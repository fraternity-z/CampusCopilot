// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HelpSectionImpl _$$HelpSectionImplFromJson(Map<String, dynamic> json) =>
    _$HelpSectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => HelpItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HelpSectionImplToJson(_$HelpSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'description': instance.description,
      'items': instance.items,
      'tags': instance.tags,
      'order': instance.order,
    };

_$HelpItemImpl _$$HelpItemImplFromJson(Map<String, dynamic> json) =>
    _$HelpItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$HelpItemTypeEnumMap, json['type']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => HelpStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      relatedItems: (json['relatedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFrequentlyUsed: json['isFrequentlyUsed'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HelpItemImplToJson(_$HelpItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': _$HelpItemTypeEnumMap[instance.type]!,
      'tags': instance.tags,
      'steps': instance.steps,
      'relatedItems': instance.relatedItems,
      'isFrequentlyUsed': instance.isFrequentlyUsed,
      'viewCount': instance.viewCount,
    };

const _$HelpItemTypeEnumMap = {
  HelpItemType.faq: 'faq',
  HelpItemType.guide: 'guide',
  HelpItemType.quickStart: 'quickStart',
  HelpItemType.feature: 'feature',
  HelpItemType.troubleshooting: 'troubleshooting',
};

_$HelpStepImpl _$$HelpStepImplFromJson(Map<String, dynamic> json) =>
    _$HelpStepImpl(
      step: (json['step'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      tips:
          (json['tips'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$HelpStepImplToJson(_$HelpStepImpl instance) =>
    <String, dynamic>{
      'step': instance.step,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'tips': instance.tips,
    };
