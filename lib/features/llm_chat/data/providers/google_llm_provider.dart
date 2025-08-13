import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class GoogleLlmProvider extends LlmProvider {
  // 使用惰性初始化，避免在未使用时提前创建模型实例
  google_ai.GenerativeModel? _embeddingModel;

  late final String _baseUrl;

  GoogleLlmProvider(super.config) {
    if (config.apiKey.isEmpty) {
      throw ApiException('Google API key is not configured.');
    }
    _baseUrl =
        config.baseUrl ?? 'https://generativelanguage.googleapis.com/v1beta';
  }

  @override
  String get providerName => 'Google';

  @override
  Future<List<ModelInfo>> listModels() async {
    try {
      // 尝试通过REST API获取模型列表
      final response = await http.get(
        Uri.parse('$_baseUrl/models?key=${config.apiKey}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final models = <ModelInfo>[];

        if (data['models'] != null) {
          for (final model in data['models']) {
            final modelName = model['name'] as String? ?? '';
            final displayName = model['displayName'] as String? ?? modelName;

            // 只包含生成模型，排除嵌入模型
            if (modelName.contains('generateContent') ||
                modelName.contains('models/gemini')) {
              final modelId = modelName.replaceAll('models/', '');
              models.add(
                ModelInfo(
                  id: modelId,
                  name: displayName.isNotEmpty ? displayName : modelId,
                  type: ModelType.chat,
                  supportsStreaming: true,
                  supportsVision:
                      modelId.contains('vision') || modelId.contains('1.5'),
                  supportsFunctionCalling: true,
                ),
              );
            }
          }
        }

        // 如果API返回的模型列表不为空，返回API结果
        if (models.isNotEmpty) {
          return models;
        }
      }
    } catch (e) {
      debugPrint('获取Gemini模型列表失败，使用预定义列表: $e');
    }

    // 回退到预定义模型列表
    return [
      const ModelInfo(
        id: 'gemini-pro',
        name: 'Gemini Pro',
        type: ModelType.chat,
        contextWindow: 30720,
        maxOutputTokens: 2048,
        supportsStreaming: true,
        supportsVision: false,
        supportsFunctionCalling: true,
      ),
      const ModelInfo(
        id: 'gemini-1.5-pro-latest',
        name: 'Gemini 1.5 Pro',
        type: ModelType.chat,
        contextWindow: 1000000,
        maxOutputTokens: 8192,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: true,
      ),
      const ModelInfo(
        id: 'gemini-1.5-flash-latest',
        name: 'Gemini 1.5 Flash',
        type: ModelType.chat,
        contextWindow: 1000000,
        maxOutputTokens: 8192,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: true,
      ),
      const ModelInfo(
        id: 'gemini-pro-vision',
        name: 'Gemini Pro Vision',
        type: ModelType.multimodal,
        contextWindow: 12288,
        maxOutputTokens: 4096,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: false,
      ),
    ];
  }

  @override
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async {
    try {
      final (model, content, modelName) = _prepareRequest(messages, options);
      // 顶层请求超时 + 重试兜底，避免偶发网络抖动导致首响应延迟过长
      final response = await _withRetry(() async {
        return await model
            .generateContent(content)
            .timeout(const Duration(seconds: 20));
      });

      return ChatResult(
        content: response.text ?? '',
        model: modelName,
        finishReason: _mapFinishReason(
          response.candidates.isNotEmpty
              ? response.candidates.first.finishReason
              : null,
        ),
        tokenUsage: TokenUsage(
          inputTokens: response.usageMetadata?.promptTokenCount ?? 0,
          outputTokens: response.usageMetadata?.candidatesTokenCount ?? 0,
          totalTokens: response.usageMetadata?.totalTokenCount ?? 0,
        ),
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) {
    try {
      final (model, content, modelName) = _prepareRequest(messages, options);
      // 注意：SDK流式API未提供超时参数，这里不包裹整体超时，避免中途断流；
      // 由上层chat_service已有整体策略控制。
      return model.generateContentStream(content).map((response) {
        return StreamedChatResult(
          delta: response.text ?? '',
          content: response.text,
          isDone: response.candidates.isNotEmpty,
          model: modelName,
          finishReason: _mapFinishReason(
            response.candidates.isNotEmpty
                ? response.candidates.first.finishReason
                : null,
          ),
          tokenUsage: TokenUsage(
            inputTokens: response.usageMetadata?.promptTokenCount ?? 0,
            outputTokens: response.usageMetadata?.candidatesTokenCount ?? 0,
            totalTokens: response.usageMetadata?.totalTokenCount ?? 0,
          ),
        );
      });
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<EmbeddingResult> generateEmbeddings(List<String> texts) async {
    try {
      final requests = texts
          .map(
            (text) =>
                google_ai.EmbedContentRequest(google_ai.Content.text(text)),
          )
          .toList();
      final response = await _withRetry(() async {
        return await _getEmbeddingModel().batchEmbedContents(requests);
      });
      return EmbeddingResult(
        embeddings: response.embeddings.map((e) => e.values).toList(),
        model: config.defaultEmbeddingModel ?? 'embedding-001',
        tokenUsage: const TokenUsage(
          inputTokens: 0,
          outputTokens: 0,
          totalTokens: 0,
        ), // Not provided by API
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<bool> validateConfig() async {
    try {
      await listModels();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  int estimateTokens(String text) {
    // This is a rough estimation.
    // For a more accurate count, you might need to use a tokenizer package
    // or make an API call to `countTokens`.
    return text.length ~/ 4;
  }

  @override
  void dispose() {
    // No resources to dispose
  }

  // ========= 惰性获取各类型模型 =========

  google_ai.GenerativeModel _getEmbeddingModel() =>
      _embeddingModel ??= google_ai.GenerativeModel(
        model: config.defaultEmbeddingModel ?? 'embedding-001',
        apiKey: config.apiKey,
      );

  (google_ai.GenerativeModel, List<google_ai.Content>, String) _prepareRequest(
    List<ChatMessage> messages,
    ChatOptions? options,
  ) {
    final bool hasImages = messages.any((m) => m.imageUrls.isNotEmpty);
    final String modelName = hasImages
        ? 'gemini-pro-vision'
        : (options?.model ?? config.defaultModel ?? 'gemini-pro');

    // 为包含 system 指令的场景构建带 systemInstruction 的模型实例
    google_ai.GenerativeModel model = google_ai.GenerativeModel(
      model: modelName,
      apiKey: config.apiKey,
      systemInstruction:
          (options?.systemPrompt != null &&
              options!.systemPrompt!.trim().isNotEmpty)
          ? google_ai.Content.text(options.systemPrompt!.trim())
          : null,
    );

    final List<google_ai.Content> content = [];
    for (final m in messages) {
      final text = m.content.trim();
      final images = m.imageUrls;
      if (images.isNotEmpty) {
        // 兼容 file:// / http(s):// / data:，无法获取字节时降级为文本占位
        final parts = <google_ai.Part>[];
        for (final url in images) {
          try {
            final uri = Uri.parse(url);
            if (uri.scheme == 'data' && uri.data != null) {
              parts.add(
                google_ai.DataPart('image/*', uri.data!.contentAsBytes()),
              );
            } else {
              // 无法直接读取字节，降级为文本提示，避免空 contents 触发 400
              parts.add(
                google_ai.TextPart(
                  '[image:${uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'inline'}]',
                ),
              );
            }
          } catch (_) {
            parts.add(google_ai.TextPart('[image]'));
          }
        }
        if (text.isNotEmpty) {
          parts.add(google_ai.TextPart(text));
        }
        if (parts.isNotEmpty) {
          content.add(google_ai.Content.multi(parts));
        }
      } else if (text.isNotEmpty) {
        content.add(google_ai.Content.text(text));
      }
    }

    // 防御：若内容为空，填充最少一条文本，避免 "contents is not specified"
    if (content.isEmpty) {
      content.add(google_ai.Content.text('请根据以上上下文继续回答。'));
    }

    // Grounding 标记（若需要）
    final enableNative =
        options?.customParams?['enableModelNativeSearch'] == true;
    if (enableNative) {
      model = google_ai.GenerativeModel(
        model: modelName,
        apiKey: config.apiKey,
        systemInstruction:
            (options?.systemPrompt != null &&
                options!.systemPrompt!.trim().isNotEmpty)
            ? google_ai.Content.text(options.systemPrompt!.trim())
            : null,
      );
    }

    return (model, content, modelName);
  }

  FinishReason _mapFinishReason(google_ai.FinishReason? reason) {
    switch (reason) {
      case google_ai.FinishReason.stop:
        return FinishReason.stop;
      case google_ai.FinishReason.maxTokens:
        return FinishReason.length;
      case google_ai.FinishReason.safety:
      case google_ai.FinishReason.recitation:
        return FinishReason.contentFilter;
      default:
        return FinishReason.stop;
    }
  }

  ApiException _handleException(Object error) {
    if (error is ApiException) {
      return error;
    }
    final errorMessage = error.toString();
    if (errorMessage.contains('API_KEY_INVALID')) {
      return ApiException.invalidApiKey();
    } else if (errorMessage.contains('429')) {
      return ApiException.rateLimitExceeded();
    }
    return ApiException('Google Gemini API error: $errorMessage');
  }

  // ========== 通用重试封装（针对瞬时网络/服务错误） ==========
  Future<T> _withRetry<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } catch (e) {
        if (attempt >= maxRetries - 1 || !_isRetryable(e)) {
          rethrow;
        }
        final backoffMs = (200 * math.pow(2, attempt)).toInt();
        final jitter = math.Random().nextInt(150);
        await Future.delayed(Duration(milliseconds: backoffMs + jitter));
        attempt++;
      }
    }
  }

  bool _isRetryable(Object error) {
    final msg = error.toString();
    return msg.contains('429') ||
        msg.contains('rate limit') ||
        msg.contains('TimeoutException') ||
        msg.contains('SocketException') ||
        msg.contains('Connection reset') ||
        msg.contains('Connection closed') ||
        msg.contains('temporarily unavailable') ||
        msg.contains('500') ||
        msg.contains('502') ||
        msg.contains('503') ||
        msg.contains('504');
  }
}
