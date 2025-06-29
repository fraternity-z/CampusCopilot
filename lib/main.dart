import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// 应用程序入口点
/// 
/// 初始化Riverpod状态管理并启动应用
void main() {
  runApp(
    const ProviderScope(
      child: AIAssistantApp(),
    ),
  );
}
