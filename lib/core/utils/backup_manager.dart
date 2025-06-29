import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';

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
      final backupFileName =
          'ai_assistant_backup_$timestamp${AppConstants.backupFileExtension}';

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

      // 组装最终备份数据
      final finalBackupData = {
        'metadata': metadata.toJson(),
        'data': backupData,
      };

      // 写入备份文件
      await backupFile.writeAsString(
        jsonEncode(finalBackupData),
        encoding: utf8,
      );

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

      // 读取备份文件
      final backupContent = await backupFile.readAsString(encoding: utf8);
      final backupJson = jsonDecode(backupContent) as Map<String, dynamic>;

      // 验证备份文件格式
      if (!backupJson.containsKey('metadata') ||
          !backupJson.containsKey('data')) {
        throw BackupException.invalidBackupFile();
      }

      // 解析元数据
      final metadata = BackupMetadata.fromJson(backupJson['metadata']);
      final backupData = backupJson['data'] as Map<String, dynamic>;

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

      final backupContent = await backupFile.readAsString(encoding: utf8);
      final backupJson = jsonDecode(backupContent) as Map<String, dynamic>;

      if (!backupJson.containsKey('metadata') ||
          !backupJson.containsKey('data')) {
        return false;
      }

      final metadata = BackupMetadata.fromJson(backupJson['metadata']);
      final backupData = backupJson['data'] as Map<String, dynamic>;

      final calculatedChecksum = _calculateChecksum(backupData);
      return calculatedChecksum == metadata.checksum;
    } catch (e) {
      return false;
    }
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
    final driftDbFile = File(path.join(dbFolder.path, AppConstants.databaseName));
    if (await driftDbFile.exists()) {
      backupData['drift_database'] = base64Encode(await driftDbFile.readAsBytes());
    }

    // 备份ObjectBox数据库
    final objectboxDir = Directory(path.join(dbFolder.path, AppConstants.objectBoxDirectory));
    if (await objectboxDir.exists()) {
      // For simplicity, we'll just back up the main data file.
      // A more robust solution would be to archive the whole directory.
      final objectboxFile = File(path.join(objectboxDir.path, 'data.mdb'));
      if (await objectboxFile.exists()) {
        backupData['objectbox_database'] = base64Encode(await objectboxFile.readAsBytes());
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
      final driftDbFile = File(path.join(dbFolder.path, AppConstants.databaseName));
      await driftDbFile.writeAsBytes(base64Decode(backupData['drift_database']));
    }

    // 恢复ObjectBox数据库
    if (backupData.containsKey('objectbox_database')) {
      final dbFolder = await getApplicationDocumentsDirectory();
      final objectboxDir = Directory(path.join(dbFolder.path, AppConstants.objectBoxDirectory));
      if (!await objectboxDir.exists()) {
        await objectboxDir.create(recursive: true);
      }
      final objectboxFile = File(path.join(objectboxDir.path, 'data.mdb'));
      await objectboxFile.writeAsBytes(base64Decode(backupData['objectbox_database']));
    }
  }

  /// 获取默认备份路径
  Future<String> _getDefaultBackupPath() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return path.join(documentsDir.path, 'AI_Assistant_Backups');
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
    return path.join(documentsDir.path, 'AI_Assistant_RestorePoints');
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
                entity.path.endsWith(AppConstants.backupFileExtension),
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
    version: json['version'],
    timestamp: DateTime.parse(json['timestamp']),
    type: BackupType.values.byName(json['type']),
    checksum: json['checksum'],
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
