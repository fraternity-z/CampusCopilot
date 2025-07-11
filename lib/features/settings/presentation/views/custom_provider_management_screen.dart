import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';
import '../widgets/custom_provider_edit_dialog.dart';
import '../providers/custom_provider_notifier.dart';

/// 自定义提供商管理界面
class CustomProviderManagementScreen extends ConsumerStatefulWidget {
  const CustomProviderManagementScreen({super.key});

  @override
  ConsumerState<CustomProviderManagementScreen> createState() =>
      _CustomProviderManagementScreenState();
}

class _CustomProviderManagementScreenState
    extends ConsumerState<CustomProviderManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义提供商管理'),
        actions: [
          IconButton(
            onPressed: _showAddProviderDialog,
            icon: const Icon(Icons.add),
            tooltip: '添加自定义提供商',
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final customProviders = ref.watch(customProvidersListProvider);
          final isLoading = ref.watch(customProvidersLoadingProvider);
          final error = ref.watch(customProvidersErrorProvider);

          if (error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text('加载失败', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(customProviderNotifierProvider.notifier)
                          .loadProviders();
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildProviderList(customProviders);
        },
      ),
    );
  }

  /// 构建提供商列表
  Widget _buildProviderList(List<LlmConfigsTableData> customProviders) {
    if (customProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.api_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无自定义提供商',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右上角的 + 按钮添加自定义提供商',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _showAddProviderDialog,
              icon: const Icon(Icons.add),
              label: const Text('添加自定义提供商'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customProviders.length,
      itemBuilder: (context, index) {
        final provider = customProviders[index];
        return _buildProviderCard(provider);
      },
    );
  }

  /// 构建提供商卡片
  Widget _buildProviderCard(LlmConfigsTableData provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 提供商图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getProviderColor(
                      provider.apiCompatibilityType,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getProviderIcon(provider.apiCompatibilityType),
                    size: 24,
                    color: _getProviderColor(provider.apiCompatibilityType),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (provider.customProviderDescription != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          provider.customProviderDescription!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // API兼容性类型
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getProviderColor(
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
                                    color: _getProviderColor(
                                      provider.apiCompatibilityType,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 状态指示器
                          Container(
                            width: 8,
                            height: 8,
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
                // 操作按钮
                PopupMenuButton<String>(
                  onSelected: (action) =>
                      _handleProviderAction(provider, action),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('编辑'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: provider.isEnabled ? 'disable' : 'enable',
                      child: ListTile(
                        leading: Icon(
                          provider.isEnabled
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        title: Text(provider.isEnabled ? '禁用' : '启用'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('删除', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取提供商图标
  IconData _getProviderIcon(String compatibilityType) {
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

  /// 获取提供商颜色
  Color _getProviderColor(String compatibilityType) {
    switch (compatibilityType.toLowerCase()) {
      case 'openai':
        return Colors.green;
      case 'gemini':
        return Colors.blue;
      case 'anthropic':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// 显示添加提供商对话框
  void _showAddProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomProviderEditDialog(
        onSaved: () {
          ref.read(customProviderNotifierProvider.notifier).loadProviders();
        },
      ),
    );
  }

  /// 显示编辑提供商对话框
  void _showEditProviderDialog(LlmConfigsTableData provider) {
    showDialog(
      context: context,
      builder: (context) => CustomProviderEditDialog(
        provider: provider,
        onSaved: () {
          ref.read(customProviderNotifierProvider.notifier).loadProviders();
        },
      ),
    );
  }

  /// 处理提供商操作
  void _handleProviderAction(LlmConfigsTableData provider, String action) {
    switch (action) {
      case 'edit':
        _showEditProviderDialog(provider);
        break;
      case 'enable':
      case 'disable':
        _toggleProviderStatus(provider);
        break;
      case 'delete':
        _showDeleteConfirmDialog(provider);
        break;
    }
  }

  /// 切换提供商状态
  Future<void> _toggleProviderStatus(LlmConfigsTableData provider) async {
    try {
      final database = ref.read(appDatabaseProvider);
      final updatedConfig = LlmConfigsTableCompanion(
        id: drift.Value(provider.id),
        name: drift.Value(provider.name),
        provider: drift.Value(provider.provider),
        apiKey: drift.Value(provider.apiKey),
        baseUrl: drift.Value(provider.baseUrl),
        defaultModel: drift.Value(provider.defaultModel),
        defaultEmbeddingModel: drift.Value(provider.defaultEmbeddingModel),
        organizationId: drift.Value(provider.organizationId),
        projectId: drift.Value(provider.projectId),
        extraParams: drift.Value(provider.extraParams),
        createdAt: drift.Value(provider.createdAt),
        updatedAt: drift.Value(DateTime.now()),
        isEnabled: drift.Value(!provider.isEnabled),
        isCustomProvider: drift.Value(provider.isCustomProvider),
        apiCompatibilityType: drift.Value(provider.apiCompatibilityType),
        customProviderName: drift.Value(provider.customProviderName),
        customProviderDescription: drift.Value(
          provider.customProviderDescription,
        ),
        customProviderIcon: drift.Value(provider.customProviderIcon),
      );

      await database.upsertLlmConfig(updatedConfig);
      ref.read(customProviderNotifierProvider.notifier).loadProviders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.isEnabled ? '提供商已禁用' : '提供商已启用')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('操作失败: $e')));
      }
    }
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(LlmConfigsTableData provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
          '确定要删除提供商 "${provider.customProviderName ?? provider.name}" 吗？此操作不可撤销。',
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              context.pop();
              _deleteProvider(provider);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 删除提供商
  Future<void> _deleteProvider(LlmConfigsTableData provider) async {
    try {
      final database = ref.read(appDatabaseProvider);
      await database.deleteLlmConfig(provider.id);
      ref.read(customProviderNotifierProvider.notifier).loadProviders();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('提供商已删除')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    }
  }
}
