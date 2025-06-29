import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_router.dart';
import 'theme/app_theme.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import '../features/settings/domain/entities/app_settings.dart' as app_settings;

/// 应用程序根Widget
///
/// 这是整个应用的入口点，配置了：
/// - Riverpod状态管理
/// - GoRouter导航
/// - 应用主题
/// - 全局错误处理
class AIAssistantApp extends ConsumerWidget {
  const AIAssistantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'AI Assistant',
      debugShowCheckedModeBanner: false,

      // 主题配置
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _convertThemeMode(settings.themeMode),

      // 路由配置
      routerConfig: router,

      // 本地化配置
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],

      // 构建器用于全局错误处理和加载状态
      builder: (context, child) {
        return _AppWrapper(child: child);
      },
    );
  }

  /// 转换应用设置的主题模式为Flutter的主题模式
  ThemeMode _convertThemeMode(app_settings.ThemeMode themeMode) {
    switch (themeMode) {
      case app_settings.ThemeMode.light:
        return ThemeMode.light;
      case app_settings.ThemeMode.dark:
        return ThemeMode.dark;
      case app_settings.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}

/// 应用包装器，用于全局状态管理和错误处理
class _AppWrapper extends ConsumerWidget {
  final Widget? child;

  const _AppWrapper({this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      // 可以在这里添加全局的Snackbar、Loading等
    );
  }
}
