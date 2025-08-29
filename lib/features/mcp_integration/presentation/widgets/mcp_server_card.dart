import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_servers_provider.dart';

/// MCP服务器卡片组件
class McpServerCard extends ConsumerWidget {
  final McpServerConfig server;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggle;
  final VoidCallback? onConnect;

  const McpServerCard({
    super.key,
    required this.server,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggle,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 服务器基本信息
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 连接状态指示器
                    _buildStatusIndicator(),
                    const SizedBox(width: 12),
                    // 服务器信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  server.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _buildTransportTypeChip(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            server.baseUrl,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                          if (server.lastConnected != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '上次连接: ${_formatDateTime(server.lastConnected!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // 操作按钮
                    _buildActionButtons(context),
                  ],
                ),
              ),
              // 服务器状态详情 - 简化显示
              if (server.isConnected) _buildSimpleConnectionStatus(ref),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  /// 构建状态指示器
  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;
    String tooltip;

    if (server.disabled == true) {
      color = Colors.grey;
      icon = Icons.pause_circle;
      tooltip = '已禁用';
    } else if (server.isConnected) {
      color = Colors.green;
      icon = Icons.check_circle;
      tooltip = '已连接';
    } else if (server.error != null) {
      color = Colors.red;
      icon = Icons.error;
      tooltip = '连接错误';
    } else {
      color = Colors.orange;
      icon = Icons.radio_button_unchecked;
      tooltip = '未连接';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 8,
          color: Colors.white,
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: server.isConnected ? 0.ms : 2000.ms);
  }

  /// 构建传输类型标签
  Widget _buildTransportTypeChip() {
    final type = server.type;
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
  border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            type.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 连接/断开按钮
        IconButton(
          onPressed: onConnect,
          icon: Icon(
            server.isConnected ? Icons.link_off : Icons.link,
            color: server.isConnected ? Colors.red : Colors.green,
          ),
          tooltip: server.isConnected ? '断开连接' : '连接服务器',
        ),
        // 更多操作菜单
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit?.call();
                break;
              case 'toggle':
                onToggle?.call();
                break;
              case 'delete':
                onDelete?.call();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    server.disabled == true 
                        ? Icons.play_arrow 
                        : Icons.pause,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(server.disabled == true ? '启用' : '禁用'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
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

  /// 构建简化的连接状态
  Widget _buildSimpleConnectionStatus(WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider(server.id));
    final serverTools = ref.watch(serverToolsProvider(server.id));
    final serverResources = ref.watch(serverResourcesProvider(server.id));
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(
            color: Colors.green.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: Colors.green[600],
          ),
          const SizedBox(width: 8),
          Text(
            '已连接',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          // 延迟显示
          connectionStatus.when(
            data: (status) => status?.latency != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${status!.latency}ms',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, _) => const SizedBox(),
          ),
          const Spacer(),
          // 工具和资源数量
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              serverTools.when(
                data: (tools) => _buildCompactStat(Icons.build, tools.length),
                loading: () => _buildCompactStat(Icons.build, null),
                error: (_, _) => const SizedBox(),
              ),
              const SizedBox(width: 12),
              serverResources.when(
                data: (resources) => _buildCompactStat(Icons.folder, resources.length),
                loading: () => _buildCompactStat(Icons.folder, null),
                error: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建紧凑的统计显示
  Widget _buildCompactStat(IconData icon, int? count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 2),
        Text(
          count?.toString() ?? '...',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}