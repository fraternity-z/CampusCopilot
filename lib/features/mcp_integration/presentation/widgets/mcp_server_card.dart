import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/mcp_server_config.dart';

/// MCP服务器卡片组件
class McpServerCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
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
                        ),
                        if (server.error != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            server.error!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                            maxLines: 2,
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
            // 服务器状态详情
            if (server.isConnected) _buildConnectionDetails(),
          ],
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

  /// 构建连接详情
  Widget _buildConnectionDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
  color: Colors.green.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.green[700],
              ),
              const SizedBox(width: 8),
              Text(
                '连接详情',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 显示模拟的连接详情，实际数据需要从服务器获取
          Row(
            children: [
              _buildDetailItem('延迟', '45ms'), // TODO: 从实际ping结果获取
              const SizedBox(width: 24),
              _buildDetailItem('工具', '12'), // TODO: 从服务器获取实际工具数量
              const SizedBox(width: 24),
              _buildDetailItem('资源', '8'), // TODO: 从服务器获取实际资源数量
            ],
          ),
        ],
      ),
    );
  }

  /// 构建详情项
  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
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
}