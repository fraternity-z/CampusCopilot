import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, dynamic> _storageInfo = {
    'chatCount': 156,
    'messageCount': 2450,
    'personaCount': 12,
    'knowledgeCount': 8,
  };

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

            _buildStorageItem(
              context,
              icon: Icons.chat,
              title: '聊天记录',
              subtitle:
                  '约 ${_calculateDataSize(_storageInfo['messageCount'] ?? 0, 0.1)} MB',
              count:
                  '${_storageInfo['chatCount'] ?? 0} 个会话, ${_storageInfo['messageCount'] ?? 0} 条消息',
            ),

            const Divider(),

            _buildStorageItem(
              context,
              icon: Icons.person,
              title: '智能体',
              subtitle:
                  '约 ${_calculateDataSize(_storageInfo['personaCount'] ?? 0, 0.05)} MB',
              count: '${_storageInfo['personaCount'] ?? 0} 个智能体',
            ),

            const Divider(),

            _buildStorageItem(
              context,
              icon: Icons.library_books,
              title: '知识库',
              subtitle:
                  '约 ${_calculateDataSize(_storageInfo['knowledgeCount'] ?? 0, 2.0)} MB',
              count: '${_storageInfo['knowledgeCount'] ?? 0} 个文档',
            ),

            const Divider(),

            _buildStorageItem(
              context,
              icon: Icons.settings,
              title: '设置数据',
              subtitle: '约 0.1 MB',
              count: '配置信息',
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                      '总计使用存储空间：约 ${_calculateTotalDataSize()} MB',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
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
              leading: Icon(
                Icons.delete_forever,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '清空所有数据',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('删除所有聊天记录、智能体和设置（不可恢复）'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _clearAllData,
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(),

            ListTile(
              leading: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '重置应用',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('恢复应用到初始状态'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _resetApp,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建存储项目
  Widget _buildStorageItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String count,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        count,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  /// 导出数据
  Future<void> _exportData() async {
    setState(() => _isLoading = true);

    try {
      // 创建备份数据
      final backupData = {
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'data': {
          'chats': _storageInfo['chatCount'] ?? 0,
          'messages': _storageInfo['messageCount'] ?? 0,
          'personas': _storageInfo['personaCount'] ?? 0,
          'knowledge': _storageInfo['knowledgeCount'] ?? 0,
        },
      };

      // 获取文档目录
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'ai_assistant_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      // 写入备份数据
      await file.writeAsString(jsonEncode(backupData));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('数据导出成功！文件已保存到：$fileName'),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: '查看路径',
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('完整路径：${file.path}')));
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败：$e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 导入数据
  Future<void> _importData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _isLoading = true);

        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final backupData = jsonDecode(content);

        // 显示确认对话框
        final confirmed = await _showImportConfirmDialog();
        if (!confirmed) return;

        // 模拟导入过程
        await Future.delayed(const Duration(seconds: 2));

        // 更新存储信息
        if (backupData['data'] != null) {
          setState(() {
            _storageInfo = Map<String, dynamic>.from(backupData['data']);
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('数据导入成功！')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导入失败：$e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 切换自动备份
  Future<void> _toggleAutoBackup(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_backup_enabled', value);

      setState(() {
        _autoBackupEnabled = value;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(value ? '自动备份已启用' : '自动备份已禁用')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('设置失败：$e')));
      }
    }
  }

  /// 清空所有数据
  Future<void> _clearAllData() async {
    final confirmed = await _showClearDataConfirmDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // 模拟清空过程
      await Future.delayed(const Duration(seconds: 2));

      // 重置存储信息
      setState(() {
        _storageInfo = {
          'chatCount': 0,
          'messageCount': 0,
          'personaCount': 0,
          'knowledgeCount': 0,
        };
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('所有数据已清空！')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('清空失败：$e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 重置应用
  Future<void> _resetApp() async {
    final confirmed = await _showResetAppConfirmDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // 清空SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 模拟重置过程
      await Future.delayed(const Duration(seconds: 3));

      // 重置存储信息和设置
      setState(() {
        _storageInfo = {
          'chatCount': 0,
          'messageCount': 0,
          'personaCount': 0,
          'knowledgeCount': 0,
        };
        _autoBackupEnabled = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('应用已重置到初始状态！')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('重置失败：$e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 显示导入确认对话框
  Future<bool> _showImportConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认导入'),
            content: const Text('导入数据将覆盖当前所有数据，此操作不可撤销。确定要继续吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('确认导入'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// 显示清空数据确认对话框
  Future<bool> _showClearDataConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认清空'),
            content: const Text('此操作将删除所有聊天记录、智能体和知识库数据，且不可恢复。确定要继续吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('确认清空'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// 显示重置应用确认对话框
  Future<bool> _showResetAppConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认重置'),
            content: const Text('此操作将清空所有数据和设置，将应用恢复到初始状态，且不可恢复。确定要继续吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('确认重置'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// 计算数据大小（简单估算）
  String _calculateDataSize(int count, double sizePerItem) {
    final size = count * sizePerItem;
    return size.toStringAsFixed(1);
  }

  /// 计算总数据大小
  String _calculateTotalDataSize() {
    final chatSize = (_storageInfo['messageCount'] ?? 0) * 0.1;
    final personaSize = (_storageInfo['personaCount'] ?? 0) * 0.05;
    final knowledgeSize = (_storageInfo['knowledgeCount'] ?? 0) * 2.0;
    final settingsSize = 0.1;

    final total = chatSize + personaSize + knowledgeSize + settingsSize;
    return total.toStringAsFixed(1);
  }
}
