import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import '../providers/data_management_provider.dart';
import '../../../llm_chat/presentation/providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../../../knowledge_base/data/services/vector_collection_repair_service.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// 数据管理页面
class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() =>
      _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isLoading = false;
  bool _autoBackupEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// 加载设置信息
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _autoBackupEnabled = prefs.getBool('auto_backup_enabled') ?? false;
      });
    } catch (e) {
      // 处理错误
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数据管理'), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBackupSection(context),
                const SizedBox(height: 16),
                _buildStorageSection(context),
                const SizedBox(height: 16),
                _buildDangerZoneSection(context),
              ],
            ),
    );
  }

  /// 备份恢复区域
  Widget _buildBackupSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.backup,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '备份与恢复',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('导出数据'),
              subtitle: const Text('导出聊天记录、智能体和设置'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _exportData,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('导入数据'),
              subtitle: const Text('从备份文件恢复数据'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _importData,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('自动备份'),
              subtitle: const Text('定期自动备份数据'),
              trailing: Switch(
                value: _autoBackupEnabled,
                onChanged: _toggleAutoBackup,
              ),
              contentPadding: EdgeInsets.zero,
            ),


            if (_autoBackupEnabled) ...[
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.schedule,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '备份时间',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        _autoBackupTime,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'monospace',
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '每日定时自动备份',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ),
                  onTap: _pickAutoBackupTime,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('备份位置'),
                subtitle: Text(_autoBackupPath ?? '默认应用文档目录'),
                onTap: _pickAutoBackupDirectory,
                contentPadding: EdgeInsets.zero,
              ),
            ],

          ],
        ),
      ),
    );
  }

  /// 存储信息区域
  Widget _buildStorageSection(BuildContext context) {
    final statsAsync = ref.watch(dataStatisticsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '存储信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  _buildStorageItem(
                    context: context,
                    icon: Icons.chat,
                    title: '聊天记录',
                    subtitle:
                        '约 ${_calculateDataSize(stats.messageCount, 0.1)} MB',
                    count: '${stats.chatCount} 个会话, ${stats.messageCount} 条消息',
                  ),
                  const Divider(),
                  _buildStorageItem(
                    context: context,
                    icon: Icons.person,
                    title: '智能体',
                    subtitle:
                        '约 ${_calculateDataSize(stats.personaCount, 0.05)} MB',
                    count: '${stats.personaCount} 个智能体',
                  ),
                  const Divider(),
                  _buildStorageItem(
                    context: context,
                    icon: Icons.library_books,
                    title: '知识库',
                    subtitle:
                        '约 ${_calculateDataSize(stats.knowledgeCount, 2.0)} MB',
                    count: '${stats.knowledgeCount} 个文档',
                  ),
                  const Divider(),
                  _buildStorageItem(
                    context: context,
                    icon: Icons.settings,
                    title: '设置数据',
                    subtitle: '约 0.1 MB',
                    count: '配置信息',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '总计使用存储空间：约 ${_calculateTotalDataSize(stats)} MB',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('错误: $err')),
            ),
          ],
        ),
      ),
    );
  }

  /// 系统维护区域
  /// 注意：此功能已被禁用，如需重新启用请在build方法中添加对此方法的调用
  // ignore: unused_element
  Widget _buildSystemMaintenanceSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.build, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '系统维护',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text('修复向量集合'),
              subtitle: const Text('检查并修复缺失的向量集合，解决搜索问题'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _repairVectorCollections,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('重建向量索引'),
              subtitle: const Text('重新构建向量索引以提高搜索性能'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _rebuildVectorIndex,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 危险区域
  Widget _buildDangerZoneSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  '危险操作',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('清除聊天记录'),
              subtitle: const Text('删除所有本地聊天数据'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _clearChatHistory,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('清除知识库'),
              subtitle: const Text('删除所有本地知识库文件'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _clearKnowledgeBase,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('恢复出厂设置'),
              subtitle: const Text('重置所有设置和数据'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _resetToFactorySettings,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建存储信息项
  Widget _buildStorageItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(count, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  /// 导出数据
  Future<void> _exportData() async {
    try {
      setState(() => _isLoading = true);

      final backupPath = await ref
          .read(dataManagementProvider.notifier)
          .exportData();

      if (backupPath != null && mounted) {
        // 提取文件名
        final fileName = backupPath.split('/').last.split('\\').last;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('数据导出成功！'),
                const SizedBox(height: 4),
                Text(
                  '文件：$fileName',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: '打开文件夹',
              onPressed: () => _openFileLocation(backupPath),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出失败: ${_getErrorMessage(e)}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 导入数据
  Future<void> _importData() async {
    // 首先显示警告对话框
    final confirmed = await _showImportWarningDialog();
    if (confirmed != true) return;

    try {
      setState(() => _isLoading = true);

      final success = await ref
          .read(dataManagementProvider.notifier)
          .importData();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('数据导入成功！应用将重新加载以应用更改。'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '立即重启',
              onPressed: () => _restartApp(),
            ),
          ),
        );

        // 刷新相关的Provider
        ref.invalidate(dataStatisticsProvider);
        ref.invalidate(chatProvider);
        ref.invalidate(settingsProvider);

        // 延迟重启应用
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _restartApp();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败: ${_getErrorMessage(e)}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 显示导入警告对话框
  Future<bool?> _showImportWarningDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            const Text('重要提醒'),
          ],
        ),
        content: const Text(
          '导入数据将：\n\n'
          '• 覆盖所有现有聊天记录\n'
          '• 覆盖所有AI模型配置\n'
          '• 覆盖所有智能体设置\n'
          '• 覆盖所有应用设置\n\n'
          '此操作不可撤销。建议在导入前先导出当前数据作为备份。\n\n'
          '确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              '确认导入',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  /// 打开文件位置
  Future<void> _openFileLocation(String filePath) async {
    try {
      final file = File(filePath);
      final directory = file.parent.path;

      if (Platform.isWindows) {
        await Process.run('explorer', [directory]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [directory]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [directory]);
      } else {
        // 复制路径到剪贴板作为备选方案
        await Clipboard.setData(ClipboardData(text: directory));
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('文件路径已复制到剪贴板')));
        }
      }
    } catch (e) {
      // 如果无法打开文件夹，复制路径到剪贴板
      final directory = File(filePath).parent.path;
      await Clipboard.setData(ClipboardData(text: directory));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法打开文件夹，路径已复制到剪贴板')));
      }
    }
  }

  /// 重启应用
  void _restartApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  /// 获取错误消息
  String _getErrorMessage(dynamic error) {
    if (error is BackupException) {
      switch (error.code) {
        case 'BACKUP_CREATE_FAILED':
          return '创建备份失败，请检查存储权限和磁盘空间';
        case 'BACKUP_RESTORE_FAILED':
          return '恢复备份失败，请检查文件完整性';
        case 'INVALID_BACKUP_FILE':
          return '无效的备份文件，请选择正确的 .aibackup 文件';
        case 'CORRUPTED_BACKUP':
          return '备份文件已损坏，无法恢复';
        default:
          return error.message;
      }
    }
    return error.toString();
  }

  /// 切换自动备份
  Future<void> _toggleAutoBackup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_backup_enabled', value);
    setState(() {
      _autoBackupEnabled = value;
    });
  }



  /// 选择自动备份时间
  Future<void> _pickAutoBackupTime() async {
    final parts = _autoBackupTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 3,
      minute: int.tryParse(parts[1]) ?? 0,
    );
    final picked = await showTimePicker(
      context: context, 
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  width: 2.5,
                ),
              ),
              hourMinuteColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              hourMinuteTextStyle: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                letterSpacing: 2.0,
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              dayPeriodColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
              dayPeriodTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              dialBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              dialTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              entryModeIconColor: Theme.of(context).colorScheme.primary,
              helpTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 4,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      final str = '$hh:$mm';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auto_backup_time', str);
      if (mounted) setState(() => _autoBackupTime = str);
    }
  }

  /// 选择自动备份路径
  Future<void> _pickAutoBackupDirectory() async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '选择自动备份保存位置',
      );
      if (directory != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auto_backup_path', directory);
        if (mounted) setState(() => _autoBackupPath = directory);
      }
    } catch (e) {
      // 移动端可能不支持目录选择，回退为默认目录
      final manager = ref.read(backupManagerProvider);
      final def = await manager.getDefaultBackupDirectory();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auto_backup_path', def);
      if (mounted) setState(() => _autoBackupPath = def);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('当前平台不支持选择目录，已使用默认目录')),
        );
      }
    }
  }


  /// 清除聊天记录
  Future<void> _clearChatHistory() async {
    final confirmed = await _showConfirmationDialog(
      context: context,
      title: '确认清除',
      content: '确定要删除所有聊天记录吗？此操作不可恢复。',
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      // 实际的数据库清除逻辑将在这里实现
      // await ref.read(appDatabaseProvider).clearChatHistory();
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      ref.invalidate(dataStatisticsProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('聊天记录已清除')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 清除知识库
  Future<void> _clearKnowledgeBase() async {
    final confirmed = await _showConfirmationDialog(
      context: context,
      title: '确认清除',
      content: '确定要删除所有知识库文档吗？此操作不可恢复。',
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      // 实际的数据库清除逻辑将在这里实现
      // await ref.read(appDatabaseProvider).clearKnowledgeBase();
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      ref.invalidate(dataStatisticsProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('知识库已清除')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清除失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 恢复出厂设置
  Future<void> _resetToFactorySettings() async {
    final confirmed = await _showConfirmationDialog(
      context: context,
      title: '确认重置',
      content: '确定要恢复出厂设置吗？所有数据和设置都将被删除，应用将恢复到初始状态。',
      confirmText: '确认重置',
      isDestructive: true,
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      // 实际的数据库重置逻辑将在这里实现
      // await ref.read(appDatabaseProvider).resetDatabase();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
      ref.invalidate(dataStatisticsProvider);

      if (mounted) {
        setState(() {
          _autoBackupEnabled = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('应用已恢复出厂设置')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('重置失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool?> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '确认',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDestructive
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 计算数据大小
  String _calculateDataSize(int count, double itemSize) {
    if (count == 0) return '0.00';
    return (count * itemSize).toStringAsFixed(2);
  }

  /// 计算总数据大小
  String _calculateTotalDataSize(DataStatistics? stats) {
    if (stats == null) return '0.00';
    final chatSize = _calculateDataSize(stats.messageCount, 0.1);
    final personaSize = _calculateDataSize(stats.personaCount, 0.05);
    final knowledgeSize = _calculateDataSize(stats.knowledgeCount, 2.0);
    return (double.parse(chatSize) +
            double.parse(personaSize) +
            double.parse(knowledgeSize) +
            0.1)
        .toStringAsFixed(2);
  }

  /// 修复向量集合
  Future<void> _repairVectorCollections() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // 显示确认对话框
      final confirmed = await _showConfirmationDialog(
        context: context,
        title: '修复向量集合',
        content: '这将检查所有知识库并为缺失的向量集合创建新的集合。此操作是安全的，不会删除任何数据。\n\n是否继续？',
        confirmText: '开始修复',
      );

      if (confirmed != true) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 执行修复
      final repairService = ref.read(vectorCollectionRepairServiceProvider);
      final result = await repairService.repairAllCollections(ref);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // 显示结果
        final message = result.success
            ? '✅ ${result.message}'
            : '❌ ${result.message}';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: result.success
                ? Colors.green
                : Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );

        // 如果有详细信息，显示详细对话框
        if (result.hasAnyOperation) {
          _showRepairResultDialog(result);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('修复失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// 重建向量索引
  Future<void> _rebuildVectorIndex() async {
    // 显示确认对话框
    final confirmed = await _showConfirmationDialog(
      context: context,
      title: '重建向量索引',
      content: '此功能正在开发中，将在未来版本中提供。\n\n重建向量索引可以提高搜索性能，但需要较长时间。',
      confirmText: '了解',
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('此功能正在开发中，敬请期待！'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// 显示修复结果详细对话框
  void _showRepairResultDialog(VectorCollectionRepairResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修复结果详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result.existingCollections.isNotEmpty) ...[
                Text(
                  '✅ 已存在的向量集合 (${result.existingCollections.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...result.existingCollections.map(
                  (id) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text('• $id'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (result.createdCollections.isNotEmpty) ...[
                Text(
                  '🆕 新创建的向量集合 (${result.createdCollections.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.createdCollections.map(
                  (id) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text('• $id'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (result.failedCollections.isNotEmpty) ...[
                Text(
                  '❌ 创建失败的向量集合 (${result.failedCollections.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.failedCollections.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text('• ${entry.key}: ${entry.value}'),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
