import 'package:flutter/material.dart';
import '../utils/keyboard_utils.dart';

/// 键盘可收起包装器
/// 
/// 包装子Widget，使其支持点击空白处收起键盘的功能
class KeyboardDismissibleWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const KeyboardDismissibleWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// 安全区域包装器
/// 
/// 提供状态栏安全区域处理，确保内容不被状态栏遮挡
class SafeAreaWrapper extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final EdgeInsets? minimum;

  const SafeAreaWrapper({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      child: child,
    );
  }
}

/// 组合的键盘和安全区域包装器
/// 
/// 同时提供键盘收起和安全区域功能
class KeyboardSafeWrapper extends StatelessWidget {
  final Widget child;
  final bool keyboardDismissible;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final EdgeInsets? safeAreaMinimum;

  const KeyboardSafeWrapper({
    super.key,
    required this.child,
    this.keyboardDismissible = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaMinimum,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // 添加安全区域
    result = SafeAreaWrapper(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      left: safeAreaLeft,
      right: safeAreaRight,
      minimum: safeAreaMinimum,
      child: result,
    );

    // 添加键盘收起功能
    if (keyboardDismissible) {
      result = KeyboardDismissibleWrapper(
        child: result,
      );
    }

    return result;
  }
}
