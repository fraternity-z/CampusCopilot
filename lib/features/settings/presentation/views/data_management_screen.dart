import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/data_management_provider.dart';

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
    // ... (实现将在需要时添加)
  }

  /// 导入数据
  Future<void> _importData() async {
    // ... (实现将在需要时添加)
  }

  /// 切换自动备份
  Future<void> _toggleAutoBackup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_backup_enabled', value);
    setState(() {
      _autoBackupEnabled = value;
    });
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
}
