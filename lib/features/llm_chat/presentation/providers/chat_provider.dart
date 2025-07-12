import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/usecases/chat_service.dart';
import '../../../persona_management/presentation/providers/persona_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/services/speech_service.dart';

/// 聊天状态管理
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final Ref _ref;
  final _uuid = const Uuid();
  StreamSubscription? _currentStreamSubscription;
  final SpeechService _speechService = SpeechService();

  ChatNotifier(this._chatService, this._ref) : super(const ChatState()) {
    // 延迟加载会话列表，避免构造函数中的异步操作
    _initialize();
    _initializeSpeechService();

    // 设置会话标题更新回调
    _chatService.onSessionTitleUpdated = _onSessionTitleUpdated;
    debugPrint('🔗 ChatNotifier: 已设置会话标题更新回调');
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

  /// 处理会话标题更新（自动命名回调）
  void _onSessionTitleUpdated(String sessionId, String newTitle) {
    debugPrint('🔄 收到会话标题更新回调: sessionId=$sessionId, newTitle=$newTitle');
    debugPrint('🔄 当前会话ID: ${state.currentSession?.id}');
    debugPrint('🔄 会话列表数量: ${state.sessions.length}');

    // 更新会话列表中的对应会话
    final updatedSessions = state.sessions.map((session) {
      if (session.id == sessionId) {
        debugPrint('🔄 找到匹配的会话，更新标题: ${session.title} → $newTitle');
        return session.updateTitle(newTitle);
      }
      return session;
    }).toList();

    // 更新当前会话（如果是当前会话）
    ChatSession? updatedCurrentSession = state.currentSession;
    if (state.currentSession?.id == sessionId) {
      debugPrint('🔄 更新当前会话标题: ${state.currentSession?.title} → $newTitle');
      updatedCurrentSession = state.currentSession!.updateTitle(newTitle);
    }

    // 更新状态
    final oldState = state;
    state = state.copyWith(
      sessions: updatedSessions,
      currentSession: updatedCurrentSession,
    );

    debugPrint('🔄 UI状态已更新完成');
    debugPrint('🔄 更新前当前会话标题: ${oldState.currentSession?.title}');
    debugPrint('🔄 更新后当前会话标题: ${state.currentSession?.title}');
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

  /// 清除所有会话
  Future<void> clearAllSessions() async {
    try {
      // 删除所有会话
      for (final session in state.sessions) {
        await _chatService.deleteChatSession(session.id);
      }

      // 清空状态
      state = state.copyWith(
        sessions: [],
        currentSession: null,
        messages: [],
        error: null,
      );

      // 自动创建一个新的会话
      await createNewSession();
    } catch (e) {
      state = state.copyWith(error: '清除所有会话失败: $e');
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

  /// 清除上下文（标记下次对话不包含历史）
  void clearContext() {
    state = state.copyWith(contextCleared: true, error: null);
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

      // 重新生成AI回复，不重复添加用户消息
      await _regenerateAIResponse(lastUserMessage.content);
    }
  }

  /// 重新生成AI回复（不添加新的用户消息）
  Future<void> _regenerateAIResponse(String userContent) async {
    // 检查是否有当前会话
    ChatSession? currentSession = state.currentSession;
    if (currentSession == null) {
      state = state.copyWith(error: '无法找到当前对话会话');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
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

      // 开始流式响应（使用原始用户内容）
      final stream = _chatService.sendMessageStream(
        sessionId: currentSession.id,
        content: userContent,
        includeContext: !state.contextCleared, // 如果清除了上下文则不包含历史
      );

      String fullResponse = '';
      bool isFirstUserMessage = true;

      // 取消之前的流订阅
      await _currentStreamSubscription?.cancel();

      // 创建新的流订阅
      _currentStreamSubscription = stream.listen(
        (messageChunk) {
          if (messageChunk.isFromUser && isFirstUserMessage) {
            // 跳过第一个用户消息，因为我们不需要重复添加
            isFirstUserMessage = false;
            return;
          }

          if (!messageChunk.isFromUser) {
            fullResponse = messageChunk.content;
            final updatedMessages = state.messages.map((m) {
              return m.id == aiMessageId
                  ? m.copyWith(
                      content: fullResponse,
                      status: messageChunk.status,
                    )
                  : m;
            }).toList();
            state = state.copyWith(
              messages: updatedMessages,
              isLoading: messageChunk.status != MessageStatus.sent,
            );
          }
        },
        onError: (error) {
          throw error;
        },
        onDone: () {
          _currentStreamSubscription = null;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '重新生成回复时出现错误: $e');
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
    // 检查是否有当前会话，如果没有则创建新会话
    ChatSession? currentSession = state.currentSession;
    if (currentSession == null) {
      try {
        await createNewSession();
        // 确保新会话已创建
        currentSession = state.currentSession;
        if (currentSession == null) {
          state = state.copyWith(error: '无法创建新的对话会话');
          return;
        }
      } catch (e) {
        state = state.copyWith(error: '创建新会话失败: $e');
        return;
      }
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
        includeContext: !state.contextCleared, // 如果清除了上下文则不包含历史
      );

      String fullResponse = '';
      bool isFirstUserMessage = true;

      // 取消之前的流订阅
      await _currentStreamSubscription?.cancel();

      // 创建新的流订阅
      _currentStreamSubscription = stream.listen(
        (messageChunk) {
          if (messageChunk.isFromUser && isFirstUserMessage) {
            // 跳过第一个用户消息，因为我们已经在UI中显示了
            isFirstUserMessage = false;
            return;
          }

          if (!messageChunk.isFromUser) {
            fullResponse = messageChunk.content;
            final updatedMessages = state.messages.map((m) {
              return m.id == aiMessageId
                  ? m.copyWith(
                      content: fullResponse,
                      status: messageChunk.status,
                    )
                  : m;
            }).toList();
            state = state.copyWith(
              messages: updatedMessages,
              isLoading: messageChunk.status != MessageStatus.sent,
            );
          }
        },
        onError: (error) {
          throw error;
        },
        onDone: () {
          _currentStreamSubscription = null;
        },
      );

      // 等待流完成
      await _currentStreamSubscription?.asFuture();

      // 消息发送完成后，重置上下文清除状态并重新加载会话信息
      state = state.copyWith(contextCleared: false);
      await _loadChatSessions();
    } catch (e) {
      // 取消当前流订阅
      await _currentStreamSubscription?.cancel();
      _currentStreamSubscription = null;

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

  /// 停止AI响应
  Future<void> stopResponse() async {
    if (_currentStreamSubscription != null) {
      await _currentStreamSubscription?.cancel();
      _currentStreamSubscription = null;

      // 更新最后一条AI消息的状态为已发送（即使被中断）
      final updatedMessages = state.messages.map((m) {
        if (!m.isFromUser && m.status == MessageStatus.sending) {
          return m.copyWith(status: MessageStatus.sent);
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages, isLoading: false);
    }
  }

  /// 初始化语音识别服务
  void _initializeSpeechService() {
    _speechService.setOnResult((text) {
      state = state.copyWith(speechText: text);
    });

    _speechService.setOnError((error) {
      state = state.copyWith(error: error, isListening: false, speechText: '');
    });

    _speechService.setOnListeningStatusChanged((isListening) {
      state = state.copyWith(isListening: isListening);
    });
  }

  /// 开始语音识别
  Future<void> startSpeechRecognition() async {
    if (state.isListening) return;

    state = state.copyWith(speechText: '', error: null);

    final success = await _speechService.startListening();
    if (!success) {
      state = state.copyWith(error: '无法开始语音识别，请检查麦克风权限', isListening: false);
    }
  }

  /// 停止语音识别
  Future<void> stopSpeechRecognition() async {
    if (!state.isListening) return;
    await _speechService.stopListening();
  }

  /// 取消语音识别
  Future<void> cancelSpeechRecognition() async {
    if (!state.isListening) return;
    await _speechService.cancel();
    state = state.copyWith(isListening: false, speechText: '');
  }

  /// 确认语音识别结果
  void confirmSpeechText() {
    if (state.speechText.isNotEmpty) {
      // 将语音识别的文本发送为消息
      sendMessage(state.speechText);
      // 清空语音文本
      state = state.copyWith(speechText: '');
    }
  }

  /// 清空语音文本
  void clearSpeechText() {
    state = state.copyWith(speechText: '');
  }

  /// 获取语音服务是否可用
  bool get isSpeechAvailable => _speechService.isAvailable;

  @override
  void dispose() {
    _speechService.dispose();
    super.dispose();
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
  final bool isListening;
  final String speechText;
  final bool contextCleared; // 标记是否已清除上下文

  const ChatState({
    this.messages = const [],
    this.currentSession,
    this.isLoading = false,
    this.error,
    this.sessions = const [],
    this.attachedFiles = const [],
    this.isListening = false,
    this.speechText = '',
    this.contextCleared = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatSession? currentSession,
    bool? isLoading,
    String? error,
    List<ChatSession>? sessions,
    List<PlatformFile>? attachedFiles,
    bool? isListening,
    String? speechText,
    bool? contextCleared,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      currentSession: currentSession ?? this.currentSession,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessions: sessions ?? this.sessions,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      isListening: isListening ?? this.isListening,
      speechText: speechText ?? this.speechText,
      contextCleared: contextCleared ?? this.contextCleared,
    );
  }

  @override
  String toString() {
    return 'ChatState(messages: ${messages.length}, currentSession: ${currentSession?.id}, isLoading: $isLoading, error: $error, sessions: ${sessions.length}, isListening: $isListening, speechText: "$speechText")';
  }
}

/// 聊天Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  final notifier = ChatNotifier(chatService, ref);

  // 确保回调在Provider重建时重新设置
  ref.onDispose(() {
    chatService.onSessionTitleUpdated = null;
  });

  return notifier;
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
