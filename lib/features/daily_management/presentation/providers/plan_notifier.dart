import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/database_providers.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/plan_repository.dart';
import '../../data/repositories/plan_repository_impl.dart';

/// 计划仓库提供商
final planRepositoryProvider = Provider<PlanRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return PlanRepositoryImpl(database);
});


/// 计划状态管理器
class PlanNotifier extends StateNotifier<PlanState> {
  final PlanRepository _repository;

  PlanNotifier(this._repository) : super(const PlanState.loading()) {
    loadPlans();
  }

  /// 加载所有计划
  Future<void> loadPlans() async {
    try {
      state = const PlanState.loading();
      final plans = await _repository.getAllPlans();
      state = PlanState.loaded(plans);
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 创建计划
  Future<void> createPlan(CreatePlanRequest request) async {
    try {
      final plan = await _repository.createPlan(request);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = [plan, ...currentPlans];
        state = PlanState.loaded(updatedPlans);
      } else {
        await loadPlans();
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 更新计划
  Future<void> updatePlan(String id, UpdatePlanRequest request) async {
    try {
      final updatedPlan = await _repository.updatePlan(id, request);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = currentPlans
            .map((plan) => plan.id == id ? updatedPlan : plan)
            .toList();
        state = PlanState.loaded(updatedPlans);
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 删除计划
  Future<void> deletePlan(String id) async {
    try {
      await _repository.deletePlan(id);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = currentPlans.where((plan) => plan.id != id).toList();
        state = PlanState.loaded(updatedPlans);
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 更新计划状态
  Future<void> updatePlanStatus(String id, PlanStatus status) async {
    try {
      await _repository.updatePlanStatus(id, status);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = currentPlans.map((plan) {
          if (plan.id == id) {
            return plan.copyWith(
              status: status,
              updatedAt: DateTime.now(),
              completedAt: status == PlanStatus.completed ? DateTime.now() : null,
              progress: status == PlanStatus.completed ? 100 : plan.progress,
            );
          }
          return plan;
        }).toList();
        state = PlanState.loaded(updatedPlans);
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 更新计划进度
  Future<void> updatePlanProgress(String id, int progress) async {
    try {
      await _repository.updatePlanProgress(id, progress);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = currentPlans.map((plan) {
          if (plan.id == id) {
            return plan.copyWith(
              progress: progress,
              status: progress >= 100 ? PlanStatus.completed : plan.status,
              updatedAt: DateTime.now(),
              completedAt: progress >= 100 ? DateTime.now() : null,
            );
          }
          return plan;
        }).toList();
        state = PlanState.loaded(updatedPlans);
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 完成计划
  Future<void> completePlan(String id) async {
    await updatePlanStatus(id, PlanStatus.completed);
  }

  /// 取消计划
  Future<void> cancelPlan(String id) async {
    await updatePlanStatus(id, PlanStatus.cancelled);
  }

  /// 批量删除计划
  Future<void> deletePlans(List<String> ids) async {
    try {
      await _repository.deletePlans(ids);
      
      if (state is Loaded) {
        final currentPlans = (state as Loaded).plans;
        final updatedPlans = currentPlans
            .where((plan) => !ids.contains(plan.id))
            .toList();
        state = PlanState.loaded(updatedPlans);
      }
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 搜索计划
  Future<void> searchPlans(String query) async {
    try {
      state = const PlanState.loading();
      final plans = await _repository.searchPlans(query);
      state = PlanState.loaded(plans);
    } catch (e) {
      state = PlanState.error(e.toString());
    }
  }

  /// 按状态筛选计划
  List<PlanEntity> filterByStatus(PlanStatus status) {
    if (state is Loaded) {
      final plans = (state as Loaded).plans;
      return plans.where((plan) => plan.status == status).toList();
    }
    return [];
  }

  /// 按类型筛选计划
  List<PlanEntity> filterByType(PlanType type) {
    if (state is Loaded) {
      final plans = (state as Loaded).plans;
      return plans.where((plan) => plan.type == type).toList();
    }
    return [];
  }

  /// 按优先级筛选计划
  List<PlanEntity> filterByPriority(PlanPriority priority) {
    if (state is Loaded) {
      final plans = (state as Loaded).plans;
      return plans.where((plan) => plan.priority == priority).toList();
    }
    return [];
  }

  /// 获取今日计划
  List<PlanEntity> getTodayPlans() {
    if (state is Loaded) {
      final plans = (state as Loaded).plans;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      return plans.where((plan) {
        return plan.planDate.isAfter(startOfDay) && 
               plan.planDate.isBefore(endOfDay);
      }).toList();
    }
    return [];
  }
}

/// 计划状态
sealed class PlanState {
  const PlanState();

  const factory PlanState.loading() = Loading;
  const factory PlanState.loaded(List<PlanEntity> plans) = Loaded;
  const factory PlanState.error(String message) = Error;
}

class Loading extends PlanState {
  const Loading();
}

class Loaded extends PlanState {
  final List<PlanEntity> plans;
  const Loaded(this.plans);
}

class Error extends PlanState {
  final String message;
  const Error(this.message);
}

/// 计划通知器提供商
final planNotifierProvider = StateNotifierProvider<PlanNotifier, PlanState>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return PlanNotifier(repository);
});

/// 计划统计提供商
final planStatsProvider = FutureProvider<PlanStats>((ref) async {
  final repository = ref.watch(planRepositoryProvider);
  return await repository.getPlanStats();
});

/// 今日计划统计提供商
final todayPlanStatsProvider = FutureProvider<PlanStats>((ref) async {
  final repository = ref.watch(planRepositoryProvider);
  final today = DateTime.now();
  return await repository.getPlanStatsByDate(today);
});

/// 今日计划提供商
final todayPlansProvider = Provider<List<PlanEntity>>((ref) {
  final planState = ref.watch(planNotifierProvider);
  
  if (planState is Loaded) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return planState.plans.where((plan) {
      return plan.planDate.isAfter(startOfDay) && 
             plan.planDate.isBefore(endOfDay);
    }).toList()..sort((a, b) {
      // 按优先级和时间排序
      final priorityComparison = b.priority.level.compareTo(a.priority.level);
      if (priorityComparison != 0) return priorityComparison;
      
      if (a.startTime != null && b.startTime != null) {
        return a.startTime!.compareTo(b.startTime!);
      }
      
      return a.planDate.compareTo(b.planDate);
    });
  }
  
  return [];
});

/// 按状态分组的计划提供商
final plansByStatusProvider = Provider<Map<PlanStatus, List<PlanEntity>>>((ref) {
  final planState = ref.watch(planNotifierProvider);
  
  if (planState is Loaded) {
    final Map<PlanStatus, List<PlanEntity>> groupedPlans = {};
    
    for (final status in PlanStatus.values) {
      groupedPlans[status] = planState.plans
          .where((plan) => plan.status == status)
          .toList();
    }
    
    return groupedPlans;
  }
  
  return {};
});

/// 按类型分组的计划提供商
final plansByTypeProvider = Provider<Map<PlanType, List<PlanEntity>>>((ref) {
  final planState = ref.watch(planNotifierProvider);
  
  if (planState is Loaded) {
    final Map<PlanType, List<PlanEntity>> groupedPlans = {};
    
    for (final type in PlanType.values) {
      groupedPlans[type] = planState.plans
          .where((plan) => plan.type == type)
          .toList();
    }
    
    return groupedPlans;
  }
  
  return {};
});

/// 计划筛选器状态
class PlanFilter {
  final PlanStatus? status;
  final PlanType? type;
  final PlanPriority? priority;
  final String? searchQuery;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const PlanFilter({
    this.status,
    this.type,
    this.priority,
    this.searchQuery,
    this.dateFrom,
    this.dateTo,
  });

  PlanFilter copyWith({
    PlanStatus? status,
    PlanType? type,
    PlanPriority? priority,
    String? searchQuery,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return PlanFilter(
      status: status ?? this.status,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }
}

/// 计划筛选器状态管理器
class PlanFilterNotifier extends StateNotifier<PlanFilter> {
  PlanFilterNotifier() : super(const PlanFilter());

  void updateStatus(PlanStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateType(PlanType? type) {
    state = state.copyWith(type: type);
  }

  void updatePriority(PlanPriority? priority) {
    state = state.copyWith(priority: priority);
  }

  void updateSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(dateFrom: from, dateTo: to);
  }

  void clearFilters() {
    state = const PlanFilter();
  }
}

/// 计划筛选器提供商
final planFilterProvider = StateNotifierProvider<PlanFilterNotifier, PlanFilter>((ref) {
  return PlanFilterNotifier();
});

/// 筛选后的计划提供商
final filteredPlansProvider = Provider<List<PlanEntity>>((ref) {
  final planState = ref.watch(planNotifierProvider);
  final filter = ref.watch(planFilterProvider);
  
  if (planState is Loaded) {
    var plans = planState.plans;
    
    // 按状态筛选
    if (filter.status != null) {
      plans = plans.where((plan) => plan.status == filter.status).toList();
    }
    
    // 按类型筛选
    if (filter.type != null) {
      plans = plans.where((plan) => plan.type == filter.type).toList();
    }
    
    // 按优先级筛选
    if (filter.priority != null) {
      plans = plans.where((plan) => plan.priority == filter.priority).toList();
    }
    
    // 按搜索关键词筛选
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      plans = plans.where((plan) {
        return plan.title.toLowerCase().contains(query) ||
            (plan.description?.toLowerCase().contains(query) ?? false) ||
            plan.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }
    
    // 按日期范围筛选
    if (filter.dateFrom != null && filter.dateTo != null) {
      plans = plans.where((plan) {
        return plan.planDate.isAfter(filter.dateFrom!) && 
               plan.planDate.isBefore(filter.dateTo!);
      }).toList();
    }
    
    return plans;
  }
  
  return [];
});