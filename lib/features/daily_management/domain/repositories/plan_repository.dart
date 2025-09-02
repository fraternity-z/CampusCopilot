import '../entities/plan_entity.dart';

/// 计划仓库接口
/// 
/// 定义计划数据访问的所有操作
abstract class PlanRepository {
  /// 创建计划
  Future<PlanEntity> createPlan(CreatePlanRequest request);

  /// 根据ID获取计划
  Future<PlanEntity?> getPlanById(String id);

  /// 获取所有计划
  Future<List<PlanEntity>> getAllPlans();

  /// 根据日期范围获取计划
  Future<List<PlanEntity>> getPlansByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// 根据状态获取计划
  Future<List<PlanEntity>> getPlansByStatus(PlanStatus status);

  /// 根据类型获取计划
  Future<List<PlanEntity>> getPlansByType(PlanType type);

  /// 根据优先级获取计划
  Future<List<PlanEntity>> getPlansByPriority(PlanPriority priority);

  /// 获取今日计划
  Future<List<PlanEntity>> getTodayPlans();

  /// 搜索计划
  Future<List<PlanEntity>> searchPlans(String query);

  /// 更新计划
  Future<PlanEntity> updatePlan(String id, UpdatePlanRequest request);

  /// 删除计划
  Future<void> deletePlan(String id);

  /// 批量删除计划
  Future<void> deletePlans(List<String> ids);

  /// 更新计划状态
  Future<void> updatePlanStatus(String id, PlanStatus status);

  /// 更新计划进度
  Future<void> updatePlanProgress(String id, int progress);

  /// 完成计划
  Future<void> completePlan(String id);

  /// 取消计划
  Future<void> cancelPlan(String id);

  /// 获取计划统计信息
  Future<PlanStats> getPlanStats();

  /// 获取指定日期的计划统计
  Future<PlanStats> getPlanStatsByDate(DateTime date);

  /// 监听计划变化（用于实时更新UI）
  Stream<List<PlanEntity>> watchAllPlans();

  /// 监听今日计划变化
  Stream<List<PlanEntity>> watchTodayPlans();

  /// 监听指定日期范围的计划变化
  Stream<List<PlanEntity>> watchPlansByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}