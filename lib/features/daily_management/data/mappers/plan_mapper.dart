import 'package:drift/drift.dart';
import '../../../../data/local/app_database.dart';
import '../../domain/entities/plan_entity.dart';

/// 计划数据映射器
/// 
/// 负责在数据库表数据和领域实体之间进行转换
class PlanMapper {
  /// 从数据库表数据转换为领域实体
  static PlanEntity fromTable(PlansTableData data) {
    return PlanEntity(
      id: data.id.toString(),
      title: data.title,
      description: data.description?.isNotEmpty == true ? data.description : null,
      type: _parseType(data.type),
      priority: _parsePriority(data.priority),
      status: _parseStatus(data.status),
      planDate: data.planDate,
      startTime: data.startTime,
      endTime: data.endTime,
      reminderTime: data.reminderTime,
      tags: _parseTags(data.tags),
      courseId: data.courseId?.toString(),
      progress: data.progress,
      notes: data.notes?.isNotEmpty == true ? data.notes : null,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      completedAt: data.completedAt,
    );
  }

  /// 解析计划类型
  static PlanType _parseType(String typeValue) {
    return PlanType.values
        .firstWhere(
          (type) => type.value == typeValue,
          orElse: () => PlanType.study,
        );
  }

  /// 解析计划优先级
  static PlanPriority _parsePriority(int priorityLevel) {
    return PlanPriority.values
        .firstWhere(
          (priority) => priority.level == priorityLevel,
          orElse: () => PlanPriority.medium,
        );
  }

  /// 解析计划状态
  static PlanStatus _parseStatus(String statusValue) {
    return PlanStatus.values
        .firstWhere(
          (status) => status.value == statusValue,
          orElse: () => PlanStatus.pending,
        );
  }

  /// 解析标签列表
  static List<String> _parseTags(String? tagsString) {
    if (tagsString == null || tagsString.isEmpty) {
      return [];
    }
    return tagsString
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  /// 将标签列表转换为字符串（用于存储）
  static String tagsToString(List<String> tags) {
    return tags.join(',');
  }

  /// 从创建请求生成数据库伴侣对象
  static PlansTableCompanion fromCreateRequest(CreatePlanRequest request) {
    return PlansTableCompanion.insert(
      title: request.title,
      planDate: request.planDate,
      description: Value(request.description),
      type: Value(request.type.value),
      priority: Value(request.priority.level),
      status: Value(PlanStatus.pending.value),
      startTime: Value(request.startTime),
      endTime: Value(request.endTime),
      reminderTime: Value(request.reminderTime),
      tags: Value(request.tags.isNotEmpty ? tagsToString(request.tags) : null),
      courseId: Value(request.courseId != null ? int.parse(request.courseId!) : null),
      notes: Value(request.notes),
    );
  }

  /// 批量转换
  static List<PlanEntity> fromTableList(List<PlansTableData> dataList) {
    return dataList.map(fromTable).toList();
  }
}