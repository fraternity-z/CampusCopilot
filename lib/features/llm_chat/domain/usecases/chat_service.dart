import 'dart:async';

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
    // 1. 创建用户消息
    final userMessage = ChatMessageFactory.createUserMessage(
      content: content,
      chatSessionId: sessionId,
      parentMessageId: parentMessageId,
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
      );

      // 8. 保存AI消息到数据库
      await _database.insertMessage(_messageToCompanion(aiMessage));

      // 9. 更新会话统计
      await _updateSessionStats(sessionId, result.tokenUsage.totalTokens);

      // 10. 更新智能体使用统计
      await _database.updatePersonaUsage(persona.id);

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
    // 1. 创建用户消息
    final userMessage = ChatMessageFactory.createUserMessage(
      content: content,
      chatSessionId: sessionId,
      parentMessageId: parentMessageId,
    );

    // 2. 保存用户消息到数据库
    await _database.insertMessage(_messageToCompanion(userMessage));
    yield userMessage;

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

      // 6. 生成流式AI响应
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt,
        temperature: session.config?.temperature ?? 0.7,
        maxTokens: session.config?.maxTokens ?? 2048,
        stream: true,
      );

      String accumulatedContent = '';
      String? aiMessageId;

      await for (final chunk in provider.generateChatStream(
        contextMessages,
        options: chatOptions,
      )) {
        if (chunk.delta != null && chunk.delta!.isNotEmpty) {
          accumulatedContent += chunk.delta!;

          // 创建或更新AI消息
          final aiMessage = ChatMessageFactory.createAIMessage(
            content: accumulatedContent,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
            tokenCount: chunk.tokenUsage?.totalTokens,
          );

          if (aiMessageId == null) {
            // 首次创建消息
            aiMessageId = aiMessage.id;
            await _database.insertMessage(_messageToCompanion(aiMessage));
          } else {
            // 更新现有消息
            await _database.updateMessageStatus(
              aiMessageId,
              aiMessage.status.name,
            );
          }

          yield aiMessage;
        }

        if (chunk.isDone && chunk.tokenUsage != null) {
          // 更新会话统计
          await _updateSessionStats(sessionId, chunk.tokenUsage!.totalTokens);

          // 更新智能体使用统计
          await _database.updatePersonaUsage(persona.id);
        }
      }
    } catch (e) {
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
  Future<void> _updateSessionStats(String sessionId, int tokenCount) async {
    final session = await _getSessionById(sessionId);
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
  Future<PersonasTableData> _getPersonaById(String personaId) async {
    final personaData = await _database.getPersonaById(personaId);
    if (personaData == null) {
      throw DatabaseException('智能体不存在: $personaId');
    }
    return personaData;
  }

  /// 获取LLM配置信息
  Future<LlmConfigsTableData> _getLlmConfigById(String configId) async {
    final configData = await _database.getLlmConfigById(configId);
    if (configData == null) {
      throw DatabaseException('LLM配置不存在: $configId');
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
      config: Value(session.config != null ? jsonEncode(session.config) : null),
      metadata: Value(
        session.metadata != null ? jsonEncode(session.metadata) : null,
      ),
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
      metadata: Value(
        message.metadata != null ? jsonEncode(message.metadata) : null,
      ),
      parentMessageId: Value(message.parentMessageId),
      tokenCount: Value(message.tokenCount),
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
