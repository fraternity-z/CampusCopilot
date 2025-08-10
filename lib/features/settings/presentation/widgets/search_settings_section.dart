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

  // 已移除旧的 API Key 帮助对话，直接在来源为 Tavily 时提供外链按钮
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
  // 已弃用：保留以兼容旧状态（不再使用）
  String _engine = 'google';
  // ignore: unused_field
  String? _endpoint; // 兼容旧字段，避免读取时报错

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
    final enabled = await db.getSetting(
      GeneralSettingsKeys.searchEnabledEngines,
    );
    setState(() {
      _source = s?.isNotEmpty == true ? s : 'tavily';
      _endpoint = e ?? '';
      if (enabled != null && enabled.isNotEmpty) {
        final parts = enabled.split(',').map((e) => e.trim()).toList();
        if (parts.isNotEmpty) _engine = parts.first;
      }
    });
  }

  Future<void> _saveSource(String v) async {
    final db = widget.ref.read(appDatabaseProvider);
    await db.setSetting(GeneralSettingsKeys.searchSource, v);
    widget.ref.read(searchConfigProvider.notifier); // 触发依赖方按需重载
    setState(() => _source = v);
  }

  // ignore: unused_element
  Future<void> _saveEndpoint(String v) async {}

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
            DropdownMenuItem(value: 'model_native', child: Text('模型内置联网（实验）')),
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

          // Direct 引擎单选（Google/Bing/Baidu）
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final id in const ['google', 'bing', 'baidu'])
                ChoiceChip(
                  label: Text(id.toUpperCase()),
                  selected: _engine == id,
                  onSelected: (_) {
                    setState(() => _engine = id);
                    widget.ref
                        .read(searchConfigProvider.notifier)
                        .updateEnabledEngines([id]);
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Orchestrator 已弃用，给出提示
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '已移除 Orchestrator 依赖，Direct 模式将直接使用轻量HTTP抓取，无需额外服务。',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_source == 'tavily') ...[
          // Tavily 需要 API Key
          TextFormField(
            initialValue: widget.ref.read(searchConfigProvider).apiKey ?? '',
            decoration: InputDecoration(
              labelText: 'Tavily API密钥',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () async {
                  final uri = Uri.parse('https://tavily.com');
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
            ),
            obscureText: true,
            onChanged: (v) => widget.ref
                .read(searchConfigProvider.notifier)
                .updateApiKey(v.isNotEmpty ? v : null),
          ),
          const SizedBox(height: 8),
          Text(
            '使用 Tavily 进行联网搜索需要 API 密钥。前往官网申请并粘贴到此处。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
