import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/app_database.dart';
import '../di/database_providers.dart';
import 'backup_manager.dart';

/// 自动备份调度器（前台定时 + 应用恢复触发，跨平台生效）
class AutoBackupScheduler with WidgetsBindingObserver {
  final BackupManager backupManager;
  final AppDatabase db;

  Timer? _timer;
  bool _isDisposed = false;

  AutoBackupScheduler({required this.backupManager, required this.db});

  Future<void> start() async {
    WidgetsBinding.instance.addObserver(this);
    _checkAndRunIfDue();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) {
      _checkAndRunIfDue();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndRunIfDue();
    }
  }

  Future<void> disposeScheduler() async {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkAndRunIfDue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('auto_backup_enabled') ?? false;
      if (!enabled || _isDisposed) return;

      final timeStr = prefs.getString('auto_backup_time') ?? '03:00';
      final parts = timeStr.split(':');
      final hour = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 3;
      final minute = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;

      final now = DateTime.now();
      final todaySchedule = DateTime(now.year, now.month, now.day, hour, minute);
      final lastStr = prefs.getString('auto_backup_last_time');
      final last = lastStr != null ? DateTime.tryParse(lastStr) : null;

      final hasBackedUpToday = last != null &&
          last.year == now.year &&
          last.month == now.month &&
          last.day == now.day;

      final shouldRun = (!hasBackedUpToday && now.isAfter(todaySchedule)) ||
          (last == null && now.isAfter(todaySchedule));

      if (!shouldRun) return;

      final directory = prefs.getString('auto_backup_path') ??
          await backupManager.getDefaultBackupDirectory();

      final path = await backupManager.createOrReplaceAutoBackup(
        db: db,
        directory: directory,
        includePersonas: true,
        includeSettings: false,
        includeCustomModels: true,
      );

      await prefs.setString(
        'auto_backup_last_time',
        DateTime.now().toIso8601String(),
      );
      debugPrint('Auto backup finished: $path');
    } catch (e) {
      debugPrint('Auto backup failed: $e');
    }
  }
}

// ============== Riverpod 接入 ==============

final autoBackupSchedulerProvider = Provider<AutoBackupScheduler>((ref) {
  final manager = BackupManager();
  final db = ref.read(appDatabaseProvider);
  final scheduler = AutoBackupScheduler(backupManager: manager, db: db);
  ref.onDispose(() {
    scheduler.disposeScheduler();
  });
  return scheduler;
});

/// 初始化自动备份（在应用装载时 watch 即可）
final autoBackupInitProvider = FutureProvider<void>((ref) async {
  final scheduler = ref.read(autoBackupSchedulerProvider);
  await scheduler.start();
});
