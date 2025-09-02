import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/widgets/modern_button.dart';
import '../../providers/chat_provider.dart';
// 删除AI搜索切换相关的导入，开关已移动到输入区
import '../../../../../core/widgets/elegant_notification.dart';
import '../../../domain/services/export_service.dart';

/// 聊天操作菜单组件
///
/// 聚合多个聊天相关功能的弹出菜单
class ChatActionMenu extends ConsumerWidget {
  const ChatActionMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Icon(
            Icons.more_horiz, // 改为水平三点，更美观
            color: const Color(0xFF999999),
            size: 20, // 统一图标大小
          ),
        ),
      ),
      tooltip: '更多操作',
      // 避免使用过大的负偏移导致被上层深色背景/遮罩裁剪
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'export_conversation',
          child: _buildMenuItem(
            context: context,
            icon: Icons.download_outlined,
            title: '导出对话',
            subtitle: '保存完整对话记录',
            color: const Color(0xFF4CAF50),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'clear_chat',
          child: _buildMenuItem(
            context: context,
            icon: Icons.clear_all,
            title: '清空对话',
            subtitle: '删除当前页面所有消息',
            color: Colors.orange,
          ),
        ),
        PopupMenuItem<String>(
          value: 'clear_context',
          child: _buildMenuItem(
            context: context,
            icon: Icons.refresh_outlined,
            title: '清除上下文',
            subtitle: '下条对话不包含历史',
            color: Colors.blue,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          child: _buildMenuItem(
            context: context,
            icon: Icons.settings_outlined,
            title: '设置',
            subtitle: '应用配置和偏好',
            color: Colors.grey,
          ),
        ),
      ],
      onSelected: (value) => _handleMenuAction(context, ref, value),
    );
  }

  /// 构建菜单项
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    // 使用主题色，确保深色/浅色模式下都有良好对比
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 处理菜单操作
  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    // 使用下一帧再执行，避免与 PopupMenu 的遮罩层产生覆盖/重叠
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (action) {
        case 'export_conversation':
          _showExportDialog(context, ref);
          break;
        case 'clear_chat':
          _showClearChatDialog(context, ref);
          break;
        case 'clear_context':
          _showClearContextDialog(context, ref);
          break;
        case 'settings':
          _navigateToSettings(context);
          break;
      }
    });
  }

  /// 显示导出对话框
  Future<void> _showExportDialog(BuildContext context, WidgetRef ref) async {
    final chatState = ref.read(chatProvider);

    if (chatState.currentSession == null || chatState.messages.isEmpty) {
      ElegantNotification.warning(
        context,
        '当前没有可导出的对话记录',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final result = await showDialog<ExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.download_outlined, color: Color(0xFF4CAF50)),
            SizedBox(width: 8),
            Text('导出完整对话'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('选择导出格式:'),
            const SizedBox(height: 16),
            ...ExportService.getSupportedFormats().map(
              (format) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  dense: true,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      format['icon'] as IconData,
                      color: const Color(0xFF4CAF50),
                      size: 18,
                    ),
                  ),
                  title: Text(
                    format['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    format['description'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pop(format['format'] as ExportFormat),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      await _exportChatHistory(context, ref, result);
    }
  }

  /// 导出聊天记录
  Future<void> _exportChatHistory(
    BuildContext context,
    WidgetRef ref,
    ExportFormat format,
  ) async {
    final chatState = ref.read(chatProvider);

    if (chatState.currentSession == null) {
      ElegantNotification.warning(
        context,
        '当前没有选中的对话会话',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // 显示导出中的提示
      ElegantNotification.info(
        context,
        '正在导出为${format == ExportFormat.markdown ? 'Markdown' : 'Word'}格式...',
        duration: const Duration(seconds: 2),
      );

      final filePath = await ExportService.exportChatHistory(
        session: chatState.currentSession!,
        messages: chatState.messages,
        format: format,
        includeMetadata: true,
      );

      if (filePath != null && context.mounted) {
        ElegantNotification.success(
          context,
          '导出成功！文件已保存到: $filePath',
          duration: const Duration(seconds: 5),
        );
      } else if (context.mounted) {
        ElegantNotification.error(
          context,
          '导出失败，请重试',
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ElegantNotification.error(
          context,
          '导出失败: $e',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// 显示清空对话确认对话框
  void _showClearChatDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        scrollable: true,
        title: const Row(
          children: [
            Icon(Icons.clear_all, color: Colors.orange),
            SizedBox(width: 8),
            Text('清空对话'),
          ],
        ),
        content: const Text('确定要清空当前页面的所有消息吗？\n\n此操作不可撤销，但不会影响历史会话记录。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              Navigator.of(context).pop();
              ElegantNotification.warning(
                context,
                '已清空当前对话页面',
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定清空'),
          ),
        ],
      ),
    );
  }

  /// 显示清除上下文确认对话框
  void _showClearContextDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        scrollable: true,
        title: const Row(
          children: [
            Icon(Icons.refresh_outlined, color: Colors.blue),
            SizedBox(width: 8),
            Text('清除上下文'),
          ],
        ),
        content: const Text(
          '确定要清除对话上下文吗？\n\n下次发送消息时，AI将不会参考当前页面的历史对话内容。页面上的消息仍会保留显示。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearContext();
              Navigator.of(context).pop();
              ElegantNotification.info(
                context,
                '已清除对话上下文，下次对话将不包含历史',
                duration: const Duration(seconds: 3),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定清除'),
          ),
        ],
      ),
    );
  }


  /// 导航到设置页面
  void _navigateToSettings(BuildContext context) {
    context.go('/settings');
  }
}
