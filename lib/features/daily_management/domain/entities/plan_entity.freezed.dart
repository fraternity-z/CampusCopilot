// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlanEntity _$PlanEntityFromJson(Map<String, dynamic> json) {
  return _PlanEntity.fromJson(json);
}

/// @nodoc
mixin _$PlanEntity {
  /// 计划ID
  String get id => throw _privateConstructorUsedError;

  /// 计划标题
  String get title => throw _privateConstructorUsedError;

  /// 计划描述
  String? get description => throw _privateConstructorUsedError;

  /// 计划类型
  PlanType get type => throw _privateConstructorUsedError;

  /// 优先级
  PlanPriority get priority => throw _privateConstructorUsedError;

  /// 计划状态
  PlanStatus get status => throw _privateConstructorUsedError;

  /// 计划日期
  DateTime get planDate => throw _privateConstructorUsedError;

  /// 开始时间
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// 结束时间
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// 提醒时间
  DateTime? get reminderTime => throw _privateConstructorUsedError;

  /// 标签列表
  List<String> get tags => throw _privateConstructorUsedError;

  /// 关联的课程ID
  String? get courseId => throw _privateConstructorUsedError;

  /// 完成进度 (0-100)
  int get progress => throw _privateConstructorUsedError;

  /// 备注
  String? get notes => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 完成时间
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanEntityCopyWith<PlanEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanEntityCopyWith<$Res> {
  factory $PlanEntityCopyWith(
          PlanEntity value, $Res Function(PlanEntity) then) =
      _$PlanEntityCopyWithImpl<$Res, PlanEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      PlanType type,
      PlanPriority priority,
      PlanStatus status,
      DateTime planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String> tags,
      String? courseId,
      int progress,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$PlanEntityCopyWithImpl<$Res, $Val extends PlanEntity>
    implements $PlanEntityCopyWith<$Res> {
  _$PlanEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? status = null,
    Object? planDate = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? courseId = freezed,
    Object? progress = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanEntityImplCopyWith<$Res>
    implements $PlanEntityCopyWith<$Res> {
  factory _$$PlanEntityImplCopyWith(
          _$PlanEntityImpl value, $Res Function(_$PlanEntityImpl) then) =
      __$$PlanEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      PlanType type,
      PlanPriority priority,
      PlanStatus status,
      DateTime planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String> tags,
      String? courseId,
      int progress,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$PlanEntityImplCopyWithImpl<$Res>
    extends _$PlanEntityCopyWithImpl<$Res, _$PlanEntityImpl>
    implements _$$PlanEntityImplCopyWith<$Res> {
  __$$PlanEntityImplCopyWithImpl(
      _$PlanEntityImpl _value, $Res Function(_$PlanEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? status = null,
    Object? planDate = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? courseId = freezed,
    Object? progress = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$PlanEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanEntityImpl implements _PlanEntity {
  const _$PlanEntityImpl(
      {required this.id,
      required this.title,
      this.description,
      this.type = PlanType.study,
      this.priority = PlanPriority.medium,
      this.status = PlanStatus.pending,
      required this.planDate,
      this.startTime,
      this.endTime,
      this.reminderTime,
      final List<String> tags = const [],
      this.courseId,
      this.progress = 0,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt})
      : _tags = tags;

  factory _$PlanEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanEntityImplFromJson(json);

  /// 计划ID
  @override
  final String id;

  /// 计划标题
  @override
  final String title;

  /// 计划描述
  @override
  final String? description;

  /// 计划类型
  @override
  @JsonKey()
  final PlanType type;

  /// 优先级
  @override
  @JsonKey()
  final PlanPriority priority;

  /// 计划状态
  @override
  @JsonKey()
  final PlanStatus status;

  /// 计划日期
  @override
  final DateTime planDate;

  /// 开始时间
  @override
  final DateTime? startTime;

  /// 结束时间
  @override
  final DateTime? endTime;

  /// 提醒时间
  @override
  final DateTime? reminderTime;

  /// 标签列表
  final List<String> _tags;

  /// 标签列表
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 关联的课程ID
  @override
  final String? courseId;

  /// 完成进度 (0-100)
  @override
  @JsonKey()
  final int progress;

  /// 备注
  @override
  final String? notes;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 更新时间
  @override
  final DateTime updatedAt;

  /// 完成时间
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'PlanEntity(id: $id, title: $title, description: $description, type: $type, priority: $priority, status: $status, planDate: $planDate, startTime: $startTime, endTime: $endTime, reminderTime: $reminderTime, tags: $tags, courseId: $courseId, progress: $progress, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      type,
      priority,
      status,
      planDate,
      startTime,
      endTime,
      reminderTime,
      const DeepCollectionEquality().hash(_tags),
      courseId,
      progress,
      notes,
      createdAt,
      updatedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanEntityImplCopyWith<_$PlanEntityImpl> get copyWith =>
      __$$PlanEntityImplCopyWithImpl<_$PlanEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanEntityImplToJson(
      this,
    );
  }
}

abstract class _PlanEntity implements PlanEntity {
  const factory _PlanEntity(
      {required final String id,
      required final String title,
      final String? description,
      final PlanType type,
      final PlanPriority priority,
      final PlanStatus status,
      required final DateTime planDate,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? reminderTime,
      final List<String> tags,
      final String? courseId,
      final int progress,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? completedAt}) = _$PlanEntityImpl;

  factory _PlanEntity.fromJson(Map<String, dynamic> json) =
      _$PlanEntityImpl.fromJson;

  @override

  /// 计划ID
  String get id;
  @override

  /// 计划标题
  String get title;
  @override

  /// 计划描述
  String? get description;
  @override

  /// 计划类型
  PlanType get type;
  @override

  /// 优先级
  PlanPriority get priority;
  @override

  /// 计划状态
  PlanStatus get status;
  @override

  /// 计划日期
  DateTime get planDate;
  @override

  /// 开始时间
  DateTime? get startTime;
  @override

  /// 结束时间
  DateTime? get endTime;
  @override

  /// 提醒时间
  DateTime? get reminderTime;
  @override

  /// 标签列表
  List<String> get tags;
  @override

  /// 关联的课程ID
  String? get courseId;
  @override

  /// 完成进度 (0-100)
  int get progress;
  @override

  /// 备注
  String? get notes;
  @override

  /// 创建时间
  DateTime get createdAt;
  @override

  /// 更新时间
  DateTime get updatedAt;
  @override

  /// 完成时间
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlanEntityImplCopyWith<_$PlanEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlanStats _$PlanStatsFromJson(Map<String, dynamic> json) {
  return _PlanStats.fromJson(json);
}

/// @nodoc
mixin _$PlanStats {
  int get totalPlans => throw _privateConstructorUsedError;
  int get completedPlans => throw _privateConstructorUsedError;
  int get pendingPlans => throw _privateConstructorUsedError;
  int get inProgressPlans => throw _privateConstructorUsedError;
  int get cancelledPlans => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanStatsCopyWith<PlanStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanStatsCopyWith<$Res> {
  factory $PlanStatsCopyWith(PlanStats value, $Res Function(PlanStats) then) =
      _$PlanStatsCopyWithImpl<$Res, PlanStats>;
  @useResult
  $Res call(
      {int totalPlans,
      int completedPlans,
      int pendingPlans,
      int inProgressPlans,
      int cancelledPlans,
      double completionRate});
}

/// @nodoc
class _$PlanStatsCopyWithImpl<$Res, $Val extends PlanStats>
    implements $PlanStatsCopyWith<$Res> {
  _$PlanStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlans = null,
    Object? completedPlans = null,
    Object? pendingPlans = null,
    Object? inProgressPlans = null,
    Object? cancelledPlans = null,
    Object? completionRate = null,
  }) {
    return _then(_value.copyWith(
      totalPlans: null == totalPlans
          ? _value.totalPlans
          : totalPlans // ignore: cast_nullable_to_non_nullable
              as int,
      completedPlans: null == completedPlans
          ? _value.completedPlans
          : completedPlans // ignore: cast_nullable_to_non_nullable
              as int,
      pendingPlans: null == pendingPlans
          ? _value.pendingPlans
          : pendingPlans // ignore: cast_nullable_to_non_nullable
              as int,
      inProgressPlans: null == inProgressPlans
          ? _value.inProgressPlans
          : inProgressPlans // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledPlans: null == cancelledPlans
          ? _value.cancelledPlans
          : cancelledPlans // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanStatsImplCopyWith<$Res>
    implements $PlanStatsCopyWith<$Res> {
  factory _$$PlanStatsImplCopyWith(
          _$PlanStatsImpl value, $Res Function(_$PlanStatsImpl) then) =
      __$$PlanStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalPlans,
      int completedPlans,
      int pendingPlans,
      int inProgressPlans,
      int cancelledPlans,
      double completionRate});
}

/// @nodoc
class __$$PlanStatsImplCopyWithImpl<$Res>
    extends _$PlanStatsCopyWithImpl<$Res, _$PlanStatsImpl>
    implements _$$PlanStatsImplCopyWith<$Res> {
  __$$PlanStatsImplCopyWithImpl(
      _$PlanStatsImpl _value, $Res Function(_$PlanStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPlans = null,
    Object? completedPlans = null,
    Object? pendingPlans = null,
    Object? inProgressPlans = null,
    Object? cancelledPlans = null,
    Object? completionRate = null,
  }) {
    return _then(_$PlanStatsImpl(
      totalPlans: null == totalPlans
          ? _value.totalPlans
          : totalPlans // ignore: cast_nullable_to_non_nullable
              as int,
      completedPlans: null == completedPlans
          ? _value.completedPlans
          : completedPlans // ignore: cast_nullable_to_non_nullable
              as int,
      pendingPlans: null == pendingPlans
          ? _value.pendingPlans
          : pendingPlans // ignore: cast_nullable_to_non_nullable
              as int,
      inProgressPlans: null == inProgressPlans
          ? _value.inProgressPlans
          : inProgressPlans // ignore: cast_nullable_to_non_nullable
              as int,
      cancelledPlans: null == cancelledPlans
          ? _value.cancelledPlans
          : cancelledPlans // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanStatsImpl implements _PlanStats {
  const _$PlanStatsImpl(
      {this.totalPlans = 0,
      this.completedPlans = 0,
      this.pendingPlans = 0,
      this.inProgressPlans = 0,
      this.cancelledPlans = 0,
      this.completionRate = 0.0});

  factory _$PlanStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalPlans;
  @override
  @JsonKey()
  final int completedPlans;
  @override
  @JsonKey()
  final int pendingPlans;
  @override
  @JsonKey()
  final int inProgressPlans;
  @override
  @JsonKey()
  final int cancelledPlans;
  @override
  @JsonKey()
  final double completionRate;

  @override
  String toString() {
    return 'PlanStats(totalPlans: $totalPlans, completedPlans: $completedPlans, pendingPlans: $pendingPlans, inProgressPlans: $inProgressPlans, cancelledPlans: $cancelledPlans, completionRate: $completionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanStatsImpl &&
            (identical(other.totalPlans, totalPlans) ||
                other.totalPlans == totalPlans) &&
            (identical(other.completedPlans, completedPlans) ||
                other.completedPlans == completedPlans) &&
            (identical(other.pendingPlans, pendingPlans) ||
                other.pendingPlans == pendingPlans) &&
            (identical(other.inProgressPlans, inProgressPlans) ||
                other.inProgressPlans == inProgressPlans) &&
            (identical(other.cancelledPlans, cancelledPlans) ||
                other.cancelledPlans == cancelledPlans) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalPlans, completedPlans,
      pendingPlans, inProgressPlans, cancelledPlans, completionRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanStatsImplCopyWith<_$PlanStatsImpl> get copyWith =>
      __$$PlanStatsImplCopyWithImpl<_$PlanStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanStatsImplToJson(
      this,
    );
  }
}

abstract class _PlanStats implements PlanStats {
  const factory _PlanStats(
      {final int totalPlans,
      final int completedPlans,
      final int pendingPlans,
      final int inProgressPlans,
      final int cancelledPlans,
      final double completionRate}) = _$PlanStatsImpl;

  factory _PlanStats.fromJson(Map<String, dynamic> json) =
      _$PlanStatsImpl.fromJson;

  @override
  int get totalPlans;
  @override
  int get completedPlans;
  @override
  int get pendingPlans;
  @override
  int get inProgressPlans;
  @override
  int get cancelledPlans;
  @override
  double get completionRate;
  @override
  @JsonKey(ignore: true)
  _$$PlanStatsImplCopyWith<_$PlanStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePlanRequest _$CreatePlanRequestFromJson(Map<String, dynamic> json) {
  return _CreatePlanRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePlanRequest {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  PlanType get type => throw _privateConstructorUsedError;
  PlanPriority get priority => throw _privateConstructorUsedError;
  DateTime get planDate => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get reminderTime => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get courseId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePlanRequestCopyWith<CreatePlanRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlanRequestCopyWith<$Res> {
  factory $CreatePlanRequestCopyWith(
          CreatePlanRequest value, $Res Function(CreatePlanRequest) then) =
      _$CreatePlanRequestCopyWithImpl<$Res, CreatePlanRequest>;
  @useResult
  $Res call(
      {String title,
      String? description,
      PlanType type,
      PlanPriority priority,
      DateTime planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String> tags,
      String? courseId,
      String? notes});
}

/// @nodoc
class _$CreatePlanRequestCopyWithImpl<$Res, $Val extends CreatePlanRequest>
    implements $CreatePlanRequestCopyWith<$Res> {
  _$CreatePlanRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? planDate = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? courseId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority,
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePlanRequestImplCopyWith<$Res>
    implements $CreatePlanRequestCopyWith<$Res> {
  factory _$$CreatePlanRequestImplCopyWith(_$CreatePlanRequestImpl value,
          $Res Function(_$CreatePlanRequestImpl) then) =
      __$$CreatePlanRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      PlanType type,
      PlanPriority priority,
      DateTime planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String> tags,
      String? courseId,
      String? notes});
}

/// @nodoc
class __$$CreatePlanRequestImplCopyWithImpl<$Res>
    extends _$CreatePlanRequestCopyWithImpl<$Res, _$CreatePlanRequestImpl>
    implements _$$CreatePlanRequestImplCopyWith<$Res> {
  __$$CreatePlanRequestImplCopyWithImpl(_$CreatePlanRequestImpl _value,
      $Res Function(_$CreatePlanRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? planDate = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = null,
    Object? courseId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$CreatePlanRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority,
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePlanRequestImpl implements _CreatePlanRequest {
  const _$CreatePlanRequestImpl(
      {required this.title,
      this.description,
      this.type = PlanType.study,
      this.priority = PlanPriority.medium,
      required this.planDate,
      this.startTime,
      this.endTime,
      this.reminderTime,
      final List<String> tags = const [],
      this.courseId,
      this.notes})
      : _tags = tags;

  factory _$CreatePlanRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePlanRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final PlanType type;
  @override
  @JsonKey()
  final PlanPriority priority;
  @override
  final DateTime planDate;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? reminderTime;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? courseId;
  @override
  final String? notes;

  @override
  String toString() {
    return 'CreatePlanRequest(title: $title, description: $description, type: $type, priority: $priority, planDate: $planDate, startTime: $startTime, endTime: $endTime, reminderTime: $reminderTime, tags: $tags, courseId: $courseId, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePlanRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      type,
      priority,
      planDate,
      startTime,
      endTime,
      reminderTime,
      const DeepCollectionEquality().hash(_tags),
      courseId,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePlanRequestImplCopyWith<_$CreatePlanRequestImpl> get copyWith =>
      __$$CreatePlanRequestImplCopyWithImpl<_$CreatePlanRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePlanRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePlanRequest implements CreatePlanRequest {
  const factory _CreatePlanRequest(
      {required final String title,
      final String? description,
      final PlanType type,
      final PlanPriority priority,
      required final DateTime planDate,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? reminderTime,
      final List<String> tags,
      final String? courseId,
      final String? notes}) = _$CreatePlanRequestImpl;

  factory _CreatePlanRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePlanRequestImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  PlanType get type;
  @override
  PlanPriority get priority;
  @override
  DateTime get planDate;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get reminderTime;
  @override
  List<String> get tags;
  @override
  String? get courseId;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$CreatePlanRequestImplCopyWith<_$CreatePlanRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdatePlanRequest _$UpdatePlanRequestFromJson(Map<String, dynamic> json) {
  return _UpdatePlanRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdatePlanRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  PlanType? get type => throw _privateConstructorUsedError;
  PlanPriority? get priority => throw _privateConstructorUsedError;
  PlanStatus? get status => throw _privateConstructorUsedError;
  DateTime? get planDate => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  DateTime? get reminderTime => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get courseId => throw _privateConstructorUsedError;
  int? get progress => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdatePlanRequestCopyWith<UpdatePlanRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePlanRequestCopyWith<$Res> {
  factory $UpdatePlanRequestCopyWith(
          UpdatePlanRequest value, $Res Function(UpdatePlanRequest) then) =
      _$UpdatePlanRequestCopyWithImpl<$Res, UpdatePlanRequest>;
  @useResult
  $Res call(
      {String? title,
      String? description,
      PlanType? type,
      PlanPriority? priority,
      PlanStatus? status,
      DateTime? planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String>? tags,
      String? courseId,
      int? progress,
      String? notes});
}

/// @nodoc
class _$UpdatePlanRequestCopyWithImpl<$Res, $Val extends UpdatePlanRequest>
    implements $UpdatePlanRequestCopyWith<$Res> {
  _$UpdatePlanRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? planDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = freezed,
    Object? courseId = freezed,
    Object? progress = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus?,
      planDate: freezed == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePlanRequestImplCopyWith<$Res>
    implements $UpdatePlanRequestCopyWith<$Res> {
  factory _$$UpdatePlanRequestImplCopyWith(_$UpdatePlanRequestImpl value,
          $Res Function(_$UpdatePlanRequestImpl) then) =
      __$$UpdatePlanRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      PlanType? type,
      PlanPriority? priority,
      PlanStatus? status,
      DateTime? planDate,
      DateTime? startTime,
      DateTime? endTime,
      DateTime? reminderTime,
      List<String>? tags,
      String? courseId,
      int? progress,
      String? notes});
}

/// @nodoc
class __$$UpdatePlanRequestImplCopyWithImpl<$Res>
    extends _$UpdatePlanRequestCopyWithImpl<$Res, _$UpdatePlanRequestImpl>
    implements _$$UpdatePlanRequestImplCopyWith<$Res> {
  __$$UpdatePlanRequestImplCopyWithImpl(_$UpdatePlanRequestImpl _value,
      $Res Function(_$UpdatePlanRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? planDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? reminderTime = freezed,
    Object? tags = freezed,
    Object? courseId = freezed,
    Object? progress = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$UpdatePlanRequestImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlanType?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PlanPriority?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus?,
      planDate: freezed == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      courseId: freezed == courseId
          ? _value.courseId
          : courseId // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePlanRequestImpl implements _UpdatePlanRequest {
  const _$UpdatePlanRequestImpl(
      {this.title,
      this.description,
      this.type,
      this.priority,
      this.status,
      this.planDate,
      this.startTime,
      this.endTime,
      this.reminderTime,
      final List<String>? tags,
      this.courseId,
      this.progress,
      this.notes})
      : _tags = tags;

  factory _$UpdatePlanRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePlanRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final PlanType? type;
  @override
  final PlanPriority? priority;
  @override
  final PlanStatus? status;
  @override
  final DateTime? planDate;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final DateTime? reminderTime;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? courseId;
  @override
  final int? progress;
  @override
  final String? notes;

  @override
  String toString() {
    return 'UpdatePlanRequest(title: $title, description: $description, type: $type, priority: $priority, status: $status, planDate: $planDate, startTime: $startTime, endTime: $endTime, reminderTime: $reminderTime, tags: $tags, courseId: $courseId, progress: $progress, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePlanRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      type,
      priority,
      status,
      planDate,
      startTime,
      endTime,
      reminderTime,
      const DeepCollectionEquality().hash(_tags),
      courseId,
      progress,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePlanRequestImplCopyWith<_$UpdatePlanRequestImpl> get copyWith =>
      __$$UpdatePlanRequestImplCopyWithImpl<_$UpdatePlanRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePlanRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdatePlanRequest implements UpdatePlanRequest {
  const factory _UpdatePlanRequest(
      {final String? title,
      final String? description,
      final PlanType? type,
      final PlanPriority? priority,
      final PlanStatus? status,
      final DateTime? planDate,
      final DateTime? startTime,
      final DateTime? endTime,
      final DateTime? reminderTime,
      final List<String>? tags,
      final String? courseId,
      final int? progress,
      final String? notes}) = _$UpdatePlanRequestImpl;

  factory _UpdatePlanRequest.fromJson(Map<String, dynamic> json) =
      _$UpdatePlanRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  PlanType? get type;
  @override
  PlanPriority? get priority;
  @override
  PlanStatus? get status;
  @override
  DateTime? get planDate;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  DateTime? get reminderTime;
  @override
  List<String>? get tags;
  @override
  String? get courseId;
  @override
  int? get progress;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$UpdatePlanRequestImplCopyWith<_$UpdatePlanRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
