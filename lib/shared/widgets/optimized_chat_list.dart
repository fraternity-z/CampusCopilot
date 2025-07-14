import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/performance_optimizations.dart';
import '../../features/llm_chat/domain/entities/chat_message.dart';

/// 优化的聊天列表组件
///
/// 主要优化点：
/// 1. 防抖滚动
/// 2. RepaintBoundary包装
/// 3. 智能重建策略
/// 4. 内存优化
class OptimizedChatList extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  final ScrollController? controller;
  final Widget Function(BuildContext, ChatMessage) itemBuilder;
  final VoidCallback? onScrollToBottom;
  final bool autoScroll;
  final String? error;

  const OptimizedChatList({
    super.key,
    required this.messages,
    required this.itemBuilder,
    this.controller,
    this.onScrollToBottom,
    this.autoScroll = true,
    this.error,
  });

  @override
  ConsumerState<OptimizedChatList> createState() => _OptimizedChatListState();
}

class _OptimizedChatListState extends ConsumerState<OptimizedChatList> {
  late ScrollController _scrollController;
  late ScrollPerformanceHelper _scrollHelper;

  // 缓存相关
  static final CacheManager<String, double> _itemHeightCache =
      CacheManager<String, double>(maxSize: 200);

  // 性能监控
  final PerformanceMeasure _buildMeasure = PerformanceMeasure('ChatList.build');
  final PerformanceMeasure _scrollMeasure = PerformanceMeasure(
    'ChatList.scroll',
  );

  // 滚动节流器
  final Throttler _scrollThrottler = Throttler(
    interval: const Duration(milliseconds: 100),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollHelper = ScrollPerformanceHelper();

    // 添加滚动监听器
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollHelper.dispose();
    if (widget.controller == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(OptimizedChatList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查是否需要自动滚动
    if (widget.autoScroll &&
        widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomIfNeeded();
      });
    }
  }

  /// 滚动监听器
  void _onScroll() {
    // 使用节流器避免过度触发
    _scrollThrottler(() {
      // 这里可以添加滚动相关的逻辑
      // 比如加载更多消息、更新已读状态等
    });
  }

  /// 智能滚动到底部
  void _scrollToBottomIfNeeded() {
    _scrollMeasure.start();

    if (_scrollHelper.shouldAutoScroll(_scrollController)) {
      _scrollHelper.scrollToBottomDebounced(_scrollController);
      widget.onScrollToBottom?.call();
    }

    _scrollMeasure.end();
  }

  /// 获取缓存的item高度
  double? _getCachedItemHeight(String messageId) {
    return _itemHeightCache.get(messageId);
  }

  /// 缓存item高度
  void _cacheItemHeight(String messageId, double height) {
    _itemHeightCache.put(messageId, height);
  }

  @override
  Widget build(BuildContext context) {
    _buildMeasure.start();

    try {
      return _buildOptimizedList();
    } finally {
      _buildMeasure.end();
    }
  }

  /// 构建优化的列表
  Widget _buildOptimizedList() {
    final itemCount = widget.messages.length + (widget.error != null ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      // 性能优化：提供itemExtent估算
      itemExtentBuilder: (index, dimensions) {
        if (widget.error != null && index == widget.messages.length) {
          return 80.0; // 错误消息固定高度
        }

        if (index < widget.messages.length) {
          final message = widget.messages[index];
          final cachedHeight = _getCachedItemHeight(message.id);
          return cachedHeight ?? 120.0; // 默认估算高度
        }

        return 120.0;
      },
      itemBuilder: (context, index) {
        // 错误消息
        if (widget.error != null && index == widget.messages.length) {
          return _buildErrorMessage(widget.error!);
        }

        // 普通消息
        if (index < widget.messages.length) {
          final message = widget.messages[index];
          return _buildOptimizedMessageItem(message, index);
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// 构建优化的消息项
  Widget _buildOptimizedMessageItem(ChatMessage message, int index) {
    return RepaintBoundary(
      key: ValueKey(message.id),
      child: _MeasuredMessageItem(
        message: message,
        itemBuilder: widget.itemBuilder,
        onHeightMeasured: (height) {
          _cacheItemHeight(message.id, height);
        },
      ),
    );
  }

  /// 构建错误消息
  Widget _buildErrorMessage(String error) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 可测量高度的消息项
class _MeasuredMessageItem extends StatefulWidget {
  final ChatMessage message;
  final Widget Function(BuildContext, ChatMessage) itemBuilder;
  final ValueChanged<double>? onHeightMeasured;

  const _MeasuredMessageItem({
    required this.message,
    required this.itemBuilder,
    this.onHeightMeasured,
  });

  @override
  State<_MeasuredMessageItem> createState() => _MeasuredMessageItemState();
}

class _MeasuredMessageItemState extends State<_MeasuredMessageItem> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    // 在下一帧测量高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  @override
  void didUpdateWidget(_MeasuredMessageItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 如果消息内容变化，重新测量高度
    if (oldWidget.message.content != widget.message.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _measureHeight();
      });
    }
  }

  /// 测量组件高度
  void _measureHeight() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      widget.onHeightMeasured?.call(height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.itemBuilder(context, widget.message),
    );
  }
}

/// 优化的聊天列表控制器
class OptimizedChatListController {
  final ScrollController _scrollController = ScrollController();
  final ScrollPerformanceHelper _scrollHelper = ScrollPerformanceHelper();

  ScrollController get scrollController => _scrollController;

  /// 滚动到底部
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) async {
    await _scrollHelper.smoothScrollTo(
      _scrollController,
      _scrollController.position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }

  /// 防抖滚动到底部
  void scrollToBottomDebounced() {
    _scrollHelper.scrollToBottomDebounced(_scrollController);
  }

  /// 检查是否应该自动滚动
  bool shouldAutoScroll({double threshold = 100}) {
    return _scrollHelper.shouldAutoScroll(
      _scrollController,
      threshold: threshold,
    );
  }

  /// 滚动到指定消息
  Future<void> scrollToMessage(String messageId) async {
    // 这里需要根据消息ID计算位置
    // 实现可能需要额外的索引逻辑
  }

  void dispose() {
    _scrollHelper.dispose();
    _scrollController.dispose();
  }
}
