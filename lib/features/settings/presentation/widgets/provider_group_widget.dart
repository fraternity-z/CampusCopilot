import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';
import '../providers/provider_group_provider.dart';
import '../providers/custom_provider_notifier.dart';

/// 提供商分组组件
class ProviderGroupWidget extends ConsumerWidget {
  final ProviderGroupUI group;

  const ProviderGroupWidget({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 分组头部
          _buildGroupHeader(context, ref),
          // 分组内容（可折叠）
          if (group.isExpanded) _buildGroupContent(context, ref),
        ],
      ),
    );
  }

  /// 构建分组头部
  Widget _buildGroupHeader(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(providerGroupNotifierProvider.notifier)
            .toggleGroup(group.groupName);
      },
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: group.color.withValues(alpha: 0.08),
          borderRadius: group.isExpanded
              ? const BorderRadius.vertical(top: Radius.circular(12))
              : BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 分组图标
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: group.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                group.icon,
                color: group.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // 分组信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        group.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 配置数量标签
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: group.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${group.enabledCount}/${group.totalCount}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: group.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${group.totalCount}个配置，${group.enabledCount}个已启用',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // 操作按钮
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 一键删除按钮
                IconButton(
                  onPressed: () => _showDeleteGroupDialog(context, ref),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '删除整个分组',
                  iconSize: 20,
                ),
                // 展开/折叠按钮
                AnimatedRotation(
                  turns: group.isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建分组内容
  Widget _buildGroupContent(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: group.configs.map((config) {
          return _buildProviderConfigItem(context, ref, config);
        }).toList(),
      ),
    );
  }

  /// 构建单个提供商配置项
  Widget _buildProviderConfigItem(
    BuildContext context, 
    WidgetRef ref, 
    LlmConfigsTableData config,
  ) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 1,
      child: InkWell(
        onTap: () {
          context.push('/settings/models/provider/${config.id}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 配置状态指示器
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: config.isEnabled ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              
              // 配置信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.customProviderName ?? config.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (config.isCustomProvider) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '自定义',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // 状态文字
              Text(
                config.isEnabled ? '已启用' : '已禁用',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: config.isEnabled ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              
              // 箭头
              Icon(
                Icons.chevron_right,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示删除分组确认对话框
  void _showDeleteGroupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除整个分组'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除 "${group.displayName}" 分组下的所有配置吗？'),
            const SizedBox(height: 8),
            Text(
              '将删除以下 ${group.totalCount} 个配置：',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            ...group.configs.take(3).map((config) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  '• ${config.customProviderName ?? config.name}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }),
            if (group.totalCount > 3)
              Text(
                '... 还有 ${group.totalCount - 3} 个配置',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '此操作无法撤销！',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteGroup(context, ref);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('删除分组'),
          ),
        ],
      ),
    );
  }

  /// 删除整个分组
  Future<void> _deleteGroup(BuildContext context, WidgetRef ref) async {
    try {
      final database = ref.read(appDatabaseProvider);
      
      // 删除分组下所有配置
      for (final config in group.configs) {
        await database.deleteLlmConfig(config.id);
      }
      
      // 刷新自定义提供商列表
      ref.read(customProviderNotifierProvider.notifier).loadProviders();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已删除 "${group.displayName}" 分组下的 ${group.totalCount} 个配置'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}