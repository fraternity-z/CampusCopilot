import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';
import '../providers/custom_provider_notifier.dart';
import '../widgets/custom_provider_edit_dialog.dart';

/// 自定义提供商列表Provider
final customProvidersProvider = FutureProvider<List<LlmConfigsTableData>>((
  ref,
) async {
  final database = ref.watch(appDatabaseProvider);
  return database.getCustomProviderConfigs();
});

/// 模型管理主页面
class ModelManagementScreen extends ConsumerWidget {
  const ModelManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportedProviders = ref.watch(supportedProvidersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('模型设置'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAddCustomProviderDialog(context, ref),
            icon: const Icon(Icons.add),
            tooltip: '添加自定义提供商',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'AI 提供商配置',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '点击配置各个AI提供商的API密钥、模型列表等设置',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // 内置提供商
          ...supportedProviders.map((providerId) {
            return _buildProviderCard(context, providerId);
          }),

          // 自定义提供商
          Consumer(
            builder: (context, ref, child) {
              final customProviders = ref.watch(customProvidersListProvider);
              return Column(
                children: customProviders.map((provider) {
                  return _buildCustomProviderCard(context, provider);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 显示添加自定义提供商对话框
  void _showAddCustomProviderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CustomProviderEditDialog(
        onSaved: () {
          ref.read(customProviderNotifierProvider.notifier).loadProviders();
        },
      ),
    );
  }

  /// 构建提供商配置卡片
  Widget _buildProviderCard(BuildContext context, String providerId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/settings/models/provider/$providerId');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 提供商图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getProviderColor(providerId).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getProviderIcon(providerId),
                  size: 28,
                  color: _getProviderColor(providerId),
                ),
              ),

              const SizedBox(width: 16),

              // 提供商信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LlmProviderFactory.getProviderDisplayName(providerId),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LlmProviderFactory.getProviderDescription(providerId),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildProviderStatus(context, providerId),
                  ],
                ),
              ),

              // 箭头图标
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建提供商状态
  Widget _buildProviderStatus(BuildContext context, String providerId) {
    final isSupported = LlmProviderFactory.isProviderSupported(providerId);
    final defaultModel = LlmProviderFactory.getDefaultModel(providerId);

    return Row(
      children: [
        // 状态指示器
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSupported ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isSupported ? '已支持' : '暂未支持',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSupported ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        // 默认模型
        if (defaultModel != null) ...[
          Icon(
            Icons.star_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            defaultModel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// 获取提供商图标
  IconData _getProviderIcon(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'openai':
        return Icons.psychology;
      case 'google':
        return Icons.auto_awesome;
      case 'anthropic':
        return Icons.smart_toy;
      case 'deepseek':
        return Icons.psychology_alt;
      case 'qwen':
        return Icons.translate;
      case 'openrouter':
        return Icons.hub;
      case 'ollama':
        return Icons.computer;
      default:
        return Icons.api;
    }
  }

  /// 获取提供商颜色
  Color _getProviderColor(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'openai':
        return Colors.green;
      case 'google':
        return Colors.blue;
      case 'anthropic':
        return Colors.orange;
      case 'deepseek':
        return Colors.purple;
      case 'qwen':
        return Colors.red;
      case 'openrouter':
        return Colors.teal;
      case 'ollama':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  /// 构建自定义提供商卡片
  Widget _buildCustomProviderCard(
    BuildContext context,
    LlmConfigsTableData provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/settings/models/provider/${provider.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 提供商图标
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getCustomProviderColor(
                    provider.apiCompatibilityType,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCustomProviderIcon(provider.apiCompatibilityType),
                  size: 28,
                  color: _getCustomProviderColor(provider.apiCompatibilityType),
                ),
              ),
              const SizedBox(width: 16),

              // 提供商信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.customProviderName ?? provider.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // API兼容性类型标签
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getCustomProviderColor(
                              provider.apiCompatibilityType,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            LlmProviderFactory.getCompatibilityTypeDisplayName(
                              provider.apiCompatibilityType,
                            ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getCustomProviderColor(
                                    provider.apiCompatibilityType,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 状态指示器
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: provider.isEnabled
                                ? Colors.green
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          provider.isEnabled ? '已启用' : '已禁用',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: provider.isEnabled
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 箭头图标
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取自定义提供商图标
  IconData _getCustomProviderIcon(String compatibilityType) {
    switch (compatibilityType.toLowerCase()) {
      case 'openai':
        return Icons.psychology;
      case 'gemini':
        return Icons.auto_awesome;
      case 'anthropic':
        return Icons.smart_toy;
      default:
        return Icons.api;
    }
  }

  /// 获取自定义提供商颜色
  Color _getCustomProviderColor(String compatibilityType) {
    switch (compatibilityType.toLowerCase()) {
      case 'openai':
        return Colors.green;
      case 'gemini':
        return Colors.blue;
      case 'anthropic':
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }
}
