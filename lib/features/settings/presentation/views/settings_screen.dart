import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 设置主页面
///
/// 显示各个设置模块的入口
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/chat'),
          tooltip: '返回聊天',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsModule(
            context,
            icon: Icons.model_training,
            title: '模型设置',
            subtitle: '管理AI模型配置、自定义模型和API设置',
            onTap: () => context.push('/settings/models'),
          ),
          const SizedBox(height: 12),
          _buildSettingsModule(
            context,
            icon: Icons.palette,
            title: '外观设置',
            subtitle: '主题、语言等界面设置',
            onTap: () => context.push('/settings/appearance'),
          ),
          const SizedBox(height: 12),
          _buildSettingsModule(
            context,
            icon: Icons.storage,
            title: '数据管理',
            subtitle: '备份、恢复、清空数据',
            onTap: () => context.push('/settings/data'),
          ),
          const SizedBox(height: 12),
          _buildSettingsModule(
            context,
            icon: Icons.info,
            title: '关于',
            subtitle: '版本信息、帮助文档',
            onTap: () => context.push('/settings/about'),
          ),
        ],
      ),
    );
  }

  /// 构建设置模块卡片
  Widget _buildSettingsModule(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
