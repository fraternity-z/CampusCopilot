import 'dart:async';
import 'dart:math' as math;

import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class GoogleLlmProvider extends LlmProvider {
  // 使用惰性初始化，避免在未使用时提前创建模型实例
  google_ai.GenerativeModel? _model;
  google_ai.GenerativeModel? _visionModel;
  google_ai.GenerativeModel? _embeddingModel;

  GoogleLlmProvider(super.config) {
    if (config.apiKey.isEmpty) {
      throw ApiException('Google API key is not configured.');
    }
  }

  @override
  String get providerName => 'Google';

  @override
  Future<List<ModelInfo>> listModels() async {
    // Google AI for Dart SDK does not support listing models yet.
    // Return a predefined list of common models.
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
        id: 'gemini-pro-vision',
        name: 'Gemini Pro Vision',
        type: ModelType.multimodal,
        contextWindow: 12288,
        maxOutputTokens: 4096,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: false,
      ),
      const ModelInfo(
        id: 'embedding-001',
        name: 'Embedding 001',
        type: ModelType.embedding,
        contextWindow: 8192,
      ),
      const ModelInfo(
        id: 'text-embedding-004',
        name: 'Text Embedding 004',
        type: ModelType.embedding,
        contextWindow: 8192,
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
  google_ai.GenerativeModel _getChatModel() =>
      _model ??= google_ai.GenerativeModel(
        model: config.defaultModel ?? 'gemini-pro',
        apiKey: config.apiKey,
      );

  google_ai.GenerativeModel _getVisionModel() =>
      _visionModel ??= google_ai.GenerativeModel(
        model: 'gemini-pro-vision',
        apiKey: config.apiKey,
      );

  google_ai.GenerativeModel _getEmbeddingModel() =>
      _embeddingModel ??= google_ai.GenerativeModel(
        model: config.defaultEmbeddingModel ?? 'embedding-001',
        apiKey: config.apiKey,
      );

  (google_ai.GenerativeModel, List<google_ai.Content>, String) _prepareRequest(
    List<ChatMessage> messages,
    ChatOptions? options,
  ) {
    var hasImages = messages.any((m) => m.imageUrls.isNotEmpty);
    final model = hasImages ? _getVisionModel() : _getChatModel();
    final modelName = hasImages
        ? 'gemini-pro-vision'
        : (options?.model ?? config.defaultModel ?? 'gemini-pro');

    final content = messages.map((m) {
      if (m.imageUrls.isNotEmpty) {
        final List<google_ai.Part> parts = m.imageUrls
            .map(
              (url) => google_ai.DataPart(
                'image/jpeg',
                Uri.parse(url).data!.contentAsBytes(),
              ),
            )
            .toList();
        parts.add(google_ai.TextPart(m.content));
        return google_ai.Content.multi(parts);
      } else {
        return google_ai.Content.text(m.content);
      }
    }).toList();

    // 开启 Google Search Grounding（若 SDK/服务端支持）
    final enableNative =
        options?.customParams?['enableModelNativeSearch'] == true;
    if (enableNative) {
      // 目前 Dart SDK 未暴露直接开关，这里通过 model 实例的 safetySettings/工具占位
      // 若后续 SDK 提供 grounding 参数，请在此映射
      // 先添加一个标记，供上游/代理识别（如通过 baseUrl 代理到支持 Grounding 的服务）
      _model = google_ai.GenerativeModel(
        model: modelName,
        apiKey: config.apiKey,
        // 注：可在 extra params 里放置自定义 Header 由后端代理启用 Grounding
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
