import 'package:flutter/material.dart';

/// 统一的对话框样式工具，确保深/浅色模式下与背景有明确区分，且低耦合复用
class DialogStyles {
  const DialogStyles._();

  /// 主容器背景色：
  /// - 深色模式：使用 surfaceContainerHigh，以便区别于 background
  /// - 浅色模式：使用 surface
  static Color containerColor(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return isDark ? cs.surfaceContainerHigh : cs.surface;
  }

  /// 头/底栏色：
  /// - 深色模式：使用层次更高的 surfaceContainerHighest
  /// - 浅色模式：使用 surfaceContainer
  static Color headerFooterColor(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return isDark ? cs.surfaceContainerHighest : cs.surfaceContainer;
  }

  /// 统一的边框色
  static Color borderColor(BuildContext context) {
    return Theme.of(context).colorScheme.outlineVariant;
  }

  /// 统一的阴影（在暗色下略强，确保浮起感）
  static List<BoxShadow> boxShadows(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.12),
        blurRadius: isDark ? 28 : 20,
        offset: const Offset(0, 10),
      ),
    ];
  }

  /// 统一的外层装饰
  static BoxDecoration dialogDecoration(BuildContext context) {
    return BoxDecoration(
      color: containerColor(context),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: borderColor(context), width: 1),
      boxShadow: boxShadows(context),
    );
  }
}
