import 'dart:async';
import 'package:flutter/foundation.dart';

import 'document_processing_service.dart';

/// 并发文档处理任务
class ConcurrentProcessingTask {
  final String id;
  final String documentId;
  final String filePath;
  final String fileType;
  final String knowledgeBaseId;
  final int chunkSize;
  final int chunkOverlap;
  final DateTime createdAt;

  ConcurrentProcessingTaskStatus status;
  double progress;
  String? error;
  DocumentProcessingResult? result;

  ConcurrentProcessingTask({
    required this.id,
    required this.documentId,
    required this.filePath,
    required this.fileType,
    required this.knowledgeBaseId,
    this.chunkSize = 1000,
    this.chunkOverlap = 200,
    this.status = ConcurrentProcessingTaskStatus.pending,
    this.progress = 0.0,
    this.error,
    this.result,
  }) : createdAt = DateTime.now();

  ConcurrentProcessingTask copyWith({
    ConcurrentProcessingTaskStatus? status,
    double? progress,
    String? error,
    DocumentProcessingResult? result,
  }) {
    return ConcurrentProcessingTask(
      id: id,
      documentId: documentId,
      filePath: filePath,
      fileType: fileType,
      knowledgeBaseId: knowledgeBaseId,
      chunkSize: chunkSize,
      chunkOverlap: chunkOverlap,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  @override
  String toString() {
    return 'ConcurrentProcessingTask('
        'id: $id, '
        'documentId: $documentId, '
        'status: $status, '
        'progress: ${(progress * 100).toInt()}%'
        ')';
  }
}

/// 并发处理任务状态
enum ConcurrentProcessingTaskStatus {
  pending, // 等待处理
  processing, // 正在处理
  completed, // 处理完成
  failed, // 处理失败
  cancelled, // 已取消
}

/// 并发文档处理服务
///
/// 支持同时处理多个文档，提高处理效率
class ConcurrentDocumentProcessingService {
  static ConcurrentDocumentProcessingService? _instance;

  // 任务队列和状态管理
  final Map<String, ConcurrentProcessingTask> _tasks = {};
  final Map<String, StreamController<ConcurrentProcessingTask>>
  _taskControllers = {};

  // 并发控制
  int _maxConcurrentTasks = 3; // 最大并发任务数
  int _currentRunningTasks = 0;

  // 文档处理服务实例
  final DocumentProcessingService _processingService =
      DocumentProcessingService();

  ConcurrentDocumentProcessingService._();

  /// 获取单例实例
  static ConcurrentDocumentProcessingService get instance {
    _instance ??= ConcurrentDocumentProcessingService._();
    return _instance!;
  }

  /// 设置最大并发任务数
  void setMaxConcurrentTasks(int maxTasks) {
    if (maxTasks > 0 && maxTasks <= 10) {
      _maxConcurrentTasks = maxTasks;
      debugPrint('🔧 设置最大并发任务数: $_maxConcurrentTasks');

      // 如果有等待的任务，尝试启动它们
      _processNextTasks();
    }
  }

  /// 提交文档处理任务
  Future<String> submitTask({
    required String documentId,
    required String filePath,
    required String fileType,
    required String knowledgeBaseId,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    final taskId = '${documentId}_${DateTime.now().millisecondsSinceEpoch}';

    final task = ConcurrentProcessingTask(
      id: taskId,
      documentId: documentId,
      filePath: filePath,
      fileType: fileType,
      knowledgeBaseId: knowledgeBaseId,
      chunkSize: chunkSize,
      chunkOverlap: chunkOverlap,
    );

    _tasks[taskId] = task;
    _taskControllers[taskId] =
        StreamController<ConcurrentProcessingTask>.broadcast();

    debugPrint('📋 提交文档处理任务: $taskId');
    debugPrint('📊 当前任务队列: ${_tasks.length} 个任务');

    // 尝试立即处理任务
    _processNextTasks();

    return taskId;
  }

  /// 获取任务状态流
  Stream<ConcurrentProcessingTask> getTaskStream(String taskId) {
    final controller = _taskControllers[taskId];
    if (controller == null) {
      throw ArgumentError('任务不存在: $taskId');
    }
    return controller.stream;
  }

  /// 获取任务状态
  ConcurrentProcessingTask? getTask(String taskId) {
    return _tasks[taskId];
  }

  /// 获取所有任务
  List<ConcurrentProcessingTask> getAllTasks() {
    return _tasks.values.toList();
  }

  /// 取消任务
  Future<bool> cancelTask(String taskId) async {
    final task = _tasks[taskId];
    if (task == null) {
      return false;
    }

    if (task.status == ConcurrentProcessingTaskStatus.processing) {
      debugPrint('⚠️ 无法取消正在处理的任务: $taskId');
      return false;
    }

    _updateTask(taskId, status: ConcurrentProcessingTaskStatus.cancelled);
    debugPrint('❌ 任务已取消: $taskId');
    return true;
  }

  /// 清理已完成的任务
  void cleanupCompletedTasks() {
    final completedTaskIds = <String>[];

    for (final entry in _tasks.entries) {
      final task = entry.value;
      if (task.status == ConcurrentProcessingTaskStatus.completed ||
          task.status == ConcurrentProcessingTaskStatus.failed ||
          task.status == ConcurrentProcessingTaskStatus.cancelled) {
        // 如果任务完成超过1小时，清理它
        if (DateTime.now().difference(task.createdAt).inHours >= 1) {
          completedTaskIds.add(entry.key);
        }
      }
    }

    for (final taskId in completedTaskIds) {
      _tasks.remove(taskId);
      _taskControllers[taskId]?.close();
      _taskControllers.remove(taskId);
    }

    if (completedTaskIds.isNotEmpty) {
      debugPrint('🧹 清理了 ${completedTaskIds.length} 个已完成的任务');
    }
  }

  /// 获取处理统计信息
  Map<String, dynamic> getProcessingStats() {
    final stats = <ConcurrentProcessingTaskStatus, int>{};

    for (final task in _tasks.values) {
      stats[task.status] = (stats[task.status] ?? 0) + 1;
    }

    return {
      'totalTasks': _tasks.length,
      'runningTasks': _currentRunningTasks,
      'maxConcurrentTasks': _maxConcurrentTasks,
      'pendingTasks': stats[ConcurrentProcessingTaskStatus.pending] ?? 0,
      'processingTasks': stats[ConcurrentProcessingTaskStatus.processing] ?? 0,
      'completedTasks': stats[ConcurrentProcessingTaskStatus.completed] ?? 0,
      'failedTasks': stats[ConcurrentProcessingTaskStatus.failed] ?? 0,
      'cancelledTasks': stats[ConcurrentProcessingTaskStatus.cancelled] ?? 0,
    };
  }

  /// 处理下一批任务
  void _processNextTasks() {
    // 找到等待处理的任务
    final pendingTasks = _tasks.values
        .where((task) => task.status == ConcurrentProcessingTaskStatus.pending)
        .toList();

    // 按创建时间排序
    pendingTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // 启动可以并发处理的任务
    for (final task in pendingTasks) {
      if (_currentRunningTasks >= _maxConcurrentTasks) {
        break;
      }

      _processTask(task.id);
    }
  }

  /// 处理单个任务
  Future<void> _processTask(String taskId) async {
    final task = _tasks[taskId];
    if (task == null || task.status != ConcurrentProcessingTaskStatus.pending) {
      return;
    }

    _currentRunningTasks++;
    _updateTask(taskId, status: ConcurrentProcessingTaskStatus.processing);

    debugPrint('🚀 开始处理任务: $taskId');
    debugPrint('📊 当前运行任务数: $_currentRunningTasks/$_maxConcurrentTasks');

    try {
      // 执行文档处理
      final result = await _processingService.processDocument(
        documentId: task.documentId,
        filePath: task.filePath,
        fileType: task.fileType,
        chunkSize: task.chunkSize,
        chunkOverlap: task.chunkOverlap,
      );

      if (result.isSuccess) {
        _updateTask(
          taskId,
          status: ConcurrentProcessingTaskStatus.completed,
          progress: 1.0,
          result: result,
        );
        debugPrint('✅ 任务处理成功: $taskId');
      } else {
        _updateTask(
          taskId,
          status: ConcurrentProcessingTaskStatus.failed,
          error: result.error,
        );
        debugPrint('❌ 任务处理失败: $taskId - ${result.error}');
      }
    } catch (e) {
      _updateTask(
        taskId,
        status: ConcurrentProcessingTaskStatus.failed,
        error: '任务处理异常: $e',
      );
      debugPrint('💥 任务处理异常: $taskId - $e');
    } finally {
      _currentRunningTasks--;
      debugPrint('📊 任务完成，当前运行任务数: $_currentRunningTasks');

      // 处理下一批任务
      _processNextTasks();
    }
  }

  /// 更新任务状态
  void _updateTask(
    String taskId, {
    ConcurrentProcessingTaskStatus? status,
    double? progress,
    String? error,
    DocumentProcessingResult? result,
  }) {
    final task = _tasks[taskId];
    if (task == null) return;

    final updatedTask = task.copyWith(
      status: status,
      progress: progress,
      error: error,
      result: result,
    );

    _tasks[taskId] = updatedTask;
    _taskControllers[taskId]?.add(updatedTask);
  }

  /// 释放资源
  void dispose() {
    for (final controller in _taskControllers.values) {
      controller.close();
    }
    _taskControllers.clear();
    _tasks.clear();
    _currentRunningTasks = 0;
  }
}
