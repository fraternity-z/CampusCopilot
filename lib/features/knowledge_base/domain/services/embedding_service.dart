import 'package:flutter/foundation.dart';

import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../domain/entities/knowledge_document.dart';

/// 嵌入结果
class EmbeddingGenerationResult {
  final List<List<double>> embeddings;
  final String? error;

  const EmbeddingGenerationResult({required this.embeddings, this.error});

  bool get isSuccess => error == null;
}

/// 嵌入服务
class EmbeddingService {
  /// 为文本块生成嵌入向量
  Future<EmbeddingGenerationResult> generateEmbeddings({
    required List<String> texts,
    required KnowledgeBaseConfig config,
  }) async {
    try {
      if (texts.isEmpty) {
        return const EmbeddingGenerationResult(embeddings: []);
      }

      // 获取嵌入模型的LLM配置
      final llmConfig = await _getLlmConfigForEmbedding(config);
      if (llmConfig == null) {
        return const EmbeddingGenerationResult(
          embeddings: [],
          error: '无法找到嵌入模型的配置',
        );
      }

      // 创建LLM提供商（非空）
      final provider = LlmProviderFactory.createProvider(llmConfig);

      // 生成嵌入向量
      final result = await provider.generateEmbeddings(texts);

      return EmbeddingGenerationResult(embeddings: result.embeddings);
    } catch (e) {
      debugPrint('生成嵌入向量失败: $e');
      return EmbeddingGenerationResult(embeddings: [], error: e.toString());
    }
  }

  /// 为单个文本生成嵌入向量
  Future<EmbeddingGenerationResult> generateSingleEmbedding({
    required String text,
    required KnowledgeBaseConfig config,
  }) async {
    return generateEmbeddings(texts: [text], config: config);
  }

  /// 批量为文本块生成嵌入向量
  Future<EmbeddingGenerationResult> generateEmbeddingsForChunks({
    required List<String> chunks,
    required KnowledgeBaseConfig config,
    int batchSize = 10, // 批处理大小
  }) async {
    try {
      final allEmbeddings = <List<double>>[];

      // 分批处理以避免API限制
      for (int i = 0; i < chunks.length; i += batchSize) {
        final end = (i + batchSize < chunks.length)
            ? i + batchSize
            : chunks.length;
        final batch = chunks.sublist(i, end);

        final result = await generateEmbeddings(texts: batch, config: config);

        if (!result.isSuccess) {
          return EmbeddingGenerationResult(embeddings: [], error: result.error);
        }

        allEmbeddings.addAll(result.embeddings);

        // 添加延迟以避免API速率限制
        if (i + batchSize < chunks.length) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      return EmbeddingGenerationResult(embeddings: allEmbeddings);
    } catch (e) {
      debugPrint('批量生成嵌入向量失败: $e');
      return EmbeddingGenerationResult(embeddings: [], error: e.toString());
    }
  }

  /// 计算向量相似度（余弦相似度）
  double calculateCosineSimilarity(List<double> vector1, List<double> vector2) {
    if (vector1.length != vector2.length) {
      throw ArgumentError('向量维度不匹配');
    }

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < vector1.length; i++) {
      dotProduct += vector1[i] * vector2[i];
      norm1 += vector1[i] * vector1[i];
      norm2 += vector2[i] * vector2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) {
      return 0.0;
    }

    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  /// 搜索相似文本块
  List<SimilarityResult> searchSimilarChunks({
    required List<double> queryEmbedding,
    required List<ChunkWithEmbedding> chunks,
    double threshold = 0.7,
    int maxResults = 5,
  }) {
    final results = <SimilarityResult>[];

    for (final chunk in chunks) {
      if (chunk.embedding.isNotEmpty) {
        final similarity = calculateCosineSimilarity(
          queryEmbedding,
          chunk.embedding,
        );

        if (similarity >= threshold) {
          results.add(
            SimilarityResult(
              chunkId: chunk.id,
              content: chunk.content,
              similarity: similarity,
              metadata: chunk.metadata,
            ),
          );
        }
      }
    }

    // 按相似度降序排序
    results.sort((a, b) => b.similarity.compareTo(a.similarity));

    // 返回前N个结果
    return results.take(maxResults).toList();
  }

  /// 获取嵌入模型的LLM配置
  Future<LlmConfig?> _getLlmConfigForEmbedding(
    KnowledgeBaseConfig config,
  ) async {
    // 这里需要根据嵌入模型的提供商创建对应的LLM配置
    // 实际实现中应该从数据库或配置中获取

    // 临时实现：根据提供商类型创建基本配置
    switch (config.embeddingModelProvider.toLowerCase()) {
      case 'openai':
        return LlmConfig(
          id: 'embedding-openai',
          name: 'OpenAI Embedding',
          provider: 'openai',
          apiKey: '', // 需要从实际配置中获取
          defaultEmbeddingModel: config.embeddingModelId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      case 'google':
        return LlmConfig(
          id: 'embedding-google',
          name: 'Google Embedding',
          provider: 'google',
          apiKey: '', // 需要从实际配置中获取
          defaultEmbeddingModel: config.embeddingModelId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      default:
        return null;
    }
  }

  /// 平方根函数
  double sqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0) return 0;

    double guess = x / 2;
    double prev = 0;

    while ((guess - prev).abs() > 0.0001) {
      prev = guess;
      guess = (guess + x / guess) / 2;
    }

    return guess;
  }
}

/// 带嵌入向量的文本块
class ChunkWithEmbedding {
  final String id;
  final String content;
  final List<double> embedding;
  final Map<String, dynamic> metadata;

  const ChunkWithEmbedding({
    required this.id,
    required this.content,
    required this.embedding,
    this.metadata = const {},
  });
}

/// 相似度搜索结果
class SimilarityResult {
  final String chunkId;
  final String content;
  final double similarity;
  final Map<String, dynamic> metadata;

  const SimilarityResult({
    required this.chunkId,
    required this.content,
    required this.similarity,
    this.metadata = const {},
  });
}
