import 'package:flutter/material.dart';

/// Web 预览版：计划列表
class PlanListPageWeb extends StatefulWidget {
  final String? title;
  const PlanListPageWeb({super.key, this.title});

  @override
  State<PlanListPageWeb> createState() => _PlanListPageWebState();
}

class _PlanListPageWebState extends State<PlanListPageWeb> with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _query = '';
  final _all = _samplePlans();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '我的计划（Web 预览）'),
        bottom: TabBar(controller: _tab, tabs: const [
          Tab(text: '全部'), Tab(text: '待处理'), Tab(text: '进行中'), Tab(text: '已完成'),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: TabBarView(controller: _tab, children: [
        _buildList(null), _buildList(_Status.pending), _buildList(_Status.inProgress), _buildList(_Status.completed),
      ]),
    );
  }

  Widget _buildList(_Status? status) {
    final list = _filtered(_all, status, _query);
    if (list.isEmpty) {
      return Center(
        child: Text(
          status == null ? '暂无计划' : '暂无${_statusText(status)}的计划',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _card(context, list[i]),
    );
  }

  Widget _card(BuildContext context, _Plan plan) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _typeIcon(plan.type),
            const SizedBox(width: 8),
            Expanded(child: Text(plan.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
            _statusChip(plan.status),
            const SizedBox(width: 6),
            _priorityChip(plan.priority),
          ]),
          if (plan.description != null) ...[
            const SizedBox(height: 8),
            Text(plan.description!, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.calendar_today, size: 14),
            const SizedBox(width: 4),
            Text('${plan.planDate.month}月${plan.planDate.day}日'),
            if (plan.startTime != null && plan.endTime != null) ...[
              const SizedBox(width: 12), const Icon(Icons.access_time, size: 14), const SizedBox(width: 4),
              Text('${_fmt(plan.startTime!)} - ${_fmt(plan.endTime!)}'),
            ],
          ]),
        ]),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text('搜索计划'),
        content: TextField(
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '输入关键词...'),
          onChanged: (v) => _query = v,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(onPressed: () { setState(() {}); Navigator.pop(context); }, child: const Text('搜索')),
        ],
      );
    });
  }
}

// ---- 样例数据（仅用于 Web 预览） ----
enum _Type { study, work, life, other }
enum _Priority { low, medium, high }
enum _Status { pending, inProgress, completed, cancelled }

class _Plan {
  final String title;
  final String? description;
  final _Type type;
  final _Priority priority;
  final _Status status;
  final DateTime planDate;
  final DateTime? startTime;
  final DateTime? endTime;

  _Plan({
    required this.title,
    this.description,
    required this.type,
    required this.priority,
    required this.status,
    required this.planDate,
    this.startTime,
    this.endTime,
  });
}

List<_Plan> _samplePlans() {
  final now = DateTime.now();
  DateTime t(int h, int m) => DateTime(now.year, now.month, now.day, h, m);
  return [
    _Plan(title: '完成实验报告', description: '第3章与第4章', type: _Type.study, priority: _Priority.high, status: _Status.inProgress, planDate: now, startTime: t(10, 0), endTime: t(11, 30)),
    _Plan(title: '健身', description: '跑步+力量', type: _Type.life, priority: _Priority.medium, status: _Status.pending, planDate: now, startTime: t(19, 0), endTime: t(20, 0)),
    _Plan(title: '写总结', description: '周报', type: _Type.work, priority: _Priority.low, status: _Status.completed, planDate: now),
  ];
}

List<_Plan> _filtered(List<_Plan> all, _Status? s, String q) {
  var list = all;
  if (s != null) list = list.where((p) => p.status == s).toList();
  if (q.isNotEmpty) list = list.where((p) => p.title.contains(q) || (p.description?.contains(q) ?? false)).toList();
  return list;
}

String _fmt(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
String _statusText(_Status s){switch(s){case _Status.pending:return '待处理';case _Status.inProgress:return '进行中';case _Status.completed:return '已完成';case _Status.cancelled:return '已取消';}}

Widget _typeIcon(_Type t) {
  final map = {
    _Type.study: (Icons.school, Colors.blue),
    _Type.work: (Icons.work, Colors.orange),
    _Type.life: (Icons.home, Colors.green),
    _Type.other: (Icons.more_horiz, Colors.grey),
  };
  final (icon, color) = map[t]!;
  return Icon(icon, color: color);
}

Widget _statusChip(_Status s) {
  Color color; String text;
  switch (s) {case _Status.pending: color=Colors.orange; text='待处理'; break; case _Status.inProgress: color=Colors.blue; text='进行中'; break; case _Status.completed: color=Colors.green; text='已完成'; break; case _Status.cancelled: color=Colors.red; text='已取消'; break;}
  return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))), child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w500)));
}

Widget _priorityChip(_Priority p) {
  final map = {
    _Priority.low: (Icons.keyboard_arrow_down, Colors.green),
    _Priority.medium: (Icons.remove, Colors.orange),
    _Priority.high: (Icons.keyboard_arrow_up, Colors.red),
  };
  final (icon, color) = map[p]!;
  return Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Icon(icon, color: color, size: 12));
}

