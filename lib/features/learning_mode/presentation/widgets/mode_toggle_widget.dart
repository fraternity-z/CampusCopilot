import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/learning_mode_provider.dart';

/// 学习模式切换组件
/// 
/// 提供聊天模式和学习模式之间的切换功能，
/// 包含模式指示和快速设置选项
class ModeToggleWidget extends ConsumerWidget {
  const ModeToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learningModeState = ref.watch(learningModeProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            context: context,
            ref: ref,
            isActive: !learningModeState.isLearningMode,
            icon: Icons.chat_bubble_outline,
            label: '聊天',
            onTap: () => _switchToMode(ref, false),
            theme: theme,
          ),
          _buildModeButton(
            context: context,
            ref: ref,
            isActive: learningModeState.isLearningMode,
            icon: Icons.school_outlined,
            label: '学习',
            onTap: () => _switchToMode(ref, true),
            theme: theme,
          ),
        ],
      ),
    );
  }

  /// 构建模式按钮
  Widget _buildModeButton({
    required BuildContext context,
    required WidgetRef ref,
    required bool isActive,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // 增加垂直内边距，避免中文字符在加粗时被裁剪
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                // 提高行高，避免中文下沿被裁剪；不强制 Strut，保持字体自然度量
                height: 1.25,
                color: isActive 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 切换模式
  void _switchToMode(WidgetRef ref, bool isLearningMode) {
    final notifier = ref.read(learningModeProvider.notifier);
    
    final currentState = ref.read(learningModeProvider);
    if (currentState.isLearningMode != isLearningMode) {
      notifier.toggleLearningMode();
    }
  }

}