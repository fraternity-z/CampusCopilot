import 'dart:async';
import 'package:flutter/material.dart';

/// Web 预览：思维链可视化占位
class ThinkingChainPreviewWeb extends StatefulWidget {
  const ThinkingChainPreviewWeb({super.key});

  @override
  State<ThinkingChainPreviewWeb> createState() => _ThinkingChainPreviewWebState();
}

class _ThinkingChainPreviewWebState extends State<ThinkingChainPreviewWeb> {
  final List<String> _chunks = [];

  @override
  void initState() {
    super.initState();
    _simulate();
  }

  void _simulate() {
    const full = [
      'Step 1: 分解问题',
      'Step 2: 列出假设',
      'Step 3: 推导与验证',
      'Step 4: 得出结论',
    ];
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i >= full.length) { t.cancel(); return; }
      setState(() { _chunks.add(full[i++]); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('思维链预览（Web）')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _chunks.length,
        itemBuilder: (_, i) => _bubble(context, _chunks[i], i),
      ),
    );
  }

  Widget _bubble(BuildContext context, String text, int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 10, backgroundColor: Colors.amber, child: Text('${i+1}', style: const TextStyle(fontSize: 12, color: Colors.black))),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

