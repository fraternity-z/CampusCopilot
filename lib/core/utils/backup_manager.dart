import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:archive/archive.dart';

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../../data/local/app_database.dart';

/// 数据备份管理器
///
/// 负责应用数据的备份和恢复，支持：
/// - 完整数据备份（数据库 + 配置）
/// - 增量备份
/// - 自动备份
/// - 备份文件管理
/// - 数据完整性验证
class BackupManager {
  static const String _backupMetadataKey = 'backup_metadata';

  // ============== 选择性备份（JSON 单文件，排除知识库） ==============
  /// 导出仅包含核心数据（AI提供商配置 + 聊天记录 + 智能体，可选设置/自定义模型）。
  /// 输出为单一 JSON 文件（扩展名 .aibackup），更便于跨平台手动管理。
  Future<String> createSelectiveBackup({
    required AppDatabase db,
    String? customPath,
    bool includePersonas = true,
    bool includeSettings = false,
    bool includeCustomModels = true,
  }) async {
    try {
      final timestamp = DateFormat(AppConstants.backupDateFormat)
          .format(DateTime.now());
      final backupFileName = 'anywherechat_core_backup_'
          '$timestamp${AppConstants.backupFileExtension}';

      final outDir = customPath ?? await _getDefaultBackupPath();
      final outFile = File(path.join(outDir, backupFileName));
      await outFile.parent.create(recursive: true);

      final data = await _collectCoreData(
        db,
        includePersonas: includePersonas,
        includeSettings: includeSettings,
        includeCustomModels: includeCustomModels,
      );

      final metadata = <String, dynamic>{
        'version': AppConstants.appVersion,
        'schemaVersion': db.schemaVersion,
        'backupScope': 'core_only',
        'type': BackupType.full.name,
        'timestamp': DateTime.now().toIso8601String(),
        'counts': {
          'llm_configs': (data['llm_configs'] as List).length,
          'custom_models': (data['custom_models'] as List).length,
          'personas': (data['personas'] as List).length,
          'persona_groups': (data['persona_groups'] as List).length,
          'chat_sessions': (data['chat_sessions'] as List).length,
          'chat_messages': (data['chat_messages'] as List).length,
          'settings_keys': (data['settings'] as Map).length,
        },
      };

      final checksum = _calculateChecksum(data);
      metadata['checksum'] = checksum;

      final envelope = {'metadata': metadata, 'data': data};
      await outFile.writeAsString(jsonEncode(envelope), encoding: utf8);

      await _updateBackupHistory(
        outFile.path,
        BackupMetadata(
          version: AppConstants.appVersion,
          timestamp: DateTime.now(),
          type: BackupType.full,
          checksum: checksum,
        ),
      );

      await _cleanupOldBackups(outDir);
      return outFile.path;
    } catch (_) {
      throw BackupException.createFailed();
    }
  }

  /// 从 JSON 单文件恢复核心数据；不会触碰知识库相关表。
  Future<void> restoreSelectiveBackup(
    AppDatabase db,
    String backupFilePath, {
    RestoreMode mode = RestoreMode.overwrite,
  }) async {
    try {
      final f = File(backupFilePath);
      if (!await f.exists()) throw BackupException.invalidBackupFile();

      final content = await f.readAsString(encoding: utf8);
      final obj = jsonDecode(content) as Map<String, dynamic>;
      if (!obj.containsKey('metadata') || !obj.containsKey('data')) {
        throw BackupException.invalidBackupFile();
      }

      final metadata = BackupMetadata.fromJson(
        obj['metadata'] as Map<String, dynamic>,
      );
      final data = obj['data'] as Map<String, dynamic>;

      final calc = _calculateChecksum(data);
      if (calc != metadata.checksum) {
        throw BackupException.corruptedBackup();
      }

      // 创建恢复点
      await _createRestorePoint();

      // 恢复核心数据
      await _restoreCoreData(db, data, mode: mode);
    } catch (e) {
      if (e is BackupException) rethrow;
      throw BackupException.restoreFailed();
    }
  }

  /// 创建完整备份
  ///
  /// 包含：
  /// - Drift数据库文件
  /// - ObjectBox数据库
  /// - SharedPreferences配置
  /// - 用户上传的文档
  Future<String> createFullBackup({String? customPath}) async {
    try {
      final timestamp = DateFormat(
        AppConstants.backupDateFormat,
      ).format(DateTime.now());
      final backupFileName = 'campus_copilot_backup_$timestamp.zip';

      // 确定备份路径
      final backupPath = customPath ?? await _getDefaultBackupPath();
      final backupFile = File(path.join(backupPath, backupFileName));

      // 创建备份目录
      await backupFile.parent.create(recursive: true);

      // 收集所有需要备份的数据
      final backupData = await _collectBackupData();

      // 创建备份元数据
      final metadata = BackupMetadata(
        version: AppConstants.appVersion,
        timestamp: DateTime.now(),
        type: BackupType.full,
        checksum: _calculateChecksum(backupData),
      );

      // 创建ZIP压缩包
      await _createZipBackup(backupFile, metadata, backupData);

      // 更新备份记录
      await _updateBackupHistory(backupFile.path, metadata);

      // 清理旧备份文件
      await _cleanupOldBackups(backupPath);

      return backupFile.path;
    } catch (e) {
      throw BackupException.createFailed();
    }
  }

  /// 恢复备份
  Future<void> restoreBackup(String backupFilePath) async {
    try {
      final backupFile = File(backupFilePath);

      if (!await backupFile.exists()) {
        throw BackupException.invalidBackupFile();
      }

      // 检查文件格式（ZIP 或 旧的 JSON 格式）
      final isZipFile = backupFilePath.endsWith('.zip');

      BackupMetadata metadata;
      Map<String, dynamic> backupData;

      if (isZipFile) {
        // 处理ZIP格式的备份文件
        final result = await _extractZipBackup(backupFile);
        metadata = result['metadata'] as BackupMetadata;
        backupData = result['data'] as Map<String, dynamic>;
      } else {
        // 处理旧的JSON格式的备份文件（向后兼容）
        final backupContent = await backupFile.readAsString(encoding: utf8);
        final backupJson = jsonDecode(backupContent) as Map<String, dynamic>;

        // 验证备份文件格式
        if (!backupJson.containsKey('metadata') ||
            !backupJson.containsKey('data')) {
          throw BackupException.invalidBackupFile();
        }

        metadata = BackupMetadata.fromJson(backupJson['metadata']);
        backupData = backupJson['data'] as Map<String, dynamic>;
      }

      // 验证数据完整性
      final calculatedChecksum = _calculateChecksum(backupData);
      if (calculatedChecksum != metadata.checksum) {
        throw BackupException.corruptedBackup();
      }

      // 创建恢复点（当前数据的备份）
      await _createRestorePoint();

      // 恢复数据
      await _restoreData(backupData);
    } catch (e) {
      if (e is BackupException) {
        rethrow;
      }
      throw BackupException.restoreFailed();
    }
  }

  /// 获取备份历史
  Future<List<BackupInfo>> getBackupHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_backupMetadataKey);

      if (historyJson == null) {
        return [];
      }

      final historyList = jsonDecode(historyJson) as List;
      return historyList.map((item) => BackupInfo.fromJson(item)).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      return [];
    }
  }

  /// 删除备份文件
  Future<void> deleteBackup(String backupFilePath) async {
    try {
      final backupFile = File(backupFilePath);
      if (await backupFile.exists()) {
        await backupFile.delete();
      }

      // 从历史记录中移除
      await _removeFromBackupHistory(backupFilePath);
    } catch (e) {
      // 静默处理删除错误
    }
  }

  /// 验证备份文件
  Future<bool> validateBackup(String backupFilePath) async {
    try {
      final backupFile = File(backupFilePath);

      if (!await backupFile.exists()) {
        return false;
      }

      // 检查文件格式（ZIP 或 旧的 JSON 格式）
      final isZipFile = backupFilePath.endsWith('.zip');

      BackupMetadata metadata;
      Map<String, dynamic> backupData;

      if (isZipFile) {
        // 处理ZIP格式的备份文件
        final result = await _extractZipBackup(backupFile);
        metadata = result['metadata'] as BackupMetadata;
        backupData = result['data'] as Map<String, dynamic>;
      } else {
        // 处理旧的JSON格式的备份文件（向后兼容）
        final backupContent = await backupFile.readAsString(encoding: utf8);
        final backupJson = jsonDecode(backupContent) as Map<String, dynamic>;

        if (!backupJson.containsKey('metadata') ||
            !backupJson.containsKey('data')) {
          return false;
        }

        metadata = BackupMetadata.fromJson(backupJson['metadata']);
        backupData = backupJson['data'] as Map<String, dynamic>;
      }

      final calculatedChecksum = _calculateChecksum(backupData);
      return calculatedChecksum == metadata.checksum;
    } catch (e) {
      return false;
    }
  }

  /// 创建ZIP压缩包
  Future<void> _createZipBackup(
    File backupFile,
    BackupMetadata metadata,
    Map<String, dynamic> backupData,
  ) async {
    final archive = Archive();

    // 添加元数据文件
    final metadataJson = jsonEncode(metadata.toJson());
    final metadataBytes = utf8.encode(metadataJson);
    archive.addFile(
      ArchiveFile('metadata.json', metadataBytes.length, metadataBytes),
    );

    // 添加配置数据文件
    if (backupData.containsKey('preferences')) {
      final preferencesJson = jsonEncode(backupData['preferences']);
      final preferencesBytes = utf8.encode(preferencesJson);
      archive.addFile(
        ArchiveFile(
          'preferences.json',
          preferencesBytes.length,
          preferencesBytes,
        ),
      );
    }

    // 添加Drift数据库文件
    if (backupData.containsKey('drift_database')) {
      final driftDbBytes = base64Decode(backupData['drift_database']);
      archive.addFile(
        ArchiveFile('drift_database.db', driftDbBytes.length, driftDbBytes),
      );
    }

    // 添加ObjectBox数据库文件
    if (backupData.containsKey('objectbox_database')) {
      final objectboxDbBytes = base64Decode(backupData['objectbox_database']);
      archive.addFile(
        ArchiveFile(
          'objectbox_database.mdb',
          objectboxDbBytes.length,
          objectboxDbBytes,
        ),
      );
    }

    // 压缩并写入文件
    final encoder = ZipEncoder();
    final zipBytes = encoder.encode(archive);
    await backupFile.writeAsBytes(zipBytes);
  }

  /// 解压ZIP备份文件
  Future<Map<String, dynamic>> _extractZipBackup(File backupFile) async {
    final bytes = await backupFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    BackupMetadata? metadata;
    final backupData = <String, dynamic>{};

    for (final file in archive) {
      if (file.isFile) {
        final fileName = file.name;
        final fileBytes = file.content as List<int>;

        switch (fileName) {
          case 'metadata.json':
            final metadataJson = utf8.decode(fileBytes);
            metadata = BackupMetadata.fromJson(jsonDecode(metadataJson));
            break;
          case 'preferences.json':
            final preferencesJson = utf8.decode(fileBytes);
            backupData['preferences'] = jsonDecode(preferencesJson);
            break;
          case 'drift_database.db':
            backupData['drift_database'] = base64Encode(fileBytes);
            break;
          case 'objectbox_database.mdb':
            backupData['objectbox_database'] = base64Encode(fileBytes);
            break;
        }
      }
    }

    if (metadata == null) {
      throw BackupException.invalidBackupFile();
    }

    return {'metadata': metadata, 'data': backupData};
  }

  /// 收集核心数据（仅白名单表），转换为 JSON 可序列化结构
  Future<Map<String, dynamic>> _collectCoreData(
    AppDatabase db, {
    required bool includePersonas,
    required bool includeSettings,
    required bool includeCustomModels,
  }) async {
    final result = <String, dynamic>{
      'llm_configs': <Map<String, dynamic>>[],
      'custom_models': <Map<String, dynamic>>[],
      'personas': <Map<String, dynamic>>[],
      'persona_groups': <Map<String, dynamic>>[],
      'chat_sessions': <Map<String, dynamic>>[],
      'chat_messages': <Map<String, dynamic>>[],
      'settings': <String, dynamic>{},
    };

    // LLM 配置
    final llmConfigs = await db.getAllLlmConfigs();
    result['llm_configs'] = llmConfigs.map((e) => e.toJson()).toList();

    // 自定义模型（可选）
    if (includeCustomModels) {
      final customModels = await db.getAllCustomModels();
      result['custom_models'] = customModels.map((e) => e.toJson()).toList();
    }

    // 智能体及分组（可选，建议包含，避免会话引用缺失）
    if (includePersonas) {
      final personas = await db.getAllPersonas();
      result['personas'] = personas.map((e) => e.toJson()).toList();

      final groups = await db.getAllPersonaGroups();
      result['persona_groups'] = groups.map((e) => e.toJson()).toList();
    }

    // 会话与消息
    final sessions = await db.getAllChatSessions();
    result['chat_sessions'] = sessions.map((e) => e.toJson()).toList();

    final allMessages = <Map<String, dynamic>>[];
    for (final s in sessions) {
      final msgs = await db.getMessagesBySession(s.id);
      allMessages.addAll(msgs.map((e) => e.toJson()));
    }
    result['chat_messages'] = allMessages;

    // 设置（可选，默认不导出）
    if (includeSettings) {
      final settings = await db.getAllSettings();
      final whitelist = <String>{
        AppConstants.keyThemeMode,
        AppConstants.keyLastSelectedPersona,
        AppConstants.keyBackupPath,
        AppConstants.keyAutoBackup,
      };
      result['settings'] = {
        for (final e in settings.entries)
          if (whitelist.contains(e.key)) e.key: e.value,
      };
    }

    return result;
  }

  /// 收集备份数据
  Future<Map<String, dynamic>> _collectBackupData() async {
    final backupData = <String, dynamic>{};

    // 备份SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    backupData['preferences'] = prefs
        .getKeys()
        .where((key) => !key.startsWith('flutter.'))
        .fold<Map<String, dynamic>>({}, (map, key) {
          final value = prefs.get(key);
          if (value != null) {
            map[key] = value;
          }
          return map;
        });

    // 备份Drift数据库
    final dbFolder = await getApplicationDocumentsDirectory();
    final driftDbFile = File(
      path.join(dbFolder.path, AppConstants.databaseName),
    );
    if (await driftDbFile.exists()) {
      backupData['drift_database'] = base64Encode(
        await driftDbFile.readAsBytes(),
      );
    }

    // 备份ObjectBox数据库
    final objectboxDir = Directory(
      path.join(dbFolder.path, AppConstants.objectBoxDirectory),
    );
    if (await objectboxDir.exists()) {
      // For simplicity, we'll just back up the main data file.
      // A more robust solution would be to archive the whole directory.
      final objectboxFile = File(path.join(objectboxDir.path, 'data.mdb'));
      if (await objectboxFile.exists()) {
        backupData['objectbox_database'] = base64Encode(
          await objectboxFile.readAsBytes(),
        );
      }
    }

    return backupData;
  }

  /// 恢复数据
  Future<void> _restoreData(Map<String, dynamic> backupData) async {
    // 恢复SharedPreferences
    if (backupData.containsKey('preferences')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final prefsData = backupData['preferences'] as Map<String, dynamic>;
      for (final entry in prefsData.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }
    }

    // 恢复Drift数据库
    if (backupData.containsKey('drift_database')) {
      final dbFolder = await getApplicationDocumentsDirectory();
      final driftDbFile = File(
        path.join(dbFolder.path, AppConstants.databaseName),
      );
      await driftDbFile.writeAsBytes(
        base64Decode(backupData['drift_database']),
      );
    }

    // 恢复ObjectBox数据库
    if (backupData.containsKey('objectbox_database')) {
      final dbFolder = await getApplicationDocumentsDirectory();
      final objectboxDir = Directory(
        path.join(dbFolder.path, AppConstants.objectBoxDirectory),
      );
      if (!await objectboxDir.exists()) {
        await objectboxDir.create(recursive: true);
      }
      final objectboxFile = File(path.join(objectboxDir.path, 'data.mdb'));
      await objectboxFile.writeAsBytes(
        base64Decode(backupData['objectbox_database']),
      );
    }
  }

  /// 恢复核心数据（不会触碰知识库相关表）
  Future<void> _restoreCoreData(
    AppDatabase db,
    Map<String, dynamic> data, {
    RestoreMode mode = RestoreMode.overwrite,
  }) async {
    List<Map<String, dynamic>> listOf(String key) =>
        (data[key] as List?)?.cast<Map<String, dynamic>>() ?? const [];

    final llmConfigs = listOf('llm_configs')
        .map((e) => LlmConfigsTableData.fromJson(e))
        .toList();
    final customModels = listOf('custom_models')
        .map((e) => CustomModelsTableData.fromJson(e))
        .toList();
    final personas = listOf('personas')
        .map((e) => PersonasTableData.fromJson(e))
        .toList();
    final personaGroups = listOf('persona_groups')
        .map((e) => PersonaGroupsTableData.fromJson(e))
        .toList();
    final sessions = listOf('chat_sessions')
        .map((e) => ChatSessionsTableData.fromJson(e))
        .toList();
    final messages = listOf('chat_messages')
        .map((e) => ChatMessagesTableData.fromJson(e))
        .toList();
    final settingsMap =
        (data['settings'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    await db.transaction(() async {
      if (mode == RestoreMode.overwrite) {
        // 清空相关表（知识库保持不变）
        await db.customStatement('DELETE FROM chat_messages_table');
        await db.customStatement('DELETE FROM chat_sessions_table');
        await db.customStatement('DELETE FROM personas_table');
        await db.customStatement('DELETE FROM persona_groups_table');
        await db.customStatement('DELETE FROM custom_models_table');
        await db.customStatement('DELETE FROM llm_configs_table');
      }

      if (llmConfigs.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.llmConfigsTable, llmConfigs.map((e) => e.toCompanion(true)).toList()));
      }
      if (customModels.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.customModelsTable, customModels.map((e) => e.toCompanion(true)).toList()));
      }
      if (personaGroups.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.personaGroupsTable,
            personaGroups.map((e) => e.toCompanion(true)).toList()));
      }
      if (personas.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.personasTable, personas.map((e) => e.toCompanion(true)).toList()));
      }
      if (sessions.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.chatSessionsTable, sessions.map((e) => e.toCompanion(true)).toList()));
      }
      if (messages.isNotEmpty) {
        await db.batch((b) => b.insertAllOnConflictUpdate(
            db.chatMessagesTable, messages.map((e) => e.toCompanion(true)).toList()));
      }

      // 设置覆盖写入（仅导出的键）
      if (settingsMap.isNotEmpty) {
        for (final entry in settingsMap.entries) {
          await db.setSetting(entry.key, entry.value.toString());
        }
      }
    });
  }

  /// 获取默认备份路径
  Future<String> _getDefaultBackupPath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return path.join(documentsDir.path, 'campus_copilot_Backups');
  }

  /// 计算数据校验和
  String _calculateChecksum(Map<String, dynamic> data) {
    final dataString = jsonEncode(data);
    final bytes = utf8.encode(dataString);
    return bytes.fold<int>(0, (sum, byte) => sum + byte).toString();
  }

  /// 创建恢复点
  Future<void> _createRestorePoint() async {
    await createFullBackup(customPath: await _getRestorePointPath());
  }

  /// 获取恢复点路径
  Future<String> _getRestorePointPath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return path.join(documentsDir.path, 'campus_copilot_RestorePoints');
  }

  /// 更新备份历史
  Future<void> _updateBackupHistory(
    String filePath,
    BackupMetadata metadata,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBackupHistory();

    final backupInfo = BackupInfo(
      filePath: filePath,
      timestamp: metadata.timestamp,
      type: metadata.type,
      size: await File(filePath).length(),
    );

    history.add(backupInfo);

    // 保留最近的备份记录
    if (history.length > AppConstants.maxBackupFiles) {
      history.removeRange(0, history.length - AppConstants.maxBackupFiles);
    }

    await prefs.setString(
      _backupMetadataKey,
      jsonEncode(history.map((info) => info.toJson()).toList()),
    );
  }

  /// 从备份历史中移除
  Future<void> _removeFromBackupHistory(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBackupHistory();

    history.removeWhere((info) => info.filePath == filePath);

    await prefs.setString(
      _backupMetadataKey,
      jsonEncode(history.map((info) => info.toJson()).toList()),
    );
  }

  /// 清理旧备份文件
  Future<void> _cleanupOldBackups(String backupPath) async {
    try {
      final backupDir = Directory(backupPath);
      if (!await backupDir.exists()) return;

      final backupFiles = await backupDir
          .list()
          .where(
            (entity) =>
                entity is File &&
                (entity.path.endsWith('.zip') ||
                    entity.path.endsWith(AppConstants.backupFileExtension)),
          )
          .cast<File>()
          .toList();

      if (backupFiles.length > AppConstants.maxBackupFiles) {
        // 按修改时间排序
        backupFiles.sort(
          (a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()),
        );

        // 删除最旧的文件
        final filesToDelete = backupFiles.take(
          backupFiles.length - AppConstants.maxBackupFiles,
        );

        for (final file in filesToDelete) {
          await file.delete();
          await _removeFromBackupHistory(file.path);
        }
      }
    } catch (e) {
      // 静默处理清理错误
    }
  }
}

/// 备份类型
enum BackupType { full, incremental, restorePoint }

/// 恢复模式
enum RestoreMode { overwrite, merge }

/// 备份元数据
class BackupMetadata {
  final String version;
  final DateTime timestamp;
  final BackupType type;
  final String checksum;

  BackupMetadata({
    required this.version,
    required this.timestamp,
    required this.type,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'checksum': checksum,
  };

  factory BackupMetadata.fromJson(Map<String, dynamic> json) => BackupMetadata(
    version: (json['version'] ?? AppConstants.appVersion) as String,
    timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    // 兼容早期未写入 type 的 JSON 备份
    type: json['type'] != null
        ? BackupType.values.byName(json['type'])
        : BackupType.full,
    checksum: (json['checksum'] ?? '') as String,
  );
}

/// 备份信息
class BackupInfo {
  final String filePath;
  final DateTime timestamp;
  final BackupType type;
  final int size;

  BackupInfo({
    required this.filePath,
    required this.timestamp,
    required this.type,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
    'filePath': filePath,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
    'size': size,
  };

  factory BackupInfo.fromJson(Map<String, dynamic> json) => BackupInfo(
    filePath: json['filePath'],
    timestamp: DateTime.parse(json['timestamp']),
    type: BackupType.values.byName(json['type']),
    size: json['size'],
  );
}
