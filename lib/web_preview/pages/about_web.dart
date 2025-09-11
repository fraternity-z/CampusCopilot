import 'package:flutter/material.dart';

/// Web 预览：关于
class AboutWeb extends StatelessWidget {
  const AboutWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于（Web 预览）')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.apps, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text('Campus Copilot', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('功能强大的校园助手（预览版）', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8), const Text('版本信息', style: TextStyle(fontWeight: FontWeight.w600))]),
                const SizedBox(height: 12),
                _kv(context, '应用版本', 'v1.0.0（预览）'),
                const Divider(),
                _kv(context, '构建版本', '1.0.0+1'),
                const Divider(),
                _kv(context, 'Flutter 版本', '3.32.x（示例）'),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(k), Text(v, style: const TextStyle(fontWeight: FontWeight.w500))]),
      );
}

