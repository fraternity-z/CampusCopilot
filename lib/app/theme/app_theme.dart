import 'package:flutter/material.dart';

/// 应用主题配置
///
/// 定义了应用的视觉风格，包括：
/// - 颜色方案
/// - 字体样式
/// - 组件主题
/// - 明暗主题切换
class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();

  // 主色调
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 颜色方案
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 列表瓦片主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // 分割线主题
      dividerTheme: const DividerThemeData(thickness: 1, space: 1),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // 颜色方案
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 列表瓦片主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // 分割线主题
      dividerTheme: const DividerThemeData(thickness: 1, space: 1),
    );
  }
}

/// 自定义颜色扩展
extension AppColors on ColorScheme {
  /// 成功色
  Color get success => brightness == Brightness.light
      ? const Color(0xFF4CAF50)
      : const Color(0xFF81C784);

  /// 警告色
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFFF9800)
      : const Color(0xFFFFB74D);

  /// 信息色
  Color get info => brightness == Brightness.light
      ? const Color(0xFF2196F3)
      : const Color(0xFF64B5F6);
}

/// 文本样式扩展
extension AppTextStyles on TextTheme {
  /// 聊天消息样式
  TextStyle get chatMessage => bodyLarge!.copyWith(height: 1.4);

  /// 代码样式
  TextStyle get code => bodyMedium!.copyWith(
    fontFamily: 'monospace',
    backgroundColor: Colors.grey.withValues(alpha: 0.1),
  );

  /// 标签样式
  TextStyle get label => labelMedium!.copyWith(fontWeight: FontWeight.w500);
}
