import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../domain/services/vector_database_interface.dart';
import '../vector_databases/local_file_vector_client.dart';
import '../vector_databases/objectbox_vector_client.dart';

/// 向量数据库迁移工具
///
/// 负责将数据从一种向量数据库迁移到另一种
class VectorDatabaseMigration {
  /// 从本地文件向量数据库迁移到 ObjectBox
  static Future<VectorMigrationResult> migrateFromLocalFileToObjectBox({
    String? localDbPath,
    bool deleteSourceAfterMigration = false,
  }) async {
    final startTime = DateTime.now();
    
    try {
      debugPrint('🔄 开始从本地文件向量数据库迁移到 ObjectBox...');

      // 初始化源数据库（本地文件）
      final sourceDbPath = localDbPath ?? await _getDefaultLocalDbPath();
      final sourceDb = LocalFileVectorClient(sourceDbPath);
      
      if (!await sourceDb.initialize()) {
        throw Exception('无法初始化源数据库: $sourceDbPath');
      }

      // 初始化目标数据库（ObjectBox）
      final targetDb = ObjectBoxVectorClient();
      if (!await targetDb.initialize()) {
        throw Exception('无法初始化目标数据库 ObjectBox');
      }

      // 获取源数据库中的所有集合
      final sourceCollections = await _getLocalFileCollections(sourceDbPath);
      
      int totalCollections = sourceCollections.length;
      int totalDocuments = 0;
      int migratedCollections = 0;
      int migratedDocuments = 0;
      final errors = <String>[];

      debugPrint('📊 发现 $totalCollections 个集合需要迁移');

      for (final collectionName in sourceCollections) {
        try {
          debugPrint('📁 迁移集合: $collectionName');

          // 获取源集合信息
          final sourceInfo = await sourceDb.getCollectionInfo(collectionName);
          if (sourceInfo == null) {
            errors.add('无法获取集合信息: $collectionName');
            continue;
          }

          // 在目标数据库中创建集合
          final createResult = await targetDb.createCollection(
            collectionName: collectionName,
            vectorDimension: sourceInfo.vectorDimension,
            description: sourceInfo.description,
            metadata: sourceInfo.metadata,
          );

          if (!createResult.success) {
            // 如果集合已存在，继续迁移文档
            if (!createResult.error!.contains('已存在')) {
              errors.add('创建集合失败: $collectionName - ${createResult.error}');
              continue;
            }
          }

          // 获取源集合中的所有文档
          final sourceDocuments = await _getLocalFileDocuments(sourceDbPath, collectionName);
          totalDocuments += sourceDocuments.length;

          if (sourceDocuments.isNotEmpty) {
            // 批量插入文档到目标数据库
            final insertResult = await targetDb.insertVectors(
              collectionName: collectionName,
              documents: sourceDocuments,
            );

            if (insertResult.success) {
              migratedDocuments += sourceDocuments.length;
              debugPrint('✅ 成功迁移 ${sourceDocuments.length} 个文档');
            } else {
              errors.add('插入文档失败: $collectionName - ${insertResult.error}');
            }
          }

          migratedCollections++;
        } catch (e) {
          errors.add('迁移集合异常: $collectionName - $e');
        }
      }

      // 关闭数据库连接
      await sourceDb.close();
      await targetDb.close();

      // 如果迁移成功且用户要求，删除源数据
      if (deleteSourceAfterMigration && errors.isEmpty) {
        try {
          final sourceDir = Directory(sourceDbPath);
          if (await sourceDir.exists()) {
            await sourceDir.delete(recursive: true);
            debugPrint('🗑️ 已删除源数据库目录: $sourceDbPath');
          }
        } catch (e) {
          errors.add('删除源数据库失败: $e');
        }
      }

      final migrationTime = DateTime.now().difference(startTime);

      debugPrint('✅ 迁移完成！');
      debugPrint('📊 迁移统计:');
      debugPrint('   - 集合: $migratedCollections/$totalCollections');
      debugPrint('   - 文档: $migratedDocuments/$totalDocuments');
      debugPrint('   - 耗时: ${migrationTime.inSeconds}秒');
      debugPrint('   - 错误: ${errors.length}个');

      return VectorMigrationResult(
        success: errors.isEmpty,
        totalCollections: totalCollections,
        migratedCollections: migratedCollections,
        totalDocuments: totalDocuments,
        migratedDocuments: migratedDocuments,
        migrationTime: migrationTime,
        errors: errors,
      );
    } catch (e) {
      final migrationTime = DateTime.now().difference(startTime);
      debugPrint('❌ 迁移失败: $e');
      
      return VectorMigrationResult(
        success: false,
        totalCollections: 0,
        migratedCollections: 0,
        totalDocuments: 0,
        migratedDocuments: 0,
        migrationTime: migrationTime,
        errors: ['迁移异常: $e'],
      );
    }
  }

  /// 获取默认本地数据库路径
  static Future<String> _getDefaultLocalDbPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return path.join(appDir.path, 'vector_database');
  }

  /// 获取本地文件数据库中的所有集合
  static Future<List<String>> _getLocalFileCollections(String dbPath) async {
    final collections = <String>[];
    
    try {
      final dbDir = Directory(dbPath);
      if (!await dbDir.exists()) return collections;

      await for (final entity in dbDir.list()) {
        if (entity is Directory) {
          final collectionName = path.basename(entity.path);
          collections.add(collectionName);
        }
      }
    } catch (e) {
      debugPrint('❌ 获取本地文件集合失败: $e');
    }

    return collections;
  }

  /// 获取本地文件数据库中指定集合的所有文档
  static Future<List<VectorDocument>> _getLocalFileDocuments(
    String dbPath,
    String collectionName,
  ) async {
    final documents = <VectorDocument>[];
    
    try {
      final collectionDir = Directory(path.join(dbPath, collectionName));
      if (!await collectionDir.exists()) return documents;

      await for (final entity in collectionDir.list()) {
        if (entity is File && entity.path.endsWith('.json')) {
          try {
            final content = await entity.readAsString();
            final data = jsonDecode(content) as Map<String, dynamic>;
            
            final document = VectorDocument(
              id: data['id'] as String,
              vector: (data['vector'] as List).cast<double>(),
              metadata: data['metadata'] as Map<String, dynamic>? ?? {},
            );
            
            documents.add(document);
          } catch (e) {
            debugPrint('⚠️ 跳过无效文档: ${entity.path} - $e');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ 获取本地文件文档失败: $e');
    }

    return documents;
  }

  /// 检查是否需要迁移
  static Future<bool> needsMigration() async {
    try {
      final localDbPath = await _getDefaultLocalDbPath();
      final localDbDir = Directory(localDbPath);
      
      // 如果本地文件数据库存在且不为空，则需要迁移
      if (await localDbDir.exists()) {
        final collections = await _getLocalFileCollections(localDbPath);
        return collections.isNotEmpty;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ 检查迁移需求失败: $e');
      return false;
    }
  }
}

/// 向量数据库迁移结果
class VectorMigrationResult {
  final bool success;
  final int totalCollections;
  final int migratedCollections;
  final int totalDocuments;
  final int migratedDocuments;
  final Duration migrationTime;
  final List<String> errors;

  const VectorMigrationResult({
    required this.success,
    required this.totalCollections,
    required this.migratedCollections,
    required this.totalDocuments,
    required this.migratedDocuments,
    required this.migrationTime,
    required this.errors,
  });

  double get collectionMigrationRate =>
      totalCollections > 0 ? migratedCollections / totalCollections : 0.0;

  double get documentMigrationRate =>
      totalDocuments > 0 ? migratedDocuments / totalDocuments : 0.0;

  @override
  String toString() {
    return 'VectorMigrationResult('
        'success: $success, '
        'collections: $migratedCollections/$totalCollections, '
        'documents: $migratedDocuments/$totalDocuments, '
        'time: ${migrationTime.inSeconds}s, '
        'errors: ${errors.length}'
        ')';
  }
}
