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

/// 外观设置（Web 预览）
class _AppearanceSettingsWeb extends StatelessWidget {
  const _AppearanceSettingsWeb();
  @override
  Widget build(BuildContext context) {
    // 本页仅 UI 预览，使用本地状态
    String themeMode = 'system'; // system / light / dark
    Color seed = Theme.of(context).colorScheme.primary;
    double fontScale = 1.0;
    double radius = 16;
    String language = 'zh-CN';

    Widget sectionTitle(String text) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        );

    Widget card(Widget child) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: child,
        );

    final palette = const [
      Color(0xFF9B87F5), Color(0xFF4F46E5), Color(0xFF22C55E), Color(0xFFF59E0B),
      Color(0xFFEC4899), Color(0xFF06B6D4), Color(0xFFEF4444), Color(0xFF6366F1),
    ];

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('外观设置')),
      body: StatefulBuilder(builder: (context, set) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            // 主题模式
            card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sectionTitle('主题模式'),
              Wrap(spacing: 8, children: [
                ChoiceChip(label: const Text('跟随系统'), selected: themeMode == 'system', onSelected: (_) => set(() => themeMode = 'system')),
                ChoiceChip(label: const Text('浅色'), selected: themeMode == 'light', onSelected: (_) => set(() => themeMode = 'light')),
                ChoiceChip(label: const Text('深色'), selected: themeMode == 'dark', onSelected: (_) => set(() => themeMode = 'dark')),
              ]),
            ])),

            const SizedBox(height: 16),

            // 主题色
            card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sectionTitle('主题色'),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: palette.length,
                itemBuilder: (_, i) {
                  final c = palette[i];
                  final sel = c.toARGB32() == seed.toARGB32();
                  return InkWell(
                    onTap: () => set(() => seed = c),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sel ? Colors.white : Colors.black.withValues(alpha: 0.1), width: sel ? 2 : 1),
                        boxShadow: [BoxShadow(color: c.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: sel ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                },
              ),
            ])),

            const SizedBox(height: 16),

            // 字体与圆角
            card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sectionTitle('字体与圆角'),
              Text('字体缩放：${fontScale.toStringAsFixed(2)}'),
              Slider(value: fontScale, min: 0.9, max: 1.2, divisions: 6, onChanged: (v) => set(() => fontScale = v)),
              const SizedBox(height: 8),
              Text('组件圆角：${radius.toStringAsFixed(0)}'),
              Slider(value: radius, min: 8, max: 24, divisions: 16, onChanged: (v) => set(() => radius = v)),
            ])),

            const SizedBox(height: 16),

            // 语言
            card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sectionTitle('语言'),
              DropdownButtonFormField<String>(
                initialValue: language,
                items: const [
                  DropdownMenuItem(value: 'zh-CN', child: Text('中文（简体）')),
                  DropdownMenuItem(value: 'en-US', child: Text('English')),
                ],
                onChanged: (v) => set(() => language = v ?? language),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ])),

            const SizedBox(height: 16),

            // 预览卡片
            card(Row(children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: seed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.palette, color: seed)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('预览效果'),
                SizedBox(height: 4),
                Text('此处展示卡片/按钮的风格示意（仅UI预览，不改变全局主题）'),
              ])),
              const SizedBox(width: 12),
              FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: seed), child: const Text('按钮')),
            ])),
          ],
        );
      }),
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
    String provider = 'tavily';
    int maxResults = 5;
    int timeoutSec = 10;
    int summaryLen = 512;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('AI 搜索设置'),
      ),
      body: StatefulBuilder(builder: (context, set) {
        Widget sectionTitle(String text) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            );

        Widget card(Widget child) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: child,
            );

        Widget dropdownProvider() => DropdownButtonFormField<String>(
              initialValue: provider,
              items: const [
                DropdownMenuItem(value: 'tavily', child: Text('Tavily（API密钥）')),
                DropdownMenuItem(value: 'serpapi', child: Text('SerpAPI（API密钥）')),
                DropdownMenuItem(value: 'bing', child: Text('Bing Web Search（密钥）')),
              ],
              onChanged: (v) => set(() => provider = v ?? provider),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            );

        Widget apiKeyField() => TextField(
              onChanged: (v) => set(() as VoidCallback),
              decoration: InputDecoration(
                hintText: '${provider[0].toUpperCase()}${provider.substring(1)} API密钥',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  tooltip: '获取方式',
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {},
                ),
              ),
            );

        Widget sliderRow({
          required String label,
          required String hint,
          required double value,
          required double min,
          required double max,
          int? divisions,
          required ValueChanged<double> onChanged,
        }) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                const SizedBox(height: 4),
                Text('当前: $hint', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            // 大标题 + 描述
            Text('AI 搜索设置', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('在此配置搜索服务商与密钥；是否调用由聊天页输入框的“AI搜索”快速开关控制。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),

            // 网络搜索（来源）
            card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.travel_explore, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('网络搜索', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                sectionTitle('联网来源'),
                dropdownProvider(),
                const SizedBox(height: 10),
                apiKeyField(),
                const SizedBox(height: 6),
                Text('使用 $provider 进行联网搜索需要 API 密钥。前往官网申请并粘贴到此处。',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            )),

            const SizedBox(height: 16),

            // 搜索配置
            card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('搜索配置'),
                sliderRow(
                  label: '最大搜索结果数',
                  hint: '$maxResults',
                  value: maxResults.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (v) => set(() => maxResults = v.round()),
                ),
                sliderRow(
                  label: '搜索超时时间',
                  hint: '$timeoutSec秒',
                  value: timeoutSec.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 25,
                  onChanged: (v) => set(() => timeoutSec = v.round()),
                ),
              ],
            )),

            const SizedBox(height: 16),

            // 结果过滤
            card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle('结果过滤'),
                sliderRow(
                  label: '最大摘要长度',
                  hint: '$summaryLen 字',
                  value: summaryLen.toDouble(),
                  min: 128,
                  max: 2048,
                  divisions: 30,
                  onChanged: (v) => set(() => summaryLen = v.round()),
                ),
              ],
            )),
          ],
        );
      }),
    );
  }
}

/// 学习模式占位
class _LearningModeSettingsWeb extends StatelessWidget {
  const _LearningModeSettingsWeb();
  @override
  Widget build(BuildContext context) {
    String mode = 'socratic';
    double difficulty = 0.6;
    int session = 20; // 学习时长（分钟）
    bool enableHints = true;
    bool enableReasoning = true;
    bool enableCitations = false;
    final subjects = <String>{'数学', '物理'};
    final allSubjects = ['数学','物理','化学','计算机','历史','文学'];

    Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
    );

    Widget card(Widget child) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: child,
    );

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), centerTitle: true, title: const Text('学习模式')),
      body: StatefulBuilder(builder: (context, set) {
        return ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), children: [
          // 模式选择
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sectionTitle('教学模式'),
            DropdownButtonFormField<String>(
              initialValue: mode,
              items: const [
                DropdownMenuItem(value: 'socratic', child: Text('苏格拉底式')),
                DropdownMenuItem(value: 'qa', child: Text('问答式')),
              ],
              onChanged: (v) => set(()=> mode = v ?? mode),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ])),

          const SizedBox(height: 16),

          // 学习参数
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sectionTitle('学习参数'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('难度调节'), Text(difficulty.toStringAsFixed(2))]),
            Slider(value: difficulty, min: 0, max: 1, divisions: 10, onChanged: (v)=>set(()=>difficulty=v)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('单次学习时长（分钟）'), Text('$session')]),
            Slider(value: session.toDouble(), min: 10, max: 60, divisions: 10, onChanged: (v)=>set(()=>session=v.round())),
            const SizedBox(height: 8),
            SwitchListTile(title: const Text('启用提示链（Hint）'), value: enableHints, onChanged: (v)=>set(()=>enableHints=v)),
            SwitchListTile(title: const Text('启用逐步推理（Chain-of-Thought）'), value: enableReasoning, onChanged: (v)=>set(()=>enableReasoning=v)),
          ])),

          const SizedBox(height: 16),

          // 结果格式
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sectionTitle('结果格式'),
            SwitchListTile(title: const Text('显示参考/引用'), value: enableCitations, onChanged: (v)=>set(()=>enableCitations=v)),
          ])),

          const SizedBox(height: 16),

          // 学科与目标
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            sectionTitle('学科选择'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in allSubjects)
                FilterChip(
                  label: Text(s),
                  selected: subjects.contains(s),
                  onSelected: (sel) => set(() { sel ? subjects.add(s) : subjects.remove(s); }),
                ),
            ]),
          ])),
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
