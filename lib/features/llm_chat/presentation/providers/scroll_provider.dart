import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';

/// 聊天滚动状态管理
class ChatScrollState {
  final bool shouldAutoScroll;
  final bool isUserScrolling;
  final bool isAtBottom;
  final int lastMessageCount;
  final String? lastMessageId;
  final DateTime lastUpdateTime;

  const ChatScrollState({
    this.shouldAutoScroll = true,
    this.isUserScrolling = false,
    this.isAtBottom = true,
    this.lastMessageCount = 0,
    this.lastMessageId,
    required this.lastUpdateTime,
  });

  ChatScrollState copyWith({
    bool? shouldAutoScroll,
    bool? isUserScrolling,
    bool? isAtBottom,
    int? lastMessageCount,
    String? lastMessageId,
    DateTime? lastUpdateTime,
  }) {
    return ChatScrollState(
      shouldAutoScroll: shouldAutoScroll ?? this.shouldAutoScroll,
      isUserScrolling: isUserScrolling ?? this.isUserScrolling,
      isAtBottom: isAtBottom ?? this.isAtBottom,
      lastMessageCount: lastMessageCount ?? this.lastMessageCount,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
    );
  }
}

/// 聊天滚动状态管理器
class ChatScrollNotifier extends StateNotifier<ChatScrollState> {
  ChatScrollNotifier() : super(ChatScrollState(lastUpdateTime: DateTime.now()));

  Timer? _userInteractionTimer;
  Timer? _scrollTimer;

  @override
  void dispose() {
    _userInteractionTimer?.cancel();
    _scrollTimer?.cancel();
    super.dispose();
  }

  /// 用户开始交互（点击菜单、切换选项等）
  void markUserInteraction() {
    _userInteractionTimer?.cancel();
    state = state.copyWith(
      shouldAutoScroll: false,
      lastUpdateTime: DateTime.now(),
    );
    _userInteractionTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        state = state.copyWith(
          shouldAutoScroll: true,
          lastUpdateTime: DateTime.now(),
        );
      }
    });
  }

  /// 用户开始滚动
  void markUserScrolling() {
    state = state.copyWith(
      isUserScrolling: true,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// 用户停止滚动
  void markUserScrollingStopped() {
    state = state.copyWith(
      isUserScrolling: false,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// 更新滚动位置状态
  void updateScrollPosition(ScrollController controller) {
    if (!mounted || !controller.hasClients) return;
    
    final position = controller.position;
    // 使用更智能的底部检测：距离底部80像素内认为在底部
    // 这样可以在用户快速滚动到接近底部时也触发自动滚动
    final isAtBottom = position.maxScrollExtent - position.pixels < 80;
    
    if (state.isAtBottom != isAtBottom) {
      state = state.copyWith(
        isAtBottom: isAtBottom,
        lastUpdateTime: DateTime.now(),
      );
    }
  }

  /// 检查消息变化并决定是否需要滚动
  bool shouldScrollForMessages(List<ChatMessage> messages) {
    if (!state.shouldAutoScroll) return false;
    if (state.isUserScrolling) return false;
    if (!state.isAtBottom) return false; // 只有在底部时才自动滚动

    final currentCount = messages.length;
    final lastCount = state.lastMessageCount;

    // 新消息
    if (currentCount > lastCount) {
      _updateMessageState(messages);
      return true;
    }

    // 流式更新（最后一条AI消息内容变化）
    if (messages.isNotEmpty) {
      final lastMessage = messages.last;
      final isStreamingUpdate =
          lastMessage.id == state.lastMessageId && !lastMessage.isFromUser;
      if (isStreamingUpdate) {
        return true;
      }
      _updateMessageState(messages);
    }
    return false;
  }

  /// 更新消息状态记录
  void _updateMessageState(List<ChatMessage> messages) {
    state = state.copyWith(
      lastMessageCount: messages.length,
      lastMessageId: messages.isNotEmpty ? messages.last.id : null,
      lastUpdateTime: DateTime.now(),
    );
  }

  /// 强制触发滚动（如发送消息后）
  void triggerScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) {
        state = state.copyWith(lastUpdateTime: DateTime.now());
      }
    });
  }
}

/// 聊天滚动状态Provider
final chatScrollProvider =
    StateNotifierProvider<ChatScrollNotifier, ChatScrollState>((ref) {
  return ChatScrollNotifier();
});

/// 滚动控制器Provider
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();

  // 不在这里修改 isUserScrolling，避免把编程滚动当作用户滚动。
  // 用户滚动的捕获在 ListView 外层的 NotificationListener 中处理。

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});
