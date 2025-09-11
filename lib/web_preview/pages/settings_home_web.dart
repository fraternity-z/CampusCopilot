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
    // 预览本地状态
    String learningStyle = 'guided'; // guided / exploratory / structured
    String responseDetail = 'normal'; // brief / normal / detailed
    int maxRounds = 5;
    bool showHints = true;
    final triggerKeywords = ['给答案', '直接答案', '最终答案'];

    final theme = Theme.of(context);

    Widget radioCard({required bool selected, required String title, required String subtitle, VoidCallback? onTap}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: selected ? theme.colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
            ),
            child: Row(children: [
              Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ]),
              ),
            ]),
          ),
        ),
      );
    }

    Widget sectionTitle(String t, [String? sub]) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        if (sub != null) ...[
          const SizedBox(height: 8),
          Text(sub, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.school_outlined, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 8),
          const Text('学习模式设置'),
        ]),
        leading: const BackButton(),
      ),
      body: StatefulBuilder(builder: (context, set) {
        return ListView(padding: const EdgeInsets.all(16), children: [
          // 状态指示条
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('学习模式已启用', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('AI将使用苏格拉底式教学方法，引导您思考', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ])),
            ]),
          ),

          const SizedBox(height: 24),

          // 学习风格
          sectionTitle('学习风格', '选择适合您的教学引导方式'),
          const SizedBox(height: 16),
          radioCard(
            selected: learningStyle == 'guided',
            title: '引导式',
            subtitle: '通过提问引导学生思考，逐步发现答案',
            onTap: () => set(() => learningStyle = 'guided'),
          ),
          const SizedBox(height: 12),
          radioCard(
            selected: learningStyle == 'exploratory',
            title: '探索式',
            subtitle: '鼓励学生自主探索，提供开放性问题',
            onTap: () => set(() => learningStyle = 'exploratory'),
          ),
          const SizedBox(height: 12),
          radioCard(
            selected: learningStyle == 'structured',
            title: '结构化',
            subtitle: '按照知识点结构，循序渐进地学习',
            onTap: () => set(() => learningStyle = 'structured'),
          ),

          const SizedBox(height: 32),

          // 回答详细程度
          sectionTitle('回答详细程度', '控制AI回答的详细程度和引导深度'),
          const SizedBox(height: 16),
          radioCard(
            selected: responseDetail == 'brief',
            title: '粗略',
            subtitle: '简单引导，关键提示',
            onTap: () => set(() => responseDetail = 'brief'),
          ),
          const SizedBox(height: 12),
          radioCard(
            selected: responseDetail == 'normal',
            title: '默认',
            subtitle: '适中引导，逐步提示',
            onTap: () => set(() => responseDetail = 'normal'),
          ),
          const SizedBox(height: 12),
          radioCard(
            selected: responseDetail == 'detailed',
            title: '详细',
            subtitle: '深入引导，充分解释',
            onTap: () => set(() => responseDetail = 'detailed'),
          ),

          const SizedBox(height: 32),

          // 学习会话设置 -> 最大对话轮数
          sectionTitle('学习会话设置', '配置学习会话的行为和参数'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('最大对话轮数', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text('设置学习会话的最大轮数，达到后AI将给出完整答案', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('$maxRounds 轮', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 16),
              Slider(value: maxRounds.toDouble(), min: 3, max: 15, divisions: 12, label: '$maxRounds 轮', onChanged: (v) => set(() => maxRounds = v.round())),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('3 轮', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text('15 轮', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ]),
            ]),
          ),

          const SizedBox(height: 20),

          // 智能答案触发关键词
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.psychology_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('智能答案触发', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
              ]),
              const SizedBox(height: 12),
              Text('当您在学习过程中使用以下关键词时，AI将直接给出完整答案：', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final k in triggerKeywords)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primaryContainer, width: 1),
                    ),
                    child: Text('"$k"', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Expanded(child: Text('也可以在对话中直接说"我想要答案"来触发', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8), fontStyle: FontStyle.italic))),
              ]),
            ]),
          ),

          const SizedBox(height: 32),

          // 其他设置：显示学习提示
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('显示学习提示', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('在学习过程中显示引导性提示信息', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ])),
              const SizedBox(width: 16),
              Switch(value: showHints, onChanged: (v) => set(() => showHints = v)),
            ]),
          ),
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
