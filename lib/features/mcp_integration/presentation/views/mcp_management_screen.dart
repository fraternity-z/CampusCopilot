import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/modern_scaffold.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_servers_provider.dart';
import '../widgets/mcp_server_card.dart';
import '../widgets/mcp_server_edit_dialog.dart';
import 'mcp_tools_screen.dart';

/// MCP服务器管理主界面
class McpManagementScreen extends ConsumerWidget {
  const McpManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ModernScaffold(
      appBar: AppBar(
        title: const Text('MCP 服务管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddServerDialog(context),
            icon: const Icon(Icons.add),
            tooltip: '添加服务器',
          ),
          IconButton(
            onPressed: () => _refreshServers(ref),
            icon: const Icon(Icons.refresh),
            tooltip: '刷新状态',
          ),
        ],
      ),
      body: Column(
        children: [
          // 服务器统计信息卡片
          _buildStatsCard(context, ref),
          const SizedBox(height: 16),
          // 服务器列表
          Expanded(
            child: _buildServersList(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "mcp_management_fab",
        onPressed: () => _showAddServerDialog(context),
        tooltip: '添加MCP服务器',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 构建统计信息卡片
  Widget _buildStatsCard(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(serverStatsProvider);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.dns,
              label: '服务器',
              value: stats['total'].toString(),
              color: Colors.blue,
            ),
            _buildStatItem(
              icon: Icons.link,
              label: '已连接',
              value: stats['connected'].toString(),
              color: Colors.green,
            ),
            _buildStatItem(
              icon: Icons.error,
              label: '失败',
              value: stats['failed'].toString(),
              color: Colors.red,
            ),
            _buildStatItem(
              icon: Icons.pause,
              label: '禁用',
              value: stats['disabled'].toString(),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单个统计项
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
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

  /// 构建服务器列表
  Widget _buildServersList(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final serversAsync = ref.watch(mcpServersProvider);
        
        return serversAsync.when(
          data: (servers) => _buildServerListContent(context, ref, servers),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('加载失败: $error'),
                ElevatedButton(
                  onPressed: () => ref.invalidate(mcpServersProvider),
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServerListContent(BuildContext context, WidgetRef ref, List<McpServerConfig> servers) {

    if (servers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无MCP服务器',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右下角按钮添加第一个服务器',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: servers.length,
      itemBuilder: (context, index) {
        final server = servers[index];
        return McpServerCard(
          server: server,
          onTap: () => _showServerDetails(context, server),
          onEdit: () => _showEditServerDialog(context, server),
          onDelete: () => _confirmDeleteServer(context, ref, server),
          onToggle: () => _toggleServerEnabled(ref, server),
          onConnect: () => _connectToServer(ref, server),
        );
      },
    );
  }

  /// 显示添加服务器对话框
  void _showAddServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) => McpServerEditDialog(
          title: '添加MCP服务器',
          onSave: (config) async {
            try {
              // 添加服务器逻辑
              final serversNotifier = ref.read(mcpServersProvider.notifier);
              await serversNotifier.addServer(config);
              
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('服务器 "${config.name}" 已添加成功'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('添加服务器失败: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  /// 显示编辑服务器对话框
  void _showEditServerDialog(BuildContext context, McpServerConfig server) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) => McpServerEditDialog(
          title: '编辑服务器',
          server: server,
          onSave: (config) async {
            try {
              // 更新服务器逻辑
              final serversNotifier = ref.read(mcpServersProvider.notifier);
              await serversNotifier.updateServer(config);
              
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('服务器 "${config.name}" 已更新成功'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('更新服务器失败: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  /// 显示服务器详情
  void _showServerDetails(BuildContext context, McpServerConfig server) {
    // 导航到MCP工具界面，显示服务器详情和工具
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => McpToolsScreen(server: server),
      ),
    );
  }

  /// 确认删除服务器
  void _confirmDeleteServer(
      BuildContext context, WidgetRef ref, McpServerConfig server) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除服务器 "${server.name}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // 删除服务器逻辑
                final serversNotifier = ref.read(mcpServersProvider.notifier);
                await serversNotifier.deleteServer(server.id);
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('服务器 "${server.name}" 已删除'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('删除服务器失败: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 切换服务器启用状态
  Future<void> _toggleServerEnabled(WidgetRef ref, McpServerConfig server) async {
    try {
      // 切换启用状态逻辑
      final serversNotifier = ref.read(mcpServersProvider.notifier);
      await serversNotifier.toggleServer(server.id);
    } catch (error) {
      // 显示错误信息但不阻塞用户界面
      debugPrint('切换服务器状态失败: $error');
    }
  }

  /// 连接到服务器
  Future<void> _connectToServer(WidgetRef ref, McpServerConfig server) async {
    try {
      // 连接服务器逻辑
      final serversNotifier = ref.read(mcpServersProvider.notifier);
      
      if (server.isConnected) {
        // 如果已连接，则断开连接
        await serversNotifier.disconnectFromServer(server.id);
      } else {
        // 如果未连接，则尝试连接
        await serversNotifier.connectToServer(server.id);
      }
    } catch (error) {
      // 显示错误信息但不阻塞用户界面
      debugPrint('服务器连接操作失败: $error');
    }
  }

  /// 刷新服务器状态
  Future<void> _refreshServers(WidgetRef ref) async {
    // 刷新所有服务器状态
    try {
      // 刷新服务器列表
      await ref.read(mcpServersProvider.notifier).refresh();
      
      // 刷新相关Provider缓存
      final servers = ref.read(mcpServersProvider).value ?? [];
      for (final server in servers) {
        ref.invalidate(connectionStatusProvider(server.id));
        ref.invalidate(serverToolsProvider(server.id));
        ref.invalidate(serverResourcesProvider(server.id));
      }
    } catch (error) {
      debugPrint('刷新服务器状态失败: $error');
    }
  }
}