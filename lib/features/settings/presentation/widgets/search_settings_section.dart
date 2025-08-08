import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../llm_chat/presentation/providers/search_providers.dart';

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

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI搜索设置',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // 启用搜索开关
            SwitchListTile(
              title: const Text('启用AI搜索'),
              subtitle: const Text('允许在对话中进行网络搜索以获取最新信息'),
              value: searchConfig.searchEnabled,
              onChanged: (value) {
                searchNotifier.updateSearchEnabled(value);
              },
            ),
            
            if (searchConfig.searchEnabled) ...[
              const Divider(),
              
              // 搜索引擎选择
              Text(
                '可用搜索引擎',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              ...availableEngines.map((engineMap) {
                final engine = SearchEngine.fromMap(engineMap);
                final isEnabled = searchConfig.enabledEngines.contains(engine.id);
                final hasApiKey = engine.requiresApiKey ? 
                    (searchConfig.apiKey?.isNotEmpty ?? false) : true;
                
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text('${engine.icon} ${engine.name}'),
                          subtitle: engine.requiresApiKey
                              ? Text(hasApiKey ? '✅ API密钥已配置' : '⚠️ 需要API密钥')
                              : const Text('✅ 免费使用'),
                          value: isEnabled,
                          onChanged: engine.requiresApiKey && !hasApiKey
                              ? null // 如果需要API密钥但未配置，则禁用
                              : (value) {
                                  final currentEngines = List<String>.from(searchConfig.enabledEngines);
                                  if (value == true) {
                                    if (!currentEngines.contains(engine.id)) {
                                      currentEngines.add(engine.id);
                                    }
                                  } else {
                                    currentEngines.remove(engine.id);
                                  }
                                  searchNotifier.updateEnabledEngines(currentEngines);
                                },
                        ),
                        
                        // API密钥输入框（仅针对需要API密钥的引擎显示）
                        if (engine.requiresApiKey) ...[
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: searchConfig.apiKey ?? '',
                            decoration: InputDecoration(
                              labelText: '${engine.name} API密钥',
                              hintText: '请输入API密钥',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.help_outline),
                                onPressed: () => _showApiKeyHelp(context, engine),
                              ),
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              searchNotifier.updateApiKey(value.isNotEmpty ? value : null);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
              
              const Divider(),
              
              // 搜索配置
              Text(
                '搜索配置',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              
              // 最大搜索结果数
              ListTile(
                title: const Text('最大搜索结果数'),
                subtitle: Text('当前: ${searchConfig.maxResults}'),
                trailing: SizedBox(
                  width: 100,
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
              ),
              
              // 搜索超时时间
              ListTile(
                title: const Text('搜索超时时间'),
                subtitle: Text('当前: ${searchConfig.timeoutSeconds}秒'),
                trailing: SizedBox(
                  width: 100,
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
        helpText = 'Tavily是一个AI驱动的搜索引擎，提供高质量的搜索结果。\n\n'
            '1. 访问 tavily.com 创建账户\n'
            '2. 在控制台中获取API密钥\n'
            '3. 将密钥粘贴到此处';
        helpUrl = 'https://tavily.com';
        break;
      case 'google':
        helpText = 'Google自定义搜索需要设置自定义搜索引擎。\n\n'
            '1. 访问 Google Custom Search\n'
            '2. 创建搜索引擎并获取API密钥\n'
            '3. 将密钥粘贴到此处';
        helpUrl = 'https://developers.google.com/custom-search/v1/introduction';
        break;
      case 'bing':
        helpText = 'Bing搜索API需要Azure订阅。\n\n'
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
                onPressed: () {
                  // TODO: 打开浏览器
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('请访问: $helpUrl')),
                  );
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
