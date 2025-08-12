import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:async';
import '../../../../settings/presentation/providers/settings_provider.dart';

/// 思考链显示组件
///
/// 模仿GPT样式的思考链显示，支持：
/// - 打字机动画效果
/// - 折叠/展开功能
/// - 可配置动画速度
/// - 渐变背景和阴影效果
/// - 性能优化
class ThinkingChainWidget extends ConsumerStatefulWidget {
  final String content;
  final String modelName;
  final bool isCompleted;
  final VoidCallback? onToggleExpanded;

  const ThinkingChainWidget({
    super.key,
    required this.content,
    required this.modelName,
    this.isCompleted = false,
    this.onToggleExpanded,
  });

  @override
  ConsumerState<ThinkingChainWidget> createState() =>
      _ThinkingChainWidgetState();
}

class _ThinkingChainWidgetState extends ConsumerState<ThinkingChainWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulsateController;
  // 已移除淡入动画
  late Animation<double> _pulsateAnimation;

  late ValueNotifier<String> _displayedContentNotifier;
  bool _isExpanded = false;
  Timer? _typingTimer;

  // 优化的批量更新参数 (用户需求)

  static const int _updateInterval = 16; // 约60fps的更新频率

  @override
  void initState() {
    super.initState();
    _displayedContentNotifier = ValueNotifier<String>('');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulsateController =
        AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: this,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _pulsateController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _pulsateController.forward();
          }
        });

    // 移除淡入动画，不再初始化

    _pulsateAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulsateController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    if (!widget.isCompleted) {
      _startOptimizedTypingAnimation();
      _pulsateController.forward();
    } else {
      _displayedContentNotifier.value = widget.content;
    }
  }

  @override
  void didUpdateWidget(ThinkingChainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 优化更新逻辑，减少不必要的重置
    if (widget.content != oldWidget.content && !widget.isCompleted) {
      final currentDisplayed = _displayedContentNotifier.value;
      if (widget.content.startsWith(currentDisplayed)) {
        // 追加内容，继续动画
        _continueTypingAnimation(currentDisplayed.length);
      } else {
        // 完全不同，重新开始
        _displayedContentNotifier.value = '';
        _startOptimizedTypingAnimation();
      }
    }

    if (widget.isCompleted && !oldWidget.isCompleted) {
      _pulsateController.stop();
      _typingTimer?.cancel();
      // 微任务中完成更新，避免与当前帧布局冲突
      scheduleMicrotask(() {
        if (mounted) {
          _displayedContentNotifier.value = widget.content;
        }
      });
    }
  }

  /// 优化的打字动画 - 使用帧调度和动态批量更新
  void _startOptimizedTypingAnimation() {
    final settings = ref.read(settingsProvider).thinkingChainSettings;
    if (!settings.enableAnimation) {
      _displayedContentNotifier.value = widget.content;
      return;
    }

    _typingTimer?.cancel();

    int currentIndex = 0;
    final int contentLength = widget.content.length;
    final buffer = StringBuffer();

    // 动态批量大小：内容越长，每批越大（范围 3-10）
    final dynamicCharsPerUpdate = (contentLength / 100).ceil().clamp(3, 10);

    void scheduleNextUpdate() {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (currentIndex < contentLength && mounted) {
          final endIndex = (currentIndex + dynamicCharsPerUpdate).clamp(
            0,
            contentLength,
          );
          buffer.write(widget.content.substring(currentIndex, endIndex));
          currentIndex = endIndex;

          // 使用微任务减少主线程阻塞 & 避免同步 setState
          scheduleMicrotask(() {
            if (mounted) {
              _displayedContentNotifier.value = buffer.toString();
            }
          });

          if (currentIndex < contentLength) {
            Future.delayed(
              const Duration(milliseconds: _updateInterval),
              scheduleNextUpdate,
            );
          }
        }
      });
    }

    scheduleNextUpdate();
  }

  /// 继续打字动画（用于追加内容）
  void _continueTypingAnimation(int startIndex) {
    final settings = ref.read(settingsProvider).thinkingChainSettings;
    if (!settings.enableAnimation) {
      _displayedContentNotifier.value = widget.content;
      return;
    }

    _typingTimer?.cancel();

    int currentIndex = startIndex;
    final int contentLength = widget.content.length;
    final buffer = StringBuffer(_displayedContentNotifier.value);

    final dynamicCharsPerUpdate = ((contentLength - startIndex) / 50)
        .ceil()
        .clamp(3, 10);

    _typingTimer = Timer.periodic(
      const Duration(milliseconds: _updateInterval),
      (timer) {
        if (currentIndex < contentLength && mounted) {
          final endIndex = (currentIndex + dynamicCharsPerUpdate).clamp(
            0,
            contentLength,
          );
          buffer.write(widget.content.substring(currentIndex, endIndex));
          currentIndex = endIndex;
          _displayedContentNotifier.value = buffer.toString();
          if (currentIndex >= contentLength) {
            timer.cancel();
          }
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulsateController.dispose();
    _typingTimer?.cancel();
    _displayedContentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).thinkingChainSettings;

    if (!settings.showThinkingChain) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptimizedHeader(context, settings),
            ValueListenableBuilder<String>(
              valueListenable: _displayedContentNotifier,
              builder: (context, displayedContent, child) {
                if (_isExpanded ||
                    settings.maxDisplayLength > displayedContent.length) {
                  return _buildOptimizedContent(
                    context,
                    settings,
                    displayedContent,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 优化的头部组件 - 分离动画部分
  Widget _buildOptimizedHeader(BuildContext context, settings) {
    final isGemini = widget.modelName.toLowerCase().contains('gemini');
    final headerIcon = isGemini && settings.enableGeminiSpecialHandling
        ? Icons.psychology_alt
        : Icons.psychology;

    return GestureDetector(
      onTap: () {
        final currentLength = _displayedContentNotifier.value.length;
        if (currentLength > settings.maxDisplayLength) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          widget.onToggleExpanded?.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surfaceContainerLow,
              Theme.of(
                context,
              ).colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 只对图标部分使用AnimatedBuilder
            if (!widget.isCompleted)
              AnimatedBuilder(
                animation: _pulsateAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + _pulsateAnimation.value * 0.1,
                    child: child,
                  );
                },
                child: Icon(
                  headerIcon,
                  size: 16,
                  color: isGemini && settings.enableGeminiSpecialHandling
                      ? Colors.blue.shade600
                      : Theme.of(context).colorScheme.primary,
                ),
              )
            else
              Icon(
                headerIcon,
                size: 16,
                color: isGemini && settings.enableGeminiSpecialHandling
                    ? Colors.blue.shade600
                    : Theme.of(context).colorScheme.primary,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isGemini && settings.enableGeminiSpecialHandling
                    ? 'Gemini 正在思考...'
                    : 'AI 正在思考...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: _displayedContentNotifier,
              builder: (context, displayedContent, child) {
                if (displayedContent.length > settings.maxDisplayLength) {
                  return Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            if (!widget.isCompleted)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 优化的内容组件
  Widget _buildOptimizedContent(
    BuildContext context,
    settings,
    String displayedContent,
  ) {
    final bool shouldTruncate =
        !_isExpanded && displayedContent.length > settings.maxDisplayLength;

    final String displayContent = shouldTruncate
        ? '${displayedContent.substring(0, settings.maxDisplayLength)}...'
        : displayedContent;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 使用 RepaintBoundary 包裹 MarkdownBody
          RepaintBoundary(
            child: MarkdownBody(
              data: displayContent,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                code: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                ),
              ),
            ),
          ),
          // 光标动画
          if (!widget.isCompleted &&
              displayedContent.length < widget.content.length)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: AnimatedBuilder(
                animation: _pulsateController,
                builder: (context, child) {
                  return Container(
                    width: 2,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: _pulsateAnimation.value,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
