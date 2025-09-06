import 'package:flutter/material.dart';
import '../../../domain/entities/chat_message.dart';
import 'message_content_widget.dart';
import 'streaming_message_content_widget.dart';

/// 平滑的消息切换组件
/// 提供优雅的淡入淡出过渡效果，替代默认的滑入动画
class SmoothMessageSwitcher extends StatelessWidget {
  final ChatMessage message;

  const SmoothMessageSwitcher({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      // 自定义过渡动画：淡入淡出效果
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: message.status == MessageStatus.sending && message.isFromAI
          ? OptimizedStreamingMessageWidget(
              key: ValueKey('streaming_${message.id}'),
              message: message,
              isStreaming: true,
            )
          : MessageContentWidget(
              key: ValueKey('static_${message.id}'),
              message: message,
            ),
    );
  }
}

/// 无动画的消息切换组件
/// 直接切换，没有任何过渡效果
class InstantMessageSwitcher extends StatelessWidget {
  final ChatMessage message;

  const InstantMessageSwitcher({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration.zero, // 无动画
      child: message.status == MessageStatus.sending && message.isFromAI
          ? OptimizedStreamingMessageWidget(
              key: ValueKey('streaming_${message.id}'),
              message: message,
              isStreaming: true,
            )
          : MessageContentWidget(
              key: ValueKey('static_${message.id}'),
              message: message,
            ),
    );
  }
}

/// 自定义滑动方向的消息切换组件
/// 可以自定义滑入方向和速度
class CustomSlideMessageSwitcher extends StatelessWidget {
  final ChatMessage message;
  final Offset slideDirection;
  final Duration duration;

  const CustomSlideMessageSwitcher({
    super.key,
    required this.message,
    this.slideDirection = const Offset(0.0, -0.3), // 默认从下方轻微滑入
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: slideDirection,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: message.status == MessageStatus.sending && message.isFromAI
          ? OptimizedStreamingMessageWidget(
              key: ValueKey('streaming_${message.id}'),
              message: message,
              isStreaming: true,
            )
          : MessageContentWidget(
              key: ValueKey('static_${message.id}'),
              message: message,
            ),
    );
  }
}