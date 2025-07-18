import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/rag_service.dart';
import '../../domain/services/vector_search_service.dart';
import '../../domain/services/enhanced_rag_service.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../data/providers/enhanced_rag_provider.dart';
import '../../../../core/di/database_providers.dart';
import 'document_processing_provider.dart';

/// 统一 RAG 服务提供者
///
/// 优先使用增强 RAG 服务，如果失败则回退到传统 RAG 服务
final unifiedRagServiceProvider = FutureProvider<dynamic>((ref) async {
  try {
    // 优先尝试使用增强 RAG 服务
    final enhancedRagService = await ref.watch(
      enhancedRagServiceProvider.future,
    );
    debugPrint('✅ 使用增强 RAG 服务（ObjectBox）');
    return enhancedRagService;
  } catch (e) {
    debugPrint('❌ 增强 RAG 服务创建失败: $e');
    debugPrint('🔄 回退到传统 RAG 服务...');

    try {
      // 回退到传统 RAG 服务
      final database = ref.read(appDatabaseProvider);
      final embeddingService = ref.read(embeddingServiceProvider);
      final vectorSearchService = VectorSearchService(
        database,
        embeddingService,
      );
      final fallbackService = RagService(
        database,
        vectorSearchService,
        embeddingService,
      );

      debugPrint('✅ 使用传统 RAG 服务（SQLite）');
      return fallbackService;
    } catch (fallbackError) {
      debugPrint('❌ 传统 RAG 服务也创建失败: $fallbackError');
      rethrow;
    }
  }
});

/// 传统 RAG 服务提供者（保持向后兼容）
final ragServiceProvider = Provider<RagService>((ref) {
  final database = ref.read(appDatabaseProvider);
  final embeddingService = ref.read(embeddingServiceProvider);
  final vectorSearchService = VectorSearchService(database, embeddingService);

  return RagService(database, vectorSearchService, embeddingService);
});

/// 统一知识库统计信息提供者
final unifiedKnowledgeBaseStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  try {
    final ragService = await ref.watch(unifiedRagServiceProvider.future);

    if (ragService is EnhancedRagService) {
      return await ragService.getKnowledgeBaseStats();
    } else if (ragService is RagService) {
      return ragService.getKnowledgeBaseStats();
    } else {
      return {
        'error': '未知的 RAG 服务类型',
        'serviceType': ragService.runtimeType.toString(),
      };
    }
  } catch (e) {
    debugPrint('❌ 获取知识库统计失败: $e');
    return {'error': e.toString(), 'totalDocuments': 0, 'totalChunks': 0};
  }
});

/// 传统知识库统计信息提供者（已迁移到统一Provider）
///
/// 注意：此Provider已弃用，请使用 unifiedKnowledgeBaseStatsProvider
@Deprecated('使用 unifiedKnowledgeBaseStatsProvider 替代')
final knowledgeBaseStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  // 重定向到统一Provider以保持向后兼容
  return ref.watch(unifiedKnowledgeBaseStatsProvider.future);
});

/// 统一RAG增强提示词Provider
///
/// 使用统一RAG服务，自动选择最佳可用版本
final unifiedRagEnhancedPromptProvider =
    FutureProvider.family<dynamic, RagPromptRequest>((ref, request) async {
      final ragService = await ref.read(unifiedRagServiceProvider.future);

      if (ragService is RagService) {
        return ragService.enhancePrompt(
          userQuery: request.query,
          config: request.config,
          knowledgeBaseId: request.knowledgeBaseId,
          similarityThreshold: request.similarityThreshold,
          maxContexts: request.maxContexts,
          systemPrompt: request.systemPrompt,
        );
      } else if (ragService is EnhancedRagService) {
        return ragService.enhancePrompt(
          userQuery: request.query,
          config: request.config,
          knowledgeBaseId: request.knowledgeBaseId,
          similarityThreshold: request.similarityThreshold,
          maxContexts: request.maxContexts,
          systemPrompt: request.systemPrompt,
        );
      } else {
        throw Exception('未知的RAG服务类型: ${ragService.runtimeType}');
      }
    });

/// RAG增强提示词Provider（已迁移到统一Provider）
///
/// 注意：此Provider已弃用，请使用 unifiedRagEnhancedPromptProvider
@Deprecated('使用 unifiedRagEnhancedPromptProvider 替代')
final ragEnhancedPromptProvider =
    FutureProvider.family<RagEnhancedPrompt, RagPromptRequest>((
      ref,
      request,
    ) async {
      final result = await ref.read(
        unifiedRagEnhancedPromptProvider(request).future,
      );

      // 如果是传统RAG结果，直接返回
      if (result is RagEnhancedPrompt) {
        return result;
      }

      // 如果是增强RAG结果，转换为传统格式
      if (result is EnhancedRagPrompt) {
        // 将字符串上下文转换为RagContextItem
        final contextItems = result.contexts
            .map(
              (context) => RagContextItem(
                chunkId: 'enhanced_${DateTime.now().millisecondsSinceEpoch}',
                documentId: 'unknown',
                content: context,
                similarity: 1.0, // 增强RAG不提供相似度信息
              ),
            )
            .toList();

        return RagEnhancedPrompt(
          enhancedPrompt: result.enhancedPrompt,
          usedContexts: contextItems,
          originalQuery: request.query,
        );
      }

      throw Exception('未知的RAG结果类型: ${result.runtimeType}');
    });

/// RAG提示词请求参数
class RagPromptRequest {
  final String query;
  final KnowledgeBaseConfig config;
  final String? knowledgeBaseId;
  final double similarityThreshold;
  final int maxContexts;
  final String? systemPrompt;

  const RagPromptRequest({
    required this.query,
    required this.config,
    this.knowledgeBaseId,
    this.similarityThreshold = 0.7,
    this.maxContexts = 3,
    this.systemPrompt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RagPromptRequest &&
        other.query == query &&
        other.config == config &&
        other.knowledgeBaseId == knowledgeBaseId &&
        other.similarityThreshold == similarityThreshold &&
        other.maxContexts == maxContexts &&
        other.systemPrompt == systemPrompt;
  }

  @override
  int get hashCode {
    return Object.hash(
      query,
      config,
      knowledgeBaseId,
      similarityThreshold,
      maxContexts,
      systemPrompt,
    );
  }
}
