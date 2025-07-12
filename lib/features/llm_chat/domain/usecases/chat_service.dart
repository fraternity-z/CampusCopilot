import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../app/app_router.dart';

import '../entities/chat_message.dart';
import '../entities/chat_session.dart';
import '../providers/llm_provider.dart';
import '../../data/providers/llm_provider_factory.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/local/app_database.dart';
import 'dart:convert';
import '../../../persona_management/domain/entities/persona.dart';
import '../../../knowledge_base/presentation/providers/rag_provider.dart';
import '../../../knowledge_base/presentation/providers/knowledge_base_config_provider.dart';
import '../../../../data/local/tables/general_settings_table.dart';

/// 聊天服务
///
/// 管理聊天会话、消息发送和AI响应生成的核心业务逻辑
class ChatService {
  final AppDatabase _database;
  final Ref _ref;
  final String _instanceId;

  /// 会话标题更新回调
  Function(String sessionId, String newTitle)? onSessionTitleUpdated;

  ChatService(this._database, this._ref)
    : _instanceId = DateTime.now().millisecondsSinceEpoch.toString() {
    debugPrint('🏗️ ChatService实例创建: $_instanceId');
  }

  /// 创建新的聊天会话
  Future<ChatSession> createChatSession({
    required String personaId,
    String? title,
    ChatSessionConfig? config,
  }) async {
    final session = ChatSessionFactory.createNew(
      personaId: personaId,
      title: title,
      config: config,
    );

    await _database.upsertChatSession(_sessionToCompanion(session));
    return session;
  }

  /// 获取聊天会话列表
  Future<List<ChatSession>> getChatSessions({
    bool includeArchived = false,
  }) async {
    try {
      final sessionsData = includeArchived
          ? await _database.getAllChatSessions()
          : await _database.getActiveChatSessions();

      if (sessionsData.isEmpty) {
        return <ChatSession>[];
      }

      return sessionsData.map((data) => data.toChatSession()).toList();
    } catch (e) {
      // 如果数据库查询失败，返回空列表而不是抛出异常
      return <ChatSession>[];
    }
  }

  /// 获取指定会话的消息
  Future<List<ChatMessage>> getSessionMessages(String sessionId) async {
    try {
      final messagesData = await _database.getMessagesBySession(sessionId);

      if (messagesData.isEmpty) {
        return <ChatMessage>[];
      }

      return messagesData.map((data) => data.toChatMessage()).toList();
    } catch (e) {
      // 如果数据库查询失败，返回空列表
      return <ChatMessage>[];
    }
  }

  /// 发送消息并获取AI响应
  Future<ChatMessage> sendMessage({
    required String sessionId,
    required String content,
    String? parentMessageId,
  }) async {
    final String? pId = parentMessageId;
    // 1. 创建用户消息
    final userMessage = ChatMessageFactory.createUserMessage(
      content: content,
      chatSessionId: sessionId,
      parentMessageId: pId,
    );

    // 2. 保存用户消息到数据库
    await _database.insertMessage(_messageToCompanion(userMessage));

    try {
      // 3. 获取会话和智能体信息
      final session = await _getSessionById(sessionId);
      final persona = await _getPersonaById(session.personaId);
      final llmConfig = await _getLlmConfigById(persona.apiConfigId);

      // 4. 创建LLM Provider
      final provider = LlmProviderFactory.createProvider(
        llmConfig.toLlmConfig(),
      );

      // 5. 检查是否需要RAG增强
      String enhancedPrompt = content;
      final ragService = _ref.read(ragServiceProvider);
      final knowledgeConfig = _ref
          .read(knowledgeBaseConfigProvider)
          .currentConfig;

      if (knowledgeConfig != null && ragService.shouldUseRag(content)) {
        try {
          debugPrint('🔍 使用RAG增强用户查询');
          final ragResult = await ragService.enhancePrompt(
            userQuery: content,
            config: knowledgeConfig,
            systemPrompt: persona.systemPrompt,
          );

          if (ragResult.usedContexts.isNotEmpty) {
            enhancedPrompt = ragResult.enhancedPrompt;
            debugPrint('✅ RAG增强成功，使用了${ragResult.usedContexts.length}个上下文');
          } else {
            debugPrint('ℹ️ 未找到相关知识库内容，使用原始查询');
          }
        } catch (e) {
          debugPrint('⚠️ RAG增强失败，使用原始查询: $e');
        }
      }

      // 6. 构建上下文消息
      final contextMessages = await _buildContextMessages(
        sessionId,
        session.config,
        enhancedUserMessage: enhancedPrompt != content ? enhancedPrompt : null,
      );

      // 7. 生成AI响应
      final params = _ref.read(modelParametersProvider);
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt,
        temperature: session.config?.temperature ?? params.temperature,
        maxTokens: params.enableMaxTokens ? params.maxTokens.toInt() : null,
        // 思考链相关参数暂时使用默认设置
        reasoningEffort: _getReasoningEffort(llmConfig.defaultModel),
        maxReasoningTokens: 2000,
        customParams: _buildThinkingParams(llmConfig.defaultModel),
      );

      debugPrint(
        '🎯 使用模型: ${llmConfig.defaultModel} (提供商: ${llmConfig.provider})',
      );

      final result = await provider.generateChat(
        contextMessages,
        options: chatOptions,
      );

      // 7. 创建AI响应消息
      final aiMessage =
          ChatMessageFactory.createAIMessage(
            content: result.content,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
            tokenCount: result.tokenUsage.totalTokens,
          ).copyWith(
            modelName: llmConfig.defaultModel,
            thinkingContent: result.thinkingContent,
            thinkingComplete: result.thinkingContent != null,
          );

      // 使用事务保证所有相关操作的原子性
      await _database.transaction(() async {
        // 8. 保存AI消息到数据库
        await _database.insertMessage(_messageToCompanion(aiMessage));

        // 9. 更新会话统计
        await _updateSessionStats(session, result.tokenUsage.totalTokens);

        // 10. 更新智能体使用统计
        await _database.updatePersonaUsage(persona.id);
      });

      // 11. 检查是否需要自动命名话题
      _tryAutoNameTopic(sessionId, userMessage.content, aiMessage.content);

      return aiMessage;
    } catch (e) {
      // 创建错误消息
      final errorMessage = ChatMessageFactory.createErrorMessage(
        content: '抱歉，生成回复时出现错误：${e.toString()}',
        chatSessionId: sessionId,
        parentMessageId: userMessage.id,
      );

      await _database.insertMessage(_messageToCompanion(errorMessage));
      return errorMessage;
    }
  }

  /// 发送消息并获取流式AI响应
  Stream<ChatMessage> sendMessageStream({
    required String sessionId,
    required String content,
    String? parentMessageId,
    bool includeContext = true, // 是否包含历史上下文
  }) async* {
    debugPrint('🚀 开始发送消息: $content');

    final String? pId = parentMessageId;
    // 1. 创建用户消息
    final userMessage = ChatMessageFactory.createUserMessage(
      content: content,
      chatSessionId: sessionId,
      parentMessageId: pId,
    );

    // 2. 保存用户消息到数据库
    await _database.insertMessage(_messageToCompanion(userMessage));
    debugPrint('✅ 用户消息已保存');
    yield userMessage;

    try {
      // 3. 获取会话和智能体信息
      final session = await _getSessionById(sessionId);
      debugPrint('📝 会话ID: ${session.id}, 智能体ID: ${session.personaId}');

      final persona = await _getPersonaById(session.personaId);
      debugPrint('🤖 智能体: ${persona.name}, 提示词: ${persona.systemPrompt}');

      final llmConfig = await _getLlmConfigById(persona.apiConfigId);
      debugPrint('🔧 LLM配置: ${llmConfig.name} (${llmConfig.provider})');

      // 4. 创建LLM Provider
      final provider = LlmProviderFactory.createProvider(
        llmConfig.toLlmConfig(),
      );
      debugPrint('🤖 AI Provider已创建');

      // 5. 检查是否需要RAG增强
      String enhancedPrompt = content;
      final ragService = _ref.read(ragServiceProvider);
      final knowledgeConfig = _ref
          .read(knowledgeBaseConfigProvider)
          .currentConfig;

      if (knowledgeConfig != null && ragService.shouldUseRag(content)) {
        try {
          debugPrint('🔍 使用RAG增强用户查询');
          final ragResult = await ragService.enhancePrompt(
            userQuery: content,
            config: knowledgeConfig,
            systemPrompt: persona.systemPrompt,
          );

          if (ragResult.usedContexts.isNotEmpty) {
            enhancedPrompt = ragResult.enhancedPrompt;
            debugPrint('✅ RAG增强成功，使用了${ragResult.usedContexts.length}个上下文');
          } else {
            debugPrint('ℹ️ 未找到相关知识库内容，使用原始查询');
          }
        } catch (e) {
          debugPrint('⚠️ RAG增强失败，使用原始查询: $e');
        }
      }

      // 6. 构建上下文消息
      final contextMessages = includeContext
          ? await _buildContextMessages(
              sessionId,
              session.config,
              enhancedUserMessage: enhancedPrompt != content
                  ? enhancedPrompt
                  : null,
            )
          : [
              // 如果不包含上下文，只使用当前用户消息
              ChatMessageFactory.createUserMessage(
                content: enhancedPrompt,
                chatSessionId: sessionId,
                parentMessageId: parentMessageId,
              ),
            ];

      debugPrint('💬 上下文消息数量: ${contextMessages.length}');

      // 7. 构建聊天选项 - 使用会话配置和智能体提示词
      final params = _ref.read(modelParametersProvider);
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt, // 使用智能体的提示词
        temperature: session.config?.temperature ?? params.temperature,
        maxTokens: params.enableMaxTokens ? params.maxTokens.toInt() : null,
        stream: true,
        // 思考链相关参数
        reasoningEffort: _getReasoningEffort(llmConfig.defaultModel),
        maxReasoningTokens: 2000,
        customParams: _buildThinkingParams(llmConfig.defaultModel),
      );

      debugPrint(
        '🎯 使用模型: ${llmConfig.defaultModel} (提供商: ${llmConfig.provider})',
      );
      debugPrint('⚙️ 开始调用AI API');
      debugPrint(
        '📊 模型参数: 温度=${chatOptions.temperature}, 最大Token=${chatOptions.maxTokens}',
      );

      String accumulatedRawContent = ''; // 完整原始内容
      String accumulatedThinking = ''; // 思考链内容
      String accumulatedActualContent = ''; // 正文内容
      bool isInThinkingMode = false; // 当前是否在思考模式
      String partialTag = ''; // 处理跨块的标签
      String? aiMessageId;

      await for (final chunk in provider.generateChatStream(
        contextMessages,
        options: chatOptions,
      )) {
        debugPrint(
          '📦 收到AI响应块: isDone=${chunk.isDone}, delta长度=${chunk.delta?.length ?? 0}',
        );

        if (chunk.isDone) {
          // 流结束，保存最终消息到数据库
          if (aiMessageId != null) {
            final finalMessage =
                ChatMessageFactory.createAIMessage(
                  content: accumulatedRawContent, // 保存完整原始内容
                  chatSessionId: sessionId,
                  parentMessageId: userMessage.id,
                  tokenCount: chunk.tokenUsage?.totalTokens ?? 0,
                ).copyWith(
                  id: aiMessageId,
                  modelName: llmConfig.defaultModel,
                  thinkingContent: accumulatedThinking.isNotEmpty
                      ? accumulatedThinking
                      : null,
                  thinkingComplete: true,
                );

            // 使用事务保证所有相关操作的原子性
            await _database.transaction(() async {
              // 保存AI消息
              await _database.insertMessage(_messageToCompanion(finalMessage));
              debugPrint(
                '✅ AI消息已保存到数据库 (原始: $accumulatedRawContent.length, 思考: $accumulatedThinking.length, 正文: $accumulatedActualContent.length)',
              );

              // 更新会话统计
              await _updateSessionStats(
                session,
                chunk.tokenUsage?.totalTokens ?? 0,
              );

              // 更新智能体使用统计
              await _database.updatePersonaUsage(persona.id);
            });

            debugPrint('✅ AI消息、会话和智能体统计已在事务中原子性保存');

            // 检查是否需要自动命名话题
            _tryAutoNameTopic(
              sessionId,
              userMessage.content,
              finalMessage.content,
            );

            yield finalMessage.copyWith(status: MessageStatus.sent);
          }
          break;
        }

        // 处理内容增量
        if (chunk.delta != null && chunk.delta!.isNotEmpty) {
          String deltaText = chunk.delta!;
          accumulatedRawContent += deltaText;

          // 调试：输出原始增量内容
          debugPrint('🔍 原始增量 ($deltaText.length字符): "$deltaText"');
          debugPrint('🔄 当前思考模式: $isInThinkingMode, 部分标签: "$partialTag"');

          // 检查是否包含任何可能的思考链标签
          if (deltaText.contains('<') ||
              deltaText.contains('>') ||
              deltaText.contains('think')) {
            debugPrint('⚠️ 发现可能的标签内容: $deltaText');
          }

          // 检查是否包含其他可能的思考标记
          if (deltaText.contains('思考') ||
              deltaText.contains('thinking') ||
              deltaText.contains('reason')) {
            debugPrint('🧠 发现思考相关关键词: $deltaText');
          }

          // 处理可能跨块的标签
          deltaText = partialTag + deltaText;
          partialTag = '';

          // 处理思考链状态切换
          final processed = _processThinkingTags(deltaText, isInThinkingMode);

          isInThinkingMode = processed['isInThinkingMode'] as bool;
          final thinkingDelta = processed['thinkingDelta'] as String?;
          final contentDelta = processed['contentDelta'] as String?;
          partialTag = processed['partialTag'] as String;

          debugPrint(
            '✅ 处理结果: 思考模式=$isInThinkingMode, 思考增量=${thinkingDelta?.length ?? 0}, 正文增量=${contentDelta?.length ?? 0}, 部分标签="$partialTag"',
          );

          // 累积思考链内容
          if (thinkingDelta != null && thinkingDelta.isNotEmpty) {
            accumulatedThinking += thinkingDelta;
            debugPrint(
              '🧠 思考链增量: $thinkingDelta.length 字符, 总长度: $accumulatedThinking.length',
            );
          }

          // 累积正文内容
          if (contentDelta != null && contentDelta.isNotEmpty) {
            accumulatedActualContent += contentDelta;
            debugPrint(
              '📝 正文增量: $contentDelta.length 字符, 总长度: $accumulatedActualContent.length',
            );
          }
        }

        // 创建或更新AI消息
        if (aiMessageId == null) {
          aiMessageId = ChatMessageFactory.createAIMessage(
            content: accumulatedRawContent,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
          ).id;
          debugPrint('🆔 创建AI消息ID: $aiMessageId');
        }

        yield ChatMessage(
          id: aiMessageId,
          content: accumulatedRawContent, // 保存完整原始内容
          isFromUser: false,
          timestamp: DateTime.now(),
          chatSessionId: sessionId,
          status: MessageStatus.sending,
          modelName: llmConfig.defaultModel,
          thinkingContent: accumulatedThinking.isNotEmpty
              ? accumulatedThinking
              : null,
          thinkingComplete: false, // 流式过程中始终为false
        );
      }
    } catch (e) {
      debugPrint('❌ 发送消息时出错: $e');
      debugPrint('❌ 错误堆栈: ${StackTrace.current}');

      // 创建错误消息
      final errorMessage = ChatMessageFactory.createErrorMessage(
        content: '抱歉，生成回复时出现错误：${e.toString()}',
        chatSessionId: sessionId,
        parentMessageId: userMessage.id,
      );

      await _database.insertMessage(_messageToCompanion(errorMessage));
      yield errorMessage;
    }
  }

  /// 删除聊天会话
  Future<void> deleteChatSession(String sessionId) async {
    await _database.deleteChatSession(sessionId);
  }

  /// 归档聊天会话
  Future<void> archiveChatSession(String sessionId) async {
    final session = await _getSessionById(sessionId);
    final archivedSession = session.archive();
    await _database.upsertChatSession(_sessionToCompanion(archivedSession));
  }

  /// 更新会话标题
  Future<void> updateSessionTitle(String sessionId, String title) async {
    final session = await _getSessionById(sessionId);
    final updatedSession = session.updateTitle(title);
    await _database.upsertChatSession(_sessionToCompanion(updatedSession));
  }

  /// 构建上下文消息
  Future<List<ChatMessage>> _buildContextMessages(
    String sessionId,
    ChatSessionConfig? config, {
    String? enhancedUserMessage,
  }) async {
    final contextWindowSize =
        config?.contextWindowSize ?? AppConstants.defaultContextWindowSize;

    // 获取最近的消息
    final recentMessages = await _database.getRecentMessages(
      sessionId,
      contextWindowSize,
    );

    // 按时间顺序排序
    recentMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final contextMessages = recentMessages
        .map((data) => data.toChatMessage())
        .toList();

    // 如果有RAG增强的消息，替换最后一条用户消息
    if (enhancedUserMessage != null && contextMessages.isNotEmpty) {
      final lastMessage = contextMessages.last;
      if (lastMessage.isFromUser) {
        contextMessages[contextMessages.length - 1] = lastMessage.copyWith(
          content: enhancedUserMessage,
        );
      }
    }

    return contextMessages;
  }

  /// 更新会话统计
  Future<void> _updateSessionStats(ChatSession session, int tokenCount) async {
    final updatedSession = session.incrementMessageCount().addTokenUsage(
      tokenCount,
    );
    await _database.upsertChatSession(_sessionToCompanion(updatedSession));
  }

  /// 获取会话信息
  Future<ChatSession> _getSessionById(String sessionId) async {
    final sessionData = await _database.getChatSessionById(sessionId);
    if (sessionData == null) {
      throw DatabaseException('聊天会话不存在: $sessionId');
    }
    return sessionData.toChatSession();
  }

  /// 获取智能体信息
  Future<Persona> _getPersonaById(String personaId) async {
    final personaData = await _database.getPersonaById(personaId);
    if (personaData == null) {
      debugPrint('⚠️ 智能体不存在: $personaId, 使用默认智能体');
      // 返回一个默认的或备用的Persona
      final defaultPersona = Persona.defaultPersona();
      await _database.upsertPersona(defaultPersona.toCompanion());
      return defaultPersona;
    }
    return personaData.toPersona();
  }

  /// 获取LLM配置信息
  Future<LlmConfigsTableData> _getLlmConfigById(String? configId) async {
    LlmConfigsTableData? configData;

    // 如果提供了配置ID，则尝试按ID获取
    if (configId != null && configId.isNotEmpty) {
      configData = await _database.getLlmConfigById(configId);
    }

    // 如果未找到或未提供ID，则回退到第一个可用配置
    if (configData == null) {
      debugPrint('⚠️ LLM配置不存在或未提供: $configId, 尝试寻找第一个可用配置');
      final firstConfig = await _database.getFirstLlmConfig();
      if (firstConfig == null) {
        throw DatabaseException('没有可用的LLM配置');
      }
      debugPrint('✅ 使用第一个可用LLM配置: ${firstConfig.name}');
      return firstConfig;
    }

    return configData;
  }

  /// 转换ChatSession到Companion
  ChatSessionsTableCompanion _sessionToCompanion(ChatSession session) {
    return ChatSessionsTableCompanion.insert(
      id: session.id,
      title: session.title,
      personaId: session.personaId,
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
      isArchived: Value(session.isArchived),
      isPinned: Value(session.isPinned),
      tags: Value(jsonEncode(session.tags)),
      messageCount: Value(session.messageCount),
      totalTokens: Value(session.totalTokens),
      config: session.config != null
          ? Value(jsonEncode(session.config))
          : const Value.absent(),
      metadata: session.metadata != null
          ? Value(jsonEncode(session.metadata))
          : const Value.absent(),
    );
  }

  /// 转换ChatMessage到Companion
  ChatMessagesTableCompanion _messageToCompanion(ChatMessage message) {
    return ChatMessagesTableCompanion.insert(
      id: message.id,
      content: message.content,
      isFromUser: message.isFromUser,
      timestamp: message.timestamp,
      chatSessionId: message.chatSessionId,
      type: Value(message.type.name),
      status: Value(message.status.name),
      metadata: message.metadata != null
          ? Value(jsonEncode(message.metadata))
          : const Value.absent(),
      parentMessageId: message.parentMessageId != null
          ? Value(message.parentMessageId!)
          : const Value.absent(),
      tokenCount: message.tokenCount != null
          ? Value(message.tokenCount!)
          : const Value.absent(),
      thinkingContent: message.thinkingContent != null
          ? Value(message.thinkingContent!)
          : const Value.absent(),
      thinkingComplete: Value(message.thinkingComplete),
      modelName: message.modelName != null
          ? Value(message.modelName!)
          : const Value.absent(),
    );
  }

  /// 获取思考努力程度
  String? _getReasoningEffort(String? model) {
    if (model == null) return null;

    // 检查是否为思考模型
    final thinkingModels = {
      'o1',
      'o1-preview',
      'o1-mini',
      'o3',
      'o3-mini',
      'deepseek-reasoner',
      'deepseek-r1',
    };

    final isThinkingModel = thinkingModels.any(
      (thinking) => model.toLowerCase().contains(thinking.toLowerCase()),
    );

    return isThinkingModel ? 'medium' : null;
  }

  /// 构建思考链参数
  Map<String, dynamic>? _buildThinkingParams(String? model) {
    if (model == null) return null;

    final params = <String, dynamic>{};

    // OpenAI o系列模型
    if (model.toLowerCase().contains('o1') ||
        model.toLowerCase().contains('o3')) {
      params['reasoning_effort'] = 'medium';
    }

    // Gemini思考模型
    if (model.toLowerCase().contains('gemini') &&
        model.toLowerCase().contains('thinking')) {
      params['max_tokens_for_reasoning'] = 2000;
    }

    // DeepSeek思考模型
    if (model.toLowerCase().contains('deepseek') &&
        (model.toLowerCase().contains('reasoner') ||
            model.toLowerCase().contains('r1'))) {
      // DeepSeek R1可能需要特殊参数
      params['enable_reasoning'] = true;
    }

    return params.isNotEmpty ? params : null;
  }

  /// 处理思考链标签，实现流式状态管理
  Map<String, dynamic> _processThinkingTags(
    String text,
    bool currentThinkingMode,
  ) {
    bool isInThinkingMode = currentThinkingMode;
    String thinkingDelta = '';
    String contentDelta = '';
    String partialTag = '';

    debugPrint('🔧 处理文本 (${text.length}字符): "$text"');
    debugPrint('🔧 初始思考模式: $currentThinkingMode');

    // 先简单处理：如果发现完整的标签，就分离内容
    if (text.contains('<think>') && text.contains('</think>')) {
      debugPrint('🎯 发现完整的思考链标签对');
      final thinkStart = text.indexOf('<think>');
      final thinkEnd = text.indexOf('</think>');

      if (thinkStart != -1 && thinkEnd != -1 && thinkEnd > thinkStart) {
        // 分离三部分：开始前、思考链、结束后
        final beforeThink = text.substring(0, thinkStart);
        final thinkingContent = text.substring(thinkStart + 7, thinkEnd);
        final afterThink = text.substring(thinkEnd + 8);

        debugPrint('📝 开始前内容: "$beforeThink"');
        debugPrint('🧠 思考链内容: "$thinkingContent"');
        debugPrint('📝 结束后内容: "$afterThink"');

        contentDelta = beforeThink + afterThink;
        thinkingDelta = thinkingContent;
        isInThinkingMode = false; // 完整标签处理后回到正文模式
      }
    } else {
      // 如果没有完整标签，就全部当作当前模式的内容
      if (isInThinkingMode) {
        thinkingDelta = text;
      } else {
        contentDelta = text;
      }

      // 检查状态切换
      if (text.contains('<think>')) {
        debugPrint('🟢 发现开始标签');
        isInThinkingMode = true;
      }
      if (text.contains('</think>')) {
        debugPrint('🔴 发现结束标签');
        isInThinkingMode = false;
      }
    }

    debugPrint(
      '🔧 处理完成: 思考=${thinkingDelta.length}, 正文=${contentDelta.length}, 模式=$isInThinkingMode',
    );

    return {
      'isInThinkingMode': isInThinkingMode,
      'thinkingDelta': thinkingDelta.isNotEmpty ? thinkingDelta : null,
      'contentDelta': contentDelta.isNotEmpty ? contentDelta : null,
      'partialTag': partialTag,
    };
  }

  /// 尝试自动命名话题
  void _tryAutoNameTopic(
    String sessionId,
    String userContent,
    String aiContent,
  ) {
    // 在后台异步执行，不阻塞主流程
    Future.microtask(() async {
      try {
        debugPrint('🏷️ 开始检查自动命名话题条件...');

        // 检查是否启用了自动命名功能
        final autoNamingEnabled = await _database.getSetting(
          GeneralSettingsKeys.autoTopicNamingEnabled,
        );
        debugPrint('🏷️ 自动命名功能启用状态: $autoNamingEnabled');
        if (autoNamingEnabled != 'true') {
          debugPrint('🏷️ 自动命名功能未启用，跳过');
          return;
        }

        // 获取命名模型ID
        final modelId = await _database.getSetting(
          GeneralSettingsKeys.autoTopicNamingModelId,
        );
        debugPrint('🏷️ 配置的命名模型ID: $modelId');
        if (modelId == null || modelId.isEmpty) {
          debugPrint('🏷️ 未配置命名模型，跳过');
          return;
        }

        // 检查会话是否已经被命名过
        final session = await _getSessionById(sessionId);
        debugPrint('🏷️ 当前会话标题: ${session.title}');
        if (session.title != '新对话') {
          debugPrint('🏷️ 会话已被命名，跳过');
          return;
        }

        // 检查是否是第一次对话（只有一条用户消息和一条AI回复）
        final messages = await getSessionMessages(sessionId);
        debugPrint('🏷️ 会话消息数量: ${messages.length}');
        if (messages.length != 2) {
          debugPrint('🏷️ 不是第一次对话，跳过');
          return;
        }

        // 获取命名模型信息
        final customModel = await _database.getCustomModelById(modelId);
        debugPrint('🏷️ 找到的自定义模型: ${customModel?.name}');
        if (customModel == null || !customModel.isEnabled) {
          debugPrint('🏷️ 自定义模型不存在或未启用，跳过');
          return;
        }

        // 获取对应的LLM配置
        final configId = customModel.configId ?? '';
        debugPrint('🏷️ 模型关联的配置ID: $configId');
        final modelConfig = await _database.getLlmConfigById(configId);
        debugPrint('🏷️ 找到的LLM配置: ${modelConfig?.name}');
        if (modelConfig == null || !modelConfig.isEnabled) {
          debugPrint('🏷️ LLM配置不存在或未启用，跳过');
          return;
        }

        // 创建命名提示词
        final namingPrompt = _buildTopicNamingPrompt(userContent, aiContent);
        debugPrint('🏷️ 生成的命名提示词长度: ${namingPrompt.length}');

        // 创建LLM Provider
        debugPrint('🏷️ 创建LLM Provider，使用模型: ${customModel.modelId}');
        final provider = LlmProviderFactory.createProvider(
          modelConfig.toLlmConfig(),
        );

        // 生成话题名称
        debugPrint('🏷️ 开始调用AI生成话题名称...');
        final result = await provider.generateChat(
          [
            ChatMessage(
              id: 'naming-prompt',
              content: namingPrompt,
              isFromUser: true,
              timestamp: DateTime.now(),
              chatSessionId: sessionId,
            ),
          ],
          options: ChatOptions(
            model: customModel.modelId, // 使用自定义模型的modelId
            systemPrompt: '你是一个专业的话题命名助手。请根据对话内容生成简洁、准确的话题标题。',
            temperature: 0.3, // 使用较低的温度以获得更稳定的结果
            maxTokens: 50, // 限制输出长度
          ),
        );

        // 清理生成的标题
        String topicTitle = result.content.trim();
        debugPrint('🏷️ AI生成的原始标题: "$topicTitle"');
        topicTitle = _cleanTopicTitle(topicTitle);
        debugPrint('🏷️ 清理后的标题: "$topicTitle"');

        // 更新会话标题
        if (topicTitle.isNotEmpty && topicTitle != '新对话') {
          // 使用update语句只更新标题和更新时间
          await (_database.update(
            _database.chatSessionsTable,
          )..where((t) => t.id.equals(sessionId))).write(
            ChatSessionsTableCompanion(
              title: Value(topicTitle),
              updatedAt: Value(DateTime.now()),
            ),
          );
          debugPrint('✅ 自动命名话题成功: $topicTitle');

          // 通知状态管理器更新UI
          debugPrint('🔗 ChatService($_instanceId): 调用标题更新回调');
          onSessionTitleUpdated?.call(sessionId, topicTitle);
        } else {
          debugPrint('⚠️ 生成的标题为空或无效，跳过更新');
        }
      } catch (e) {
        // 静默处理错误，不影响正常对话流程
        debugPrint('⚠️ 自动命名话题失败: $e');
      }
    });
  }

  /// 构建话题命名提示词
  String _buildTopicNamingPrompt(String userContent, String aiContent) {
    return '''请根据以下对话内容，生成一个简洁的话题标题（10字以内）：

用户：$userContent

助手：$aiContent

要求：
1. 标题要简洁明了，能概括对话主题
2. 不要包含引号、冒号等标点符号
3. 直接输出标题，不要其他内容''';
  }

  /// 清理话题标题
  String _cleanTopicTitle(String title) {
    // 移除常见的引号和标点
    title = title.replaceAll(
      RegExp(
        r'["""'
        '「」『』【】《》〈〉（）()[]{}]',
      ),
      '',
    );
    title = title.replaceAll(RegExp(r'^[：:\-\s]+'), '');
    title = title.replaceAll(RegExp(r'[：:\-\s]+$'), '');

    // 限制长度
    if (title.length > 20) {
      title = title.substring(0, 20);
    }

    return title.trim();
  }
}

/// 聊天服务Provider（单例）
final chatServiceProvider = Provider<ChatService>((ref) {
  final database = ref.read(appDatabaseProvider);
  final service = ChatService(database, ref);

  // 确保服务实例在Provider生命周期内保持一致
  ref.onDispose(() {
    // 清理回调
    service.onSessionTitleUpdated = null;
  });

  return service;
});

// 扩展方法，用于数据转换
extension ChatSessionDataExtension on ChatSessionsTableData {
  ChatSession toChatSession() {
    try {
      return ChatSession(
        id: id,
        title: title,
        personaId: personaId,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isArchived: isArchived,
        isPinned: isPinned,
        tags: _parseTags(tags),
        messageCount: messageCount,
        totalTokens: totalTokens,
        config: _parseConfig(config),
        metadata: _parseMetadata(metadata),
      );
    } catch (e, stackTrace) {
      // 详细记录解析失败的错误信息，便于调试
      debugPrint('❌ Failed to parse ChatSessionData: $id');
      debugPrint('❌ Error: $e');
      debugPrint('❌ StackTrace: $stackTrace');
      debugPrint(
        '❌ Raw data - title: $title, personaId: $personaId, config: $config',
      );

      // 如果解析失败，返回一个基本的ChatSession
      return ChatSession(
        id: id,
        title: title.isNotEmpty ? title : '无标题会话',
        personaId: personaId.isNotEmpty ? personaId : 'default',
        createdAt: createdAt,
        updatedAt: updatedAt,
        isArchived: isArchived,
        isPinned: isPinned,
        tags: [],
        messageCount: messageCount,
        totalTokens: totalTokens,
      );
    }
  }

  List<String> _parseTags(String tagsJson) {
    try {
      if (tagsJson.isEmpty) return [];
      final decoded = jsonDecode(tagsJson);
      if (decoded is List) {
        return List<String>.from(decoded);
      }
      return [];
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to parse tags JSON: $tagsJson');
      debugPrint('❌ Error: $e, StackTrace: $stackTrace');
      return [];
    }
  }

  ChatSessionConfig? _parseConfig(String? configJson) {
    try {
      if (configJson?.isNotEmpty == true) {
        final decoded = jsonDecode(configJson!);
        if (decoded is Map<String, dynamic>) {
          return ChatSessionConfig.fromJson(decoded);
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to parse config JSON: $configJson');
      debugPrint('❌ Error: $e, StackTrace: $stackTrace');
      return null;
    }
  }

  Map<String, dynamic>? _parseMetadata(String? metadataJson) {
    try {
      if (metadataJson?.isNotEmpty == true) {
        final decoded = jsonDecode(metadataJson!);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to parse metadata JSON: $metadataJson');
      debugPrint('❌ Error: $e, StackTrace: $stackTrace');
      return null;
    }
  }
}

extension ChatMessageDataExtension on ChatMessagesTableData {
  ChatMessage toChatMessage() {
    return ChatMessage(
      id: id,
      content: content,
      isFromUser: isFromUser,
      timestamp: timestamp,
      chatSessionId: chatSessionId,
      type: MessageType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => MessageStatus.sent,
      ),
      metadata: metadata?.isNotEmpty == true ? jsonDecode(metadata!) : null,
      parentMessageId: parentMessageId,
      tokenCount: tokenCount,
      thinkingContent: thinkingContent,
      thinkingComplete: thinkingComplete,
      modelName: modelName,
    );
  }
}

extension LlmConfigDataExtension on LlmConfigsTableData {
  LlmConfig toLlmConfig() {
    return LlmConfig(
      id: id,
      name: name,
      provider: provider,
      apiKey: apiKey,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      defaultEmbeddingModel: defaultEmbeddingModel,
      organizationId: organizationId,
      projectId: projectId,
      extraParams: extraParams?.isNotEmpty == true
          ? jsonDecode(extraParams!)
          : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isEnabled: isEnabled,
      isCustomProvider: isCustomProvider,
      apiCompatibilityType: apiCompatibilityType,
      customProviderName: customProviderName,
      customProviderDescription: customProviderDescription,
      customProviderIcon: customProviderIcon,
    );
  }
}
