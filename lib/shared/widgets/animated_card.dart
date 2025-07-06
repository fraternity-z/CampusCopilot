import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 带动画效果的卡片组件
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final bool enableHoverEffect;
  final bool enableTapEffect;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation,
    this.color,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableHoverEffect = true,
    this.enableTapEffect = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableTapEffect) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableTapEffect) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enableTapEffect) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleHoverEnter(PointerEvent event) {
    if (widget.enableHoverEffect && !_isPressed) {
      setState(() => _isHovered = true);
      _controller.forward();
    }
  }

  void _handleHoverExit(PointerEvent event) {
    if (widget.enableHoverEffect && !_isPressed) {
      setState(() => _isHovered = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableTapEffect && _isPressed
              ? _scaleAnimation.value
              : 1.0,
          child: Container(
            margin: widget.margin,
            child: MouseRegion(
              onEnter: _handleHoverEnter,
              onExit: _handleHoverExit,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: widget.animationDuration,
                  decoration: BoxDecoration(
                    color: widget.color ?? Theme.of(context).cardColor,
                    borderRadius:
                        widget.borderRadius ??
                        BorderRadius.circular(AppTheme.radiusM),
                    boxShadow: _isHovered || _isPressed
                        ? AppTheme.elevatedShadow
                        : AppTheme.cardShadow,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  padding:
                      widget.padding ?? const EdgeInsets.all(AppTheme.spacingM),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 渐变背景卡片
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius:
                  borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
              boxShadow: AppTheme.cardShadow,
            ),
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 玻璃态卡片
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: opacity),
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 带阴影的容器
class ShadowContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const ShadowContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusM),
        boxShadow: boxShadow ?? AppTheme.cardShadow,
      ),
      child: child,
    );
  }
}
