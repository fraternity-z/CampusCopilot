// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LlmConfigImpl _$$LlmConfigImplFromJson(Map<String, dynamic> json) =>
    _$LlmConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String,
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      defaultModel: json['defaultModel'] as String?,
      defaultEmbeddingModel: json['defaultEmbeddingModel'] as String?,
      organizationId: json['organizationId'] as String?,
      projectId: json['projectId'] as String?,
      extraParams: json['extraParams'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$LlmConfigImplToJson(_$LlmConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': instance.provider,
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
      'defaultEmbeddingModel': instance.defaultEmbeddingModel,
      'organizationId': instance.organizationId,
      'projectId': instance.projectId,
      'extraParams': instance.extraParams,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isEnabled': instance.isEnabled,
    };

_$ModelInfoImpl _$$ModelInfoImplFromJson(Map<String, dynamic> json) =>
    _$ModelInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$ModelTypeEnumMap, json['type']),
      contextWindow: (json['contextWindow'] as num?)?.toInt(),
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
      supportsStreaming: json['supportsStreaming'] as bool? ?? true,
      supportsFunctionCalling:
          json['supportsFunctionCalling'] as bool? ?? false,
      supportsVision: json['supportsVision'] as bool? ?? false,
      pricing: json['pricing'] == null
          ? null
          : PricingInfo.fromJson(json['pricing'] as Map<String, dynamic>),
      capabilities: (json['capabilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ModelInfoImplToJson(_$ModelInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$ModelTypeEnumMap[instance.type]!,
      'contextWindow': instance.contextWindow,
      'maxOutputTokens': instance.maxOutputTokens,
      'supportsStreaming': instance.supportsStreaming,
      'supportsFunctionCalling': instance.supportsFunctionCalling,
      'supportsVision': instance.supportsVision,
      'pricing': instance.pricing,
      'capabilities': instance.capabilities,
    };

const _$ModelTypeEnumMap = {
  ModelType.chat: 'chat',
  ModelType.embedding: 'embedding',
  ModelType.imageGeneration: 'imageGeneration',
  ModelType.speech: 'speech',
  ModelType.multimodal: 'multimodal',
};

_$PricingInfoImpl _$$PricingInfoImplFromJson(Map<String, dynamic> json) =>
    _$PricingInfoImpl(
      inputPrice: (json['inputPrice'] as num?)?.toDouble(),
      outputPrice: (json['outputPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
    );

Map<String, dynamic> _$$PricingInfoImplToJson(_$PricingInfoImpl instance) =>
    <String, dynamic>{
      'inputPrice': instance.inputPrice,
      'outputPrice': instance.outputPrice,
      'currency': instance.currency,
    };

_$ChatOptionsImpl _$$ChatOptionsImplFromJson(Map<String, dynamic> json) =>
    _$ChatOptionsImpl(
      model: json['model'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      topP: (json['topP'] as num?)?.toDouble(),
      frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble(),
      presencePenalty: (json['presencePenalty'] as num?)?.toDouble(),
      stopSequences: (json['stopSequences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stream: json['stream'] as bool?,
      systemPrompt: json['systemPrompt'] as String?,
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => ToolDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      reasoningEffort: json['reasoningEffort'] as String?,
      maxReasoningTokens: (json['maxReasoningTokens'] as num?)?.toInt(),
      customParams: json['customParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatOptionsImplToJson(_$ChatOptionsImpl instance) =>
    <String, dynamic>{
      'model': instance.model,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'topP': instance.topP,
      'frequencyPenalty': instance.frequencyPenalty,
      'presencePenalty': instance.presencePenalty,
      'stopSequences': instance.stopSequences,
      'stream': instance.stream,
      'systemPrompt': instance.systemPrompt,
      'tools': instance.tools,
      'reasoningEffort': instance.reasoningEffort,
      'maxReasoningTokens': instance.maxReasoningTokens,
      'customParams': instance.customParams,
    };

_$ToolDefinitionImpl _$$ToolDefinitionImplFromJson(Map<String, dynamic> json) =>
    _$ToolDefinitionImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ToolDefinitionImplToJson(
        _$ToolDefinitionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'parameters': instance.parameters,
    };

_$ChatResultImpl _$$ChatResultImplFromJson(Map<String, dynamic> json) =>
    _$ChatResultImpl(
      content: json['content'] as String,
      model: json['model'] as String,
      tokenUsage:
          TokenUsage.fromJson(json['tokenUsage'] as Map<String, dynamic>),
      finishReason: $enumDecode(_$FinishReasonEnumMap, json['finishReason']),
      toolCalls: (json['toolCalls'] as List<dynamic>?)
          ?.map((e) => ToolCall.fromJson(e as Map<String, dynamic>))
          .toList(),
      responseTimeMs: (json['responseTimeMs'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      thinkingContent: json['thinkingContent'] as String?,
    );

Map<String, dynamic> _$$ChatResultImplToJson(_$ChatResultImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'model': instance.model,
      'tokenUsage': instance.tokenUsage,
      'finishReason': _$FinishReasonEnumMap[instance.finishReason]!,
      'toolCalls': instance.toolCalls,
      'responseTimeMs': instance.responseTimeMs,
      'metadata': instance.metadata,
      'thinkingContent': instance.thinkingContent,
    };

const _$FinishReasonEnumMap = {
  FinishReason.stop: 'stop',
  FinishReason.length: 'length',
  FinishReason.contentFilter: 'contentFilter',
  FinishReason.toolCalls: 'toolCalls',
  FinishReason.error: 'error',
};

_$StreamedChatResultImpl _$$StreamedChatResultImplFromJson(
        Map<String, dynamic> json) =>
    _$StreamedChatResultImpl(
      delta: json['delta'] as String?,
      content: json['content'] as String?,
      isDone: json['isDone'] as bool? ?? false,
      model: json['model'] as String?,
      tokenUsage: json['tokenUsage'] == null
          ? null
          : TokenUsage.fromJson(json['tokenUsage'] as Map<String, dynamic>),
      finishReason:
          $enumDecodeNullable(_$FinishReasonEnumMap, json['finishReason']),
      toolCalls: (json['toolCalls'] as List<dynamic>?)
          ?.map((e) => ToolCall.fromJson(e as Map<String, dynamic>))
          .toList(),
      thinkingDelta: json['thinkingDelta'] as String?,
      thinkingContent: json['thinkingContent'] as String?,
      thinkingComplete: json['thinkingComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$$StreamedChatResultImplToJson(
        _$StreamedChatResultImpl instance) =>
    <String, dynamic>{
      'delta': instance.delta,
      'content': instance.content,
      'isDone': instance.isDone,
      'model': instance.model,
      'tokenUsage': instance.tokenUsage,
      'finishReason': _$FinishReasonEnumMap[instance.finishReason],
      'toolCalls': instance.toolCalls,
      'thinkingDelta': instance.thinkingDelta,
      'thinkingContent': instance.thinkingContent,
      'thinkingComplete': instance.thinkingComplete,
    };

_$TokenUsageImpl _$$TokenUsageImplFromJson(Map<String, dynamic> json) =>
    _$TokenUsageImpl(
      inputTokens: (json['inputTokens'] as num).toInt(),
      outputTokens: (json['outputTokens'] as num).toInt(),
      totalTokens: (json['totalTokens'] as num).toInt(),
    );

Map<String, dynamic> _$$TokenUsageImplToJson(_$TokenUsageImpl instance) =>
    <String, dynamic>{
      'inputTokens': instance.inputTokens,
      'outputTokens': instance.outputTokens,
      'totalTokens': instance.totalTokens,
    };

_$ToolCallImpl _$$ToolCallImplFromJson(Map<String, dynamic> json) =>
    _$ToolCallImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ToolCallImplToJson(_$ToolCallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'arguments': instance.arguments,
    };

_$EmbeddingResultImpl _$$EmbeddingResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EmbeddingResultImpl(
      embeddings: (json['embeddings'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      model: json['model'] as String,
      tokenUsage:
          TokenUsage.fromJson(json['tokenUsage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EmbeddingResultImplToJson(
        _$EmbeddingResultImpl instance) =>
    <String, dynamic>{
      'embeddings': instance.embeddings,
      'model': instance.model,
      'tokenUsage': instance.tokenUsage,
    };
