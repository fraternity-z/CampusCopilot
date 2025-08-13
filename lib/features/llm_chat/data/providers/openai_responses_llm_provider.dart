import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/providers/llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// OpenAI Responses API Provider（独立于传统 Chat Completions）
/// - 支持 tools:web_search（当 customParams.enableModelNativeSearch 为 true）
/// - 仅实现非流式 generateChat（后续可扩展 SSE 流式）
class OpenAiResponsesLlmProvider extends LlmProvider {
  OpenAiResponsesLlmProvider(super.config);

  @override
  String get providerName => 'OpenAI Responses';

  String get _baseUrl => (config.baseUrl?.isNotEmpty == true)
      ? config.baseUrl!
      : 'https://api.openai.com/v1';

  Uri get _responsesUri => Uri.parse('$_baseUrl/responses');

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Authorization': 'Bearer ${config.apiKey}',
      'Content-Type': 'application/json',
    };
    if (config.organizationId?.isNotEmpty == true) {
      headers['OpenAI-Organization'] = config.organizationId!;
    }
    return headers;
  }

  @override
  Future<List<ModelInfo>> listModels() async {
    try {
      // 尝试通过OpenAI Models API获取模型列表
      final response = await http
          .get(Uri.parse('$_baseUrl/models'), headers: _headers())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final models = <ModelInfo>[];

        if (data['data'] != null) {
          for (final model in data['data']) {
            final modelId = model['id'] as String? ?? '';

            // 只包含支持Responses API的模型
            if (_isResponsesCompatibleModel(modelId)) {
              models.add(
                ModelInfo(
                  id: modelId,
                  name: modelId,
                  type: ModelType.chat,
                  supportsStreaming: true,
                  supportsVision:
                      modelId.contains('vision') ||
                      modelId.contains('gpt-4') ||
                      modelId.contains('o1'),
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
      debugPrint('获取OpenAI Responses模型列表失败，使用预定义列表: $e');
    }

    // 回退到预定义模型列表
    return const [
      ModelInfo(
        id: 'gpt-4o',
        name: 'GPT-4o',
        type: ModelType.chat,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: true,
      ),
      ModelInfo(
        id: 'gpt-4o-mini',
        name: 'GPT-4o Mini',
        type: ModelType.chat,
        supportsStreaming: true,
        supportsVision: true,
        supportsFunctionCalling: true,
      ),
      ModelInfo(
        id: 'o1-preview',
        name: 'o1 Preview',
        type: ModelType.chat,
        supportsStreaming: false,
        supportsVision: false,
        supportsFunctionCalling: false,
      ),
      ModelInfo(
        id: 'o1-mini',
        name: 'o1 Mini',
        type: ModelType.chat,
        supportsStreaming: false,
        supportsVision: false,
        supportsFunctionCalling: false,
      ),
    ];
  }

  /// 检查模型是否兼容Responses API
  bool _isResponsesCompatibleModel(String modelId) {
    // Responses API主要支持GPT-4系列和o1系列模型
    return modelId.contains('gpt-4') ||
        modelId.contains('o1') ||
        modelId.startsWith('gpt-4o') ||
        modelId == 'gpt-3.5-turbo'; // 某些情况下也支持
  }

  /// 检查模型是否支持推理功能
  bool _supportsReasoning(String modelId) {
    // o1系列模型支持推理功能
    return modelId.contains('o1') ||
        modelId.contains('o3') ||
        modelId.contains('o4');
  }

  /// 检查模型是否支持Web搜索
  bool _supportsWebSearch(String modelId) {
    // 大部分GPT-4系列模型支持Web搜索
    return modelId.contains('gpt-4') ||
        modelId.startsWith('gpt-4o') ||
        modelId.contains('o1');
  }

  @override
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async {
    final model = options?.model ?? config.defaultModel ?? 'gpt-4o';
    try {
      final input = _convertToResponsesInput(messages, options?.systemPrompt);

      final body = <String, dynamic>{'model': model, 'input': input};

      if (options?.temperature != null) {
        body['temperature'] = options!.temperature;
      }
      if (options?.maxTokens != null) {
        body['max_output_tokens'] = options!.maxTokens;
      }

      // 思考相关参数（Responses 支持 o1 系列等推理模型）
      if (options?.reasoningEffort != null && _supportsReasoning(model)) {
        body['reasoning'] = {
          'effort': options!.reasoningEffort,
          if (options.maxReasoningTokens != null)
            'max_tokens': options.maxReasoningTokens,
        };
      }

      // Web搜索工具支持
      final enableWebSearch =
          options?.customParams?['enableModelNativeSearch'] == true ||
          options?.customParams?['enableWebSearch'] == true;
      if (enableWebSearch && _supportsWebSearch(model)) {
        body['tools'] = [
          {'type': 'web_search'},
        ];
      }

      // 文件搜索工具支持（如果需要）
      final enableFileSearch =
          options?.customParams?['enableFileSearch'] == true;
      if (enableFileSearch) {
        body['tools'] = (body['tools'] as List<Map<String, dynamic>>? ?? [])
          ..add({'type': 'file_search'});
      }

      final resp = await http
          .post(_responsesUri, headers: _headers(), body: jsonEncode(body))
          .timeout(const Duration(seconds: 25));

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw ApiException(
          'OpenAI Responses 请求失败: ${resp.statusCode} - ${resp.body}',
        );
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final content = _extractOutputText(data);
      final usage = data['usage'] as Map<String, dynamic>?;
      final inputTokens = (usage?['input_tokens'] as int?) ?? 0;
      final outputTokens = (usage?['output_tokens'] as int?) ?? 0;

      return ChatResult(
        content: content,
        model: model,
        tokenUsage: TokenUsage(
          inputTokens: inputTokens,
          outputTokens: outputTokens,
          totalTokens: inputTokens + outputTokens,
        ),
        finishReason: FinishReason.stop,
        metadata: data['citations'] != null
            ? {'citations': data['citations']}
            : null,
      );
    } catch (e) {
      throw ApiException('OpenAI Responses 生成失败: $e');
    }
  }

  @override
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async* {
    // 暂不支持流式，后续可实现 SSE 解析
    final result = await generateChat(messages, options: options);
    yield StreamedChatResult(
      content: result.content,
      isDone: true,
      model: result.model,
      tokenUsage: result.tokenUsage,
      finishReason: result.finishReason,
    );
  }

  @override
  Future<EmbeddingResult> generateEmbeddings(List<String> texts) async {
    throw UnsupportedError('Responses API 暂不提供嵌入');
  }

  @override
  Future<bool> validateConfig() async {
    try {
      // 尝试一次最小请求验证配置可用性
      await generateChat([
        ChatMessage(
          id: 'ping',
          content: 'ping',
          isFromUser: true,
          timestamp: DateTime.now(),
          chatSessionId: 'validate',
        ),
      ], options: const ChatOptions(model: 'gpt-4o'));
      return true;
    } catch (e) {
      debugPrint('Responses validate failed: $e');
      return false;
    }
  }

  @override
  int estimateTokens(String text) => (text.length / 4).ceil();

  @override
  void dispose() {}

  List<Map<String, dynamic>> _convertToResponsesInput(
    List<ChatMessage> messages,
    String? systemPrompt,
  ) {
    final input = <Map<String, dynamic>>[];
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      input.add({
        'role': 'system',
        'content': [
          {'type': 'text', 'text': systemPrompt},
        ],
      });
    }

    for (final m in messages) {
      input.add({
        'role': m.isFromUser ? 'user' : 'assistant',
        'content': [
          {'type': 'text', 'text': m.content},
        ],
      });
    }
    return input;
  }

  String _extractOutputText(Map<String, dynamic> data) {
    if (data['output_text'] is String) {
      return data['output_text'] as String;
    }
    if (data['output'] is List) {
      final out = StringBuffer();
      for (final item in (data['output'] as List)) {
        if (item is Map<String, dynamic>) {
          if (item['type'] == 'output_text' && item['text'] is String) {
            out.write(item['text']);
          } else if (item['content'] is List) {
            for (final c in (item['content'] as List)) {
              if (c is Map<String, dynamic> && c['text'] is String) {
                out.write(c['text']);
              }
            }
          }
        }
      }
      final s = out.toString();
      if (s.isNotEmpty) return s;
    }
    return data.toString();
  }
}
