import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plan_entity.dart';
import '../providers/plan_notifier.dart';
import 'create_plan_page.dart';
import 'plan_detail_page.dart';

/// 计划列表页面
/// 
/// 展示所有计划的列表界面
class PlanListPage extends ConsumerStatefulWidget {
  const PlanListPage({super.key});

  @override
  ConsumerState<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends ConsumerState<PlanListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的计划'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreatePlan,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全部'),
            Tab(text: '待处理'),
            Tab(text: '进行中'),
            Tab(text: '已完成'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlanList(null),
          _buildPlanList(PlanStatus.pending),
          _buildPlanList(PlanStatus.inProgress),
          _buildPlanList(PlanStatus.completed),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePlan,
        tooltip: '创建计划',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 构建计划列表
  Widget _buildPlanList(PlanStatus? statusFilter) {
    final planState = ref.watch(planNotifierProvider);
    
    switch (planState) {
      case Loading():
        return const Center(child: CircularProgressIndicator());
      case Error(message: final error):
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
              Text(
                '加载失败: $error',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(planNotifierProvider.notifier).loadPlans(),
                child: const Text('重试'),
              ),
            ],
          ),
        );
      case Loaded(plans: final plans):
        final filteredPlans = _filterPlansByStatus(plans, statusFilter);

        if (filteredPlans.isEmpty) {
          return _buildEmptyState(statusFilter);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(planNotifierProvider.notifier).loadPlans();
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredPlans.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final plan = filteredPlans[index];
              return _buildPlanCard(plan);
            },
          ),
        );
    }
  }

  /// 构建计划卡片
  Widget _buildPlanCard(PlanEntity plan) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToPlanDetail(plan),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanHeader(plan),
              if (plan.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  plan.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              _buildPlanMetadata(plan),
              if (plan.progress > 0) ...[
                const SizedBox(height: 12),
                _buildProgressBar(plan),
              ],
              if (plan.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildTagsRow(plan.tags),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建计划标题行
  Widget _buildPlanHeader(PlanEntity plan) {
    return Row(
      children: [
        _buildTypeIcon(plan.type),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusChip(plan.status),
                  const SizedBox(width: 8),
                  _buildPriorityChip(plan.priority),
                ],
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, plan),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'complete',
              child: Row(
                children: [
                  Icon(Icons.check, size: 16),
                  SizedBox(width: 8),
                  Text('完成'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建计划元数据
  Widget _buildPlanMetadata(PlanEntity plan) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(plan.planDate),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (plan.startTime != null && plan.endTime != null) ...[
          const SizedBox(width: 16),
          Icon(
            Icons.access_time,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '${_formatTime(plan.startTime!)} - ${_formatTime(plan.endTime!)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(PlanEntity plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '进度',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${plan.progress}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: plan.progress / 100,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          valueColor: AlwaysStoppedAnimation<Color>(
            plan.status == PlanStatus.completed
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// 构建标签行
  Widget _buildTagsRow(List<String> tags) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.take(3).map((tag) => _buildTagChip(tag)).toList(),
    );
  }

  /// 构建标签芯片
  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 11,
        ),
      ),
    );
  }

  /// 构建类型图标
  Widget _buildTypeIcon(PlanType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case PlanType.study:
        iconData = Icons.school;
        color = Colors.blue;
        break;
      case PlanType.work:
        iconData = Icons.work;
        color = Colors.orange;
        break;
      case PlanType.life:
        iconData = Icons.home;
        color = Colors.green;
        break;
      case PlanType.other:
        iconData = Icons.more_horiz;
        color = Colors.grey;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  /// 构建状态芯片
  Widget _buildStatusChip(PlanStatus status) {
    Color color;
    String text;

    switch (status) {
      case PlanStatus.pending:
        color = Colors.orange;
        text = '待处理';
        break;
      case PlanStatus.inProgress:
        color = Colors.blue;
        text = '进行中';
        break;
      case PlanStatus.completed:
        color = Colors.green;
        text = '已完成';
        break;
      case PlanStatus.cancelled:
        color = Colors.red;
        text = '已取消';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建优先级芯片
  Widget _buildPriorityChip(PlanPriority priority) {
    Color color;
    IconData icon;

    switch (priority) {
      case PlanPriority.low:
        color = Colors.green;
        icon = Icons.keyboard_arrow_down;
        break;
      case PlanPriority.medium:
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case PlanPriority.high:
        color = Colors.red;
        icon = Icons.keyboard_arrow_up;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: 12),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(PlanStatus? statusFilter) {
    String message;
    switch (statusFilter) {
      case PlanStatus.pending:
        message = '暂无待处理的计划';
        break;
      case PlanStatus.inProgress:
        message = '暂无进行中的计划';
        break;
      case PlanStatus.completed:
        message = '暂无已完成的计划';
        break;
      default:
        message = '暂无计划，点击右下角按钮创建第一个计划吧！';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 显示搜索对话框
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索计划'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: '输入关键词搜索计划...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {}); // 触发重建以应用搜索
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  /// 导航到创建计划页面
  void _navigateToCreatePlan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreatePlanPage(),
      ),
    );
  }

  /// 导航到计划详情页面
  void _navigateToPlanDetail(PlanEntity plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlanDetailPage(plan: plan),
      ),
    );
  }

  /// 处理菜单操作
  void _handleMenuAction(String action, PlanEntity plan) {
    switch (action) {
      case 'edit':
        // 编辑功能暂未实现
        // 编辑功能开发中
        break;
      case 'complete':
        _completePlan(plan);
        break;
      case 'delete':
        _showDeleteConfirmDialog(plan);
        break;
    }
  }

  /// 完成计划
  void _completePlan(PlanEntity plan) async {
    try {
      await ref.read(planNotifierProvider.notifier).updatePlanStatus(
        plan.id, 
        PlanStatus.completed,
      );
    } catch (e) {
      // 完成失败
    }
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(PlanEntity plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除计划"${plan.title}"吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              try {
                await ref.read(planNotifierProvider.notifier).deletePlan(plan.id);
              } catch (e) {
                // 删除失败
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 按状态过滤计划列表
  List<PlanEntity> _filterPlansByStatus(List<PlanEntity> plans, PlanStatus? statusFilter) {
    var filtered = plans;

    if (statusFilter != null) {
      filtered = filtered.where((plan) => plan.status == statusFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((plan) {
        return plan.title.toLowerCase().contains(query) ||
            (plan.description?.toLowerCase().contains(query) ?? false) ||
            plan.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final planDay = DateTime(date.year, date.month, date.day);

    if (planDay == today) {
      return '今天';
    } else if (planDay == tomorrow) {
      return '明天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  /// 格式化时间
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

}