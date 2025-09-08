import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../app/app_router.dart';

import '../entities/chat_message.dart';
import '../entities/chat_session.dart';
import '../providers/llm_provider.dart';
import '../entities/model_capabilities.dart';
import '../../data/providers/llm_provider_factory.dart';

import '../utils/model_capability_checker.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../core/exceptions/app_exceptions.dart';

import '../../../../data/local/app_database.dart';
import 'dart:convert';
import '../../../persona_management/domain/entities/persona.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../../data/local/tables/general_settings_table.dart';
import '../../../knowledge_base/domain/services/rag_service.dart';
import '../../../knowledge_base/domain/services/enhanced_rag_service.dart';
import '../../../knowledge_base/presentation/providers/rag_provider.dart';

// 知识库相关导入
import '../../../knowledge_base/presentation/providers/knowledge_base_config_provider.dart';
import '../../../knowledge_base/presentation/providers/multi_knowledge_base_provider.dart';
import '../../../knowledge_base/domain/entities/knowledge_document.dart';

// 搜索相关导入
import '../../presentation/providers/search_providers.dart';
import '../../../settings/domain/entities/search_config.dart';

// 学习模式相关导入
import '../../../learning_mode/data/providers/learning_mode_provider.dart';

// AI工具函数相关导入
import '../tools/daily_management_tools.dart';
import '../../presentation/providers/ai_plan_bridge_provider.dart';


/// 聊天服务
///
/// 管理聊天会话、消息发送和AI响应生成的核心业务逻辑
class ChatService {
  final AppDatabase _database;
  final Ref _ref;
  final String _instanceId;


  /// 会话标题更新回调
  Function(String sessionId, String newTitle)? onSessionTitleUpdated;

  /// 搜索状态变化回调
  Function(bool isSearching)? onSearchStatusChanged;

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

      // 使用统一RAG服务（优先使用增强版，失败时自动回退到传统版）
      final ragService = await _ref.read(unifiedRagServiceProvider.future);

      // 检查RAG开关是否启用
      final settingsState = _ref.read(settingsProvider);
      final ragEnabled = settingsState.chatSettings.enableRag;

      // 确保配置已加载完成
      final knowledgeConfigState = _ref.read(knowledgeBaseConfigProvider);
      var knowledgeConfig = knowledgeConfigState.currentConfig;

      // 如果RAG启用但配置未加载完成，尝试等待或使用兜底配置
      if (ragEnabled && knowledgeConfig == null) {
        debugPrint('⏳ 知识库配置未就绪，尝试加载...');
        try {
          // 强制重新加载配置
          await _ref.read(knowledgeBaseConfigProvider.notifier).reload();
          knowledgeConfig = _ref
              .read(knowledgeBaseConfigProvider)
              .currentConfig;

          // 如果仍然没有配置，尝试从数据库直接获取兜底配置
          if (knowledgeConfig == null) {
            final database = _ref.read(appDatabaseProvider);
            final configs = await database.getAllKnowledgeBaseConfigs();
            if (configs.isNotEmpty) {
              final dbConfig = configs.first;
              // 转换为 KnowledgeBaseConfig 类型
              knowledgeConfig = KnowledgeBaseConfig(
                id: dbConfig.id,
                name: dbConfig.name,
                embeddingModelId: dbConfig.embeddingModelId,
                embeddingModelName: dbConfig.embeddingModelName,
                embeddingModelProvider: dbConfig.embeddingModelProvider,
                chunkSize: dbConfig.chunkSize,
                chunkOverlap: dbConfig.chunkOverlap,
                maxRetrievedChunks: dbConfig.maxRetrievedChunks,
                similarityThreshold: dbConfig.similarityThreshold,
                isDefault: dbConfig.isDefault,
                createdAt: dbConfig.createdAt,
                updatedAt: dbConfig.updatedAt,
              );
              debugPrint('🔄 使用兜底配置: ${knowledgeConfig.name}');
            }
          }
        } catch (e) {
          debugPrint('❌ 加载知识库配置失败: $e');
        }
      }

      // 获取当前选中的知识库
      var currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;

      // 如果没有选中的知识库，尝试重新加载并选择默认知识库
      if (ragEnabled && currentKnowledgeBase == null) {
        debugPrint('⏳ 没有选中的知识库，尝试加载...');
        try {
          await _ref.read(multiKnowledgeBaseProvider.notifier).reload();
          currentKnowledgeBase = _ref
              .read(multiKnowledgeBaseProvider)
              .currentKnowledgeBase;

          if (currentKnowledgeBase != null) {
            debugPrint('🔄 已自动选择知识库: ${currentKnowledgeBase.name}');
          }
        } catch (e) {
          debugPrint('❌ 加载知识库失败: $e');
        }
      }

      debugPrint('🔧 RAG状态检查:');
      debugPrint('  - RAG开关: ${ragEnabled ? "启用" : "禁用"}');
      debugPrint('  - 知识库配置: ${knowledgeConfig != null ? "存在" : "不存在"}');
      debugPrint('  - 当前知识库: ${currentKnowledgeBase?.name ?? "未选择"}');
      if (knowledgeConfig != null) {
        debugPrint('  - 配置名称: ${knowledgeConfig.name}');
        debugPrint('  - 嵌入模型: ${knowledgeConfig.embeddingModelName}');
      }
      debugPrint('  - 查询内容: "$content"');

      // 判断是否需要RAG增强（兼容新旧版本）
      bool shouldUseRag = false;
      if (ragService is RagService) {
        shouldUseRag = ragService.shouldUseRag(content);
      } else {
        // 对于EnhancedRagService，使用简化的判断逻辑
        shouldUseRag =
            content.trim().length > 3 &&
            ![
              'hi',
              'hello',
              '你好',
              '嗨',
              'hey',
              '哈喽',
            ].contains(content.trim().toLowerCase());
      }

      if (ragEnabled &&
          knowledgeConfig != null &&
          currentKnowledgeBase != null &&
          shouldUseRag) {
        try {
          debugPrint('🔍 使用RAG增强用户查询');
          debugPrint(
            '📊 知识库: ${currentKnowledgeBase.name} (${currentKnowledgeBase.id})',
          );
          debugPrint(
            '⚙️ 配置: ${knowledgeConfig.name} - ${knowledgeConfig.embeddingModelName}',
          );

          if (ragService is RagService) {
            // 使用传统RAG服务（整体超时兜底，避免拖慢首响应）
            final ragResult = await ragService
                .enhancePrompt(
                  userQuery: content,
                  config: knowledgeConfig,
                  knowledgeBaseId: currentKnowledgeBase.id,
                  similarityThreshold:
                      knowledgeConfig.similarityThreshold, // 使用配置中的相似度阈值
                )
                .timeout(const Duration(seconds: 2));

            if (ragResult.usedContexts.isNotEmpty) {
              enhancedPrompt = ragResult.enhancedPrompt;
              debugPrint('✅ 传统RAG增强成功，使用了${ragResult.usedContexts.length}个上下文');
              debugPrint('📝 增强后的提示词长度: ${enhancedPrompt.length}');

              // 显示使用的上下文相似度信息
              for (int i = 0; i < ragResult.usedContexts.length; i++) {
                final context = ragResult.usedContexts[i];
                debugPrint(
                  '📄 上下文${i + 1}: 相似度=${context.similarity.toStringAsFixed(3)}, 长度=${context.content.length}',
                );
              }
            } else {
              debugPrint('ℹ️ 未找到相关知识库内容，使用原始查询');
            }
          } else if (ragService is EnhancedRagService) {
            // 使用增强RAG服务（整体超时兜底）
            final ragResult = await ragService
                .enhancePrompt(
                  userQuery: content,
                  config: knowledgeConfig,
                  knowledgeBaseId: currentKnowledgeBase.id,
                  similarityThreshold:
                      knowledgeConfig.similarityThreshold, // 使用配置中的相似度阈值
                )
                .timeout(const Duration(seconds: 2));

            if (ragResult.contexts.isNotEmpty) {
              enhancedPrompt = ragResult.enhancedPrompt;
              debugPrint('✅ 增强RAG增强成功，使用了${ragResult.contexts.length}个上下文');
              debugPrint('📝 增强后的提示词长度: ${enhancedPrompt.length}');

              // 显示使用的上下文信息（增强RAG的contexts是字符串列表）
              for (int i = 0; i < ragResult.contexts.length; i++) {
                final context = ragResult.contexts[i];
                debugPrint('📄 上下文${i + 1}: 长度=${context.length}');
              }
            } else {
              debugPrint('ℹ️ 未找到相关知识库内容，使用原始查询');
              if (ragResult.error != null) {
                debugPrint('⚠️ 增强RAG检索错误: ${ragResult.error}');
              }
            }
          } else {
            debugPrint('⚠️ 未知的RAG服务类型: ${ragService.runtimeType}');
          }
        } catch (e, stackTrace) {
          debugPrint('⚠️ RAG增强失败，使用原始查询: $e');
          debugPrint('📍 错误详情: ${e.toString()}');
          debugPrint('🔍 堆栈跟踪: ${stackTrace.toString()}');

          // 记录更详细的错误信息以便调试
          if (e.toString().contains('timeout')) {
            debugPrint('💡 建议: RAG检索超时，请检查网络连接或降低相似度阈值');
          } else if (e.toString().contains('embedding')) {
            debugPrint('💡 建议: 嵌入服务异常，请检查API配置');
          } else if (e.toString().contains('database')) {
            debugPrint('💡 建议: 数据库连接异常，请检查知识库状态');
          }
        }
      } else {
        if (!ragEnabled) {
          debugPrint('ℹ️ RAG功能已禁用，使用原始查询');
        } else if (knowledgeConfig == null) {
          debugPrint('⚠️ 没有知识库配置，使用原始查询');
        } else if (currentKnowledgeBase == null) {
          debugPrint('⚠️ 没有选中知识库，使用原始查询');
        } else if (!shouldUseRag) {
          debugPrint('ℹ️ 查询不需要RAG增强，使用原始查询');
        }
      }

      // 6. 构建上下文消息
      final contextMessages = await _buildContextMessages(
        sessionId,
        session.config,
        enhancedUserMessage: enhancedPrompt != content ? enhancedPrompt : null,
        currentImageUrls: [], // 非流式版本暂时不支持图片，需要后续扩展
      );
      // 当上下文窗口设置为0时，仍需确保当前用户输入被传递给模型
      if (contextMessages.isEmpty) {
        contextMessages.add(
          ChatMessageFactory.createUserMessage(
            content: enhancedPrompt,
            chatSessionId: sessionId,
            parentMessageId: parentMessageId,
          ),
        );
      }

      // 7. 生成AI响应
      final params = _ref.read(modelParametersProvider);
      final baseCustom =
          _buildThinkingParams(llmConfig.defaultModel) ?? <String, dynamic>{};
      final mergedCustom = {...baseCustom};
      // 如果用户选择“不启用”思考强度，则移除思考相关自定义参数
      if ((params.reasoningEffort).toLowerCase() == 'off') {
        mergedCustom.remove('reasoning_effort');
        mergedCustom.remove('max_tokens_for_reasoning');
        mergedCustom.remove('enable_reasoning');
      }

      // 当来源选择为 model_native 时，给 provider 透传开关，允许其启用内置联网/grounding
      if (await _database.getSetting(GeneralSettingsKeys.searchSource) ==
          'model_native') {
        mergedCustom['enableModelNativeSearch'] = true;
      }

      // 6.5. 检查是否支持函数调用，如果支持则添加AI工具函数
      final supportsTools = _checkModelSupportsTools(llmConfig.provider, llmConfig.defaultModel);
      List<ToolDefinition>? tools;
      if (supportsTools) {
        debugPrint('🔧 模型支持函数调用，添加AI工具函数');
        // 将 DailyManagementTools 的函数定义转换为 ToolDefinition
        tools = DailyManagementTools.getFunctionDefinitions().map((funcDef) {
          return ToolDefinition(
            name: funcDef['name'] as String,
            description: funcDef['description'] as String,
            parameters: funcDef['parameters'] as Map<String, dynamic>,
          );
        }).toList();
        debugPrint('🛠️ 已添加${tools.length}个工具函数');
      }

      debugPrint('🔍 llmConfig.defaultModel 实际值: "${llmConfig.defaultModel}"');
      debugPrint('🔍 llmConfig.defaultModel 是否为空: ${llmConfig.defaultModel?.isEmpty ?? true}');
      
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: persona.systemPrompt,
        temperature: session.config?.temperature ?? params.temperature,
        maxTokens: params.enableMaxTokens ? params.maxTokens.toInt() : null,
        reasoningEffort: _mapReasoningEffort(
          params.reasoningEffort,
          llmConfig.defaultModel,
        ),
        maxReasoningTokens: params.maxReasoningTokens,
        customParams: mergedCustom.isNotEmpty ? mergedCustom : null,
        tools: tools, // 添加工具函数
      );

      debugPrint(
        '🎯 使用模型: ${llmConfig.defaultModel} (提供商: ${llmConfig.provider})',
      );

      final result = await provider.generateChat(
        contextMessages,
        options: chatOptions,
      );

      // 6.6. 处理函数调用请求
      if (result.toolCalls != null && result.toolCalls!.isNotEmpty) {
        debugPrint('🤖 AI请求执行函数调用，数量: ${result.toolCalls!.length}');
        return await _handleToolCalls(result, sessionId, userMessage, contextMessages, chatOptions, provider);
      }

      // 7. 创建AI响应消息
      final aiMessage =
          ChatMessageFactory.createAIMessage(
            content: result.content,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
            tokenCount: result.tokenUsage.totalTokens,
          ).copyWith(
            modelName: chatOptions.model,
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
    List<String> imageUrls = const [], // 图片URL列表
    String? displayContent, // 用于UI显示的原始内容（可选）
  }) async* {
    debugPrint('🚀 开始发送消息: $content');
    
    // 🛡️ 会话存在性验证 - 确保在发送消息前会话在数据库中真实存在
    try {
      final session = await _getSessionById(sessionId);
      if (session.isArchived) {
        throw ChatSessionException.archived(sessionId);
      }
      debugPrint('🛡️ 会话验证通过: ${session.id} - ${session.title}');
    } catch (e) {
      debugPrint('🛡️ 会话验证失败: $e');
      if (e is ChatSessionException) {
        rethrow; // 重新抛出会话相关异常
      }
      throw ChatSessionException.invalidState(e.toString());
    }
    
    final messageContentForDisplay = displayContent ?? content;
    debugPrint('🔍 用户消息内容 - 显示: ${messageContentForDisplay.length}字符, AI处理: ${content.length}字符');

    final String? pId = parentMessageId;
    // 1. 创建用户消息（使用显示内容，确保UI显示的是原始输入）
    final userMessage = imageUrls.isNotEmpty
        ? ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: messageContentForDisplay, // 使用显示内容
            isFromUser: true,
            timestamp: DateTime.now(),
            chatSessionId: sessionId,
            type: MessageType.image,
            imageUrls: imageUrls,
            parentMessageId: pId,
          )
        : ChatMessageFactory.createUserMessage(
            content: messageContentForDisplay, // 使用显示内容
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

      // 检查是否有图片但模型不支持视觉
      if (imageUrls.isNotEmpty && !ModelCapabilityChecker.hasCapability(llmConfig.defaultModel, ModelCapabilityType.vision)) {
        final warningMessage = '模型 ${llmConfig.defaultModel ?? "当前模型"} 不支持视觉功能，无法处理图片内容';
        debugPrint('⚠️ 视觉模型检查失败: $warningMessage');
        
        // 创建警告消息
        final warningAIMessage = ChatMessageFactory.createErrorMessage(
          content: warningMessage,
          chatSessionId: sessionId,
          parentMessageId: userMessage.id,
        );
        
        await _database.insertMessage(_messageToCompanion(warningAIMessage));
        yield warningAIMessage;
        return;
      }

      // 4. 创建LLM Provider
      final provider = LlmProviderFactory.createProvider(
        llmConfig.toLlmConfig(),
      );
      debugPrint('🤖 AI Provider已创建');
      
      if (imageUrls.isNotEmpty) {
        debugPrint('🖼️ 发送包含${imageUrls.length}张图片的消息到模型: ${llmConfig.defaultModel}');
      }

      // 4.5. 检查是否需要RAG增强
      String enhancedPrompt = content;

      // 使用统一RAG服务（优先使用增强版，失败时自动回退到传统版）
      final ragService = await _ref.read(unifiedRagServiceProvider.future);
      final knowledgeConfig = _ref
          .read(knowledgeBaseConfigProvider)
          .currentConfig;

      // 检查RAG开关是否启用
      final settingsState = _ref.read(settingsProvider);
      final ragEnabled = settingsState.chatSettings.enableRag;

      // 获取当前选中的知识库
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;

      debugPrint('🔧 RAG状态检查:');
      debugPrint('  - RAG开关: ${ragEnabled ? "启用" : "禁用"}');
      debugPrint('  - 知识库配置: ${knowledgeConfig != null ? "存在" : "不存在"}');
      debugPrint('  - 当前知识库: ${currentKnowledgeBase?.name ?? "未选择"}');
      if (knowledgeConfig != null) {
        debugPrint('  - 配置名称: ${knowledgeConfig.name}');
        debugPrint('  - 嵌入模型: ${knowledgeConfig.embeddingModelName}');
      }
      debugPrint('  - 查询内容: "$content"');

      // 判断是否需要RAG增强（兼容新旧版本）
      bool shouldUseRag = false;
      if (ragService is RagService) {
        shouldUseRag = ragService.shouldUseRag(content);
      } else {
        // 对于EnhancedRagService，使用简化的判断逻辑
        shouldUseRag =
            content.trim().length > 3 &&
            ![
              'hi',
              'hello',
              '你好',
              '嗨',
              'hey',
              '哈喽',
            ].contains(content.trim().toLowerCase());
      }

      if (ragEnabled &&
          knowledgeConfig != null &&
          currentKnowledgeBase != null &&
          shouldUseRag) {
        try {
          debugPrint('🔍 使用RAG增强用户查询');
          debugPrint(
            '📊 知识库: ${currentKnowledgeBase.name} (${currentKnowledgeBase.id})',
          );
          debugPrint(
            '⚙️ 配置: ${knowledgeConfig.name} - ${knowledgeConfig.embeddingModelName}',
          );

          if (ragService is RagService) {
            // 使用传统RAG服务
            final ragResult = await ragService.enhancePrompt(
              userQuery: content,
              config: knowledgeConfig,
              knowledgeBaseId: currentKnowledgeBase.id,
              similarityThreshold:
                  knowledgeConfig.similarityThreshold, // 使用配置中的相似度阈值
            );

            if (ragResult.usedContexts.isNotEmpty) {
              enhancedPrompt = ragResult.enhancedPrompt;
              debugPrint('✅ 传统RAG增强成功，使用了${ragResult.usedContexts.length}个上下文');
              debugPrint('📝 增强后的提示词长度: ${enhancedPrompt.length}');
            } else {
              // 未找到相关知识库内容，使用原始查询
            }
          } else if (ragService is EnhancedRagService) {
            // 使用增强RAG服务
            final ragResult = await ragService.enhancePrompt(
              userQuery: content,
              config: knowledgeConfig,
              knowledgeBaseId: currentKnowledgeBase.id,
              similarityThreshold:
                  knowledgeConfig.similarityThreshold, // 使用配置中的相似度阈值
            );

            if (ragResult.contexts.isNotEmpty) {
              enhancedPrompt = ragResult.enhancedPrompt;
              debugPrint('✅ 增强RAG增强成功，使用了${ragResult.contexts.length}个上下文');
              debugPrint('📝 增强后的提示词长度: ${enhancedPrompt.length}');

              // 显示使用的上下文信息（增强RAG的contexts是字符串列表）
              for (int i = 0; i < ragResult.contexts.length; i++) {
                final context = ragResult.contexts[i];
                debugPrint('📄 上下文${i + 1}: 长度=${context.length}');
              }
            } else {
              debugPrint('ℹ️ 未找到相关知识库内容，使用原始查询');
              if (ragResult.error != null) {
                debugPrint('⚠️ 增强RAG检索错误: ${ragResult.error}');
              }
            }
          } else {
            debugPrint('⚠️ 未知的RAG服务类型: ${ragService.runtimeType}');
          }
        } catch (e, stackTrace) {
          debugPrint('⚠️ RAG增强失败，使用原始查询: $e');
          debugPrint('📍 错误详情: ${e.toString()}');
          debugPrint('🔍 堆栈跟踪: ${stackTrace.toString()}');

          // 记录更详细的错误信息以便调试
          if (e.toString().contains('timeout')) {
            debugPrint('💡 建议: RAG检索超时，请检查网络连接或降低相似度阈值');
          } else if (e.toString().contains('embedding')) {
            debugPrint('💡 建议: 嵌入服务异常，请检查API配置');
          } else if (e.toString().contains('database')) {
            debugPrint('💡 建议: 数据库连接异常，请检查知识库状态');
          }
        }
      } else {
        if (!ragEnabled) {
          debugPrint('ℹ️ RAG功能已禁用，使用原始查询');
        } else if (knowledgeConfig == null) {
          debugPrint('⚠️ 没有知识库配置，使用原始查询');
        } else if (currentKnowledgeBase == null) {
          debugPrint('⚠️ 没有选中知识库，使用原始查询');
        } else if (!shouldUseRag) {
          debugPrint('ℹ️ 查询不需要RAG增强，使用原始查询');
        }
      }

      // 5. 构建上下文消息
      final contextMessages = includeContext
          ? await _buildContextMessages(
              sessionId,
              session.config,
              enhancedUserMessage: enhancedPrompt != content
                  ? enhancedPrompt
                  : null,
              currentImageUrls: imageUrls, // 传递图片URLs
            )
          : [
              // 如果不包含上下文，只使用当前用户消息（包含图片）
              imageUrls.isNotEmpty
                  ? ChatMessage(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      content: enhancedPrompt,
                      isFromUser: true,
                      timestamp: DateTime.now(),
                      chatSessionId: sessionId,
                      type: MessageType.image,
                      imageUrls: imageUrls,
                      parentMessageId: parentMessageId,
                    )
                  : ChatMessageFactory.createUserMessage(
                      content: enhancedPrompt,
                      chatSessionId: sessionId,
                      parentMessageId: parentMessageId,
                    ),
            ];
      if (contextMessages.isEmpty) {
        contextMessages.add(
          ChatMessageFactory.createUserMessage(
            content: enhancedPrompt,
            chatSessionId: sessionId,
            parentMessageId: parentMessageId,
          ),
        );
      }

      debugPrint('💬 上下文消息数量: ${contextMessages.length}');

      // 6.5. 检查是否需要网络搜索
      String finalPrompt = enhancedPrompt;
      try {
        final aiSearchIntegration = _ref.read(aiSearchIntegrationProvider);
        final searchConfig = _ref.read(searchConfigProvider);

        // 详细的搜索状态调试（包含来源）
        final dbgSource = await _database.getSetting(
          GeneralSettingsKeys.searchSource,
        );
        final dbgOrchestrator = await _database.getSetting(
          GeneralSettingsKeys.searchOrchestratorEndpoint,
        );
        debugPrint('🔍 搜索状态检查:');
        debugPrint('  - 搜索开关: ${searchConfig.searchEnabled ? "启用" : "禁用"}');
        debugPrint('  - 来源: ${dbgSource ?? searchConfig.defaultEngine}');
        debugPrint('  - 启用的搜索引擎: ${searchConfig.enabledEngines}');
        debugPrint('  - 默认搜索引擎: ${searchConfig.defaultEngine}');
        debugPrint('  - orchestrator: ${dbgOrchestrator ?? ''}');
        debugPrint('  - 用户查询: "$content"');

        // 修改逻辑：如果用户主动启用了搜索，就直接搜索，不需要AI判断
        // 只有在自动搜索模式下才使用shouldSearch判断
        bool shouldExecuteSearch = false;

        if (searchConfig.searchEnabled) {
          // 用户已启用搜索开关，直接执行搜索
          shouldExecuteSearch = true;
          debugPrint('  - 用户已启用搜索，将执行搜索');
        } else {
          debugPrint('  - 搜索未启用或无可用引擎，跳过搜索');
        }

        if (shouldExecuteSearch) {
          debugPrint('🔍 ✅ 开始执行网络搜索...');

          // 通知UI开始搜索
          onSearchStatusChanged?.call(true);

          // 解析黑名单规则为 Pattern 列表
          List<Pattern> parseBlacklist(String rules) {
            final lines = rules
                .split('\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty && !e.startsWith('#'))
                .toList();
            final patterns = <Pattern>[];
            for (final line in lines) {
              if (line.startsWith('/') && line.endsWith('/')) {
                final pattern = line.substring(1, line.length - 1);
                patterns.add(RegExp(pattern));
              } else {
                patterns.add(line);
              }
            }
            return patterns;
          }

          final blacklistPatterns = parseBlacklist(searchConfig.blacklistRules);

          final int st = searchConfig.timeoutSeconds;
          final int boundedSeconds = st < 3 ? 3 : (st > 10 ? 10 : st);
          // 读取联网来源与 orchestrator 地址
          final searchSource =
              await _database.getSetting(GeneralSettingsKeys.searchSource) ??
              'direct';
          final orchestratorEndpoint = await _database.getSetting(
            GeneralSettingsKeys.searchOrchestratorEndpoint,
          );

          // 来源选择：不再回退到 Tavily；未配置 orchestrator 直接使用轻量HTTP抓取
          String sourceToUse = searchSource;

          // 简化：移动端是否允许 direct 的决策放在设置页；此处仅保留 isModelNative 判断
          final isModelNative = sourceToUse == 'model_native';

          AISearchResult? searchResult;
          if (!isModelNative) {
            searchResult = await aiSearchIntegration
                .performAISearch(
                  userQuery: content,
                  maxResults: searchConfig.maxResults,
                  language: searchConfig.language,
                  region: searchConfig.region,
                  engine: sourceToUse, // 直接用来源作为策略ID
                  apiKey: searchConfig.apiKey,
                  blacklistEnabled: searchConfig.blacklistEnabled,
                  blacklistPatterns: blacklistPatterns,
                  engines: (sourceToUse == 'direct')
                      ? (searchConfig.enabledEngines.isNotEmpty
                            ? searchConfig.enabledEngines
                            : const ['google'])
                      : const [],
                  orchestratorEndpoint: orchestratorEndpoint,
                )
                .timeout(Duration(seconds: boundedSeconds));
          }

          // 通知UI搜索结束
          onSearchStatusChanged?.call(false);

          if (searchResult != null) {
            if (searchResult.hasResults) {
              final searchContext = aiSearchIntegration
                  .formatSearchResultsForAI(searchResult);
              finalPrompt = '$enhancedPrompt\n\n$searchContext';
              debugPrint('✅ 搜索完成，已将搜索结果添加到上下文');
            } else {
              debugPrint('⚠️ 搜索未返回有效结果');
            }
          }
        }
      } on TimeoutException {
        debugPrint('⏰ 搜索整体超时，跳过网络搜索加持');
        onSearchStatusChanged?.call(false);
      } catch (e) {
        debugPrint('❌ 搜索过程中出现错误: $e');
        // 确保搜索状态被重置
        onSearchStatusChanged?.call(false);
        // 搜索失败不影响正常对话，继续使用原始提示
      }

      // 更新上下文消息中的最后一条用户消息
      if (contextMessages.isNotEmpty && finalPrompt != enhancedPrompt) {
        final lastMessage = contextMessages.last;
        if (lastMessage.isFromUser) {
          contextMessages[contextMessages.length - 1] = lastMessage.copyWith(
            content: finalPrompt,
          );
        }
      }

      // 7. 构建聊天选项 - 使用会话配置和智能体提示词
      final params = _ref.read(modelParametersProvider);
      final baseCustomStream =
          _buildThinkingParams(llmConfig.defaultModel) ?? <String, dynamic>{};
      final mergedCustomStream = {...baseCustomStream};
      if ((params.reasoningEffort).toLowerCase() == 'off') {
        mergedCustomStream.remove('reasoning_effort');
        mergedCustomStream.remove('max_tokens_for_reasoning');
        mergedCustomStream.remove('enable_reasoning');
      }

      // 检查是否为学习模式 - 学习模式下不使用智能体提示词，因为学习提示词已经包含在消息中
      final isLearningMode = content != finalPrompt; // 如果内容被修改过，说明是学习模式
      
      final chatOptions = ChatOptions(
        model: llmConfig.defaultModel,
        systemPrompt: isLearningMode ? null : persona.systemPrompt, // 学习模式下不使用智能体提示词
        temperature: session.config?.temperature ?? params.temperature,
        maxTokens: params.enableMaxTokens ? params.maxTokens.toInt() : null,
        // 注意：部分模型不支持 top_p，统一不传，以避免 400/500
        stream: true,
        // 思考链相关参数
        reasoningEffort: _mapReasoningEffort(
          params.reasoningEffort,
          llmConfig.defaultModel,
        ),
        maxReasoningTokens: params.maxReasoningTokens,
        customParams: mergedCustomStream,
      );

      debugPrint(
        '📊 模型参数: 温度=${chatOptions.temperature}, 最大Token=${chatOptions.maxTokens}, 最大推理Token=${chatOptions.maxReasoningTokens}',
      );
      debugPrint('📝 上下文消息数量: ${contextMessages.length}');

      // 8. 开始流式生成
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
                  modelName: chatOptions.model,
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
          if (kDebugMode) {
            // 检查标签内容
            if (deltaText.contains('<') ||
                deltaText.contains('>') ||
                deltaText.contains('think')) {
              // 发现可能的标签内容
            }
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

          if (kDebugMode) {
            debugPrint(
              '✅ 处理结果: 思考模式=$isInThinkingMode, 思考增量=${thinkingDelta?.length ?? 0}, 部分标签="$partialTag"',
            );
          }

          // 累积思考链内容
          if (thinkingDelta != null && thinkingDelta.isNotEmpty) {
            accumulatedThinking += thinkingDelta;
            if (kDebugMode) {
              debugPrint(
                '🧠 思考链增量: $thinkingDelta.length 字符, 总长度: $accumulatedThinking.length',
              );
            }
          }

          // 累积正文内容
          if (contentDelta != null && contentDelta.isNotEmpty) {
            accumulatedActualContent += contentDelta;
            if (kDebugMode) {
              debugPrint(
                '📝 正文内容已累积',
              );
            }
          }
        }

        // 创建或更新AI消息
        aiMessageId ??= ChatMessageFactory.createAIMessage(
            content: accumulatedRawContent,
            chatSessionId: sessionId,
            parentMessageId: userMessage.id,
            modelName: chatOptions.model,
          ).id;

        yield ChatMessage(
          id: aiMessageId,
          content: accumulatedRawContent, // 保存完整原始内容
          isFromUser: false,
          timestamp: DateTime.now(),
          chatSessionId: sessionId,
          status: MessageStatus.sending,
          modelName: chatOptions.model,
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

  /// 保存消息到数据库
  Future<void> insertMessage(ChatMessage message) async {
    await _database.insertMessage(_messageToCompanion(message));
  }

  /// 获取会话的LLM配置信息（用于图像生成等功能）
  Future<LlmConfigsTableData> getSessionLlmConfig(String sessionId) async {
    final session = await _getSessionById(sessionId);
    final persona = await _getPersonaById(session.personaId);
    return await _getLlmConfigById(persona.apiConfigId);
  }

  /// 构建上下文消息
  Future<List<ChatMessage>> _buildContextMessages(
    String sessionId,
    ChatSessionConfig? config, {
    String? enhancedUserMessage,
    List<String> currentImageUrls = const [], // 新增：当前消息的图片URLs
  }) async {
    // 从侧边栏参数获取上下文长度
    final params = _ref.read(modelParametersProvider);
    final contextWindowSize = params.contextLength.toInt();

    debugPrint('📊 使用上下文长度: $contextWindowSize');

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

    // 学习模式下的上下文过滤：只包含最近一次学习会话结束分割线之后的消息
    final filteredMessages = _filterContextForLearningMode(contextMessages);

    // 如果有RAG增强的消息，替换最后一条用户消息
    if (enhancedUserMessage != null && filteredMessages.isNotEmpty) {
      final lastMessage = filteredMessages.last;
      if (lastMessage.isFromUser) {
        filteredMessages[filteredMessages.length - 1] = lastMessage.copyWith(
          content: enhancedUserMessage,
        );
      }
    }

    // 如果当前消息包含图片，需要添加到上下文中
    if (currentImageUrls.isNotEmpty) {
      // 创建包含图片的用户消息
      final imageMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: enhancedUserMessage ?? '',
        isFromUser: true,
        timestamp: DateTime.now(),
        chatSessionId: sessionId,
        type: MessageType.image,
        imageUrls: currentImageUrls,
      );
      
      // 如果上下文为空或最后一条不是用户消息，直接添加
      if (filteredMessages.isEmpty || !filteredMessages.last.isFromUser) {
        filteredMessages.add(imageMessage);
      } else {
        // 替换最后一条用户消息，保留图片信息
        filteredMessages[filteredMessages.length - 1] = filteredMessages.last.copyWith(
          imageUrls: currentImageUrls,
          type: MessageType.image,
          content: enhancedUserMessage ?? filteredMessages.last.content,
        );
      }
      
      debugPrint('🖼️ 添加图片到上下文消息: ${currentImageUrls.length}张图片');
    }

    return filteredMessages;
  }

  /// 过滤学习模式下的上下文消息
  /// 
  /// 在学习模式下，只保留最近一次学习会话结束分割线之后的消息，
  /// 确保新的学习会话不会包含上一轮学习的内容
  List<ChatMessage> _filterContextForLearningMode(List<ChatMessage> messages) {
    // 检查是否在学习模式
    final learningModeState = _ref.read(learningModeProvider);
    if (!learningModeState.isLearningMode) {
      return messages; // 非学习模式，返回所有消息
    }

    // 查找最后一个系统分割线消息（学习会话结束标记）
    int lastDividerIndex = -1;
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].type == MessageType.system && 
          messages[i].content.contains('学习会话结束')) {
        lastDividerIndex = i;
        break;
      }
    }

    // 如果找到分割线，只返回分割线之后的消息
    if (lastDividerIndex >= 0) {
      final filtered = messages.sublist(lastDividerIndex + 1);
      debugPrint('🎓 学习模式上下文过滤: 原消息${messages.length}条 → 过滤后${filtered.length}条');
      return filtered;
    }

    // 没有找到分割线，返回所有消息（可能是第一次学习会话）
    return messages;
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
      imageUrls: Value(jsonEncode(message.imageUrls)),
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

  /// 将侧边栏的 effort 值映射到具体模型
  String? _mapReasoningEffort(String effort, String? model) {
    if (model == null) return null;
    final lower = effort.toLowerCase();
    // 新增：当为 off 时，明确禁用推理强度
    if (lower == 'off') return null;
    if (lower == 'auto') {
      return _getReasoningEffort(model);
    }
    // 仅推理模型生效
    final isThinkingModel = {
      'o1',
      'o3',
      'deepseek-reasoner',
      'deepseek-r1',
    }.any((m) => model.toLowerCase().contains(m));
    return isThinkingModel ? lower : null;
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

  /// 验证RAG功能状态
  Future<Map<String, dynamic>> validateRagStatus() async {
    final result = <String, dynamic>{};

    try {
      // 1. 检查RAG开关
      final settingsState = _ref.read(settingsProvider);
      final ragEnabled = settingsState.chatSettings.enableRag;
      result['ragEnabled'] = ragEnabled;

      // 2. 检查RAG服务
      try {
        final ragService = await _ref.read(unifiedRagServiceProvider.future);
        result['ragServiceType'] = ragService.runtimeType.toString();
        result['ragServiceAvailable'] = true;
      } catch (e) {
        result['ragServiceAvailable'] = false;
        result['ragServiceError'] = e.toString();
      }

      // 3. 检查知识库配置
      final knowledgeConfigState = _ref.read(knowledgeBaseConfigProvider);
      final knowledgeConfig = knowledgeConfigState.currentConfig;
      result['knowledgeConfigAvailable'] = knowledgeConfig != null;
      if (knowledgeConfig != null) {
        result['knowledgeConfigName'] = knowledgeConfig.name;
        result['embeddingModel'] = knowledgeConfig.embeddingModelName;
      }

      // 4. 检查知识库选择
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;
      result['knowledgeBaseSelected'] = currentKnowledgeBase != null;
      if (currentKnowledgeBase != null) {
        result['knowledgeBaseName'] = currentKnowledgeBase.name;
        result['knowledgeBaseId'] = currentKnowledgeBase.id;
      }

      // 5. 综合状态
      result['ragFullyFunctional'] =
          ragEnabled &&
          result['ragServiceAvailable'] == true &&
          knowledgeConfig != null &&
          currentKnowledgeBase != null;
    } catch (e) {
      result['error'] = e.toString();
    }

    return result;
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

        // 内容分离完成

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
        // 默认启用：仅当显式为 'false' 时才禁用
        debugPrint('🏷️ 自动命名功能启用状态: ${autoNamingEnabled ?? 'null(按启用处理)'}');
        if (autoNamingEnabled == 'false') {
          debugPrint('🏷️ 自动命名功能被关闭，跳过');
          return;
        }

        // 获取会话与默认模型（用于命名的兜底）
        final session = await _getSessionById(sessionId);
        debugPrint('🏷️ 当前会话标题: ${session.title}');
        // 会话未命名才处理
        if (session.title != '新对话') {
          debugPrint('🏷️ 会话已被命名，跳过');
          return;
        }

        final persona = await _getPersonaById(session.personaId);
        final sessionLlmConfigData = await _getLlmConfigById(
          persona.apiConfigId,
        );
        final fallbackLlmConfig = sessionLlmConfigData.toLlmConfig();

        // 读取配置的命名模型（可选）
        final modelId = await _database.getSetting(
          GeneralSettingsKeys.autoTopicNamingModelId,
        );
        debugPrint('🏷️ 配置的命名模型ID: $modelId');

        // 检查是否是第一次对话（只有一条用户消息和一条AI回复）
        final messages = await getSessionMessages(sessionId);
        debugPrint('🏷️ 会话消息数量: ${messages.length}');
        if (messages.length != 2) {
          debugPrint('🏷️ 不是第一次对话，跳过');
          return;
        }

        // 选择用于命名的Provider与模型：优先用配置的命名模型，否则回退到当前会话模型
        var namingProviderConfig = fallbackLlmConfig;
        var namingModelId = fallbackLlmConfig.defaultModel;

        if (modelId != null && modelId.isNotEmpty) {
          final customModel = await _database.getCustomModelById(modelId);
          debugPrint('🏷️ 找到的自定义模型: ${customModel?.name}');
          if (customModel != null && customModel.isEnabled) {
            final configId = customModel.configId ?? '';
            debugPrint('🏷️ 模型关联的配置ID: $configId');
            final modelConfig = await _database.getLlmConfigById(configId);
            debugPrint('🏷️ 找到的LLM配置: ${modelConfig?.name}');
            if (modelConfig != null && modelConfig.isEnabled) {
              namingProviderConfig = modelConfig.toLlmConfig();
              namingModelId = customModel.modelId;
            } else {
              debugPrint('🏷️ 指定命名模型的配置不可用，回退到会话默认模型');
            }
          } else {
            debugPrint('🏷️ 指定命名模型不可用，回退到会话默认模型');
          }
        } else {
          debugPrint('🏷️ 未配置命名模型，使用会话默认模型命名');
        }

        // 创建命名提示词
        final namingPrompt = _buildTopicNamingPrompt(userContent, aiContent);
        debugPrint('🏷️ 生成的命名提示词长度: ${namingPrompt.length}');

        // 创建LLM Provider
        debugPrint('🏷️ 创建LLM Provider，使用模型: $namingModelId');
        final provider = LlmProviderFactory.createProvider(
          namingProviderConfig,
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
            model: namingModelId,
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

  /// 检查模型是否支持工具函数调用
  bool _checkModelSupportsTools(String? provider, String? model) {
    if (provider == null || model == null) return false;
    switch (provider.toLowerCase()) {
      case 'openai':
        // GPT-4和GPT-3.5系列支持函数调用
        return model.contains('gpt-4') || model.contains('gpt-3.5');
      case 'anthropic':
        // Claude系列支持函数调用
        return model.contains('claude');
      case 'google':
        // Gemini Pro支持函数调用
        return model.contains('gemini-pro') || model.contains('gemini-1.5');
      default:
        // 保守起见，未知提供商默认不支持
        return false;
    }
  }

  /// 处理工具函数调用
  Future<ChatMessage> _handleToolCalls(
    ChatResult result,
    String sessionId,
    ChatMessage userMessage,
    List<ChatMessage> contextMessages,
    ChatOptions chatOptions,
    LlmProvider provider,
  ) async {
    debugPrint('🛠️ 开始处理工具函数调用');
    
    try {
      // 获取AI计划桥接服务
      final bridgeService = _ref.read(aiPlanBridgeServiceProvider);
      final aiToolsNotifier = _ref.read(aiToolsStateProvider.notifier);
      final activeFunctionCallNotifier = _ref.read(activeFunctionCallProvider.notifier);
      final statisticsNotifier = _ref.read(aiToolsStatisticsProvider.notifier);
      
      // 记录工具函数执行开始
      aiToolsNotifier.setExecuting(true);
      
      // 存储所有函数调用结果
      final List<Map<String, dynamic>> functionResults = [];
      
      // 逐一处理每个函数调用
      for (final toolCall in result.toolCalls!) {
        final startTime = DateTime.now();
        
        debugPrint('🔧 执行函数: ${toolCall.name}');
        debugPrint('📋 函数参数: ${toolCall.arguments}');
        
        // 记录活跃函数调用
        activeFunctionCallNotifier.startFunctionCall(
          toolCall.name,
          toolCall.arguments,
          sessionId: sessionId,
        );
        
        try {
          // 执行函数调用
          final functionResult = await bridgeService.handleFunctionCall(
            toolCall.name,
            toolCall.arguments,
          );
          
          final executionTime = DateTime.now().difference(startTime);
          
          if (functionResult.success) {
            debugPrint('✅ 函数执行成功: ${toolCall.name}');
            debugPrint('📊 执行结果: ${functionResult.data}');
            
            // 记录成功统计
            statisticsNotifier.recordSuccess(toolCall.name, executionTime);
            
            functionResults.add({
              'function_name': toolCall.name,
              'call_id': toolCall.id,
              'success': true,
              'result': functionResult.data,
              'message': functionResult.message,
              'execution_time_ms': executionTime.inMilliseconds,
            });
          } else {
            debugPrint('❌ 函数执行失败: ${toolCall.name}');
            debugPrint('💥 错误信息: ${functionResult.error}');
            
            // 记录失败统计
            statisticsNotifier.recordFailure(toolCall.name, executionTime);
            
            functionResults.add({
              'function_name': toolCall.name,
              'call_id': toolCall.id,
              'success': false,
              'error': functionResult.error,
              'execution_time_ms': executionTime.inMilliseconds,
            });
          }
        } catch (e) {
          final executionTime = DateTime.now().difference(startTime);
          debugPrint('💥 函数调用异常: ${toolCall.name} - $e');
          
          // 记录失败统计
          statisticsNotifier.recordFailure(toolCall.name, executionTime);
          
          functionResults.add({
            'function_name': toolCall.name,
            'call_id': toolCall.id,
            'success': false,
            'error': '函数调用异常: ${e.toString()}',
            'execution_time_ms': executionTime.inMilliseconds,
          });
        } finally {
          // 结束活跃函数调用记录
          activeFunctionCallNotifier.endFunctionCall();
        }
      }
      
      // 构建AI响应内容，包含原始内容和函数执行结果
      final functionResultsText = _formatFunctionResults(functionResults);
      final aiContent = result.content.isNotEmpty 
          ? '${result.content}\n\n$functionResultsText'
          : functionResultsText;
      
      // 创建包含函数调用结果的AI消息
      final aiMessage = ChatMessageFactory.createAIMessage(
        content: aiContent,
        chatSessionId: sessionId,
        parentMessageId: userMessage.id,
        tokenCount: result.tokenUsage.totalTokens,
      ).copyWith(
        modelName: chatOptions.model,
        thinkingContent: result.thinkingContent,
        thinkingComplete: result.thinkingContent != null,
        // 可以在metadata中保存详细的函数调用信息
        metadata: {
          'function_calls': functionResults,
          'tool_calls_count': result.toolCalls!.length,
        },
      );
      
      // 清除执行状态
      aiToolsNotifier.setExecuting(false);
      aiToolsNotifier.clearError();
      
      debugPrint('🎯 工具函数调用处理完成，执行了${functionResults.length}个函数');
      
      return aiMessage;
      
    } catch (e, stackTrace) {
      debugPrint('💥 处理工具函数调用时发生错误: $e');
      debugPrint('📍 错误堆栈: $stackTrace');
      
      // 更新错误状态
      final aiToolsNotifier = _ref.read(aiToolsStateProvider.notifier);
      aiToolsNotifier.setError('工具函数调用处理失败: ${e.toString()}');
      
      // 创建错误消息
      return ChatMessageFactory.createErrorMessage(
        content: '抱歉，执行工具函数时出现错误：${e.toString()}',
        chatSessionId: sessionId,
        parentMessageId: userMessage.id,
      );
    }
  }
  
  /// 格式化函数执行结果为用户可读的文本
  String _formatFunctionResults(List<Map<String, dynamic>> functionResults) {
    final buffer = StringBuffer();
    buffer.writeln('📋 **函数执行结果:**\n');
    
    for (int i = 0; i < functionResults.length; i++) {
      final result = functionResults[i];
      final functionName = result['function_name'] as String;
      final success = result['success'] as bool;
      final executionTime = result['execution_time_ms'] as int;
      
      buffer.writeln('${i + 1}. **${DailyManagementTools.getFunctionDescription(functionName)}**');
      
      if (success) {
        buffer.writeln('   ✅ 执行成功 (${executionTime}ms)');
        
        final message = result['message'] as String?;
        if (message != null && message.isNotEmpty) {
          buffer.writeln('   📄 $message');
        }
        
        // 根据函数类型格式化结果数据
        _formatFunctionData(buffer, functionName, result['result']);
      } else {
        buffer.writeln('   ❌ 执行失败 (${executionTime}ms)');
        final error = result['error'] as String?;
        if (error != null && error.isNotEmpty) {
          buffer.writeln('   💥 错误: $error');
        }
      }
      
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// 格式化特定函数的数据结果
  void _formatFunctionData(StringBuffer buffer, String functionName, dynamic data) {
    if (data == null) return;
    
    switch (functionName) {
      case 'read_course_schedule':
        _formatCourseScheduleData(buffer, data);
        break;
      case 'get_study_plans':
        _formatStudyPlansData(buffer, data);
        break;
      case 'analyze_course_workload':
        _formatWorkloadAnalysisData(buffer, data);
        break;
      case 'create_study_plan':
      case 'update_study_plan':
        _formatPlanOperationData(buffer, data);
        break;
      default:
        // 通用格式化
        if (data is Map) {
          final summary = data['message'] ?? data['summary'] ?? '';
          if (summary.isNotEmpty) {
            buffer.writeln('   📝 $summary');
          }
        }
    }
  }
  
  /// 格式化课程表数据
  void _formatCourseScheduleData(StringBuffer buffer, Map<String, dynamic> data) {
    final courses = data['courses'] as List?;
    if (courses == null || courses.isEmpty) {
      buffer.writeln('   📚 暂无课程安排');
      return;
    }
    
    buffer.writeln('   📚 找到 ${courses.length} 门课程:');
    for (final course in courses.take(3)) { // 最多显示3门课程
      final name = course['course_name'] ?? '未知课程';
      final time = course['time'] ?? '';
      final teacher = course['teacher'] ?? '';
      final classroom = course['classroom'] ?? '';
      
      buffer.write('     • $name');
      if (time.isNotEmpty) buffer.write(' ($time)');
      if (teacher.isNotEmpty) buffer.write(' - $teacher');
      if (classroom.isNotEmpty) buffer.write(' @ $classroom');
      buffer.writeln();
    }
    
    if (courses.length > 3) {
      buffer.writeln('     ... 以及其他 ${courses.length - 3} 门课程');
    }
  }
  
  /// 格式化学习计划数据
  void _formatStudyPlansData(StringBuffer buffer, Map<String, dynamic> data) {
    final plans = data['plans'] as List?;
    if (plans == null || plans.isEmpty) {
      buffer.writeln('   📋 暂无学习计划');
      return;
    }
    
    buffer.writeln('   📋 找到 ${plans.length} 个计划:');
    for (final plan in plans.take(3)) { // 最多显示3个计划
      final title = plan['title'] ?? '未知计划';
      final status = plan['status'] ?? '';
      final progress = plan['progress'] ?? 0;
      final priority = plan['priority'] ?? '';
      
      buffer.write('     • $title');
      if (status.isNotEmpty) {
        final statusEmoji = status == 'completed' ? '✅' : 
                           status == 'in_progress' ? '🔄' : '⏸️';
        buffer.write(' $statusEmoji');
      }
      if (progress > 0) buffer.write(' ($progress%)');
      if (priority.isNotEmpty && priority != 'medium') {
        final priorityEmoji = priority == 'high' ? '🔴' : '🟡';
        buffer.write(' $priorityEmoji');
      }
      buffer.writeln();
    }
    
    if (plans.length > 3) {
      buffer.writeln('     ... 以及其他 ${plans.length - 3} 个计划');
    }
  }
  
  /// 格式化工作量分析数据
  void _formatWorkloadAnalysisData(StringBuffer buffer, Map<String, dynamic> data) {
    final summary = data['summary'] as String?;
    if (summary != null && summary.isNotEmpty) {
      buffer.writeln('   📊 $summary');
    }
    
    final recommendations = data['recommendations'] as List?;
    if (recommendations != null && recommendations.isNotEmpty) {
      buffer.writeln('   💡 建议:');
      for (final recommendation in recommendations.take(2)) {
        buffer.writeln('     • $recommendation');
      }
      if (recommendations.length > 2) {
        buffer.writeln('     ... 以及其他 ${recommendations.length - 2} 条建议');
      }
    }
  }
  
  /// 格式化计划操作数据
  void _formatPlanOperationData(StringBuffer buffer, Map<String, dynamic> data) {
    final planTitle = data['title'] as String?;
    final planId = data['plan_id'] as String?;
    
    if (planTitle != null) {
      buffer.writeln('   📌 计划: $planTitle');
    }
    if (planId != null) {
      buffer.writeln('   🆔 ID: ${planId.substring(0, 8)}...');
    }
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
    // 解析图片URL列表
    List<String> parsedImageUrls = [];
    try {
      if (imageUrls.isNotEmpty) {
        final decoded = jsonDecode(imageUrls);
        if (decoded is List) {
          parsedImageUrls = decoded.cast<String>();
        }
      }
    } catch (e) {
      debugPrint('解析图片URL失败: $e');
    }

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
      imageUrls: parsedImageUrls,
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
