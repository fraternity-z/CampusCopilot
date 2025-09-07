import 'package:flutter/material.dart';

/// 应用颜色主题枚举
/// 
/// 提供六种预设颜色主题：红、黄、蓝、绿、紫、橙
enum AppColorTheme {
  /// 红色主题
  red,
  
  /// 黄色主题
  yellow,
  
  /// 蓝色主题
  blue,
  
  /// 绿色主题
  green,
  
  /// 紫色主题（默认）
  purple,
  
  /// 橙色主题
  orange,
}

/// 颜色主题配置类
/// 
/// 定义各种颜色主题的具体颜色值和渐变配置
class ColorThemeConfig {
  ColorThemeConfig._();

  /// 获取颜色主题的显示名称
  static String getDisplayName(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.red:
        return '红色';
      case AppColorTheme.yellow:
        return '黄色';
      case AppColorTheme.blue:
        return '蓝色';
      case AppColorTheme.green:
        return '绿色';
      case AppColorTheme.purple:
        return '紫色';
      case AppColorTheme.orange:
        return '橙色';
    }
  }

  /// 获取颜色主题的主色调
  static Color getPrimaryColor(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.red:
        return const Color(0xFFE53E3E); // 红色
      case AppColorTheme.yellow:
        return const Color(0xFFD69E2E); // 黄色
      case AppColorTheme.blue:
        return const Color(0xFF3182CE); // 蓝色
      case AppColorTheme.green:
        return const Color(0xFF38A169); // 绿色
      case AppColorTheme.purple:
        return const Color(0xFF6750A4); // 紫色（原默认色）
      case AppColorTheme.orange:
        return const Color(0xFFDD6B20); // 橙色
    }
  }

  /// 获取颜色主题的次要色调
  static Color getSecondaryColor(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.red:
        return const Color(0xFFC53030);
      case AppColorTheme.yellow:
        return const Color(0xFFB7791F);
      case AppColorTheme.blue:
        return const Color(0xFF2B6CB0);
      case AppColorTheme.green:
        return const Color(0xFF2F855A);
      case AppColorTheme.purple:
        return const Color(0xFF625B71); // 原默认色
      case AppColorTheme.orange:
        return const Color(0xFFC05621);
    }
  }

  /// 获取主要渐变色
  static LinearGradient getPrimaryGradient(AppColorTheme theme) {
    final primary = getPrimaryColor(theme);
    final secondary = _getGradientSecondary(theme);
    
    return LinearGradient(
      colors: [primary, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// 获取聊天气泡渐变色
  static LinearGradient getChatBubbleGradient(AppColorTheme theme) {
    final primary = getPrimaryColor(theme);
    final accent = _getChatBubbleAccent(theme);
    
    return LinearGradient(
      colors: [primary, accent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// 获取颜色主题的亮色ColorScheme
  static ColorScheme getLightColorScheme(AppColorTheme theme) {
    final primary = getPrimaryColor(theme);
    final secondary = getSecondaryColor(theme);
    
    return ColorScheme.light(
      primary: primary,
      primaryContainer: primary.withValues(alpha: 0.1),
      secondary: secondary,
      secondaryContainer: secondary.withValues(alpha: 0.1),
      surface: const Color(0xFFFFFBFE),
      surfaceContainerHighest: const Color(0xFFE6E0E9),
      error: const Color(0xFFBA1A1A),
      onPrimary: Colors.white,
      onPrimaryContainer: primary.withValues(alpha: 0.8),
      onSecondary: Colors.white,
      onSecondaryContainer: secondary.withValues(alpha: 0.8),
      onSurface: const Color(0xFF1C1B1F),
      onSurfaceVariant: const Color(0xFF49454F),
      onError: Colors.white,
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
    );
  }

  /// 获取颜色主题的暗色ColorScheme
  static ColorScheme getDarkColorScheme(AppColorTheme theme) {
    final primary = getPrimaryColor(theme);
    final secondary = getSecondaryColor(theme);
    
    return ColorScheme.dark(
      primary: primary.withValues(alpha: 0.8),
      primaryContainer: primary.withValues(alpha: 0.3),
      secondary: secondary.withValues(alpha: 0.8),
      secondaryContainer: secondary.withValues(alpha: 0.3),
      surface: const Color(0xFF1C1B1F),
      surfaceContainerHighest: const Color(0xFF36343B),
      error: const Color(0xFFFFB4AB),
      onPrimary: const Color(0xFF371E73),
      onPrimaryContainer: primary.withValues(alpha: 0.9),
      onSecondary: const Color(0xFF332D41),
      onSecondaryContainer: secondary.withValues(alpha: 0.9),
      onSurface: const Color(0xFFE6E0E9),
      onSurfaceVariant: const Color(0xFFCAC4D0),
      onError: const Color(0xFF690005),
      outline: const Color(0xFF938F99),
      outlineVariant: const Color(0xFF49454F),
    );
  }

  /// 获取颜色主题的主题预览色块
  static Color getPreviewColor(AppColorTheme theme) {
    return getPrimaryColor(theme);
  }

  /// 获取所有可用的颜色主题
  static List<AppColorTheme> getAllThemes() {
    return AppColorTheme.values;
  }

  /// 私有方法：获取渐变次要色
  static Color _getGradientSecondary(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.red:
        return const Color(0xFFFC8181);
      case AppColorTheme.yellow:
        return const Color(0xFFF6E05E);
      case AppColorTheme.blue:
        return const Color(0xFF63B3ED);
      case AppColorTheme.green:
        return const Color(0xFF68D391);
      case AppColorTheme.purple:
        return const Color(0xFF7C4DFF);
      case AppColorTheme.orange:
        return const Color(0xFFF6AD55);
    }
  }

  /// 私有方法：获取聊天气泡强调色
  static Color _getChatBubbleAccent(AppColorTheme theme) {
    switch (theme) {
      case AppColorTheme.red:
        return const Color(0xFFF56565);
      case AppColorTheme.yellow:
        return const Color(0xFFECC94B);
      case AppColorTheme.blue:
        return const Color(0xFF4299E1);
      case AppColorTheme.green:
        return const Color(0xFF48BB78);
      case AppColorTheme.purple:
        return const Color(0xFF8B5CF6);
      case AppColorTheme.orange:
        return const Color(0xFFED8936);
    }
  }
}
