// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaImpl _$$PersonaImplFromJson(Map<String, dynamic> json) =>
    _$PersonaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      systemPrompt: json['systemPrompt'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      avatarImagePath: json['avatarImagePath'] as String?,
      avatarEmoji: json['avatarEmoji'] as String? ?? '🤖',
      avatar: json['avatar'] as String?,
      apiConfigId: json['apiConfigId'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PersonaImplToJson(_$PersonaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'systemPrompt': instance.systemPrompt,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
      'avatarImagePath': instance.avatarImagePath,
      'avatarEmoji': instance.avatarEmoji,
      'avatar': instance.avatar,
      'apiConfigId': instance.apiConfigId,
      'isDefault': instance.isDefault,
      'isEnabled': instance.isEnabled,
      'usageCount': instance.usageCount,
      'description': instance.description,
      'tags': instance.tags,
      'metadata': instance.metadata,
    };
