import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'classtable_view.dart';
import 'profile_view.dart';

/// 日常管理界面
/// 
/// 用于管理用户的日常事务，包括：
/// - 课程表管理
/// - 计划表管理
/// - 个人信息管理
/// - 其他日常工具
class DailyDashboardScreen extends ConsumerStatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  ConsumerState<DailyDashboardScreen> createState() => _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends ConsumerState<DailyDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        '日常',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.chat_outlined),
          onPressed: () => context.go('/chat'),
          tooltip: '返回对话',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// 构建主体内容
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 欢迎区域
          _buildWelcomeSection(),
          const SizedBox(height: 32),
          
          // 功能网格
          _buildFeatureGrid(),
          const SizedBox(height: 32),
          
          // 快捷操作
          _buildQuickActions(),
        ],
      ),
    );
  }

  /// 构建欢迎区域
  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                size: 28,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Text(
                '欢迎来到日常管理',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '在这里管理您的课程表、计划安排和个人事务',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建功能网格
  Widget _buildFeatureGrid() {
    final features = [
      {
        'title': '课程表',
        'subtitle': '管理您的课程安排',
        'icon': Icons.schedule_outlined,
        'color': Colors.blue,
        'onTap': () => _navigateToClassTable(),
      },
      {
        'title': '计划表',
        'subtitle': '制定和跟踪计划',
        'icon': Icons.task_outlined,
        'color': Colors.green,
        'onTap': () => _showComingSoon('计划表'),
      },
      {
        'title': '个人信息',
        'subtitle': '管理个人资料',
        'icon': Icons.person_outline,
        'color': Colors.orange,
        'onTap': () => _navigateToProfile(),
      },
      {
        'title': '设置',
        'subtitle': '偏好设置',
        'icon': Icons.settings_outlined,
        'color': Colors.purple,
        'onTap': () => _showComingSoon('设置'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          title: feature['title'] as String,
          subtitle: feature['subtitle'] as String,
          icon: feature['icon'] as IconData,
          color: feature['color'] as Color,
          onTap: feature['onTap'] as VoidCallback,
        );
      },
    );
  }

  /// 构建功能卡片
  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建快捷操作
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快捷操作',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                title: '新建计划',
                icon: Icons.add_task,
                color: Colors.blue,
                onTap: () => _showComingSoon('新建计划'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                title: '查看今日',
                icon: Icons.today,
                color: Colors.green,
                onTap: () => _showComingSoon('查看今日'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建快捷操作按钮
  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示即将推出提示
  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.construction,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Text('即将推出'),
          ],
        ),
        content: Text('$feature 功能正在开发中，敬请期待！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  /// 导航到个人信息界面
  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileView(),
      ),
    );
  }

  /// 导航到课程表界面
  void _navigateToClassTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClassTableView(),
      ),
    );
  }
}