import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:collection';

import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../data/models/embedding_model_config.dart';
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
      // 注意：维度配置目前需要在LLM配置层面设置，这里暂时不传递dimensions参数
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

  /// 为查询语句生成单个向量（模块化封装）
  /// 返回首个向量；失败或为空时返回 null
  Future<List<double>?> getQueryEmbedding({
    required String query,
    required KnowledgeBaseConfig config,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      if (query.trim().isEmpty) {
        debugPrint('⚠️ 空查询，跳过向量生成');
        return null;
      }

      final result = await generateSingleEmbedding(
        text: query,
        config: config,
      ).timeout(timeout, onTimeout: () {
        throw TimeoutException('查询向量生成超时');
      });

      if (!result.isSuccess || result.embeddings.isEmpty) {
        debugPrint('❌ 查询向量生成失败或为空: ${result.error ?? 'no-embedding'}');
        return null;
      }

      final embedding = result.embeddings.first;
      if (embedding.isEmpty) {
        debugPrint('⚠️ 查询向量为空');
        return null;
      }
      return embedding;
    } catch (e) {
      debugPrint('💥 getQueryEmbedding 异常: $e');
      return null;
    }
  }

  /// 批量为文本块生成嵌入向量（性能优化版）
  Future<EmbeddingGenerationResult> generateEmbeddingsForChunks({
    required List<String> chunks,
    required KnowledgeBaseConfig config,
    int batchSize = 32, // 增加批处理大小以提高性能
    int maxConcurrency = 3, // 最大并发批次数
    int maxRetries = 2, // 最大重试次数
  }) async {
    try {
      final allEmbeddings = <List<double>>[];
      final errors = <String>[];
      int successCount = 0;
      int failedCount = 0;

      // 获取模型配置以优化批处理大小
      final modelConfig = EmbeddingModelConfigs.getConfig(config.embeddingModelId);
      final optimizedBatchSize = _getOptimizedBatchSize(modelConfig, batchSize);

      debugPrint('🚀 开始批量嵌入向量生成：'
          '总数=${chunks.length}, '
          '批次大小=$optimizedBatchSize, '
          '并发数=$maxConcurrency');

      // 创建批次任务列表
      final batchTasks = <Future<BatchResult>>[];
      final semaphore = Semaphore(maxConcurrency);

      for (int i = 0; i < chunks.length; i += optimizedBatchSize) {
        final end = (i + optimizedBatchSize < chunks.length)
            ? i + optimizedBatchSize
            : chunks.length;
        final batch = chunks.sublist(i, end);
        final batchIndex = (i / optimizedBatchSize).floor() + 1;

        // 创建带信号量的批次处理任务
        final batchTask = semaphore.acquire().then((_) async {
          try {
            final result = await _processBatchWithRetry(
              batch: batch,
              config: config,
              batchIndex: batchIndex,
              maxRetries: maxRetries,
            );
            return result;
          } finally {
            semaphore.release();
          }
        });

        batchTasks.add(batchTask);
      }

      // 等待所有批次完成
      final batchResults = await Future.wait(batchTasks);

      // 合并结果
      for (final result in batchResults) {
        allEmbeddings.addAll(result.embeddings);
        successCount += result.successCount;
        failedCount += result.failedCount;
        if (result.error != null) {
          errors.add(result.error!);
        }
      }

      // 计算成功率
      final successRate = successCount / chunks.length;

      if (successCount > 0) {
        debugPrint(
          '✅ 嵌入服务高性能批量处理完成：'
          '成功 $successCount，失败 $failedCount，'
          '成功率 ${(successRate * 100).toStringAsFixed(1)}%',
        );

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

  /// 获取优化的批处理大小
  int _getOptimizedBatchSize(EmbeddingModelConfig? modelConfig, int defaultSize) {
    if (modelConfig == null) return defaultSize;
    
    // 根据不同提供商优化批处理大小
    switch (modelConfig.provider.toLowerCase()) {
      case 'openai':
        return math.min(64, defaultSize); // OpenAI支持较大批次
      case 'qwen':
      case 'doubao':
      case 'baidu':
        return math.min(32, defaultSize); // 国内厂商适中批次
      case 'jina':
      case 'voyageai':
        return math.min(48, defaultSize); // 专业嵌入服务可以较大批次
      case 'cohere':
        return math.min(96, defaultSize); // Cohere支持大批次
      default:
        return defaultSize;
    }
  }

  /// 带重试机制的批次处理
  Future<BatchResult> _processBatchWithRetry({
    required List<String> batch,
    required KnowledgeBaseConfig config,
    required int batchIndex,
    required int maxRetries,
  }) async {
    Exception? lastError;
    
    for (int retry = 0; retry <= maxRetries; retry++) {
      try {
        if (retry > 0) {
          // 重试前等待，使用指数退避
          final delay = Duration(milliseconds: 200 * math.pow(2, retry - 1).toInt());
          await Future.delayed(delay);
          debugPrint('🔄 批次 $batchIndex 重试第 $retry 次');
        }

        final result = await generateEmbeddings(texts: batch, config: config);

        if (result.isSuccess) {
          debugPrint('✅ 批次 $batchIndex 成功处理 ${batch.length} 个文本块');
          return BatchResult(
            embeddings: result.embeddings,
            successCount: batch.length,
            failedCount: 0,
          );
        } else {
          lastError = Exception(result.error);
          if (retry == maxRetries) {
            debugPrint('❌ 批次 $batchIndex 重试次数耗尽: ${result.error}');
          }
        }
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        if (retry == maxRetries) {
          debugPrint('❌ 批次 $batchIndex 重试次数耗尽，异常: $e');
        }
      }
    }

    // 所有重试都失败，返回空向量占位
    final emptyEmbeddings = List.generate(batch.length, (_) => <double>[]);
    return BatchResult(
      embeddings: emptyEmbeddings,
      successCount: 0,
      failedCount: batch.length,
      error: '批次 $batchIndex: ${lastError?.toString() ?? "未知错误"}',
    );
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
    double threshold = 0.3, // 降低默认阈值，提高召回率
    int maxResults = 5,
  }) {
    final results = <SimilarityResult>[];
    final allResults = <SimilarityResult>[]; // 存储所有结果，用于回退策略

    for (final chunk in chunks) {
      if (chunk.embedding.isNotEmpty) {
        final similarity = calculateCosineSimilarity(
          queryEmbedding,
          chunk.embedding,
        );

        final resultItem = SimilarityResult(
          chunkId: chunk.id,
          content: chunk.content,
          similarity: similarity,
          metadata: chunk.metadata,
        );

        // 添加到所有结果列表
        allResults.add(resultItem);

        // 如果相似度超过阈值，添加到主结果中
        if (similarity >= threshold) {
          results.add(resultItem);
        }
      }
    }

    // 按相似度降序排序
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    allResults.sort((a, b) => b.similarity.compareTo(a.similarity));

    // 回退策略：如果没有找到超过阈值的结果，返回最相似的文本块
    if (results.isEmpty && allResults.isNotEmpty) {
      debugPrint('🔄 启用回退策略：没有找到超过阈值的结果，返回最相似的文本块');
      final fallbackResults = allResults.take(maxResults).toList();
      debugPrint('📋 回退结果: 返回前${fallbackResults.length}个最相似的文本块');
      for (int i = 0; i < fallbackResults.length; i++) {
        final result = fallbackResults[i];
        debugPrint(
          '📄 回退结果${i + 1}: 相似度=${result.similarity.toStringAsFixed(3)}',
        );
      }
      return fallbackResults;
    }

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

/// 信号量类，用于控制并发数量
class Semaphore {
  final int maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this.maxCount) : _currentCount = maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
    }
  }
}

/// 批次处理结果
class BatchResult {
  final List<List<double>> embeddings;
  final int successCount;
  final int failedCount;
  final String? error;

  const BatchResult({
    required this.embeddings,
    required this.successCount,
    required this.failedCount,
    this.error,
  });
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
