import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'dart:convert';

import '../../domain/services/document_processing_service.dart';
import '../../domain/services/embedding_service.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import 'knowledge_base_config_provider.dart';

/// 文档处理状态
class DocumentProcessingState {
  final Map<String, double> processingProgress; // 文档ID -> 进度
  final Map<String, String?> processingErrors; // 文档ID -> 错误信息
  final bool isProcessing;

  const DocumentProcessingState({
    this.processingProgress = const {},
    this.processingErrors = const {},
    this.isProcessing = false,
  });

  DocumentProcessingState copyWith({
    Map<String, double>? processingProgress,
    Map<String, String?>? processingErrors,
    bool? isProcessing,
  }) {
    return DocumentProcessingState(
      processingProgress: processingProgress ?? this.processingProgress,
      processingErrors: processingErrors ?? this.processingErrors,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

/// 文档处理管理器
class DocumentProcessingNotifier
    extends StateNotifier<DocumentProcessingState> {
  final AppDatabase _database;
  final DocumentProcessingService _processingService;
  final EmbeddingService _embeddingService;
  final Ref _ref;

  DocumentProcessingNotifier(
    this._database,
    this._processingService,
    this._embeddingService,
    this._ref,
  ) : super(const DocumentProcessingState());

  /// 处理单个文档
  Future<void> processDocument({
    required String documentId,
    required String filePath,
    required String fileType,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      // 更新处理状态
      _updateProgress(documentId, 0.0);
      _updateDocumentStatus(documentId, 'processing');

      // 处理文档
      final result = await _processingService.processDocument(
        documentId: documentId,
        filePath: filePath,
        fileType: fileType,
        chunkSize: chunkSize,
        chunkOverlap: chunkOverlap,
      );

      if (result.isSuccess) {
        // 保存文本块到数据库
        _updateProgress(documentId, 0.4);
        await _saveChunksToDatabase(documentId, result.chunks);

        // 生成嵌入向量
        _updateProgress(documentId, 0.6);
        await _generateEmbeddingsForChunks(documentId, result.chunks);

        // 更新文档状态
        _updateProgress(documentId, 1.0);
        await _updateDocumentStatus(documentId, 'completed');
        await _updateDocumentMetadata(documentId, result.metadata);

        // 清除进度信息
        _clearProgress(documentId);
      } else {
        // 处理失败
        await _updateDocumentStatus(documentId, 'failed', result.error);
        _updateError(documentId, result.error);
      }
    } catch (e) {
      await _updateDocumentStatus(documentId, 'failed', e.toString());
      _updateError(documentId, e.toString());
    }
  }

  /// 批量处理文档
  Future<void> processAllPendingDocuments({
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      state = state.copyWith(isProcessing: true);

      // 获取待处理的文档
      final pendingDocs = await _database.getDocumentsByStatus('pending');

      for (final doc in pendingDocs) {
        await processDocument(
          documentId: doc.id,
          filePath: doc.filePath,
          fileType: doc.type,
          chunkSize: chunkSize,
          chunkOverlap: chunkOverlap,
        );
      }
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  /// 重新处理文档
  Future<void> reprocessDocument({
    required String documentId,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      // 删除现有的文本块
      await _database.deleteChunksByDocument(documentId);

      // 获取文档信息
      final doc = await _database.getAllKnowledgeDocuments().then(
        (docs) => docs.where((d) => d.id == documentId).firstOrNull,
      );

      if (doc != null) {
        await processDocument(
          documentId: documentId,
          filePath: doc.filePath,
          fileType: doc.type,
          chunkSize: chunkSize,
          chunkOverlap: chunkOverlap,
        );
      }
    } catch (e) {
      _updateError(documentId, e.toString());
    }
  }

  /// 保存文本块到数据库
  Future<void> _saveChunksToDatabase(
    String documentId,
    List<DocumentChunk> chunks,
  ) async {
    final companions = chunks.map((chunk) {
      return KnowledgeChunksTableCompanion.insert(
        id: chunk.id,
        documentId: documentId,
        content: chunk.content,
        chunkIndex: chunk.index,
        characterCount: chunk.characterCount,
        tokenCount: chunk.tokenCount,
        createdAt: DateTime.now(),
      );
    }).toList();

    await _database.insertKnowledgeChunks(companions);

    // 更新文档的块数量
    await _database.upsertKnowledgeDocument(
      KnowledgeDocumentsTableCompanion(
        id: Value(documentId),
        chunks: Value(chunks.length),
        processedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 更新文档状态
  Future<void> _updateDocumentStatus(
    String documentId,
    String status, [
    String? errorMessage,
  ]) async {
    await _database.upsertKnowledgeDocument(
      KnowledgeDocumentsTableCompanion(
        id: Value(documentId),
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 更新文档元数据
  Future<void> _updateDocumentMetadata(
    String documentId,
    Map<String, dynamic> metadata,
  ) async {
    await _database.upsertKnowledgeDocument(
      KnowledgeDocumentsTableCompanion(
        id: Value(documentId),
        metadata: Value(metadata.isNotEmpty ? metadata.toString() : null),
      ),
    );
  }

  /// 更新处理进度
  void _updateProgress(String documentId, double progress) {
    final newProgress = Map<String, double>.from(state.processingProgress);
    newProgress[documentId] = progress;
    state = state.copyWith(processingProgress: newProgress);
  }

  /// 清除进度信息
  void _clearProgress(String documentId) {
    final newProgress = Map<String, double>.from(state.processingProgress);
    final newErrors = Map<String, String?>.from(state.processingErrors);
    newProgress.remove(documentId);
    newErrors.remove(documentId);
    state = state.copyWith(
      processingProgress: newProgress,
      processingErrors: newErrors,
    );
  }

  /// 更新错误信息
  void _updateError(String documentId, String? error) {
    final newErrors = Map<String, String?>.from(state.processingErrors);
    newErrors[documentId] = error;
    state = state.copyWith(processingErrors: newErrors);
  }

  /// 获取文档处理进度
  double? getDocumentProgress(String documentId) {
    return state.processingProgress[documentId];
  }

  /// 获取文档处理错误
  String? getDocumentError(String documentId) {
    return state.processingErrors[documentId];
  }

  /// 为文本块生成嵌入向量
  Future<void> _generateEmbeddingsForChunks(
    String documentId,
    List<DocumentChunk> chunks,
  ) async {
    try {
      // 获取知识库配置
      final config = _ref.read(knowledgeBaseConfigProvider).currentConfig;
      if (config == null) {
        throw Exception('未找到知识库配置');
      }

      // 提取文本内容
      final texts = chunks.map((chunk) => chunk.content).toList();

      // 生成嵌入向量
      final result = await _embeddingService.generateEmbeddingsForChunks(
        chunks: texts,
        config: config,
      );

      if (result.isSuccess) {
        // 保存嵌入向量到数据库
        for (int i = 0; i < chunks.length; i++) {
          if (i < result.embeddings.length) {
            final embeddingJson = jsonEncode(result.embeddings[i]);
            await _database.updateChunkEmbedding(chunks[i].id, embeddingJson);
          }
        }
      } else {
        throw Exception('生成嵌入向量失败: ${result.error}');
      }
    } catch (e) {
      // 嵌入生成失败不应该影响整个文档处理流程
      // 只记录错误，文档仍然可以被标记为已完成
      debugPrint('为文档 $documentId 生成嵌入向量失败: $e');
    }
  }
}

/// 文档处理服务Provider
final documentProcessingServiceProvider = Provider<DocumentProcessingService>((
  ref,
) {
  return DocumentProcessingService();
});

/// 嵌入服务Provider
final embeddingServiceProvider = Provider<EmbeddingService>((ref) {
  return EmbeddingService();
});

/// 文档处理Provider
final documentProcessingProvider =
    StateNotifierProvider<DocumentProcessingNotifier, DocumentProcessingState>((
      ref,
    ) {
      final database = ref.read(appDatabaseProvider);
      final processingService = ref.read(documentProcessingServiceProvider);
      final embeddingService = ref.read(embeddingServiceProvider);
      return DocumentProcessingNotifier(
        database,
        processingService,
        embeddingService,
        ref,
      );
    });

/// 文档处理进度Provider
final documentProgressProvider = Provider.family<double?, String>((
  ref,
  documentId,
) {
  return ref.watch(documentProcessingProvider).processingProgress[documentId];
});

/// 文档处理错误Provider
final documentErrorProvider = Provider.family<String?, String>((
  ref,
  documentId,
) {
  return ref.watch(documentProcessingProvider).processingErrors[documentId];
});
