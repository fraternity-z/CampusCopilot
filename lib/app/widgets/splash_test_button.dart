import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/splash_provider.dart';

/// 测试启动屏按钮
/// 用于开发和演示，允许重新显示启动屏动画
class SplashTestButton extends ConsumerWidget {
  const SplashTestButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () {
        // 重置启动屏状态，再次显示动画
        ref.read(splashProvider.notifier).reset();
      },
      icon: const Icon(Icons.refresh),
      label: const Text('重播启动动画'),
      tooltip: '点击重新播放启动屏动画',
    );
  }
}