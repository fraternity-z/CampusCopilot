import 'dart:async';
import 'dart:convert' show json;

import 'package:openai_dart/openai_dart.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// OpenAI LLM Provider实现
///
/// 使用openai_dart包实现与OpenAI API的交互
class OpenAiLlmProvider extends LlmProvider {
  late final OpenAIClient _client;
  
  OpenAiLlmProvider(super.config) {
    _initializeOpenAI();
  }

  @override
  String get providerName => 'OpenAI';

  /// 初始化OpenAI配置
  void _initializeOpenAI() {
    String? baseUrl = config.baseUrl;
    
    if (baseUrl != null) {
      // 修复baseUrl重复/v1的问题
      String cleanBaseUrl = baseUrl.trim();
      
      // 移除末尾的斜杠
      if (cleanBaseUrl.endsWith('/')) {
        cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
      }
      
      // 确保以/v1结尾，因为openai_dart需要完整的URL
      if (!cleanBaseUrl.endsWith('/v1')) {
        cleanBaseUrl += '/v1';
      }
      
      baseUrl = cleanBaseUrl;
      debugPrint('🔧 设置OpenAI baseUrl: $baseUrl (原始: ${config.baseUrl})');
    }

    _client = OpenAIClient(
      apiKey: config.apiKey,
      baseUrl: baseUrl,
      organization: config.organizationId,
    );
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
      final response = await _client.listModels();
      final models = response.data;

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
          supportsVision: true, // 支持视觉功能
          supportsFunctionCalling: true,
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
      
      final model = options?.model ?? config.defaultModel ?? 'gpt-3.5-turbo';
      
      // 转换工具函数
      List<ChatCompletionTool>? tools;
      if (options?.tools != null && options!.tools!.isNotEmpty) {
        tools = _convertToOpenAITools(options.tools!);
        debugPrint('🔧 转换后的工具函数数量: ${tools.length}');
        for (final tool in tools) {
          debugPrint('🔧 工具函数: ${tool.function.name} - ${tool.function.description}');
        }
      }

      final request = CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(model),
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences != null 
            ? ChatCompletionStop.listString(options!.stopSequences!) 
            : null,
        // 添加工具函数支持
        tools: tools,
      );

      final chatCompletion = await _client.createChatCompletion(request: request);

      if (chatCompletion.choices.isEmpty) {
        throw ApiException('OpenAI API返回了空的选择列表');
      }

      final choice = chatCompletion.choices.first;
      final usage = chatCompletion.usage;

      // 保存完整的原始内容
      final originalContent = choice.message.content ?? '';

      debugPrint('🧠 接收完整响应内容: 长度=${originalContent.length}');
      debugPrint('🧠 完成原因: ${choice.finishReason?.name}');
      
      // 处理工具调用
      final toolCalls = _convertToToolCalls(choice.message.toolCalls);
      if (toolCalls.isNotEmpty) {
        debugPrint('🔧 检测到 ${toolCalls.length} 个工具调用');
        for (final call in toolCalls) {
          debugPrint('🔧 工具调用: ${call.name} (${call.id})');
          debugPrint('🔧 参数: ${call.arguments}');
        }
      } else if (choice.message.toolCalls?.isNotEmpty == true) {
        debugPrint('⚠️ 原始工具调用存在但转换后为空: ${choice.message.toolCalls?.length}');
      }
      
      return ChatResult(
        content: originalContent, // 保存完整内容，UI层面分离显示
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: usage?.promptTokens ?? 0,
          outputTokens: usage?.completionTokens ?? 0,
          totalTokens: usage?.totalTokens ?? 0,
        ),
        finishReason: _convertFinishReason(choice.finishReason?.name),
        toolCalls: toolCalls, // 添加工具调用结果
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
      
      // 转换工具函数
      List<ChatCompletionTool>? tools;
      if (options?.tools != null && options!.tools!.isNotEmpty) {
        tools = _convertToOpenAITools(options.tools!);
        debugPrint('🔧 流式响应 - 转换后的工具函数数量: ${tools.length}');
      }

      final request = CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(model),
        messages: openAIMessages,
        temperature: options?.temperature ?? 0.7,
        maxTokens: options?.maxTokens ?? 2048,
        frequencyPenalty: options?.frequencyPenalty ?? 0.0,
        presencePenalty: options?.presencePenalty ?? 0.0,
        stop: options?.stopSequences != null 
            ? ChatCompletionStop.listString(options!.stopSequences!) 
            : null,
        // 添加工具函数支持
        tools: tools,
        stream: true,
      );

      final stream = _client.createChatCompletionStream(request: request);

      String accumulatedContent = ''; // 累积完整原始内容
      List<ToolCall> accumulatedToolCalls = []; // 累积工具调用

      await for (final chunk in stream) {
        if (chunk.choices?.isEmpty ?? true) continue;

        final choice = chunk.choices!.first;
        final delta = choice.delta;

        // 处理内容增量
        final deltaContent = delta?.content;
        if (deltaContent != null && deltaContent.isNotEmpty) {
          accumulatedContent += deltaContent;

          yield StreamedChatResult(
            delta: deltaContent,
            content: accumulatedContent, // 保存完整内容
            isDone: false,
            model: model,
          );
        }

        // 处理工具调用增量（流式响应中工具调用通常在最后一个chunk中）
        if (delta?.toolCalls != null && delta!.toolCalls!.isNotEmpty) {
          final deltaToolCalls = _convertStreamToolCalls(delta.toolCalls!);
          if (deltaToolCalls.isNotEmpty) {
            // 流式响应中工具调用通常是完整的，直接设置
            accumulatedToolCalls.addAll(deltaToolCalls);
          }
        }

        if (choice.finishReason != null) {
          debugPrint('🧠 流式响应完成: 内容长度=${accumulatedContent.length}, 工具调用=${accumulatedToolCalls.length}');

          yield StreamedChatResult(
            content: accumulatedContent, // 保存完整内容，UI层面分离显示
            isDone: true,
            model: model,
            tokenUsage: TokenUsage(
              inputTokens: 0, // 流式响应中无法准确获取
              outputTokens: accumulatedContent.split(' ').length,
              totalTokens: accumulatedContent.split(' ').length,
            ),
            finishReason: _convertFinishReason(choice.finishReason?.name),
            toolCalls: accumulatedToolCalls.isNotEmpty ? accumulatedToolCalls : null, // 添加工具调用
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

      final request = CreateEmbeddingRequest(
        model: EmbeddingModel.modelId(model),
        input: EmbeddingInput.listString(texts),
      );

      final embedding = await _client.createEmbedding(request: request)
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
        // 根据文档，应该使用 embeddingVector 而不是 embedding
        final embeddingVector = item.embeddingVector;
        if (embeddingVector.isNotEmpty) {
          embeddings.add(embeddingVector);
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
      await _client.listModels();
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
    _client.endSession();
  }

  /// 转换为OpenAI消息格式
  List<ChatCompletionMessage> _convertToOpenAIMessages(
    List<ChatMessage> messages,
    String? systemPrompt,
  ) {
    final openAIMessages = <ChatCompletionMessage>[];

    // 添加系统提示词（放在最前）
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      openAIMessages.add(
        ChatCompletionMessage.system(
          content: systemPrompt,
        ),
      );
    }

    // 转换聊天消息
    for (final message in messages) {
      if (message.content.isEmpty && message.imageUrls.isEmpty) {
        continue; // 跳过空消息
      }

      if (message.imageUrls.isNotEmpty) {
        // 多模态消息（文本 + 图片）
        final contentParts = <ChatCompletionMessageContentPart>[];
        
        // 添加文本内容
        if (message.content.isNotEmpty) {
          contentParts.add(
            ChatCompletionMessageContentPart.text(text: message.content),
          );
        }
        
        // 添加图片内容
        for (final imageUrl in message.imageUrls) {
          if (imageUrl.startsWith('data:image/') || imageUrl.startsWith('http')) {
            contentParts.add(
              ChatCompletionMessageContentPart.image(
                imageUrl: ChatCompletionMessageImageUrl(
                  url: imageUrl,
                ),
              ),
            );
          } else {
            debugPrint('⚠️ 不支持的图片格式: $imageUrl');
          }
        }
        
        if (contentParts.isNotEmpty) {
          openAIMessages.add(
            message.isFromUser
                ? ChatCompletionMessage.user(
                    content: ChatCompletionUserMessageContent.parts(contentParts),
                  )
                : ChatCompletionMessage.assistant(
                    content: message.content,
                  ),
          );
        }
      } else {
        // 纯文本消息
        openAIMessages.add(
          message.isFromUser
              ? ChatCompletionMessage.user(
                  content: ChatCompletionUserMessageContent.string(message.content),
                )
              : ChatCompletionMessage.assistant(
                  content: message.content,
                ),
        );
      }
    }

    // 如果没有有效消息，添加一个默认消息
    if (openAIMessages.isEmpty ||
        openAIMessages.every((m) => m.role == ChatCompletionMessageRole.system)) {
      openAIMessages.add(
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(
            systemPrompt?.isNotEmpty == true
                ? '请根据上述系统指令回答。'
                : '你好！',
          ),
        ),
      );
    }

    return openAIMessages;
  }

  /// 将ToolDefinition转换为OpenAI工具格式
  List<ChatCompletionTool> _convertToOpenAITools(List<ToolDefinition> tools) {
    return tools.map((tool) {
      return ChatCompletionTool(
        type: ChatCompletionToolType.function,
        function: FunctionObject(
          name: tool.name,
          description: tool.description,
          parameters: tool.parameters,
        ),
      );
    }).toList();
  }

  /// 将OpenAI工具调用转换为ToolCall格式（非流式）
  List<ToolCall> _convertToToolCalls(List<ChatCompletionMessageToolCall>? openAiToolCalls) {
    if (openAiToolCalls == null || openAiToolCalls.isEmpty) {
      return [];
    }

    return openAiToolCalls.map((toolCall) {
      // 解析函数参数
      Map<String, dynamic> arguments = {};
      try {
        final argumentsStr = toolCall.function.arguments;
        if (argumentsStr.isNotEmpty) {
          arguments = json.decode(argumentsStr) as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint('⚠️ 解析工具调用参数失败: $e, 原始参数: ${toolCall.function.arguments}');
        // 如果JSON解析失败，尝试作为字符串处理
        arguments = {'raw_arguments': toolCall.function.arguments};
      }

      debugPrint('🔧 转换工具调用: ${toolCall.function.name}, 参数: $arguments');

      return ToolCall(
        id: toolCall.id,
        name: toolCall.function.name,
        arguments: arguments,
      );
    }).toList();
  }

  /// 将流式工具调用转换为ToolCall格式
  List<ToolCall> _convertStreamToolCalls(List<ChatCompletionStreamMessageToolCallChunk>? toolCalls) {
    if (toolCalls == null || toolCalls.isEmpty) {
      return [];
    }
    
    // 过滤掉无效的工具调用（没有函数名或函数对象为空的）
    final validToolCalls = toolCalls.where((toolCall) {
      final hasValidName = toolCall.function?.name != null && 
                           toolCall.function!.name!.isNotEmpty;
      if (!hasValidName) {
        debugPrint('⚠️ 跳过无效的工具调用: id=${toolCall.id}, function=${toolCall.function}');
      }
      return hasValidName;
    }).toList();
    
    if (validToolCalls.isEmpty) {
      return [];
    }
    
    return validToolCalls.map((toolCall) {
      // 尝试解析参数
      Map<String, dynamic> arguments = {};
      try {
        final argumentsStr = toolCall.function?.arguments;
        if (argumentsStr != null && argumentsStr.isNotEmpty) {
          arguments = json.decode(argumentsStr) as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint('⚠️ 解析流式工具调用参数失败: $e, 原始参数: ${toolCall.function?.arguments}');
        // 如果JSON解析失败，尝试作为字符串处理
        arguments = {'raw_arguments': toolCall.function?.arguments ?? ''};
      }

      final functionName = toolCall.function!.name!;
      debugPrint('🔧 转换流式工具调用: $functionName, 参数: $arguments');

      return ToolCall(
        id: toolCall.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: functionName,
        arguments: arguments,
      );
    }).toList();
  }

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
