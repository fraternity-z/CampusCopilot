import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/learning_session.dart';
import '../../domain/entities/learning_mode_state.dart';
import '../../data/providers/learning_mode_provider.dart';

/// 学习会话状态指示器
/// 
/// 显示当前学习会话的进度、状态和相关信息
class LearningSessionIndicator extends ConsumerWidget {
  const LearningSessionIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learningModeState = ref.watch(learningModeProvider);
    final theme = Theme.of(context);

    // 只有在学习模式启用时才显示
    if (!learningModeState.isLearningMode) {
      return const SizedBox.shrink();
    }

    final currentSession = learningModeState.currentSession;
    
    // 没有活跃会话时不显示
    if (currentSession == null || 
        currentSession.status != LearningSessionStatus.active) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, currentSession, learningModeState),
          const SizedBox(height: 12),
          _buildProgressBar(theme, currentSession),
          const SizedBox(height: 8),
          _buildStatusInfo(theme, currentSession, learningModeState),
        ],
      ),
    );
  }

  /// 构建顶部标题
  Widget _buildHeader(
    ThemeData theme, 
    LearningSession session,
    LearningModeState state,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.school_outlined,
            color: theme.colorScheme.onPrimary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '学习会话进行中',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                state.style.displayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          '第${session.currentRound}轮',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(ThemeData theme, LearningSession session) {
    final progress = session.currentRound / session.maxRounds;
    final isLastRound = session.currentRound >= session.maxRounds;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLastRound 
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${session.currentRound}/${session.maxRounds}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLastRound 
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        if (isLastRound) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '最后一轮，AI将给出完整答案',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 构建状态信息
  Widget _buildStatusInfo(
    ThemeData theme, 
    LearningSession session,
    LearningModeState state,
  ) {
    final duration = DateTime.now().difference(session.startTime);
    final durationText = _formatDuration(duration);
    
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '用时 $durationText',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 12,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                '苏格拉底式',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 格式化持续时间
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}小时${duration.inMinutes.remainder(60)}分钟';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}分钟';
    } else {
      return '${duration.inSeconds}秒';
    }
  }
}

/// 学习模式提示卡片
/// 
/// 在聊天界面显示学习模式的特殊提示
class LearningModeHintCard extends ConsumerWidget {
  final String message;
  final VoidCallback? onClose;

  const LearningModeHintCard({
    super.key,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onClose,
              child: Icon(
                Icons.close,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 学习模式切换状态指示器
/// 
/// 显示当前是否处于学习模式
class LearningModeStatusChip extends ConsumerWidget {
  const LearningModeStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learningModeState = ref.watch(learningModeProvider);
    final theme = Theme.of(context);

    if (!learningModeState.isLearningMode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school,
            color: theme.colorScheme.onPrimary,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '学习模式',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}