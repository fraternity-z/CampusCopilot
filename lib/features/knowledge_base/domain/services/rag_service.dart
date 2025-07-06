import 'package:flutter/foundation.dart';

import '../../../../data/local/app_database.dart';
import '../entities/knowledge_document.dart';
import 'vector_search_service.dart';
import 'embedding_service.dart';

/// RAG上下文项
class RagContextItem {
  final String chunkId;
  final String documentId;
  final String content;
  final double similarity;
  final Map<String, dynamic> metadata;

  const RagContextItem({
    required this.chunkId,
    required this.documentId,
    required this.content,
    required this.similarity,
    this.metadata = const {},
  });
}

/// RAG检索结果
class RagRetrievalResult {
  final List<RagContextItem> contexts;
  final String? error;
  final double searchTime;
  final int totalResults;

  const RagRetrievalResult({
    required this.contexts,
    this.error,
    required this.searchTime,
    required this.totalResults,
  });

  bool get isSuccess => error == null;
}

/// RAG增强结果
class RagEnhancedPrompt {
  final String enhancedPrompt;
  final List<RagContextItem> usedContexts;
  final String originalQuery;

  const RagEnhancedPrompt({
    required this.enhancedPrompt,
    required this.usedContexts,
    required this.originalQuery,
  });
}

/// RAG服务
class RagService {
  final AppDatabase _database;
  final VectorSearchService _vectorSearchService;
  final EmbeddingService _embeddingService;

  RagService(this._database, this._vectorSearchService, this._embeddingService);

  /// 检索相关上下文
  Future<RagRetrievalResult> retrieveContext({
    required String query,
    required KnowledgeBaseConfig config,
    double similarityThreshold = 0.7,
    int maxResults = 5,
  }) async {
    try {
      final startTime = DateTime.now();

      // 使用向量搜索检索相关内容
      final searchResult = await _vectorSearchService.hybridSearch(
        query: query,
        config: config,
        similarityThreshold: similarityThreshold,
        maxResults: maxResults,
      );

      if (!searchResult.isSuccess) {
        return RagRetrievalResult(
          contexts: [],
          error: searchResult.error,
          searchTime: searchResult.searchTime,
          totalResults: 0,
        );
      }

      // 转换为RAG上下文项
      final contexts = searchResult.items
          .map(
            (item) => RagContextItem(
              chunkId: item.chunkId,
              documentId: item.documentId,
              content: item.content,
              similarity: item.similarity,
              metadata: item.metadata,
            ),
          )
          .toList();

      return RagRetrievalResult(
        contexts: contexts,
        searchTime: DateTime.now()
            .difference(startTime)
            .inMilliseconds
            .toDouble(),
        totalResults: contexts.length,
      );
    } catch (e) {
      debugPrint('RAG检索失败: $e');
      return RagRetrievalResult(
        contexts: [],
        error: e.toString(),
        searchTime: 0,
        totalResults: 0,
      );
    }
  }

  /// 增强用户提示词
  Future<RagEnhancedPrompt> enhancePrompt({
    required String userQuery,
    required KnowledgeBaseConfig config,
    double similarityThreshold = 0.7,
    int maxContexts = 3,
    String? systemPrompt,
  }) async {
    try {
      // 检索相关上下文
      final retrievalResult = await retrieveContext(
        query: userQuery,
        config: config,
        similarityThreshold: similarityThreshold,
        maxResults: maxContexts,
      );

      if (!retrievalResult.isSuccess || retrievalResult.contexts.isEmpty) {
        // 没有找到相关上下文，返回原始查询
        return RagEnhancedPrompt(
          enhancedPrompt: userQuery,
          usedContexts: [],
          originalQuery: userQuery,
        );
      }

      // 构建增强的提示词
      final enhancedPrompt = _buildEnhancedPrompt(
        userQuery: userQuery,
        contexts: retrievalResult.contexts,
        systemPrompt: systemPrompt,
      );

      return RagEnhancedPrompt(
        enhancedPrompt: enhancedPrompt,
        usedContexts: retrievalResult.contexts,
        originalQuery: userQuery,
      );
    } catch (e) {
      debugPrint('增强提示词失败: $e');
      return RagEnhancedPrompt(
        enhancedPrompt: userQuery,
        usedContexts: [],
        originalQuery: userQuery,
      );
    }
  }

  /// 构建增强的提示词
  String _buildEnhancedPrompt({
    required String userQuery,
    required List<RagContextItem> contexts,
    String? systemPrompt,
  }) {
    final buffer = StringBuffer();

    // 添加系统提示词
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      buffer.writeln(systemPrompt);
      buffer.writeln();
    }

    // 添加上下文信息
    if (contexts.isNotEmpty) {
      buffer.writeln('以下是相关的背景信息，请基于这些信息回答用户的问题：');
      buffer.writeln();

      for (int i = 0; i < contexts.length; i++) {
        final context = contexts[i];
        buffer.writeln('【参考资料${i + 1}】');
        buffer.writeln(context.content.trim());
        buffer.writeln();
      }

      buffer.writeln('---');
      buffer.writeln();
    }

    // 添加用户查询
    buffer.writeln('用户问题：$userQuery');

    // 添加回答指导
    if (contexts.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('请基于上述参考资料回答问题。如果参考资料中没有相关信息，请明确说明。');
    }

    return buffer.toString();
  }

  /// 判断查询是否需要RAG增强
  bool shouldUseRag(String query) {
    // 简单的启发式规则判断是否需要使用RAG
    final lowerQuery = query.toLowerCase();

    // 包含疑问词的查询通常需要RAG
    final questionWords = [
      '什么',
      '如何',
      '怎么',
      '为什么',
      '哪里',
      '什么时候',
      '谁',
      'what',
      'how',
      'why',
      'where',
      'when',
      'who',
      'which',
    ];

    for (final word in questionWords) {
      if (lowerQuery.contains(word)) {
        return true;
      }
    }

    // 包含特定关键词的查询
    final knowledgeKeywords = [
      '解释',
      '说明',
      '介绍',
      '定义',
      '原理',
      '方法',
      '步骤',
      'explain',
      'describe',
      'define',
      'principle',
      'method',
    ];

    for (final keyword in knowledgeKeywords) {
      if (lowerQuery.contains(keyword)) {
        return true;
      }
    }

    // 查询长度超过一定阈值
    if (query.length > 10) {
      return true;
    }

    return false;
  }

  /// 获取文档统计信息
  Future<Map<String, dynamic>> getKnowledgeBaseStats() async {
    try {
      final documents = await _database.getAllKnowledgeDocuments();
      final chunks = await _database.getChunksWithEmbeddings();

      final completedDocs = documents
          .where((doc) => doc.status == 'completed')
          .length;
      final processingDocs = documents
          .where((doc) => doc.status == 'processing')
          .length;
      final failedDocs = documents
          .where((doc) => doc.status == 'failed')
          .length;

      return {
        'totalDocuments': documents.length,
        'completedDocuments': completedDocs,
        'processingDocuments': processingDocs,
        'failedDocuments': failedDocs,
        'totalChunks': chunks.length,
        'chunksWithEmbeddings': chunks
            .where((c) => c.embedding?.isNotEmpty == true)
            .length,
      };
    } catch (e) {
      debugPrint('获取知识库统计信息失败: $e');
      return {};
    }
  }

  /// 清理过期的嵌入向量缓存
  Future<void> cleanupEmbeddingCache() async {
    try {
      // 获取所有带有嵌入向量的文本块
      final chunks = await _database.getChunksWithEmbeddings();

      if (chunks.isEmpty) return;

      final now = DateTime.now();
      final expiredChunks = <String>[];
      final oldChunks = <String>[];

      for (final chunk in chunks) {
        // 检查最后更新时间
        final daysSinceCreated = now.difference(chunk.createdAt).inDays;

        // 超过6个月未使用的块标记为过期
        if (daysSinceCreated > 180) {
          expiredChunks.add(chunk.id);
        }
        // 超过3个月的块标记为旧块（可选择性清理）
        else if (daysSinceCreated > 90) {
          oldChunks.add(chunk.id);
        }
      }

      debugPrint(
        '嵌入向量缓存清理: 发现${expiredChunks.length}个过期块, ${oldChunks.length}个旧块',
      );

      // 删除过期的嵌入向量
      for (final chunkId in expiredChunks) {
        await _database.updateChunkEmbedding(chunkId, '');
      }

      // 根据存储空间压力决定是否清理旧块
      if (chunks.length > 10000) {
        // 如果总块数超过1万个
        // 清理一半的旧块
        final toRemove = oldChunks.take(oldChunks.length ~/ 2);
        for (final chunkId in toRemove) {
          await _database.updateChunkEmbedding(chunkId, '');
        }
        debugPrint('由于存储压力，额外清理了${toRemove.length}个旧块');
      }

      debugPrint('嵌入向量缓存清理完成: 清理了${expiredChunks.length}个过期块');
    } catch (e) {
      debugPrint('清理嵌入向量缓存失败: $e');
    }
  }

  /// 重新生成所有文档的嵌入向量
  Future<void> regenerateAllEmbeddings(KnowledgeBaseConfig config) async {
    try {
      // 获取所有文本块
      final chunks = await _database.getChunksWithEmbeddings();

      // 分批重新生成嵌入向量
      const batchSize = 10;
      for (int i = 0; i < chunks.length; i += batchSize) {
        final end = (i + batchSize < chunks.length)
            ? i + batchSize
            : chunks.length;
        final batch = chunks.sublist(i, end);

        final texts = batch.map((chunk) => chunk.content).toList();
        final result = await _embeddingService.generateEmbeddings(
          texts: texts,
          config: config,
        );

        if (result.isSuccess) {
          // 更新数据库中的嵌入向量
          for (int j = 0; j < batch.length; j++) {
            if (j < result.embeddings.length) {
              final embeddingJson = result.embeddings[j].toString();
              await _database.updateChunkEmbedding(batch[j].id, embeddingJson);
            }
          }
        }

        // 添加延迟避免API限制
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      debugPrint('重新生成嵌入向量失败: $e');
      rethrow;
    }
  }
}
