import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:url_launcher/url_launcher.dart';
import '../../../llm_chat/presentation/providers/search_providers.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/tables/general_settings_table.dart';

/// 搜索引擎信息类
class SearchEngine {
  final String id;
  final String name;
  final String description;
  final bool requiresApiKey;
  final String icon;

  const SearchEngine({
    required this.id,
    required this.name,
    required this.description,
    required this.requiresApiKey,
    required this.icon,
  });

  factory SearchEngine.fromMap(Map<String, String> map) {
    return SearchEngine(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      requiresApiKey: map['requiresApiKey'] == 'true',
      icon: map['icon'] ?? '',
    );
  }
}

/// 搜索设置部分组件
class SearchSettingsSection extends ConsumerWidget {
  const SearchSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchConfig = ref.watch(searchConfigProvider);
    final searchNotifier = ref.read(searchConfigProvider.notifier);
    final availableEngines = ref.watch(availableSearchEnginesProvider);
    // 兼容热重载期间状态结构变化导致的临时类型问题（在具体控件处内联处理）

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI搜索设置', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // 顶部仅显示说明；启用逻辑交给聊天输入区的快捷开关
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('网络搜索'),
              subtitle: const Text('此处配置搜索服务商与密钥；是否调用由聊天页输入框的“AI搜索”快捷开关控制'),
              leading: const Icon(Icons.travel_explore),
            ),

            // ====== 联网来源切换（模型内置 / Tavily / 直接检索） ======
            const Divider(),
            Text('联网来源', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _SearchSourceConfig(ref: ref),

            ...[
              const Divider(),

              // 搜索服务商（单选）
              Text('搜索服务商', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  // 计算当前选择，若无则回退为第一个
                  final hasDefault = availableEngines.any(
                    (e) => e['id'] == searchConfig.defaultEngine,
                  );
                  final selectedId = hasDefault
                      ? searchConfig.defaultEngine
                      : (availableEngines.isNotEmpty
                            ? availableEngines.first['id']!
                            : '');

                  Map<String, String> selectedEngine =
                      availableEngines.isNotEmpty
                      ? Map<String, String>.from(
                          availableEngines.firstWhere(
                            (e) => e['id'] == selectedId,
                            orElse: () => availableEngines.first,
                          ),
                        )
                      : <String, String>{};

                  String itemLabel(Map<String, String> m) {
                    final needKey = m['requiresApiKey'] == 'true';
                    final name = m['name'] ?? '';
                    return needKey ? '$name（API密钥）' : '$name（免费）';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedId.isEmpty ? null : selectedId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          for (final m in availableEngines)
                            DropdownMenuItem(
                              value: m['id'],
                              child: Text(
                                itemLabel(Map<String, String>.from(m)),
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          searchNotifier.updateDefaultEngine(value);
                          searchNotifier.updateEnabledEngines([value]);
                        },
                      ),
                      const SizedBox(height: 12),

                      // 当前搜索服务商配置
                      if (selectedEngine.isNotEmpty)
                        Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      selectedEngine['icon'] ?? '🔎',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        selectedEngine['name'] ?? '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  selectedEngine['description'] ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                if (selectedEngine['requiresApiKey'] == 'true')
                                  TextFormField(
                                    initialValue: searchConfig.apiKey ?? '',
                                    decoration: InputDecoration(
                                      labelText:
                                          '${selectedEngine['name']} API密钥',
                                      hintText: '请输入API密钥',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.help_outline),
                                        onPressed: () => _showApiKeyHelp(
                                          context,
                                          SearchEngine.fromMap(selectedEngine),
                                        ),
                                      ),
                                    ),
                                    obscureText: true,
                                    onChanged: (value) {
                                      searchNotifier.updateApiKey(
                                        value.isNotEmpty ? value : null,
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const Divider(),

              // 搜索配置
              Text('搜索配置', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),

              // 最大搜索结果数（更长且对齐）
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('最大搜索结果数'),
                subtitle: Text('当前: ${searchConfig.maxResults}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  value: searchConfig.maxResults.toDouble(),
                  min: 3,
                  max: 10,
                  divisions: 7,
                  label: searchConfig.maxResults.toString(),
                  onChanged: (value) {
                    searchNotifier.updateMaxResults(value.round());
                  },
                ),
              ),

              // 搜索超时时间（更长且对齐，移除多余展示）
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('搜索超时时间'),
                subtitle: Text('当前: ${searchConfig.timeoutSeconds}秒'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  value: searchConfig.timeoutSeconds.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: '${searchConfig.timeoutSeconds}s',
                  onChanged: (value) {
                    searchNotifier.updateTimeoutSeconds(value.round());
                  },
                ),
              ),

              const SizedBox(height: 8),
              Text('结果过滤', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              // 黑名单开关（兼容热重载状态变化）
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: (() {
                  try {
                    return searchConfig.blacklistEnabled;
                  } catch (_) {
                    return false;
                  }
                })(),
                onChanged: (v) => ref
                    .read(searchConfigProvider.notifier)
                    .updateBlacklistEnabled(v),
                title: const Text('启用黑名单'),
                subtitle: const Text('过滤命中规则的网站，不在搜索结果中展示'),
                secondary: const Icon(Icons.block),
              ),
              const SizedBox(height: 8),
              // 黑名单规则编辑
              TextFormField(
                initialValue: (() {
                  try {
                    return searchConfig.blacklistRules;
                  } catch (_) {
                    return '';
                  }
                })(),
                decoration: const InputDecoration(
                  labelText: '黑名单规则（每行一条，可用 /regex/ 表示正则）',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText:
                      '示例:\n* 直接写域名：example.com\n* 正则：/.*\\.spam\\.com/\n* 可加#注释说明',
                ),
                minLines: 3,
                maxLines: 6,
                onChanged: (v) => ref
                    .read(searchConfigProvider.notifier)
                    .updateBlacklistRules(v),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showApiKeyHelp(BuildContext context, SearchEngine engine) {
    String helpText;
    String? helpUrl;

    switch (engine.id) {
      case 'tavily':
        helpText =
            'Tavily是一个AI驱动的搜索引擎，提供高质量的搜索结果。\n\n'
            '1. 访问 tavily.com 创建账户\n'
            '2. 在控制台中获取API密钥\n'
            '3. 将密钥粘贴到此处';
        helpUrl = 'https://tavily.com';
        break;
      case 'google':
        helpText =
            'Google自定义搜索需要设置自定义搜索引擎。\n\n'
            '1. 访问 Google Custom Search\n'
            '2. 创建搜索引擎并获取API密钥\n'
            '3. 将密钥粘贴到此处';
        helpUrl = 'https://developers.google.com/custom-search/v1/introduction';
        break;
      case 'bing':
        helpText =
            'Bing搜索API需要Azure订阅。\n\n'
            '1. 在Azure门户中创建Bing搜索资源\n'
            '2. 获取订阅密钥\n'
            '3. 将密钥粘贴到此处';
        helpUrl = 'https://portal.azure.com';
        break;
      default:
        helpText = '请参考官方文档获取API密钥。';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${engine.name} API密钥帮助'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(helpText),
            if (helpUrl != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  // 优先尝试使用默认浏览器打开链接，失败则提示手动访问
                  final uri = Uri.parse(helpUrl!);
                  // 预先获取 messenger，避免在 await 之后使用 context
                  final messenger = ScaffoldMessenger.maybeOf(context);
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!launched && messenger != null) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('请访问: $helpUrl')),
                    );
                  }
                },
                child: const Text('打开官方网站'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

// ============ 子组件：联网来源配置 ============
class _SearchSourceConfig extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _SearchSourceConfig({required this.ref});

  @override
  ConsumerState<_SearchSourceConfig> createState() =>
      _SearchSourceConfigState();
}

class _SearchSourceConfigState extends ConsumerState<_SearchSourceConfig> {
  String? _source;
  String? _endpoint;
  List<String> _engines = const ['google', 'bing', 'baidu'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = widget.ref.read(appDatabaseProvider);
    final s = await db.getSetting(GeneralSettingsKeys.searchSource);
    final e = await db.getSetting(
      GeneralSettingsKeys.searchOrchestratorEndpoint,
    );
    setState(() {
      _source = s?.isNotEmpty == true ? s : 'tavily';
      _endpoint = e ?? '';
    });
  }

  Future<void> _saveSource(String v) async {
    final db = widget.ref.read(appDatabaseProvider);
    await db.setSetting(GeneralSettingsKeys.searchSource, v);
    widget.ref.read(searchConfigProvider.notifier); // 触发依赖方按需重载
    setState(() => _source = v);
  }

  Future<void> _saveEndpoint(String v) async {
    final db = widget.ref.read(appDatabaseProvider);
    await db.setSetting(GeneralSettingsKeys.searchOrchestratorEndpoint, v);
    setState(() => _endpoint = v);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _source,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: 'model_native', child: Text('模型内置联网（推荐）')),
            DropdownMenuItem(value: 'tavily', child: Text('Tavily（API密钥）')),
            DropdownMenuItem(value: 'direct', child: Text('直接检索（实验）')),
          ],
          onChanged: (v) {
            if (v == null) return;
            _saveSource(v);
          },
        ),
        const SizedBox(height: 12),

        if (_source == 'direct') ...[
          if (isMobile)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '移动端轻量检索：仅基于HTTP解析公共SERP，易受限、结果可能不完整。建议优先使用“模型内置联网”或 Tavily。',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

          // Direct 引擎多选（仅三项）
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final id in const ['google', 'bing', 'baidu'])
                FilterChip(
                  label: Text(id.toUpperCase()),
                  selected: _engines.contains(id),
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _engines = {..._engines, id}.toList();
                      } else {
                        _engines = _engines.where((e) => e != id).toList();
                      }
                    });
                    // 这里仅在内存中记录，实际使用时 ChatService 会读 `enabledEngines`
                    widget.ref
                        .read(searchConfigProvider.notifier)
                        .updateEnabledEngines(_engines);
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Orchestrator 地址
          TextFormField(
            initialValue: _endpoint,
            decoration: const InputDecoration(
              labelText: 'Orchestrator 地址（留空=启用轻量直接检索）',
              border: OutlineInputBorder(),
            ),
            onChanged: _saveEndpoint,
          ),
        ],
      ],
    );
  }
}
