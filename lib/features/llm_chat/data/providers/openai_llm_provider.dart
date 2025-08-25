import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// OpenAI LLM Provider实现
///
/// 使用dart_openai包实现与OpenAI API的交互
class OpenAiLlmProvider extends LlmProvider {
  OpenAiLlmProvider(super.config) {
    _initializeOpenAI();
  }

  @override
  String get providerName => 'OpenAI';

  /// 初始化OpenAI配置
  void _initializeOpenAI() {
    OpenAI.apiKey = config.apiKey;

    if (config.baseUrl != null) {
      // 修复baseUrl重复/v1的问题
      String cleanBaseUrl = config.baseUrl!.trim();
      
      // 移除末尾的斜杠
      if (cleanBaseUrl.endsWith('/')) {
        cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
      }
      
      // 如果用户已经配置了/v1，则移除它，因为dart_openai会自动添加
      if (cleanBaseUrl.endsWith('/v1')) {
        cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 3);
      }
      
      OpenAI.baseUrl = cleanBaseUrl;
      debugPrint('🔧 设置OpenAI baseUrl: $cleanBaseUrl (原始: ${config.baseUrl})');
    }

    if (config.organizationId != null) {
      OpenAI.organization = config.organizationId;
    }
  }

  // ===== 缓存模型列表，减少频繁的网络请求 =====
  List<ModelInfo>? _cachedModels;
  DateTime? _cacheTime;
  static const Duration _cacheExpiry = Duration(hours: 1);

  @override
  Future<List<ModelInfo>> listModels() async {
    // 如果缓存仍然有效，直接返回缓存数据
    final now = DateTime.now();
    if (_cachedModels != null &&
        _cacheTime != null &&
        now.difference(_cacheTime!) < _cacheExpiry) {
      return _cachedModels!;
    }

    try {
      // 调用 OpenAI 列出模型 API
      final models = await OpenAI.instance.model.list();

      // 仅取可用的模型 id，生成 ModelInfo（其它字段用默认）
      final List<ModelInfo> result = models.map((m) {
        return ModelInfo(
          id: m.id,
          name: m.id, // 默认显示名称与 id 相同，后续可编辑
          type: ModelType.chat,
          supportsStreaming: true,
        );
      }).toList();

      // 若 API 返回空，降级到静态列表
      if (result.isEmpty) throw Exception('empty');

      // 写入缓存
      _cachedModels = result;
      _cacheTime = now;
      return result;
    } catch (_) {
      // 返回静态列表作为兜底，并写入缓存，避免连续失败导致重复请求
      const fallback = <ModelInfo>[
        ModelInfo(
          id: 'gpt-3.5-turbo',
          name: 'gpt-3.5-turbo',
          type: ModelType.chat,
          supportsStreaming: true,
        ),
        ModelInfo(
          id: 'gpt-4o',
          name: 'gpt-4o',
          type: ModelType.chat,
          supportsStreaming: true,
        ),
        ModelInfo(
          id: 'text-embedding-3-small',
          name: 'text-embedding-3-small',
          type: ModelType.embedding,
          supportsStreaming: false,
        ),
      ];
      _cachedModels = fallback;
      _cacheTime = now;
      return fallback;
    }
  }

  @override
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async {
    try {
      final openAIMessages = _convertToOpenAIMessages(
        messages,
        options?.systemPrompt,
      );
      // 防御：如果消息体为空，补一条最小用户消息，避免下游兼容端点报 contents/messages 为空
      if (openAIMessages.isEmpty) {
        openAIMessages.add(
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                options?.systemPrompt?.isNotEmpty == true
                    ? options!.systemPrompt!
                    : '请根据系统指令继续回答。',
              ),
            ],
          ),
        );
      }
      final model = options?.model ?? config.defaultModel ?? 'gpt-3.5-turbo';

      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        // 不传 topP，避免与部分兼容模型不兼容
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences,
        // 暂时移除工具调用功能
        // tools: options?.tools?.map(_convertToOpenAITool).toList(),
      );

      if (chatCompletion.choices.isEmpty) {
        throw ApiException('OpenAI API返回了空的选择列表');
      }

      final choice = chatCompletion.choices.first;
      final usage = chatCompletion.usage;

      // 保存完整的原始内容
      final originalContent = choice.message.content?.isNotEmpty == true
          ? choice.message.content!.first.text ?? ''
          : '';

      debugPrint('🧠 接收完整响应内容: 长度=${originalContent.length}');

      return ChatResult(
        content: originalContent, // 保存完整内容，UI层面分离显示
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: usage.promptTokens,
          outputTokens: usage.completionTokens,
          totalTokens: usage.totalTokens,
        ),
        finishReason: _convertFinishReason(choice.finishReason),
        // 暂时移除工具调用功能
        // toolCalls: choice.message.toolCalls?.map(_convertToolCall).toList(),
      );
    } catch (e) {
      throw _handleOpenAIError(e);
    }
  }

  @override
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async* {
    try {
      final openAIMessages = _convertToOpenAIMessages(
        messages,
        options?.systemPrompt,
      );
      if (openAIMessages.isEmpty) {
        openAIMessages.add(
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                options?.systemPrompt?.isNotEmpty == true
                    ? options!.systemPrompt!
                    : '请根据系统指令继续回答。',
              ),
            ],
          ),
        );
      }
      final model = options?.model ?? config.defaultModel ?? 'gpt-3.5-turbo';

      final stream = OpenAI.instance.chat.createStream(
        model: model,
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        // 不传 topP，避免与部分兼容模型不兼容
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences,
        // 暂时移除工具调用功能
        // tools: options?.tools?.map(_convertToOpenAITool).toList(),
      );

      String accumulatedContent = ''; // 累积完整原始内容

      await for (final chunk in stream) {
        if (chunk.choices.isEmpty) continue;

        final choice = chunk.choices.first;
        final delta = choice.delta;

        // 处理内容增量
        if (delta.content != null && delta.content!.isNotEmpty) {
          final OpenAIChatCompletionChoiceMessageContentItemModel?
          firstContent = delta.content!.first;
          final String? deltaText = firstContent?.text;
          if (deltaText != null && deltaText.isNotEmpty) {
            accumulatedContent += deltaText;

            yield StreamedChatResult(
              delta: deltaText,
              content: accumulatedContent, // 保存完整内容
              isDone: false,
              model: model,
            );
          }
        }

        if (choice.finishReason != null) {
          debugPrint('🧠 流式响应完成: 内容长度=${accumulatedContent.length}');

          yield StreamedChatResult(
            content: accumulatedContent, // 保存完整内容，UI层面分离显示
            isDone: true,
            model: model,
            tokenUsage: TokenUsage(
              inputTokens: 0, // 流式响应中无法准确获取
              outputTokens: accumulatedContent.split(' ').length,
              totalTokens: accumulatedContent.split(' ').length,
            ),
            finishReason: _convertFinishReason(choice.finishReason),
          );
        }
      }
    } catch (e) {
      throw _handleOpenAIError(e);
    }
  }

  @override
  Future<EmbeddingResult> generateEmbeddings(List<String> texts) async {
    try {
      final model = config.defaultEmbeddingModel ?? 'text-embedding-3-small';

      debugPrint('🔗 OpenAI嵌入请求: 模型=$model, 文本数量=${texts.length}');
      debugPrint('🌐 API端点: ${config.baseUrl ?? 'https://api.openai.com'}');

      final embedding = await OpenAI.instance.embedding
          .create(model: model, input: texts)
          .timeout(
            const Duration(minutes: 2), // 2分钟超时
            onTimeout: () {
              throw Exception('OpenAI嵌入请求超时，请检查网络连接或API服务状态');
            },
          );

      // 检查响应数据是否有效
      if (embedding.data.isEmpty) {
        throw Exception('OpenAI API返回了空的嵌入数据');
      }

      debugPrint('✅ OpenAI嵌入请求成功: 生成${embedding.data.length}个向量');

      // 安全地处理嵌入数据
      final embeddings = <List<double>>[];
      for (final item in embedding.data) {
        if (item.embeddings.isNotEmpty) {
          embeddings.add(item.embeddings);
        } else {
          debugPrint('⚠️ 发现空的嵌入向量，跳过');
        }
      }

      if (embeddings.isEmpty) {
        throw Exception('所有嵌入向量都为空');
      }

      return EmbeddingResult(
        embeddings: embeddings,
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: embedding.usage?.promptTokens ?? 0,
          outputTokens: 0,
          totalTokens: embedding.usage?.totalTokens ?? 0,
        ),
      );
    } catch (e) {
      debugPrint('❌ OpenAI嵌入请求失败: $e');
      debugPrint('🔍 OpenAI错误详情: $e');

      // 提供更详细的错误信息
      if (e.toString().contains('NoSuchMethodError')) {
        debugPrint('💡 这可能是API响应格式问题，请检查OpenAI API版本兼容性');
      }

      throw _handleOpenAIError(e);
    }
  }

  @override
  Future<bool> validateConfig() async {
    try {
      await OpenAI.instance.model.list();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  int estimateTokens(String text) {
    // 简单的token估算：大约4个字符 = 1个token
    return (text.length / 4).ceil();
  }

  @override
  void dispose() {
    // OpenAI SDK不需要特殊的清理
  }

  /// 转换为OpenAI消息格式
  List<OpenAIChatCompletionChoiceMessageModel> _convertToOpenAIMessages(
    List<ChatMessage> messages,
    String? systemPrompt,
  ) {
    final openAIMessages = <OpenAIChatCompletionChoiceMessageModel>[];
    bool hasContentMessage = false; // 是否存在至少一条非空内容消息

    // 添加系统提示词（放在最前）
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      openAIMessages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              systemPrompt,
            ),
          ],
        ),
      );
    }

    // 转换聊天消息（跳过空内容项）
    for (final message in messages) {
      final contentItems =
          <OpenAIChatCompletionChoiceMessageContentItemModel>[];

      // 添加文本内容
      if (message.content.isNotEmpty) {
        contentItems.add(
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            message.content,
          ),
        );
      }

      // 添加图片内容（如果有）
      if (message.imageUrls.isNotEmpty) {
        for (final imageUrl in message.imageUrls) {
          // 检查是否是base64格式的图片
          if (imageUrl.startsWith('data:image/')) {
            contentItems.add(
              OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                imageUrl,
              ),
            );
          } else if (imageUrl.startsWith('file://')) {
            // 如果是文件路径，需要转换为base64
            // 这里暂时跳过，因为需要异步读取文件
            debugPrint('⚠️ 文件路径格式的图片暂不支持: $imageUrl');
          } else {
            // 假设是URL或base64字符串
            contentItems.add(
              OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                imageUrl,
              ),
            );
          }
        }
      }

      // 仅在存在内容项时才追加，避免空 content 触发下游错误
      if (contentItems.isNotEmpty) {
        hasContentMessage = true;
        openAIMessages.add(
          OpenAIChatCompletionChoiceMessageModel(
            role: message.isFromUser
                ? OpenAIChatMessageRole.user
                : OpenAIChatMessageRole.assistant,
            content: contentItems,
          ),
        );
      }
    }

    // 若最终没有任何有效内容消息，补一条最小用户消息作为兜底
    if (!hasContentMessage) {
      openAIMessages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              (systemPrompt != null && systemPrompt.isNotEmpty)
                  ? systemPrompt
                  : '请根据系统指令继续回答。',
            ),
          ],
        ),
      );
    }

    // 强化保障：确保最后一条是当前用户输入（部分网关更依赖最后一条 user 内容）
    final ChatMessage lastUserInput = messages.lastWhere(
      (m) => m.isFromUser,
      orElse: () => ChatMessage(
        id: 'fallback',
        content: '',
        isFromUser: true,
        timestamp: DateTime.now(),
        chatSessionId: 'fallback',
      ),
    );
    final latestUserText = (lastUserInput.content).trim();
    if (latestUserText.isNotEmpty) {
      openAIMessages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              latestUserText,
            ),
          ],
        ),
      );
    }

    return openAIMessages;
  }

  // 工具调用功能暂时移除，等待OpenAI包API稳定

  /// 转换完成原因
  FinishReason _convertFinishReason(String? reason) {
    switch (reason) {
      case 'stop':
        return FinishReason.stop;
      case 'length':
        return FinishReason.length;
      case 'content_filter':
        return FinishReason.contentFilter;
      case 'tool_calls':
        return FinishReason.toolCalls;
      default:
        return FinishReason.stop;
    }
  }

  // 辅助方法已移除，因为现在使用预定义的模型列表

  /// 处理OpenAI错误
  AppException _handleOpenAIError(dynamic error) {
    final errorMessage = error.toString();
    debugPrint('🔍 OpenAI错误详情: $errorMessage');

    // NoSuchMethodError - 通常是API响应格式问题
    if (errorMessage.contains('NoSuchMethodError')) {
      return ApiException('API响应格式异常，可能是OpenAI API版本不兼容或响应数据为空');
    }

    // 网络连接错误
    if (errorMessage.contains('SocketException')) {
      return NetworkException('网络连接失败，请检查网络设置或API服务地址是否正确');
    }

    // 超时错误
    if (errorMessage.contains('TimeoutException') ||
        errorMessage.contains('超时')) {
      return NetworkException('请求超时，请检查网络连接或稍后重试');
    }

    // API认证错误
    if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
      return ApiException.invalidApiKey();
    }

    // 速率限制错误
    if (errorMessage.contains('429') || errorMessage.contains('rate limit')) {
      return ApiException.rateLimitExceeded();
    }

    // 配额超限错误
    if (errorMessage.contains('402') || errorMessage.contains('quota')) {
      return ApiException.quotaExceeded();
    }

    // 404错误 - API端点不存在
    if (errorMessage.contains('404')) {
      return ApiException(
        'API端点不存在，请检查baseUrl配置是否正确。\n'
        '提示：NewAPI等第三方网关的baseUrl应该类似：http://your-host（不要包含/v1）'
      );
    }

    // 500系列服务器错误
    if (errorMessage.contains('500') ||
        errorMessage.contains('502') ||
        errorMessage.contains('503') ||
        errorMessage.contains('504')) {
      return ApiException('OpenAI服务器错误，请稍后重试');
    }

    return ApiException('OpenAI请求失败: $errorMessage');
  }
}
