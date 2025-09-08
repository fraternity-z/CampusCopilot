import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_router.dart';
import '../shared/theme/dynamic_theme_manager.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import '../features/settings/presentation/providers/theme_color_provider.dart';
import '../features/settings/domain/entities/app_settings.dart' as app_settings;
import '../core/network/proxy_service.dart';
import 'widgets/splash_screen.dart';
import 'providers/splash_provider.dart';

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
    final colorSettings = ref.watch(themeColorProvider);
    final shouldShowSplash = ref.watch(shouldShowSplashProvider);

    return MaterialApp.router(
      title: 'Campus Copilot',
      debugShowCheckedModeBanner: false,

      // 主题配置 - 使用动态颜色主题
      theme: DynamicThemeManager.getLightTheme(colorSettings.currentColor),
      darkTheme: DynamicThemeManager.getDarkTheme(colorSettings.currentColor),
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

      // 构建器用于全局错误处理、加载状态和启动屏
      builder: (context, child) {
        return _AppWrapper(
          child: shouldShowSplash 
              ? _SplashWrapper(child: child)
              : child,
        );
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
    // 初始化代理配置监听
    ref.watch(proxyConfigWatcherProvider);

    return child ?? const SizedBox.shrink();
  }
}

/// 启动屏包装器
class _SplashWrapper extends ConsumerStatefulWidget {
  final Widget? child;

  const _SplashWrapper({this.child});

  @override
  ConsumerState<_SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends ConsumerState<_SplashWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeInController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showMainApp = false;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    );

    final curve = CurvedAnimation(
      parent: _fadeInController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = curve;
    _scaleAnimation = Tween<double>(begin: 0.985, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeInController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashSettings = ref.watch(splashSettingsProvider);
    final shouldShowSplash = ref.watch(shouldShowSplashProvider);
    
    // 监听启动屏状态变化，如果重置则重置本地状态
    ref.listen<SplashState>(splashProvider, (previous, next) {
      if (next == SplashState.showing && previous == SplashState.completed) {
        // 启动屏被重置，重置本地状态
        setState(() {
          _showMainApp = false;
        });
        _fadeInController.reset();
      }
    });
    
    return Stack(
      children: [
        // 主应用（淡入效果）
        if (_showMainApp)
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              filterQuality: FilterQuality.high,
              child: widget.child ?? const SizedBox.shrink(),
            ),
          ),
        
        // 启动屏
        if (shouldShowSplash)
          SplashScreen(
            animationDuration: Duration(milliseconds: splashSettings.durationMs),
            onAnimationComplete: () {
              // 启动屏动画完成后，显示主应用并开始淡入
              setState(() {
                _showMainApp = true;
              });
              
              _fadeInController.forward().then((_) {
                // 淡入完成后更新状态
                ref.read(splashProvider.notifier).completeAnimation();
              });
            },
          ),
      ],
    );
  }
}
