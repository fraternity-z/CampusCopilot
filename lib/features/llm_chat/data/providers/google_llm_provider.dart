import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class GoogleLlmProvider extends LlmProvider {
  late final google_ai.GenerativeModel _model;
  late final google_ai.GenerativeModel _visionModel;
  late final google_ai.GenerativeModel _embeddingModel;

  GoogleLlmProvider(super.config) {
    if (config.apiKey.isEmpty) {
      throw ApiException('Google API key is not configured.');
    }
    _model = google_ai.GenerativeModel(
      model: config.defaultModel ?? 'gemini-pro',
      apiKey: config.apiKey,
    );
    _visionModel = google_ai.GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: config.apiKey,
    );
    _embeddingModel = google_ai.GenerativeModel(
      model: config.defaultEmbeddingModel ?? 'embedding-001',
      apiKey: config.apiKey,
    );
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
      final response = await model.generateContent(content);

      return ChatResult(
        content: response.text ?? '',
        model: modelName,
        finishReason: _mapFinishReason(response.candidates.first.finishReason),
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
      return model.generateContentStream(content).map((response) {
        return StreamedChatResult(
          delta: response.text ?? '',
          content: response.text,
          isDone: response.candidates.isNotEmpty,
          model: modelName,
          finishReason:
              _mapFinishReason(response.candidates.first.finishReason),
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
          .map((text) =>
              google_ai.EmbedContentRequest(google_ai.Content.text(text)))
          .toList();
      final response = await _embeddingModel.batchEmbedContents(requests);
      return EmbeddingResult(
        embeddings: response.embeddings.map((e) => e.values).toList(),
        model: config.defaultEmbeddingModel ?? 'embedding-001',
        tokenUsage: const TokenUsage(
            inputTokens: 0, outputTokens: 0, totalTokens: 0), // Not provided by API
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

  (google_ai.GenerativeModel, List<google_ai.Content>, String) _prepareRequest(
      List<ChatMessage> messages, ChatOptions? options) {
    var hasImages = messages.any((m) => m.imageUrls.isNotEmpty);
    final model = hasImages ? _visionModel : _model;
    final modelName = hasImages
        ? 'gemini-pro-vision'
        : (options?.model ?? config.defaultModel ?? 'gemini-pro');

    final content = messages.map((m) {
      if (m.imageUrls.isNotEmpty) {
        final List<google_ai.Part> parts = m.imageUrls
            .map((url) => google_ai.DataPart(
                'image/jpeg', Uri.parse(url).data!.contentAsBytes()))
            .toList();
        parts.add(google_ai.TextPart(m.content));
        return google_ai.Content.multi(parts);
      } else {
        return google_ai.Content.text(m.content);
      }
    }).toList();

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
}
