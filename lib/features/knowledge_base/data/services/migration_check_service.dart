import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/migration_provider.dart';
import '../../presentation/widgets/migration_dialog.dart';

/// 迁移检查服务
///
/// 在应用启动时检查是否需要进行向量数据库迁移
class MigrationCheckService {
  static MigrationCheckService? _instance;
  bool _hasChecked = false;

  MigrationCheckService._();

  /// 获取单例实例
  static MigrationCheckService get instance {
    _instance ??= MigrationCheckService._();
    return _instance!;
  }

  /// 检查并处理迁移
  Future<void> checkAndHandleMigration(
    BuildContext context,
    WidgetRef ref, {
    bool showDialog = true,
  }) async {
    // 避免重复检查
    if (_hasChecked) {
      debugPrint('⏭️ 迁移检查已执行，跳过');
      return;
    }

    try {
      debugPrint('🔍 开始检查向量数据库迁移需求...');

      final migrationNotifier = ref.read(migrationProvider.notifier);

      // 检查是否需要迁移
      await migrationNotifier.checkMigrationNeeded();

      final migrationState = ref.read(migrationProvider);

      switch (migrationState.status) {
        case MigrationStatus.needsMigration:
          debugPrint('📋 检测到需要迁移的数据');
          if (showDialog && context.mounted) {
            await _showMigrationDialog(context);
          }
          break;

        case MigrationStatus.notNeeded:
          debugPrint('✅ 无需进行数据迁移');
          break;

        case MigrationStatus.failed:
          debugPrint('❌ 迁移检查失败: ${migrationState.error}');
          if (showDialog && context.mounted) {
            await _showErrorDialog(context, migrationState.error);
          }
          break;

        default:
          debugPrint('⚠️ 未知的迁移状态: ${migrationState.status}');
          break;
      }

      _hasChecked = true;
    } catch (e) {
      debugPrint('❌ 迁移检查异常: $e');
      if (showDialog && context.mounted) {
        await _showErrorDialog(context, '迁移检查异常: $e');
      }
    }
  }

  /// 显示迁移对话框
  Future<void> _showMigrationDialog(BuildContext context) async {
    try {
      await MigrationDialog.show(context);
    } catch (e) {
      debugPrint('❌ 显示迁移对话框失败: $e');
    }
  }

  /// 显示错误对话框
  Future<void> _showErrorDialog(BuildContext context, String? error) async {
    if (!context.mounted) return;

    try {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('迁移检查失败'),
            ],
          ),
          content: Text(error ?? '未知错误'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('❌ 显示错误对话框失败: $e');
    }
  }

  /// 重置检查状态（用于测试）
  void resetCheckStatus() {
    _hasChecked = false;
    debugPrint('🔄 迁移检查状态已重置');
  }

  /// 静默检查迁移需求（不显示对话框）
  Future<bool> silentCheckMigrationNeeded(WidgetRef ref) async {
    try {
      final migrationNotifier = ref.read(migrationProvider.notifier);
      await migrationNotifier.checkMigrationNeeded();

      final migrationState = ref.read(migrationProvider);
      return migrationState.status == MigrationStatus.needsMigration;
    } catch (e) {
      debugPrint('❌ 静默迁移检查失败: $e');
      return false;
    }
  }

  /// 执行自动迁移（不显示对话框）
  Future<bool> performAutoMigration(WidgetRef ref) async {
    try {
      debugPrint('🤖 开始自动迁移...');

      final migrationNotifier = ref.read(migrationProvider.notifier);
      await migrationNotifier.performMigration(
        deleteSourceAfterMigration: false,
      );

      final migrationState = ref.read(migrationProvider);

      if (migrationState.status == MigrationStatus.completed) {
        debugPrint('✅ 自动迁移完成');
        return true;
      } else {
        debugPrint('❌ 自动迁移失败: ${migrationState.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 自动迁移异常: $e');
      return false;
    }
  }
}

/// 迁移检查服务提供者
final migrationCheckServiceProvider = Provider<MigrationCheckService>((ref) {
  return MigrationCheckService.instance;
});

/// 应用启动迁移检查提供者
final appStartupMigrationCheckProvider = FutureProvider<bool>((ref) async {
  try {
    final migrationNotifier = ref.read(migrationProvider.notifier);
    await migrationNotifier.checkMigrationNeeded();

    final migrationState = ref.read(migrationProvider);
    return migrationState.status == MigrationStatus.needsMigration;
  } catch (e) {
    debugPrint('❌ 应用启动迁移检查失败: $e');
    return false;
  }
});
