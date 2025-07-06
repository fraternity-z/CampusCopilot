import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 现代化脚手架
class ModernScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final bool showAppBar;

  const ModernScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.appBar,
    this.showAppBar = true,
  });

  @override
  State<ModernScaffold> createState() => _ModernScaffoldState();
}

class _ModernScaffoldState extends State<ModernScaffold>
    with TickerProviderStateMixin {
  late AnimationController _appBarController;
  late Animation<double> _appBarAnimation;

  @override
  void initState() {
    super.initState();
    _appBarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _appBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeOut),
    );

    if (widget.showAppBar) {
      _appBarController.forward();
    }
  }

  @override
  void dispose() {
    _appBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,

      // 自定义AppBar
      appBar: widget.showAppBar ? _buildAppBar() : widget.appBar,

      // 主体内容
      body: widget.body,

      // 浮动操作按钮
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,

      // 抽屉
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,

      // 底部导航
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (widget.appBar != null) return widget.appBar;
    if (widget.title == null && (widget.actions?.isEmpty ?? true)) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedBuilder(
        animation: _appBarAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -50 * (1 - _appBarAnimation.value)),
            child: Opacity(
              opacity: _appBarAnimation.value,
              child: AppBar(
                title: widget.title != null
                    ? Text(
                        widget.title!,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      )
                    : null,
                actions: widget.actions,
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                centerTitle: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 带侧边栏的现代化布局
class ModernLayoutWithSidebar extends StatefulWidget {
  final Widget body;
  final Widget sidebar;
  final String? title;
  final List<Widget>? actions;
  final double sidebarWidth;
  final bool showSidebar;
  final VoidCallback? onToggleSidebar;

  const ModernLayoutWithSidebar({
    super.key,
    required this.body,
    required this.sidebar,
    this.title,
    this.actions,
    this.sidebarWidth = 280,
    this.showSidebar = true,
    this.onToggleSidebar,
  });

  @override
  State<ModernLayoutWithSidebar> createState() =>
      _ModernLayoutWithSidebarState();
}

class _ModernLayoutWithSidebarState extends State<ModernLayoutWithSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sidebarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.showSidebar) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ModernLayoutWithSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showSidebar != widget.showSidebar) {
      if (widget.showSidebar) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // 侧边栏
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return SizedBox(
                width: widget.sidebarWidth * _sidebarAnimation.value,
                child: _sidebarAnimation.value > 0
                    ? Opacity(
                        opacity: _sidebarAnimation.value,
                        child: widget.sidebar,
                      )
                    : null,
              );
            },
          ),

          // 主内容区域
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusL),
                ),
                boxShadow: widget.showSidebar ? AppTheme.cardShadow : null,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusL),
                ),
                child: widget.body,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: widget.title != null
          ? Text(
              widget.title!,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            )
          : null,
      actions: [
        if (widget.onToggleSidebar != null)
          IconButton(
            onPressed: widget.onToggleSidebar,
            icon: AnimatedRotation(
              turns: widget.showSidebar ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.menu),
            ),
            tooltip: widget.showSidebar ? '隐藏侧边栏' : '显示侧边栏',
          ),
        ...?widget.actions,
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      centerTitle: true,
    );
  }
}

/// 响应式布局
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileBreakpoint = 600,
    this.tabletBreakpoint = 1024,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakpoint && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= mobileBreakpoint && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// 带动画的页面包装器
class AnimatedPageWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AnimatedPageWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedPageWrapper> createState() => _AnimatedPageWrapperState();
}

class _AnimatedPageWrapperState extends State<AnimatedPageWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
        );
      },
    );
  }
}
