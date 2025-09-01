import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classtable_view.dart';
import '../services/class_status_service.dart';

/// 日常总览页面
/// 
/// 包含课程表和计划表，上下排列布局
class DailyOverviewPage extends ConsumerStatefulWidget {
  const DailyOverviewPage({super.key});

  @override
  ConsumerState<DailyOverviewPage> createState() => _DailyOverviewPageState();
}

class _DailyOverviewPageState extends ConsumerState<DailyOverviewPage> {
  DailyClassStatus? _classStatus;
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _loadClassStatus();
  }

  /// 加载课程状态（伪实时计算）
  Future<void> _loadClassStatus() async {
    if (mounted) {
      setState(() {
        _isLoadingStatus = true;
      });
      
      try {
        final status = await ClassStatusService.calculateTodayStatus();
        if (mounted) {
          setState(() {
            _classStatus = status;
            _isLoadingStatus = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _classStatus = DailyClassStatus.empty();
            _isLoadingStatus = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 欢迎区域
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          
          // 课程表卡片
          _buildClassTableCard(),
          const SizedBox(height: 16),
          
          // 计划表卡片
          _buildPlannerCard(),
          const SizedBox(height: 16),
          
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
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 28,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '欢迎来到日常管理',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '管理您的课程表和计划安排',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建课程表卡片
  Widget _buildClassTableCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: _navigateToClassTable,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.schedule_outlined,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '课程表',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理您的课程安排',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              // 课程预览信息
              if (!_isLoadingStatus && _classStatus != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: _buildClassPreview(),
                ),
              ],
              if (_isLoadingStatus) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '加载课程状态...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建课程预览
  Widget _buildClassPreview() {
    final status = _classStatus!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              status.currentClass != null 
                ? Icons.play_circle_outline 
                : Icons.schedule,
              size: 16,
              color: status.currentClass != null 
                ? Colors.green 
                : Colors.blue,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                status.statusText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: status.currentClass != null 
                    ? Colors.green 
                    : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        if (status.currentClass != null || status.nextClass != null) ...[
          const SizedBox(height: 8),
          if (status.currentClass != null)
            _buildCourseDetailRow(
              '当前课程',
              status.currentClass!,
              Colors.green,
            ),
          if (status.nextClass != null)
            _buildCourseDetailRow(
              '下节课程',
              status.nextClass!,
              Colors.orange,
            ),
        ],
      ],
    );
  }

  /// 构建课程详情行
  Widget _buildCourseDetailRow(String label, ClassStatus courseStatus, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$label: ${courseStatus.courseName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${courseStatus.timeRange}${courseStatus.classroom != null ? ' · ${courseStatus.classroom}' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建计划表卡片
  Widget _buildPlannerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showComingSoon('计划表'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.task_outlined,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '计划表',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '制定和跟踪计划',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              // 计划表预览信息（TODO占位符）
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.1),
                  ),
                ),
                child: _buildPlannerPreview(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建计划表预览（TODO占位符）
  Widget _buildPlannerPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.pending_actions,
              size: 16,
              color: Colors.green,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '今日计划概览',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // TODO项目列表占位符
        _buildTodoItemPlaceholder('完成项目文档撰写', true),
        _buildTodoItemPlaceholder('参与团队会议讨论', false),
        _buildTodoItemPlaceholder('复习算法与数据结构', false),
      ],
    );
  }

  /// 构建TODO项目占位符
  Widget _buildTodoItemPlaceholder(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.transparent,
              border: Border.all(
                color: Colors.green,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    size: 8,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : null,
                fontSize: 12,
              ),
            ),
          ),
        ],
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
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

  /// 导航到课程表界面
  void _navigateToClassTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClassTableView(),
      ),
    );
  }
}