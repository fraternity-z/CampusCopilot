import 'package:flutter/material.dart';

/// 优雅的通知类型
enum ElegantNotificationType {
  success,
  error,
  warning,
  info,
}

/// 优雅的通知组件
/// 
/// 替代 SnackBar，提供更好的用户体验：
/// - 不会遮挡底部按钮
/// - 自动消失
/// - 支持多种类型
/// - 位置可配置
class ElegantNotification {
  static OverlayEntry? _currentOverlay;

  /// 显示通知
  static void show(
    BuildContext context, {
    required String message,
    ElegantNotificationType type = ElegantNotificationType.info,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool showAtTop = true, // 默认显示在顶部
  }) {
    // 移除之前的通知
    hide();

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ElegantNotificationWidget(
        message: message,
        type: type,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        showAtTop: showAtTop,
        onDismiss: hide,
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
  }

  /// 显示成功通知
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool showAtTop = true,
  }) {
    show(
      context,
      message: message,
      type: ElegantNotificationType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      showAtTop: showAtTop,
    );
  }

  /// 显示错误通知
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showAtTop = true,
  }) {
    show(
      context,
      message: message,
      type: ElegantNotificationType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      showAtTop: showAtTop,
    );
  }

  /// 显示警告通知
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool showAtTop = true,
  }) {
    show(
      context,
      message: message,
      type: ElegantNotificationType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      showAtTop: showAtTop,
    );
  }

  /// 显示信息通知
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool showAtTop = true,
  }) {
    show(
      context,
      message: message,
      type: ElegantNotificationType.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      showAtTop: showAtTop,
    );
  }

  /// 隐藏当前通知
  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

/// 通知组件实现
class _ElegantNotificationWidget extends StatefulWidget {
  final String message;
  final ElegantNotificationType type;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showAtTop;
  final VoidCallback onDismiss;

  const _ElegantNotificationWidget({
    required this.message,
    required this.type,
    required this.duration,
    this.actionLabel,
    this.onAction,
    required this.showAtTop,
    required this.onDismiss,
  });

  @override
  State<_ElegantNotificationWidget> createState() => _ElegantNotificationWidgetState();
}

class _ElegantNotificationWidgetState extends State<_ElegantNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.showAtTop ? const Offset(0, -1) : const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // 开始动画
    _animationController.forward();

    // 自动消失
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.showAtTop ? MediaQuery.of(context).padding.top + 16 : null,
      bottom: widget.showAtTop ? null : MediaQuery.of(context).padding.bottom + 100, // 避开底部按钮
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getBorderColor(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIcon(),
                    color: _getIconColor(context),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _getTextColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null && widget.onAction != null) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        widget.onAction!();
                        _dismiss();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _getActionColor(context),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: _getTextColor(context).withValues(alpha: 0.7),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ElegantNotificationType.success:
        return Icons.check_circle_outline;
      case ElegantNotificationType.error:
        return Icons.error_outline;
      case ElegantNotificationType.warning:
        return Icons.warning_amber_outlined;
      case ElegantNotificationType.info:
        return Icons.info_outline;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ElegantNotificationType.success:
        return colorScheme.surface;
      case ElegantNotificationType.error:
        return colorScheme.surface;
      case ElegantNotificationType.warning:
        return colorScheme.surface;
      case ElegantNotificationType.info:
        return colorScheme.surface;
    }
  }

  Color _getBorderColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ElegantNotificationType.success:
        return Colors.green.withValues(alpha: 0.3);
      case ElegantNotificationType.error:
        return colorScheme.error.withValues(alpha: 0.3);
      case ElegantNotificationType.warning:
        return Colors.orange.withValues(alpha: 0.3);
      case ElegantNotificationType.info:
        return colorScheme.primary.withValues(alpha: 0.3);
    }
  }

  Color _getIconColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ElegantNotificationType.success:
        return Colors.green;
      case ElegantNotificationType.error:
        return colorScheme.error;
      case ElegantNotificationType.warning:
        return Colors.orange;
      case ElegantNotificationType.info:
        return colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  Color _getActionColor(BuildContext context) {
    return _getIconColor(context);
  }
}
