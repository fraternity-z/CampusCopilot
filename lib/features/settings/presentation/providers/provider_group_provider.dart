import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../../data/local/app_database.dart';
import 'custom_provider_notifier.dart';

/// UI层面的分组数据结构
class ProviderGroupUI {
  final String groupName; // 分组名称(如 deepseek, openai)
  final String displayName; // 显示名称
  final List<LlmConfigsTableData> configs; // 该分组下的配置
  final bool isExpanded; // 是否展开
  final IconData icon; // 图标
  final Color color; // 颜色

  const ProviderGroupUI({
    required this.groupName,
    required this.displayName,
    required this.configs,
    this.isExpanded = true,
    required this.icon,
    required this.color,
  });

  /// 复制并修改展开状态
  ProviderGroupUI copyWith({
    String? groupName,
    String? displayName,
    List<LlmConfigsTableData>? configs,
    bool? isExpanded,
    IconData? icon,
    Color? color,
  }) {
    return ProviderGroupUI(
      groupName: groupName ?? this.groupName,
      displayName: displayName ?? this.displayName,
      configs: configs ?? this.configs,
      isExpanded: isExpanded ?? this.isExpanded,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  /// 启用的配置数量
  int get enabledCount => configs.where((config) => config.isEnabled).length;

  /// 总配置数量  
  int get totalCount => configs.length;
}

/// 分组展开状态管理
class ProviderGroupNotifier extends StateNotifier<Map<String, bool>> {
  ProviderGroupNotifier() : super({});

  /// 切换分组展开状态
  void toggleGroup(String groupName) {
    state = {
      ...state,
      groupName: !(state[groupName] ?? true),
    };
  }

  /// 设置分组展开状态
  void setGroupExpanded(String groupName, bool expanded) {
    state = {
      ...state,
      groupName: expanded,
    };
  }

  /// 获取分组展开状态
  bool isExpanded(String groupName) {
    return state[groupName] ?? true;
  }
}

/// 分组展开状态Provider
final providerGroupNotifierProvider = StateNotifierProvider<ProviderGroupNotifier, Map<String, bool>>((ref) {
  return ProviderGroupNotifier();
});

/// 分组数据Provider
final providerGroupsProvider = Provider<List<ProviderGroupUI>>((ref) {
  final customProviders = ref.watch(customProvidersListProvider);
  final groupExpandedStates = ref.watch(providerGroupNotifierProvider);
  
  return _groupProviders(customProviders, groupExpandedStates);
});

/// 按名称前缀分组逻辑
List<ProviderGroupUI> _groupProviders(
  List<LlmConfigsTableData> providers, 
  Map<String, bool> expandedStates,
) {
  // 按提供商名称分组
  final Map<String, List<LlmConfigsTableData>> groups = {};
  
  for (final provider in providers) {
    final groupName = _extractGroupName(provider);
    groups.putIfAbsent(groupName, () => []).add(provider);
  }
  
  // 转换为UI分组对象
  return groups.entries.map((entry) {
    final groupName = entry.key;
    final configs = entry.value;
    
    return ProviderGroupUI(
      groupName: groupName,
      displayName: _getGroupDisplayName(groupName),
      configs: configs,
      isExpanded: expandedStates[groupName] ?? true,
      icon: _getGroupIcon(groupName),
      color: _getGroupColor(groupName),
    );
  }).toList()
    ..sort((a, b) => a.displayName.compareTo(b.displayName));
}

/// 提取分组名称
String _extractGroupName(LlmConfigsTableData provider) {
  final name = provider.customProviderName?.toLowerCase() ?? 
                provider.name.toLowerCase();
  
  // 提取提供商前缀
  if (name.contains('deepseek')) return 'deepseek';
  if (name.contains('openai') || name.contains('gpt')) return 'openai';
  if (name.contains('google') || name.contains('gemini')) return 'google';
  if (name.contains('anthropic') || name.contains('claude')) return 'anthropic';
  if (name.contains('qwen') || name.contains('tongyi')) return 'qwen';
  if (name.contains('openrouter')) return 'openrouter';
  if (name.contains('ollama')) return 'ollama';
  if (name.contains('moonshot') || name.contains('kimi')) return 'moonshot';
  if (name.contains('zhipu') || name.contains('glm')) return 'zhipu';
  
  // 默认使用原提供商名称
  return provider.provider;
}

/// 获取分组显示名称
String _getGroupDisplayName(String groupName) {
  switch (groupName.toLowerCase()) {
    case 'deepseek':
      return 'DeepSeek';
    case 'openai':
      return 'OpenAI';
    case 'google':
      return 'Google';
    case 'anthropic':
      return 'Anthropic';
    case 'qwen':
      return '通义千问';
    case 'openrouter':
      return 'OpenRouter';
    case 'ollama':
      return 'Ollama';
    case 'moonshot':
      return 'Moonshot AI';
    case 'zhipu':
      return '智谱AI';
    default:
      return LlmProviderFactory.getProviderDisplayName(groupName);
  }
}

/// 获取分组图标
IconData _getGroupIcon(String groupName) {
  switch (groupName.toLowerCase()) {
    case 'deepseek':
      return Icons.psychology_alt;
    case 'openai':
      return Icons.psychology;
    case 'google':
      return Icons.auto_awesome;
    case 'anthropic':
      return Icons.smart_toy;
    case 'qwen':
      return Icons.translate;
    case 'openrouter':
      return Icons.hub;
    case 'ollama':
      return Icons.computer;
    case 'moonshot':
      return Icons.rocket_launch;
    case 'zhipu':
      return Icons.auto_fix_high;
    default:
      return Icons.api;
  }
}

/// 获取分组颜色
Color _getGroupColor(String groupName) {
  switch (groupName.toLowerCase()) {
    case 'deepseek':
      return Colors.purple;
    case 'openai':
      return Colors.green;
    case 'google':
      return Colors.blue;
    case 'anthropic':
      return Colors.orange;
    case 'qwen':
      return Colors.red;
    case 'openrouter':
      return Colors.teal;
    case 'ollama':
      return Colors.indigo;
    case 'moonshot':
      return Colors.deepPurple;
    case 'zhipu':
      return Colors.cyan;
    default:
      return Colors.grey;
  }
}