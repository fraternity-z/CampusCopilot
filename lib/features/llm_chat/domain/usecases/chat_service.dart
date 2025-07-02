import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

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

/// 聊天服务
///
/// 管理聊天会话、消息发送和AI响应生成的核心业务逻辑
class ChatService {
  final AppDatabase _database;

  ChatService(this._database);

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

      // 5. 构建上下文消息
      final contextMessages = await _buildContextMessages(
        sessionId,
        session.config,
      );

      // 6. 生成AI响应
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt,
        temperature: session.config?.temperature ?? 0.7,
        maxTokens: session.config?.maxTokens ?? 2048,
      );

      debugPrint(
        '🎯 使用模型: ${llmConfig.defaultModel} (提供商: ${llmConfig.provider})',
      );

      final result = await provider.generateChat(
        contextMessages,
        options: chatOptions,
      );

      // 7. 创建AI响应消息
      final aiMessage = ChatMessageFactory.createAIMessage(
        content: result.content,
        chatSessionId: sessionId,
        parentMessageId: userMessage.id,
        tokenCount: result.tokenUsage.totalTokens,
      ).copyWith(modelName: llmConfig.defaultModel);

      // 使用事务保证所有相关操作的原子性
      await _database.transaction(() async {
        // 8. 保存AI消息到数据库
        await _database.insertMessage(_messageToCompanion(aiMessage));

        // 9. 更新会话统计
        await _updateSessionStats(session, result.tokenUsage.totalTokens);

        // 10. 更新智能体使用统计
        await _database.updatePersonaUsage(persona.id);
      });

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

      // 5. 构建上下文消息（最近10条消息作为上下文）
      final recentMessages = await _database.getMessagesBySession(sessionId);
      final contextMessages = recentMessages
          .take(10) // 最近10条消息作为上下文
          .map(
            (msg) => ChatMessage(
              id: msg.id,
              content: msg.content,
              isFromUser: msg.isFromUser,
              timestamp: msg.timestamp,
              chatSessionId: msg.chatSessionId,
            ),
          )
          .toList();

      debugPrint('💬 上下文消息数量: ${contextMessages.length}');

      // 6. 构建聊天选项 - 使用会话配置和智能体提示词
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt, // 使用智能体的提示词
        temperature: session.config?.temperature ?? 0.7,
        maxTokens: session.config?.maxTokens ?? 2048,
        stream: true,
      );

      debugPrint(
        '🎯 使用模型: ${llmConfig.defaultModel} (提供商: ${llmConfig.provider})',
      );
      debugPrint('⚙️ 开始调用AI API');
      debugPrint(
        '📊 模型参数: 温度=${chatOptions.temperature}, 最大Token=${chatOptions.maxTokens}',
      );

      String accumulatedContent = '';
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
            final finalMessage = ChatMessageFactory.createAIMessage(
              content: accumulatedContent,
              chatSessionId: sessionId,
              parentMessageId: userMessage.id,
              tokenCount: chunk.tokenUsage?.totalTokens ?? 0,
            ).copyWith(id: aiMessageId, modelName: llmConfig.defaultModel);

            // 使用事务保证所有相关操作的原子性
            await _database.transaction(() async {
              // 保存AI消息
              await _database.insertMessage(_messageToCompanion(finalMessage));
              debugPrint('✅ AI消息已保存到数据库');

              // 更新会话统计
              await _updateSessionStats(
                session,
                chunk.tokenUsage?.totalTokens ?? 0,
              );

              // 更新智能体使用统计
              await _database.updatePersonaUsage(persona.id);
            });

            debugPrint('✅ AI消息、会话和智能体统计已在事务中原子性保存');

            yield finalMessage.copyWith(status: MessageStatus.sent);
          }
          break;
        }

        // 累积内容
        if (chunk.delta != null && chunk.delta!.isNotEmpty) {
          accumulatedContent += chunk.delta!;
        }

        // 创建或更新AI消息
        if (aiMessageId == null) {
          aiMessageId = ChatMessageFactory.createAIMessage(
            content: accumulatedContent,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
          ).id;
          debugPrint('🆔 创建AI消息ID: $aiMessageId');
        }

        yield ChatMessage(
          id: aiMessageId,
          content: accumulatedContent,
          isFromUser: false,
          timestamp: DateTime.now(),
          chatSessionId: sessionId,
          status: MessageStatus.sending,
          modelName: llmConfig.defaultModel,
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
    ChatSessionConfig? config,
  ) async {
    final contextWindowSize =
        config?.contextWindowSize ?? AppConstants.defaultContextWindowSize;

    // 获取最近的消息
    final recentMessages = await _database.getRecentMessages(
      sessionId,
      contextWindowSize,
    );

    // 按时间顺序排序
    recentMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return recentMessages.map((data) => data.toChatMessage()).toList();
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
    );
  }
}

/// 聊天服务Provider
final chatServiceProvider = Provider<ChatService>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ChatService(database);
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
    );
  }
}
