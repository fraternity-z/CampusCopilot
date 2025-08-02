// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionImpl _$$ChatSessionImplFromJson(Map<String, dynamic> json) =>
    _$ChatSessionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      personaId: json['personaId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isArchived: json['isArchived'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              ChatMessageDefaults.emptyStringList,
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
      config: json['config'] == null
          ? null
          : ChatSessionConfig.fromJson(json['config'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatSessionImplToJson(_$ChatSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'personaId': instance.personaId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isArchived': instance.isArchived,
      'isPinned': instance.isPinned,
      'tags': instance.tags,
      'messageCount': instance.messageCount,
      'totalTokens': instance.totalTokens,
      'config': instance.config,
      'metadata': instance.metadata,
    };

_$ChatSessionConfigImpl _$$ChatSessionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatSessionConfigImpl(
      contextWindowSize: (json['contextWindowSize'] as num?)?.toInt() ??
          ChatMessageDefaults.defaultContextWindowSize,
      temperature: (json['temperature'] as num?)?.toDouble() ??
          ChatMessageDefaults.defaultTemperature,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ??
          ChatMessageDefaults.defaultMaxTokens,
      enableStreaming: json['enableStreaming'] as bool? ?? true,
      enableRAG: json['enableRAG'] as bool? ?? false,
      knowledgeBaseIds: (json['knowledgeBaseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ChatMessageDefaults.emptyKnowledgeBaseIds,
      systemPromptOverride: json['systemPromptOverride'] as String?,
      customParams: json['customParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatSessionConfigImplToJson(
        _$ChatSessionConfigImpl instance) =>
    <String, dynamic>{
      'contextWindowSize': instance.contextWindowSize,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'enableStreaming': instance.enableStreaming,
      'enableRAG': instance.enableRAG,
      'knowledgeBaseIds': instance.knowledgeBaseIds,
      'systemPromptOverride': instance.systemPromptOverride,
      'customParams': instance.customParams,
    };
