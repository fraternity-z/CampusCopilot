import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/di/database_providers.dart';
import '../../../../core/utils/backup_manager.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// 数据统计信息
class DataStatistics {
  final int chatCount;
  final int messageCount;
  final int personaCount;
  final int knowledgeCount;

  DataStatistics({
    required this.chatCount,
    required this.messageCount,
    required this.personaCount,
    required this.knowledgeCount,
  });
}

/// 备份管理Provider
final backupManagerProvider = Provider<BackupManager>((ref) {
  return BackupManager();
});

/// 数据统计Provider
final dataStatisticsProvider = FutureProvider<DataStatistics>((ref) async {
  final db = ref.watch(appDatabaseProvider);

  final chatCount = await db.getChatSessionCount();
  final messageCount = await db.getMessageCount();
  final personaCount = await db.getPersonaCount();
  final knowledgeCount = await db.getKnowledgeDocumentCount();

  return DataStatistics(
    chatCount: chatCount,
    messageCount: messageCount,
    personaCount: personaCount,
    knowledgeCount: knowledgeCount,
  );
});

/// 数据管理状态管理
class DataManagementNotifier extends StateNotifier<DataManagementState> {
  final BackupManager _backupManager;

  DataManagementNotifier(this._backupManager)
    : super(const DataManagementState());

  /// 导出数据
  Future<String?> exportData() async {
    try {
      state = state.copyWith(isExporting: true, exportError: null);

      // 让用户选择保存位置
      final selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '选择备份保存位置',
      );

      if (selectedDirectory == null) {
        state = state.copyWith(isExporting: false);
        return null; // 用户取消了选择
      }

      // 创建备份
      final backupPath = await _backupManager.createFullBackup(
        customPath: selectedDirectory,
      );

      state = state.copyWith(
        isExporting: false,
        lastExportPath: backupPath,
        exportSuccess: true,
      );

      return backupPath;
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        exportError: e.toString(),
        exportSuccess: false,
      );
      rethrow;
    }
  }

  /// 导入数据
  Future<bool> importData() async {
    try {
      state = state.copyWith(isImporting: true, importError: null);

      // 让用户选择备份文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'aibackup'],
        dialogTitle: '选择备份文件',
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isImporting: false);
        return false; // 用户取消了选择
      }

      final backupFile = result.files.first;
      if (backupFile.path == null) {
        throw const BackupException('无法获取文件路径');
      }

      // 验证备份文件
      final isValid = await _backupManager.validateBackup(backupFile.path!);
      if (!isValid) {
        throw BackupException.invalidBackupFile();
      }

      // 恢复数据
      await _backupManager.restoreBackup(backupFile.path!);

      state = state.copyWith(
        isImporting: false,
        lastImportPath: backupFile.path!,
        importSuccess: true,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        importError: e.toString(),
        importSuccess: false,
      );
      rethrow;
    }
  }

  /// 获取备份历史
  Future<List<BackupInfo>> getBackupHistory() async {
    try {
      return await _backupManager.getBackupHistory();
    } catch (e) {
      return [];
    }
  }

  /// 删除备份文件
  Future<void> deleteBackup(String backupPath) async {
    try {
      await _backupManager.deleteBackup(backupPath);
    } catch (e) {
      // 静默处理删除错误
    }
  }

  /// 清除状态
  void clearState() {
    state = const DataManagementState();
  }
}

/// 数据管理状态
class DataManagementState {
  final bool isExporting;
  final bool isImporting;
  final String? exportError;
  final String? importError;
  final String? lastExportPath;
  final String? lastImportPath;
  final bool exportSuccess;
  final bool importSuccess;

  const DataManagementState({
    this.isExporting = false,
    this.isImporting = false,
    this.exportError,
    this.importError,
    this.lastExportPath,
    this.lastImportPath,
    this.exportSuccess = false,
    this.importSuccess = false,
  });

  DataManagementState copyWith({
    bool? isExporting,
    bool? isImporting,
    String? exportError,
    String? importError,
    String? lastExportPath,
    String? lastImportPath,
    bool? exportSuccess,
    bool? importSuccess,
  }) {
    return DataManagementState(
      isExporting: isExporting ?? this.isExporting,
      isImporting: isImporting ?? this.isImporting,
      exportError: exportError,
      importError: importError,
      lastExportPath: lastExportPath ?? this.lastExportPath,
      lastImportPath: lastImportPath ?? this.lastImportPath,
      exportSuccess: exportSuccess ?? this.exportSuccess,
      importSuccess: importSuccess ?? this.importSuccess,
    );
  }
}

/// 数据管理Provider
final dataManagementProvider =
    StateNotifierProvider<DataManagementNotifier, DataManagementState>((ref) {
      final backupManager = ref.watch(backupManagerProvider);
      return DataManagementNotifier(backupManager);
});
