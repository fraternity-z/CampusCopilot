import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../domain/services/vector_database_interface.dart';
import '../vector_databases/local_file_vector_client.dart';
import '../vector_databases/objectbox_vector_client.dart';

/// 向量数据库类型枚举
enum VectorDatabaseType {
  /// 本地文件存储
  localFile,

  /// ObjectBox 数据库
  objectBox,
}

/// 向量数据库工厂
///
/// 负责根据配置创建相应的向量数据库实例
class VectorDatabaseFactory {
  // 实例缓存，避免重复创建
  static final Map<VectorDatabaseType, VectorDatabaseInterface> _instanceCache =
      {};

  /// 创建向量数据库实例
  static Future<VectorDatabaseInterface> createDatabase({
    VectorDatabaseType type = VectorDatabaseType.objectBox,
    Map<String, dynamic>? config,
  }) async {
    // 优先返回缓存实例
    final cached = _instanceCache[type];
    if (cached != null) {
      debugPrint('🔄 返回缓存的向量数据库实例: $type');
      return cached;
    }

    late final VectorDatabaseInterface database;

    switch (type) {
      case VectorDatabaseType.localFile:
        database = await _createLocalFileDatabase(config);
        break;
      case VectorDatabaseType.objectBox:
        database = _createObjectBoxDatabase(config);
        break;
    }

    // 缓存实例
    _instanceCache[type] = database;
    debugPrint('✅ 创建新的向量数据库实例: $type');

    return database;
  }

  /// 获取默认向量数据库实例
  static Future<VectorDatabaseInterface> getDefaultDatabase() async {
    return createDatabase(type: VectorDatabaseType.objectBox);
  }

  /// 创建本地文件向量数据库
  static Future<LocalFileVectorClient> _createLocalFileDatabase(
    Map<String, dynamic>? config,
  ) async {
    String dbPath;

    if (config != null && config.containsKey('path')) {
      dbPath = config['path'] as String;
    } else {
      // 使用默认路径
      final appDir = await getApplicationDocumentsDirectory();
      dbPath = path.join(appDir.path, 'vector_database');
    }

    debugPrint('📁 创建本地文件向量数据库: $dbPath');
    return LocalFileVectorClient(dbPath);
  }

  /// 创建 ObjectBox 向量数据库
  static ObjectBoxVectorClient _createObjectBoxDatabase(
    Map<String, dynamic>? config,
  ) {
    debugPrint('📦 创建 ObjectBox 向量数据库');
    return ObjectBoxVectorClient();
  }

  /// 清理缓存
  static Future<void> clearCache() async {
    for (final database in _instanceCache.values) {
      try {
        await database.close();
      } catch (e) {
        debugPrint('⚠️ 关闭向量数据库失败: $e');
      }
    }
    _instanceCache.clear();
    debugPrint('🧹 向量数据库缓存已清理');
  }

  /// 获取支持的数据库类型
  static List<VectorDatabaseType> getSupportedTypes() {
    return VectorDatabaseType.values;
  }

  /// 获取数据库类型的显示名称
  static String getDisplayName(VectorDatabaseType type) {
    switch (type) {
      case VectorDatabaseType.localFile:
        return '本地文件存储';
      case VectorDatabaseType.objectBox:
        return 'ObjectBox 数据库';
    }
  }

  /// 获取数据库类型的描述
  static String getDescription(VectorDatabaseType type) {
    switch (type) {
      case VectorDatabaseType.localFile:
        return '使用本地文件系统存储向量数据，适合小规模数据';
      case VectorDatabaseType.objectBox:
        return '使用 ObjectBox 高性能数据库，支持 HNSW 索引，适合大规模向量搜索';
    }
  }

  /// 检查数据库类型是否支持特定功能
  static bool supportsFeature(VectorDatabaseType type, String feature) {
    switch (feature) {
      case 'hnsw_index':
        return type == VectorDatabaseType.objectBox;
      case 'backup':
        return true; // 所有类型都支持备份
      case 'batch_operations':
        return true; // 所有类型都支持批量操作
      case 'real_time_search':
        return type == VectorDatabaseType.objectBox;
      default:
        return false;
    }
  }
}
