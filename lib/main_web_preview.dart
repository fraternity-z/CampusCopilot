import 'package:flutter/material.dart';

import 'web_preview/web_shell.dart';

/// 独立的 Web 预览入口
/// 使用“页面橱窗（gallery）”展示项目主要页面的 Web 兼容版。
void main() => runApp(const _WebPreviewApp());

class _WebPreviewApp extends StatelessWidget {
  const _WebPreviewApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web 预览',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // 直接进入模拟主壳：侧边栏 + 内容区
      home: const MainShellWeb(),
    );
  }
}
