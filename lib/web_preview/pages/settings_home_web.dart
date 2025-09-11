import 'package:flutter/material.dart';
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
            icon: Icons.settings_suggest_outlined,
            title: '常规设置',
            subtitle: '话题自动命名、基础功能配置',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _GeneralSettingsWeb())),
          ),
          _card(
            context,
            icon: Icons.tune,
            title: '模型设置',
            subtitle: '管理AI模型配置、自定义模型和API设置',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ModelSettingsWeb())),
          ),
          _card(
            context,
            icon: Icons.search,
            title: 'AI 搜索设置',
            subtitle: '选择搜索服务商并配置 API 密钥',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _SearchSettingsWeb())),
          ),
          _card(
            context,
            icon: Icons.palette_outlined,
            title: '外观设置',
            subtitle: '主题、语言等界面设置',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _AppearanceSettingsWeb())),
          ),
          _card(
            context,
            icon: Icons.school_outlined,
            title: '学习模式',
            subtitle: '苏格拉底式教学、难度调节、学科设置',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _LearningModeSettingsWeb())),
          ),
          const SizedBox(height: 16),
          _card(
            context,
            icon: Icons.storage_outlined,
            title: '数据管理',
            subtitle: '备份/恢复/清空（预览）',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DataManagementWeb())),
          ),
          _card(
            context,
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '版本与开源许可（预览）',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutWeb())),
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
            subtitle: Text('当前：${seed.toARGB32().toRadixString(16)}'),
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

/// 常规设置占位
class _GeneralSettingsWeb extends StatelessWidget {
  const _GeneralSettingsWeb();
  @override
  Widget build(BuildContext context) {
    bool autoName = true;
    bool markdown = true;
    bool autoSave = true;
    return Scaffold(
      appBar: AppBar(title: const Text('常规设置（预览）')),
      body: StatefulBuilder(builder: (context, set) {
        return ListView(padding: const EdgeInsets.all(16), children: [
          SwitchListTile(title: const Text('话题自动命名'), value: autoName, onChanged: (v)=>set(()=>autoName=v)),
          SwitchListTile(title: const Text('启用 Markdown 渲染'), value: markdown, onChanged: (v)=>set(()=>markdown=v)),
          SwitchListTile(title: const Text('自动保存聊天记录'), value: autoSave, onChanged: (v)=>set(()=>autoSave=v)),
        ]);
      }),
    );
  }
}

/// 模型设置占位
class _ModelSettingsWeb extends StatelessWidget {
  const _ModelSettingsWeb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('模型设置（预览）')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        ListTile(leading: Icon(Icons.memory), title: Text('OpenAI / gpt-4o-mini')), Divider(),
        ListTile(leading: Icon(Icons.memory), title: Text('DeepSeek / deepseek-r1')), Divider(),
        ListTile(leading: Icon(Icons.memory), title: Text('Anthropic / Claude 3.5 Sonnet')),
      ]),
    );
  }
}

/// AI 搜索设置占位
class _SearchSettingsWeb extends StatelessWidget {
  const _SearchSettingsWeb();
  @override
  Widget build(BuildContext context) {
    String provider = 'serpapi';
    final ctrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('AI 搜索设置（预览）')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        DropdownButtonFormField<String>(
          initialValue: provider,
          items: const [
            DropdownMenuItem(value: 'serpapi', child: Text('SerpAPI')),
            DropdownMenuItem(value: 'tavily', child: Text('Tavily')),
            DropdownMenuItem(value: 'bing', child: Text('Bing Web Search')),
          ],
          onChanged: (_) {},
          decoration: const InputDecoration(labelText: '服务商', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'API Key（预览）', border: OutlineInputBorder())),
      ]),
    );
  }
}

/// 学习模式占位
class _LearningModeSettingsWeb extends StatelessWidget {
  const _LearningModeSettingsWeb();
  @override
  Widget build(BuildContext context) {
    String mode = 'socratic';
    double difficulty = 0.5;
    return Scaffold(
      appBar: AppBar(title: const Text('学习模式（预览）')),
      body: StatefulBuilder(builder: (context, set){
        return ListView(padding: const EdgeInsets.all(16), children: [
          DropdownButtonFormField<String>(initialValue: mode, items: const [
            DropdownMenuItem(value: 'socratic', child: Text('苏格拉底式')),
            DropdownMenuItem(value: 'qa', child: Text('问答式')),
          ], onChanged: (v)=> set(()=> mode = v ?? mode), decoration: const InputDecoration(labelText: '教学模式', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('难度调节'), Text(difficulty.toStringAsFixed(2))]),
          Slider(value: difficulty, min: 0, max: 1, onChanged: (v)=>set(()=>difficulty=v)),
        ]);
      }),
    );
  }
}
