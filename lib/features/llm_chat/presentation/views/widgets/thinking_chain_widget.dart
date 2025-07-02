import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../settings/presentation/providers/settings_provider.dart';

/// 思考链显示组件
///
/// 模仿GPT样式的思考链显示，支持：
/// - 打字机动画效果
/// - 折叠/展开功能
/// - Gemini模型特殊处理
/// - 可配置动画速度
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
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulsateAnimation;

  String _displayedContent = '';
  bool _isExpanded = false;
  bool _isAnimating = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulsateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulsateAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulsateController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    if (!widget.isCompleted) {
      _startTypingAnimation();
      _pulsateController.repeat(reverse: true);
    } else {
      _displayedContent = widget.content;
    }
  }

  @override
  void didUpdateWidget(ThinkingChainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content && !widget.isCompleted) {
      _startTypingAnimation();
    }

    if (widget.isCompleted && !oldWidget.isCompleted) {
      _pulsateController.stop();
      _displayedContent = widget.content;
      setState(() {});
    }
  }

  void _startTypingAnimation() {
    final settings = ref.read(settingsProvider).thinkingChainSettings;
    if (!settings.enableAnimation) {
      _displayedContent = widget.content;
      setState(() {});
      return;
    }

    _isAnimating = true;
    _currentIndex = 0;

    void typeNextCharacter() {
      if (_currentIndex < widget.content.length && mounted) {
        setState(() {
          _displayedContent = widget.content.substring(0, _currentIndex + 1);
          _currentIndex++;
        });

        Future.delayed(Duration(milliseconds: settings.animationSpeed), () {
          if (mounted) typeNextCharacter();
        });
      } else {
        _isAnimating = false;
      }
    }

    typeNextCharacter();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulsateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).thinkingChainSettings;

    if (!settings.showThinkingChain) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, settings),
            if (_isExpanded ||
                settings.maxDisplayLength > _displayedContent.length)
              _buildContent(context, settings),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, settings) {
    final isGemini = widget.modelName.toLowerCase().contains('gemini');
    final headerIcon = isGemini && settings.enableGeminiSpecialHandling
        ? Icons
              .psychology_alt // Gemini特殊图标
        : Icons.psychology;

    return GestureDetector(
      onTap: () {
        if (_displayedContent.length > settings.maxDisplayLength) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          widget.onToggleExpanded?.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _pulsateAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: widget.isCompleted ? 1.0 : _pulsateAnimation.value,
                  child: Icon(
                    headerIcon,
                    size: 16,
                    color: isGemini && settings.enableGeminiSpecialHandling
                        ? Colors.blue.shade600
                        : Theme.of(context).colorScheme.primary,
                  ),
                );
              },
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
            if (_displayedContent.length > settings.maxDisplayLength)
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            if (!widget.isCompleted)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isGemini && settings.enableGeminiSpecialHandling
                        ? Colors.blue.shade600
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, settings) {
    final shouldTruncate =
        !_isExpanded && _displayedContent.length > settings.maxDisplayLength;

    final displayContent = shouldTruncate
        ? '${_displayedContent.substring(0, settings.maxDisplayLength)}...'
        : _displayedContent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
          MarkdownBody(
            data: displayContent,
            styleSheet: MarkdownStyleSheet(
              p: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              code: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
            ),
          ),
          if (_isAnimating && !widget.isCompleted)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: AnimatedBuilder(
                animation: _pulsateController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _pulsateAnimation.value,
                    child: Container(
                      width: 8,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
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
