import 'package:flutter/material.dart';

/// Web 预览版：创建计划
class CreatePlanPageWeb extends StatefulWidget {
  const CreatePlanPageWeb({super.key});

  @override
  State<CreatePlanPageWeb> createState() => _CreatePlanPageWebState();
}

class _CreatePlanPageWebState extends State<CreatePlanPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _type = '学习';
  String _priority = '中';
  bool _loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建计划（Web 预览）'),
        actions: [
          TextButton(onPressed: _loading ? null : _submit, child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('保存')),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '计划标题', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title)),
              validator: (v) => (v==null || v.trim().isEmpty) ? '请输入标题' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: '计划描述（可选）', border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _dropdown('类型', _type, ['学习','工作','生活','其他'], (v){setState(()=>_type=v!);})),
              const SizedBox(width: 12),
              Expanded(child: _dropdown('优先级', _priority, ['低','中','高'], (v){setState(()=>_priority=v!);})),
            ]),
            const SizedBox(height: 16),
            _dateSelector(context),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _timeSelector(context, '开始时间', _startTime, (t)=> setState(()=>_startTime=t))),
              const SizedBox(width: 12),
              Expanded(child: _timeSelector(context, '结束时间', _endTime, (t)=> setState(()=>_endTime=t))),
            ]),
            const SizedBox(height: 16),
            TextFormField(controller: _tagsController, decoration: const InputDecoration(labelText: '标签（逗号分隔）', border: OutlineInputBorder(), prefixIcon: Icon(Icons.tag))),
            const SizedBox(height: 16),
            TextFormField(controller: _notesController, maxLines: 3, decoration: const InputDecoration(labelText: '备注（可选）', border: OutlineInputBorder(), prefixIcon: Icon(Icons.note))),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: FilledButton.icon(icon: const Icon(Icons.add), label: const Text('创建计划'), onPressed: _loading ? null : _submit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _dateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 365)));
        if (picked != null) setState(()=>_selectedDate=picked);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text('计划日期: ${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日'),
        ]),
      ),
    );
  }

  Widget _timeSelector(BuildContext context, String label, TimeOfDay? time, void Function(TimeOfDay?) onChanged) {
    final selected = time != null;
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
          onChanged(picked);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5) : Theme.of(context).dividerColor, width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(selected ? time.format(context) : '$label（可选）')),
            Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.primary),
          ]),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(()=>_loading=true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(()=>_loading=false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('仅预览：已模拟创建计划')));
    Navigator.of(context).maybePop();
  }
}

