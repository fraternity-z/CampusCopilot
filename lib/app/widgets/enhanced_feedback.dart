import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

/// 增强版 SnackBar 工具类
class EnhancedFeedback {
  /// 显示成功消息
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Icons.check_circle_outline_rounded,
      context.colorScheme.primary,
    );
  }

  /// 显示错误消息
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Icons.error_outline_rounded,
      context.colorScheme.error,
    );
  }

  /// 显示警告消息
  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Icons.warning_amber_rounded,
      Colors.orange,
    );
  }

  /// 显示信息消息
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Icons.info_outline_rounded,
      context.colorScheme.primary,
    );
  }

  /// 显示加载消息
  static void showLoading(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Icons.hourglass_empty_rounded,
      context.colorScheme.primary,
      showProgress: true,
    );
  }

  /// 内部方法：显示美化的 SnackBar
  static void _showSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color, {
    bool showProgress = false,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _EnhancedSnackBarContent(
          message: message,
          icon: icon,
          color: color,
          showProgress: showProgress,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(UIConstants.spacingM),
        padding: EdgeInsets.zero,
        duration: showProgress ? const Duration(seconds: 10) : const Duration(seconds: 4),
      ),
    );
  }

  /// 显示确认对话框
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = '确认',
    String cancelText = '取消',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _EnhancedAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
  }

  /// 显示输入对话框
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = '确认',
    String cancelText = '取消',
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _EnhancedInputDialog(
        title: title,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }
}

/// 增强版 SnackBar 内容组件
class _EnhancedSnackBarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final bool showProgress;

  const _EnhancedSnackBarContent({
    required this.message,
    required this.icon,
    required this.color,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(UIConstants.borderRadius * 1.5),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: showProgress
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                : Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
          ),
          const SizedBox(width: UIConstants.spacingM),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 增强版确认对话框
class _EnhancedAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const _EnhancedAlertDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius * 2),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 16,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary).withValues(alpha: 0.15),
                  (isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDestructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
              color: isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: UIConstants.spacingM),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: UIConstants.spacingS),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                (isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: (isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 增强版输入对话框
class _EnhancedInputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;

  const _EnhancedInputDialog({
    required this.title,
    this.hint,
    this.initialValue,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  State<_EnhancedInputDialog> createState() => _EnhancedInputDialogState();
}

class _EnhancedInputDialogState extends State<_EnhancedInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.borderRadius * 2),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 16,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: UIConstants.spacingM),
          Expanded(
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(
              Icons.text_fields_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(UIConstants.spacingM),
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              widget.cancelText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: UIConstants.spacingS),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton(
            onPressed: () {
              final text = _controller.text.trim();
              Navigator.of(context).pop(text.isEmpty ? null : text);
            },
            child: Text(
              widget.confirmText,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 扩展 BuildContext 以便于访问主题色彩
extension BuildContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
