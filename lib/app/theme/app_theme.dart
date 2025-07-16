import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // 基础颜色
  static const Color _primaryColor = Color(0xFF4A90E2);
  static const Color _secondaryColor = Color(0xFF50E3C2);
  static const Color _errorColor = Color(0xFFD0021B);

  /// 构建主题数据
  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseTheme = isLight
        ? ThemeData.light(useMaterial3: true)
        : ThemeData.dark(useMaterial3: true);

    final textTheme = GoogleFonts.notoSansScTextTheme(baseTheme.textTheme);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      brightness: brightness,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      iconButtonTheme: _buildIconButtonTheme(colorScheme),
      listTileTheme: _buildListTileTheme(),
      dividerTheme: _buildDividerTheme(colorScheme),
    );
  }

  /// 构建 AppBar 主题
  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
    );
  }

  /// 构建卡片主题
  static CardThemeData _buildCardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surfaceContainer,
    );
  }

  /// 构建输入框主题
  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  /// 构建按钮主题
  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 2,
      ),
    );
  }

  /// 构建图标按钮主题
  static IconButtonThemeData _buildIconButtonTheme(ColorScheme colorScheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// 构建列表项主题
  static ListTileThemeData _buildListTileTheme() {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// 构建分割线主题
  static DividerThemeData _buildDividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant.withAlpha(128),
      thickness: 1,
      space: 1,
    );
  }

  /// 浅色主题
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  /// 深色主题
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
}

/// 自定义颜色扩展
extension AppColors on ColorScheme {
  /// 成功色
  Color get success => brightness == Brightness.light
      ? const Color(0xFF28A745)
      : const Color(0xFF218838);

  /// 警告色
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFFFC107)
      : const Color(0xFFD39E00);

  /// 信息色
  Color get info => brightness == Brightness.light
      ? const Color(0xFF17A2B8)
      : const Color(0xFF117A8B);
}

/// 文本样式扩展
extension AppTextStyles on TextTheme {
  /// 聊天消息样式
  TextStyle? get chatMessage =>
      bodyLarge?.copyWith(height: 1.5, letterSpacing: 0.2);

  /// 代码样式
  TextStyle? get code => bodyMedium?.copyWith(
    fontFamily: 'monospace',
    backgroundColor: Colors.black.withAlpha(13),
    letterSpacing: 0.1,
  );

  /// 标签样式
  TextStyle? get label =>
      labelMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.3);
}
