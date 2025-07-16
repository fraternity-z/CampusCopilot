import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/rag_service.dart';
import '../../domain/services/vector_search_service.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../../../core/di/database_providers.dart';
import 'document_processing_provider.dart';

/// RAG服务Provider
final ragServiceProvider = Provider<RagService>((ref) {
  final database = ref.read(appDatabaseProvider);
  final embeddingService = ref.read(embeddingServiceProvider);
  final vectorSearchService = VectorSearchService(database, embeddingService);

  return RagService(database, vectorSearchService, embeddingService);
});

/// 知识库统计信息Provider
final knowledgeBaseStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final ragService = ref.read(ragServiceProvider);
  return ragService.getKnowledgeBaseStats();
});

/// RAG增强提示词Provider
final ragEnhancedPromptProvider =
    FutureProvider.family<RagEnhancedPrompt, RagPromptRequest>((
      ref,
      request,
    ) async {
      final ragService = ref.read(ragServiceProvider);

      return ragService.enhancePrompt(
        userQuery: request.query,
        config: request.config,
        knowledgeBaseId: request.knowledgeBaseId,
        similarityThreshold: request.similarityThreshold,
        maxContexts: request.maxContexts,
        systemPrompt: request.systemPrompt,
      );
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
