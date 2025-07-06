import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 现代化按钮组件
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ModernButtonStyle style;
  final Size? size;
  final EdgeInsetsGeometry? padding;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.style = ModernButtonStyle.primary,
    this.size,
    this.padding,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size?.width,
              height: widget.size?.height ?? 48,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
              decoration: _getButtonDecoration(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                  ] else if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: _getTextColor(context)),
                    const SizedBox(width: AppTheme.spacingS),
                  ],
                  Text(
                    widget.text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: _getTextColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _getButtonDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (widget.style) {
      case ModernButtonStyle.primary:
        return BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: _isPressed ? [] : AppTheme.cardShadow,
        );

      case ModernButtonStyle.secondary:
        return BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: _isPressed ? [] : AppTheme.cardShadow,
        );

      case ModernButtonStyle.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(color: colorScheme.primary, width: 2),
        );

      case ModernButtonStyle.ghost:
        return BoxDecoration(
          color: _isPressed
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        );

      case ModernButtonStyle.danger:
        return BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: _isPressed ? [] : AppTheme.cardShadow,
        );
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (widget.style) {
      case ModernButtonStyle.primary:
        return Colors.white;

      case ModernButtonStyle.secondary:
        return colorScheme.onSecondaryContainer;

      case ModernButtonStyle.outline:
      case ModernButtonStyle.ghost:
        return colorScheme.primary;

      case ModernButtonStyle.danger:
        return colorScheme.onError;
    }
  }
}

/// 按钮样式枚举
enum ModernButtonStyle { primary, secondary, outline, ghost, danger }

/// 浮动操作按钮
class ModernFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool mini;
  final Color? backgroundColor;

  const ModernFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.mini = false,
    this.backgroundColor,
  });

  @override
  State<ModernFAB> createState() => _ModernFABState();
}

class _ModernFABState extends State<ModernFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                widget.onPressed?.call();
              },
              tooltip: widget.tooltip,
              mini: widget.mini,
              backgroundColor: widget.backgroundColor,
              child: Icon(widget.icon),
            ),
          ),
        );
      },
    );
  }
}

/// 图标按钮
class ModernIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? size;
  final Color? color;
  final Color? backgroundColor;

  const ModernIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size,
    this.color,
    this.backgroundColor,
  });

  @override
  State<ModernIconButton> createState() => _ModernIconButtonState();
}

class _ModernIconButtonState extends State<ModernIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: widget.backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
            child: InkWell(
              onTap: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                widget.onPressed?.call();
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                child: Icon(
                  widget.icon,
                  size: widget.size ?? 24,
                  color:
                      widget.color ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
