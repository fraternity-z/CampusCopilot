import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'classtable_view.dart';
import 'plan_list_page.dart';
import 'create_plan_page.dart';
import '../services/class_status_service.dart';
import '../providers/plan_notifier.dart';
import '../../domain/entities/plan_entity.dart';

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
      physics: const BouncingScrollPhysics(), // 改进垂直滚动物理效果
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
        onTap: _navigateToPlanList,
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
              // 今日计划预览
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

  /// 构建计划表预览
  Widget _buildPlannerPreview() {
    final todayPlans = ref.watch(todayPlansProvider);
    
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
            Text(
              '${todayPlans.length}项',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        if (todayPlans.isEmpty)
          _buildEmptyPlanItem()
        else
          ...todayPlans.take(3).map((plan) => _buildPlanItem(plan)),
          
        if (todayPlans.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '...还有${todayPlans.length - 3}项计划',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建计划项目
  Widget _buildPlanItem(PlanEntity plan) {
    final isCompleted = plan.status == PlanStatus.completed;
    final priority = plan.priority;
    
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
                color: _getPriorityColor(priority),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (plan.startTime != null && plan.endTime != null)
                  Text(
                    '${_formatTime(plan.startTime!)} - ${_formatTime(plan.endTime!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          if (!isCompleted)
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: _getPriorityColor(priority),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  /// 构建空计划项
  Widget _buildEmptyPlanItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.event_available,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '今天暂无计划，点击添加第一个计划',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 获取优先级颜色
  Color _getPriorityColor(PlanPriority priority) {
    switch (priority) {
      case PlanPriority.high:
        return Colors.red;
      case PlanPriority.medium:
        return Colors.orange;
      case PlanPriority.low:
        return Colors.green;
    }
  }

  /// 格式化时间
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
                onTap: _navigateToCreatePlan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                title: '查看今日',
                icon: Icons.today,
                color: Colors.green,
                onTap: _navigateToPlanList,
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


  /// 导航到课程表界面
  void _navigateToClassTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ClassTableView(),
      ),
    );
  }

  /// 导航到计划列表界面
  void _navigateToPlanList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PlanListPage(),
      ),
    );
  }

  /// 导航到创建计划界面
  void _navigateToCreatePlan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreatePlanPage(),
      ),
    );
  }
}