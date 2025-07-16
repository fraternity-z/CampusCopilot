import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/vector_database_provider.dart';
import '../../data/providers/unified_vector_search_provider.dart';
import '../../data/factories/vector_database_factory.dart';
import '../providers/rag_provider.dart';

/// 系统状态监控组件
///
/// 显示向量数据库和相关服务的状态信息
class SystemStatusWidget extends ConsumerWidget {
  final bool showDetails;
  final VoidCallback? onTap;

  const SystemStatusWidget({super.key, this.showDetails = false, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.monitor_heart, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    '系统状态',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      showDetails ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildVectorDatabaseStatus(ref),
              if (showDetails) ...[
                const SizedBox(height: 12),
                _buildVectorSearchServiceStatus(ref),
                const SizedBox(height: 12),
                _buildKnowledgeBaseStats(ref),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVectorDatabaseStatus(WidgetRef ref) {
    final vectorDbHealthAsync = ref.watch(vectorDatabaseHealthProvider);
    final vectorDbConfig = ref.watch(vectorDatabaseConfigProvider);

    return vectorDbHealthAsync.when(
      data: (isHealthy) {
        return _buildStatusRow(
          icon: isHealthy ? Icons.check_circle : Icons.error,
          iconColor: isHealthy ? Colors.green : Colors.red,
          title: '向量数据库',
          subtitle:
              '${_getDatabaseTypeName(vectorDbConfig.type)} - ${isHealthy ? "正常" : "异常"}',
        );
      },
      loading: () => _buildStatusRow(
        icon: Icons.hourglass_empty,
        iconColor: Colors.orange,
        title: '向量数据库',
        subtitle: '检查中...',
      ),
      error: (error, _) => _buildStatusRow(
        icon: Icons.error,
        iconColor: Colors.red,
        title: '向量数据库',
        subtitle: '检查失败',
      ),
    );
  }

  Widget _buildVectorSearchServiceStatus(WidgetRef ref) {
    final serviceTypeAsync = ref.watch(vectorSearchServiceTypeProvider);
    final serviceHealthAsync = ref.watch(unifiedVectorSearchHealthProvider);

    return serviceTypeAsync.when(
      data: (serviceType) {
        return serviceHealthAsync.when(
          data: (isHealthy) => _buildStatusRow(
            icon: isHealthy ? Icons.search : Icons.search_off,
            iconColor: isHealthy ? Colors.green : Colors.orange,
            title: '向量搜索服务',
            subtitle: '${serviceType.name} - ${isHealthy ? "正常" : "异常"}',
          ),
          loading: () => _buildStatusRow(
            icon: Icons.hourglass_empty,
            iconColor: Colors.orange,
            title: '向量搜索服务',
            subtitle: '${serviceType.name} - 检查中...',
          ),
          error: (error, _) => _buildStatusRow(
            icon: Icons.error,
            iconColor: Colors.red,
            title: '向量搜索服务',
            subtitle: '${serviceType.name} - 检查失败',
          ),
        );
      },
      loading: () => _buildStatusRow(
        icon: Icons.hourglass_empty,
        iconColor: Colors.orange,
        title: '向量搜索服务',
        subtitle: '检查中...',
      ),
      error: (error, _) => _buildStatusRow(
        icon: Icons.error,
        iconColor: Colors.red,
        title: '向量搜索服务',
        subtitle: '检查失败',
      ),
    );
  }

  Widget _buildKnowledgeBaseStats(WidgetRef ref) {
    final statsAsync = ref.watch(unifiedKnowledgeBaseStatsProvider);

    return statsAsync.when(
      data: (stats) {
        final totalDocs = stats['totalDocuments'] ?? 0;
        final totalChunks = stats['totalChunks'] ?? 0;
        final isHealthy = stats['vectorDatabaseHealthy'] ?? false;

        return _buildStatusRow(
          icon: Icons.library_books,
          iconColor: isHealthy ? Colors.blue : Colors.orange,
          title: '知识库',
          subtitle: '$totalDocs 个文档，$totalChunks 个片段',
        );
      },
      loading: () => _buildStatusRow(
        icon: Icons.hourglass_empty,
        iconColor: Colors.orange,
        title: '知识库',
        subtitle: '加载中...',
      ),
      error: (error, _) => _buildStatusRow(
        icon: Icons.error,
        iconColor: Colors.red,
        title: '知识库',
        subtitle: '加载失败',
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDatabaseTypeName(VectorDatabaseType type) {
    switch (type) {
      case VectorDatabaseType.objectBox:
        return 'ObjectBox';
      case VectorDatabaseType.localFile:
        return '本地文件';
    }
  }
}

/// 系统状态详情对话框
class SystemStatusDialog extends ConsumerWidget {
  const SystemStatusDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.monitor_heart, color: Colors.blue),
          SizedBox(width: 8),
          Text('系统状态详情'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailSection('向量数据库', ref),
              const SizedBox(height: 16),
              _buildDetailSection('向量搜索服务', ref),
              const SizedBox(height: 16),
              _buildDetailSection('知识库统计', ref),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        ElevatedButton(
          onPressed: () {
            // 刷新状态
            ref.invalidate(vectorDatabaseHealthProvider);
            ref.invalidate(unifiedVectorSearchHealthProvider);
            ref.invalidate(unifiedKnowledgeBaseStatsProvider);
          },
          child: const Text('刷新'),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: _buildDetailContent(title, ref),
        ),
      ],
    );
  }

  Widget _buildDetailContent(String section, WidgetRef ref) {
    switch (section) {
      case '向量数据库':
        return _buildVectorDatabaseDetails(ref);
      case '向量搜索服务':
        return _buildVectorSearchServiceDetails(ref);
      case '知识库统计':
        return _buildKnowledgeBaseStatsDetails(ref);
      default:
        return const Text('未知部分');
    }
  }

  Widget _buildVectorDatabaseDetails(WidgetRef ref) {
    final healthAsync = ref.watch(vectorDatabaseHealthProvider);
    final config = ref.watch(vectorDatabaseConfigProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        healthAsync.when(
          data: (isHealthy) => Text('健康状态: ${isHealthy ? "正常" : "异常"}'),
          loading: () => const Text('健康状态: 检查中...'),
          error: (error, _) => Text('健康状态: 检查失败 - $error'),
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('数据库类型: ${_getDatabaseTypeName(config.type)}'),
            Text('自动备份: ${config.autoBackup ? "启用" : "禁用"}'),
            Text('缓存大小: ${config.maxCacheSize}'),
          ],
        ),
      ],
    );
  }

  Widget _buildVectorSearchServiceDetails(WidgetRef ref) {
    final serviceTypeAsync = ref.watch(vectorSearchServiceTypeProvider);
    final statsAsync = ref.watch(unifiedVectorSearchStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        serviceTypeAsync.when(
          data: (serviceType) => Text('服务类型: ${serviceType.name}'),
          loading: () => const Text('服务类型: 检查中...'),
          error: (error, _) => Text('服务类型: 检查失败 - $error'),
        ),
        const SizedBox(height: 4),
        statsAsync.when(
          data: (stats) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('数据库类型: ${stats['databaseType'] ?? "未知"}'),
              Text('HNSW 支持: ${stats['supportsHNSW'] == true ? "是" : "否"}'),
              Text(
                '实时搜索: ${stats['supportsRealTimeSearch'] == true ? "是" : "否"}',
              ),
            ],
          ),
          loading: () => const Text('统计信息: 加载中...'),
          error: (error, _) => Text('统计信息: 加载失败 - $error'),
        ),
      ],
    );
  }

  Widget _buildKnowledgeBaseStatsDetails(WidgetRef ref) {
    final statsAsync = ref.watch(unifiedKnowledgeBaseStatsProvider);

    return statsAsync.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('文档总数: ${stats['totalDocuments'] ?? 0}'),
          Text('片段总数: ${stats['totalChunks'] ?? 0}'),
          Text(
            '向量数据库健康: ${stats['vectorDatabaseHealthy'] == true ? "正常" : "异常"}',
          ),
          if (stats['cacheSize'] != null) Text('缓存大小: ${stats['cacheSize']}'),
          if (stats['lastUpdated'] != null)
            Text('最后更新: ${stats['lastUpdated']}'),
        ],
      ),
      loading: () => const Text('统计信息: 加载中...'),
      error: (error, _) => Text('统计信息: 加载失败 - $error'),
    );
  }

  String _getDatabaseTypeName(VectorDatabaseType type) {
    switch (type) {
      case VectorDatabaseType.objectBox:
        return 'ObjectBox';
      case VectorDatabaseType.localFile:
        return '本地文件';
    }
  }

  /// 显示系统状态详情对话框
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const SystemStatusDialog(),
    );
  }
}
