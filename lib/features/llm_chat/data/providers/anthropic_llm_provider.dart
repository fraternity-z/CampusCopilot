import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class AnthropicLlmProvider implements LlmProvider {
  static final Map<String, http.Client> _clientPool = {};
  @override
  final LlmConfig config;
  late final http.Client _httpClient;
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const String _anthropicVersion = '2023-06-01';

  AnthropicLlmProvider(this.config) {
    if (config.apiKey.isEmpty) {
      throw ApiException('Anthropic API key is not configured.');
    }
    _httpClient = _clientPool.putIfAbsent(config.apiKey, () => http.Client());
  }

  @override
  String get providerName => "Anthropic";

  @override
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async {
    try {
      final requestBody = _prepareRequest(messages, options);
      final response = await _makeRequest('/messages', requestBody);
      return _mapResponseToChatResult(response);
    } catch (e) {
      throw ApiException('Failed to generate chat with Anthropic Claude: $e');
    }
  }

  @override
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async* {
    try {
      final requestBody = _prepareRequest(messages, options, stream: true);
      final streamController = StreamController<StreamedChatResult>();

      _makeStreamRequest('/messages', requestBody, streamController);

      yield* streamController.stream;
    } catch (e) {
      throw ApiException(
        'Failed to generate chat stream with Anthropic Claude: $e',
      );
    }
  }

  @override
  Future<EmbeddingResult> generateEmbeddings(List<String> texts) {
    throw UnsupportedError("Anthropic does not support text embeddings.");
  }

  @override
  Future<List<ModelInfo>> listModels() async {
    return [
      const ModelInfo(
        id: "claude-3-opus-20240229",
        name: "Claude 3 Opus",
        type: ModelType.chat,
        supportsVision: true,
      ),
      const ModelInfo(
        id: "claude-3-sonnet-20240229",
        name: "Claude 3 Sonnet",
        type: ModelType.chat,
        supportsVision: true,
      ),
      const ModelInfo(
        id: "claude-3-haiku-20240307",
        name: "Claude 3 Haiku",
        type: ModelType.chat,
        supportsVision: true,
      ),
    ];
  }

  @override
  Future<bool> validateConfig() async {
    try {
      final requestBody = {
        'model': 'claude-3-haiku-20240307',
        'messages': [
          {'role': 'user', 'content': 'test'},
        ],
        'max_tokens': 1,
      };

      await _makeRequest('/messages', requestBody);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  int estimateTokens(String text) {
    return (text.length / 4).round();
  }

  @override
  void dispose() {
    // 使用连接池，不在此处关闭客户端
  }

  /// 关闭并清理所有共享的 http.Client
  static void disposeAllClients() {
    for (final client in _clientPool.values) {
      client.close();
    }
    _clientPool.clear();
  }

  Map<String, dynamic> _prepareRequest(
    List<ChatMessage> messages,
    ChatOptions? options, {
    bool stream = false,
  }) {
    final modelName =
        options?.model ?? config.defaultModel ?? "claude-3-sonnet-20240229";

    final anthropicMessages = messages.map((m) {
      // For simple text content
      if (m.imageUrls.isEmpty) {
        return {
          'role': m.isFromUser ? 'user' : 'assistant',
          'content': m.content,
        };
      }

      // For mixed content (text + images)
      final contentBlocks = <Map<String, dynamic>>[];

      if (m.content.isNotEmpty) {
        contentBlocks.add({'type': 'text', 'text': m.content});
      }

      for (final url in m.imageUrls) {
        final parts = url.split(',');
        if (parts.length == 2) {
          final mediaType = parts[0].split(';')[0].split(':')[1];
          final data = parts[1];
          contentBlocks.add({
            'type': 'image',
            'source': {'type': 'base64', 'media_type': mediaType, 'data': data},
          });
        }
      }

      return {
        'role': m.isFromUser ? 'user' : 'assistant',
        'content': contentBlocks,
      };
    }).toList();

    final request = {
      'model': modelName,
      'messages': anthropicMessages,
      'max_tokens': options?.maxTokens ?? 4096,
    };

    if (options?.temperature != null) {
      request['temperature'] = options!.temperature!;
    }

    if (stream) {
      request['stream'] = true;
    }

    return request;
  }

  Future<Map<String, dynamic>> _makeRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'x-api-key': config.apiKey,
      'anthropic-version': _anthropicVersion,
    };

    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(
        'Anthropic API request failed: ${response.statusCode} - ${response.body}',
      );
    }
  }

  void _makeStreamRequest(
    String endpoint,
    Map<String, dynamic> body,
    StreamController<StreamedChatResult> controller,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        'x-api-key': config.apiKey,
        'anthropic-version': _anthropicVersion,
        'Accept': 'text/event-stream',
      };

      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      request.body = json.encode(body);

      final streamedResponse = await _httpClient.send(request);

      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(
          utf8.decoder,
        )) {
          final lines = chunk.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data.trim() == '[DONE]') {
                controller.add(
                  const StreamedChatResult(
                    delta: '',
                    isDone: true,
                    tokenUsage: TokenUsage(
                      inputTokens: 0,
                      outputTokens: 0,
                      totalTokens: 0,
                    ),
                  ),
                );
                controller.close();
                return;
              }

              try {
                final eventData = json.decode(data) as Map<String, dynamic>;
                final eventType = eventData['type'] as String?;

                if (eventType == 'content_block_delta') {
                  final delta = eventData['delta'] as Map<String, dynamic>?;
                  if (delta != null && delta['type'] == 'text_delta') {
                    final text = delta['text'] as String? ?? '';
                    controller.add(
                      StreamedChatResult(delta: text, isDone: false),
                    );
                  }
                }
              } catch (e) {
                // Ignore parsing errors for individual events
              }
            }
          }
        }
      } else {
        controller.addError(
          ApiException(
            'Anthropic API stream request failed: ${streamedResponse.statusCode}',
          ),
        );
      }
    } catch (e) {
      controller.addError(e);
    } finally {
      controller.close();
    }
  }

  ChatResult _mapResponseToChatResult(Map<String, dynamic> response) {
    final finishReason = _mapFinishReason(response['stop_reason'] as String?);

    String textContent = '';
    final content = response['content'] as List<dynamic>?;
    if (content != null && content.isNotEmpty) {
      for (final block in content) {
        if (block is Map<String, dynamic> &&
            block['type'] == 'text' &&
            block['text'] != null) {
          textContent = block['text'] as String;
          break;
        }
      }
    }

    final usage = response['usage'] as Map<String, dynamic>?;
    final inputTokens = usage?['input_tokens'] as int? ?? 0;
    final outputTokens = usage?['output_tokens'] as int? ?? 0;

    return ChatResult(
      content: textContent,
      finishReason: finishReason,
      tokenUsage: TokenUsage(
        inputTokens: inputTokens,
        outputTokens: outputTokens,
        totalTokens: inputTokens + outputTokens,
      ),
      model: response['model'] as String? ?? '',
    );
  }

  FinishReason _mapFinishReason(String? reason) {
    switch (reason) {
      case 'end_turn':
        return FinishReason.stop;
      case 'max_tokens':
        return FinishReason.length;
      case 'stop_sequence':
        return FinishReason.stop;
      default:
        return FinishReason.stop;
    }
  }
}
