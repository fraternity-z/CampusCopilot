import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 键盘管理工具类
/// 
/// 提供键盘相关的实用方法，包括收起键盘、键盘状态检测等
class KeyboardUtils {
  /// 收起键盘
  /// 
  /// 通过移除焦点来收起当前显示的键盘
  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    } else {
      currentFocus.unfocus();
    }
  }

  /// 检查键盘是否显示
  /// 
  /// 通过MediaQuery检测键盘是否当前显示
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// 获取键盘高度
  /// 
  /// 返回当前键盘的高度
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// 配置系统UI样式
  /// 
  /// 设置状态栏和导航栏的样式
  static void configureSystemUI({
    SystemUiOverlayStyle? style,
    bool? statusBarTransparent,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      style ?? SystemUiOverlayStyle(
        statusBarColor: statusBarTransparent == true ? Colors.transparent : null,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// 启用边到边显示模式
  /// 
  /// 让应用内容延伸到状态栏和导航栏区域
  static void enableEdgeToEdge() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }
}
