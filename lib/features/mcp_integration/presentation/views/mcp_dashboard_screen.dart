import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/modern_scaffold.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../widgets/mcp_connection_monitor.dart';
import '../widgets/mcp_server_card.dart';
import 'mcp_management_screen.dart';
import 'mcp_tools_screen.dart';

/// MCP服务仪表板主界面
class McpDashboardScreen extends ConsumerWidget {
  const McpDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 暂时使用空列表，等待Provider层实现后连接实际数据源
    final servers = <McpServerConfig>[];
    
    // TODO: 当Repository层完成后，改为从Provider获取：
    // final servers = ref.watch(mcpServersProvider);

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
              _buildQuickActions(context),
              
              // 最近使用的服务器
              _buildRecentServers(context, servers),
              
              // 功能导航卡片
              _buildFeatureCards(context, servers),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToManagement(context),
        icon: const Icon(Icons.add),
        label: const Text('添加服务器'),
      ),
    );
  }

  /// 构建快速操作区域
  Widget _buildQuickActions(BuildContext context) {
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
                    onTap: () => _refreshAllServers(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.link,
                    label: '重新连接',
                    subtitle: '重连断开的服务器',
                    color: Colors.purple,
                    onTap: () => _reconnectFailedServers(),
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
  Widget _buildFeatureCards(BuildContext context, List<McpServerConfig> servers) {

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
                onTap: () => _quickConnectServers(),
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
    // TODO: 实现数据刷新逻辑
    await Future.delayed(const Duration(seconds: 1));
  }

  /// 刷新所有服务器
  void _refreshAllServers() {
    // TODO: 实现刷新所有服务器逻辑
  }

  /// 重连失败的服务器
  void _reconnectFailedServers() {
    // TODO: 实现重连失败服务器逻辑
  }

  /// 快速连接所有服务器
  void _quickConnectServers() {
    // TODO: 实现快速连接所有服务器逻辑
  }
}