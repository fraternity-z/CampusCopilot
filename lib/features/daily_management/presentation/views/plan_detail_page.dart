import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plan_entity.dart';
import '../providers/plan_notifier.dart';

/// 计划详情页面
/// 
/// 展示单个计划的详细信息和操作
class PlanDetailPage extends ConsumerStatefulWidget {
  final PlanEntity plan;

  const PlanDetailPage({
    super.key,
    required this.plan,
  });

  @override
  ConsumerState<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends ConsumerState<PlanDetailPage> {
  late PlanEntity _currentPlan;

  @override
  void initState() {
    super.initState();
    _currentPlan = widget.plan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计划详情'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
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
              if (_currentPlan.status != PlanStatus.completed)
                const PopupMenuItem(
                  value: 'complete',
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.green),
                      SizedBox(width: 8),
                      Text('完成'),
                    ],
                  ),
                ),
              if (_currentPlan.status == PlanStatus.pending)
                const PopupMenuItem(
                  value: 'start',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('开始'),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// 构建头部区域
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getTypeColor(_currentPlan.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTypeIcon(_currentPlan.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPlan.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(_currentPlan.type),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusChip(_currentPlan.status),
                        const SizedBox(width: 8),
                        _buildPriorityChip(_currentPlan.priority),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_currentPlan.description?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Text(
              _currentPlan.description!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _getTypeColor(_currentPlan.type).withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_currentPlan.progress > 0) _buildProgressCard(),
          const SizedBox(height: 16),
          _buildTimeCard(),
          const SizedBox(height: 16),
          if (_currentPlan.tags.isNotEmpty) _buildTagsCard(),
          if (_currentPlan.notes?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            _buildNotesCard(),
          ],
          const SizedBox(height: 16),
          _buildMetadataCard(),
        ],
      ),
    );
  }

  /// 构建进度卡片
  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, size: 20),
                const SizedBox(width: 8),
                Text(
                  '完成进度',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_currentPlan.progress}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _currentPlan.progress >= 100
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _currentPlan.progress / 100,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                _currentPlan.progress >= 100
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
            if (_currentPlan.progress < 100) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateProgress(_currentPlan.progress + 25),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('+25%'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateProgress(_currentPlan.progress + 50),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('+50%'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建时间卡片
  Widget _buildTimeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 20),
                const SizedBox(width: 8),
                Text(
                  '时间安排',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTimeItem(
              Icons.calendar_today,
              '计划日期',
              _formatDate(_currentPlan.planDate),
            ),
            if (_currentPlan.startTime != null && _currentPlan.endTime != null) ...[
              const SizedBox(height: 8),
              _buildTimeItem(
                Icons.access_time,
                '执行时间',
                '${_formatTime(_currentPlan.startTime!)} - ${_formatTime(_currentPlan.endTime!)}',
              ),
            ],
            if (_currentPlan.reminderTime != null) ...[
              const SizedBox(height: 8),
              _buildTimeItem(
                Icons.notifications,
                '提醒时间',
                _formatTime(_currentPlan.reminderTime!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建时间项
  Widget _buildTimeItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 构建标签卡片
  Widget _buildTagsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tag, size: 20),
                const SizedBox(width: 8),
                Text(
                  '标签',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentPlan.tags
                  .map((tag) => _buildTagChip(tag))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建备注卡片
  Widget _buildNotesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note, size: 20),
                const SizedBox(width: 8),
                Text(
                  '备注',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentPlan.notes!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建元数据卡片
  Widget _buildMetadataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  '计划信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetadataItem('创建时间', _formatDateTime(_currentPlan.createdAt)),
            const SizedBox(height: 4),
            _buildMetadataItem('更新时间', _formatDateTime(_currentPlan.updatedAt)),
            if (_currentPlan.completedAt != null) ...[
              const SizedBox(height: 4),
              _buildMetadataItem('完成时间', _formatDateTime(_currentPlan.completedAt!)),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建元数据项
  Widget _buildMetadataItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPlan.status == PlanStatus.pending)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _updateStatus(PlanStatus.inProgress),
                icon: const Icon(Icons.play_arrow),
                label: const Text('开始'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          if (_currentPlan.status == PlanStatus.inProgress) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _updateStatus(PlanStatus.pending),
                icon: const Icon(Icons.pause),
                label: const Text('暂停'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _updateStatus(PlanStatus.completed),
                icon: const Icon(Icons.check),
                label: const Text('完成'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
          if (_currentPlan.status == PlanStatus.completed)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '已完成',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(PlanType type) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getTypeColor(type).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getTypeIconData(type),
        color: _getTypeColor(type),
        size: 24,
      ),
    );
  }

  /// 构建状态芯片
  Widget _buildStatusChip(PlanStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status).withValues(alpha: 0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建优先级芯片
  Widget _buildPriorityChip(PlanPriority priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(priority).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPriorityIconData(priority),
            color: _getPriorityColor(priority),
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              color: _getPriorityColor(priority),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建标签芯片
  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  /// 处理菜单操作
  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        // 编辑功能开发中
        break;
      case 'complete':
        _updateStatus(PlanStatus.completed);
        break;
      case 'start':
        _updateStatus(PlanStatus.inProgress);
        break;
      case 'delete':
        _showDeleteConfirmDialog();
        break;
    }
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除计划"${_currentPlan.title}"吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              try {
                await ref.read(planNotifierProvider.notifier).deletePlan(widget.plan.id);
                // 关闭对话框
                if (navigator.canPop()) {
                  navigator.pop();
                }
                // 返回列表页面
                if (navigator.canPop()) {
                  navigator.pop();
                }
              } catch (e) {
                // 删除失败，只关闭对话框
                if (navigator.canPop()) {
                  navigator.pop();
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 更新计划状态
  void _updateStatus(PlanStatus newStatus) {
    setState(() {
      _currentPlan = _currentPlan.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        completedAt: newStatus == PlanStatus.completed ? DateTime.now() : null,
        progress: newStatus == PlanStatus.completed ? 100 : _currentPlan.progress,
      );
    });

    // 状态已更新
  }

  /// 更新计划进度
  void _updateProgress(int newProgress) {
    final progress = newProgress.clamp(0, 100);
    final status = progress >= 100 ? PlanStatus.completed : PlanStatus.inProgress;

    setState(() {
      _currentPlan = _currentPlan.copyWith(
        progress: progress,
        status: status,
        updatedAt: DateTime.now(),
        completedAt: progress >= 100 ? DateTime.now() : null,
      );
    });

    // 进度已更新
  }

  // 辅助方法
  Color _getTypeColor(PlanType type) {
    switch (type) {
      case PlanType.study:
        return Colors.blue;
      case PlanType.work:
        return Colors.orange;
      case PlanType.life:
        return Colors.green;
      case PlanType.other:
        return Colors.grey;
    }
  }

  IconData _getTypeIconData(PlanType type) {
    switch (type) {
      case PlanType.study:
        return Icons.school;
      case PlanType.work:
        return Icons.work;
      case PlanType.life:
        return Icons.home;
      case PlanType.other:
        return Icons.more_horiz;
    }
  }

  Color _getStatusColor(PlanStatus status) {
    switch (status) {
      case PlanStatus.pending:
        return Colors.orange;
      case PlanStatus.inProgress:
        return Colors.blue;
      case PlanStatus.completed:
        return Colors.green;
      case PlanStatus.cancelled:
        return Colors.red;
    }
  }

  Color _getPriorityColor(PlanPriority priority) {
    switch (priority) {
      case PlanPriority.low:
        return Colors.green;
      case PlanPriority.medium:
        return Colors.orange;
      case PlanPriority.high:
        return Colors.red;
    }
  }

  IconData _getPriorityIconData(PlanPriority priority) {
    switch (priority) {
      case PlanPriority.low:
        return Icons.keyboard_arrow_down;
      case PlanPriority.medium:
        return Icons.remove;
      case PlanPriority.high:
        return Icons.keyboard_arrow_up;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }
}