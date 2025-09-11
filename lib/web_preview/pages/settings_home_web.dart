import 'package:flutter/material.dart';
import 'data_management_web.dart';
import 'about_web.dart';

/// Web 预览：设置首页（卡片式子页面入口）
class SettingsHomeWeb extends StatelessWidget {
  final VoidCallback? onBack;
  const SettingsHomeWeb({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onBack != null
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack)
            : (Navigator.of(context).canPop() ? const BackButton() : null),
        title: const Text('设置（Web 预览）'),
      ),
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
      appBar: AppBar(leading: const BackButton(), title: const Text('外观设置（占位）')),
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
      appBar: AppBar(leading: const BackButton(), title: const Text('常规设置（预览）')),
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
    final providers = <_ProviderInfo>[
      _ProviderInfo(
        name: 'OpenAI',
        desc: 'OpenAI的GPT系列模型，包括GPT‑3.5和GPT‑4',
        icon: Icons.psychology_alt_rounded,
        color: const Color(0xFF67C587),
        defaultModel: 'gpt-3.5-turbo',
      ),
      _ProviderInfo(
        name: 'Google Gemini',
        desc: 'Google的Gemini系列模型，支持多模态输入',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF6AA9FF),
        defaultModel: 'gemini-pro',
      ),
      _ProviderInfo(
        name: 'Anthropic Claude',
        desc: 'Anthropic的Claude系列模型，注重安全性和有用性',
        icon: Icons.star_rate_rounded,
        color: const Color(0xFFFFB861),
        defaultModel: 'claude-3-sonnet-20240229',
      ),
      _ProviderInfo(
        name: 'DeepSeek',
        desc: 'DeepSeek的高性能大语言模型，支持推理和代码生成',
        icon: Icons.extension_rounded,
        color: const Color(0xFFB08FFF),
        defaultModel: 'deepseek-chat',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('模型设置'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // 顶部说明
          Text(
            'AI 提供商配置',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '按名称分组管理各个AI提供商的配置，支持扩展开关和批量删除',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          Text('内置提供商', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // 提供商卡片
          ...providers.map((p) => _providerCard(context, p)).expand((w) => [w, const SizedBox(height: 12)]),
        ],
      ),
    );
  }

  Widget _providerCard(BuildContext context, _ProviderInfo p) {
    final outline = Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
    final bg = Theme.of(context).colorScheme.surface;
    final iconBg = p.color.withValues(alpha: 0.15);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧品牌图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(p.icon, color: p.color, size: 28),
              ),
              const SizedBox(width: 14),
              // 中间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      p.desc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // 绿色“已支持”
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF57D18D).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: const [
                            Icon(Icons.circle, size: 8, color: Color(0xFF1DBF73)),
                            SizedBox(width: 6),
                            Text('已支持', style: TextStyle(color: Color(0xFF1DBF73), fontWeight: FontWeight.w600)),
                          ]),
                        ),
                        const SizedBox(width: 10),
                        // 默认模型 tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            const Icon(Icons.memory_rounded, size: 14),
                            const SizedBox(width: 4),
                            Text(p.defaultModel, style: Theme.of(context).textTheme.bodySmall),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 右箭头
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
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
      appBar: AppBar(leading: const BackButton(), title: const Text('AI 搜索设置（预览）')),
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
      appBar: AppBar(leading: const BackButton(), title: const Text('学习模式（预览）')),
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

/// 模型提供商信息（仅用于 Web 预览UI）
class _ProviderInfo {
  final String name;
  final String desc;
  final IconData icon;
  final Color color;
  final String defaultModel;

  const _ProviderInfo({
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.defaultModel,
  });
}
