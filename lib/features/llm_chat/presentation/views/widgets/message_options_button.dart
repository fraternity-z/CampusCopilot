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
      icon: Icon(
        Icons.more_vert,
        size: 18,
        color: Theme.of(context).colorScheme.outline,
      ),
      onSelected: (option) async {
        switch (option) {
          case _MessageOption.copy:
            final messenger = ScaffoldMessenger.of(context);
            Clipboard.setData(ClipboardData(text: message.content)).then((_) {
              messenger.showSnackBar(const SnackBar(content: Text('已复制到剪贴板')));
            });
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
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<_MessageOption>>[
          const PopupMenuItem<_MessageOption>(
            value: _MessageOption.copy,
            child: Text('复制'),
          ),
          const PopupMenuItem<_MessageOption>(
            value: _MessageOption.export,
            child: Text('导出'),
          ),
        ];

        if (!message.isFromUser) {
          items.add(
            const PopupMenuItem<_MessageOption>(
              value: _MessageOption.regenerate,
              child: Text('重新生成'),
            ),
          );
        }

        return items;
      },
    );
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
