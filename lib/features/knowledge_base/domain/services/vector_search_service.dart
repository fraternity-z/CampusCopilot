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

  const SearchResultItem({
    required this.chunkId,
    required this.documentId,
    required this.content,
    required this.similarity,
    required this.chunkIndex,
    this.metadata = const {},
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

  VectorSearchService(this._database, this._embeddingService);

  /// 执行向量搜索
  Future<VectorSearchResult> search({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    double similarityThreshold = 0.7,
    int maxResults = 5,
  }) async {
    final startTime = DateTime.now();

    try {
      // 1. 为查询生成嵌入向量
      final queryEmbeddingResult = await _embeddingService
          .generateSingleEmbedding(text: query, config: config);

      if (!queryEmbeddingResult.isSuccess) {
        return VectorSearchResult(
          items: [],
          error: '生成查询嵌入向量失败: ${queryEmbeddingResult.error}',
          totalResults: 0,
          searchTime: _calculateSearchTime(startTime),
        );
      }

      final queryEmbedding = queryEmbeddingResult.embeddings.first;

      // 2. 获取指定知识库的有嵌入向量的文本块
      final chunks = knowledgeBaseId != null
          ? await _database.getEmbeddedChunksByKnowledgeBase(knowledgeBaseId)
          : await _database.getChunksWithEmbeddings();

      // 3. 计算相似度并筛选结果
      final results = <SearchResultItem>[];

      for (final chunk in chunks) {
        if (chunk.embedding != null && chunk.embedding!.isNotEmpty) {
          try {
            // 解析嵌入向量
            final embeddingList = jsonDecode(chunk.embedding!) as List;
            final chunkEmbedding = embeddingList
                .map((e) => (e as num).toDouble())
                .toList();

            // 计算相似度
            final similarity = _embeddingService.calculateCosineSimilarity(
              queryEmbedding,
              chunkEmbedding,
            );

            // 如果相似度超过阈值，添加到结果中
            if (similarity >= similarityThreshold) {
              results.add(
                SearchResultItem(
                  chunkId: chunk.id,
                  documentId: chunk.documentId,
                  content: chunk.content,
                  similarity: similarity,
                  chunkIndex: chunk.chunkIndex,
                  metadata: {
                    'characterCount': chunk.characterCount,
                    'tokenCount': chunk.tokenCount,
                    'createdAt': chunk.createdAt.toIso8601String(),
                  },
                ),
              );
            }
          } catch (e) {
            debugPrint('解析文本块 ${chunk.id} 的嵌入向量失败: $e');
            continue;
          }
        }
      }

      // 4. 按相似度降序排序
      results.sort((a, b) => b.similarity.compareTo(a.similarity));

      // 5. 限制结果数量
      final limitedResults = results.take(maxResults).toList();

      return VectorSearchResult(
        items: limitedResults,
        totalResults: results.length,
        searchTime: _calculateSearchTime(startTime),
      );
    } catch (e) {
      debugPrint('向量搜索失败: $e');
      return VectorSearchResult(
        items: [],
        error: e.toString(),
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

      return chunks
          .map(
            (chunk) => SearchResultItem(
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
}
