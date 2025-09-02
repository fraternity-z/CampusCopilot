import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daily_main_screen.dart';

/// 日常管理界面入口
/// 
/// 重定向到新的底部导航主界面
class DailyDashboardScreen extends ConsumerWidget {
  const DailyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DailyMainScreen();
  }
}