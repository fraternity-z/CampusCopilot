import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/utils/keyboard_utils.dart';

/// 设置主页面
///
/// 显示各个设置模块的入口
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/chat'),
            tooltip: '返回聊天',
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingsModule(
                context,
                icon: Icons.settings,
                title: '常规设置',
                subtitle: '话题自动命名、基础功能配置',
                onTap: () => context.push('/settings/general'),
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
                icon: Icons.model_training,
                title: '模型设置',
                subtitle: '管理AI模型配置、自定义模型和API设置',
                onTap: () => context.push('/settings/models'),
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
                icon: Icons.folder,
                title: '知识库',
                subtitle: '管理文档、索引与向量搜索',
                onTap: () => context.push('/knowledge'),
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
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
