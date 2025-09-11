import 'package:flutter/material.dart';

/// Web 预览：图表构建器（占位版，不渲染真实图表）
class ChartBuilderDialogWebPage extends StatelessWidget {
  const ChartBuilderDialogWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图表构建器（Web 预览）')),
      body: Center(
        child: FilledButton(
          onPressed: () => _openDialog(context),
          child: const Text('打开图表对话框'),
        ),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('从 JSON 生成图表（占位）'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: '{\n  "type": "bar",\n  "data": [1,2,3]\n}',
                  border: OutlineInputBorder(),
                  labelText: '图表 JSON（示例）',
                ),
              ),
              SizedBox(height: 12),
              _ChartPreviewPlaceholder(),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('生成')),
        ],
      ),
    );
  }
}

class _ChartPreviewPlaceholder extends StatelessWidget {
  const _ChartPreviewPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      alignment: Alignment.center,
      child: Text('预览占位（不渲染真实图表）', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}

