import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/ai_plan_bridge_service.dart';
import '../../../daily_management/presentation/providers/plan_notifier.dart';

/// AI计划桥接服务提供商
/// 
/// 管理AI与计划系统之间的桥接服务实例
final aiPlanBridgeServiceProvider = Provider<AIPlanBridgeService>((ref) {
  // 获取计划仓库依赖
  final planRepository = ref.watch(planRepositoryProvider);
  
  // 创建桥接服务实例
  return AIPlanBridgeService(planRepository, ref);
});

/// AI工具函数状态管理
/// 
/// 跟踪当前AI工具函数的启用状态和配置
class AIToolsState {
  final bool isEnabled;
  final Set<String> enabledFunctions;
  final bool isExecuting;
  final String? lastError;

  const AIToolsState({
    this.isEnabled = true,
    this.enabledFunctions = const {
      'read_course_schedule',
      'create_study_plan',
      'update_study_plan', 
      'delete_study_plan',
      'get_study_plans',
      'analyze_course_workload'
    },
    this.isExecuting = false,
    this.lastError,
  });

  AIToolsState copyWith({
    bool? isEnabled,
    Set<String>? enabledFunctions,
    bool? isExecuting,
    String? lastError,
  }) {
    return AIToolsState(
      isEnabled: isEnabled ?? this.isEnabled,
      enabledFunctions: enabledFunctions ?? this.enabledFunctions,
      isExecuting: isExecuting ?? this.isExecuting,
      lastError: lastError ?? this.lastError,
    );
  }

  /// 清除错误状态
  AIToolsState clearError() => copyWith(lastError: null);

  /// 检查指定函数是否启用
  bool isFunctionEnabled(String functionName) {
    return isEnabled && enabledFunctions.contains(functionName);
  }
}

/// AI工具函数状态管理器
class AIToolsNotifier extends StateNotifier<AIToolsState> {
  AIToolsNotifier() : super(const AIToolsState());

  /// 启用/禁用AI工具函数
  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }

  /// 启用特定函数
  void enableFunction(String functionName) {
    final updatedFunctions = Set<String>.from(state.enabledFunctions)
      ..add(functionName);
    state = state.copyWith(enabledFunctions: updatedFunctions);
  }

  /// 禁用特定函数
  void disableFunction(String functionName) {
    final updatedFunctions = Set<String>.from(state.enabledFunctions)
      ..remove(functionName);
    state = state.copyWith(enabledFunctions: updatedFunctions);
  }

  /// 设置批量函数状态
  void setEnabledFunctions(Set<String> functions) {
    state = state.copyWith(enabledFunctions: functions);
  }

  /// 设置执行状态
  void setExecuting(bool executing) {
    state = state.copyWith(isExecuting: executing);
  }

  /// 设置错误信息
  void setError(String error) {
    state = state.copyWith(lastError: error, isExecuting: false);
  }

  /// 清除错误
  void clearError() {
    state = state.clearError();
  }

  /// 重置为默认状态
  void reset() {
    state = const AIToolsState();
  }
}

/// AI工具函数状态提供商
final aiToolsStateProvider = StateNotifierProvider<AIToolsNotifier, AIToolsState>((ref) {
  return AIToolsNotifier();
});

/// 检查AI工具函数是否可用的提供商
final aiToolsAvailableProvider = Provider<bool>((ref) {
  final aiToolsState = ref.watch(aiToolsStateProvider);
  
  // 检查基本条件
  if (!aiToolsState.isEnabled) return false;
  if (aiToolsState.enabledFunctions.isEmpty) return false;
  
  // 检查计划仓库是否可用
  try {
    ref.read(planRepositoryProvider);
    return true;
  } catch (e) {
    return false;
  }
});

/// 当前执行中的AI函数调用信息
class ActiveFunctionCall {
  final String functionName;
  final Map<String, dynamic> arguments;
  final DateTime startTime;
  final String? sessionId;

  const ActiveFunctionCall({
    required this.functionName,
    required this.arguments,
    required this.startTime,
    this.sessionId,
  });

  Duration get duration => DateTime.now().difference(startTime);
}

/// 活跃函数调用状态管理器
class ActiveFunctionCallNotifier extends StateNotifier<ActiveFunctionCall?> {
  ActiveFunctionCallNotifier() : super(null);

  /// 开始函数调用
  void startFunctionCall(String functionName, Map<String, dynamic> arguments, {String? sessionId}) {
    state = ActiveFunctionCall(
      functionName: functionName,
      arguments: arguments,
      startTime: DateTime.now(),
      sessionId: sessionId,
    );
  }

  /// 结束函数调用
  void endFunctionCall() {
    state = null;
  }

  /// 检查是否有活跃的函数调用
  bool get hasActiveCall => state != null;

  /// 获取当前调用持续时间
  Duration? get currentCallDuration => state?.duration;
}

/// 活跃函数调用提供商
final activeFunctionCallProvider = StateNotifierProvider<ActiveFunctionCallNotifier, ActiveFunctionCall?>((ref) {
  return ActiveFunctionCallNotifier();
});

/// AI工具函数执行统计
class AIToolsStatistics {
  final int totalCalls;
  final int successfulCalls;
  final int failedCalls;
  final Map<String, int> functionCallCounts;
  final DateTime? lastCallTime;
  final Duration totalExecutionTime;

  const AIToolsStatistics({
    this.totalCalls = 0,
    this.successfulCalls = 0,
    this.failedCalls = 0,
    this.functionCallCounts = const {},
    this.lastCallTime,
    this.totalExecutionTime = Duration.zero,
  });

  AIToolsStatistics copyWith({
    int? totalCalls,
    int? successfulCalls,
    int? failedCalls,
    Map<String, int>? functionCallCounts,
    DateTime? lastCallTime,
    Duration? totalExecutionTime,
  }) {
    return AIToolsStatistics(
      totalCalls: totalCalls ?? this.totalCalls,
      successfulCalls: successfulCalls ?? this.successfulCalls,
      failedCalls: failedCalls ?? this.failedCalls,
      functionCallCounts: functionCallCounts ?? this.functionCallCounts,
      lastCallTime: lastCallTime ?? this.lastCallTime,
      totalExecutionTime: totalExecutionTime ?? this.totalExecutionTime,
    );
  }

  /// 记录成功调用
  AIToolsStatistics recordSuccess(String functionName, Duration executionTime) {
    final updatedCounts = Map<String, int>.from(functionCallCounts);
    updatedCounts[functionName] = (updatedCounts[functionName] ?? 0) + 1;

    return copyWith(
      totalCalls: totalCalls + 1,
      successfulCalls: successfulCalls + 1,
      functionCallCounts: updatedCounts,
      lastCallTime: DateTime.now(),
      totalExecutionTime: totalExecutionTime + executionTime,
    );
  }

  /// 记录失败调用
  AIToolsStatistics recordFailure(String functionName, Duration executionTime) {
    final updatedCounts = Map<String, int>.from(functionCallCounts);
    updatedCounts[functionName] = (updatedCounts[functionName] ?? 0) + 1;

    return copyWith(
      totalCalls: totalCalls + 1,
      failedCalls: failedCalls + 1,
      functionCallCounts: updatedCounts,
      lastCallTime: DateTime.now(),
      totalExecutionTime: totalExecutionTime + executionTime,
    );
  }

  /// 计算成功率
  double get successRate {
    if (totalCalls == 0) return 0.0;
    return successfulCalls / totalCalls;
  }

  /// 获取平均执行时间
  Duration get averageExecutionTime {
    if (totalCalls == 0) return Duration.zero;
    return Duration(microseconds: totalExecutionTime.inMicroseconds ~/ totalCalls);
  }

  /// 获取最常用函数
  String? get mostUsedFunction {
    if (functionCallCounts.isEmpty) return null;
    
    return functionCallCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

/// AI工具函数统计状态管理器
class AIToolsStatisticsNotifier extends StateNotifier<AIToolsStatistics> {
  AIToolsStatisticsNotifier() : super(const AIToolsStatistics());

  /// 记录成功调用
  void recordSuccess(String functionName, Duration executionTime) {
    state = state.recordSuccess(functionName, executionTime);
  }

  /// 记录失败调用
  void recordFailure(String functionName, Duration executionTime) {
    state = state.recordFailure(functionName, executionTime);
  }

  /// 重置统计信息
  void reset() {
    state = const AIToolsStatistics();
  }
}

/// AI工具函数统计提供商
final aiToolsStatisticsProvider = StateNotifierProvider<AIToolsStatisticsNotifier, AIToolsStatistics>((ref) {
  return AIToolsStatisticsNotifier();
});