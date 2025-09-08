import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/help_provider.dart';

/// 帮助快速访问组件
class HelpQuickAccess extends ConsumerWidget {
  const HelpQuickAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _getCrossAxisCount(context),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.rocket_launch,
          title: '快速入门',
          description: '新手必看指南',
          color: Colors.blue,
          onTap: () => _navigateToSection(ref, 'quick_start'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.chat,
          title: 'AI对话',
          description: '智能聊天功能',
          color: Colors.green,
          onTap: () => _navigateToSection(ref, 'ai_chat'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.folder,
          title: '知识库',
          description: '文档管理搜索',
          color: Colors.orange,
          onTap: () => _navigateToSection(ref, 'knowledge_base'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.help_outline,
          title: '常见问题',
          description: '问题快速解答',
          color: Colors.purple,
          onTap: () => _navigateToSection(ref, 'faq'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.cloud,
          title: '云端开发',
          description: '云端IDE环境',
          color: Colors.cyan,
          onTap: () => _navigateToSection(ref, 'cloud_development'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.build,
          title: '开发者工具',
          description: 'API和SDK资源',
          color: Colors.amber,
          onTap: () => _navigateToSection(ref, 'developer_tools'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.school,
          title: '学习模式',
          description: '苏格拉底教学',
          color: Colors.teal,
          onTap: () => _navigateToSection(ref, 'learning_mode'),
        ),
        _buildQuickAccessCard(
          context,
          ref,
          icon: Icons.settings_applications,
          title: '高级功能',
          description: '个性化设置',
          color: Colors.indigo,
          onTap: () => _navigateToSection(ref, 'advanced'),
        ),
      ],
    );
  }

  /// 构建快速访问卡片
  Widget _buildQuickAccessCard(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 导航到指定栏目
  void _navigateToSection(WidgetRef ref, String sectionId) {
    ref.read(selectedSectionProvider.notifier).state = sectionId;
    ref.read(selectedHelpItemProvider.notifier).state = null;
  }

  /// 根据屏幕宽度获取列数
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}
