import 'package:flutter/material.dart';

/// 页面过渡动画类型
enum PageTransitionType {
  fade,
  slide,
  scale,
  rotation,
  slideFromBottom,
  slideFromTop,
  slideFromLeft,
  slideFromRight,
}

/// 自定义页面路由
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.transitionType = PageTransitionType.slide,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
       );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (transitionType) {
      case PageTransitionType.fade:
        return FadeTransition(opacity: curvedAnimation, child: child);

      case PageTransitionType.scale:
        return ScaleTransition(scale: curvedAnimation, child: child);

      case PageTransitionType.rotation:
        return RotationTransition(turns: curvedAnimation, child: child);

      case PageTransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
    }
  }
}

/// 共享元素过渡
class SharedAxisTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final SharedAxisTransitionType transitionType;

  const SharedAxisTransition({
    super.key,
    required this.child,
    required this.animation,
    required this.transitionType,
  });

  @override
  Widget build(BuildContext context) {
    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: FadeTransition(opacity: animation, child: child),
        );

      case SharedAxisTransitionType.vertical:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: FadeTransition(opacity: animation, child: child),
        );

      case SharedAxisTransitionType.scaled:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
    }
  }
}

enum SharedAxisTransitionType { horizontal, vertical, scaled }

/// 容器变换过渡
class ContainerTransformTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const ContainerTransformTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: Opacity(opacity: animation.value, child: this.child),
        );
      },
    );
  }
}

/// 淡入淡出过渡
class FadeThroughTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const FadeThroughTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// 页面过渡构建器
class PageTransitionBuilder {
  static Route<T> build<T>({
    required Widget page,
    PageTransitionType type = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    RouteSettings? settings,
  }) {
    return CustomPageRoute<T>(
      child: page,
      transitionType: type,
      duration: duration,
      curve: curve,
      settings: settings,
    );
  }

  static Route<T> slideUp<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.slideFromBottom,
      settings: settings,
    );
  }

  static Route<T> slideDown<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.slideFromTop,
      settings: settings,
    );
  }

  static Route<T> slideLeft<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.slideFromRight,
      settings: settings,
    );
  }

  static Route<T> slideRight<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.slideFromLeft,
      settings: settings,
    );
  }

  static Route<T> fade<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.fade,
      settings: settings,
    );
  }

  static Route<T> scale<T>(Widget page, {RouteSettings? settings}) {
    return build<T>(
      page: page,
      type: PageTransitionType.scale,
      curve: Curves.elasticOut,
      settings: settings,
    );
  }
}

/// 路由动画扩展
extension NavigatorExtensions on NavigatorState {
  Future<T?> pushWithTransition<T>(
    Widget page, {
    PageTransitionType type = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return push<T>(
      PageTransitionBuilder.build<T>(
        page: page,
        type: type,
        duration: duration,
        curve: curve,
      ),
    );
  }

  Future<T?> pushReplacementWithTransition<T, TO>(
    Widget page, {
    PageTransitionType type = PageTransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TO? result,
  }) {
    return pushReplacement<T, TO>(
      PageTransitionBuilder.build<T>(
        page: page,
        type: type,
        duration: duration,
        curve: curve,
      ),
      result: result,
    );
  }
}

/// 微交互动画
class MicroInteraction extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleValue;

  const MicroInteraction({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 100),
    this.scaleValue = 0.95,
  });

  @override
  State<MicroInteraction> createState() => _MicroInteractionState();
}

class _MicroInteractionState extends State<MicroInteraction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// 弹性动画
class ElasticAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const ElasticAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ElasticAnimation> createState() => _ElasticAnimationState();
}

class _ElasticAnimationState extends State<ElasticAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _opacityAnimation.value, child: widget.child),
        );
      },
    );
  }
}
