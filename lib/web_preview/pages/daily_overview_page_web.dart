import 'package:flutter/material.dart';
import 'plan_list_page_web.dart';
import 'create_plan_page_web.dart';

/// Web 预览版：日常总览
class DailyOverviewPageWeb extends StatelessWidget {
  const DailyOverviewPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final status = _sampleDailyClassStatus();
    final todayPlans = _samplePlans();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcome(context),
          const SizedBox(height: 16),
          _buildCard(
            context,
            title: '课程表',
            icon: Icons.schedule_outlined,
            color: Colors.blue,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlanListPageWeb(title: '课程表（Web 预览）')),
            ),
            child: _buildClassPreview(context, status),
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: '计划表',
            icon: Icons.task_outlined,
            color: Colors.green,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlanListPageWeb()),
            ),
            child: _buildPlanPreview(context, todayPlans),
          ),
          const SizedBox(height: 12),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
        ]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('欢迎来到日常管理', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                )),
                Text('管理您的课程表和计划安排', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right),
              ]),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassPreview(BuildContext context, _DailyClassStatus status) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(status.currentClass != null ? Icons.play_circle_outline : Icons.schedule, color: status.currentClass != null ? Colors.green : Colors.blue, size: 16),
          const SizedBox(width: 6),
          Expanded(child: Text(status.statusText, style: TextStyle(color: status.currentClass != null ? Colors.green : Colors.blue))),
        ]),
        if (status.currentClass != null) ...[
          const SizedBox(height: 6),
          Text('当前课程：${status.currentClass!.courseName}  ${status.currentClass!.timeRange}', style: Theme.of(context).textTheme.bodySmall),
        ],
        if (status.nextClass != null) ...[
          const SizedBox(height: 2),
          Text('下节课程：${status.nextClass!.courseName}  ${status.nextClass!.timeRange}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ]),
    );
  }

  Widget _buildPlanPreview(BuildContext context, List<_Plan> plans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.today, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Expanded(child: Text('今日计划概览', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.w500))),
          Text('${plans.length}项', style: const TextStyle(color: Colors.green)),
        ]),
        const SizedBox(height: 8),
        if (plans.isEmpty) const Text('今天暂无计划，点击添加第一个计划'),
        for (final p in plans.take(3)) Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: p.completed ? Colors.green : Colors.transparent,
                border: Border.all(color: _priorityColor(p.priority), width: 1.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(child: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (!p.completed) Container(width: 4, height: 4, decoration: BoxDecoration(color: _priorityColor(p.priority), shape: BoxShape.circle)),
          ]),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _quickButton(context, '新建计划', Icons.add_task, Colors.blue, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreatePlanPageWeb()));
        }),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _quickButton(context, '查看今日', Icons.today, Colors.green, () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlanListPageWeb()));
        }),
      ),
    ]);
  }

  Widget _quickButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }
}

// ---- 简易样例数据模型（仅用于 Web 预览） ----

class _ClassStatus { final String courseName; final String timeRange; _ClassStatus(this.courseName, this.timeRange); }
class _DailyClassStatus { final _ClassStatus? currentClass; final _ClassStatus? nextClass; final String statusText; _DailyClassStatus({this.currentClass, this.nextClass, required this.statusText}); }
_DailyClassStatus _sampleDailyClassStatus() {
  return _DailyClassStatus(
    currentClass: _ClassStatus('数据结构', '第3-4节 10:25-12:00'),
    nextClass: _ClassStatus('操作系统', '第5-6节 14:00-15:35'),
    statusText: '正在上课：数据结构',
  );
}

enum _Priority { low, medium, high }
class _Plan { final String title; final _Priority priority; final bool completed; _Plan(this.title, this.priority, this.completed); }
List<_Plan> _samplePlans() => [
  _Plan('完成实验报告', _Priority.high, false),
  _Plan('预习第5章', _Priority.medium, false),
  _Plan('锻炼30分钟', _Priority.low, true),
];

Color _priorityColor(_Priority p) {
  switch (p) {
    case _Priority.high: return Colors.red;
    case _Priority.medium: return Colors.orange;
    case _Priority.low: return Colors.green;
  }
}

