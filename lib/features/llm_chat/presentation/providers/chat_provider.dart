import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/usecases/chat_service.dart';
import '../../../persona_management/presentation/providers/persona_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/services/image_service.dart';
import '../../../../core/services/image_generation_service.dart';
import '../../../knowledge_base/presentation/providers/document_processing_provider.dart';
import '../../../learning_mode/data/providers/learning_mode_provider.dart';
import '../../../learning_mode/domain/services/learning_prompt_service.dart';
import '../../../learning_mode/domain/services/learning_session_service.dart';
import '../../../learning_mode/domain/entities/learning_session.dart';

/// 聊天状态管理
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final Ref _ref;
  final _uuid = const Uuid();
  StreamSubscription? _currentStreamSubscription;

  final ImageService _imageService = ImageService();
  final ImageGenerationService _imageGenerationService =
      ImageGenerationService();

  ChatNotifier(this._chatService, this._ref) : super(const ChatState()) {
    // 延迟加载会话列表，避免构造函数中的异步操作
    _initialize();

    // 设置会话标题更新回调
    _chatService.onSessionTitleUpdated = _onSessionTitleUpdated;
    
    // 设置搜索状态回调
    _chatService.onSearchStatusChanged = _onSearchStatusChanged;
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

  /// 处理搜索状态变化回调
  void _onSearchStatusChanged(bool isSearching) {
    debugPrint('🔍 搜索状态变化: $isSearching');
    state = state.copyWith(isSearching: isSearching);
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
    // 学习模式处理：检查是否启用学习模式并处理消息内容
    final learningModeState = _ref.read(learningModeProvider);
    String processedMessage = userContent;
    
    if (learningModeState.isLearningMode) {
      // 重新生成时检查是否应该给出答案
      final userWantsDirectAnswer = _isRequestingDirectAnswer(userContent);
      final reachedMaxRounds = learningModeState.currentSession != null && 
          learningModeState.currentSession!.currentRound >= learningModeState.currentSession!.maxRounds;
      final shouldGiveFinalAnswerInRegen = userWantsDirectAnswer || reachedMaxRounds;
      
      // 构建学习模式消息，并添加重新生成标识
      if (learningModeState.currentSession != null) {
        processedMessage = _buildLearningSessionMessage(
          userContent, 
          learningModeState, 
          isRegeneration: true,
          shouldGiveFinalAnswer: shouldGiveFinalAnswerInRegen,
          userRequestedAnswer: false, // 重新生成时无法确定具体原因
          reachedMaxRounds: shouldGiveFinalAnswerInRegen,
        );
      } else {
        processedMessage = _buildLearningModeMessage(
          userContent, 
          learningModeState, 
          isRegeneration: true,
          shouldGiveFinalAnswer: shouldGiveFinalAnswerInRegen,
        );
      }
      
      debugPrint('🎓 学习模式重新生成: ${learningModeState.style.displayName}');
    }
    
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
        content: '',
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      // 添加AI占位符到UI
      state = state.copyWith(messages: [...state.messages, aiPlaceholder]);

      // 开始流式响应（在学习模式下使用处理过的消息，普通模式下使用原始内容）
      final messageContent = learningModeState.isLearningMode ? processedMessage : userContent;
      final stream = _chatService.sendMessageStream(
        sessionId: currentSession.id,
        content: messageContent, // AI处理用的内容
        includeContext: !state.contextCleared, // 如果清除了上下文则不包含历史
        displayContent: userContent, // 传递原始用户输入用于显示
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
            debugPrint('🔍 重新生成：跳过流中的用户消息');
            return;
          }

          // 额外保护：如果流中还有其他用户消息，也要跳过
          if (messageChunk.isFromUser) {
            debugPrint('⚠️ 重新生成：检测到额外的用户消息，跳过以保护原始内容');
            return;
          }

          if (!messageChunk.isFromUser) {
            fullResponse = messageChunk.content;
            final updatedMessages = state.messages.map((m) {
              return m.id == aiMessageId
                  ? m.copyWith(
                      content: fullResponse,
                      status: messageChunk.status,
                      modelName: messageChunk.modelName,
                    )
                  : m;
            }).toList();
            state = state.copyWith(
              messages: updatedMessages,
              isLoading: messageChunk.status != MessageStatus.sent,
            );

            // 如果是学习模式且AI回复完成，进行学习模式处理
            if (learningModeState.isLearningMode && messageChunk.status == MessageStatus.sent) {
              _processLearningModeResponse(fullResponse, aiMessageId);
            }
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
    state = state.copyWith(attachedFiles: [], attachedImages: []);
  }

  /// 从相册选择图片
  Future<void> pickImagesFromGallery({int maxImages = 5}) async {
    try {
      final images = await _imageService.pickImagesFromGallery(
        maxImages: maxImages,
      );

      if (images.isNotEmpty) {
        state = state.copyWith(
          attachedImages: [...state.attachedImages, ...images],
        );
      }
    } catch (e) {
      state = state.copyWith(error: '选择图片失败: $e');
    }
  }

  /// 拍摄照片
  Future<void> capturePhoto() async {
    try {
      final image = await _imageService.capturePhoto();

      if (image != null) {
        state = state.copyWith(
          attachedImages: [...state.attachedImages, image],
        );
      }
    } catch (e) {
      state = state.copyWith(error: '拍摄照片失败: $e');
    }
  }

  /// 选择单张图片
  Future<void> pickSingleImage() async {
    try {
      final image = await _imageService.pickSingleImageFromGallery();

      if (image != null) {
        state = state.copyWith(
          attachedImages: [...state.attachedImages, image],
        );
      }
    } catch (e) {
      state = state.copyWith(error: '选择图片失败: $e');
    }
  }

  /// 移除图片
  void removeImage(ImageResult image) {
    state = state.copyWith(
      attachedImages: state.attachedImages
          .where((img) => img.savedPath != image.savedPath)
          .toList(),
    );
  }

  /// 清除所有图片
  void clearImages() {
    state = state.copyWith(attachedImages: []);
  }

  /// 添加处理过的图片
  void addProcessedImage(ImageResult image) {
    state = state.copyWith(attachedImages: [...state.attachedImages, image]);
  }

  /// 判断是否应该使用图像生成服务
  bool _shouldUseImageGeneration(String text) {
    // 1. 首先检查文本是否包含明确的图像生成指令
    if (_isImageGenerationPrompt(text)) {
      debugPrint('🔍 检测到图像生成指令: $text');
      return true;
    }
    
    // 2. 未来可以添加更多检测逻辑，比如：
    // - 检查当前选择的模型是否为图像模型
    // - 检查用户偏好设置
    // - 检查上下文信息等
    
    return false;
  }


  /// 检测用户是否要求直接答案 - 让AI自己判断
  bool _isRequestingDirectAnswer(String text) {
    return false; // 先简化为false，让AI在学习提示词中自己判断
  }

  /// 判断是否为图像生成指令
  bool _isImageGenerationPrompt(String text) {
    final lowerText = text.toLowerCase().trim();
    
    // 中文图像生成指令
    final chineseKeywords = [
      '画', '绘制', '绘画', '画一', '画个', '画出', '生成图', '创建图', '制作图', 
      '图像', '图片', '插画', '素描', '水彩', '油画', '漫画', '卡通',
    ];
    
    // 英文图像生成指令
    final englishKeywords = [
      'draw', 'paint', 'create', 'generate', 'make', 'design', 'sketch', 
      'illustrate', 'render', 'produce', 'image of', 'picture of', 'art of',
      'painting of', 'drawing of', 'illustration of',
    ];
    
    // 检查是否以这些关键词开头或包含这些关键词
    for (final keyword in chineseKeywords) {
      if (lowerText.startsWith(keyword) || lowerText.contains(keyword)) {
        return true;
      }
    }
    
    for (final keyword in englishKeywords) {
      if (lowerText.startsWith(keyword) || lowerText.contains(keyword)) {
        return true;
      }
    }
    
    return false;
  }

  /// 带占位符的图像生成（内部使用）
  Future<void> _generateImageWithPlaceholder(String prompt, String placeholderId) async {
    await _generateImageInternal(
      prompt: prompt,
      placeholderId: placeholderId,
    );
  }

  /// 生成AI图片（公共接口）
  Future<void> generateImage({
    required String prompt,
    int count = 1,
    ImageSize size = ImageSize.size1024x1024,
    ImageQuality quality = ImageQuality.standard,
    ImageStyle style = ImageStyle.vivid,
  }) async {
    await _generateImageInternal(
      prompt: prompt,
      count: count,
      size: size,
      quality: quality,
      style: style,
    );
  }

  /// 内部图像生成方法
  Future<void> _generateImageInternal({
    required String prompt,
    String? placeholderId,
    int count = 1,
    ImageSize size = ImageSize.size1024x1024,
    ImageQuality quality = ImageQuality.standard,
    ImageStyle style = ImageStyle.vivid,
  }) async {
    // 检查是否有当前会话
    ChatSession? currentSession = state.currentSession;
    if (currentSession == null) {
      if (placeholderId != null) {
        // 如果有占位符，移除它并显示错误
        final messagesWithoutPlaceholder = state.messages.where((m) => m.id != placeholderId).toList();
        state = state.copyWith(
          messages: messagesWithoutPlaceholder,
          error: '无法找到当前对话会话',
          isLoading: false,
        );
      } else {
        state = state.copyWith(error: '无法找到当前对话会话');
      }
      return;
    }

    // 只有在没有占位符时才设置全局加载状态
    if (placeholderId == null) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      // 使用和聊天相同的配置获取逻辑：通过会话 → 智能体 → API配置
      final llmConfig = await _chatService.getSessionLlmConfig(currentSession.id);
      debugPrint('🔧 图像生成LLM配置: ${llmConfig.name} (${llmConfig.provider})');

      // 直接使用LLM配置的信息
      String? apiKey = llmConfig.apiKey;
      String? baseUrl = llmConfig.baseUrl;
      String configType = '${llmConfig.name} (${llmConfig.provider})';

      if (apiKey.isEmpty) {
        throw Exception('配置 "${llmConfig.name}" 的API密钥为空，请检查配置');
      }

      debugPrint('🎨 使用 $configType 配置生成图片');
      debugPrint('🌐 API端点: ${baseUrl ?? 'https://api.openai.com/v1'}');
      
      // 生成图片
      final results = await _imageGenerationService.generateImages(
        prompt: prompt,
        count: count,
        size: size,
        quality: quality,
        style: style,
        apiKey: apiKey,
        baseUrl: baseUrl,
      );

      if (results.isNotEmpty) {
        // 创建包含生成图片的消息
        final imageUrls = results.map((r) => 'file://${r.localPath}').toList();
        
        final imageMessage = ChatMessage(
          id: placeholderId ?? '${DateTime.now().microsecondsSinceEpoch}_${_uuid.v4()}',
          chatSessionId: currentSession.id,
          content: '生成了${results.length}张图片：$prompt',
          isFromUser: false,
          timestamp: DateTime.now(),
          type: MessageType.image,
          imageUrls: imageUrls,
          status: MessageStatus.sent,
          metadata: {
            'generated': true,
            'prompt': prompt,
            'model': results.first.model,
            'size': results.first.sizeDescription,
            'quality': quality.name,
            'style': style.name,
          },
        );

        // 保存到数据库
        await _chatService.insertMessage(imageMessage);

        // 更新UI - 如果有占位符则替换，否则添加
        if (placeholderId != null) {
          final updatedMessages = state.messages.map((m) {
            return m.id == placeholderId ? imageMessage : m;
          }).toList();
          state = state.copyWith(
            messages: updatedMessages,
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            messages: [...state.messages, imageMessage],
            isLoading: false,
          );
        }
      }
    } catch (e) {
      debugPrint('❌ 图片生成失败: $e');
      
      // 创建错误消息
      final errorMessage = ChatMessage(
        id: placeholderId ?? '${DateTime.now().microsecondsSinceEpoch}_${_uuid.v4()}',
        chatSessionId: currentSession.id,
        content: '图片生成失败: $e',
        isFromUser: false,
        timestamp: DateTime.now(),
        type: MessageType.error,
        status: MessageStatus.failed,
        metadata: {
          'error': true,
          'errorType': 'image_generation_failed',
          'originalPrompt': prompt,
        },
      );

      try {
        // 保存错误消息到数据库
        await _chatService.insertMessage(errorMessage);
        
        // 更新UI显示错误消息 - 如果有占位符则替换，否则添加
        if (placeholderId != null) {
          final updatedMessages = state.messages.map((m) {
            return m.id == placeholderId ? errorMessage : m;
          }).toList();
          state = state.copyWith(
            messages: updatedMessages,
            isLoading: false,
            error: null,
          );
        } else {
          state = state.copyWith(
            messages: [...state.messages, errorMessage],
            isLoading: false,
            error: null,
          );
        }
      } catch (dbError) {
        debugPrint('❌ 保存错误消息失败: $dbError');
        // 如果数据库操作也失败，处理占位符并设置全局错误状态
        if (placeholderId != null) {
          final messagesWithoutPlaceholder = state.messages.where((m) => m.id != placeholderId).toList();
          state = state.copyWith(
            messages: messagesWithoutPlaceholder,
            error: '图片生成失败: $e',
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            error: '图片生成失败: $e',
            isLoading: false,
          );
        }
      }
    }
  }

  /// 发送消息
  Future<void> sendMessage(String text) async {
    // 学习模式处理：检查是否启用学习模式并处理消息内容
    final learningModeState = _ref.read(learningModeProvider);
    final learningModeNotifier = _ref.read(learningModeProvider.notifier);
    String processedMessage = text;
    
    if (learningModeState.isLearningMode) {
      // 检查是否需要开始新的学习会话
      if (learningModeState.currentSession == null && 
          LearningSessionService.isLearningQuestion(text)) {
        // 开始新的学习会话
        learningModeNotifier.startLearningSession(text);
        debugPrint('🎓 开始新的学习会话');
      }
      
      // 简化逻辑：检查用户是否明确要求答案或到达最后一轮
      final userWantsDirectAnswer = _isRequestingDirectAnswer(text);
      final reachedMaxRounds = learningModeState.currentSession != null && 
          learningModeState.currentSession!.currentRound >= learningModeState.currentSession!.maxRounds;
      // 关键修改：只有当这轮回复后正好达到最大轮数时，才给最终答案
      // 例如：3轮设置，第3轮时给最终答案（currentRound + 1 == maxRounds）  
      final willReachMaxRounds = learningModeState.currentSession != null && 
          (learningModeState.currentSession!.currentRound + 1) == learningModeState.currentSession!.maxRounds;
      final shouldGiveFinalAnswer = userWantsDirectAnswer || reachedMaxRounds || willReachMaxRounds;
      
      debugPrint('🔍 学习模式检测: 用户要求答案=$userWantsDirectAnswer, 达到最大轮数=$reachedMaxRounds, 应给最终答案=$shouldGiveFinalAnswer');
      debugPrint('🔍 用户消息: "$text"');
      
      // 如果用户要求答案或达到最大轮数，标记会话状态
      if (shouldGiveFinalAnswer && learningModeState.currentSession != null) {
        final updatedSession = learningModeState.currentSession!.copyWith(
          userRequestedAnswer: userWantsDirectAnswer,
          status: LearningSessionStatus.active, // 保持active状态直到AI回复完成
        );
        learningModeNotifier.updateCurrentSession(updatedSession);
        debugPrint('🎓 将在本轮给出完整答案');
      }
      
      // 构建学习模式消息（传递是否应该给出最终答案的信息）
      if (learningModeState.currentSession != null) {
        processedMessage = _buildLearningSessionMessage(
          text, 
          learningModeState,
          shouldGiveFinalAnswer: shouldGiveFinalAnswer,
          userRequestedAnswer: userWantsDirectAnswer,
          reachedMaxRounds: reachedMaxRounds || willReachMaxRounds,
        );
      } else {
        processedMessage = _buildLearningModeMessage(
          text, 
          learningModeState, 
          shouldGiveFinalAnswer: shouldGiveFinalAnswer,
        );
      }
      
      debugPrint('🎓 学习模式已激活: ${learningModeState.style.displayName}');
    }
    
    // 智能路由：检查是否应该使用图像生成
    final isImageGeneration = _shouldUseImageGeneration(text);
    if (isImageGeneration) {
      debugPrint('🎨 检测到图像生成指令，将在创建用户消息后进行图像生成');
    }
    
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

    if (text.isEmpty &&
        state.attachedFiles.isEmpty &&
        state.attachedImages.isEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    // 准备消息内容和图片URL
    // 在学习模式下使用处理过的消息，普通模式下使用原始文本
    String messageContent = learningModeState.isLearningMode ? processedMessage : text;
    List<String> imageUrls = [];

    // 处理附加的图片
    List<String> imageUrlsForAI = []; // 用于传递给AI的base64格式
    if (state.attachedImages.isNotEmpty) {
      // UI显示用：使用本地文件路径，这样ImagePreviewWidget可以正确显示
      imageUrls = state.attachedImages
          .map((img) => 'file://${img.savedPath}')
          .toList();

      // AI处理用：使用base64格式
      imageUrlsForAI = state.attachedImages
          .map((img) => img.base64String)
          .toList();

      if (text.isEmpty) {
        messageContent = '发送了${state.attachedImages.length}张图片';
      }
    }

    // 处理其他附件 - 分离UI显示和AI内容
    final fileAttachments = <FileAttachment>[];
    final fileContents = <String>[];

    if (state.attachedFiles.isNotEmpty) {
      for (final file in state.attachedFiles) {
        if (file.path != null) {
          try {
            // 使用文档处理服务读取文件内容
            final documentProcessingService = _ref.read(
              documentProcessingServiceProvider,
            );
            final extractionResult = await documentProcessingService
                .extractTextFromFile(file.path!, file.extension ?? 'unknown');

            // 创建文件附件信息（用于UI显示）
            final attachment = FileAttachment(
              fileName: file.name,
              fileSize: file.size,
              fileType: file.extension ?? 'unknown',
              filePath: file.path,
              content: extractionResult.error == null
                  ? extractionResult.text
                  : null,
            );
            fileAttachments.add(attachment);

            // 添加文件内容到消息（用于传递给AI）
            if (extractionResult.error == null &&
                extractionResult.text.isNotEmpty) {
              fileContents.add(
                '文件 "${file.name}" 的内容：\n${extractionResult.text}',
              );
            } else {
              fileContents.add(
                '文件 "${file.name}" 无法读取内容：${extractionResult.error ?? "未知错误"}',
              );
            }
          } catch (e) {
            // 即使读取失败，也创建附件信息
            final attachment = FileAttachment(
              fileName: file.name,
              fileSize: file.size,
              fileType: file.extension ?? 'unknown',
              filePath: file.path,
            );
            fileAttachments.add(attachment);
            fileContents.add('文件 "${file.name}" 读取失败：$e');
          }
        } else {
          // 路径无效的情况
          final attachment = FileAttachment(
            fileName: file.name,
            fileSize: file.size,
            fileType: file.extension ?? 'unknown',
          );
          fileAttachments.add(attachment);
          fileContents.add('文件 "${file.name}" 路径无效');
        }
      }

      // 只有在有文件内容时才添加到消息中（用于AI处理）
      if (fileContents.isNotEmpty) {
        messageContent = '$messageContent\n\n${fileContents.join('\n\n')}';
      }
    }

    try {
      // 创建用户消息（UI显示用，不包含文件内容）
      final displayContent = text.trim().isEmpty && fileAttachments.isNotEmpty
          ? '发送了${fileAttachments.length}个文件'
          : text;

      // 准备图片元数据
      Map<String, dynamic>? messageMetadata;
      if (state.attachedImages.isNotEmpty) {
        messageMetadata = {
          'imageFileNames': state.attachedImages
              .map((img) => img.fileName)
              .toList(),
          'imageFileSizes': state.attachedImages
              .map((img) => img.originalSize)
              .toList(),
        };
      }

      final userMessage = ChatMessage(
        id: _uuid.v4(),
        chatSessionId: currentSession.id,
        content: displayContent,
        isFromUser: true,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        type: imageUrls.isNotEmpty ? MessageType.image : MessageType.text,
        imageUrls: imageUrls,
        attachments: fileAttachments,
        metadata: messageMetadata,
      );

      // 立即将用户消息添加到UI，并清除附件
      state = state.copyWith(
        messages: [...state.messages, userMessage],
        attachedFiles: [],
        attachedImages: [],
      );

      final aiMessageId = _uuid.v4();
      // 为正常显示新增占位符（空内容）
      final aiPlaceholderSend = ChatMessage(
        id: aiMessageId,
        chatSessionId: currentSession.id,
        content: '',
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );
      state = state.copyWith(messages: [...state.messages, aiPlaceholderSend]);

      // 检查是否是图像生成指令
      if (isImageGeneration) {
        debugPrint('🎨 开始图像生成流程');
        
        // 为图像生成创建特殊的AI占位符消息
        final imageAiPlaceholder = aiPlaceholderSend.copyWith(
          content: '正在生成图片...',
          type: MessageType.generating,
          metadata: {
            'isImageGeneration': true,
            'prompt': text,
          },
        );
        
        // 更新AI占位符为图像生成占位符
        final updatedMessages = state.messages.map((m) {
          return m.id == aiMessageId ? imageAiPlaceholder : m;
        }).toList();
        
        state = state.copyWith(messages: updatedMessages, isLoading: true);
        
        // 调用图像生成，传递占位符ID以便替换
        await _generateImageWithPlaceholder(text, aiMessageId);
        return;
      }

      // 开始流式响应
      final stream = _chatService.sendMessageStream(
        sessionId: currentSession.id,
        content: messageContent, // AI处理用的内容
        includeContext: !state.contextCleared, // 如果清除了上下文则不包含历史
        imageUrls: imageUrlsForAI, // 传递base64格式的图片给AI
        displayContent: text, // 传递原始用户输入用于显示
      );

      String fullResponse = '';
      bool isFirstUserMessage = true;

      // 取消之前的流订阅
      await _currentStreamSubscription?.cancel();

      // 创建新的流订阅
      _currentStreamSubscription = stream.listen(
        (messageChunk) {
          if (messageChunk.isFromUser && isFirstUserMessage) {
            // 跳过第一个用户消息，因为我们已经在UI中显示了原始用户消息
            isFirstUserMessage = false;
            debugPrint('🔍 跳过流中的用户消息，保持显示原始内容');
            return;
          }

          // 额外保护：如果流中还有其他用户消息，也要跳过，防止替换原始用户消息
          if (messageChunk.isFromUser) {
            debugPrint('⚠️ 检测到额外的用户消息，跳过以保护原始内容');
            return;
          }

          if (!messageChunk.isFromUser) {
            fullResponse = messageChunk.content;
            final updatedMessages = state.messages.map((m) {
              return m.id == aiMessageId
                  ? m.copyWith(
                      content: fullResponse,
                      status: messageChunk.status,
                      modelName: messageChunk.modelName,
                    )
                  : m;
            }).toList();
            state = state.copyWith(
              messages: updatedMessages,
              isLoading: messageChunk.status != MessageStatus.sent,
            );

            // 如果是学习模式且AI回复完成，进行学习模式处理
            if (learningModeState.isLearningMode && messageChunk.status == MessageStatus.sent) {
              _processLearningModeResponse(fullResponse, aiMessageId);
            }
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

      // 移除占位符（按ID），添加错误消息
      final messagesWithoutPlaceholder = state.messages
          .where(
            (m) =>
                !(m.isFromUser == false && m.status == MessageStatus.sending),
          )
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

  /// 构建学习模式消息
  /// 
  /// 在学习模式下，将用户的原始问题转换为苏格拉底式教学格式，
  /// 引导AI使用提问而非直接回答的方式来帮助学生学习
  String _buildLearningModeMessage(String originalMessage, dynamic learningModeState, {bool isRegeneration = false, bool shouldGiveFinalAnswer = false}) {
    // 如果是最后一轮，直接替换为最终答案提示词
    if (shouldGiveFinalAnswer) {
      return '''你是一个专业的AI助手。学生经过学习引导后，现在需要得到完整的答案和解释。

===== 学生的问题 =====
$originalMessage

===== 重要指令 =====
学习阶段已结束，请直接给出完整答案：
1. 提供准确、详细的答案
2. 解释解题过程和思路
3. 总结关键知识点
4. 不需要再进行引导或提问

请直接回答学生的问题。''';
    }
    
    // 正常学习引导模式
    final systemPrompt = LearningPromptService.buildLearningSystemPrompt(
      style: learningModeState.style,
      responseDetail: learningModeState.responseDetail,
      questionStep: learningModeState.questionStep,
      maxSteps: learningModeState.maxQuestionSteps,
    );

    // 包装用户消息
    final wrappedMessage = LearningPromptService.wrapUserMessage(
      originalMessage,
      style: learningModeState.style,
      questionStep: learningModeState.questionStep,
      hintHistory: learningModeState.hintHistory,
    );

    // 组合系统提示词和用户消息
    final regenerationNote = isRegeneration 
        ? '\n\n===== 重新生成说明 =====\n这是对同一个问题的重新生成回应。请用不同的角度或方法来引导学生，但仍然保持苏格拉底式教学，不要直接给出答案。可以尝试：\n- 换一个引导角度\n- 提出不同类型的启发性问题\n- 使用不同的比喻或例子\n但依然要遵循学习模式的指导原则。'
        : '';
    
    return '''$systemPrompt$regenerationNote

===== 学生的问题 =====
$wrappedMessage

重要指导原则：
1. 如果学生明确要求直接答案（如说"直接告诉我答案"、"不要引导了"等），立即停止引导，直接给出完整答案。
2. 如果学生只是提问学习，使用苏格拉底式引导，不要直接给答案。
3. 你需要根据学生的话语自己判断他们的意图。''';
  }

  /// 构建学习会话消息
  /// 
  /// 在学习会话中，将用户消息包装为会话格式，
  /// 提供会话上下文和进度信息
  String _buildLearningSessionMessage(String originalMessage, dynamic learningModeState, {bool isRegeneration = false, bool shouldGiveFinalAnswer = false, bool userRequestedAnswer = false, bool reachedMaxRounds = false}) {
    final currentSession = learningModeState.currentSession;
    if (currentSession == null) {
      return _buildLearningModeMessage(originalMessage, learningModeState, isRegeneration: isRegeneration, shouldGiveFinalAnswer: shouldGiveFinalAnswer);
    }

    // 如果是最后一轮，直接替换为最终答案提示词
    if (shouldGiveFinalAnswer) {
      // 根据原因确定说明内容
      String reasonExplanation = '';
      if (reachedMaxRounds) {
        reasonExplanation = '我们已经完成了${currentSession.maxRounds}轮的学习引导，现在是时候给出完整答案了。';
      } else if (userRequestedAnswer) {
        reasonExplanation = '根据您的要求，我将直接给出完整答案。';
      } else {
        reasonExplanation = '学习会话已完成，现在给出完整答案。';
      }
      
      return '''你是一个专业的AI助手。学生经过${currentSession.currentRound}轮学习引导后，现在需要得到完整的答案。

===== 学习会话信息 =====
初始问题：${currentSession.initialQuestion}
当前进度：第${currentSession.currentRound}轮（共${currentSession.maxRounds}轮）
会话状态：学习完成

===== 学生的最新问题 =====
$originalMessage

===== 重要指令 =====
$reasonExplanation

请在回答的开头简要说明："$reasonExplanation"，然后提供完整答案：
1. 直接回答学生的初始问题：${currentSession.initialQuestion}
2. 提供完整的解题步骤和解释
3. 总结整个学习过程的关键思路
4. 解释重要概念和知识点
5. 不需要再进行任何形式的引导

请给出完整、准确的最终答案。''';
    }

    // 正常学习会话引导模式
    final systemPrompt = LearningSessionService.buildSessionSystemPrompt(
      session: currentSession,
      learningModeState: learningModeState,
    );

    // 包装用户消息
    final wrappedMessage = LearningSessionService.wrapUserMessageForSession(
      originalMessage: originalMessage,
      session: currentSession,
      learningModeState: learningModeState,
    );

    // 添加重新生成说明
    final regenerationNote = isRegeneration 
        ? '''

===== 重新生成说明 =====
这是对同一轮会话的重新生成回应。请用不同的方式来引导学生，保持学习会话的连续性：
- 尝试不同的引导策略或问题角度
- 保持当前轮次的教学目标不变
- 仍然遵循苏格拉底式引导原则
- 不要直接给出答案（除非是最后一轮）
请提供一个更好的引导性回应。'''
        : '';
    
    return '''$systemPrompt$regenerationNote

===== 用户输入 =====
$wrappedMessage

重要指导原则：
1. 如果学生明确要求直接答案，立即停止引导，直接给出完整答案。
2. 如果已达到最大轮次，应该给出完整答案。
3. 如果学生只是正常学习互动，继续苏格拉底式引导。
4. 根据学生的话语和会话进度自己判断应该引导还是给答案。''';
  }

  /// 处理学习模式下的AI回复
  /// 
  /// 在学习模式下，可以对AI的回复进行后处理，
  /// 例如添加学习提示、分析学生的理解程度等
  void _processLearningModeResponse(String aiResponse, String aiMessageId) {
    final learningModeNotifier = _ref.read(learningModeProvider.notifier);
    
    // 如果在学习会话中，先推进会话
    if (learningModeNotifier.isInLearningSession) {
      learningModeNotifier.advanceLearningSession(aiMessageId);
      
      // 获取更新后的会话状态
      final updatedLearningModeState = _ref.read(learningModeProvider);
      final currentSession = updatedLearningModeState.currentSession;
      
      // 检查是否应该结束会话（达到最大轮次或用户已要求答案）
      if (currentSession != null) {
        final shouldEnd = currentSession.currentRound >= currentSession.maxRounds ||
                         currentSession.userRequestedAnswer;
        
        if (shouldEnd) {
          // 结束学习会话
          learningModeNotifier.endCurrentSession(
            userRequested: currentSession.userRequestedAnswer,
          );
          debugPrint('🎓 学习会话已结束：${currentSession.userRequestedAnswer ? "用户要求答案" : "达到最大轮次"}');
        }
      }
    }
    
    // 如果AI回复中包含引导性内容，添加到提示历史中
    if (aiResponse.contains('让我们') || aiResponse.contains('你觉得') || aiResponse.contains('试着想想')) {
      learningModeNotifier.addToHintHistory(aiResponse.split('\n').first);
    }

    // 检查是否需要重置提问步骤（当学生得到完整理解时）
    if (aiResponse.contains('很好') || aiResponse.contains('正确') || aiResponse.contains('理解得很棒')) {
      // 可以考虑重置或调整学习进度
      debugPrint('🎓 学生理解程度良好，学习模式响应已处理');
    }
  }
}

/// 聊天状态
class ChatState {
  final List<ChatMessage> messages;
  final ChatSession? currentSession;
  final bool isLoading;
  final bool isSearching; // 新增：搜索状态
  final String? error;
  final List<ChatSession> sessions;
  final List<PlatformFile> attachedFiles;
  final List<ImageResult> attachedImages; // 新增：附加的图片
  final bool contextCleared; // 标记是否已清除上下文

  const ChatState({
    this.messages = const [],
    this.currentSession,
    this.isLoading = false,
    this.isSearching = false, // 新增
    this.error,
    this.sessions = const [],
    this.attachedFiles = const [],
    this.attachedImages = const [], // 新增
    this.contextCleared = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatSession? currentSession,
    bool? isLoading,
    bool? isSearching, // 新增
    String? error,
    List<ChatSession>? sessions,
    List<PlatformFile>? attachedFiles,
    List<ImageResult>? attachedImages, // 新增
    bool? contextCleared,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      currentSession: currentSession ?? this.currentSession,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching, // 新增
      error: error,
      sessions: sessions ?? this.sessions,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      attachedImages: attachedImages ?? this.attachedImages, // 新增
      contextCleared: contextCleared ?? this.contextCleared,
    );
  }

  @override
  String toString() {
    return 'ChatState(messages: ${messages.length}, currentSession: ${currentSession?.id}, isLoading: $isLoading, isSearching: $isSearching, error: $error, sessions: ${sessions.length})';
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

/// 聊天搜索状态Provider
final chatSearchingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isSearching;
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
