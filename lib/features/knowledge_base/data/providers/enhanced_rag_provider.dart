import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/enhanced_rag_service.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../../../core/di/database_providers.dart';
import 'enhanced_vector_search_provider.dart';

/// 增强 RAG 服务提供者
///
/// 使用增强向量搜索服务创建 RAG 服务
final enhancedRagServiceProvider = FutureProvider<EnhancedRagService>((
  ref,
) async {
  try {
    debugPrint('🤖 创建增强 RAG 服务...');

    // 获取依赖
    final database = ref.read(appDatabaseProvider);
    final enhancedVectorSearchService = await ref.watch(
      enhancedVectorSearchServiceProvider.future,
    );

    // 创建服务实例
    final service = EnhancedRagService(database, enhancedVectorSearchService);

    debugPrint('✅ 增强 RAG 服务创建成功');
    return service;
  } catch (e) {
    debugPrint('❌ 创建增强 RAG 服务失败: $e');
    rethrow;
  }
});

/// 增强知识库统计信息提供者
final enhancedKnowledgeBaseStatsProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async {
    try {
      final ragService = await ref.watch(enhancedRagServiceProvider.future);
      return await ragService.getKnowledgeBaseStats();
    } catch (e) {
      debugPrint('❌ 获取增强知识库统计失败: $e');
      return <String, dynamic>{
        'error': e.toString(),
        'totalDocuments': 0,
        'totalChunks': 0,
        'vectorDimension': 0,
      };
    }
  },
);

/// 增强 RAG 提示词提供者
final enhancedRagPromptProvider =
    FutureProvider.family<EnhancedRagPrompt, EnhancedRagPromptRequest>((
      ref,
      request,
    ) async {
      try {
        final ragService = await ref.watch(enhancedRagServiceProvider.future);

        return ragService.enhancePrompt(
          userQuery: request.query,
          config: request.config,
          knowledgeBaseId: request.knowledgeBaseId,
          similarityThreshold: request.similarityThreshold,
          maxContexts: request.maxContexts,
          systemPrompt: request.systemPrompt,
        );
      } catch (e) {
        debugPrint('❌ 增强 RAG 提示词生成失败: $e');
        return EnhancedRagPrompt(
          enhancedPrompt: request.systemPrompt ?? '',
          contexts: [],
          totalTokens: 0,
          retrievalTime: 0.0,
          error: e.toString(),
        );
      }
    });

/// 增强 RAG 提示词请求参数
class EnhancedRagPromptRequest {
  final String query;
  final KnowledgeBaseConfig config;
  final String? knowledgeBaseId;
  final double similarityThreshold;
  final int maxContexts;
  final String? systemPrompt;

  const EnhancedRagPromptRequest({
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
    return other is EnhancedRagPromptRequest &&
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
