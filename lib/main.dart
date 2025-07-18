import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'shared/utils/keyboard_utils.dart';

/// 应用程序入口点
///
/// 初始化Riverpod状态管理并启动应用
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 配置系统UI样式
  _configureSystemUI();

  runApp(const ProviderScope(child: AIAssistantApp()));
}

/// 配置系统UI样式
void _configureSystemUI() {
  // 启用边到边显示模式
  KeyboardUtils.enableEdgeToEdge();

  // 配置状态栏样式
  KeyboardUtils.configureSystemUI(
    statusBarTransparent: true,
    statusBarIconBrightness: Brightness.dark,
  );
}
