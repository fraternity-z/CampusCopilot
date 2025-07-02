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
      OpenAI.baseUrl = config.baseUrl!;
    }

    if (config.organizationId != null) {
      OpenAI.organization = config.organizationId;
    }
  }

  @override
  Future<List<ModelInfo>> listModels() async {
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

      return result;
    } catch (_) {
      // 返回预定义的少量静态模型作为兜底
      return [
        const ModelInfo(
          id: 'gpt-3.5-turbo',
          name: 'gpt-3.5-turbo',
          type: ModelType.chat,
          supportsStreaming: true,
        ),
        const ModelInfo(
          id: 'gpt-4o',
          name: 'gpt-4o',
          type: ModelType.chat,
          supportsStreaming: true,
        ),
        const ModelInfo(
          id: 'text-embedding-3-small',
          name: 'text-embedding-3-small',
          type: ModelType.embedding,
          supportsStreaming: false,
        ),
      ];
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

      // 提取思考链内容
      String? thinkingContent = _extractThinkingContent(chatCompletion, model);

      return ChatResult(
        content: choice.message.content?.first.text ?? '',
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: usage.promptTokens,
          outputTokens: usage.completionTokens,
          totalTokens: usage.totalTokens,
        ),
        finishReason: _convertFinishReason(choice.finishReason),
        thinkingContent: thinkingContent,
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
      String accumulatedThinking = '';

      await for (final chunk in stream) {
        final choice = chunk.choices.first;
        final delta = choice.delta;

        // 处理思考链增量内容
        String? thinkingDelta = _extractThinkingDelta(chunk, model);
        if (thinkingDelta != null && thinkingDelta.isNotEmpty) {
          accumulatedThinking += thinkingDelta;

          yield StreamedChatResult(
            thinkingDelta: thinkingDelta,
            thinkingContent: accumulatedThinking,
            isDone: false,
            model: model,
          );
        }

        // 处理主要内容
        if (delta.content != null && delta.content!.isNotEmpty) {
          final OpenAIChatCompletionChoiceMessageContentItemModel?
          firstContent = delta.content!.first;
          final String? deltaText = firstContent?.text;
          if (deltaText != null && deltaText.isNotEmpty) {
            accumulatedContent += deltaText;

            yield StreamedChatResult(
              delta: deltaText,
              content: accumulatedContent,
              thinkingContent: accumulatedThinking.isNotEmpty
                  ? accumulatedThinking
                  : null,
              isDone: false,
              model: model,
            );
          }
        }

        if (choice.finishReason != null) {
          // OpenAI流式响应中usage信息可能不可用，使用默认值
          yield StreamedChatResult(
            content: accumulatedContent,
            thinkingContent: accumulatedThinking.isNotEmpty
                ? accumulatedThinking
                : null,
            thinkingComplete: true,
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

  /// 提取思考链内容
  String? _extractThinkingContent(dynamic completion, String model) {
    // 不同模型的思考链提取逻辑
    if (_isThinkingModel(model)) {
      try {
        // 尝试从响应中提取思考链内容
        if (completion is Map<String, dynamic>) {
          // DeepSeek R1格式：reasoning_content
          if (completion.containsKey('reasoning_content')) {
            return completion['reasoning_content'] as String?;
          }

          // 检查choices中的reasoning内容
          final choices = completion['choices'] as List?;
          if (choices != null && choices.isNotEmpty) {
            final firstChoice = choices.first as Map<String, dynamic>;

            // DeepSeek格式
            if (firstChoice.containsKey('reasoning_content')) {
              return firstChoice['reasoning_content'] as String?;
            }

            // 检查message中的reasoning
            final message = firstChoice['message'] as Map<String, dynamic>?;
            if (message != null) {
              if (message.containsKey('reasoning_content')) {
                return message['reasoning_content'] as String?;
              }
              if (message.containsKey('reasoning')) {
                return message['reasoning'] as String?;
              }
            }
          }
        }
      } catch (e) {
        debugPrint('提取思考链内容时出错: $e');
      }
    }

    return null;
  }

  /// 提取思考链增量内容（用于流式响应）
  String? _extractThinkingDelta(dynamic chunk, String model) {
    if (!_isThinkingModel(model)) return null;

    try {
      // 尝试从流式响应中提取思考链增量
      if (chunk is Map<String, dynamic>) {
        final choices = chunk['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final firstChoice = choices.first as Map<String, dynamic>;

          // 检查delta中的reasoning内容
          final delta = firstChoice['delta'] as Map<String, dynamic>?;
          if (delta != null) {
            // DeepSeek R1格式
            if (delta.containsKey('reasoning_content')) {
              return delta['reasoning_content'] as String?;
            }
            if (delta.containsKey('reasoning')) {
              return delta['reasoning'] as String?;
            }
          }

          // 某些API可能直接在choice层级返回reasoning
          if (firstChoice.containsKey('reasoning_content')) {
            return firstChoice['reasoning_content'] as String?;
          }
        }
      }
    } catch (e) {
      debugPrint('提取思考链增量内容时出错: $e');
    }

    return null;
  }

  /// 判断是否为思考模型
  bool _isThinkingModel(String model) {
    final thinkingModels = {
      // OpenAI o系列
      'o1', 'o1-preview', 'o1-mini', 'o3', 'o3-mini',
      // DeepSeek思考模型
      'deepseek-reasoner', 'deepseek-r1',
      // Gemini思考模型
      'gemini-2.0-flash-thinking', 'gemini-2.5-flash:thinking',
    };

    return thinkingModels.any(
      (thinking) => model.toLowerCase().contains(thinking.toLowerCase()),
    );
  }

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
