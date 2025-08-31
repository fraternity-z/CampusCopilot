import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../domain/services/export_service.dart';
import '../../providers/chat_provider.dart';

/// 聊天消息右上角的选项按钮
///
/// 提供复制、导出以及重新生成等操作。
class MessageOptionsButton extends ConsumerWidget {
  final ChatMessage message;

  const MessageOptionsButton({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_MessageOption>(
      tooltip: '更多操作',
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.more_vert,
          size: 18,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
        ),
      ),
      offset: const Offset(0, 8),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.surface,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      // 添加延迟处理，避免在设备更新期间处理事件
      onSelected: (option) {
        // 使用 scheduleMicrotask 和 postFrameCallback 双重保护
        scheduleMicrotask(() {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!context.mounted) return;
            try {
              await _handleMenuSelection(context, ref, option);
            } catch (e) {
              debugPrint('菜单处理异常: $e');
            }
          });
        });
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<_MessageOption>>[
          PopupMenuItem<_MessageOption>(
            value: _MessageOption.copy,
            height: 48,
            child: _buildMenuItem(
              context: context,
              icon: Icons.copy_outlined,
              title: '复制',
              subtitle: '复制到剪贴板',
              color: const Color(0xFF2196F3),
            ),
          ),
          PopupMenuItem<_MessageOption>(
            value: _MessageOption.export,
            height: 48,
            child: _buildMenuItem(
              context: context,
              icon: Icons.download_outlined,
              title: '导出',
              subtitle: '保存为文件',
              color: const Color(0xFF4CAF50),
            ),
          ),
        ];

        if (!message.isFromUser) {
          items.add(
            PopupMenuItem<_MessageOption>(
              value: _MessageOption.regenerate,
              height: 48,
              child: _buildMenuItem(
                context: context,
                icon: Icons.refresh_outlined,
                title: '重新生成',
                subtitle: '生成新回答',
                color: const Color(0xFFFF9800),
              ),
            ),
          );
        }

        return items;
      },
    );
  }

  /// 构建美化的菜单项
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 处理菜单选择事件
  Future<void> _handleMenuSelection(
    BuildContext context,
    WidgetRef ref,
    _MessageOption option,
  ) async {
    switch (option) {
      case _MessageOption.copy:
        final messenger = ScaffoldMessenger.of(context);
        try {
          await Clipboard.setData(ClipboardData(text: message.content));
          // 再次使用 postFrameCallback 确保 SnackBar 显示不会干扰其他操作
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              messenger.showSnackBar(const SnackBar(
                content: Text('已复制到剪贴板'),
                duration: Duration(seconds: 2),
              ));
            }
          });
        } catch (e) {
          // 复制失败处理
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              messenger.showSnackBar(SnackBar(
                content: Text('复制失败: $e'),
                duration: const Duration(seconds: 2),
              ));
            }
          });
        }
        break;
      case _MessageOption.export:
        await _showExportDialog(context, ref);
        break;
      case _MessageOption.regenerate:
        // 仅在消息来自AI时提供重新生成
        if (!message.isFromUser) {
          // 当前简单实现：重新生成最后一条用户消息的回复
          await ref.read(chatProvider.notifier).retryLastMessage();
        }
        break;
    }
  }

  /// 显示导出对话框
  Future<void> _showExportDialog(BuildContext context, WidgetRef ref) async {
    final chatState = ref.read(chatProvider);

    if (chatState.currentSession == null || chatState.messages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('当前没有可导出的聊天记录')));
      return;
    }

    final result = await showDialog<ExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出聊天记录'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('选择导出格式:'),
            const SizedBox(height: 16),
            ...ExportService.getSupportedFormats().map(
              (format) => ListTile(
                leading: Icon(format['icon'] as IconData),
                title: Text(format['name'] as String),
                subtitle: Text(format['description'] as String),
                onTap: () =>
                    Navigator.of(context).pop(format['format'] as ExportFormat),
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
    final messenger = ScaffoldMessenger.of(context);

    if (chatState.currentSession == null) {
      messenger.showSnackBar(const SnackBar(content: Text('当前没有选中的聊天会话')));
      return;
    }

    try {
      // 显示导出中的提示
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '正在导出为${format == ExportFormat.markdown ? 'Markdown' : 'Word'}格式...',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      final filePath = await ExportService.exportChatHistory(
        session: chatState.currentSession!,
        messages: chatState.messages,
        format: format,
        includeMetadata: true,
      );

      if (filePath != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('导出成功！文件已保存到: $filePath'),
            action: SnackBarAction(
              label: '打开',
              onPressed: () async {
                try {
                  await ExportService.openExportedFile(filePath);
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('打开文件失败: $e')));
                }
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        messenger.showSnackBar(const SnackBar(content: Text('导出失败，请重试')));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导出失败: $e')));
    }
  }
}

enum _MessageOption { copy, export, regenerate }
