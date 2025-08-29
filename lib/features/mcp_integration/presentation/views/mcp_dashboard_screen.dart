import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/modern_scaffold.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_servers_provider.dart';
import '../widgets/mcp_connection_monitor.dart';
import '../widgets/mcp_server_card.dart';
import 'mcp_management_screen.dart';
import 'mcp_tools_screen.dart';

/// MCP服务仪表板主界面
class McpDashboardScreen extends ConsumerWidget {
  const McpDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(mcpServersProvider);
    
    return serversAsync.when(
      data: (servers) => _buildContent(context, ref, servers),
      loading: () => _buildLoading(),
      error: (error, stack) => _buildError(context, error),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<McpServerConfig> servers) {
    return ModernScaffold(
      appBar: AppBar(
        title: const Text('MCP 服务中心'),
        actions: [
          IconButton(
            onPressed: () => _navigateToManagement(context),
            icon: const Icon(Icons.settings),
            tooltip: '服务器管理',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 连接状态监控面板
              McpConnectionMonitor(servers: servers),
              
              // 快速操作区域
              _buildQuickActions(context, ref),
              
              // 最近使用的服务器
              _buildRecentServers(context, servers),
              
              // 功能导航卡片
              _buildFeatureCards(context, ref, servers),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "mcp_dashboard_fab",
        onPressed: () => _navigateToManagement(context),
        icon: const Icon(Icons.add),
        label: const Text('添加服务器'),
      ),
    );
  }

  /// 构建快速操作区域
  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速操作',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.dns,
                    label: '管理服务器',
                    subtitle: '添加、编辑或删除MCP服务器',
                    color: Colors.blue,
                    onTap: () => _navigateToManagement(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.monitor,
                    label: '状态监控',
                    subtitle: '查看所有服务器状态',
                    color: Colors.orange,
                    onTap: () => _navigateToManagement(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.refresh,
                    label: '全部刷新',
                    subtitle: '刷新所有服务器状态',
                    color: Colors.green,
                    onTap: () => _refreshAllServers(context, ref),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.link,
                    label: '重新连接',
                    subtitle: '重连断开的服务器',
                    color: Colors.purple,
                    onTap: () => _reconnectFailedServers(context, ref),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建快速操作按钮
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建最近使用的服务器
  Widget _buildRecentServers(BuildContext context, List<McpServerConfig> servers) {
    final recentServers = servers.take(3).toList(); // 显示最近3个

    if (recentServers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '最近使用',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _navigateToManagement(context),
                child: const Text('查看全部'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentServers.length,
            itemBuilder: (context, index) {
              final server = recentServers[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                child: McpServerCard(
                  server: server,
                  onTap: () => _navigateToServerDetail(context, server),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 构建功能导航卡片
  Widget _buildFeatureCards(BuildContext context, WidgetRef ref, List<McpServerConfig> servers) {

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '功能导航',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildFeatureCard(
                title: '服务器管理',
                subtitle: '添加、编辑和配置MCP服务器',
                icon: Icons.dns,
                color: Colors.blue,
                onTap: () => _navigateToManagement(context),
              ),
              _buildFeatureCard(
                title: '连接监控',
                subtitle: '查看服务器连接状态',
                icon: Icons.monitor_heart,
                color: Colors.green,
                onTap: () => _navigateToManagement(context),
              ),
              _buildFeatureCard(
                title: '调用历史',
                subtitle: '查看工具使用记录',
                icon: Icons.history,
                color: Colors.purple,
                onTap: () => _navigateToManagement(context),
              ),
              _buildFeatureCard(
                title: '快速连接',
                subtitle: '一键连接MCP服务器',
                icon: Icons.flash_on,
                color: Colors.orange,
                onTap: () => _quickConnectServers(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建功能卡片
  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 导航到服务器管理界面
  void _navigateToManagement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const McpManagementScreen(),
      ),
    );
  }

  /// 导航到服务器详情(工具/资源界面)
  void _navigateToServerDetail(BuildContext context, McpServerConfig server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => McpToolsScreen(server: server),
      ),
    );
  }

  /// 刷新数据
  Future<void> _refreshData(WidgetRef ref) async {
    try {
      // 刷新服务器列表数据
      await ref.read(mcpServersProvider.notifier).refresh();
    } catch (e) {
      debugPrint('刷新数据失败: $e');
    }
  }

  /// 刷新所有服务器
  void _refreshAllServers(BuildContext context, WidgetRef ref) {
    try {
      // 刷新服务器列表
      ref.read(mcpServersProvider.notifier).refresh();
      
      // 显示刷新提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在刷新所有服务器状态...')),
      );
    } catch (e) {
      debugPrint('刷新所有服务器失败: $e');
    }
  }

  /// 重连失败的服务器
  void _reconnectFailedServers(BuildContext context, WidgetRef ref) {
    try {
      // 调用Provider的重连方法
      ref.read(mcpServersProvider.notifier).reconnectFailedServers();
      
      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正在重连失败的服务器...')),
      );
    } catch (e) {
      debugPrint('重连失败服务器失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('重连失败: $e')),
      );
    }
  }

  /// 快速连接所有服务器
  void _quickConnectServers(BuildContext context, WidgetRef ref) {
    try {
      final serversAsync = ref.read(mcpServersProvider);
      serversAsync.whenData((servers) async {
        final disconnectedServers = servers.where((s) => !s.isConnected && !(s.disabled ?? false));
        
        if (disconnectedServers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('没有需要连接的服务器')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('正在连接${disconnectedServers.length}个服务器...')),
        );

        // 连接所有断开的服务器
        for (final server in disconnectedServers) {
          try {
            await ref.read(mcpServersProvider.notifier).connectToServer(server.id);
          } catch (e) {
            debugPrint('连接服务器${server.name}失败: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('快速连接服务器失败: $e');
    }
  }

  /// 构建加载状态
  Widget _buildLoading() {
    return const ModernScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在加载MCP服务器...'),
          ],
        ),
      ),
    );
  }

  /// 构建错误状态
  Widget _buildError(BuildContext context, Object error) {
    return ModernScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: ${error.toString()}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 重试加载
                // ref.invalidate(mcpServersProvider);
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}