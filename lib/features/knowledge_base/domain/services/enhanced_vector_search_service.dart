import 'package:flutter/foundation.dart';

import '../../../../data/local/app_database.dart';
import '../entities/enhanced_search_entities.dart';
import '../entities/knowledge_document.dart';
import 'vector_database_interface.dart';
import 'embedding_service.dart';

/// 增强的向量搜索服务
///
/// 使用专业向量数据库替代SQLite存储，提供更高性能的向量搜索
class EnhancedVectorSearchService {
  final AppDatabase _database;
  final VectorDatabaseInterface _vectorDatabase;
  final EmbeddingService _embeddingService;

  // 搜索结果缓存
  final Map<String, VectorSearchResult> _searchCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const int _maxCacheSize = 50;
  static const Duration _cacheExpiry = Duration(minutes: 10);

  EnhancedVectorSearchService(
    this._database,
    this._vectorDatabase,
    this._embeddingService,
  );

  /// 初始化向量数据库连接
  Future<bool> initialize() async {
    try {
      debugPrint('🔌 初始化增强向量搜索服务...');
      final success = await _vectorDatabase.initialize();
      if (success) {
        debugPrint('✅ 向量数据库连接成功');
      } else {
        debugPrint('❌ 向量数据库连接失败');
      }
      return success;
    } catch (e) {
      debugPrint('❌ 初始化向量搜索服务失败: $e');
      return false;
    }
  }

  /// 关闭向量数据库连接
  Future<void> close() async {
    await _vectorDatabase.close();
    _searchCache.clear();
    _cacheTimestamps.clear();
  }

  /// 检查向量数据库健康状态
  Future<bool> isHealthy() async {
    return await _vectorDatabase.isHealthy();
  }

  /// 为知识库创建向量集合
  Future<bool> createCollectionForKnowledgeBase({
    required String knowledgeBaseId,
    required int vectorDimension,
    String? description,
  }) async {
    try {
      debugPrint('📁 为知识库创建向量集合: $knowledgeBaseId');

      final result = await _vectorDatabase.createCollection(
        collectionName: knowledgeBaseId,
        vectorDimension: vectorDimension,
        description: description ?? '知识库 $knowledgeBaseId 的向量集合',
        metadata: {
          'knowledgeBaseId': knowledgeBaseId,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      if (result.success) {
        debugPrint('✅ 向量集合创建成功: $knowledgeBaseId');
        return true;
      } else {
        debugPrint('❌ 向量集合创建失败: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 创建向量集合异常: $e');
      return false;
    }
  }

  /// 删除知识库的向量集合
  Future<bool> deleteCollectionForKnowledgeBase(String knowledgeBaseId) async {
    try {
      debugPrint('🗑️ 删除知识库向量集合: $knowledgeBaseId');

      final result = await _vectorDatabase.deleteCollection(knowledgeBaseId);

      if (result.success) {
        debugPrint('✅ 向量集合删除成功: $knowledgeBaseId');
        // 清理相关缓存
        _clearCacheForKnowledgeBase(knowledgeBaseId);
        return true;
      } else {
        debugPrint('❌ 向量集合删除失败: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 删除向量集合异常: $e');
      return false;
    }
  }

  /// 向向量数据库插入文档向量
  Future<bool> insertDocumentVectors({
    required String knowledgeBaseId,
    required List<DocumentChunkVector> chunkVectors,
  }) async {
    try {
      debugPrint('📝 插入${chunkVectors.length}个文档向量到集合: $knowledgeBaseId');

      final vectorDocuments = chunkVectors
          .map(
            (chunk) => VectorDocument(
              id: chunk.chunkId,
              vector: chunk.vector,
              metadata: {
                'documentId': chunk.documentId,
                'chunkIndex': chunk.chunkIndex,
                'content': chunk.content,
                'characterCount': chunk.characterCount,
                'tokenCount': chunk.tokenCount,
                'createdAt': chunk.createdAt.toIso8601String(),
              },
            ),
          )
          .toList();

      final result = await _vectorDatabase.insertVectors(
        collectionName: knowledgeBaseId,
        documents: vectorDocuments,
      );

      if (result.success) {
        debugPrint('✅ 文档向量插入成功');
        return true;
      } else {
        debugPrint('❌ 文档向量插入失败: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 插入文档向量异常: $e');
      return false;
    }
  }

  /// 从向量数据库删除文档向量
  Future<bool> deleteDocumentVectors({
    required String knowledgeBaseId,
    required List<String> chunkIds,
  }) async {
    try {
      debugPrint('🗑️ 删除${chunkIds.length}个文档向量从集合: $knowledgeBaseId');

      final result = await _vectorDatabase.deleteVectors(
        collectionName: knowledgeBaseId,
        documentIds: chunkIds,
      );

      if (result.success) {
        debugPrint('✅ 文档向量删除成功');
        return true;
      } else {
        debugPrint('❌ 文档向量删除失败: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 删除文档向量异常: $e');
      return false;
    }
  }

  /// 执行向量搜索
  Future<EnhancedVectorSearchResult> search({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    double similarityThreshold = 0.7,
    int maxResults = 5,
  }) async {
    final startTime = DateTime.now();

    // 生成缓存键
    final cacheKey = _generateCacheKey(
      query,
      config.id,
      knowledgeBaseId,
      similarityThreshold,
      maxResults,
    );

    // 检查缓存
    final cachedResult = _getCachedResult(cacheKey);
    if (cachedResult != null) {
      debugPrint('🚀 使用缓存的搜索结果');
      return EnhancedVectorSearchResult.fromVectorSearchResult(cachedResult);
    }

    try {
      debugPrint('🔍 开始增强向量搜索: "$query"');
      debugPrint('📊 使用配置: ${config.name} - ${config.embeddingModelProvider}');
      debugPrint('📊 搜索参数: 相似度阈值=$similarityThreshold, 最大结果数=$maxResults');

      final targetKnowledgeBaseId = knowledgeBaseId ?? 'default_kb';
      debugPrint('📚 目标知识库: $targetKnowledgeBaseId');

      // 1. 检查集合是否存在
      final collectionExists = await _vectorDatabase.collectionExists(
        targetKnowledgeBaseId,
      );
      if (!collectionExists) {
        debugPrint('⚠️ 向量集合不存在: $targetKnowledgeBaseId');
        return EnhancedVectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
          error: '知识库向量集合不存在，请先处理文档',
        );
      }

      // 2. 为查询生成嵌入向量
      debugPrint('🧮 生成查询嵌入向量...');
      final queryEmbeddingResult = await _embeddingService
          .generateSingleEmbedding(text: query, config: config);

      if (!queryEmbeddingResult.isSuccess) {
        debugPrint('❌ 生成查询嵌入向量失败: ${queryEmbeddingResult.error}');
        return EnhancedVectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
          error: '生成查询嵌入向量失败: ${queryEmbeddingResult.error}',
        );
      }

      debugPrint('✅ 查询嵌入向量生成成功');
      final queryEmbedding = queryEmbeddingResult.embeddings.first;

      // 3. 执行向量搜索
      debugPrint('🔍 执行向量数据库搜索...');
      final searchResult = await _vectorDatabase.search(
        collectionName: targetKnowledgeBaseId,
        queryVector: queryEmbedding,
        limit: maxResults,
        scoreThreshold: similarityThreshold,
      );

      if (!searchResult.isSuccess) {
        debugPrint('❌ 向量搜索失败: ${searchResult.error}');
        return EnhancedVectorSearchResult(
          items: [],
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
          error: searchResult.error,
        );
      }

      // 4. 转换搜索结果
      final enhancedItems = searchResult.items
          .map((item) => EnhancedSearchResultItem.fromVectorSearchItem(item))
          .toList();

      debugPrint('✅ 向量搜索完成，找到${enhancedItems.length}个结果');

      final result = EnhancedVectorSearchResult(
        items: enhancedItems,
        totalResults: searchResult.totalResults,
        searchTime: _calculateSearchTime(startTime),
      );

      // 缓存搜索结果
      _cacheResult(cacheKey, searchResult);

      return result;
    } catch (e) {
      debugPrint('❌ 增强向量搜索失败: $e');
      String errorMessage = e.toString();

      // 提供更友好的错误信息
      if (errorMessage.contains('SocketException')) {
        errorMessage = '向量搜索网络连接失败，请检查向量数据库连接';
      } else if (errorMessage.contains('TimeoutException') ||
          errorMessage.contains('超时')) {
        errorMessage = '向量搜索超时，请检查向量数据库状态或稍后重试';
      }

      return EnhancedVectorSearchResult(
        items: [],
        totalResults: 0,
        searchTime: _calculateSearchTime(startTime),
        error: errorMessage,
      );
    }
  }

  /// 混合搜索（向量搜索 + 关键词搜索）
  Future<EnhancedVectorSearchResult> hybridSearch({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    double similarityThreshold = 0.7,
    int maxResults = 5,
    double vectorWeight = 0.7,
    double keywordWeight = 0.3,
  }) async {
    final startTime = DateTime.now();

    try {
      debugPrint('🔍 开始混合搜索: "$query"');

      // 1. 执行向量搜索
      final vectorResult = await search(
        query: query,
        config: config,
        knowledgeBaseId: knowledgeBaseId,
        similarityThreshold: similarityThreshold,
        maxResults: maxResults * 2, // 获取更多结果用于混合
      );

      if (!vectorResult.isSuccess) {
        return vectorResult;
      }

      // 2. 执行关键词搜索
      final keywordResults = await _keywordSearch(
        query,
        maxResults * 2,
        knowledgeBaseId,
      );

      // 3. 合并和重新排序结果
      final combinedResults = _combineResults(
        vectorResult.items,
        keywordResults,
        vectorWeight,
        keywordWeight,
      );

      // 4. 限制结果数量
      final limitedResults = combinedResults.take(maxResults).toList();

      return EnhancedVectorSearchResult(
        items: limitedResults,
        totalResults: combinedResults.length,
        searchTime: _calculateSearchTime(startTime),
      );
    } catch (e) {
      debugPrint('❌ 混合搜索失败: $e');
      return EnhancedVectorSearchResult(
        items: [],
        totalResults: 0,
        searchTime: _calculateSearchTime(startTime),
        error: e.toString(),
      );
    }
  }

  // === 私有辅助方法 ===

  /// 关键词搜索
  Future<List<EnhancedSearchResultItem>> _keywordSearch(
    String query,
    int maxResults,
    String? knowledgeBaseId,
  ) async {
    try {
      final chunks = knowledgeBaseId != null
          ? await _database.searchChunksByKnowledgeBase(query, knowledgeBaseId)
          : await _database.searchChunks(query);

      return chunks
          .map(
            (chunk) => EnhancedSearchResultItem(
              chunkId: chunk.id,
              documentId: chunk.documentId,
              content: chunk.content,
              similarity: _calculateKeywordSimilarity(query, chunk.content),
              chunkIndex: chunk.chunkIndex,
              metadata: {
                'characterCount': chunk.characterCount,
                'tokenCount': chunk.tokenCount,
                'createdAt': chunk.createdAt.toIso8601String(),
                'searchType': 'keyword',
              },
            ),
          )
          .take(maxResults)
          .toList();
    } catch (e) {
      debugPrint('关键词搜索失败: $e');
      return [];
    }
  }

  /// 计算关键词相似度
  double _calculateKeywordSimilarity(String query, String content) {
    final queryWords = query.toLowerCase().split(' ');
    final contentWords = content.toLowerCase().split(' ');

    int matchCount = 0;
    for (final word in queryWords) {
      if (contentWords.contains(word)) {
        matchCount++;
      }
    }

    return queryWords.isEmpty ? 0.0 : matchCount / queryWords.length;
  }

  /// 合并向量搜索和关键词搜索结果
  List<EnhancedSearchResultItem> _combineResults(
    List<EnhancedSearchResultItem> vectorResults,
    List<EnhancedSearchResultItem> keywordResults,
    double vectorWeight,
    double keywordWeight,
  ) {
    final Map<String, EnhancedSearchResultItem> combinedMap = {};

    // 添加向量搜索结果
    for (final item in vectorResults) {
      combinedMap[item.chunkId] = item.copyWith(
        similarity: item.similarity * vectorWeight,
      );
    }

    // 合并关键词搜索结果
    for (final item in keywordResults) {
      if (combinedMap.containsKey(item.chunkId)) {
        // 如果已存在，合并分数
        final existing = combinedMap[item.chunkId]!;
        combinedMap[item.chunkId] = existing.copyWith(
          similarity: existing.similarity + (item.similarity * keywordWeight),
        );
      } else {
        // 如果不存在，添加新项
        combinedMap[item.chunkId] = item.copyWith(
          similarity: item.similarity * keywordWeight,
        );
      }
    }

    // 按相似度排序
    final sortedResults = combinedMap.values.toList()
      ..sort((a, b) => b.similarity.compareTo(a.similarity));

    return sortedResults;
  }

  /// 生成缓存键
  String _generateCacheKey(
    String query,
    String configId,
    String? knowledgeBaseId,
    double similarityThreshold,
    int maxResults,
  ) {
    return '${query}_${configId}_${knowledgeBaseId ?? 'all'}_${similarityThreshold}_$maxResults';
  }

  /// 获取缓存结果
  VectorSearchResult? _getCachedResult(String cacheKey) {
    final timestamp = _cacheTimestamps[cacheKey];
    if (timestamp != null &&
        DateTime.now().difference(timestamp) < _cacheExpiry) {
      return _searchCache[cacheKey];
    }

    // 清理过期缓存
    _searchCache.remove(cacheKey);
    _cacheTimestamps.remove(cacheKey);
    return null;
  }

  /// 缓存搜索结果
  void _cacheResult(String cacheKey, VectorSearchResult result) {
    if (_searchCache.length >= _maxCacheSize) {
      _cleanupOldestCache();
    }

    _searchCache[cacheKey] = result;
    _cacheTimestamps[cacheKey] = DateTime.now();
  }

  /// 清理最旧的缓存条目
  void _cleanupOldestCache() {
    if (_cacheTimestamps.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cacheTimestamps.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestTime = entry.value;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _searchCache.remove(oldestKey);
      _cacheTimestamps.remove(oldestKey);
    }
  }

  /// 清理指定知识库的缓存
  void _clearCacheForKnowledgeBase(String knowledgeBaseId) {
    final keysToRemove = <String>[];

    for (final key in _searchCache.keys) {
      if (key.contains(knowledgeBaseId)) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      _searchCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// 清理所有缓存
  void clearCache() {
    _searchCache.clear();
    _cacheTimestamps.clear();
  }

  /// 计算搜索时间
  double _calculateSearchTime(DateTime startTime) {
    return DateTime.now().difference(startTime).inMilliseconds.toDouble();
  }
}
