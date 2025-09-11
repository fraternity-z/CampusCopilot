import 'package:flutter/material.dart';
import '../../shared/markdown/markdown_renderer.dart';

/// Web 预览：Markdown 渲染
class MarkdownPreviewWeb extends StatelessWidget {
  const MarkdownPreviewWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final md = _sampleMarkdown;
    final renderer = MarkdownRenderer.defaultRenderer();
    return Scaffold(
      appBar: AppBar(title: const Text('Markdown 预览（Web）')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: renderer.render(md, baseTextStyle: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  String get _sampleMarkdown =>
      '# 标题\n\n'
      '这是一些示例的 **Markdown** 内容，包含代码：\n\n'
      '```dart\nvoid main() {\n  print(\'Hello Markdown\');\n}\n```\n\n'
      '- 列表项 A\n- 列表项 B\n\n'
      '> 引用段落\n\n'
      '[链接](https://example.com)';
}

