import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/learning_mode_provider.dart';
import '../../domain/entities/learning_session.dart';

/// 学习模式输入框
/// 
/// 为学习模式提供特殊的输入提示和快捷功能
class LearningInputField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool isEnabled;

  const LearningInputField({
    super.key,
    required this.controller,
    this.onSubmit,
    this.isEnabled = true,
  });

  @override
  ConsumerState<LearningInputField> createState() => _LearningInputFieldState();
}

class _LearningInputFieldState extends ConsumerState<LearningInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  bool _showQuickActions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final learningModeState = ref.watch(learningModeProvider);
    final theme = Theme.of(context);

    // 更新动画颜色
    _colorAnimation = ColorTween(
      begin: theme.colorScheme.outline,
      end: learningModeState.isLearningMode 
        ? theme.colorScheme.primary
        : theme.colorScheme.outline,
    ).animate(_animationController);

    // 根据学习模式状态控制动画
    if (learningModeState.isLearningMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 学习模式提示栏
        if (learningModeState.isLearningMode)
          _buildLearningHintBar(theme, learningModeState),
        
        // 主输入框
        AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _colorAnimation.value ?? theme.colorScheme.outline,
                  width: learningModeState.isLearningMode ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(24),
                color: theme.colorScheme.surface,
              ),
              child: Column(
                children: [
                  // 快捷操作栏
                  if (_showQuickActions && learningModeState.isLearningMode)
                    _buildQuickActions(theme, ref),
                  
                  // 输入框主体
                  _buildMainInput(theme, learningModeState),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// 构建学习模式提示栏
  Widget _buildLearningHintBar(ThemeData theme, learningModeState) {
    final currentSession = learningModeState.currentSession;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              currentSession != null
                ? _getSessionHint(currentSession)
                : '学习模式已启用，AI将引导您思考',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 快捷操作按钮
          InkWell(
            onTap: () {
              setState(() {
                _showQuickActions = !_showQuickActions;
              });
            },
            child: Icon(
              _showQuickActions ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建快捷操作栏
  Widget _buildQuickActions(ThemeData theme, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '快捷操作',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickActionChip(
                theme,
                '我想要答案',
                Icons.lightbulb_outline,
                () {
                  widget.controller.text = '我想要答案';
                  widget.onSubmit?.call();
                },
              ),
              _buildQuickActionChip(
                theme,
                '给我提示',
                Icons.help_outline,
                () {
                  widget.controller.text = '能给我一些提示吗？';
                  widget.onSubmit?.call();
                },
              ),
              _buildQuickActionChip(
                theme,
                '我不理解',
                Icons.help_outline,
                () {
                  widget.controller.text = '我不太理解，能换个角度解释吗？';
                  widget.onSubmit?.call();
                },
              ),
              _buildQuickActionChip(
                theme,
                '继续引导',
                Icons.arrow_forward,
                () {
                  widget.controller.text = '请继续引导我思考';
                  widget.onSubmit?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建快捷操作芯片
  Widget _buildQuickActionChip(
    ThemeData theme,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.secondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建主输入框
  Widget _buildMainInput(ThemeData theme, learningModeState) {
    return TextField(
      controller: widget.controller,
      enabled: widget.isEnabled,
      maxLines: null,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => widget.onSubmit?.call(),
      decoration: InputDecoration(
        hintText: learningModeState.isLearningMode
          ? '分享您的想法和理解...'
          : '输入消息...',
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        prefixIcon: learningModeState.isLearningMode
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.psychology,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            )
          : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: widget.isEnabled ? widget.onSubmit : null,
            icon: Icon(
              Icons.send,
              color: learningModeState.isLearningMode
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取会话提示文本
  String _getSessionHint(LearningSession session) {
    if (session.currentRound >= session.maxRounds) {
      return '最后一轮，AI将给出完整答案';
    } else if (session.currentRound == 1) {
      return '学习会话开始，请分享您的初步理解';
    } else {
      return '第${session.currentRound}轮，继续深入思考';
    }
  }
}

/// 学习模式功能按钮
class LearningModeFunctionButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const LearningModeFunctionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final learningModeState = ref.watch(learningModeProvider);
    
    return FilledButton.tonalIcon(
      onPressed: isEnabled && learningModeState.isLearningMode ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: learningModeState.isLearningMode
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.colorScheme.surfaceContainerHighest,
        foregroundColor: learningModeState.isLearningMode
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}