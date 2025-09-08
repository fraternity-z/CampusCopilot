import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 渐进迁移：优先通过渲染适配层接入 markdown_widget
import 'package:campus_copilot/shared/markdown/markdown_renderer.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../../settings/presentation/providers/settings_provider.dart';
import '../../../../../app/app_router.dart' show generalSettingsProvider;

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
  // 移除整体淡入入场动画，仅保留脉动动画
  late AnimationController _pulsateController;
  late Animation<double> _pulsateAnimation;

  // 使用 ValueNotifier 替代 setState 减少重建范围
  late ValueNotifier<String> _displayedContentNotifier;
  bool _isExpanded = false;
  Timer? _typingTimer;

  // 批量更新相关
  static const int _charsPerUpdate = 3; // 每次更新显示的字符数
  static const int _updateInterval = 20; // 更新间隔(ms)

  // 预览窗相关
  late ScrollController _previewScrollController;
  late ValueNotifier<int> _activeLineIndex;
  Timer? _previewTimer;
  List<String> _contentLines = [];
  
  // 预览窗配置
  static const double _previewWindowHeight = 72.0; // 3行高度
  static const double _lineHeight = 24.0; // 单行高度
  static const int _previewScrollInterval = 800; // 滚动间隔(ms)

  @override
  void initState() {
    super.initState();
    _displayedContentNotifier = ValueNotifier<String>('');
    _previewScrollController = ScrollController();
    _activeLineIndex = ValueNotifier<int>(0);

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

    _pulsateAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulsateController, curve: Curves.easeInOut),
    );

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

    if (widget.content != oldWidget.content && !widget.isCompleted) {
      _displayedContentNotifier.value = '';
      _contentLines.clear();
      _activeLineIndex.value = 0;
      _startOptimizedTypingAnimation();
    }

    if (widget.isCompleted && !oldWidget.isCompleted) {
      _pulsateController.stop();
      _typingTimer?.cancel();
      _previewTimer?.cancel();
      _displayedContentNotifier.value = widget.content;
      _processContentLines(widget.content);
    }
  }

  /// 处理内容分行
  void _processContentLines(String content) {
    _contentLines = content.split('\n')
        .expand((line) => _wrapTextLine(line, 50)) // 每行最多50字符
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  /// 文本换行处理
  List<String> _wrapTextLine(String text, int maxLength) {
    if (text.length <= maxLength) return [text];
    
    final List<String> lines = [];
    int start = 0;
    
    while (start < text.length) {
      int end = math.min(start + maxLength, text.length);
      // 尝试在单词边界断行
      if (end < text.length) {
        int spaceIndex = text.lastIndexOf(' ', end);
        if (spaceIndex > start) end = spaceIndex;
      }
      
      lines.add(text.substring(start, end).trim());
      start = end + (end < text.length && text[end] == ' ' ? 1 : 0);
    }
    
    return lines;
  }

  /// 启动预览窗滚动动画
  void _startPreviewScrollAnimation() {
    _previewTimer?.cancel();
    
    if (_contentLines.isEmpty) return;
    
    _previewTimer = Timer.periodic(
      Duration(milliseconds: _previewScrollInterval),
      (timer) {
        if (!mounted || _isExpanded) {
          timer.cancel();
          return;
        }
        
        final nextIndex = (_activeLineIndex.value + 1) % _contentLines.length;
        _activeLineIndex.value = nextIndex;
        
        // 平滑滚动到目标位置
        final targetOffset = nextIndex * _lineHeight - _previewWindowHeight / 2 + _lineHeight / 2;
        _previewScrollController.animateTo(
          math.max(0, targetOffset),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  /// 优化的打字动画 - 批量更新字符
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

    _typingTimer = Timer.periodic(
      const Duration(milliseconds: _updateInterval),
      (timer) {
        if (currentIndex < contentLength && mounted) {
          int endIndex = currentIndex + _charsPerUpdate;
          if (endIndex > contentLength) {
            endIndex = contentLength;
          }
          buffer.write(widget.content.substring(currentIndex, endIndex));
          currentIndex = endIndex;
          final newContent = buffer.toString();
          _displayedContentNotifier.value = newContent;
          
          // 只在内容完成时处理预览窗，避免闪烁
          if (currentIndex >= contentLength) {
            _processContentLines(newContent);
            if (!_isExpanded && _contentLines.isNotEmpty && _previewTimer == null) {
              _startPreviewScrollAnimation();
            }
          }
          
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
    _pulsateController.dispose();
    _typingTimer?.cancel();
    _previewTimer?.cancel();
    _displayedContentNotifier.dispose();
    _previewScrollController.dispose();
    _activeLineIndex.dispose();
    super.dispose();
  }

  /// 获取固定的文字颜色（不随主题颜色变化）
  Color _getFixedTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // 浅色系统使用黑色，深色系统使用白色
    return brightness == Brightness.light ? Colors.black : Colors.white;
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
                  // 简化逻辑：显示折叠展开的内容
                  if (displayedContent.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  // 内容较短时直接显示，不支持折叠
                  if (displayedContent.length <= 100) { // 降低阈值以便测试
                    return _buildOptimizedContent(
                      context,
                      settings,
                      displayedContent,
                    );
                  }
                  
                  // 内容较长时支持折叠
                  if (_isExpanded) {
                    return _buildOptimizedContent(
                      context,
                      settings,
                      displayedContent,
                    );
                  } else {
                    // 折叠状态显示预览窗
                    _processContentLines(displayedContent); // 实时处理分行
                    if (_contentLines.isNotEmpty) {
                      return _buildPreviewWindow(context, settings);
                    } else {
                      return _buildOptimizedContent(
                        context,
                        settings,
                        displayedContent,
                      );
                    }
                  }
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
        // 降低折叠阈值以便测试
        if (currentLength > 10) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          
          // 折叠状态管理
          if (_isExpanded) {
            _previewTimer?.cancel();
            _previewTimer = null;
          } else {
            // 折叠时立即处理内容并启动动画
            _processContentLines(_displayedContentNotifier.value);
            if (_contentLines.isNotEmpty) {
              _startPreviewScrollAnimation();
            }
          }
          
          widget.onToggleExpanded?.call();
        }
      },
      child: AnimatedScale(
        scale: _isExpanded ? 1.0 : 0.98,
        duration: const Duration(milliseconds: 150),
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
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
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
      ),
    );
  }

  /// 构建预览窗组件
  Widget _buildPreviewWindow(BuildContext context, settings) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.only(top: 8),
      height: _previewWindowHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: const [0.0, 0.15, 0.85, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: ValueListenableBuilder<int>(
            valueListenable: _activeLineIndex,
            builder: (context, activeIndex, child) {
              return ListView.builder(
                controller: _previewScrollController,
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: _lineHeight,
                itemCount: _contentLines.length,
                itemBuilder: (context, index) {
                  final isActive = index == activeIndex;
                  return _buildPreviewLine(
                    context,
                    _contentLines[index],
                    isActive,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// 构建预览行组件
  Widget _buildPreviewLine(BuildContext context, String text, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _lineHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
              alpha: isActive ? 1.0 : 0.7,
            ),
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
          child: Transform.scale(
            scale: isActive ? 1.02 : 1.0,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
    final general = ref.watch(generalSettingsProvider);
    final bool shouldTruncate =
        !_isExpanded && displayedContent.length > settings.maxDisplayLength;

    final String displayContent = shouldTruncate
        ? '${displayedContent.substring(0, settings.maxDisplayLength)}...'
        : displayedContent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
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
      child: AnimatedOpacity(
        opacity: _isExpanded ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 内容区：根据设置选择 Markdown 或纯文本
            if (general.enableMarkdownRendering)
              RepaintBoundary(
                child: MarkdownRenderer
                        .defaultRenderer(engine: MarkdownEngine.markdownWidget)
                    .render(
                  displayContent,
                  baseTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getFixedTextColor(context),
                        height: 1.4,
                      ),
                ),
              )
            else
              SelectableText(
                displayContent,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getFixedTextColor(context),
                  height: 1.4,
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
      ),
    );
  }
}
