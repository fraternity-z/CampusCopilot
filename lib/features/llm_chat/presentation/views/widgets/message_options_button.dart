import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/chat_message.dart';
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
            // TODO: 实现导出功能，目前仅提示
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('导出功能暂未实现')));
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
}

enum _MessageOption { copy, export, regenerate }
