import 'package:flutter/material.dart';

/// Web 预览版：数据管理（不落库，不读写文件）
class DataManagementWeb extends StatelessWidget {
  const DataManagementWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数据管理（Web 预览）')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _card(context, title: '备份与恢复', icon: Icons.backup, child: Column(children: [
          ListTile(leading: const Icon(Icons.cloud_upload), title: const Text('导出数据'), subtitle: const Text('预览模式：不真正导出'), onTap: () => _toast(context, '仅预览：导出数据')), const Divider(),
          ListTile(leading: const Icon(Icons.cloud_download), title: const Text('导入数据'), subtitle: const Text('预览模式：不真正导入'), onTap: () => _toast(context, '仅预览：导入数据')),
          const Divider(),
          SwitchListTile(value: false, onChanged: (_) {}, title: const Text('自动备份'), subtitle: const Text('预览模式：不可用'), contentPadding: EdgeInsets.zero),
        ])),
        const SizedBox(height: 16),
        _card(context, title: '存储', icon: Icons.storage, child: Column(children: const [
          ListTile(leading: Icon(Icons.chat), title: Text('聊天记录'), subtitle: Text('123 条（示例）')),
          Divider(),
          ListTile(leading: Icon(Icons.person), title: Text('智能体配置'), subtitle: Text('6 条（示例）')),
          Divider(),
          ListTile(leading: Icon(Icons.book), title: Text('知识库'), subtitle: Text('12 篇文档（示例）')),
        ])),
        const SizedBox(height: 16),
        _card(context, title: '危险区域', icon: Icons.warning_amber_rounded, child: Column(children: [
          ListTile(leading: const Icon(Icons.delete_forever, color: Colors.red), title: const Text('清空所有数据', style: TextStyle(color: Colors.red)), subtitle: const Text('预览模式：不执行'), onTap: () => _toast(context, '仅预览：清空数据')),
        ])),
      ]),
    );
  }

  Widget _card(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))]),
      const SizedBox(height: 12),
      child,
    ])));
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

