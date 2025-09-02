// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanEntityImpl _$$PlanEntityImplFromJson(Map<String, dynamic> json) =>
    _$PlanEntityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$PlanTypeEnumMap, json['type']) ??
          PlanType.study,
      priority: $enumDecodeNullable(_$PlanPriorityEnumMap, json['priority']) ??
          PlanPriority.medium,
      status: $enumDecodeNullable(_$PlanStatusEnumMap, json['status']) ??
          PlanStatus.pending,
      planDate: DateTime.parse(json['planDate'] as String),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      reminderTime: json['reminderTime'] == null
          ? null
          : DateTime.parse(json['reminderTime'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      courseId: json['courseId'] as String?,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$PlanEntityImplToJson(_$PlanEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$PlanTypeEnumMap[instance.type]!,
      'priority': _$PlanPriorityEnumMap[instance.priority]!,
      'status': _$PlanStatusEnumMap[instance.status]!,
      'planDate': instance.planDate.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'tags': instance.tags,
      'courseId': instance.courseId,
      'progress': instance.progress,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$PlanTypeEnumMap = {
  PlanType.study: 'study',
  PlanType.work: 'work',
  PlanType.life: 'life',
  PlanType.other: 'other',
};

const _$PlanPriorityEnumMap = {
  PlanPriority.low: 1,
  PlanPriority.medium: 2,
  PlanPriority.high: 3,
};

const _$PlanStatusEnumMap = {
  PlanStatus.pending: 'pending',
  PlanStatus.inProgress: 'in_progress',
  PlanStatus.completed: 'completed',
  PlanStatus.cancelled: 'cancelled',
};

_$PlanStatsImpl _$$PlanStatsImplFromJson(Map<String, dynamic> json) =>
    _$PlanStatsImpl(
      totalPlans: (json['totalPlans'] as num?)?.toInt() ?? 0,
      completedPlans: (json['completedPlans'] as num?)?.toInt() ?? 0,
      pendingPlans: (json['pendingPlans'] as num?)?.toInt() ?? 0,
      inProgressPlans: (json['inProgressPlans'] as num?)?.toInt() ?? 0,
      cancelledPlans: (json['cancelledPlans'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PlanStatsImplToJson(_$PlanStatsImpl instance) =>
    <String, dynamic>{
      'totalPlans': instance.totalPlans,
      'completedPlans': instance.completedPlans,
      'pendingPlans': instance.pendingPlans,
      'inProgressPlans': instance.inProgressPlans,
      'cancelledPlans': instance.cancelledPlans,
      'completionRate': instance.completionRate,
    };

_$CreatePlanRequestImpl _$$CreatePlanRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePlanRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$PlanTypeEnumMap, json['type']) ??
          PlanType.study,
      priority: $enumDecodeNullable(_$PlanPriorityEnumMap, json['priority']) ??
          PlanPriority.medium,
      planDate: DateTime.parse(json['planDate'] as String),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      reminderTime: json['reminderTime'] == null
          ? null
          : DateTime.parse(json['reminderTime'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      courseId: json['courseId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CreatePlanRequestImplToJson(
        _$CreatePlanRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': _$PlanTypeEnumMap[instance.type]!,
      'priority': _$PlanPriorityEnumMap[instance.priority]!,
      'planDate': instance.planDate.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'tags': instance.tags,
      'courseId': instance.courseId,
      'notes': instance.notes,
    };

_$UpdatePlanRequestImpl _$$UpdatePlanRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePlanRequestImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$PlanTypeEnumMap, json['type']),
      priority: $enumDecodeNullable(_$PlanPriorityEnumMap, json['priority']),
      status: $enumDecodeNullable(_$PlanStatusEnumMap, json['status']),
      planDate: json['planDate'] == null
          ? null
          : DateTime.parse(json['planDate'] as String),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      reminderTime: json['reminderTime'] == null
          ? null
          : DateTime.parse(json['reminderTime'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      courseId: json['courseId'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$UpdatePlanRequestImplToJson(
        _$UpdatePlanRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': _$PlanTypeEnumMap[instance.type],
      'priority': _$PlanPriorityEnumMap[instance.priority],
      'status': _$PlanStatusEnumMap[instance.status],
      'planDate': instance.planDate?.toIso8601String(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'reminderTime': instance.reminderTime?.toIso8601String(),
      'tags': instance.tags,
      'courseId': instance.courseId,
      'progress': instance.progress,
      'notes': instance.notes,
    };
