import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/usecases/chat_service.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../persona_management/presentation/providers/persona_provider.dart';

/// 聊天状态管理
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final Ref _ref;
  final _uuid = const Uuid();

  ChatNotifier(this._chatService, this._ref) : super(const ChatState()) {
    // 延迟加载会话列表，避免构造函数中的异步操作
    _initialize();
  }

  /// 初始化方法
  void _initialize() {
    Future.microtask(() async {
      try {
        await _loadChatSessions();
      } catch (e) {
        state = state.copyWith(error: '初始化失败: $e', sessions: <ChatSession>[]);
      }
    });
  }

  /// 加载聊天会话列表
  Future<void> _loadChatSessions() async {
    try {
      final sessions = await _chatService.getChatSessions();
      // 直接使用sessions，因为getChatSessions保证返回非null列表
      state = state.copyWith(sessions: sessions, error: null);
    } catch (e) {
      // 确保在错误情况下也有一个空列表
      state = state.copyWith(
        error: '加载会话列表失败: $e',
        sessions: <ChatSession>[], // 明确指定类型
      );
    }
  }

  /// 选择会话
  Future<void> selectSession(String sessionId) async {
    try {
      final sessionIndex = state.sessions.indexWhere((s) => s.id == sessionId);
      if (sessionIndex == -1) {
        state = state.copyWith(error: '会话不存在');
        return;
      }

      final session = state.sessions[sessionIndex];
      final messages = await _chatService.getSessionMessages(sessionId);

      state = state.copyWith(
        currentSession: session,
        messages: messages,
        error: null,
      );
    } catch (e) {
      // 添加调试信息
      state = state.copyWith(error: '加载会话失败: $e');
    }
  }

  /// 删除会话
  Future<void> deleteSession(String sessionId) async {
    try {
      await _chatService.deleteChatSession(sessionId);

      final updatedSessions = state.sessions
          .where((s) => s.id != sessionId)
          .toList();

      // 如果删除的是当前会话，清空当前状态
      if (state.currentSession?.id == sessionId) {
        state = state.copyWith(
          sessions: updatedSessions,
          currentSession: null,
          messages: [],
          error: null,
        );
      } else {
        state = state.copyWith(sessions: updatedSessions);
      }
    } catch (e) {
      state = state.copyWith(error: '删除会话失败: $e');
    }
  }

  /// 发送消息
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 检查AI配置
    final currentProvider = _ref.read(currentAIProviderProvider);

    if (currentProvider == null) {
      state = state.copyWith(
        error: 'Please configure AI service in settings first',
      );
      return;
    }

    // 确保有当前会话，如果没有则创建一个使用当前智能体的会话
    if (state.currentSession == null) {
      await _createNewSession();
    }

    // 创建用户消息
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
      chatSessionId: state.currentSession?.id ?? 'default',
    );

    // 添加用户消息到状态
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      // 发送到AI服务（使用数据库驱动的流式接口）
      final stream = _chatService.sendMessageStream(
        sessionId: state.currentSession?.id ?? 'default',
        content: content,
      );

      // 创建AI消息占位符
      final aiMessageId = _uuid.v4();
      final aiMessage = ChatMessage(
        id: aiMessageId,
        content: '',
        isFromUser: false,
        timestamp: DateTime.now(),
        chatSessionId: state.currentSession?.id ?? 'default',
        status: MessageStatus.sending,
      );

      state = state.copyWith(messages: [...state.messages, aiMessage]);

      // 处理流式响应
      await for (final msg in stream) {
        // 跳过用户消息（已在本地添加）
        if (msg.isFromUser) continue;

        // 更新AI消息内容
        final updatedMessages = state.messages.map((m) {
          if (m.id == aiMessageId) {
            return m.copyWith(content: msg.content, status: msg.status);
          }
          return m;
        }).toList();

        state = state.copyWith(
          messages: updatedMessages,
          isLoading: msg.status != MessageStatus.sent,
        );

        if (msg.status == MessageStatus.sent) {
          break;
        }
      }
    } catch (e) {
      // 处理错误
      state = state.copyWith(isLoading: false, error: e.toString());

      // 移除失败的AI消息或标记为失败
      final updatedMessages = state.messages.map((msg) {
        if (!msg.isFromUser && msg.content.isEmpty) {
          return msg.copyWith(
            content: 'Failed to get response: ${e.toString()}',
            status: MessageStatus.failed,
          );
        }
        return msg;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    }
  }

  /// 创建新的聊天会话（私有方法）
  Future<void> _createNewSession() async {
    final selectedPersona = _ref.read(selectedPersonaProvider);
    final personaId = selectedPersona?.id ?? 'default';

    final session = ChatSession(
      id: _uuid.v4(),
      title: 'New Chat',
      personaId: personaId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(currentSession: session, messages: [], error: null);
  }

  /// 创建新的聊天会话（公共方法）
  Future<void> createNewSession() async {
    try {
      final selectedPersona = _ref.read(selectedPersonaProvider);
      final personaId = selectedPersona?.id ?? 'default';

      final session = await _chatService.createChatSession(
        personaId: personaId,
        title: '新对话',
      );

      // 更新会话列表并选择新会话
      final updatedSessions = [session, ...state.sessions];
      state = state.copyWith(
        sessions: updatedSessions,
        currentSession: session,
        messages: [],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: '创建新会话失败: $e');
    }
  }

  /// 清空当前聊天
  void clearChat() {
    state = state.copyWith(messages: [], error: null);
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 重试最后一条消息
  Future<void> retryLastMessage() async {
    final lastUserMessage = state.messages
        .where((msg) => msg.isFromUser)
        .lastOrNull;

    if (lastUserMessage != null) {
      // 移除最后的AI响应（如果有）
      final messagesWithoutLastAI = state.messages
          .where(
            (msg) => !(msg.id == state.messages.last.id && !msg.isFromUser),
          )
          .toList();

      state = state.copyWith(messages: messagesWithoutLastAI);

      // 重新发送
      await sendMessage(lastUserMessage.content);
    }
  }
}

/// 聊天状态
class ChatState {
  final List<ChatMessage> messages;
  final ChatSession? currentSession;
  final bool isLoading;
  final String? error;
  final List<ChatSession> sessions;

  const ChatState({
    this.messages = const [],
    this.currentSession,
    this.isLoading = false,
    this.error,
    this.sessions = const [],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatSession? currentSession,
    bool? isLoading,
    String? error,
    List<ChatSession>? sessions,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      currentSession: currentSession ?? this.currentSession,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  String toString() {
    return 'ChatState(messages: ${messages.length}, currentSession: ${currentSession?.id}, isLoading: $isLoading, error: $error, sessions: ${sessions.length})';
  }
}

/// 聊天Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.read(chatServiceProvider);
  return ChatNotifier(chatService, ref);
});

/// 当前聊天会话Provider
final currentChatSessionProvider = Provider<ChatSession?>((ref) {
  return ref.watch(chatProvider).currentSession;
});

/// 聊天消息列表Provider
final chatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatProvider).messages;
});

/// 聊天加载状态Provider
final chatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isLoading;
});

/// 聊天错误Provider
final chatErrorProvider = Provider<String?>((ref) {
  return ref.watch(chatProvider).error;
});

/// 聊天会话列表Provider
final chatSessionsProvider = Provider<List<ChatSession>>((ref) {
  final sessions = ref.watch(chatProvider).sessions;
  return sessions; // sessions已经在ChatState中有默认值[]
});
