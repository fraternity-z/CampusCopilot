import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_color.freezed.dart';
part 'theme_color.g.dart';

/// 主题颜色枚举
enum ThemeColorType {
  yellow('黄色', Color(0xFFF59E0B), 'yellow'),
  blue('蓝色', Color(0xFF3B82F6), 'blue'),
  green('绿色', Color(0xFF10B981), 'green'),
  purple('紫色', Color(0xFF8B5CF6), 'purple'),
  orange('橙色', Color(0xFFF97316), 'orange'),
  cyan('青色', Color(0xFF06B6D4), 'cyan'),
  indigo('靛蓝', Color(0xFF6366F1), 'indigo');

  const ThemeColorType(this.displayName, this.primaryColor, this.colorKey);

  /// 显示名称
  final String displayName;
  
  /// 主色调
  final Color primaryColor;
  
  /// 颜色标识
  final String colorKey;

  /// 获取亮色主题的ColorScheme
  ColorScheme get lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );
  }

  /// 获取暗色主题的ColorScheme
  ColorScheme get darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );
  }

  /// 从字符串获取颜色类型
  static ThemeColorType fromString(String colorKey) {
    return ThemeColorType.values.firstWhere(
      (color) => color.colorKey == colorKey,
      orElse: () => ThemeColorType.purple, // 默认紫色
    );
  }
}

/// 主题颜色设置
@freezed
class ThemeColorSettings with _$ThemeColorSettings {
  const factory ThemeColorSettings({
    /// 当前选择的颜色主题
    @Default(ThemeColorType.purple) ThemeColorType currentColor,
    
    /// 是否启用动态颜色（Material You）
    @Default(false) bool enableDynamicColor,
    
    /// 最后更新时间
    DateTime? lastUpdated,
  }) = _ThemeColorSettings;

  factory ThemeColorSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeColorSettingsFromJson(json);
}
