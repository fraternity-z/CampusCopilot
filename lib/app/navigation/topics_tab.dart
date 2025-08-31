import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/ui_constants.dart';
import '../../features/llm_chat/presentation/providers/chat_provider.dart';
import '../../features/llm_chat/presentation/views/widgets/animated_title_widget.dart';
import '../../features/settings/presentation/providers/ui_settings_provider.dart';
import '../../features/llm_chat/domain/services/export_service.dart';
import '../../core/widgets/elegant_notification.dart';

/// 聊天记录标签页组件
class TopicsTab extends ConsumerWidget {
  const TopicsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 标题栏
        _buildHeader(context, ref),

        // 聊天记录列表
        Expanded(child: _buildSessionsList(context, ref)),
      ],
    );
  }

  /// 构建头部
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacingL),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '聊天记录',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // 清除所有对话按钮
          IconButton(
            icon: const Icon(
              Icons.delete_sweep,
              size: UIConstants.iconSizeMedium,
            ),
            onPressed: () => _showClearAllSessionsDialog(context, ref),
            tooltip: '清除所有对话',
          ),
          // 新建对话按钮
          IconButton(
            icon: const Icon(Icons.add, size: UIConstants.iconSizeMedium),
            onPressed: () => ref.read(chatProvider.notifier).createNewSession(),
            tooltip: '新建对话',
          ),
        ],
      ),
    );
  }

  /// 构建会话列表
  Widget _buildSessionsList(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final chatState = ref.watch(chatProvider);
        final sessions = chatState.sessions;
        final currentSession = chatState.currentSession;
        final error = chatState.error;

        // 错误状态
        if (error != null) {
          return _buildErrorState(context, ref, error);
        }

        // 空状态
        if (sessions.isEmpty) {
          return _buildEmptyState(context);
        }

        // 会话列表
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingL),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            final isSelected = currentSession?.id == session.id;

            return _ChatSessionTile(
              session: session,
              isSelected: isSelected,
              onTap: () => _handleSessionTap(context, ref, session.id),
              onDelete: () => _showDeleteSessionDialog(context, ref, session),
            );
          },
        );
      },
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: UIConstants.spacingL),
          Text('加载失败', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: UIConstants.spacingS),
          Text(
            error,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UIConstants.spacingL),
          ElevatedButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearError();
              ref.invalidate(chatProvider);
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Text('暂无聊天记录', style: TextStyle(color: Colors.grey)),
    );
  }

  /// 处理会话点击
  void _handleSessionTap(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
  ) {
    ref.read(chatProvider.notifier).selectSession(sessionId);
    // 关闭侧边栏
    ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(true);
    // 跳转到聊天页面
    context.go('/chat');
  }

  /// 显示清除所有会话对话框
  void _showClearAllSessionsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有对话'),
        content: const Text('确定要清除所有聊天记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatProvider.notifier).clearAllSessions();
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }

  /// 显示删除会话对话框
  void _showDeleteSessionDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic session,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除对话'),
        content: Text('确定要删除对话 "${session.title}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatProvider.notifier).deleteSession(session.id);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

/// 聊天会话条目组件
class _ChatSessionTile extends StatelessWidget {
  final dynamic session;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ChatSessionTile({
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.spacingXS),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: UIConstants.spacingL,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.chat_bubble_outline,
            size: UIConstants.spacingL,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: AnimatedTitleWidget(
          title: session.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),
        ),
        subtitle: Text(
          _formatSessionTime(session.updatedAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(
                    alpha: UIConstants.disabledOpacity,
                  )
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: UIConstants.spacingL,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(
                    alpha: UIConstants.disabledOpacity,
                  )
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: UIConstants.spacingL),
                  SizedBox(width: UIConstants.spacingS),
                  Text('删除'),
                ],
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingM,
          vertical: UIConstants.spacingXS,
        ),
        dense: true,
      ),
    );
  }

  /// 格式化会话时间
  String _formatSessionTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
