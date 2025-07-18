import 'package:flutter/foundation.dart';

import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../../../data/local/app_database.dart';
import 'dart:math' as math;

/// 嵌入结果
class EmbeddingGenerationResult {
  final List<List<double>> embeddings;
  final String? error;

  const EmbeddingGenerationResult({required this.embeddings, this.error});

  bool get isSuccess => error == null;
}

/// 嵌入服务
class EmbeddingService {
  final AppDatabase _database;

  // 提供者缓存，支持实时切换
  final Map<String, LlmProvider> _providerCache = {};

  // 缓存过期时间（5分钟）
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  EmbeddingService(this._database);

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
          error: '无法找到嵌入模型的配置，请检查知识库配置中的嵌入模型设置',
        );
      }

      debugPrint(
        '🔗 使用嵌入服务: ${llmConfig.provider} - ${llmConfig.baseUrl ?? '默认端点'}',
      );

      // 获取或创建LLM提供商（支持实时切换）
      final provider = _getOrCreateProvider(llmConfig);

      // 生成嵌入向量（添加超时处理）
      final result = await provider
          .generateEmbeddings(texts)
          .timeout(
            const Duration(minutes: 2), // 2分钟超时
            onTimeout: () {
              throw Exception('嵌入向量生成超时，请检查网络连接或API服务状态');
            },
          );

      return EmbeddingGenerationResult(embeddings: result.embeddings);
    } catch (e) {
      debugPrint('生成嵌入向量失败: $e');
      String errorMessage = e.toString();

      // 提供更友好的错误信息
      if (errorMessage.contains('SocketException')) {
        errorMessage = '网络连接失败，请检查网络设置或API服务地址是否正确';
      } else if (errorMessage.contains('TimeoutException') ||
          errorMessage.contains('超时')) {
        errorMessage = '请求超时，请检查网络连接或稍后重试';
      } else if (errorMessage.contains('401') ||
          errorMessage.contains('Unauthorized')) {
        errorMessage = 'API密钥无效，请检查嵌入模型的API密钥配置';
      } else if (errorMessage.contains('404')) {
        errorMessage = 'API端点不存在，请检查嵌入模型的API地址配置';
      }

      return EmbeddingGenerationResult(embeddings: [], error: errorMessage);
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
      final errors = <String>[];
      int successCount = 0;
      int failedCount = 0;

      // 分批处理以避免API限制
      for (int i = 0; i < chunks.length; i += batchSize) {
        final end = (i + batchSize < chunks.length)
            ? i + batchSize
            : chunks.length;
        final batch = chunks.sublist(i, end);

        try {
          final result = await generateEmbeddings(texts: batch, config: config);

          if (result.isSuccess) {
            allEmbeddings.addAll(result.embeddings);
            successCount += batch.length;
            debugPrint(
              '✅ 嵌入服务批次 ${(i / batchSize).floor() + 1} 成功处理 ${batch.length} 个文本块',
            );
          } else {
            // 批次失败，为每个文本块添加空向量占位
            for (int j = 0; j < batch.length; j++) {
              allEmbeddings.add([]); // 空向量表示失败
            }
            failedCount += batch.length;
            errors.add('批次 ${(i / batchSize).floor() + 1}: ${result.error}');
            debugPrint(
              '⚠️ 嵌入服务批次 ${(i / batchSize).floor() + 1} 失败: ${result.error}，跳过继续处理',
            );
          }
        } catch (batchError) {
          // 批次异常，为每个文本块添加空向量占位
          for (int j = 0; j < batch.length; j++) {
            allEmbeddings.add([]); // 空向量表示失败
          }
          failedCount += batch.length;
          errors.add('批次 ${(i / batchSize).floor() + 1} 异常: $batchError');
          debugPrint(
            '⚠️ 嵌入服务批次 ${(i / batchSize).floor() + 1} 异常: $batchError，跳过继续处理',
          );
        }

        // 添加延迟以避免API速率限制
        if (i + batchSize < chunks.length) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      // 计算成功率
      final successRate = successCount / chunks.length;

      if (successCount > 0) {
        debugPrint(
          '✅ 嵌入服务批量处理完成：成功 $successCount，失败 $failedCount，成功率 ${(successRate * 100).toStringAsFixed(1)}%',
        );

        // 即使有部分失败，只要有成功的就返回成功结果
        return EmbeddingGenerationResult(
          embeddings: allEmbeddings,
          error: errors.isNotEmpty ? '部分失败: ${errors.join('; ')}' : null,
        );
      } else {
        debugPrint('❌ 嵌入服务批量处理全部失败');
        return EmbeddingGenerationResult(
          embeddings: [],
          error: '所有批次都失败: ${errors.join('; ')}',
        );
      }
    } catch (e) {
      debugPrint('❌ 嵌入服务批量生成异常: $e');
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

    return dotProduct / (math.sqrt(norm1) * math.sqrt(norm2));
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

  /// 获取或创建LLM提供商（支持实时切换）
  LlmProvider _getOrCreateProvider(LlmConfig config) {
    final cacheKey =
        '${config.provider}_${config.id}_${config.updatedAt.millisecondsSinceEpoch}';
    final now = DateTime.now();

    // 检查缓存是否存在且未过期
    final cachedProvider = _providerCache[cacheKey];
    final cacheTime = _cacheTimestamps[cacheKey];

    if (cachedProvider != null &&
        cacheTime != null &&
        now.difference(cacheTime) < _cacheExpiry) {
      debugPrint('🚀 使用缓存的嵌入提供者: ${config.provider}');
      return cachedProvider;
    }

    // 清理过期的缓存
    _cleanExpiredCache();

    // 创建新的提供者
    debugPrint('🔄 创建新的嵌入提供者: ${config.provider}');
    final provider = LlmProviderFactory.createProvider(config);

    // 缓存新的提供者
    _providerCache[cacheKey] = provider;
    _cacheTimestamps[cacheKey] = now;

    return provider;
  }

  /// 清理过期的缓存
  void _cleanExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) >= _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _providerCache.remove(key);
      _cacheTimestamps.remove(key);
    }

    if (expiredKeys.isNotEmpty) {
      debugPrint('🧹 清理了 ${expiredKeys.length} 个过期的嵌入提供者缓存');
    }
  }

  /// 清除所有缓存（用于强制刷新）
  void clearCache() {
    _providerCache.clear();
    _cacheTimestamps.clear();
    debugPrint('🧹 已清除所有嵌入提供者缓存');
  }

  /// 获取嵌入模型的LLM配置
  Future<LlmConfig?> _getLlmConfigForEmbedding(
    KnowledgeBaseConfig config,
  ) async {
    try {
      debugPrint('🔍 查找嵌入模型配置: ${config.embeddingModelProvider}');

      // 根据提供商查找对应的LLM配置
      final allConfigs = await _database.getEnabledLlmConfigs();

      // 查找匹配的提供商配置
      LlmConfigsTableData? matchingConfig;
      for (final llmConfig in allConfigs) {
        if (llmConfig.provider.toLowerCase() ==
            config.embeddingModelProvider.toLowerCase()) {
          matchingConfig = llmConfig;
          break;
        }
      }

      if (matchingConfig == null) {
        debugPrint('❌ 未找到匹配的LLM配置: ${config.embeddingModelProvider}');
        return null;
      }

      debugPrint('✅ 找到匹配的LLM配置: ${matchingConfig.name}');

      // 转换为LlmConfig对象
      return LlmConfig(
        id: matchingConfig.id,
        name: matchingConfig.name,
        provider: matchingConfig.provider,
        apiKey: matchingConfig.apiKey,
        baseUrl: matchingConfig.baseUrl,
        defaultModel: matchingConfig.defaultModel,
        defaultEmbeddingModel: config.embeddingModelId, // 使用知识库配置中指定的嵌入模型
        organizationId: matchingConfig.organizationId,
        projectId: matchingConfig.projectId,
        createdAt: matchingConfig.createdAt,
        updatedAt: matchingConfig.updatedAt,
        isEnabled: matchingConfig.isEnabled,
        isCustomProvider: matchingConfig.isCustomProvider,
        apiCompatibilityType: matchingConfig.apiCompatibilityType,
        customProviderName: matchingConfig.customProviderName,
        customProviderDescription: matchingConfig.customProviderDescription,
        customProviderIcon: matchingConfig.customProviderIcon,
      );
    } catch (e) {
      debugPrint('💥 获取嵌入模型配置失败: $e');
      return null;
    }
  }

  // 自定义 sqrt 已删除，统一使用 math.sqrt
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
