import 'package:flutter/material.dart';

/// Web 预览：聊天操作菜单
class ChatActionMenuWebPage extends StatelessWidget {
  const ChatActionMenuWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('聊天操作菜单（Web 预览）')),
      body: Center(
        child: FilledButton.icon(
          icon: const Icon(Icons.more_horiz),
          label: const Text('打开菜单'),
          onPressed: () => _openMenu(context),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                ListTile(leading: Icon(Icons.copy_all), title: Text('复制消息')),
                ListTile(leading: Icon(Icons.edit), title: Text('编辑消息')),
                ListTile(leading: Icon(Icons.refresh), title: Text('重新生成')),
                Divider(),
                ListTile(leading: Icon(Icons.delete), title: Text('删除'), textColor: Colors.red, iconColor: Colors.red),
              ],
            ),
          ),
        );
      },
    );
  }
}

