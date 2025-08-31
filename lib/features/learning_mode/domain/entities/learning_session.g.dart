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
            '不用引导',
            '我想直接知道答案',
            '我想知道答案',
            '直接给出答案',
            '请直接告诉我',
            '我要直接答案',
            '给我完整答案',
            '完整答案',
            '最终答案',
            '标准答案',
            '正确答案',
            '我不想引导',
            '不想步骤',
            '不要步骤',
            '省略步骤',
            '跳过步骤',
            '直接结果',
            '我要结果',
            '给我结果',
            '告诉我结果',
            '想直接知道',
            '直接知道',
            '想知道答案',
            '直接得到答案',
            '得到答案',
            '接得到答案',
            '想要直接答案',
            '要直接答案',
            '直接给答案'
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
