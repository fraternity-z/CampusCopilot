import 'package:flutter/material.dart';
import 'settings_tab_web.dart';
import 'data_management_web.dart';
import 'about_web.dart';

/// Web 预览：设置首页（卡片式子页面入口）
class SettingsHomeWeb extends StatelessWidget {
  const SettingsHomeWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置（Web 预览）')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            context,
            icon: Icons.tune,
            title: '通用设置',
            subtitle: '模型参数、代码块、Markdown 等',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsTabWeb()),
            ),
          ),
          _card(
            context,
            icon: Icons.palette_outlined,
            title: '外观设置',
            subtitle: '主题色与明暗模式（占位）',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _AppearanceSettingsWeb()),
            ),
          ),
          _card(
            context,
            icon: Icons.storage_outlined,
            title: '数据管理',
            subtitle: '备份/恢复/清空（预览）',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataManagementWeb()),
            ),
          ),
          _card(
            context,
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '版本与开源许可（预览）',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutWeb()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// 外观设置占位
class _AppearanceSettingsWeb extends StatelessWidget {
  const _AppearanceSettingsWeb();
  @override
  Widget build(BuildContext context) {
    bool dark = Theme.of(context).brightness == Brightness.dark;
    Color seed = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('外观设置（占位）')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SwitchListTile(title: const Text('深色模式'), value: dark, onChanged: (_) {}, contentPadding: EdgeInsets.zero),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('主题色'),
            subtitle: Text('当前：${seed.value.toRadixString(16)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Text('说明：预览模式不改动全局主题，仅演示交互。', style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}

