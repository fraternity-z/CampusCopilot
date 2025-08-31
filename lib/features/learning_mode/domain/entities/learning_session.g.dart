// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LearningSessionImpl _$$LearningSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningSessionImpl(
      sessionId: json['sessionId'] as String,
      initialQuestion: json['initialQuestion'] as String,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 1,
      maxRounds: (json['maxRounds'] as num?)?.toInt() ?? 8,
      status:
          $enumDecodeNullable(_$LearningSessionStatusEnumMap, json['status']) ??
              LearningSessionStatus.active,
      startTime: DateTime.parse(json['startTime'] as String),
      messageIds: (json['messageIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userRequestedAnswer: json['userRequestedAnswer'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LearningSessionImplToJson(
        _$LearningSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'initialQuestion': instance.initialQuestion,
      'currentRound': instance.currentRound,
      'maxRounds': instance.maxRounds,
      'status': _$LearningSessionStatusEnumMap[instance.status]!,
      'startTime': instance.startTime.toIso8601String(),
      'messageIds': instance.messageIds,
      'userRequestedAnswer': instance.userRequestedAnswer,
      'metadata': instance.metadata,
    };

const _$LearningSessionStatusEnumMap = {
  LearningSessionStatus.active: 'active',
  LearningSessionStatus.completed: 'completed',
  LearningSessionStatus.terminated: 'terminated',
  LearningSessionStatus.paused: 'paused',
};

_$LearningSessionConfigImpl _$$LearningSessionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningSessionConfigImpl(
      defaultMaxRounds: (json['defaultMaxRounds'] as num?)?.toInt() ?? 8,
      answerTriggerKeywords: (json['answerTriggerKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [
            '直接告诉我答案',
            '给我答案',
            '直接给我答案',
            '不要引导了',
            '直接说',
            '我想要答案',
            '告诉我答案',
            '跳过引导',
            '直接回答',
            '我要答案',
            '给答案',
            '说答案',
            '直接讲答案',
            '别引导了',
            '不用引导'
          ],
      autoAnswerAtEnd: json['autoAnswerAtEnd'] as bool? ?? true,
      showProgress: json['showProgress'] as bool? ?? true,
      contextStrategy: $enumDecodeNullable(
              _$ContextStrategyEnumMap, json['contextStrategy']) ??
          ContextStrategy.full,
    );

Map<String, dynamic> _$$LearningSessionConfigImplToJson(
        _$LearningSessionConfigImpl instance) =>
    <String, dynamic>{
      'defaultMaxRounds': instance.defaultMaxRounds,
      'answerTriggerKeywords': instance.answerTriggerKeywords,
      'autoAnswerAtEnd': instance.autoAnswerAtEnd,
      'showProgress': instance.showProgress,
      'contextStrategy': _$ContextStrategyEnumMap[instance.contextStrategy]!,
    };

const _$ContextStrategyEnumMap = {
  ContextStrategy.full: 'full',
  ContextStrategy.sliding: 'sliding',
  ContextStrategy.keyRounds: 'key_rounds',
};
