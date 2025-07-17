import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'dart:convert';

import '../../domain/services/document_processing_service.dart';
import '../../domain/services/embedding_service.dart';
import '../../domain/services/vector_database_interface.dart';
import '../../data/providers/vector_database_provider.dart';
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
    required String knowledgeBaseId,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      debugPrint('🔄 开始处理文档: $documentId');

      // 更新处理状态
      _updateProgress(documentId, 0.0);
      await _updateDocumentStatus(documentId, 'processing');
      debugPrint('📊 文档状态已更新为processing');

      // 处理文档（添加超时机制）
      debugPrint('📄 开始提取文档内容...');
      final result = await _processingService
          .processDocument(
            documentId: documentId,
            filePath: filePath,
            fileType: fileType,
            chunkSize: chunkSize,
            chunkOverlap: chunkOverlap,
          )
          .timeout(
            const Duration(minutes: 10), // 10分钟超时
            onTimeout: () {
              debugPrint('⏰ 文档处理超时: $documentId');
              return DocumentProcessingResult(
                chunks: [],
                error: '文档处理超时（超过10分钟）',
              );
            },
          );

      if (result.isSuccess) {
        debugPrint('✅ 文档处理成功，生成了${result.chunks.length}个文本块');

        // 保存文本块到数据库
        _updateProgress(documentId, 0.4);
        debugPrint('💾 保存文本块到数据库...');
        await _saveChunksToDatabase(documentId, knowledgeBaseId, result.chunks);

        // 生成嵌入向量
        _updateProgress(documentId, 0.6);
        debugPrint('🧠 生成嵌入向量...');
        await _generateEmbeddingsForChunks(documentId, result.chunks);

        // 更新文档状态
        _updateProgress(documentId, 1.0);
        debugPrint('🎉 更新文档状态为completed');
        await _updateDocumentStatus(documentId, 'completed');
        await _updateDocumentMetadata(documentId, result.metadata);

        // 清除进度信息
        _clearProgress(documentId);
        debugPrint('✅ 文档处理完成: $documentId');
      } else {
        // 处理失败
        debugPrint('❌ 文档处理失败: ${result.error}');
        await _updateDocumentStatus(documentId, 'failed', result.error);
        _updateError(documentId, result.error);
      }
    } catch (e, stackTrace) {
      debugPrint('💥 文档处理异常: $e');
      debugPrint('堆栈跟踪: $stackTrace');
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
          knowledgeBaseId: doc.knowledgeBaseId,
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
          knowledgeBaseId: doc.knowledgeBaseId,
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
    String knowledgeBaseId,
    List<DocumentChunk> chunks,
  ) async {
    final companions = chunks.map((chunk) {
      return KnowledgeChunksTableCompanion.insert(
        id: chunk.id,
        knowledgeBaseId: knowledgeBaseId,
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
    await (_database.update(
      _database.knowledgeDocumentsTable,
    )..where((t) => t.id.equals(documentId))).write(
      KnowledgeDocumentsTableCompanion(
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
    // 使用update语句只更新特定字段，避免数据验证错误
    await (_database.update(
      _database.knowledgeDocumentsTable,
    )..where((t) => t.id.equals(documentId))).write(
      KnowledgeDocumentsTableCompanion(
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
    // 使用update语句只更新元数据字段
    await (_database.update(
      _database.knowledgeDocumentsTable,
    )..where((t) => t.id.equals(documentId))).write(
      KnowledgeDocumentsTableCompanion(
        metadata: Value(metadata.isNotEmpty ? jsonEncode(metadata) : null),
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

  /// 为文本块生成嵌入向量（批处理版本）
  Future<void> _generateEmbeddingsForChunks(
    String documentId,
    List<DocumentChunk> chunks,
  ) async {
    try {
      debugPrint('🧠 开始生成嵌入向量，总共 ${chunks.length} 个文本块');

      // 获取知识库配置
      final config = _ref.read(knowledgeBaseConfigProvider).currentConfig;
      if (config == null) {
        throw Exception('未找到知识库配置');
      }

      // 分批处理，避免一次性处理太多文本块导致超时
      // 根据文档规模动态调整批大小，默认 50，可通过配置覆盖
      const batchSize = 50; // 每批处理50个文本块，提高吞吐量
      int processedCount = 0;

      for (int i = 0; i < chunks.length; i += batchSize) {
        final endIndex = (i + batchSize < chunks.length)
            ? i + batchSize
            : chunks.length;
        final batchChunks = chunks.sublist(i, endIndex);
        final batchTexts = batchChunks.map((chunk) => chunk.content).toList();

        debugPrint(
          '🔄 处理第 ${(i / batchSize).floor() + 1} 批，包含 ${batchChunks.length} 个文本块',
        );

        try {
          // 生成当前批次的嵌入向量
          final result = await _embeddingService.generateEmbeddingsForChunks(
            chunks: batchTexts,
            config: config,
          );

          if (result.isSuccess) {
            // 准备向量文档列表
            final vectorDocuments = <VectorDocument>[];

            // 保存嵌入向量到关系型数据库和向量数据库
            for (int j = 0; j < batchChunks.length; j++) {
              if (j < result.embeddings.length) {
                final chunk = batchChunks[j];
                final embedding = result.embeddings[j];
                final embeddingJson = jsonEncode(embedding);

                // 保存到关系型数据库
                await _database.updateChunkEmbedding(chunk.id, embeddingJson);

                // 准备向量文档
                vectorDocuments.add(
                  VectorDocument(
                    id: chunk.id,
                    vector: embedding,
                    metadata: {
                      'documentId': documentId,
                      'chunkIndex': chunk.index,
                      'content': chunk.content,
                      'characterCount': chunk.characterCount,
                      'tokenCount': chunk.tokenCount,
                      'createdAt': DateTime.now().toIso8601String(),
                    },
                  ),
                );
              }
            }

            // 批量保存到向量数据库
            if (vectorDocuments.isNotEmpty) {
              await _saveVectorsToVectorDatabase(vectorDocuments, documentId);
            }

            processedCount += batchChunks.length;
            debugPrint('✅ 已完成 $processedCount/${chunks.length} 个文本块的嵌入向量生成');
          } else {
            debugPrint(
              '❌ 第 ${(i / batchSize).floor() + 1} 批嵌入向量生成失败: ${result.error}',
            );
            // 继续处理下一批，不中断整个流程
          }
        } catch (batchError) {
          debugPrint('❌ 第 ${(i / batchSize).floor() + 1} 批处理异常: $batchError');
          // 继续处理下一批
        }

        // 如有必要可根据具体 API 限流策略在此处添加延迟，默认不等待
      }

      debugPrint('🎉 嵌入向量生成完成，成功处理 $processedCount/${chunks.length} 个文本块');
    } catch (e) {
      // 嵌入生成失败不应该影响整个文档处理流程
      // 只记录错误，文档仍然可以被标记为已完成
      debugPrint('❌ 为文档 $documentId 生成嵌入向量失败: $e');
    }
  }

  /// 保存向量到向量数据库
  Future<void> _saveVectorsToVectorDatabase(
    List<VectorDocument> vectorDocuments,
    String documentId,
  ) async {
    try {
      // 从文本块中获取知识库ID
      final chunks = await _database.getChunksByDocument(documentId);
      String knowledgeBaseId = 'default_kb';

      if (chunks.isNotEmpty) {
        knowledgeBaseId = chunks.first.knowledgeBaseId;
      }

      debugPrint(
        '💾 保存 ${vectorDocuments.length} 个向量到向量数据库，知识库: $knowledgeBaseId',
      );

      // 获取向量数据库
      final vectorDatabase = await _ref.read(vectorDatabaseProvider.future);

      // 确保目标集合存在，若不存在则自动创建
      debugPrint('🔍 检查向量集合是否存在: $knowledgeBaseId');
      final collectionExists = await vectorDatabase.collectionExists(
        knowledgeBaseId,
      );
      debugPrint('📊 集合存在状态: $collectionExists');

      if (!collectionExists) {
        debugPrint('🔧 自动创建向量集合: $knowledgeBaseId');
        // 使用首个向量的维度作为集合维度
        final vectorDim = vectorDocuments.first.vector.length;
        debugPrint('📏 向量维度: $vectorDim');

        final createResult = await vectorDatabase.createCollection(
          collectionName: knowledgeBaseId,
          vectorDimension: vectorDim,
          description: '知识库 $knowledgeBaseId 的向量集合',
          metadata: {
            'knowledgeBaseId': knowledgeBaseId,
            'createdAt': DateTime.now().toIso8601String(),
            'autoCreated': 'true',
          },
        );

        if (createResult.success) {
          debugPrint('✅ 向量集合创建成功: $knowledgeBaseId');
        } else {
          debugPrint('❌ 向量集合创建失败: $knowledgeBaseId - ${createResult.error}');
          throw Exception('创建向量集合失败: ${createResult.error}');
        }
      } else {
        debugPrint('✅ 向量集合已存在: $knowledgeBaseId');
      }

      // 批量插入向量
      debugPrint('📝 插入 ${vectorDocuments.length} 个向量到集合: $knowledgeBaseId');
      final result = await vectorDatabase.insertVectors(
        collectionName: knowledgeBaseId,
        documents: vectorDocuments,
      );

      if (result.success) {
        debugPrint('✅ 向量保存成功: ${vectorDocuments.length} 个向量');
      } else {
        debugPrint('❌ 向量保存失败: ${result.error}');
        // 如果插入失败，再次检查集合是否存在
        final stillExists = await vectorDatabase.collectionExists(
          knowledgeBaseId,
        );
        debugPrint('🔍 插入失败后集合存在状态: $stillExists');
        throw Exception('插入向量失败: ${result.error}');
      }
    } catch (e) {
      debugPrint('❌ 保存向量到向量数据库异常: $e');
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
  final database = ref.read(appDatabaseProvider);
  return EmbeddingService(database);
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
