import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/migration_provider.dart';
import '../../data/migration/vector_database_migration.dart';

/// 数据迁移对话框
///
/// 显示向量数据库迁移的进度和选项
class MigrationDialog extends ConsumerWidget {
  const MigrationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final migrationState = ref.watch(migrationProvider);
    final migrationNotifier = ref.read(migrationProvider.notifier);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.sync_alt, color: Colors.blue),
          SizedBox(width: 8),
          Text('向量数据库迁移'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusSection(migrationState),
            const SizedBox(height: 16),
            _buildProgressSection(migrationState),
            if (migrationState.result != null) ...[
              const SizedBox(height: 16),
              _buildResultSection(migrationState.result!),
            ],
            if (migrationState.error != null) ...[
              const SizedBox(height: 16),
              _buildErrorSection(migrationState.error!),
            ],
          ],
        ),
      ),
      actions: _buildActions(context, migrationState, migrationNotifier),
    );
  }

  Widget _buildStatusSection(MigrationState state) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (state.status) {
      case MigrationStatus.notStarted:
        statusText = '准备迁移';
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
        break;
      case MigrationStatus.checking:
        statusText = '检查迁移需求...';
        statusColor = Colors.blue;
        statusIcon = Icons.search;
        break;
      case MigrationStatus.needsMigration:
        statusText = '发现需要迁移的数据';
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case MigrationStatus.migrating:
        statusText = '正在迁移数据...';
        statusColor = Colors.blue;
        statusIcon = Icons.sync;
        break;
      case MigrationStatus.completed:
        statusText = '迁移完成';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case MigrationStatus.failed:
        statusText = '迁移失败';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case MigrationStatus.notNeeded:
        statusText = '无需迁移';
        statusColor = Colors.green;
        statusIcon = Icons.check;
        break;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 20),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildProgressSection(MigrationState state) {
    if (state.status != MigrationStatus.migrating) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: state.progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          '进度: ${(state.progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildResultSection(VectorMigrationResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: result.success ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: result.success ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '迁移结果',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: result.success ? Colors.green[800] : Colors.red[800],
            ),
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            '集合',
            '${result.migratedCollections}/${result.totalCollections}',
          ),
          _buildResultRow(
            '文档',
            '${result.migratedDocuments}/${result.totalDocuments}',
          ),
          _buildResultRow('耗时', '${result.migrationTime.inSeconds}秒'),
          if (result.errors.isNotEmpty)
            _buildResultRow('错误', '${result.errors.length}个'),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '错误信息',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(error, style: const TextStyle(fontSize: 12, color: Colors.red)),
        ],
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    MigrationState state,
    MigrationNotifier notifier,
  ) {
    switch (state.status) {
      case MigrationStatus.needsMigration:
        return [
          TextButton(
            onPressed: () {
              notifier.skipMigration();
              Navigator.of(context).pop();
            },
            child: const Text('跳过'),
          ),
          ElevatedButton(
            onPressed: () async {
              await notifier.performMigration(deleteSourceAfterMigration: true);
            },
            child: const Text('开始迁移'),
          ),
        ];

      case MigrationStatus.migrating:
        return [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ];

      case MigrationStatus.completed:
      case MigrationStatus.failed:
      case MigrationStatus.notNeeded:
        return [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ];

      default:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ];
    }
  }

  /// 显示迁移对话框
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MigrationDialog(),
    );
  }
}
