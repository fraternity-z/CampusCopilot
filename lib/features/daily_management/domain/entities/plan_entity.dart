import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_entity.freezed.dart';
part 'plan_entity.g.dart';

/// 计划实体类
/// 
/// 表示用户的日常计划任务，包含所有必要的属性和状态信息
@freezed
class PlanEntity with _$PlanEntity {
  const factory PlanEntity({
    /// 计划ID
    required String id,
    
    /// 计划标题
    required String title,
    
    /// 计划描述
    String? description,
    
    /// 计划类型
    @Default(PlanType.study) PlanType type,
    
    /// 优先级
    @Default(PlanPriority.medium) PlanPriority priority,
    
    /// 计划状态
    @Default(PlanStatus.pending) PlanStatus status,
    
    /// 计划日期
    required DateTime planDate,
    
    /// 开始时间
    DateTime? startTime,
    
    /// 结束时间
    DateTime? endTime,
    
    /// 提醒时间
    DateTime? reminderTime,
    
    /// 标签列表
    @Default([]) List<String> tags,
    
    /// 关联的课程ID
    String? courseId,
    
    /// 完成进度 (0-100)
    @Default(0) int progress,
    
    /// 备注
    String? notes,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 完成时间
    DateTime? completedAt,
  }) = _PlanEntity;

  factory PlanEntity.fromJson(Map<String, dynamic> json) =>
      _$PlanEntityFromJson(json);
}

/// 计划类型枚举
@JsonEnum(valueField: 'value')
enum PlanType {
  study('study', '学习'),
  work('work', '工作'),
  life('life', '生活'),
  other('other', '其他');

  const PlanType(this.value, this.displayName);
  
  final String value;
  final String displayName;
}

/// 计划优先级枚举
@JsonEnum(valueField: 'level')
enum PlanPriority {
  low(1, '低'),
  medium(2, '中'),
  high(3, '高');

  const PlanPriority(this.level, this.displayName);
  
  final int level;
  final String displayName;
}

/// 计划状态枚举
@JsonEnum(valueField: 'value')
enum PlanStatus {
  pending('pending', '待处理'),
  inProgress('in_progress', '进行中'),
  completed('completed', '已完成'),
  cancelled('cancelled', '已取消');

  const PlanStatus(this.value, this.displayName);
  
  final String value;
  final String displayName;
}

/// 计划统计信息
@freezed
class PlanStats with _$PlanStats {
  const factory PlanStats({
    @Default(0) int totalPlans,
    @Default(0) int completedPlans,
    @Default(0) int pendingPlans,
    @Default(0) int inProgressPlans,
    @Default(0) int cancelledPlans,
    @Default(0.0) double completionRate,
  }) = _PlanStats;

  factory PlanStats.fromJson(Map<String, dynamic> json) =>
      _$PlanStatsFromJson(json);
}

/// 创建计划请求
@freezed
class CreatePlanRequest with _$CreatePlanRequest {
  const factory CreatePlanRequest({
    required String title,
    String? description,
    @Default(PlanType.study) PlanType type,
    @Default(PlanPriority.medium) PlanPriority priority,
    required DateTime planDate,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? reminderTime,
    @Default([]) List<String> tags,
    String? courseId,
    String? notes,
  }) = _CreatePlanRequest;

  factory CreatePlanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePlanRequestFromJson(json);
}

/// 更新计划请求
@freezed
class UpdatePlanRequest with _$UpdatePlanRequest {
  const factory UpdatePlanRequest({
    String? title,
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
    String? notes,
  }) = _UpdatePlanRequest;

  factory UpdatePlanRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePlanRequestFromJson(json);
}