import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../theme/app_theme.dart';

/// 现代化聊天气泡
class ModernChatBubble extends StatefulWidget {
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final bool isTyping;
  final bool showAvatar;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ModernChatBubble({
    super.key,
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    this.isTyping = false,
    this.showAvatar = true,
    this.avatarUrl,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<ModernChatBubble> createState() => _ModernChatBubbleState();
}

class _ModernChatBubbleState extends State<ModernChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: widget.isFromUser ? const Offset(1, 0) : const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
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
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildBubbleContent(context),
          ),
        );
      },
    );
  }

  Widget _buildBubbleContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isFromUser && widget.showAvatar) ...[
            _buildAvatar(context),
            const SizedBox(width: AppTheme.spacingS),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: widget.isFromUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingM,
                    ),
                    decoration: BoxDecoration(
                      gradient: widget.isFromUser
                          ? AppTheme.chatBubbleGradient
                          : null,
                      color: widget.isFromUser
                          ? null
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppTheme.radiusL),
                        topRight: const Radius.circular(AppTheme.radiusL),
                        bottomLeft: widget.isFromUser
                            ? const Radius.circular(AppTheme.radiusL)
                            : const Radius.circular(AppTheme.radiusXS),
                        bottomRight: widget.isFromUser
                            ? const Radius.circular(AppTheme.radiusXS)
                            : const Radius.circular(AppTheme.radiusL),
                      ),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: widget.isTyping
                        ? _buildTypingIndicator()
                        : _buildMessageContent(context),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingXS),
                
                // 时间戳
                Text(
                  _formatTime(widget.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          
          if (widget.isFromUser && widget.showAvatar) ...[
            const SizedBox(width: AppTheme.spacingS),
            _buildAvatar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: widget.isFromUser
            ? AppTheme.primaryGradient
            : LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: widget.avatarUrl != null
          ? ClipOval(
              child: Image.network(
                widget.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      widget.isFromUser ? Icons.person : Icons.smart_toy,
      color: Colors.white,
      size: 20,
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    return SelectableText(
      widget.message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: widget.isFromUser
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return SizedBox(
      height: 20,
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            '正在思考...',
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            speed: const Duration(milliseconds: 100),
          ),
        ],
        repeatForever: true,
        pause: const Duration(milliseconds: 500),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else {
      return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// 系统消息气泡
class SystemMessageBubble extends StatelessWidget {
  final String message;
  final IconData? icon;

  const SystemMessageBubble({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppTheme.spacingS),
              ],
              Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

/// 聊天输入框
class ModernChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;
  final VoidCallback? onVoicePressed;
  final bool isLoading;
  final String hintText;

  const ModernChatInput({
    super.key,
    required this.controller,
    this.onSend,
    this.onVoicePressed,
    this.isLoading = false,
    this.hintText = '输入消息...',
  });

  @override
  State<ModernChatInput> createState() => _ModernChatInputState();
}

class _ModernChatInputState extends State<ModernChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _hasText ? widget.onSend?.call() : null,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingM,
                    ),
                    suffixIcon: widget.onVoicePressed != null
                        ? IconButton(
                            onPressed: widget.onVoicePressed,
                            icon: const Icon(Icons.mic),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingS),
            
            // 发送按钮
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              child: Material(
                color: _hasText && !widget.isLoading
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                child: InkWell(
                  onTap: _hasText && !widget.isLoading ? widget.onSend : null,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  child: widget.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: _hasText
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          size: 20,
                        ),
                ),
              ),
            )
                .animate(target: _hasText ? 1 : 0)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 200.ms,
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
