import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_servers_provider.dart';

/// MCP连接状态监控面板
class McpConnectionMonitor extends ConsumerWidget {
  final List<McpServerConfig> servers;

  const McpConnectionMonitor({
    super.key,
    required this.servers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.monitor_heart, color: Colors.blue),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '连接状态监控',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // 总体状态指示器
                _buildOverallStatus(),
              ],
            ),
          ),
          const Divider(height: 1),
          // 服务器状态列表
          if (servers.isEmpty)
            _buildEmptyState()
          else
            _buildServerStatusList(ref),
          // 操作栏
          _buildActionBar(context, ref),
        ],
      ),
    );
  }

  /// 构建总体状态指示器
  Widget _buildOverallStatus() {
    final connectedCount = servers.where((s) => s.isConnected).length;
    final totalCount = servers.length;
    final hasErrors = servers.any((s) => s.error != null);

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (hasErrors) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
      statusText = '存在错误';
    } else if (connectedCount == totalCount && totalCount > 0) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = '全部连接';
    } else if (connectedCount > 0) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      statusText = '部分连接';
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.radio_button_unchecked;
      statusText = '全部断开';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
  color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
          if (totalCount > 0) ...[
            const SizedBox(width: 6),
            Text(
              '($connectedCount/$totalCount)',
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
              ),
            ),
          ],
        ],
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: hasErrors ? 1500.ms : 0.ms);
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.dns_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无MCP服务器',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '添加服务器后开始监控连接状态',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建服务器状态列表
  Widget _buildServerStatusList(WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: servers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final server = servers[index];
          return _buildServerStatusItem(server, ref);
        },
      ),
    );
  }

  /// 构建单个服务器状态项
  Widget _buildServerStatusItem(McpServerConfig server, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getServerStatusColor(server).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getServerStatusColor(server).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // 状态指示器
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getServerStatusColor(server),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: server.isConnected ? 0.ms : 2000.ms),
          const SizedBox(width: 12),
          // 服务器信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        server.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildTransportChip(server.type),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  server.baseUrl,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (server.error != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    server.error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // 连接信息
          _buildConnectionInfo(server, ref),
        ],
      ),
    );
  }

  /// 构建传输类型标签
  Widget _buildTransportChip(McpTransportType type) {
    Color color;
    IconData icon;

    switch (type) {
      case McpTransportType.sse:
        color = Colors.blue;
        icon = Icons.stream;
        break;
      case McpTransportType.streamableHttp:
        color = Colors.purple;
        icon = Icons.http;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            type.name.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建连接信息
  Widget _buildConnectionInfo(McpServerConfig server, WidgetRef ref) {
    if (server.disabled == true) {
      return const Icon(Icons.pause, size: 16, color: Colors.grey);
    }

    if (server.isConnected) {
      // 从实际网络请求获取延迟数据
      final connectionStatus = ref.watch(connectionStatusProvider(server.id));
      
      return connectionStatus.when(
        data: (status) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status?.latency != null ? '${status!.latency}ms' : '-',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green[600],
            ),
          ],
        ),
        loading: () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '检测中...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green[600],
            ),
          ],
        ),
        error: (_, stackTrace) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '错误',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.error,
              size: 16,
              color: Colors.red[600],
            ),
          ],
        ),
      );
    }

    if (server.error != null) {
      return Icon(
        Icons.error,
        size: 16,
        color: Colors.red[600],
      );
    }

    return const Icon(
      Icons.radio_button_unchecked,
      size: 16,
      color: Colors.grey,
    );
  }

  /// 构建操作栏
  Widget _buildActionBar(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 刷新按钮
          TextButton.icon(
            onPressed: () => _refreshAll(ref),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('刷新状态'),
          ),
          const SizedBox(width: 16),
          // 重连按钮
          TextButton.icon(
            onPressed: servers.any((s) => !s.isConnected && s.disabled != true)
                ? () => _reconnectAll(ref)
                : null,
            icon: const Icon(Icons.link, size: 16),
            label: const Text('重连失败'),
          ),
          const Spacer(),
          // 详细信息按钮
          TextButton.icon(
            onPressed: () => _showDetailedStatus(context),
            icon: const Icon(Icons.info, size: 16),
            label: const Text('详细信息'),
          ),
        ],
      ),
    );
  }

  /// 获取服务器状态颜色
  Color _getServerStatusColor(McpServerConfig server) {
    if (server.disabled == true) {
      return Colors.grey;
    } else if (server.isConnected) {
      return Colors.green;
    } else if (server.error != null) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  /// 刷新所有服务器状态
  Future<void> _refreshAll(WidgetRef ref) async {
    // 调用实际的服务器状态刷新
    final clientService = ref.read(mcpClientServiceProvider);
    
    for (final server in servers) {
      if (server.isConnected) {
        try {
          // 执行ping检测服务器状态
          await clientService.ping(server.id);
          debugPrint('Refreshed server: ${server.name}');
        } catch (e) {
          debugPrint('Failed to refresh server ${server.name}: $e');
        }
      }
    }
    
    // 刷新连接状态Provider缓存
    for (final server in servers) {
      ref.invalidate(connectionStatusProvider(server.id));
    }
    
    // 刷新服务器列表
    ref.invalidate(mcpServersProvider);
  }

  /// 重连所有失败的服务器
  Future<void> _reconnectAll(WidgetRef ref) async {
    // 调用实际的服务器重连逻辑
    final serversNotifier = ref.read(mcpServersProvider.notifier);
    
    for (final server in servers) {
      if (!server.isConnected && server.disabled != true) {
        try {
          // 通过McpServersNotifier进行重连
          await serversNotifier.connectToServer(server.id);
          debugPrint('Successfully reconnected to server: ${server.name}');
        } catch (e) {
          debugPrint('Failed to reconnect to server ${server.name}: $e');
        }
      }
    }
    
    // 刷新连接状态
    for (final server in servers) {
      ref.invalidate(connectionStatusProvider(server.id));
    }
  }

  /// 显示详细状态信息
  void _showDetailedStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _DetailedStatusDialog(servers: servers),
    );
  }
}

/// 详细状态信息对话框
class _DetailedStatusDialog extends StatelessWidget {
  final List<McpServerConfig> servers;

  const _DetailedStatusDialog({required this.servers});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('连接状态详情'),
      content: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 统计信息
              _buildStatistics(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // 服务器详情列表
              ...servers.map((server) => _buildServerDetail(server)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
      ],
    );
  }

  /// 构建统计信息
  Widget _buildStatistics() {
    final connectedCount = servers.where((s) => s.isConnected).length;
    final errorCount = servers.where((s) => s.error != null).length;
    final disabledCount = servers.where((s) => s.disabled == true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '统计信息',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('总数', servers.length.toString(), Colors.blue),
            _buildStatItem('已连接', connectedCount.toString(), Colors.green),
            _buildStatItem('错误', errorCount.toString(), Colors.red),
            _buildStatItem('禁用', disabledCount.toString(), Colors.grey),
          ],
        ),
      ],
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 构建服务器详情
  Widget _buildServerDetail(McpServerConfig server) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  server.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(server),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow('URL', server.baseUrl),
          _buildDetailRow('类型', server.type.name.toUpperCase()),
          if (server.timeout != null)
            _buildDetailRow('超时', '${server.timeout}秒'),
          if (server.lastConnected != null)
            _buildDetailRow('上次连接', _formatDateTime(server.lastConnected!)),
          if (server.error != null)
            _buildDetailRow('错误信息', server.error!, isError: true),
        ],
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isError ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取状态颜色
  Color _getStatusColor(McpServerConfig server) {
    if (server.disabled == true) {
      return Colors.grey;
    } else if (server.isConnected) {
      return Colors.green;
    } else if (server.error != null) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else {
      return '${difference.inDays}天前';
    }
  }
}