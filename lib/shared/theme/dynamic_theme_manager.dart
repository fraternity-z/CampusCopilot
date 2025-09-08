import 'package:flutter/material.dart';

import '../../features/settings/domain/entities/theme_color.dart';
import 'app_theme.dart';

/// 动态主题管理器
/// 负责根据颜色设置生成动态主题
class DynamicThemeManager {
  /// 私有构造函数
  DynamicThemeManager._();

  /// 获取动态亮色主题
  static ThemeData getLightTheme(ThemeColorType colorType) {
    final baseTheme = AppTheme.lightTheme;
    final colorScheme = colorType.lightColorScheme;
    
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      
      // 更新悬停和高亮颜色
      hoverColor: colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: colorScheme.primary.withValues(alpha: 0.10),
      splashColor: colorScheme.primary.withValues(alpha: 0.12),
    );
  }

  /// 获取动态暗色主题
  static ThemeData getDarkTheme(ThemeColorType colorType) {
    final baseTheme = AppTheme.darkTheme;
    final colorScheme = colorType.darkColorScheme;
    
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      
      // 更新悬停和高亮颜色
      hoverColor: colorScheme.primary.withValues(alpha: 0.12),
      highlightColor: colorScheme.primary.withValues(alpha: 0.16),
      splashColor: colorScheme.primary.withValues(alpha: 0.20),
    );
  }

  /// 生成聊天气泡渐变色
  static LinearGradient getChatBubbleGradient(ThemeColorType colorType, {bool isUser = true}) {
    if (isUser) {
      // 用户消息气泡：使用主色调的渐变
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colorType.primaryColor.withValues(alpha: 0.15),
          colorType.primaryColor.withValues(alpha: 0.2),
          colorType.primaryColor.withValues(alpha: 0.18),
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else {
      // AI消息气泡：使用中性色渐变
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
          Color(0xFFF1F5F9),
        ],
        stops: [0.0, 0.5, 1.0],
      );
    }
  }

  /// 获取聊天气泡边框颜色
  static Color getChatBubbleBorderColor(ThemeColorType colorType, {bool isUser = true}) {
    if (isUser) {
      return colorType.primaryColor.withValues(alpha: 0.2);
    } else {
      return Colors.white.withValues(alpha: 0.3);
    }
  }
}