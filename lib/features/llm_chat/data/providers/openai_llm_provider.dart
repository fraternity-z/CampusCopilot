import 'dart:async';

import 'package:dart_openai/dart_openai.dart';

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
      OpenAI.baseUrl = config.baseUrl!;
    }

    if (config.organizationId != null) {
      OpenAI.organization = config.organizationId;
    }
  }

  @override
  Future<List<ModelInfo>> listModels() async {
    try {
      // 返回预定义的模型列表，避免API调用问题
      return [
        const ModelInfo(
          id: 'gpt-3.5-turbo',
          name: 'GPT-3.5 Turbo',
          type: ModelType.chat,
          contextWindow: 4096,
          supportsStreaming: true,
          supportsFunctionCalling: true,
        ),
        const ModelInfo(
          id: 'gpt-4',
          name: 'GPT-4',
          type: ModelType.chat,
          contextWindow: 8192,
          supportsStreaming: true,
          supportsFunctionCalling: true,
        ),
        const ModelInfo(
          id: 'text-embedding-3-small',
          name: 'Text Embedding 3 Small',
          type: ModelType.embedding,
          contextWindow: 8191,
          supportsStreaming: false,
          supportsFunctionCalling: false,
        ),
      ];
    } catch (e) {
      throw ApiException('获取模型列表失败: ${e.toString()}');
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
      final model = options?.model ?? config.defaultModel ?? 'gpt-3.5-turbo';

      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        topP: options?.topP ?? 1.0,
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences,
        // 暂时移除工具调用功能
        // tools: options?.tools?.map(_convertToOpenAITool).toList(),
      );

      final choice = chatCompletion.choices.first;
      final usage = chatCompletion.usage;

      return ChatResult(
        content: choice.message.content?.first.text ?? '',
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
      final model = options?.model ?? config.defaultModel ?? 'gpt-3.5-turbo';

      final stream = OpenAI.instance.chat.createStream(
        model: model,
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        topP: options?.topP ?? 1.0,
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences,
        // 暂时移除工具调用功能
        // tools: options?.tools?.map(_convertToOpenAITool).toList(),
      );

      String accumulatedContent = '';

      await for (final chunk in stream) {
        final choice = chunk.choices.first;
        final delta = choice.delta;

        if (delta.content != null && delta.content!.isNotEmpty) {
          final OpenAIChatCompletionChoiceMessageContentItemModel?
          firstContent = delta.content!.first;
          final String? deltaText = firstContent?.text;
          if (deltaText != null && deltaText.isNotEmpty) {
            accumulatedContent += deltaText;

            yield StreamedChatResult(
              delta: deltaText,
              content: accumulatedContent,
              isDone: false,
              model: model,
            );
          }
        }

        if (choice.finishReason != null) {
          // OpenAI流式响应中usage信息可能不可用，使用默认值
          yield StreamedChatResult(
            content: accumulatedContent,
            isDone: true,
            model: model,
            tokenUsage: TokenUsage(
              inputTokens: 0, // 流式响应中无法准确获取
              outputTokens: accumulatedContent.split(' ').length,
              totalTokens: accumulatedContent.split(' ').length,
            ),
            finishReason: _convertFinishReason(choice.finishReason),
            // 暂时移除工具调用功能
            // toolCalls: delta.toolCalls?.map(_convertToolCall).toList(),
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

      final embedding = await OpenAI.instance.embedding.create(
        model: model,
        input: texts,
      );

      return EmbeddingResult(
        embeddings: embedding.data.map((e) => e.embeddings).toList(),
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: embedding.usage?.promptTokens ?? 0,
          outputTokens: 0,
          totalTokens: embedding.usage?.totalTokens ?? 0,
        ),
      );
    } catch (e) {
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

    // 添加系统提示词
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

    // 转换聊天消息
    for (final message in messages) {
      openAIMessages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: message.isFromUser
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              message.content,
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
    // 简化错误处理，因为OpenAI包的异常类型可能不稳定
    final errorMessage = error.toString();

    if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
      return ApiException.invalidApiKey();
    } else if (errorMessage.contains('429') ||
        errorMessage.contains('rate limit')) {
      return ApiException.rateLimitExceeded();
    } else if (errorMessage.contains('402') || errorMessage.contains('quota')) {
      return ApiException.quotaExceeded();
    }
    return ApiException('未知错误: ${error.toString()}');
  }
}
