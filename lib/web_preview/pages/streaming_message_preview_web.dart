import 'dart:async';
import 'package:flutter/material.dart';

/// Web 预览：流式消息内容
class StreamingMessagePreviewWeb extends StatefulWidget {
  const StreamingMessagePreviewWeb({super.key});

  @override
  State<StreamingMessagePreviewWeb> createState() => _StreamingMessagePreviewWebState();
}

class _StreamingMessagePreviewWebState extends State<StreamingMessagePreviewWeb> {
  String _content = '';
  @override
  void initState() {
    super.initState();
    _stream();
  }

  void _stream() {
    const full = '这是一个“流式”消息预览。内容将逐字显示，用于模拟模型输出过程。';
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i >= full.length) { t.cancel(); return; }
      setState(() { _content = full.substring(0, i++); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('流式消息预览（Web）')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_content),
          ),
        ),
      ),
    );
  }
}

