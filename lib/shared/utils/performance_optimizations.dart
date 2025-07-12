import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 性能优化工具集合
/// 
/// 提供各种性能优化相关的工具类和方法
library performance_optimizations;

/// 滚动性能优化助手
class ScrollPerformanceHelper {
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 200);
  
  /// 防抖滚动到底部
  void scrollToBottomDebounced(ScrollController controller) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }
  
  /// 检查是否应该自动滚动
  bool shouldAutoScroll(ScrollController controller, {double threshold = 100}) {
    if (!controller.hasClients) return true;
    
    final position = controller.position;
    return position.maxScrollExtent - position.pixels < threshold;
  }
  
  /// 平滑滚动到指定位置
  Future<void> smoothScrollTo(
    ScrollController controller, 
    double offset, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (!controller.hasClients) return;
    
    await controller.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }
  
  void dispose() {
    _debounceTimer?.cancel();
  }
}

/// 缓存管理器
class CacheManager<K, V> {
  final Map<K, V> _cache = <K, V>{};
  final int maxSize;
  final List<K> _accessOrder = <K>[];
  
  CacheManager({this.maxSize = 100});
  
  /// 获取缓存值
  V? get(K key) {
    if (_cache.containsKey(key)) {
      // 更新访问顺序
      _accessOrder.remove(key);
      _accessOrder.add(key);
      return _cache[key];
    }
    return null;
  }
  
  /// 设置缓存值
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache[key] = value;
      _accessOrder.remove(key);
      _accessOrder.add(key);
    } else {
      // 检查缓存大小
      if (_cache.length >= maxSize) {
        _evictLeastRecentlyUsed();
      }
      
      _cache[key] = value;
      _accessOrder.add(key);
    }
  }
  
  /// 清除缓存
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
  
  /// 获取缓存大小
  int get size => _cache.length;
  
  /// 获取缓存命中率
  double get hitRate {
    // 这里需要额外的统计逻辑
    return 0.0;
  }
  
  /// 驱逐最少使用的项
  void _evictLeastRecentlyUsed() {
    if (_accessOrder.isNotEmpty) {
      final oldestKey = _accessOrder.removeAt(0);
      _cache.remove(oldestKey);
    }
  }
}

/// 性能监控器
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  
  int _frameCount = 0;
  DateTime _lastFrameTime = DateTime.now();
  final List<double> _fpsHistory = <double>[];
  static const int _maxHistorySize = 60; // 保存60秒的FPS历史
  
  /// 开始监控
  void startMonitoring() {
    if (kDebugMode) {
      SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
      developer.log('Performance monitoring started', name: 'Performance');
    }
  }
  
  /// 帧回调
  void _onFrame(Duration timestamp) {
    _frameCount++;
    final now = DateTime.now();
    
    if (now.difference(_lastFrameTime).inSeconds >= 1) {
      final fps = _frameCount / now.difference(_lastFrameTime).inSeconds;
      
      // 记录FPS历史
      _fpsHistory.add(fps);
      if (_fpsHistory.length > _maxHistorySize) {
        _fpsHistory.removeAt(0);
      }
      
      developer.log('FPS: ${fps.toStringAsFixed(1)}', name: 'Performance');
      
      // 检测低FPS
      if (fps < 55) {
        developer.log('⚠️ Low FPS detected: ${fps.toStringAsFixed(1)}', 
                     name: 'Performance');
      }
      
      _frameCount = 0;
      _lastFrameTime = now;
    }
  }
  
  /// 获取平均FPS
  double get averageFPS {
    if (_fpsHistory.isEmpty) return 0.0;
    return _fpsHistory.reduce((a, b) => a + b) / _fpsHistory.length;
  }
  
  /// 获取最低FPS
  double get minFPS {
    if (_fpsHistory.isEmpty) return 0.0;
    return _fpsHistory.reduce((a, b) => a < b ? a : b);
  }
  
  /// 记录操作耗时
  static void logOperationTime(String operation, Duration duration) {
    if (kDebugMode) {
      developer.log(
        '$operation took ${duration.inMilliseconds}ms',
        name: 'Performance'
      );
      
      // 警告慢操作
      if (duration.inMilliseconds > 16) { // 超过一帧时间
        developer.log(
          '⚠️ Slow operation detected: $operation (${duration.inMilliseconds}ms)',
          name: 'Performance'
        );
      }
    }
  }
  
  /// 记录内存使用情况
  void logMemoryUsage() {
    if (kDebugMode) {
      developer.log('Memory monitoring - implement native memory tracking', 
                   name: 'Performance');
    }
  }
}

/// 防抖器
class Debouncer {
  final Duration delay;
  Timer? _timer;
  
  Debouncer({required this.delay});
  
  /// 执行防抖操作
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
  
  /// 取消防抖
  void cancel() {
    _timer?.cancel();
  }
  
  /// 立即执行
  void flush(VoidCallback action) {
    _timer?.cancel();
    action();
  }
  
  void dispose() {
    _timer?.cancel();
  }
}

/// 节流器
class Throttler {
  final Duration interval;
  DateTime? _lastExecution;
  
  Throttler({required this.interval});
  
  /// 执行节流操作
  bool call(VoidCallback action) {
    final now = DateTime.now();
    
    if (_lastExecution == null || 
        now.difference(_lastExecution!) >= interval) {
      _lastExecution = now;
      action();
      return true;
    }
    
    return false;
  }
}

/// 批处理器
class BatchProcessor<T> {
  final Duration batchInterval;
  final int maxBatchSize;
  final Function(List<T>) processor;
  
  final List<T> _batch = <T>[];
  Timer? _timer;
  
  BatchProcessor({
    required this.batchInterval,
    required this.maxBatchSize,
    required this.processor,
  });
  
  /// 添加项目到批处理
  void add(T item) {
    _batch.add(item);
    
    // 检查是否达到最大批处理大小
    if (_batch.length >= maxBatchSize) {
      _processBatch();
    } else {
      // 设置定时器
      _timer?.cancel();
      _timer = Timer(batchInterval, _processBatch);
    }
  }
  
  /// 处理批次
  void _processBatch() {
    if (_batch.isNotEmpty) {
      final items = List<T>.from(_batch);
      _batch.clear();
      _timer?.cancel();
      
      processor(items);
    }
  }
  
  /// 强制处理当前批次
  void flush() {
    _processBatch();
  }
  
  void dispose() {
    _timer?.cancel();
    _batch.clear();
  }
}

/// 性能测量工具
class PerformanceMeasure {
  final String name;
  final Stopwatch _stopwatch = Stopwatch();
  
  PerformanceMeasure(this.name);
  
  /// 开始测量
  void start() {
    _stopwatch.start();
  }
  
  /// 结束测量并记录
  void end() {
    _stopwatch.stop();
    PerformanceMonitor.logOperationTime(name, _stopwatch.elapsed);
    _stopwatch.reset();
  }
  
  /// 测量代码块执行时间
  static T measure<T>(String name, T Function() operation) {
    final stopwatch = Stopwatch()..start();
    try {
      return operation();
    } finally {
      stopwatch.stop();
      PerformanceMonitor.logOperationTime(name, stopwatch.elapsed);
    }
  }
  
  /// 异步测量
  static Future<T> measureAsync<T>(String name, Future<T> Function() operation) async {
    final stopwatch = Stopwatch()..start();
    try {
      return await operation();
    } finally {
      stopwatch.stop();
      PerformanceMonitor.logOperationTime(name, stopwatch.elapsed);
    }
  }
}
