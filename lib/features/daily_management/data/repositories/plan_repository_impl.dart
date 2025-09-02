import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/plan_repository.dart';
import '../mappers/plan_mapper.dart';

/// 计划仓库实现类
/// 
/// 实现计划数据的持久化存储和查询操作
class PlanRepositoryImpl implements PlanRepository {
  final AppDatabase _database;

  PlanRepositoryImpl(this._database);

  @override
  Future<PlanEntity> createPlan(CreatePlanRequest request) async {
    final companion = PlanMapper.fromCreateRequest(request);
    
    final insertedId = await _database.into(_database.plansTable).insert(companion);
    
    // 返回创建的计划
    final created = await (_database.select(_database.plansTable)
      ..where((p) => p.id.equals(insertedId))).getSingleOrNull();
    
    if (created == null) {
      throw Exception('创建计划失败');
    }
    
    return PlanMapper.fromTable(created);
  }

  @override
  Future<PlanEntity?> getPlanById(String id) async {
    final result = await (_database.select(_database.plansTable)
          ..where((t) => t.id.equals(int.parse(id))))
        .getSingleOrNull();
    
    return result != null ? PlanMapper.fromTable(result) : null;
  }

  @override
  Future<List<PlanEntity>> getAllPlans() async {
    final results = await (_database.select(_database.plansTable)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<List<PlanEntity>> getPlansByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final results = await (_database.select(_database.plansTable)
          ..where((t) => t.planDate.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm.asc(t.planDate)]))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<List<PlanEntity>> getPlansByStatus(PlanStatus status) async {
    final results = await (_database.select(_database.plansTable)
          ..where((t) => t.status.equals(status.value))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<List<PlanEntity>> getPlansByType(PlanType type) async {
    final results = await (_database.select(_database.plansTable)
          ..where((t) => t.type.equals(type.value))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<List<PlanEntity>> getPlansByPriority(PlanPriority priority) async {
    final results = await (_database.select(_database.plansTable)
          ..where((t) => t.priority.equals(priority.level))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<List<PlanEntity>> getTodayPlans() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getPlansByDateRange(startOfDay, endOfDay);
  }

  @override
  Future<List<PlanEntity>> searchPlans(String query) async {
    final lowerQuery = query.toLowerCase();
    final results = await (_database.select(_database.plansTable)..where(
          (t) =>
              t.title.lower().contains(lowerQuery) |
              t.description.lower().contains(lowerQuery) |
              t.notes.lower().contains(lowerQuery),
        ))
        .get();
    
    return results.map(PlanMapper.fromTable).toList();
  }

  @override
  Future<PlanEntity> updatePlan(String id, UpdatePlanRequest request) async {
    final companion = PlansTableCompanion(
      title: request.title != null ? Value(request.title!) : const Value.absent(),
      description: request.description != null 
          ? Value(request.description) 
          : const Value.absent(),
      type: request.type != null 
          ? Value(request.type!.value) 
          : const Value.absent(),
      priority: request.priority != null 
          ? Value(request.priority!.level) 
          : const Value.absent(),
      status: request.status != null 
          ? Value(request.status!.value) 
          : const Value.absent(),
      planDate: request.planDate != null 
          ? Value(request.planDate!) 
          : const Value.absent(),
      startTime: request.startTime != null 
          ? Value(request.startTime) 
          : const Value.absent(),
      endTime: request.endTime != null 
          ? Value(request.endTime) 
          : const Value.absent(),
      reminderTime: request.reminderTime != null 
          ? Value(request.reminderTime) 
          : const Value.absent(),
      tags: request.tags != null 
          ? Value(request.tags!.join(',')) 
          : const Value.absent(),
      courseId: request.courseId != null 
          ? Value(int.parse(request.courseId!)) 
          : const Value.absent(),
      progress: request.progress != null 
          ? Value(request.progress!) 
          : const Value.absent(),
      notes: request.notes != null 
          ? Value(request.notes) 
          : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await (_database.update(_database.plansTable)..where((t) => t.id.equals(int.parse(id))))
        .write(companion);
    
    final updated = await getPlanById(id);
    if (updated == null) {
      throw Exception('更新计划失败');
    }
    
    return updated;
  }

  @override
  Future<void> deletePlan(String id) async {
    await (_database.delete(_database.plansTable)..where((t) => t.id.equals(int.parse(id))))
        .go();
  }

  @override
  Future<void> deletePlans(List<String> ids) async {
    await _database.transaction(() async {
      for (final id in ids) {
        await deletePlan(id);
      }
    });
  }

  @override
  Future<void> updatePlanStatus(String id, PlanStatus status) async {
    final companion = PlansTableCompanion(
      status: Value(status.value),
      updatedAt: Value(DateTime.now()),
      completedAt: status == PlanStatus.completed 
          ? Value(DateTime.now()) 
          : const Value.absent(),
    );

    await (_database.update(_database.plansTable)..where((t) => t.id.equals(int.parse(id))))
        .write(companion);
  }

  @override
  Future<void> updatePlanProgress(String id, int progress) async {
    final companion = PlansTableCompanion(
      progress: Value(progress),
      updatedAt: Value(DateTime.now()),
      status: progress >= 100 
          ? Value(PlanStatus.completed.value) 
          : const Value.absent(),
      completedAt: progress >= 100 
          ? Value(DateTime.now()) 
          : const Value.absent(),
    );

    await (_database.update(_database.plansTable)..where((t) => t.id.equals(int.parse(id))))
        .write(companion);
  }

  @override
  Future<void> completePlan(String id) async {
    await updatePlanStatus(id, PlanStatus.completed);
    await updatePlanProgress(id, 100);
  }

  @override
  Future<void> cancelPlan(String id) async {
    await updatePlanStatus(id, PlanStatus.cancelled);
  }

  @override
  Future<PlanStats> getPlanStats() async {
    final allPlans = await getAllPlans();
    
    final totalPlans = allPlans.length;
    final completedPlans = allPlans.where((p) => p.status == PlanStatus.completed).length;
    final pendingPlans = allPlans.where((p) => p.status == PlanStatus.pending).length;
    final inProgressPlans = allPlans.where((p) => p.status == PlanStatus.inProgress).length;
    final cancelledPlans = allPlans.where((p) => p.status == PlanStatus.cancelled).length;
    
    final completionRate = totalPlans > 0 ? completedPlans / totalPlans : 0.0;

    return PlanStats(
      totalPlans: totalPlans,
      completedPlans: completedPlans,
      pendingPlans: pendingPlans,
      inProgressPlans: inProgressPlans,
      cancelledPlans: cancelledPlans,
      completionRate: completionRate,
    );
  }

  @override
  Future<PlanStats> getPlanStatsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final dayPlans = await getPlansByDateRange(startOfDay, endOfDay);
    
    final totalPlans = dayPlans.length;
    final completedPlans = dayPlans.where((p) => p.status == PlanStatus.completed).length;
    final pendingPlans = dayPlans.where((p) => p.status == PlanStatus.pending).length;
    final inProgressPlans = dayPlans.where((p) => p.status == PlanStatus.inProgress).length;
    final cancelledPlans = dayPlans.where((p) => p.status == PlanStatus.cancelled).length;
    
    final completionRate = totalPlans > 0 ? completedPlans / totalPlans : 0.0;

    return PlanStats(
      totalPlans: totalPlans,
      completedPlans: completedPlans,
      pendingPlans: pendingPlans,
      inProgressPlans: inProgressPlans,
      cancelledPlans: cancelledPlans,
      completionRate: completionRate,
    );
  }

  @override
  Stream<List<PlanEntity>> watchAllPlans() {
    return (_database.select(_database.plansTable)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((results) => results.map(PlanMapper.fromTable).toList());
  }

  @override
  Stream<List<PlanEntity>> watchTodayPlans() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return watchPlansByDateRange(startOfDay, endOfDay);
  }

  @override
  Stream<List<PlanEntity>> watchPlansByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (_database.select(_database.plansTable)
          ..where((t) => t.planDate.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm.asc(t.planDate)]))
        .watch()
        .map((results) => results.map(PlanMapper.fromTable).toList());
  }
}

/// 数据库扩展，为AppDatabase添加计划相关的便捷方法
extension AppDatabasePlanExtension on AppDatabase {
  Future<PlansTableData?> getPlanById(String id) {
    return (select(plansTable)..where((t) => t.id.equals(int.parse(id)))).getSingleOrNull();
  }
}