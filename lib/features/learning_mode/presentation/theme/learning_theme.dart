import 'package:flutter/material.dart';

/// 学习模式主题配置
/// 
/// 提供学习模式下的专用颜色、样式和动画配置
class LearningTheme {
  LearningTheme._();

  /// 学习模式主色调
  static const Color primaryColor = Color(0xFF1976D2); // 蓝色，象征知识和学习
  static const Color secondaryColor = Color(0xFF388E3C); // 绿色，象征成长和进步
  static const Color accentColor = Color(0xFFFF9800); // 橙色，象征灵感和启发
  static const Color surfaceColor = Color(0xFFF3F7FF); // 淡蓝色背景
  
  /// 学习会话状态颜色
  static const Color sessionActiveColor = Color(0xFF4CAF50);
  static const Color sessionCompletedColor = Color(0xFF2196F3);
  static const Color sessionTerminatedColor = Color(0xFFFF9800);
  
  /// 学习模式渐变色
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFFFFA726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 为学习模式扩展主题
  static ThemeData extendTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
    );
  }
  
  /// 学习模式消息气泡样式
  static BoxDecoration getMessageBubbleDecoration(
    ThemeData theme, {
    bool isFromUser = false,
    bool isLearningMode = false,
  }) {
    if (!isLearningMode) {
      return BoxDecoration(
        color: isFromUser 
          ? theme.colorScheme.primary 
          : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      );
    }
    
    return BoxDecoration(
      gradient: isFromUser ? null : LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary.withValues(alpha: 0.05),
          theme.colorScheme.secondary.withValues(alpha: 0.02),
        ],
      ),
      color: isFromUser ? theme.colorScheme.primary : null,
      borderRadius: BorderRadius.circular(16),
      border: isFromUser ? null : Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
        width: 1,
      ),
      boxShadow: isLearningMode ? [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ] : null,
    );
  }
  
  /// 学习会话指示器样式
  static BoxDecoration getSessionIndicatorDecoration(ThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primary.withValues(alpha: 0.1),
          theme.colorScheme.secondary.withValues(alpha: 0.05),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.2),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  /// 学习模式切换按钮样式
  static ButtonStyle getLearningToggleButtonStyle(
    ThemeData theme, {
    required bool isLearningMode,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: isLearningMode 
        ? theme.colorScheme.primary 
        : theme.colorScheme.surfaceContainerHighest,
      foregroundColor: isLearningMode 
        ? theme.colorScheme.onPrimary 
        : theme.colorScheme.onSurfaceVariant,
      elevation: isLearningMode ? 4 : 1,
      shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
  
  /// 学习提示卡片样式
  static BoxDecoration getHintCardDecoration(
    ThemeData theme, {
    LearningHintType type = LearningHintType.info,
  }) {
    Color color;
    switch (type) {
      case LearningHintType.success:
        color = theme.colorScheme.primary;
        break;
      case LearningHintType.warning:
        color = accentColor;
        break;
      case LearningHintType.error:
        color = theme.colorScheme.error;
        break;
      case LearningHintType.info:
        color = theme.colorScheme.secondary;
        break;
    }
    
    return BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withValues(alpha: 0.3),
      ),
    );
  }
  
  /// 学习模式动画持续时间
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration sessionTransitionDuration = Duration(milliseconds: 500);
  
  /// 学习模式图标
  static const IconData learningModeIcon = Icons.school;
  static const IconData sessionActiveIcon = Icons.psychology;
  static const IconData guidanceIcon = Icons.lightbulb_outline;
  static const IconData progressIcon = Icons.trending_up;
  static const IconData completedIcon = Icons.check_circle;
  static const IconData terminatedIcon = Icons.skip_next;
  
  /// 获取会话状态颜色
  static Color getSessionStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'active':
        return sessionActiveColor;
      case 'completed':
        return sessionCompletedColor;
      case 'terminated':
        return sessionTerminatedColor;
      case 'paused':
        return theme.colorScheme.outline;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
  
  /// 获取学习风格颜色
  static Color getLearningStyleColor(String style, ThemeData theme) {
    switch (style.toLowerCase()) {
      case 'guided':
        return primaryColor;
      case 'exploratory':
        return secondaryColor;
      case 'structured':
        return accentColor;
      default:
        return theme.colorScheme.primary;
    }
  }
}

/// 学习提示类型枚举
enum LearningHintType {
  info,
  success,
  warning,
  error,
}

/// 学习模式主题扩展
extension LearningThemeExtension on ThemeData {
  /// 获取学习模式专用颜色
  ColorScheme get learningColorScheme => colorScheme.copyWith(
    primary: LearningTheme.primaryColor,
    secondary: LearningTheme.secondaryColor,
    tertiary: LearningTheme.accentColor,
  );
  
  /// 是否为学习模式主题
  bool get isLearningTheme => colorScheme.primary == LearningTheme.primaryColor;
}

/// 学习模式颜色常量
class LearningColors {
  LearningColors._();
  
  // 主要颜色
  static const primary = Color(0xFF1976D2);
  static const primaryLight = Color(0xFF42A5F5);
  static const primaryDark = Color(0xFF1565C0);
  
  // 次要颜色
  static const secondary = Color(0xFF388E3C);
  static const secondaryLight = Color(0xFF66BB6A);
  static const secondaryDark = Color(0xFF2E7D32);
  
  // 强调色
  static const accent = Color(0xFFFF9800);
  static const accentLight = Color(0xFFFFB74D);
  static const accentDark = Color(0xFFF57C00);
  
  // 背景颜色
  static const backgroundLight = Color(0xFFF8FBFF);
  static const backgroundDark = Color(0xFF121212);
  
  // 表面颜色
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1E1E);
  
  // 错误颜色
  static const error = Color(0xFFD32F2F);
  static const errorLight = Color(0xFFEF5350);
  static const errorDark = Color(0xFFC62828);
  
  // 成功颜色
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  static const successDark = Color(0xFF388E3C);
  
  // 警告颜色
  static const warning = Color(0xFFF57C00);
  static const warningLight = Color(0xFFFFB74D);
  static const warningDark = Color(0xFFE65100);
  
  // 信息颜色
  static const info = Color(0xFF1976D2);
  static const infoLight = Color(0xFF42A5F5);
  static const infoDark = Color(0xFF1565C0);
}