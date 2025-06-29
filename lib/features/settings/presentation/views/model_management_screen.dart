import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../llm_chat/data/providers/llm_provider_factory.dart';

/// 模型管理主页面
class ModelManagementScreen extends ConsumerWidget {
  const ModelManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportedProviders = ref.watch(supportedProvidersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('模型设置'), elevation: 0),
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

          ...supportedProviders.map((providerId) {
            final providerInfo = ref.watch(providerInfoProvider(providerId));
            return _buildProviderCard(context, providerInfo);
          }),
        ],
      ),
    );
  }

  /// 构建提供商配置卡片
  Widget _buildProviderCard(BuildContext context, ProviderInfo providerInfo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          context.push('/settings/models/provider/${providerInfo.id}');
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
                  color: _getProviderColor(
                    providerInfo.id,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getProviderIcon(providerInfo.id),
                  size: 28,
                  color: _getProviderColor(providerInfo.id),
                ),
              ),

              const SizedBox(width: 16),

              // 提供商信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerInfo.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      providerInfo.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildProviderStatus(context, providerInfo),
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
  Widget _buildProviderStatus(BuildContext context, ProviderInfo providerInfo) {
    return Row(
      children: [
        // 状态指示器
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: providerInfo.isSupported ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          providerInfo.isSupported ? '已支持' : '暂未支持',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: providerInfo.isSupported ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        // 默认模型
        if (providerInfo.defaultModel != null) ...[
          Icon(
            Icons.star_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            providerInfo.defaultModel!,
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
      default:
        return Colors.grey;
    }
  }
}
