// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_mode_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningModeStateImpl _$$LearningModeStateImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningModeStateImpl(
      isLearningMode: json['isLearningMode'] as bool? ?? false,
      style: $enumDecodeNullable(_$LearningStyleEnumMap, json['style']) ??
          LearningStyle.guided,
      hintHistory: (json['hintHistory'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      responseDetail: $enumDecodeNullable(
              _$ResponseDetailEnumMap, json['responseDetail']) ??
          ResponseDetail.normal,
      showLearningHints: json['showLearningHints'] as bool? ?? true,
      questionStep: (json['questionStep'] as num?)?.toInt() ?? 0,
      maxQuestionSteps: (json['maxQuestionSteps'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$$LearningModeStateImplToJson(
        _$LearningModeStateImpl instance) =>
    <String, dynamic>{
      'isLearningMode': instance.isLearningMode,
      'style': _$LearningStyleEnumMap[instance.style]!,
      'hintHistory': instance.hintHistory,
      'responseDetail': _$ResponseDetailEnumMap[instance.responseDetail]!,
      'showLearningHints': instance.showLearningHints,
      'questionStep': instance.questionStep,
      'maxQuestionSteps': instance.maxQuestionSteps,
    };

const _$LearningStyleEnumMap = {
  LearningStyle.guided: 'guided',
  LearningStyle.exploratory: 'exploratory',
  LearningStyle.structured: 'structured',
};

const _$ResponseDetailEnumMap = {
  ResponseDetail.brief: 'brief',
  ResponseDetail.normal: 'normal',
  ResponseDetail.detailed: 'detailed',
};

_$LearningModeConfigImpl _$$LearningModeConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningModeConfigImpl(
      provideHintsFirst: json['provideHintsFirst'] as bool? ?? true,
      allowDirectAnswers: json['allowDirectAnswers'] as bool? ?? false,
      hintInterval: (json['hintInterval'] as num?)?.toInt() ?? 5,
      customPromptTemplates:
          (json['customPromptTemplates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$LearningModeConfigImplToJson(
        _$LearningModeConfigImpl instance) =>
    <String, dynamic>{
      'provideHintsFirst': instance.provideHintsFirst,
      'allowDirectAnswers': instance.allowDirectAnswers,
      'hintInterval': instance.hintInterval,
      'customPromptTemplates': instance.customPromptTemplates,
    };
