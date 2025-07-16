import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../migration/vector_database_migration.dart';

/// 迁移状态枚举
enum MigrationStatus {
  /// 未开始
  notStarted,
  /// 检查中
  checking,
  /// 需要迁移
  needsMigration,
  /// 迁移中
  migrating,
  /// 迁移完成
  completed,
  /// 迁移失败
  failed,
  /// 不需要迁移
  notNeeded,
}

/// 迁移状态数据
class MigrationState {
  final MigrationStatus status;
  final VectorMigrationResult? result;
  final String? error;
  final double progress;

  const MigrationState({
    required this.status,
    this.result,
    this.error,
    this.progress = 0.0,
  });

  MigrationState copyWith({
    MigrationStatus? status,
    VectorMigrationResult? result,
    String? error,
    double? progress,
  }) {
    return MigrationState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      progress: progress ?? this.progress,
    );
  }
}

/// 迁移状态管理器
class MigrationNotifier extends StateNotifier<MigrationState> {
  MigrationNotifier() : super(const MigrationState(status: MigrationStatus.notStarted));

  /// 检查是否需要迁移
  Future<void> checkMigrationNeeded() async {
    try {
      state = state.copyWith(status: MigrationStatus.checking);
      
      final needsMigration = await VectorDatabaseMigration.needsMigration();
      
      if (needsMigration) {
        state = state.copyWith(status: MigrationStatus.needsMigration);
        debugPrint('📋 检测到需要进行向量数据库迁移');
      } else {
        state = state.copyWith(status: MigrationStatus.notNeeded);
        debugPrint('✅ 无需进行向量数据库迁移');
      }
    } catch (e) {
      state = state.copyWith(
        status: MigrationStatus.failed,
        error: '检查迁移需求失败: $e',
      );
      debugPrint('❌ 检查迁移需求失败: $e');
    }
  }

  /// 执行迁移
  Future<void> performMigration({
    String? localDbPath,
    bool deleteSourceAfterMigration = false,
  }) async {
    try {
      state = state.copyWith(
        status: MigrationStatus.migrating,
        progress: 0.0,
      );

      debugPrint('🚀 开始执行向量数据库迁移...');

      // 执行迁移
      final result = await VectorDatabaseMigration.migrateFromLocalFileToObjectBox(
        localDbPath: localDbPath,
        deleteSourceAfterMigration: deleteSourceAfterMigration,
      );

      if (result.success) {
        state = state.copyWith(
          status: MigrationStatus.completed,
          result: result,
          progress: 1.0,
        );
        debugPrint('✅ 向量数据库迁移成功完成');
      } else {
        state = state.copyWith(
          status: MigrationStatus.failed,
          result: result,
          error: '迁移失败: ${result.errors.join(', ')}',
        );
        debugPrint('❌ 向量数据库迁移失败');
      }
    } catch (e) {
      state = state.copyWith(
        status: MigrationStatus.failed,
        error: '迁移异常: $e',
      );
      debugPrint('❌ 向量数据库迁移异常: $e');
    }
  }

  /// 重置迁移状态
  void reset() {
    state = const MigrationState(status: MigrationStatus.notStarted);
    debugPrint('🔄 迁移状态已重置');
  }

  /// 跳过迁移
  void skipMigration() {
    state = state.copyWith(status: MigrationStatus.notNeeded);
    debugPrint('⏭️ 用户选择跳过迁移');
  }
}

/// 迁移状态提供者
final migrationProvider = StateNotifierProvider<MigrationNotifier, MigrationState>(
  (ref) => MigrationNotifier(),
);

/// 自动检查迁移需求提供者
final autoMigrationCheckProvider = FutureProvider<bool>((ref) async {
  final migrationNotifier = ref.read(migrationProvider.notifier);
  await migrationNotifier.checkMigrationNeeded();
  
  final state = ref.read(migrationProvider);
  return state.status == MigrationStatus.needsMigration;
});

/// 迁移进度提供者
final migrationProgressProvider = Provider<double>((ref) {
  final state = ref.watch(migrationProvider);
  return state.progress;
});

/// 迁移错误提供者
final migrationErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(migrationProvider);
  return state.error;
});

/// 迁移结果提供者
final migrationResultProvider = Provider<VectorMigrationResult?>((ref) {
  final state = ref.watch(migrationProvider);
  return state.result;
});
