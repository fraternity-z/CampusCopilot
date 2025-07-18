import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../../../data/local/app_database.dart';
import '../entities/knowledge_document.dart';
import 'embedding_service.dart';

/// 搜索结果项
class SearchResultItem {
  final String chunkId;
  final String documentId;
  final String content;
  final double similarity;
  final int chunkIndex;
  final Map<String, dynamic> metadata;
  final String? documentTitle; // 添加文档标题

  const SearchResultItem({
    required this.chunkId,
    required this.documentId,
    required this.content,
    required this.similarity,
    required this.chunkIndex,
    this.metadata = const {},
    this.documentTitle,
  });
}

/// 向量搜索结果
class VectorSearchResult {
  final List<SearchResultItem> items;
  final String? error;
  final int totalResults;
  final double searchTime; // 搜索耗时（毫秒）

  const VectorSearchResult({
    required this.items,
    this.error,
    required this.totalResults,
    required this.searchTime,
  });

  bool get isSuccess => error == null;
}

/// 向量搜索服务
class VectorSearchService {
  final AppDatabase _database;
  final EmbeddingService _embeddingService;

  // 缓存最近的查询结果
  final Map<String, VectorSearchResult> _searchCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);
  static const int _maxCacheSize = 50;

  VectorSearchService(this._database, this._embeddingService);

  /// 执行向量搜索
  Future<VectorSearchResult> search({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    double similarityThreshold = 0.3, // 降低默认阈值，提高召回率
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
      return cachedResult;
    }

    try {
      debugPrint('🔍 开始向量搜索: "$query"');
      debugPrint('📊 使用配置: ${config.name} - ${config.embeddingModelProvider}');
      debugPrint('📊 搜索参数: 相似度阈值=$similarityThreshold, 最大结果数=$maxResults');
      if (knowledgeBaseId != null) {
        debugPrint('📚 限定知识库: $knowledgeBaseId');
      }

      // 1. 为查询生成嵌入向量
      debugPrint('🧮 生成查询嵌入向量...');
      final queryEmbeddingResult = await _embeddingService
          .generateSingleEmbedding(text: query, config: config);

      if (!queryEmbeddingResult.isSuccess) {
        debugPrint('❌ 生成查询嵌入向量失败: ${queryEmbeddingResult.error}');
        return VectorSearchResult(
          items: [],
          error: '生成查询嵌入向量失败: ${queryEmbeddingResult.error}',
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      debugPrint('✅ 查询嵌入向量生成成功');

      final queryEmbedding = queryEmbeddingResult.embeddings.first;

      // 2. 获取指定知识库的有嵌入向量的文本块（优化查询）
      debugPrint('📚 获取文本块...');
      final chunks = await _getOptimizedChunks(knowledgeBaseId);

      debugPrint('📊 找到 ${chunks.length} 个有嵌入向量的文本块');

      if (chunks.isEmpty) {
        debugPrint('⚠️ 没有找到任何有嵌入向量的文本块');
        return VectorSearchResult(
          items: [],
          error: '知识库中没有可搜索的内容，请先上传并处理文档',
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      // 3. 获取文档标题映射
      debugPrint('📄 获取文档信息...');
      final documentTitles = await _getDocumentTitles(
        chunks.map((c) => c.documentId).toSet(),
      );

      // 4. 计算相似度并筛选结果（优化版本）
      debugPrint('🧮 计算相似度...');
      final results = await _calculateSimilarityOptimized(
        queryEmbedding: queryEmbedding,
        chunks: chunks,
        similarityThreshold: similarityThreshold,
        maxResults: maxResults,
        config: config,
        documentTitles: documentTitles,
      );

      // 4. 按相似度降序排序
      results.sort((a, b) => b.similarity.compareTo(a.similarity));

      // 5. 限制结果数量
      final limitedResults = results.take(maxResults).toList();

      debugPrint('✅ 向量搜索完成: 找到${limitedResults.length}个相关结果');
      for (int i = 0; i < limitedResults.length; i++) {
        final result = limitedResults[i];
        debugPrint(
          '📄 结果${i + 1}: 相似度=${result.similarity.toStringAsFixed(3)}, 内容长度=${result.content.length}',
        );
      }

      // 如果没有找到任何结果，可能是向量维度不匹配导致的
      if (results.isEmpty && chunks.isNotEmpty) {
        debugPrint('⚠️ 没有找到匹配的结果，可能是向量维度不匹配');
        debugPrint('💡 建议：重新处理文档以生成兼容的嵌入向量');
        return VectorSearchResult(
          items: [],
          error: '向量维度不匹配，请重新处理文档或检查嵌入模型配置',
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      final result = VectorSearchResult(
        items: limitedResults,
        totalResults: results.length,
        searchTime: _calculateSearchTime(startTime),
      );

      // 缓存搜索结果
      _cacheResult(cacheKey, result);

      return result;
    } catch (e) {
      debugPrint('❌ 向量搜索失败: $e');
      String errorMessage = e.toString();

      // 提供更友好的错误信息
      if (errorMessage.contains('SocketException')) {
        errorMessage = '向量搜索网络连接失败，请检查网络设置或API服务地址';
      } else if (errorMessage.contains('TimeoutException') ||
          errorMessage.contains('超时')) {
        errorMessage = '向量搜索超时，请检查网络连接或稍后重试';
      } else if (errorMessage.contains('401') ||
          errorMessage.contains('Unauthorized')) {
        errorMessage = 'API密钥无效，请检查嵌入模型的API密钥配置';
      } else if (errorMessage.contains('404')) {
        errorMessage = 'API端点不存在，请检查嵌入模型的API地址配置';
      }

      return VectorSearchResult(
        items: [],
        error: errorMessage,
        totalResults: 0,
        searchTime: _calculateSearchTime(startTime),
      );
    }
  }

  /// 混合搜索（向量搜索 + 关键词搜索）
  Future<VectorSearchResult> hybridSearch({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    double similarityThreshold = 0.7,
    int maxResults = 5,
    double vectorWeight = 0.7, // 向量搜索权重
    double keywordWeight = 0.3, // 关键词搜索权重
  }) async {
    final startTime = DateTime.now();

    try {
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

      return VectorSearchResult(
        items: limitedResults,
        totalResults: combinedResults.length,
        searchTime: _calculateSearchTime(startTime),
      );
    } catch (e) {
      debugPrint('混合搜索失败: $e');
      return VectorSearchResult(
        items: [],
        error: e.toString(),
        totalResults: 0,
        searchTime: _calculateSearchTime(startTime),
      );
    }
  }

  /// 关键词搜索
  Future<List<SearchResultItem>> _keywordSearch(
    String query,
    int maxResults,
    String? knowledgeBaseId,
  ) async {
    try {
      final chunks = knowledgeBaseId != null
          ? await _database.searchChunksByKnowledgeBase(query, knowledgeBaseId)
          : await _database.searchChunks(query);

      // 获取文档标题
      final documentIds = chunks.map((c) => c.documentId).toSet();
      final documentTitles = await _getDocumentTitles(documentIds);

      return chunks
          .map(
            (chunk) => SearchResultItem(
              chunkId: chunk.id,
              documentId: chunk.documentId,
              content: chunk.content,
              similarity: _calculateKeywordSimilarity(query, chunk.content),
              chunkIndex: chunk.chunkIndex,
              documentTitle: documentTitles[chunk.documentId],
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

  /// 计算关键词相似度（简单实现）
  double _calculateKeywordSimilarity(String query, String content) {
    final queryWords = query.toLowerCase().split(RegExp(r'\s+'));
    final contentWords = content.toLowerCase().split(RegExp(r'\s+'));

    int matchCount = 0;
    for (final word in queryWords) {
      if (contentWords.contains(word)) {
        matchCount++;
      }
    }

    return queryWords.isEmpty ? 0.0 : matchCount / queryWords.length;
  }

  /// 合并向量搜索和关键词搜索结果
  List<SearchResultItem> _combineResults(
    List<SearchResultItem> vectorResults,
    List<SearchResultItem> keywordResults,
    double vectorWeight,
    double keywordWeight,
  ) {
    final Map<String, SearchResultItem> combinedMap = {};

    // 添加向量搜索结果
    for (final item in vectorResults) {
      combinedMap[item.chunkId] = SearchResultItem(
        chunkId: item.chunkId,
        documentId: item.documentId,
        content: item.content,
        similarity: item.similarity * vectorWeight,
        chunkIndex: item.chunkIndex,
        documentTitle: item.documentTitle,
        metadata: {...item.metadata, 'searchType': 'vector'},
      );
    }

    // 合并关键词搜索结果
    for (final item in keywordResults) {
      if (combinedMap.containsKey(item.chunkId)) {
        // 如果已存在，合并分数
        final existing = combinedMap[item.chunkId]!;
        combinedMap[item.chunkId] = SearchResultItem(
          chunkId: item.chunkId,
          documentId: item.documentId,
          content: item.content,
          similarity: existing.similarity + (item.similarity * keywordWeight),
          chunkIndex: item.chunkIndex,
          documentTitle: existing.documentTitle ?? item.documentTitle,
          metadata: {...existing.metadata, 'searchType': 'hybrid'},
        );
      } else {
        // 新结果，只有关键词分数
        combinedMap[item.chunkId] = SearchResultItem(
          chunkId: item.chunkId,
          documentId: item.documentId,
          content: item.content,
          similarity: item.similarity * keywordWeight,
          chunkIndex: item.chunkIndex,
          documentTitle: item.documentTitle,
          metadata: {...item.metadata, 'searchType': 'keyword'},
        );
      }
    }

    // 转换为列表并排序
    final results = combinedMap.values.toList();
    results.sort((a, b) => b.similarity.compareTo(a.similarity));

    return results;
  }

  /// 计算搜索耗时
  double _calculateSearchTime(DateTime startTime) {
    return DateTime.now().difference(startTime).inMilliseconds.toDouble();
  }

  /// 检查并清理不兼容的向量数据
  Future<void> cleanupIncompatibleVectors({
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
  }) async {
    try {
      debugPrint('🧹 开始清理不兼容的向量数据...');

      // 1. 生成一个测试向量来获取当前模型的维度
      final testResult = await _embeddingService.generateSingleEmbedding(
        text: "测试向量维度",
        config: config,
      );

      if (!testResult.isSuccess) {
        debugPrint('❌ 无法生成测试向量: ${testResult.error}');
        return;
      }

      final expectedDimension = testResult.embeddings.first.length;
      debugPrint('📏 当前嵌入模型维度: $expectedDimension');

      // 2. 获取所有有嵌入向量的文本块
      final chunks = knowledgeBaseId != null
          ? await _database.getEmbeddedChunksByKnowledgeBase(knowledgeBaseId)
          : await _database.getChunksWithEmbeddings();

      debugPrint('📊 检查 ${chunks.length} 个文本块的向量维度...');

      int incompatibleCount = 0;
      final incompatibleChunkIds = <String>[];

      // 3. 检查每个文本块的向量维度
      for (final chunk in chunks) {
        if (chunk.embedding != null && chunk.embedding!.isNotEmpty) {
          try {
            final embeddingList = jsonDecode(chunk.embedding!) as List;
            final chunkEmbedding = embeddingList
                .map((e) => (e as num).toDouble())
                .toList();

            if (chunkEmbedding.length != expectedDimension) {
              incompatibleCount++;
              incompatibleChunkIds.add(chunk.id);
              debugPrint(
                '⚠️ 文本块 ${chunk.id} 维度不匹配: ${chunkEmbedding.length} != $expectedDimension',
              );
            }
          } catch (e) {
            incompatibleCount++;
            incompatibleChunkIds.add(chunk.id);
            debugPrint('❌ 文本块 ${chunk.id} 向量解析失败: $e');
          }
        }
      }

      if (incompatibleCount > 0) {
        debugPrint('🗑️ 发现 $incompatibleCount 个不兼容的向量，开始清理...');

        // 4. 清理不兼容的向量数据（将embedding字段设为null）
        for (final chunkId in incompatibleChunkIds) {
          await _database.clearChunkEmbedding(chunkId);
        }

        debugPrint('✅ 清理完成，已清理 $incompatibleCount 个不兼容的向量');
        debugPrint('💡 建议：重新处理相关文档以生成兼容的嵌入向量');
      } else {
        debugPrint('✅ 所有向量维度都兼容');
      }
    } catch (e) {
      debugPrint('❌ 清理不兼容向量失败: $e');
    }
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

  /// 获取缓存的搜索结果
  VectorSearchResult? _getCachedResult(String cacheKey) {
    final timestamp = _cacheTimestamps[cacheKey];
    if (timestamp != null) {
      final now = DateTime.now();
      if (now.difference(timestamp) < _cacheExpiry) {
        return _searchCache[cacheKey];
      } else {
        // 缓存过期，清理
        _searchCache.remove(cacheKey);
        _cacheTimestamps.remove(cacheKey);
      }
    }
    return null;
  }

  /// 缓存搜索结果
  void _cacheResult(String cacheKey, VectorSearchResult result) {
    // 如果缓存已满，清理最旧的条目
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

  /// 清理所有缓存
  void clearCache() {
    _searchCache.clear();
    _cacheTimestamps.clear();
  }

  /// 优化的文本块查询方法
  Future<List<KnowledgeChunksTableData>> _getOptimizedChunks(
    String? knowledgeBaseId,
  ) async {
    // 使用更高效的查询，只获取必要的字段
    if (knowledgeBaseId != null) {
      return await _database.getEmbeddedChunksByKnowledgeBase(knowledgeBaseId);
    } else {
      return await _database.getChunksWithEmbeddings();
    }
  }

  /// 获取文档标题映射
  Future<Map<String, String>> _getDocumentTitles(
    Set<String> documentIds,
  ) async {
    try {
      final documents = await _database.getDocumentsByIds(documentIds.toList());
      return Map.fromEntries(
        documents.map((doc) => MapEntry(doc.id, doc.name)),
      );
    } catch (e) {
      debugPrint('获取文档标题失败: $e');
      return {};
    }
  }

  /// 优化的相似度计算方法
  Future<List<SearchResultItem>> _calculateSimilarityOptimized({
    required List<double> queryEmbedding,
    required List<KnowledgeChunksTableData> chunks,
    required double similarityThreshold,
    required int maxResults,
    required KnowledgeBaseConfig config,
    Map<String, String> documentTitles = const {},
  }) async {
    final results = <SearchResultItem>[];
    final allResults = <SearchResultItem>[]; // 存储所有结果，用于回退策略
    final allSimilarities = <double>[]; // 用于统计相似度分布
    int processedCount = 0;
    int skippedCount = 0;

    // 分批处理以提高性能
    const batchSize = 50;
    for (int i = 0; i < chunks.length; i += batchSize) {
      final end = (i + batchSize < chunks.length)
          ? i + batchSize
          : chunks.length;
      final batch = chunks.sublist(i, end);

      for (final chunk in batch) {
        if (chunk.embedding != null && chunk.embedding!.isNotEmpty) {
          try {
            // 解析嵌入向量
            final embeddingList = jsonDecode(chunk.embedding!) as List;
            final chunkEmbedding = embeddingList
                .map((e) => (e as num).toDouble())
                .toList();

            // 检查向量维度是否匹配
            if (queryEmbedding.length != chunkEmbedding.length) {
              skippedCount++;
              if (skippedCount <= 5) {
                // 只打印前5个错误，避免日志过多
                debugPrint(
                  '⚠️ 文本块 ${chunk.id} 向量维度不匹配: ${chunkEmbedding.length} != ${queryEmbedding.length}',
                );
              }
              continue;
            }

            // 计算相似度
            final similarity = _embeddingService.calculateCosineSimilarity(
              queryEmbedding,
              chunkEmbedding,
            );

            // 记录所有相似度值用于统计
            allSimilarities.add(similarity);

            // 创建搜索结果项
            final resultItem = SearchResultItem(
              chunkId: chunk.id,
              documentId: chunk.documentId,
              content: chunk.content,
              similarity: similarity,
              chunkIndex: chunk.chunkIndex,
              documentTitle: documentTitles[chunk.documentId],
              metadata: {
                'characterCount': chunk.characterCount,
                'tokenCount': chunk.tokenCount,
                'createdAt': chunk.createdAt.toIso8601String(),
              },
            );

            // 添加到所有结果列表
            allResults.add(resultItem);

            // 如果相似度超过阈值，添加到主结果中
            if (similarity >= similarityThreshold) {
              results.add(resultItem);
            }
            processedCount++;
          } catch (e) {
            debugPrint('解析文本块 ${chunk.id} 的嵌入向量失败: $e');
            continue;
          }
        }
      }

      // 如果已经找到足够的结果，可以提前退出（性能优化）
      if (results.length >= maxResults * 2) {
        debugPrint('🚀 提前退出：已找到足够的候选结果');
        break;
      }
    }

    if (skippedCount > 0) {
      debugPrint('⚠️ 跳过了 $skippedCount 个维度不匹配的向量');
      debugPrint('💡 建议：重新处理文档以生成兼容的嵌入向量');
    }

    // 打印相似度分布统计
    if (allSimilarities.isNotEmpty) {
      allSimilarities.sort((a, b) => b.compareTo(a)); // 降序排列
      final maxSim = allSimilarities.first;
      final minSim = allSimilarities.last;
      final avgSim =
          allSimilarities.reduce((a, b) => a + b) / allSimilarities.length;

      debugPrint('📊 相似度分布统计:');
      debugPrint('  - 总文档块数: ${allSimilarities.length}');
      debugPrint('  - 最高相似度: ${maxSim.toStringAsFixed(3)}');
      debugPrint('  - 最低相似度: ${minSim.toStringAsFixed(3)}');
      debugPrint('  - 平均相似度: ${avgSim.toStringAsFixed(3)}');
      debugPrint('  - 阈值: ${similarityThreshold.toStringAsFixed(3)}');
      debugPrint('  - 通过阈值的数量: ${results.length}');

      // 显示前5个最高相似度
      final top5 = allSimilarities.take(5).toList();
      debugPrint(
        '  - 前5个相似度: ${top5.map((s) => s.toStringAsFixed(3)).join(', ')}',
      );
    }

    debugPrint('📊 处理了 $processedCount 个文本块，找到 ${results.length} 个匹配结果');

    // 回退策略：如果没有找到超过阈值的结果，返回最相似的文本块
    if (results.isEmpty && allResults.isNotEmpty) {
      debugPrint('🔄 启用回退策略：没有找到超过阈值的结果，返回最相似的文本块');

      // 按相似度降序排序所有结果
      allResults.sort((a, b) => b.similarity.compareTo(a.similarity));

      // 返回配置中指定数量的最相似文本块
      final fallbackResults = allResults
          .take(config.maxRetrievedChunks)
          .toList();

      debugPrint('📋 回退结果: 返回前${fallbackResults.length}个最相似的文本块');
      for (int i = 0; i < fallbackResults.length; i++) {
        final result = fallbackResults[i];
        debugPrint(
          '📄 回退结果${i + 1}: 相似度=${result.similarity.toStringAsFixed(3)}, 内容长度=${result.content.length}',
        );
      }

      return fallbackResults;
    }

    return results;
  }
}
