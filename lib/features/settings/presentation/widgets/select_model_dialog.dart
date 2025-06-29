import 'package:flutter/material.dart';

import '../../../llm_chat/domain/providers/llm_provider.dart';

/// 选择模型弹窗
/// 传入模型列表，勾选后返回用户选中的 ModelInfo 列表
class SelectModelDialog extends StatefulWidget {
  const SelectModelDialog({super.key, required this.models});

  final List<ModelInfo> models;

  @override
  State<SelectModelDialog> createState() => _SelectModelDialogState();
}

class _SelectModelDialogState extends State<SelectModelDialog> {
  final TextEditingController _search = TextEditingController();
  late List<ModelInfo> _filtered;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _filtered = List.of(widget.models);
  }

  void _filter(String q) {
    setState(() {
      _filtered = widget.models
          .where((m) => m.id.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '搜索模型 id',
                ),
                onChanged: _filter,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('没有匹配的模型'))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final model = _filtered[index];
                        final selected = _selectedIds.contains(model.id);
                        return CheckboxListTile(
                          title: Text(model.id),
                          value: selected,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedIds.add(model.id);
                              } else {
                                _selectedIds.remove(model.id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () {
                            final selectedModels = widget.models
                                .where((m) => _selectedIds.contains(m.id))
                                .toList();
                            Navigator.pop(context, selectedModels);
                          },
                    child: const Text('添加已选'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
