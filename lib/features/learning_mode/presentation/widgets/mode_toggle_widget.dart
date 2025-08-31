import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/learning_mode_state.dart';
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
            showSettings: true,
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
    bool showSettings = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: showSettings ? () => _showLearningSettings(context, ref) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                color: isActive 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (showSettings && isActive) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.settings_outlined,
                size: 12,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ],
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

  /// 显示学习模式设置
  void _showLearningSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LearningModeSettingsSheet(),
    );
  }
}

/// 学习模式设置底部表单
class LearningModeSettingsSheet extends ConsumerWidget {
  const LearningModeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learningModeState = ref.watch(learningModeProvider);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Row(
                children: [
                  Icon(
                    Icons.school_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '学习模式设置',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 学习风格选择
              Text(
                '学习风格',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildLearningStyleSelector(context, ref, learningModeState),
              
              const SizedBox(height: 24),

              // 难度级别
              Text(
                '难度级别',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildDifficultySlider(context, ref, learningModeState),

              const SizedBox(height: 24),

              // 学科设置
              Text(
                '当前学科',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildSubjectSelector(context, ref, learningModeState),

              const SizedBox(height: 24),

              // 其他选项
              _buildToggleOption(
                context: context,
                ref: ref,
                title: '显示学习提示',
                subtitle: '在学习过程中显示引导提示',
                value: learningModeState.showLearningHints,
                onChanged: () => ref
                    .read(learningModeProvider.notifier)
                    .toggleShowLearningHints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建学习风格选择器
  Widget _buildLearningStyleSelector(
    BuildContext context, 
    WidgetRef ref, 
    LearningModeState state,
  ) {
    return Column(
      children: LearningStyle.values.map((style) {
        final isSelected = state.style == style;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => ref
                  .read(learningModeProvider.notifier)
                  .setLearningStyle(style),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            style.displayName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            style.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建难度滑块
  Widget _buildDifficultySlider(
    BuildContext context,
    WidgetRef ref,
    LearningModeState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当前难度：${_getDifficultyLabel(state.difficultyLevel)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${state.difficultyLevel}/5',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: state.difficultyLevel.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: _getDifficultyLabel(state.difficultyLevel),
            onChanged: (value) => ref
                .read(learningModeProvider.notifier)
                .setDifficultyLevel(value.round()),
          ),
        ],
      ),
    );
  }

  /// 构建学科选择器
  Widget _buildSubjectSelector(
    BuildContext context,
    WidgetRef ref,
    LearningModeState state,
  ) {
    final subjects = ['数学', '物理', '化学', '生物', '英语', '语文', '历史', '地理'];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: subjects.map((subject) {
        final isSelected = state.currentSubject == subject;
        return FilterChip(
          label: Text(subject),
          selected: isSelected,
          onSelected: (selected) {
            ref
                .read(learningModeProvider.notifier)
                .setCurrentSubject(selected ? subject : null);
          },
        );
      }).toList(),
    );
  }

  /// 构建切换选项
  Widget _buildToggleOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }

  /// 获取难度标签
  String _getDifficultyLabel(int level) {
    switch (level) {
      case 1: return '初级';
      case 2: return '入门';
      case 3: return '中等';
      case 4: return '进阶';
      case 5: return '高级';
      default: return '中等';
    }
  }
}