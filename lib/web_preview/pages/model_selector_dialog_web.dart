import 'package:flutter/material.dart';

/// Web 预览：模型选择对话框
class ModelSelectorDialogWebPage extends StatelessWidget {
  const ModelSelectorDialogWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('模型选择（Web 预览）')),
      body: Center(
        child: FilledButton(
          onPressed: () => _showDialog(context),
          child: const Text('打开选择器'),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('选择模型'),
        content: SizedBox(
          width: 420,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(leading: Icon(Icons.memory), title: Text('gpt-4o-mini（示例）')),
              ListTile(leading: Icon(Icons.memory), title: Text('deepseek-r1（示例）')),
              ListTile(leading: Icon(Icons.memory), title: Text('claude-3.5-sonnet（示例）')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('取消')),
          FilledButton(onPressed: ()=>Navigator.pop(context), child: const Text('确认')),
        ],
      ),
    );
  }
}

