import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/concurrent_document_processing_service.dart';

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

  ConcurrentDocumentProcessingNotifier(this._processingService)
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

      // 保存文本块到数据库
      await _saveChunksToDatabase(
        task.documentId,
        task.knowledgeBaseId,
        result.chunks,
      );

      // 生成嵌入向量
      await _generateEmbeddingsForChunks(task.documentId, result.chunks);

      // 更新文档状态
      await _updateDocumentStatus(task.documentId, 'completed');
      await _updateDocumentMetadata(task.documentId, result.metadata);

      debugPrint('✅ 任务后续处理完成: ${task.id}');
    } catch (e) {
      debugPrint('❌ 任务后续处理失败: ${task.id} - $e');
    }
  }

  /// 保存文本块到数据库
  Future<void> _saveChunksToDatabase(
    String documentId,
    String knowledgeBaseId,
    List<dynamic> chunks, // 使用 dynamic 类型
  ) async {
    // 这里需要根据实际的数据库接口来实现
    // 暂时跳过具体实现，等待数据库接口完善
    debugPrint('保存 ${chunks.length} 个文本块到数据库');
  }

  /// 生成嵌入向量
  Future<void> _generateEmbeddingsForChunks(
    String documentId,
    List<dynamic> chunks, // 使用 dynamic 类型
  ) async {
    try {
      // 暂时跳过嵌入向量生成，等待接口完善
      debugPrint('为文档 $documentId 生成嵌入向量（暂时跳过）');
    } catch (e) {
      debugPrint('❌ 生成嵌入向量异常: $e');
    }
  }

  /// 更新文档状态
  Future<void> _updateDocumentStatus(String documentId, String status) async {
    // 暂时跳过，等待数据库接口完善
    debugPrint('更新文档状态: $documentId -> $status');
  }

  /// 更新文档元数据
  Future<void> _updateDocumentMetadata(
    String documentId,
    Map<String, dynamic> metadata,
  ) async {
    // 暂时跳过，等待数据库接口完善
    debugPrint('更新文档元数据: $documentId');
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

      return ConcurrentDocumentProcessingNotifier(processingService);
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
