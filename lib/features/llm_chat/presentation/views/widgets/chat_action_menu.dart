import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/widgets/modern_button.dart';
import '../../providers/chat_provider.dart';
import '../../providers/search_providers.dart';
import '../../../../../core/widgets/elegant_notification.dart';

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
      offset: const Offset(0, -200), // 向上弹出
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      itemBuilder: (context) => [
        // 快速启用/禁用 AI 搜索
        PopupMenuItem<String>(
          value: 'toggle_search',
          child: _buildMenuItem(
            icon: Icons.travel_explore,
            title: 'AI搜索',
            subtitle: '一键启用/禁用网络搜索',
            color: Colors.teal,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'clear_chat',
          child: _buildMenuItem(
            icon: Icons.clear_all,
            title: '清空对话',
            subtitle: '删除当前页面所有消息',
            color: Colors.orange,
          ),
        ),
        PopupMenuItem<String>(
          value: 'clear_context',
          child: _buildMenuItem(
            icon: Icons.refresh_outlined,
            title: '清除上下文',
            subtitle: '下条对话不包含历史',
            color: Colors.blue,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'mcp_tools',
          child: _buildMenuItem(
            icon: Icons.extension_outlined,
            title: 'MCP工具',
            subtitle: '模型上下文协议工具',
            color: Colors.purple,
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: _buildMenuItem(
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
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
    switch (action) {
      case 'toggle_search':
        final notifier = ref.read(searchConfigProvider.notifier);
        final enabled = ref.read(searchConfigProvider).searchEnabled;
        notifier.updateSearchEnabled(!enabled);
        ElegantNotification.info(
          context,
          !enabled ? '已启用AI搜索' : '已关闭AI搜索',
          duration: const Duration(seconds: 2),
        );
        break;
      case 'clear_chat':
        _showClearChatDialog(context, ref);
        break;
      case 'clear_context':
        _showClearContextDialog(context, ref);
        break;
      case 'mcp_tools':
        _showMCPToolsDialog(context, ref);
        break;
      case 'settings':
        _navigateToSettings(context);
        break;
    }
  }

  /// 显示清空对话确认对话框
  void _showClearChatDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          ModernButton(
            text: '确定清空',
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              Navigator.of(context).pop();
              ElegantNotification.warning(
                context,
                '已清空当前对话页面',
                duration: const Duration(seconds: 2),
              );
            },
            style: ModernButtonStyle.danger,
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
          ModernButton(
            text: '确定清除',
            onPressed: () {
              ref.read(chatProvider.notifier).clearContext();
              Navigator.of(context).pop();
              ElegantNotification.info(
                context,
                '已清除对话上下文，下次对话将不包含历史',
                duration: const Duration(seconds: 3),
              );
            },
            style: ModernButtonStyle.primary,
          ),
        ],
      ),
    );
  }

  /// 显示MCP工具对话框
  void _showMCPToolsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.extension_outlined, color: Colors.purple),
            SizedBox(width: 8),
            Text('MCP工具'),
          ],
        ),
        content: const Text('MCP（模型上下文协议）工具功能正在开发中...\n\n敬请期待！'),
        actions: [
          ModernButton(
            text: '知道了',
            onPressed: () => Navigator.of(context).pop(),
            style: ModernButtonStyle.outline,
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
