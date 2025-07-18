import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'dart:convert';

import '../../domain/services/concurrent_document_processing_service.dart';
import '../../domain/entities/knowledge_document.dart';
import '../../presentation/providers/knowledge_base_config_provider.dart';
import '../../presentation/providers/document_processing_provider.dart';
import '../../presentation/providers/knowledge_base_provider.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';

/// 并发文档处理服务提供者
final concurrentDocumentProcessingServiceProvider =
    Provider<ConcurrentDocumentProcessingService>((ref) {
      return ConcurrentDocumentProcessingService.instance;
    });

/// 并发文档处理状态
class ConcurrentDocumentProcessingState {
  final Map<String, ConcurrentProcessingTask> tasks;
  final bool isProcessing;
  final String? error;
  final Map<String, dynamic> stats;

  const ConcurrentDocumentProcessingState({
    this.tasks = const {},
    this.isProcessing = false,
    this.error,
    this.stats = const {},
  });

  ConcurrentDocumentProcessingState copyWith({
    Map<String, ConcurrentProcessingTask>? tasks,
    bool? isProcessing,
    String? error,
    Map<String, dynamic>? stats,
  }) {
    return ConcurrentDocumentProcessingState(
      tasks: tasks ?? this.tasks,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      stats: stats ?? this.stats,
    );
  }

  @override
  String toString() {
    return 'ConcurrentDocumentProcessingState('
        'tasks: ${tasks.length}, '
        'isProcessing: $isProcessing, '
        'error: $error'
        ')';
  }
}

/// 并发文档处理状态管理器
class ConcurrentDocumentProcessingNotifier
    extends StateNotifier<ConcurrentDocumentProcessingState> {
  final ConcurrentDocumentProcessingService _processingService;
  final Ref _ref;

  ConcurrentDocumentProcessingNotifier(this._processingService, this._ref)
    : super(const ConcurrentDocumentProcessingState()) {
    _initialize();
  }

  /// 初始化
  void _initialize() {
    // 定期更新状态
    _startPeriodicUpdate();
  }

  /// 提交多个文档处理任务
  Future<List<String>> submitMultipleDocuments({
    required List<DocumentUploadInfo> documents,
    required String knowledgeBaseId,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      state = state.copyWith(isProcessing: true, error: null);

      final taskIds = <String>[];

      debugPrint('📋 提交 ${documents.length} 个文档处理任务...');

      for (final doc in documents) {
        // 立即更新文档状态为"处理中"
        await _updateDocumentStatus(doc.documentId, 'processing');

        final taskId = await _processingService.submitTask(
          documentId: doc.documentId,
          filePath: doc.filePath,
          fileType: doc.fileType,
          knowledgeBaseId: knowledgeBaseId,
          chunkSize: chunkSize,
          chunkOverlap: chunkOverlap,
        );

        taskIds.add(taskId);

        // 监听任务状态变化
        _listenToTask(taskId);
      }

      debugPrint('✅ 已提交 ${taskIds.length} 个处理任务');
      _updateState();

      // 触发文档列表刷新以显示最新状态
      _ref.read(knowledgeBaseProvider.notifier).reloadDocuments();

      return taskIds;
    } catch (e) {
      debugPrint('❌ 提交文档处理任务失败: $e');
      state = state.copyWith(error: '提交任务失败: $e', isProcessing: false);
      return [];
    }
  }

  /// 提交单个文档处理任务
  Future<String?> submitDocument({
    required String documentId,
    required String filePath,
    required String fileType,
    required String knowledgeBaseId,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      final taskId = await _processingService.submitTask(
        documentId: documentId,
        filePath: filePath,
        fileType: fileType,
        knowledgeBaseId: knowledgeBaseId,
        chunkSize: chunkSize,
        chunkOverlap: chunkOverlap,
      );

      // 监听任务状态变化
      _listenToTask(taskId);

      _updateState();
      return taskId;
    } catch (e) {
      debugPrint('❌ 提交文档处理任务失败: $e');
      state = state.copyWith(error: '提交任务失败: $e');
      return null;
    }
  }

  /// 取消任务
  Future<bool> cancelTask(String taskId) async {
    final success = await _processingService.cancelTask(taskId);
    if (success) {
      _updateState();
    }
    return success;
  }

  /// 设置最大并发任务数
  void setMaxConcurrentTasks(int maxTasks) {
    _processingService.setMaxConcurrentTasks(maxTasks);
    _updateState();
  }

  /// 清理已完成的任务
  void cleanupCompletedTasks() {
    _processingService.cleanupCompletedTasks();
    _updateState();
  }

  /// 监听任务状态变化
  void _listenToTask(String taskId) {
    _processingService
        .getTaskStream(taskId)
        .listen(
          (task) async {
            // 当任务完成时，处理嵌入向量生成
            if (task.status == ConcurrentProcessingTaskStatus.completed &&
                task.result != null) {
              await _handleTaskCompletion(task);
            }

            _updateState();
          },
          onError: (error) {
            debugPrint('❌ 任务状态监听错误: $error');
          },
        );
  }

  /// 处理任务完成
  Future<void> _handleTaskCompletion(ConcurrentProcessingTask task) async {
    try {
      debugPrint('🎉 任务完成，开始后续处理: ${task.id}');

      final result = task.result!;

      // 1. 更新状态为"正在保存文本块"
      await _updateDocumentStatus(task.documentId, 'saving_chunks');

      // 2. 保存文本块到数据库
      await _saveChunksToDatabase(
        task.documentId,
        task.knowledgeBaseId,
        result.chunks,
      );

      // 3. 更新状态为"正在生成嵌入向量"
      await _updateDocumentStatus(task.documentId, 'generating_embeddings');

      // 4. 生成嵌入向量
      bool embeddingSuccess = false;
      try {
        embeddingSuccess = await _generateEmbeddingsForChunks(
          task.documentId,
          result.chunks,
        );
      } catch (e) {
        debugPrint('❌ 嵌入向量生成异常: $e');
        embeddingSuccess = false;
      }

      // 5. 根据嵌入向量生成结果更新最终状态
      if (embeddingSuccess) {
        await _updateDocumentStatus(task.documentId, 'completed');
        debugPrint('✅ 文档处理完全完成: ${task.documentId}');
      } else {
        await _updateDocumentStatus(task.documentId, 'embedding_failed');
        debugPrint('⚠️ 文档分块完成但嵌入向量生成失败: ${task.documentId}');
      }

      // 6. 更新文档元数据
      await _updateDocumentMetadata(task.documentId, {
        'totalChunks': result.chunks.length,
        'processingTime': DateTime.now().difference(task.createdAt).inSeconds,
        'embeddingSuccess': embeddingSuccess,
        ...result.metadata,
      });

      debugPrint('✅ 任务后续处理完成: ${task.id}');

      // 刷新文档列表以显示最新状态
      _ref.read(knowledgeBaseProvider.notifier).reloadDocuments();
    } catch (e) {
      debugPrint('❌ 任务后续处理失败: ${task.id} - $e');
      await _updateDocumentStatus(task.documentId, 'failed');

      // 即使失败也要刷新文档列表
      _ref.read(knowledgeBaseProvider.notifier).reloadDocuments();
    }
  }

  /// 保存文本块到数据库
  Future<void> _saveChunksToDatabase(
    String documentId,
    String knowledgeBaseId,
    List<dynamic> chunks, // 使用 dynamic 类型
  ) async {
    try {
      debugPrint('💾 开始保存 ${chunks.length} 个文本块到数据库');

      final database = _ref.read(appDatabaseProvider);

      for (int i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];

        // 从动态类型中提取数据
        final chunkId = '${documentId}_chunk_$i';
        final content = chunk.content as String? ?? '';
        final characterCount = content.length;
        final tokenCount = _estimateTokenCount(content);

        // 保存文本块到数据库
        await database.insertKnowledgeChunk(
          KnowledgeChunksTableCompanion.insert(
            id: chunkId,
            knowledgeBaseId: knowledgeBaseId,
            documentId: documentId,
            content: content,
            chunkIndex: i,
            characterCount: characterCount,
            tokenCount: tokenCount,
            embedding: const Value(null), // 嵌入向量稍后生成
            createdAt: DateTime.now(),
          ),
        );

        // 每50个块输出一次进度
        if ((i + 1) % 50 == 0 || i == chunks.length - 1) {
          debugPrint('💾 已保存 ${i + 1}/${chunks.length} 个文本块');
        }
      }

      debugPrint('✅ 文本块保存完成，共保存 ${chunks.length} 个文本块');
    } catch (e) {
      debugPrint('❌ 保存文本块到数据库失败: $e');
      rethrow;
    }
  }

  /// 估算token数量（简化版本）
  int _estimateTokenCount(String text) {
    // 简化的token估算：大约每4个字符为1个token
    return (text.length / 4).ceil();
  }

  /// 创建默认配置
  Future<void> _createDefaultConfig(AppDatabase database) async {
    try {
      debugPrint('🔧 创建默认知识库配置...');

      final now = DateTime.now();
      final config = KnowledgeBaseConfigsTableCompanion.insert(
        id: 'default_config',
        name: '默认配置',
        embeddingModelId: 'text-embedding-3-small',
        embeddingModelName: 'Text Embedding 3 Small',
        embeddingModelProvider: 'openai',
        chunkSize: const Value(1000),
        chunkOverlap: const Value(200),
        maxRetrievedChunks: const Value(5),
        similarityThreshold: const Value(0.3),
        isDefault: const Value(true),
        createdAt: now,
        updatedAt: now,
      );

      await database.upsertKnowledgeBaseConfig(config);
      debugPrint('✅ 默认知识库配置创建成功');
    } catch (e) {
      debugPrint('❌ 创建默认知识库配置失败: $e');
      rethrow;
    }
  }

  /// 生成嵌入向量
  Future<bool> _generateEmbeddingsForChunks(
    String documentId,
    List<dynamic> chunks, // 使用 dynamic 类型
  ) async {
    try {
      debugPrint('🧠 开始为文档 $documentId 生成嵌入向量，共 ${chunks.length} 个文本块');

      // 获取数据库中的文本块（因为并发处理的chunks可能格式不同）
      final database = _ref.read(appDatabaseProvider);
      final dbChunks = await database.getChunksByDocument(documentId);

      if (dbChunks.isEmpty) {
        debugPrint('⚠️ 未找到文档 $documentId 的文本块，跳过嵌入向量生成');
        return false;
      }

      // 直接实现嵌入向量生成逻辑
      final success = await _generateEmbeddingsForDocumentChunks(
        documentId,
        dbChunks,
      );

      if (success) {
        debugPrint('✅ 文档 $documentId 嵌入向量生成完成');
        return true;
      } else {
        debugPrint('❌ 文档 $documentId 嵌入向量生成失败');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 生成嵌入向量异常: $e');
      return false;
    }
  }

  /// 为文档块生成嵌入向量的实现
  Future<bool> _generateEmbeddingsForDocumentChunks(
    String documentId,
    List<dynamic> chunks,
  ) async {
    try {
      // 获取知识库配置
      final configState = _ref.read(knowledgeBaseConfigProvider);
      var config = configState.currentConfig;

      // 如果配置未加载，尝试获取兜底配置
      if (config == null) {
        debugPrint('⏳ 知识库配置未就绪，尝试加载兜底配置...');
        try {
          final database = _ref.read(appDatabaseProvider);
          final configs = await database.getAllKnowledgeBaseConfigs();

          if (configs.isNotEmpty) {
            final dbConfig = configs.first;
            // 转换为 KnowledgeBaseConfig 类型
            config = KnowledgeBaseConfig(
              id: dbConfig.id,
              name: dbConfig.name,
              embeddingModelId: dbConfig.embeddingModelId,
              embeddingModelName: dbConfig.embeddingModelName,
              embeddingModelProvider: dbConfig.embeddingModelProvider,
              chunkSize: dbConfig.chunkSize,
              chunkOverlap: dbConfig.chunkOverlap,
              maxRetrievedChunks: dbConfig.maxRetrievedChunks,
              similarityThreshold: dbConfig.similarityThreshold,
              isDefault: dbConfig.isDefault,
              createdAt: dbConfig.createdAt,
              updatedAt: dbConfig.updatedAt,
            );
            debugPrint('🔄 使用兜底配置: ${config.name}');
          } else {
            // 如果数据库中也没有配置，创建一个默认配置
            debugPrint('🔧 数据库中没有配置，创建默认配置...');
            await _createDefaultConfig(database);

            // 重新尝试获取配置
            final newConfigs = await database.getAllKnowledgeBaseConfigs();
            if (newConfigs.isNotEmpty) {
              final dbConfig = newConfigs.first;
              config = KnowledgeBaseConfig(
                id: dbConfig.id,
                name: dbConfig.name,
                embeddingModelId: dbConfig.embeddingModelId,
                embeddingModelName: dbConfig.embeddingModelName,
                embeddingModelProvider: dbConfig.embeddingModelProvider,
                chunkSize: dbConfig.chunkSize,
                chunkOverlap: dbConfig.chunkOverlap,
                maxRetrievedChunks: dbConfig.maxRetrievedChunks,
                similarityThreshold: dbConfig.similarityThreshold,
                isDefault: dbConfig.isDefault,
                createdAt: dbConfig.createdAt,
                updatedAt: dbConfig.updatedAt,
              );
              debugPrint('✅ 创建并使用默认配置: ${config.name}');
            }
          }
        } catch (e) {
          debugPrint('❌ 加载知识库配置失败: $e');
        }
      }

      if (config == null) {
        debugPrint('❌ 未找到知识库配置，无法生成嵌入向量');
        return false;
      }

      // 获取嵌入服务
      final embeddingService = _ref.read(embeddingServiceProvider);
      final database = _ref.read(appDatabaseProvider);

      debugPrint('🧠 开始生成嵌入向量，总共 ${chunks.length} 个文本块');

      // 分批处理，避免一次性处理太多文本块导致超时
      const batchSize = 50;
      int processedCount = 0;
      int failedCount = 0;

      for (int i = 0; i < chunks.length; i += batchSize) {
        final endIndex = (i + batchSize < chunks.length)
            ? i + batchSize
            : chunks.length;
        final batchChunks = chunks.sublist(i, endIndex);
        final batchTexts = batchChunks
            .map((chunk) => chunk.content as String)
            .toList();

        debugPrint(
          '🔄 处理第 ${(i / batchSize).floor() + 1} 批，包含 ${batchChunks.length} 个文本块',
        );

        try {
          // 生成当前批次的嵌入向量
          final result = await embeddingService.generateEmbeddingsForChunks(
            chunks: batchTexts,
            config: config,
          );

          // 处理嵌入服务的结果（可能是部分成功）
          int batchSuccessCount = 0;
          for (int j = 0; j < batchChunks.length; j++) {
            try {
              if (j < result.embeddings.length &&
                  result.embeddings[j].isNotEmpty) {
                final chunk = batchChunks[j];
                final embedding = result.embeddings[j];
                final embeddingJson = jsonEncode(embedding);

                // 保存到关系型数据库
                await database.updateChunkEmbedding(chunk.id, embeddingJson);
                batchSuccessCount++;
              } else {
                debugPrint('⚠️ 文本块 ${batchChunks[j].id} 没有有效的嵌入向量，跳过');
                failedCount++;
              }
            } catch (saveError) {
              debugPrint(
                '⚠️ 保存文本块 ${batchChunks[j].id} 的嵌入向量失败: $saveError，跳过继续处理',
              );
              failedCount++;
            }
          }

          processedCount += batchSuccessCount;

          if (batchSuccessCount > 0) {
            debugPrint(
              '✅ 第 ${(i / batchSize).floor() + 1} 批完成：成功 $batchSuccessCount/${batchChunks.length} 个文本块',
            );
          } else {
            debugPrint(
              '⚠️ 第 ${(i / batchSize).floor() + 1} 批全部失败：${result.error ?? "未知错误"}，跳过继续处理下一批',
            );
          }

          // 更新进度到数据库
          final progress = processedCount / chunks.length;
          await _updateDocumentProgress(documentId, progress);
        } catch (batchError) {
          debugPrint(
            '⚠️ 第 ${(i / batchSize).floor() + 1} 批处理异常: $batchError，跳过继续处理下一批',
          );
          failedCount += batchChunks.length;

          // 即使批次失败，也更新进度以显示处理在继续
          final progress = (processedCount + (i + batchSize)) / chunks.length;
          await _updateDocumentProgress(documentId, progress.clamp(0.0, 1.0));
        }
      }

      debugPrint('🎉 嵌入向量生成完成，成功处理 $processedCount/${chunks.length} 个文本块');

      // 计算成功率，允许一定比例的失败（80%成功率即可认为处理成功）
      final successRate = processedCount / chunks.length;
      const minSuccessRate = 0.8; // 最低80%成功率

      final success = successRate >= minSuccessRate;

      if (success) {
        if (failedCount > 0) {
          debugPrint(
            '✅ 嵌入向量生成基本完成：成功 $processedCount，失败 $failedCount，成功率 ${(successRate * 100).toStringAsFixed(1)}%',
          );
        } else {
          debugPrint('✅ 嵌入向量生成完美完成：所有 $processedCount 个文本块都成功处理');
        }
      } else {
        debugPrint(
          '❌ 嵌入向量生成失败过多：成功 $processedCount，失败 $failedCount，成功率 ${(successRate * 100).toStringAsFixed(1)}%（需要至少${(minSuccessRate * 100).toInt()}%）',
        );
      }

      return success;
    } catch (e) {
      debugPrint('❌ 为文档 $documentId 生成嵌入向量失败: $e');
      return false;
    }
  }

  /// 更新文档状态
  Future<void> _updateDocumentStatus(String documentId, String status) async {
    try {
      debugPrint('📝 更新文档状态: $documentId -> $status');

      final database = _ref.read(appDatabaseProvider);

      // 使用 update 方法更新文档状态
      await (database.update(
        database.knowledgeDocumentsTable,
      )..where((t) => t.id.equals(documentId))).write(
        KnowledgeDocumentsTableCompanion(
          status: Value(status),
          processedAt: Value(DateTime.now()),
        ),
      );

      debugPrint('✅ 文档状态更新成功: $documentId -> $status');
    } catch (e) {
      debugPrint('❌ 更新文档状态失败: $documentId -> $status, 错误: $e');
    }
  }

  /// 更新文档元数据
  Future<void> _updateDocumentMetadata(
    String documentId,
    Map<String, dynamic> metadata,
  ) async {
    try {
      debugPrint('📝 更新文档元数据: $documentId');

      final database = _ref.read(appDatabaseProvider);
      final metadataJson = jsonEncode(metadata);

      // 更新文档元数据
      await (database.update(
        database.knowledgeDocumentsTable,
      )..where((t) => t.id.equals(documentId))).write(
        KnowledgeDocumentsTableCompanion(
          metadata: Value(metadataJson),
          processedAt: Value(DateTime.now()),
        ),
      );

      debugPrint('✅ 文档元数据更新成功: $documentId');
    } catch (e) {
      debugPrint('❌ 更新文档元数据失败: $documentId, 错误: $e');
    }
  }

  /// 更新文档进度
  Future<void> _updateDocumentProgress(
    String documentId,
    double progress,
  ) async {
    try {
      final database = _ref.read(appDatabaseProvider);

      // 更新文档进度
      await (database.update(
        database.knowledgeDocumentsTable,
      )..where((t) => t.id.equals(documentId))).write(
        KnowledgeDocumentsTableCompanion(indexProgress: Value(progress)),
      );
    } catch (e) {
      debugPrint('❌ 更新文档进度失败: $documentId, 错误: $e');
    }
  }

  /// 更新状态
  void _updateState() {
    final allTasks = _processingService.getAllTasks();
    final taskMap = {for (final task in allTasks) task.id: task};
    final stats = _processingService.getProcessingStats();

    final isProcessing =
        stats['processingTasks'] > 0 || stats['pendingTasks'] > 0;

    state = state.copyWith(
      tasks: taskMap,
      isProcessing: isProcessing,
      stats: stats,
      error: null,
    );
  }

  /// 开始定期更新
  void _startPeriodicUpdate() {
    // 每5秒更新一次状态
    Stream.periodic(const Duration(seconds: 5)).listen((_) {
      _updateState();
    });
  }
}

/// 文档上传信息
class DocumentUploadInfo {
  final String documentId;
  final String filePath;
  final String fileType;
  final String title;
  final int fileSize;

  const DocumentUploadInfo({
    required this.documentId,
    required this.filePath,
    required this.fileType,
    required this.title,
    required this.fileSize,
  });
}

/// 并发文档处理状态提供者
final concurrentDocumentProcessingProvider =
    StateNotifierProvider<
      ConcurrentDocumentProcessingNotifier,
      ConcurrentDocumentProcessingState
    >((ref) {
      final processingService = ref.read(
        concurrentDocumentProcessingServiceProvider,
      );

      return ConcurrentDocumentProcessingNotifier(processingService, ref);
    });

/// 处理统计信息提供者
final processingStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(concurrentDocumentProcessingProvider);
  return state.stats;
});

/// 当前处理任务提供者
final currentProcessingTasksProvider = Provider<List<ConcurrentProcessingTask>>(
  (ref) {
    final state = ref.watch(concurrentDocumentProcessingProvider);
    return state.tasks.values
        .where(
          (task) =>
              task.status == ConcurrentProcessingTaskStatus.processing ||
              task.status == ConcurrentProcessingTaskStatus.pending,
        )
        .toList();
  },
);

/// 已完成任务提供者
final completedTasksProvider = Provider<List<ConcurrentProcessingTask>>((ref) {
  final state = ref.watch(concurrentDocumentProcessingProvider);
  return state.tasks.values
      .where((task) => task.status == ConcurrentProcessingTaskStatus.completed)
      .toList();
});
