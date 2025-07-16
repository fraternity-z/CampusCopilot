import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import '../../../../objectbox.g.dart'; // ObjectBox 生成的代码
import '../../domain/services/vector_database_interface.dart';
import '../entities/vector_collection_entity.dart';
import '../entities/vector_document_entity.dart';
import '../objectbox/objectbox_manager.dart';

/// ObjectBox 向量数据库客户端实现
///
/// 使用 ObjectBox 作为后端存储，支持高性能向量搜索和HNSW索引
class ObjectBoxVectorClient implements VectorDatabaseInterface {
  final ObjectBoxManager _objectBoxManager = ObjectBoxManager.instance;
  bool _isInitialized = false;

  @override
  Future<bool> initialize() async {
    try {
      debugPrint('🔌 初始化 ObjectBox 向量数据库客户端...');

      final success = await _objectBoxManager.initialize();
      if (success) {
        _isInitialized = true;
        debugPrint('✅ ObjectBox 向量数据库客户端初始化成功');

        // 打印数据库统计信息
        final stats = _objectBoxManager.getDatabaseStats();
        debugPrint('📊 数据库统计: $stats');
      }

      return success;
    } catch (e) {
      debugPrint('❌ ObjectBox 向量数据库客户端初始化失败: $e');
      return false;
    }
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      await _objectBoxManager.close();
      _isInitialized = false;
      debugPrint('🔌 ObjectBox 向量数据库客户端连接已关闭');
    }
  }

  @override
  Future<bool> isHealthy() async {
    return _isInitialized && _objectBoxManager.isHealthy;
  }

  @override
  Future<VectorCollectionResult> createCollection({
    required String collectionName,
    required int vectorDimension,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint(
        '📁 创建 ObjectBox 向量集合: $collectionName (维度: $vectorDimension)',
      );

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      final collectionBox = _objectBoxManager.collectionBox;

      // 检查集合是否已存在
      final existingQuery = collectionBox
          .query(VectorCollectionEntity_.collectionName.equals(collectionName))
          .build();
      final existing = existingQuery.findFirst();
      existingQuery.close();

      if (existing != null) {
        return VectorCollectionResult(
          success: false,
          error: '集合已存在: $collectionName',
        );
      }

      // 创建新集合
      final collection = VectorCollectionEntity(
        collectionName: collectionName,
        vectorDimension: vectorDimension,
        description: description,
        metadata: metadata != null ? jsonEncode(metadata) : null,
      );

      final id = collectionBox.put(collection);
      debugPrint('✅ 向量集合创建成功: $collectionName (ID: $id)');

      return VectorCollectionResult(
        success: true,
        collectionName: collectionName,
        metadata: {
          'id': id,
          'vectorDimension': vectorDimension,
          'description': description,
          ...?metadata,
        },
      );
    } catch (e) {
      final error = '创建向量集合异常: $e';
      debugPrint('❌ $error');
      return VectorCollectionResult(success: false, error: error);
    }
  }

  @override
  Future<VectorOperationResult> deleteCollection(String collectionName) async {
    try {
      debugPrint('🗑️ 删除 ObjectBox 向量集合: $collectionName');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      final collectionBox = _objectBoxManager.collectionBox;
      final documentBox = _objectBoxManager.documentBox;

      // 查找集合
      final collectionQuery = collectionBox
          .query(VectorCollectionEntity_.collectionName.equals(collectionName))
          .build();
      final collection = collectionQuery.findFirst();
      collectionQuery.close();

      if (collection == null) {
        return VectorOperationResult(
          success: false,
          error: '集合不存在: $collectionName',
        );
      }

      // 删除集合中的所有文档
      final documentQuery = documentBox
          .query(VectorDocumentEntity_.collectionName.equals(collectionName))
          .build();
      final documents = documentQuery.find();
      documentQuery.close();

      if (documents.isNotEmpty) {
        final documentIds = documents.map((doc) => doc.id).toList();
        documentBox.removeMany(documentIds);
        debugPrint('🗑️ 删除了 ${documents.length} 个向量文档');
      }

      // 删除集合
      collectionBox.remove(collection.id);

      debugPrint('✅ 向量集合删除成功: $collectionName');
      return const VectorOperationResult(success: true);
    } catch (e) {
      final error = '删除向量集合异常: $e';
      debugPrint('❌ $error');
      return VectorOperationResult(success: false, error: error);
    }
  }

  @override
  Future<bool> collectionExists(String collectionName) async {
    try {
      if (!_isInitialized) return false;

      final collectionBox = _objectBoxManager.collectionBox;
      final query = collectionBox
          .query(VectorCollectionEntity_.collectionName.equals(collectionName))
          .build();
      final exists = query.findFirst() != null;
      query.close();

      return exists;
    } catch (e) {
      debugPrint('❌ 检查集合存在性失败: $e');
      return false;
    }
  }

  @override
  Future<VectorCollectionInfo?> getCollectionInfo(String collectionName) async {
    try {
      if (!_isInitialized) return null;

      final collectionBox = _objectBoxManager.collectionBox;
      final documentBox = _objectBoxManager.documentBox;

      // 查找集合
      final collectionQuery = collectionBox
          .query(VectorCollectionEntity_.collectionName.equals(collectionName))
          .build();
      final collection = collectionQuery.findFirst();
      collectionQuery.close();

      if (collection == null) return null;

      // 统计文档数量
      final documentQuery = documentBox
          .query(VectorDocumentEntity_.collectionName.equals(collectionName))
          .build();
      final documentCount = documentQuery.count();
      documentQuery.close();

      // 更新集合的文档数量
      if (collection.documentCount != documentCount) {
        collection.documentCount = documentCount;
        collection.updatedAt = DateTime.now();
        collectionBox.put(collection);
      }

      return VectorCollectionInfo(
        name: collection.collectionName,
        vectorDimension: collection.vectorDimension,
        documentCount: documentCount,
        description: collection.description,
        metadata: collection.metadata != null
            ? jsonDecode(collection.metadata!) as Map<String, dynamic>?
            : null,
        createdAt: collection.createdAt,
        updatedAt: collection.updatedAt,
      );
    } catch (e) {
      debugPrint('❌ 获取集合信息失败: $e');
      return null;
    }
  }

  @override
  Future<VectorOperationResult> insertVectors({
    required String collectionName,
    required List<VectorDocument> documents,
  }) async {
    try {
      debugPrint('📝 插入 ${documents.length} 个向量到集合: $collectionName');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 验证集合存在
      if (!await collectionExists(collectionName)) {
        throw Exception('集合不存在: $collectionName');
      }

      final documentBox = _objectBoxManager.documentBox;
      final entities = <VectorDocumentEntity>[];

      for (final doc in documents) {
        // 检查是否已存在，如果存在则更新
        final existingQuery = documentBox
            .query(
              VectorDocumentEntity_.documentId.equals(doc.id) &
                  VectorDocumentEntity_.collectionName.equals(collectionName),
            )
            .build();
        final existing = existingQuery.findFirst();
        existingQuery.close();

        final entity =
            existing ??
            VectorDocumentEntity(
              documentId: doc.id,
              collectionName: collectionName,
            );

        entity.vector = doc.vector;
        entity.metadata = doc.metadata.isNotEmpty
            ? jsonEncode(doc.metadata)
            : null;
        entity.updatedAt = DateTime.now();

        entities.add(entity);
      }

      // 批量插入/更新
      documentBox.putMany(entities);

      debugPrint('✅ 向量插入成功');
      return const VectorOperationResult(success: true);
    } catch (e) {
      final error = '插入向量异常: $e';
      debugPrint('❌ $error');
      return VectorOperationResult(success: false, error: error);
    }
  }

  @override
  Future<VectorOperationResult> updateVectors({
    required String collectionName,
    required List<VectorDocument> documents,
  }) async {
    // 更新操作与插入操作相同
    return insertVectors(collectionName: collectionName, documents: documents);
  }

  @override
  Future<VectorOperationResult> deleteVectors({
    required String collectionName,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint('🗑️ 删除 ${documentIds.length} 个向量从集合: $collectionName');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      final documentBox = _objectBoxManager.documentBox;
      int removedCount = 0;

      for (final docId in documentIds) {
        final query = documentBox
            .query(
              VectorDocumentEntity_.documentId.equals(docId) &
                  VectorDocumentEntity_.collectionName.equals(collectionName),
            )
            .build();
        final document = query.findFirst();
        query.close();

        if (document != null) {
          documentBox.remove(document.id);
          removedCount++;
        }
      }

      debugPrint('✅ 向量删除成功，删除了 $removedCount 个向量');
      return const VectorOperationResult(success: true);
    } catch (e) {
      final error = '删除向量异常: $e';
      debugPrint('❌ $error');
      return VectorOperationResult(success: false, error: error);
    }
  }

  @override
  Future<VectorSearchResult> search({
    required String collectionName,
    required List<double> queryVector,
    int limit = 10,
    double? scoreThreshold,
    Map<String, dynamic>? filter,
  }) async {
    final startTime = DateTime.now();

    try {
      debugPrint('🔍 ObjectBox 向量搜索: $collectionName (limit: $limit)');

      if (!_isInitialized) {
        debugPrint('⚠️ 向量数据库未初始化');
        return VectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
          error: '向量数据库未初始化',
        );
      }

      final documentBox = _objectBoxManager.documentBox;

      // 获取集合中的所有文档
      final query = documentBox
          .query(VectorDocumentEntity_.collectionName.equals(collectionName))
          .build();
      final documents = query.find();
      query.close();

      if (documents.isEmpty) {
        debugPrint('⚠️ 集合中没有向量数据: $collectionName');
        return VectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      // 计算相似度并排序
      final results = <VectorSearchResultWrapper>[];

      for (final document in documents) {
        if (document.vector == null || document.vector!.isEmpty) {
          continue;
        }

        try {
          final similarity = _cosineSimilarity(queryVector, document.vector!);

          // 应用分数阈值过滤
          if (scoreThreshold == null || similarity >= scoreThreshold) {
            results.add(
              VectorSearchResultWrapper(document: document, score: similarity),
            );
          }
        } catch (e) {
          debugPrint('⚠️ 跳过无效向量: ${document.documentId} - $e');
        }
      }

      // 按相似度排序（降序）
      results.sort((a, b) => b.score.compareTo(a.score));

      // 限制结果数量
      final limitedResults = results.take(limit).toList();

      // 转换为VectorSearchItem
      final items = limitedResults.map((result) {
        final metadata = result.document.metadata != null
            ? jsonDecode(result.document.metadata!) as Map<String, dynamic>
            : <String, dynamic>{};

        return VectorSearchItem(
          id: result.document.documentId,
          vector: result.document.vector!,
          metadata: metadata,
          score: result.score,
        );
      }).toList();

      final searchTime = _calculateSearchTime(startTime);
      debugPrint('✅ 搜索完成，找到 ${items.length} 个结果，耗时: ${searchTime}ms');

      return VectorSearchResult(
        items: items,
        totalResults: results.length,
        searchTime: searchTime,
      );
    } catch (e) {
      final searchTime = _calculateSearchTime(startTime);
      final error = '向量搜索异常: $e';
      debugPrint('❌ $error');
      return VectorSearchResult(
        items: [],
        totalResults: 0,
        searchTime: searchTime,
        error: error,
      );
    }
  }

  @override
  Future<List<VectorSearchResult>> batchSearch({
    required String collectionName,
    required List<List<double>> queryVectors,
    int limit = 10,
    double? scoreThreshold,
    Map<String, dynamic>? filter,
  }) async {
    final results = <VectorSearchResult>[];

    for (final queryVector in queryVectors) {
      final result = await search(
        collectionName: collectionName,
        queryVector: queryVector,
        limit: limit,
        scoreThreshold: scoreThreshold,
        filter: filter,
      );
      results.add(result);
    }

    return results;
  }

  @override
  Future<VectorDocument?> getVector({
    required String collectionName,
    required String documentId,
  }) async {
    try {
      if (!_isInitialized) return null;

      final documentBox = _objectBoxManager.documentBox;
      final query = documentBox
          .query(
            VectorDocumentEntity_.documentId.equals(documentId) &
                VectorDocumentEntity_.collectionName.equals(collectionName),
          )
          .build();
      final document = query.findFirst();
      query.close();

      if (document == null || document.vector == null) return null;

      final metadata = document.metadata != null
          ? jsonDecode(document.metadata!) as Map<String, dynamic>
          : <String, dynamic>{};

      return VectorDocument(
        id: document.documentId,
        vector: document.vector!,
        metadata: metadata,
      );
    } catch (e) {
      debugPrint('❌ 获取向量失败: $e');
      return null;
    }
  }

  @override
  Future<List<VectorDocument>> getVectors({
    required String collectionName,
    required List<String> documentIds,
  }) async {
    try {
      if (!_isInitialized) return [];

      final documentBox = _objectBoxManager.documentBox;
      final results = <VectorDocument>[];

      for (final docId in documentIds) {
        final query = documentBox
            .query(
              VectorDocumentEntity_.documentId.equals(docId) &
                  VectorDocumentEntity_.collectionName.equals(collectionName),
            )
            .build();
        final document = query.findFirst();
        query.close();

        if (document != null && document.vector != null) {
          final metadata = document.metadata != null
              ? jsonDecode(document.metadata!) as Map<String, dynamic>
              : <String, dynamic>{};

          results.add(
            VectorDocument(
              id: document.documentId,
              vector: document.vector!,
              metadata: metadata,
            ),
          );
        }
      }

      return results;
    } catch (e) {
      debugPrint('❌ 批量获取向量失败: $e');
      return [];
    }
  }

  @override
  Future<VectorCollectionStats> getCollectionStats(
    String collectionName,
  ) async {
    try {
      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      final collectionBox = _objectBoxManager.collectionBox;
      final documentBox = _objectBoxManager.documentBox;

      // 获取集合信息
      final collectionQuery = collectionBox
          .query(VectorCollectionEntity_.collectionName.equals(collectionName))
          .build();
      final collection = collectionQuery.findFirst();
      collectionQuery.close();

      if (collection == null) {
        throw Exception('集合不存在: $collectionName');
      }

      // 统计文档数量
      final documentQuery = documentBox
          .query(VectorDocumentEntity_.collectionName.equals(collectionName))
          .build();
      final documentCount = documentQuery.count();
      documentQuery.close();

      final averageVectorSize = collection.vectorDimension * 4.0; // float32

      return VectorCollectionStats(
        collectionName: collectionName,
        documentCount: documentCount,
        vectorDimension: collection.vectorDimension,
        averageVectorSize: averageVectorSize,
        additionalStats: {
          'storageType': 'ObjectBox',
          'databasePath': _objectBoxManager.store.directoryPath,
          'isHealthy': _objectBoxManager.isHealthy,
        },
      );
    } catch (e) {
      debugPrint('❌ 获取集合统计失败: $e');
      rethrow;
    }
  }

  @override
  Future<VectorBackupResult> backupCollection({
    required String collectionName,
    required String backupPath,
  }) async {
    try {
      debugPrint('💾 备份 ObjectBox 向量集合: $collectionName 到 $backupPath');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 获取集合信息
      final collectionInfo = await getCollectionInfo(collectionName);
      if (collectionInfo == null) {
        throw Exception('集合不存在: $collectionName');
      }

      // 获取所有文档
      final documentBox = _objectBoxManager.documentBox;
      final query = documentBox
          .query(VectorDocumentEntity_.collectionName.equals(collectionName))
          .build();
      final documents = query.find();
      query.close();

      // 创建备份数据
      final backupData = {
        'collection': {
          'name': collectionInfo.name,
          'vectorDimension': collectionInfo.vectorDimension,
          'documentCount': collectionInfo.documentCount,
          'description': collectionInfo.description,
          'metadata': collectionInfo.metadata,
          'createdAt': collectionInfo.createdAt.toIso8601String(),
          'updatedAt': collectionInfo.updatedAt.toIso8601String(),
        },
        'documents': documents.map((doc) => doc.toMap()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // 写入备份文件
      final backupFile = File(backupPath);
      await backupFile.writeAsString(jsonEncode(backupData));

      final backupSize = await _calculateFileSize(backupFile);

      debugPrint('✅ 集合备份完成: $collectionName');

      return VectorBackupResult(
        success: true,
        backupPath: backupPath,
        documentCount: documents.length,
        backupSize: backupSize,
      );
    } catch (e) {
      final error = '备份异常: $e';
      debugPrint('❌ $error');
      return VectorBackupResult(
        success: false,
        documentCount: 0,
        backupSize: 0.0,
        error: error,
      );
    }
  }

  @override
  Future<VectorOperationResult> restoreCollection({
    required String collectionName,
    required String backupPath,
  }) async {
    try {
      debugPrint('🔄 恢复 ObjectBox 向量集合: $collectionName 从 $backupPath');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 读取备份文件
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('备份文件不存在: $backupPath');
      }

      final backupContent = await backupFile.readAsString();
      final backupData = jsonDecode(backupContent) as Map<String, dynamic>;

      // 恢复集合
      final collectionData = backupData['collection'] as Map<String, dynamic>;
      final collection = VectorCollectionEntity.fromMap(collectionData);
      collection.collectionName = collectionName; // 使用新的集合名称

      final collectionBox = _objectBoxManager.collectionBox;
      collectionBox.put(collection);

      // 恢复文档
      final documentsData = backupData['documents'] as List;
      final documentBox = _objectBoxManager.documentBox;
      final documents = <VectorDocumentEntity>[];

      for (final docData in documentsData) {
        final document = VectorDocumentEntity.fromMap(
          docData as Map<String, dynamic>,
        );
        document.collectionName = collectionName; // 使用新的集合名称
        documents.add(document);
      }

      documentBox.putMany(documents);

      debugPrint('✅ 集合恢复完成');
      return const VectorOperationResult(success: true);
    } catch (e) {
      final error = '恢复异常: $e';
      debugPrint('❌ $error');
      return VectorOperationResult(success: false, error: error);
    }
  }

  // === 私有辅助方法 ===

  /// 计算余弦相似度
  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('向量维度不匹配: ${a.length} != ${b.length}');
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0.0 || normB == 0.0) {
      return 0.0;
    }

    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  /// 计算搜索时间
  double _calculateSearchTime(DateTime startTime) {
    return DateTime.now().difference(startTime).inMilliseconds.toDouble();
  }

  /// 计算文件大小（MB）
  Future<double> _calculateFileSize(File file) async {
    try {
      if (!await file.exists()) return 0.0;
      final stat = await file.stat();
      return stat.size / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }
}
