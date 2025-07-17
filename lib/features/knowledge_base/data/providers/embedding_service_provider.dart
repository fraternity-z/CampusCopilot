import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/embedding_service.dart';
import '../../../../core/di/database_providers.dart';

/// 嵌入服务提供者
///
/// 提供支持实时模型切换的嵌入服务
final embeddingServiceProvider = Provider<EmbeddingService>((ref) {
  final database = ref.read(appDatabaseProvider);
  return EmbeddingService(database);
});

/// 嵌入服务状态提供者
final embeddingServiceStateProvider =
    StateNotifierProvider<EmbeddingServiceStateNotifier, EmbeddingServiceState>(
      (ref) {
        final embeddingService = ref.read(embeddingServiceProvider);
        return EmbeddingServiceStateNotifier(embeddingService);
      },
    );

/// 嵌入服务状态
class EmbeddingServiceState {
  final bool isInitialized;
  final String? currentProvider;
  final String? currentModel;
  final DateTime? lastRefresh;
  final String? error;

  const EmbeddingServiceState({
    this.isInitialized = false,
    this.currentProvider,
    this.currentModel,
    this.lastRefresh,
    this.error,
  });

  EmbeddingServiceState copyWith({
    bool? isInitialized,
    String? currentProvider,
    String? currentModel,
    DateTime? lastRefresh,
    String? error,
  }) {
    return EmbeddingServiceState(
      isInitialized: isInitialized ?? this.isInitialized,
      currentProvider: currentProvider ?? this.currentProvider,
      currentModel: currentModel ?? this.currentModel,
      lastRefresh: lastRefresh ?? this.lastRefresh,
      error: error,
    );
  }

  @override
  String toString() {
    return 'EmbeddingServiceState('
        'isInitialized: $isInitialized, '
        'currentProvider: $currentProvider, '
        'currentModel: $currentModel, '
        'lastRefresh: $lastRefresh, '
        'error: $error'
        ')';
  }
}

/// 嵌入服务状态管理器
class EmbeddingServiceStateNotifier
    extends StateNotifier<EmbeddingServiceState> {
  final EmbeddingService _embeddingService;

  EmbeddingServiceStateNotifier(this._embeddingService)
    : super(const EmbeddingServiceState()) {
    _initialize();
  }

  /// 初始化服务
  void _initialize() {
    state = state.copyWith(isInitialized: true, lastRefresh: DateTime.now());
    debugPrint('✅ 嵌入服务状态管理器已初始化');
  }

  /// 刷新嵌入服务（清除缓存）
  void refreshService({String? newProvider, String? newModel}) {
    try {
      debugPrint('🔄 刷新嵌入服务...');

      // 清除嵌入服务缓存
      _embeddingService.clearCache();

      // 更新状态
      state = state.copyWith(
        currentProvider: newProvider ?? state.currentProvider,
        currentModel: newModel ?? state.currentModel,
        lastRefresh: DateTime.now(),
        error: null,
      );

      debugPrint('✅ 嵌入服务已刷新');
      debugPrint('📊 当前提供者: ${state.currentProvider}');
      debugPrint('📊 当前模型: ${state.currentModel}');
    } catch (e) {
      debugPrint('❌ 刷新嵌入服务失败: $e');
      state = state.copyWith(
        error: '刷新嵌入服务失败: $e',
        lastRefresh: DateTime.now(),
      );
    }
  }

  /// 更新当前使用的提供者和模型
  void updateCurrentProviderAndModel(String provider, String model) {
    if (state.currentProvider != provider || state.currentModel != model) {
      debugPrint('🔄 嵌入模型切换: $provider/$model');

      // 清除缓存以确保使用新的提供者
      _embeddingService.clearCache();

      state = state.copyWith(
        currentProvider: provider,
        currentModel: model,
        lastRefresh: DateTime.now(),
        error: null,
      );

      debugPrint('✅ 嵌入模型已切换到: $provider/$model');
    }
  }

  /// 清除错误状态
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  /// 获取服务统计信息
  Map<String, dynamic> getServiceStats() {
    return {
      'isInitialized': state.isInitialized,
      'currentProvider': state.currentProvider ?? 'unknown',
      'currentModel': state.currentModel ?? 'unknown',
      'lastRefresh': state.lastRefresh?.toIso8601String(),
      'hasError': state.error != null,
      'error': state.error,
    };
  }
}

/// 嵌入服务统计信息提供者
final embeddingServiceStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.read(embeddingServiceStateProvider.notifier);
  return notifier.getServiceStats();
});

/// 嵌入服务健康状态提供者
final embeddingServiceHealthProvider = Provider<bool>((ref) {
  final serviceState = ref.watch(embeddingServiceStateProvider);
  return serviceState.isInitialized && serviceState.error == null;
});

/// 当前嵌入提供者信息提供者
final currentEmbeddingProviderInfoProvider = Provider<Map<String, String?>>((
  ref,
) {
  final serviceState = ref.watch(embeddingServiceStateProvider);
  return {
    'provider': serviceState.currentProvider,
    'model': serviceState.currentModel,
    'lastRefresh': serviceState.lastRefresh?.toIso8601String(),
  };
});

/// 嵌入服务刷新动作提供者
final embeddingServiceRefreshProvider =
    Provider<void Function({String? newProvider, String? newModel})>((ref) {
      final notifier = ref.read(embeddingServiceStateProvider.notifier);
      return notifier.refreshService;
    });

/// 嵌入模型切换动作提供者
final embeddingModelSwitchProvider =
    Provider<void Function(String provider, String model)>((ref) {
      final notifier = ref.read(embeddingServiceStateProvider.notifier);
      return notifier.updateCurrentProviderAndModel;
    });
