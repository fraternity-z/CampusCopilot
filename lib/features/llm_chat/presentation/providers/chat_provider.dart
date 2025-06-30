import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/usecases/chat_service.dart';
import '../../../persona_management/presentation/providers/persona_provider.dart';
import 'package:file_picker/file_picker.dart';

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

  /// 附加文件
  void attachFiles(List<PlatformFile> files) {
    state = state.copyWith(attachedFiles: [...state.attachedFiles, ...files]);
  }

  /// 移除文件
  void removeFile(PlatformFile file) {
    state = state.copyWith(
      attachedFiles: state.attachedFiles
          .where((f) => f.path != file.path)
          .toList(),
    );
  }

  /// 清除所有附件
  void clearAttachments() {
    state = state.copyWith(attachedFiles: []);
  }

  /// 发送消息
  Future<void> sendMessage(String text) async {
    final currentSession = state.currentSession;
    if (currentSession == null) {
      await createNewSession();
      // 等待新会话创建后再次发送
      if (state.currentSession != null) {
        await sendMessage(text);
      }
      return;
    }

    if (text.isEmpty && state.attachedFiles.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    // 将附件信息合并到消息内容中
    String messageContent = text;
    if (state.attachedFiles.isNotEmpty) {
      final fileNames = state.attachedFiles.map((f) => f.name).join(', ');
      messageContent = '$text\n\n[附件: $fileNames]';
      // 发送后清除附件
      state = state.copyWith(attachedFiles: []);
    }

    try {
      // 首先创建用户消息并立即显示在UI中
      final userMessage = ChatMessage(
        id: _uuid.v4(),
        chatSessionId: currentSession.id,
        content: messageContent,
        isFromUser: true,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      // 立即将用户消息添加到UI
      state = state.copyWith(messages: [...state.messages, userMessage]);

      // 创建AI消息占位符
      final aiMessageId = _uuid.v4();
      final aiPlaceholder = ChatMessage(
        id: aiMessageId,
        chatSessionId: currentSession.id,
        content: '...',
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      // 添加AI占位符到UI
      state = state.copyWith(messages: [...state.messages, aiPlaceholder]);

      // 开始流式响应
      final stream = _chatService.sendMessageStream(
        sessionId: currentSession.id,
        content: messageContent,
      );

      String fullResponse = '';
      bool isFirstUserMessage = true;

      await for (final messageChunk in stream) {
        if (messageChunk.isFromUser && isFirstUserMessage) {
          // 跳过第一个用户消息，因为我们已经在UI中显示了
          isFirstUserMessage = false;
          continue;
        }

        if (!messageChunk.isFromUser) {
          fullResponse = messageChunk.content;
          final updatedMessages = state.messages.map((m) {
            return m.id == aiMessageId
                ? m.copyWith(content: fullResponse, status: messageChunk.status)
                : m;
          }).toList();
          state = state.copyWith(
            messages: updatedMessages,
            isLoading: messageChunk.status != MessageStatus.sent,
          );
        }
      }

      // 消息发送完成后，重新加载会话信息以更新计数
      await _loadChatSessions();
    } catch (e) {
      // 如果发生错误，移除占位符并显示错误消息
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        chatSessionId: currentSession.id,
        content: '抱歉，发生错误: $e',
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.failed,
      );

      // 移除占位符，添加错误消息
      final messagesWithoutPlaceholder = state.messages
          .where((m) => !(m.content == '...' && !m.isFromUser))
          .toList();

      state = state.copyWith(
        messages: [...messagesWithoutPlaceholder, errorMessage],
        isLoading: false,
        error: e.toString(),
      );
    } finally {
      // 确保最终加载状态为 false
      state = state.copyWith(isLoading: false);
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
  final List<PlatformFile> attachedFiles;

  const ChatState({
    this.messages = const [],
    this.currentSession,
    this.isLoading = false,
    this.error,
    this.sessions = const [],
    this.attachedFiles = const [],
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatSession? currentSession,
    bool? isLoading,
    String? error,
    List<ChatSession>? sessions,
    List<PlatformFile>? attachedFiles,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      currentSession: currentSession ?? this.currentSession,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessions: sessions ?? this.sessions,
      attachedFiles: attachedFiles ?? this.attachedFiles,
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
