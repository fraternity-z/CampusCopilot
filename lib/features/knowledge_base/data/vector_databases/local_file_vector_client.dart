import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import '../../domain/services/vector_database_interface.dart';

/// 向量距离类型
enum VectorDistanceType { euclidean, cosine, dotProduct, manhattan }

/// 本地文件向量数据库客户端实现
///
/// 使用本地文件存储实现完全本地的向量数据库，无需外部依赖
class LocalFileVectorClient implements VectorDatabaseInterface {
  final Map<String, List<LocalVectorDocument>> _collections = {};
  bool _isInitialized = false;
  final String _databasePath;

  LocalFileVectorClient(this._databasePath);

  @override
  Future<bool> initialize() async {
    try {
      debugPrint('🔌 初始化本地文件向量数据库: $_databasePath');

      // 创建数据库目录
      final dbDir = Directory(_databasePath);
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      // 加载现有数据
      await _loadCollections();

      _isInitialized = true;
      debugPrint('✅ 本地文件向量数据库初始化成功');
      return true;
    } catch (e) {
      debugPrint('❌ 本地向量数据库初始化失败: $e');
      return false;
    }
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      // 保存所有数据
      await _saveCollections();
      _collections.clear();
      _isInitialized = false;
      debugPrint('🔌 本地向量数据库连接已关闭');
    }
  }

  @override
  Future<bool> isHealthy() async {
    return _isInitialized;
  }

  @override
  Future<VectorCollectionResult> createCollection({
    required String collectionName,
    required int vectorDimension,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint('📁 创建本地向量集合: $collectionName (维度: $vectorDimension)');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 初始化集合
      _collections[collectionName] = [];

      // 保存集合元数据
      await _saveCollectionMetadata(collectionName, {
        'vectorDimension': vectorDimension,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
        ...?metadata,
      });

      debugPrint('✅ 向量集合创建成功: $collectionName');
      return VectorCollectionResult(
        success: true,
        collectionName: collectionName,
        metadata: {
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
      debugPrint('🗑️ 删除本地向量集合: $collectionName');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 删除内存中的集合数据
      final removed = _collections.remove(collectionName);

      if (removed != null) {
        debugPrint('✅ 删除了${removed.length}个向量');

        // 删除文件
        final collectionFile = File(
          path.join(_databasePath, '$collectionName.json'),
        );
        if (await collectionFile.exists()) {
          await collectionFile.delete();
        }

        final metadataFile = File(
          path.join(_databasePath, '${collectionName}_metadata.json'),
        );
        if (await metadataFile.exists()) {
          await metadataFile.delete();
        }
      }

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
      return _collections.containsKey(collectionName);
    } catch (e) {
      debugPrint('❌ 检查集合存在性失败: $e');
      return false;
    }
  }

  @override
  Future<VectorCollectionInfo?> getCollectionInfo(String collectionName) async {
    try {
      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        return null;
      }

      final entities = _collections[collectionName]!;
      final metadata = await _loadCollectionMetadata(collectionName);

      if (entities.isEmpty) {
        return VectorCollectionInfo(
          name: collectionName,
          vectorDimension: metadata['vectorDimension'] as int? ?? 0,
          documentCount: 0,
          description: metadata['description'] as String?,
          createdAt:
              DateTime.tryParse(metadata['createdAt'] as String? ?? '') ??
              DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      // 获取第一个向量的维度作为集合维度
      final vectorDimension = entities.first.vector.length;

      return VectorCollectionInfo(
        name: collectionName,
        vectorDimension: vectorDimension,
        documentCount: entities.length,
        description: metadata['description'] as String? ?? '本地文件向量集合',
        createdAt:
            DateTime.tryParse(metadata['createdAt'] as String? ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.now(),
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
      debugPrint('📝 插入${documents.length}个向量到集合: $collectionName');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 确保集合存在
      if (!_collections.containsKey(collectionName)) {
        _collections[collectionName] = [];
      }

      final collection = _collections[collectionName]!;

      for (final doc in documents) {
        // 检查是否已存在，如果存在则更新
        final existingIndex = collection.indexWhere((e) => e.id == doc.id);

        final localDoc = LocalVectorDocument(
          id: doc.id,
          vector: doc.vector,
          metadata: doc.metadata,
          createdAt: DateTime.now(),
        );

        if (existingIndex >= 0) {
          collection[existingIndex] = localDoc;
        } else {
          collection.add(localDoc);
        }
      }

      // 保存到文件
      await _saveCollection(collectionName);

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
      debugPrint('🗑️ 删除${documentIds.length}个向量从集合: $collectionName');

      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        throw Exception('集合不存在: $collectionName');
      }

      final collection = _collections[collectionName]!;
      int removedCount = 0;

      for (final docId in documentIds) {
        final initialLength = collection.length;
        collection.removeWhere((e) => e.id == docId);
        removedCount += initialLength - collection.length;
      }

      if (removedCount > 0) {
        await _saveCollection(collectionName);
      }

      debugPrint('✅ 向量删除成功，删除了$removedCount个向量');
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
      debugPrint('🔍 本地向量搜索: $collectionName (limit: $limit)');

      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        debugPrint('⚠️ 集合不存在: $collectionName');
        return VectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      final collection = _collections[collectionName]!;

      if (collection.isEmpty) {
        debugPrint('⚠️ 集合中没有向量数据: $collectionName');
        return VectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      // 计算相似度并排序
      final results = <LocalVectorSearchResult>[];

      for (final candidate in collection) {
        try {
          final similarity = _cosineSimilarity(queryVector, candidate.vector);

          // 应用分数阈值过滤
          if (scoreThreshold == null || similarity >= scoreThreshold) {
            results.add(
              LocalVectorSearchResult(document: candidate, score: similarity),
            );
          }
        } catch (e) {
          debugPrint('⚠️ 跳过无效向量: ${candidate.id} - $e');
        }
      }

      // 按相似度排序（降序）
      results.sort((a, b) => b.score.compareTo(a.score));

      // 限制结果数量
      final limitedResults = results.take(limit).toList();

      // 转换为VectorSearchItem
      final items = limitedResults
          .map(
            (result) => VectorSearchItem(
              id: result.document.id,
              vector: result.document.vector,
              metadata: result.document.metadata,
              score: result.score,
            ),
          )
          .toList();

      final searchTime = _calculateSearchTime(startTime);
      debugPrint('✅ 搜索完成，找到${items.length}个结果，耗时: ${searchTime}ms');

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
      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        return null;
      }

      final collection = _collections[collectionName]!;
      final document = collection.where((e) => e.id == documentId).firstOrNull;

      if (document == null) return null;

      return VectorDocument(
        id: document.id,
        vector: document.vector,
        metadata: document.metadata,
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
      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        return [];
      }

      final collection = _collections[collectionName]!;
      final results = <VectorDocument>[];

      for (final docId in documentIds) {
        final document = collection.where((e) => e.id == docId).firstOrNull;
        if (document != null) {
          results.add(
            VectorDocument(
              id: document.id,
              vector: document.vector,
              metadata: document.metadata,
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
      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        throw Exception('集合不存在: $collectionName');
      }

      final collection = _collections[collectionName]!;

      if (collection.isEmpty) {
        return VectorCollectionStats(
          collectionName: collectionName,
          documentCount: 0,
          vectorDimension: 0,
          averageVectorSize: 0.0,
        );
      }

      final vectorDimension = collection.first.vector.length;
      final averageVectorSize = vectorDimension * 4.0; // float32

      return VectorCollectionStats(
        collectionName: collectionName,
        documentCount: collection.length,
        vectorDimension: vectorDimension,
        averageVectorSize: averageVectorSize,
        additionalStats: {
          'storageType': 'Local File',
          'databasePath': _databasePath,
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
      debugPrint('💾 备份本地向量集合: $collectionName 到 $backupPath');

      if (!_isInitialized || !_collections.containsKey(collectionName)) {
        throw Exception('集合不存在: $collectionName');
      }

      final collection = _collections[collectionName]!;

      // 创建备份目录
      final backupDir = Directory(backupPath);
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // 备份数据文件
      final sourceFile = File(path.join(_databasePath, '$collectionName.json'));
      final backupFile = File(path.join(backupPath, '$collectionName.json'));

      if (await sourceFile.exists()) {
        await sourceFile.copy(backupFile.path);
      }

      // 备份元数据文件
      final sourceMetaFile = File(
        path.join(_databasePath, '${collectionName}_metadata.json'),
      );
      final backupMetaFile = File(
        path.join(backupPath, '${collectionName}_metadata.json'),
      );

      if (await sourceMetaFile.exists()) {
        await sourceMetaFile.copy(backupMetaFile.path);
      }

      debugPrint('✅ 集合备份完成: $collectionName');

      return VectorBackupResult(
        success: true,
        backupPath: backupPath,
        documentCount: collection.length,
        backupSize: await _calculateFileSize(sourceFile),
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
      debugPrint('🔄 恢复本地向量集合: $collectionName 从 $backupPath');

      if (!_isInitialized) {
        throw Exception('向量数据库未初始化');
      }

      // 恢复数据文件
      final backupFile = File(path.join(backupPath, '$collectionName.json'));
      final targetFile = File(path.join(_databasePath, '$collectionName.json'));

      if (await backupFile.exists()) {
        await backupFile.copy(targetFile.path);
      }

      // 恢复元数据文件
      final backupMetaFile = File(
        path.join(backupPath, '${collectionName}_metadata.json'),
      );
      final targetMetaFile = File(
        path.join(_databasePath, '${collectionName}_metadata.json'),
      );

      if (await backupMetaFile.exists()) {
        await backupMetaFile.copy(targetMetaFile.path);
      }

      // 重新加载集合数据
      await _loadCollection(collectionName);

      debugPrint('✅ 集合恢复完成');
      return const VectorOperationResult(success: true);
    } catch (e) {
      final error = '恢复异常: $e';
      debugPrint('❌ $error');
      return VectorOperationResult(success: false, error: error);
    }
  }

  // === 私有辅助方法 ===

  /// 加载所有集合
  Future<void> _loadCollections() async {
    try {
      final dbDir = Directory(_databasePath);
      if (!await dbDir.exists()) return;

      await for (final entity in dbDir.list()) {
        if (entity is File &&
            entity.path.endsWith('.json') &&
            !entity.path.endsWith('_metadata.json')) {
          final fileName = path.basenameWithoutExtension(entity.path);
          await _loadCollection(fileName);
        }
      }
    } catch (e) {
      debugPrint('❌ 加载集合失败: $e');
    }
  }

  /// 加载单个集合
  Future<void> _loadCollection(String collectionName) async {
    try {
      final collectionFile = File(
        path.join(_databasePath, '$collectionName.json'),
      );
      if (!await collectionFile.exists()) return;

      final content = await collectionFile.readAsString();
      final jsonData = jsonDecode(content) as List;

      final documents = jsonData
          .map(
            (item) =>
                LocalVectorDocument.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      _collections[collectionName] = documents;

      debugPrint('📚 加载集合: $collectionName (${documents.length}个向量)');
    } catch (e) {
      debugPrint('❌ 加载集合失败: $collectionName - $e');
    }
  }

  /// 保存所有集合
  Future<void> _saveCollections() async {
    for (final collectionName in _collections.keys) {
      await _saveCollection(collectionName);
    }
  }

  /// 保存单个集合
  Future<void> _saveCollection(String collectionName) async {
    try {
      final collection = _collections[collectionName];
      if (collection == null) return;

      final collectionFile = File(
        path.join(_databasePath, '$collectionName.json'),
      );
      final jsonData = collection.map((doc) => doc.toJson()).toList();
      await collectionFile.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      debugPrint('❌ 保存集合失败: $collectionName - $e');
    }
  }

  /// 保存集合元数据
  Future<void> _saveCollectionMetadata(
    String collectionName,
    Map<String, dynamic> metadata,
  ) async {
    try {
      final metadataFile = File(
        path.join(_databasePath, '${collectionName}_metadata.json'),
      );
      await metadataFile.writeAsString(jsonEncode(metadata));
    } catch (e) {
      debugPrint('❌ 保存集合元数据失败: $collectionName - $e');
    }
  }

  /// 加载集合元数据
  Future<Map<String, dynamic>> _loadCollectionMetadata(
    String collectionName,
  ) async {
    try {
      final metadataFile = File(
        path.join(_databasePath, '${collectionName}_metadata.json'),
      );
      if (!await metadataFile.exists()) return {};

      final content = await metadataFile.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ 加载集合元数据失败: $collectionName - $e');
      return {};
    }
  }

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

    return dotProduct / (_sqrt(normA) * _sqrt(normB));
  }

  /// 简单的平方根实现
  double _sqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0) return 0;

    double guess = x / 2;
    double prev = 0;

    while ((guess - prev).abs() > 1e-10) {
      prev = guess;
      guess = (guess + x / guess) / 2;
    }

    return guess;
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

/// 本地向量文档
class LocalVectorDocument {
  final String id;
  final List<double> vector;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LocalVectorDocument({
    required this.id,
    required this.vector,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'vector': vector,
    'metadata': metadata,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory LocalVectorDocument.fromJson(Map<String, dynamic> json) =>
      LocalVectorDocument(
        id: json['id'] as String,
        vector: (json['vector'] as List).cast<double>(),
        metadata: json['metadata'] as Map<String, dynamic>,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );

  @override
  String toString() {
    return 'LocalVectorDocument(id: $id, vectorDim: ${vector.length}, createdAt: $createdAt)';
  }
}

/// 本地向量搜索结果
class LocalVectorSearchResult {
  final LocalVectorDocument document;
  final double score;

  const LocalVectorSearchResult({required this.document, required this.score});

  @override
  String toString() {
    return 'LocalVectorSearchResult(id: ${document.id}, score: $score)';
  }
}
