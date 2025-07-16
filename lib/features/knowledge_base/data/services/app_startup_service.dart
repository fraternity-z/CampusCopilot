import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/vector_database_provider.dart';
import 'migration_check_service.dart';

/// 应用启动服务
///
/// 负责在应用启动时进行必要的初始化和检查
class AppStartupService {
  static AppStartupService? _instance;
  bool _hasInitialized = false;

  AppStartupService._();

  /// 获取单例实例
  static AppStartupService get instance {
    _instance ??= AppStartupService._();
    return _instance!;
  }

  /// 执行应用启动初始化
  Future<AppStartupResult> initialize(
    BuildContext context,
    WidgetRef ref, {
    bool showMigrationDialog = true,
    bool autoMigrate = false,
  }) async {
    if (_hasInitialized) {
      debugPrint('⏭️ 应用启动服务已初始化，跳过');
      return AppStartupResult(success: true, message: '应用启动服务已初始化');
    }

    try {
      debugPrint('🚀 开始应用启动初始化...');

      final result = AppStartupResult(success: true);

      // 1. 检查向量数据库迁移需求
      final migrationResult = await _checkAndHandleMigration(
        context,
        ref,
        showDialog: showMigrationDialog,
        autoMigrate: autoMigrate,
      );

      if (!migrationResult.success) {
        result.warnings.add('迁移检查失败: ${migrationResult.message}');
      }

      // 2. 初始化向量数据库
      final vectorDbResult = await _initializeVectorDatabase(ref);
      if (!vectorDbResult.success) {
        result.warnings.add('向量数据库初始化失败: ${vectorDbResult.message}');
      }

      // 3. 验证系统健康状态
      final healthResult = await _checkSystemHealth(ref);
      if (!healthResult.success) {
        result.warnings.add('系统健康检查失败: ${healthResult.message}');
      }

      _hasInitialized = true;

      final totalTime = DateTime.now().difference(result.startTime);
      result.message = '应用启动初始化完成，耗时: ${totalTime.inMilliseconds}ms';

      if (result.warnings.isNotEmpty) {
        debugPrint('⚠️ 启动过程中有警告: ${result.warnings.join(', ')}');
      }

      debugPrint('✅ ${result.message}');
      return result;
    } catch (e) {
      debugPrint('❌ 应用启动初始化失败: $e');
      return AppStartupResult(success: false, message: '应用启动初始化失败: $e');
    }
  }

  /// 检查和处理迁移
  Future<AppStartupResult> _checkAndHandleMigration(
    BuildContext context,
    WidgetRef ref, {
    required bool showDialog,
    required bool autoMigrate,
  }) async {
    try {
      debugPrint('🔍 检查向量数据库迁移需求...');

      final migrationCheckService = ref.read(migrationCheckServiceProvider);

      if (autoMigrate) {
        // 自动迁移模式
        final needsMigration = await migrationCheckService
            .silentCheckMigrationNeeded(ref);
        if (needsMigration) {
          debugPrint('🤖 执行自动迁移...');
          final success = await migrationCheckService.performAutoMigration(ref);
          if (success) {
            return AppStartupResult(success: true, message: '自动迁移完成');
          } else {
            return AppStartupResult(success: false, message: '自动迁移失败');
          }
        } else {
          return AppStartupResult(success: true, message: '无需迁移');
        }
      } else {
        // 交互式迁移模式
        if (showDialog && context.mounted) {
          await migrationCheckService.checkAndHandleMigration(context, ref);
        } else {
          await migrationCheckService.checkAndHandleMigration(
            context,
            ref,
            showDialog: false,
          );
        }
        return AppStartupResult(success: true, message: '迁移检查完成');
      }
    } catch (e) {
      debugPrint('❌ 迁移检查失败: $e');
      return AppStartupResult(success: false, message: '迁移检查失败: $e');
    }
  }

  /// 初始化向量数据库
  Future<AppStartupResult> _initializeVectorDatabase(WidgetRef ref) async {
    try {
      debugPrint('🔌 初始化向量数据库...');

      // 触发向量数据库初始化
      final vectorDatabase = await ref.read(vectorDatabaseProvider.future);
      final isHealthy = await vectorDatabase.isHealthy();

      if (isHealthy) {
        debugPrint('✅ 向量数据库初始化成功');
        return AppStartupResult(success: true, message: '向量数据库初始化成功');
      } else {
        debugPrint('⚠️ 向量数据库初始化成功但健康检查失败');
        return AppStartupResult(success: false, message: '向量数据库健康检查失败');
      }
    } catch (e) {
      debugPrint('❌ 向量数据库初始化失败: $e');
      return AppStartupResult(success: false, message: '向量数据库初始化失败: $e');
    }
  }

  /// 检查系统健康状态
  Future<AppStartupResult> _checkSystemHealth(WidgetRef ref) async {
    try {
      debugPrint('🏥 检查系统健康状态...');

      final healthChecks = <String, bool>{};

      // 检查向量数据库健康状态
      try {
        final isVectorDbHealthy = await ref.read(
          vectorDatabaseHealthProvider.future,
        );
        healthChecks['vectorDatabase'] = isVectorDbHealthy;
      } catch (e) {
        healthChecks['vectorDatabase'] = false;
        debugPrint('⚠️ 向量数据库健康检查失败: $e');
      }

      final healthyCount = healthChecks.values
          .where((healthy) => healthy)
          .length;
      final totalCount = healthChecks.length;

      if (healthyCount == totalCount) {
        debugPrint('✅ 系统健康检查通过 ($healthyCount/$totalCount)');
        return AppStartupResult(success: true, message: '系统健康检查通过');
      } else {
        debugPrint('⚠️ 系统健康检查部分失败 ($healthyCount/$totalCount)');
        return AppStartupResult(
          success: false,
          message: '系统健康检查部分失败 ($healthyCount/$totalCount)',
        );
      }
    } catch (e) {
      debugPrint('❌ 系统健康检查失败: $e');
      return AppStartupResult(success: false, message: '系统健康检查失败: $e');
    }
  }

  /// 重置初始化状态（用于测试）
  void reset() {
    _hasInitialized = false;
    debugPrint('🔄 应用启动服务状态已重置');
  }

  /// 获取初始化状态
  bool get isInitialized => _hasInitialized;
}

/// 应用启动结果
class AppStartupResult {
  final bool success;
  String message;
  final List<String> warnings;
  final DateTime startTime;

  AppStartupResult({
    required this.success,
    this.message = '',
    List<String>? warnings,
  }) : warnings = warnings ?? [],
       startTime = DateTime.now();

  @override
  String toString() {
    return 'AppStartupResult('
        'success: $success, '
        'message: $message, '
        'warnings: ${warnings.length}'
        ')';
  }
}

/// 应用启动服务提供者
final appStartupServiceProvider = Provider<AppStartupService>((ref) {
  return AppStartupService.instance;
});

/// 应用启动初始化提供者
///
/// 注意：由于类型限制，建议直接使用 AppStartupService.instance.initialize() 方法

/// 应用启动配置
class AppStartupConfig {
  final BuildContext context;
  final bool showMigrationDialog;
  final bool autoMigrate;

  const AppStartupConfig({
    required this.context,
    this.showMigrationDialog = true,
    this.autoMigrate = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppStartupConfig &&
        other.context == context &&
        other.showMigrationDialog == showMigrationDialog &&
        other.autoMigrate == autoMigrate;
  }

  @override
  int get hashCode {
    return Object.hash(context, showMigrationDialog, autoMigrate);
  }
}
