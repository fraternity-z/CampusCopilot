import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:talker_flutter/talker_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'app_database.dart';

/// 数据库管理工具类
/// 提供数据库备份、恢复、重置等维护功能
class DatabaseManager {
  final AppDatabase _database;
  final Talker _logger;

  DatabaseManager(this._database) : _logger = TalkerFlutter.init();

  /// 获取数据库文件路径
  Future<String> _getDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return p.join(dbFolder.path, AppConstants.databaseName);
  }

  /// 获取备份目录路径
  Future<String> _getBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(appDir.path, 'database_backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  /// 备份数据库
  Future<String> backupDatabase({String? customName}) async {
    try {
      final dbPath = await _getDatabasePath();
      final backupDir = await _getBackupDirectory();

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final backupName = customName ?? 'backup_$timestamp${AppConstants.backupFileExtension}';
      final backupPath = p.join(backupDir, backupName);

      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        throw Exception('数据库文件不存在');
      }

      // 读取数据库文件
      final dbData = await dbFile.readAsBytes();

      // 创建压缩文件
      final archive = Archive();
      archive.addFile(ArchiveFile('database.db', dbData.length, dbData));

      // 压缩并保存
      final zipData = ZipEncoder().encode(archive);
      await File(backupPath).writeAsBytes(zipData);

      _logger.info('数据库备份成功: $backupPath');
      return backupPath;
    } catch (e) {
      _logger.error('数据库备份失败', e);
      rethrow;
    }
  }

  /// 恢复数据库
  Future<void> restoreDatabase(String backupPath) async {
    try {
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('备份文件不存在: $backupPath');
      }

      final dbPath = await _getDatabasePath();

      // 读取并解压备份文件
      final zipData = await backupFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipData);

      final dbFile = archive.findFile('database.db');
      if (dbFile == null) {
        throw Exception('备份文件中没有找到数据库文件');
      }

      // 关闭当前数据库连接
      await _database.close();

      // 写入数据库文件
      await File(dbPath).writeAsBytes(dbFile.content as List<int>);

      _logger.info('数据库恢复成功: $backupPath');
    } catch (e) {
      _logger.error('数据库恢复失败', e);
      rethrow;
    }
  }

  /// 重置数据库
  Future<void> resetDatabase() async {
    try {
      // 先备份当前数据库
      final backupPath = await backupDatabase(customName: 'before_reset_${DateTime.now().millisecondsSinceEpoch}${AppConstants.backupFileExtension}');
      _logger.info('重置前备份: $backupPath');

      // 重置数据库
      await _database.resetDatabase();

      _logger.info('数据库重置成功');
    } catch (e) {
      _logger.error('数据库重置失败', e);
      rethrow;
    }
  }

  /// 获取数据库信息
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);

      final stats = await _database.getDashboardStatsBatch();

      return {
        'databasePath': dbPath,
        'databaseSize': await dbFile.exists() ? await dbFile.length() : 0,
        'schemaVersion': _database.schemaVersion,
        'totalSessions': stats['sessions'],
        'totalMessages': stats['messages'],
        'totalPersonas': stats['personas'],
        'totalDocuments': stats['documents'],
        'lastModified': await dbFile.exists() ? await dbFile.lastModified() : null,
      };
    } catch (e) {
      _logger.error('获取数据库信息失败', e);
      return {};
    }
  }

  /// 清理旧备份文件
  Future<void> cleanupOldBackups({int keepCount = 10}) async {
    try {
      final backupDir = await _getBackupDirectory();
      final backupDirFile = Directory(backupDir);

      if (!await backupDirFile.exists()) {
        return;
      }

      final files = await backupDirFile.list().toList();
      final backupFiles = files
          .whereType<File>()
          .where((file) => file.path.endsWith(AppConstants.backupFileExtension))
          .toList();

      // 按修改时间排序
      backupFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // 删除多余的备份
      if (backupFiles.length > keepCount) {
        for (var i = keepCount; i < backupFiles.length; i++) {
          await backupFiles[i].delete();
          _logger.info('删除旧备份: ${backupFiles[i].path}');
        }
      }
    } catch (e) {
      _logger.error('清理旧备份失败', e);
    }
  }

  /// 导出数据库为SQL
  Future<String> exportToSql() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('-- Database Export');
      buffer.writeln('-- Generated at: ${DateTime.now().toIso8601String()}');
      buffer.writeln();

      // 导出设置
      final settings = await _database.select(_database.generalSettingsTable).get();
      for (final setting in settings) {
        buffer.writeln("INSERT OR REPLACE INTO general_settings_table (key, value, updatedAt) VALUES ('${setting.key.replaceAll("'", "''")}', '${setting.value.replaceAll("'", "''")}', '${setting.updatedAt.toIso8601String()}');");
      }

      // 导出LLM配置
      final llmConfigs = await _database.select(_database.llmConfigsTable).get();
      for (final config in llmConfigs) {
        buffer.writeln("INSERT OR REPLACE INTO llm_configs_table (id, name, provider, apiKey, defaultModel, defaultEmbeddingModel, createdAt, updatedAt, isEnabled, isCustomProvider) VALUES ('${config.id}', '${config.name.replaceAll("'", "''")}', '${config.provider}', '${config.apiKey}', '${config.defaultModel}', '${config.defaultEmbeddingModel}', '${config.createdAt.toIso8601String()}', '${config.updatedAt.toIso8601String()}', ${config.isEnabled ? 1 : 0}, ${config.isCustomProvider ? 1 : 0});");
      }

      // 导出智能体
      final personas = await _database.select(_database.personasTable).get();
      for (final persona in personas) {
        buffer.writeln("INSERT OR REPLACE INTO personas_table (id, name, description, systemPrompt, apiConfigId, createdAt, updatedAt, category, isDefault, usageCount, lastUsedAt, isEnabled) VALUES ('${persona.id}', '${persona.name.replaceAll("'", "''")}', '${persona.description}', '${persona.systemPrompt.replaceAll("'", "''")}', '${persona.apiConfigId}', '${persona.createdAt.toIso8601String()}', '${persona.updatedAt.toIso8601String()}', '${persona.category}', ${persona.isDefault ? 1 : 0}, ${persona.usageCount}, '${persona.lastUsedAt?.toIso8601String() ?? ''}', ${persona.isEnabled ? 1 : 0});");
      }

      return buffer.toString();
    } catch (e) {
      _logger.error('导出SQL失败', e);
      rethrow;
    }
  }

  /// 验证数据库完整性
  Future<bool> validateDatabase() async {
    try {
      // 检查基本表是否存在
      final tables = [
        'llm_configs_table',
        'personas_table',
        'chat_sessions_table',
        'chat_messages_table',
        'general_settings_table',
      ];

      for (final table in tables) {
        final result = await _database.customSelect('SELECT name FROM sqlite_master WHERE type="table" AND name="$table"').get();
        if (result.isEmpty) {
          _logger.warning('表不存在: $table');
          return false;
        }
      }

      // 检查默认数据
      final defaultPersona = await _database.getDefaultPersona();
      if (defaultPersona == null) {
        _logger.warning('默认智能体不存在');
        return false;
      }

      _logger.info('数据库完整性检查通过');
      return true;
    } catch (e) {
      _logger.error('数据库完整性检查失败', e);
      return false;
    }
  }
}
