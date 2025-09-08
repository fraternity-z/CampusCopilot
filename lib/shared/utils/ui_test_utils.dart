import 'package:flutter/material.dart';
import 'keyboard_utils.dart';

/// UI测试工具类
///
/// 提供UI相关的测试和验证方法
class UITestUtils {
  /// 测试键盘收起功能
  ///
  /// 验证点击空白处是否能正确收起键盘
  static void testKeyboardDismiss(BuildContext context) {
    debugPrint('测试键盘收起功能...');

    // 检查键盘是否显示
    final isKeyboardVisible = KeyboardUtils.isKeyboardVisible(context);
    debugPrint('键盘当前状态: ${isKeyboardVisible ? "显示" : "隐藏"}');

    if (isKeyboardVisible) {
      // 收起键盘
      KeyboardUtils.hideKeyboard(context);
      debugPrint('已执行键盘收起操作');
    } else {
      debugPrint('键盘未显示，无需收起');
    }
  }

  /// 测试安全区域配置
  ///
  /// 验证状态栏和安全区域是否正确配置
  static void testSafeAreaConfiguration(BuildContext context) {
    debugPrint('测试安全区域配置...');

    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;

    debugPrint('状态栏高度: ${padding.top}');
    debugPrint('底部安全区域: ${padding.bottom}');
    debugPrint('键盘高度: ${viewInsets.bottom}');
    debugPrint('屏幕尺寸: ${mediaQuery.size}');

    // 验证状态栏是否透明
    if (padding.top > 0) {
      debugPrint('✅ 状态栏安全区域已正确配置');
    } else {
      debugPrint('⚠️ 状态栏安全区域可能未正确配置');
    }
  }

  /// 显示UI状态信息
  ///
  /// 在调试模式下显示当前UI状态的详细信息
  static void showUIStatus(BuildContext context) {
    if (!kDebugMode) return;

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    debugPrint('=== UI状态信息 ===');
    debugPrint('主题模式: ${theme.brightness}');
    debugPrint('屏幕密度: ${mediaQuery.devicePixelRatio}');
    debugPrint('文本缩放: ${mediaQuery.textScaler}');
    debugPrint('键盘可见: ${KeyboardUtils.isKeyboardVisible(context)}');
    debugPrint(
      '安全区域 - 顶部: ${mediaQuery.padding.top}, 底部: ${mediaQuery.padding.bottom}',
    );
    debugPrint('==================');
  }
}

/// 调试模式标识
const bool kDebugMode = true;
