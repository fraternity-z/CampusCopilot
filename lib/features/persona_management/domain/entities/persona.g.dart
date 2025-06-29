// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaImpl _$$PersonaImplFromJson(Map<String, dynamic> json) =>
    _$PersonaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      systemPrompt: json['systemPrompt'] as String,
      apiConfigId: json['apiConfigId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      category: json['category'] as String? ?? 'assistant',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      avatar: json['avatar'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      config: json['config'] == null
          ? null
          : PersonaConfig.fromJson(json['config'] as Map<String, dynamic>),
      capabilities: (json['capabilities'] as List<dynamic>?)
              ?.map(
                  (e) => PersonaCapability.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PersonaImplToJson(_$PersonaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'systemPrompt': instance.systemPrompt,
      'apiConfigId': instance.apiConfigId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
      'category': instance.category,
      'tags': instance.tags,
      'avatar': instance.avatar,
      'isDefault': instance.isDefault,
      'isEnabled': instance.isEnabled,
      'usageCount': instance.usageCount,
      'config': instance.config,
      'capabilities': instance.capabilities,
      'metadata': instance.metadata,
    };

_$PersonaConfigImpl _$$PersonaConfigImplFromJson(Map<String, dynamic> json) =>
    _$PersonaConfigImpl(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 2048,
      topP: (json['topP'] as num?)?.toDouble() ?? 1.0,
      frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.0,
      presencePenalty: (json['presencePenalty'] as num?)?.toDouble() ?? 0.0,
      stopSequences: (json['stopSequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      enableStreaming: json['enableStreaming'] as bool? ?? true,
      contextStrategy: $enumDecodeNullable(
              _$ContextStrategyEnumMap, json['contextStrategy']) ??
          ContextStrategy.truncate,
      contextWindowSize: (json['contextWindowSize'] as num?)?.toInt() ?? 4096,
      enableRAG: json['enableRAG'] as bool? ?? false,
      defaultKnowledgeBases: (json['defaultKnowledgeBases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      customParams: json['customParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PersonaConfigImplToJson(_$PersonaConfigImpl instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'topP': instance.topP,
      'frequencyPenalty': instance.frequencyPenalty,
      'presencePenalty': instance.presencePenalty,
      'stopSequences': instance.stopSequences,
      'enableStreaming': instance.enableStreaming,
      'contextStrategy': _$ContextStrategyEnumMap[instance.contextStrategy]!,
      'contextWindowSize': instance.contextWindowSize,
      'enableRAG': instance.enableRAG,
      'defaultKnowledgeBases': instance.defaultKnowledgeBases,
      'customParams': instance.customParams,
    };

const _$ContextStrategyEnumMap = {
  ContextStrategy.truncate: 'truncate',
  ContextStrategy.summarize: 'summarize',
  ContextStrategy.slidingWindow: 'slidingWindow',
};

_$PersonaCapabilityImpl _$$PersonaCapabilityImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonaCapabilityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$CapabilityTypeEnumMap, json['type']),
      isEnabled: json['isEnabled'] as bool? ?? true,
      config: json['config'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PersonaCapabilityImplToJson(
        _$PersonaCapabilityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$CapabilityTypeEnumMap[instance.type]!,
      'isEnabled': instance.isEnabled,
      'config': instance.config,
    };

const _$CapabilityTypeEnumMap = {
  CapabilityType.tool: 'tool',
  CapabilityType.knowledgeBase: 'knowledgeBase',
  CapabilityType.codeExecution: 'codeExecution',
  CapabilityType.imageGeneration: 'imageGeneration',
  CapabilityType.fileProcessing: 'fileProcessing',
  CapabilityType.webSearch: 'webSearch',
};
