import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../shared/utils/debug_log.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../objectbox.g.dart'; // ObjectBox 生成的代码
import '../entities/vector_collection_entity.dart';
import '../entities/vector_document_entity.dart';

/// ObjectBox 数据库管理器
///
/// 管理 ObjectBox 数据库的初始化、连接和基本操作
class ObjectBoxManager {
  static ObjectBoxManager? _instance;
  Store? _store;

  /// 向量集合Box
  Box<VectorCollectionEntity>? _collectionBox;

  /// 向量文档Box
  Box<VectorDocumentEntity>? _documentBox;

  ObjectBoxManager._();

  /// 获取单例实例
  static ObjectBoxManager get instance {
    _instance ??= ObjectBoxManager._();
    return _instance!;
  }

  /// 初始化 ObjectBox 数据库
  Future<bool> initialize() async {
    try {
      if (_store != null) {
        debugLog(() =>'🔄 ObjectBox 数据库已经初始化');
        return true;
      }

      debugLog(() =>'🔌 初始化 ObjectBox 数据库...');

      // 获取数据库目录
      final dbDirectory = await _getDatabaseDirectory();

      // 尝试创建 Store
      try {
        _store = await openStore(directory: dbDirectory);
      } catch (e) {
        // 检查是否是模式不匹配错误
        if (e.toString().contains('does not match existing UID') || 
            e.toString().contains('failed to create store')) {
          debugLog(() =>'🔧 检测到数据库模式不匹配，尝试自动重建...');
          
          // 删除现有数据库文件并重新创建
          final dbDir = Directory(dbDirectory);
          if (await dbDir.exists()) {
            await dbDir.delete(recursive: true);
            debugLog(() =>'🗑️ 已清理不兼容的数据库文件');
          }
          
          // 重新创建数据库
          _store = await openStore(directory: dbDirectory);
          debugLog(() =>'✅ 数据库重建成功');
        } else {
          rethrow;
        }
      }

      // 初始化 Box
      _collectionBox = _store!.box<VectorCollectionEntity>();
      _documentBox = _store!.box<VectorDocumentEntity>();

      debugLog(() =>'✅ ObjectBox 数据库初始化成功');
      debugLog(() =>'📊 数据库路径: $dbDirectory');
      debugLog(() =>'📊 集合数量: ${_collectionBox!.count()}');
      debugLog(() =>'📊 文档数量: ${_documentBox!.count()}');

      return true;
    } catch (e, stackTrace) {
      debugLog(() =>'❌ ObjectBox 数据库初始化失败: $e');
      debugLog(() =>'Stack trace: $stackTrace');
      return false;
    }
  }

  /// 关闭数据库连接
  Future<void> close() async {
    try {
      if (_store != null) {
        _store!.close();
        _store = null;
        _collectionBox = null;
        _documentBox = null;
        debugLog(() =>'🔌 ObjectBox 数据库连接已关闭');
      }
    } catch (e) {
      debugLog(() =>'❌ 关闭 ObjectBox 数据库失败: $e');
    }
  }

  /// 检查数据库是否健康
  bool get isHealthy => _store != null && !_store!.isClosed();

  /// 获取向量集合Box
  Box<VectorCollectionEntity> get collectionBox {
    if (_collectionBox == null) {
      throw StateError('ObjectBox 数据库未初始化，请先调用 initialize()');
    }
    return _collectionBox!;
  }

  /// 获取向量文档Box
  Box<VectorDocumentEntity> get documentBox {
    if (_documentBox == null) {
      throw StateError('ObjectBox 数据库未初始化，请先调用 initialize()');
    }
    return _documentBox!;
  }

  /// 获取Store实例
  Store get store {
    if (_store == null) {
      throw StateError('ObjectBox 数据库未初始化，请先调用 initialize()');
    }
    return _store!;
  }

  /// 获取数据库目录
  Future<String> _getDatabaseDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDocDir.path, AppConstants.objectBoxDirectory);

    // 确保目录存在
    final dbDir = Directory(dbPath);
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }

    return dbPath;
  }

  /// 获取数据库统计信息
  Map<String, dynamic> getDatabaseStats() {
    if (!isHealthy) {
      return {'error': '数据库未初始化或已关闭'};
    }

    return {
      'collections': _collectionBox!.count(),
      'documents': _documentBox!.count(),
      'isHealthy': isHealthy,
      'databasePath': _store!.directoryPath,
    };
  }

  /// 清理数据库（仅用于测试）
  Future<void> clearDatabase() async {
    if (!isHealthy) return;

    try {
      await _documentBox!.removeAllAsync();
      await _collectionBox!.removeAllAsync();
      debugLog(() =>'🧹 ObjectBox 数据库已清理');
    } catch (e) {
      debugLog(() =>'❌ 清理 ObjectBox 数据库失败: $e');
    }
  }

  /// 重建数据库（修复Schema不匹配问题）
  Future<bool> rebuildDatabase() async {
    try {
      debugLog(() =>'🔄 开始重建ObjectBox数据库...');
      
      // 关闭现有连接
      await close();
      
      // 删除数据库文件
      final dbDirectory = await _getDatabaseDirectory();
      final dbDir = Directory(dbDirectory);
      if (await dbDir.exists()) {
        await dbDir.delete(recursive: true);
        debugLog(() =>'🗑️ 已删除旧数据库文件');
      }
      
      // 重新初始化
      final success = await initialize();
      if (success) {
        debugLog(() =>'✅ ObjectBox数据库重建成功，HNSW索引已启用');
      }
      
      return success;
    } catch (e) {
      debugLog(() =>'❌ 重建数据库失败: $e');
      return false;
    }
  }
}
