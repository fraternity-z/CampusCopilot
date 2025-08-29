import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/modern_scaffold.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_servers_provider.dart';
import '../widgets/mcp_tool_card.dart';
import '../widgets/mcp_tool_call_dialog.dart';

/// MCP工具调用界面
class McpToolsScreen extends ConsumerStatefulWidget {
  final McpServerConfig? server;

  const McpToolsScreen({
    super.key,
    this.server,
  });

  @override
  ConsumerState<McpToolsScreen> createState() => _McpToolsScreenState();
}

class _McpToolsScreenState extends ConsumerState<McpToolsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  McpServerConfig? _selectedServer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedServer = widget.server;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      appBar: AppBar(
        title: Text(_selectedServer?.name ?? 'MCP 工具'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // 服务器选择器
              if (_selectedServer == null) _buildServerSelector(),
              // 标签栏
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '工具', icon: Icon(Icons.build)),
                  Tab(text: '资源', icon: Icon(Icons.folder)),
                  Tab(text: '历史', icon: Icon(Icons.history)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),
          // 标签页内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildToolsTab(),
                _buildResourcesTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建服务器选择器
  Widget _buildServerSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<McpServerConfig>(
        initialValue: _selectedServer,
        decoration: const InputDecoration(
          labelText: '选择服务器',
          border: OutlineInputBorder(),
        ),
        items: ref.watch(mcpServersProvider).when(
          data: (servers) => servers
              .map((server) => DropdownMenuItem<McpServerConfig>(
                    value: server,
                    child: Text(server.name),
                  ))
              .toList(),
          loading: () => [],
          error: (_, _) => [],
        ),
        onChanged: (server) {
          setState(() {
            _selectedServer = server;
          });
        },
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索工具、资源或历史记录...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  /// 构建工具标签页
  Widget _buildToolsTab() {
    if (_selectedServer == null) {
      return const Center(
        child: Text('请先选择一个MCP服务器'),
      );
    }

    // 从Provider获取工具列表
    final toolsAsync = ref.watch(serverToolsProvider(_selectedServer!.id));
    
    return toolsAsync.when(
      data: (tools) => _buildToolsList(tools),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red),
            Text('加载工具失败: $error'),
            ElevatedButton(
              onPressed: () => ref.invalidate(serverToolsProvider(_selectedServer!.id)),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsList(List<McpTool> tools) {

    if (tools.isEmpty) {
      return _buildEmptyState(
        icon: Icons.build_outlined,
        title: '暂无可用工具',
        subtitle: '此服务器未提供任何工具',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return McpToolCard(
          tool: tool,
          onTap: () => _showToolCallDialog(tool),
        );
      },
    );
  }

  /// 构建资源标签页
  Widget _buildResourcesTab() {
    if (_selectedServer == null) {
      return const Center(
        child: Text('请先选择一个MCP服务器'),
      );
    }

    // 从Provider获取资源列表
    final resourcesAsync = ref.watch(serverResourcesProvider(_selectedServer!.id));
    
    return resourcesAsync.when(
      data: (resources) => _buildResourcesList(resources),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red),
            Text('加载资源失败: $error'),
            ElevatedButton(
              onPressed: () => ref.invalidate(serverResourcesProvider(_selectedServer!.id)),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesList(List<McpResource> resources) {
    if (resources.isEmpty) {
      return _buildEmptyState(
        icon: Icons.folder_outlined,
        title: '暂无可用资源',
        subtitle: '此服务器未提供任何资源',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return Card(
          child: ListTile(
            leading: Icon(_getResourceIcon(resource.mimeType)),
            title: Text(resource.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.uri),
                if (resource.description != null) Text(resource.description!),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showResourceDetails(resource),
          ),
        );
      },
    );
  }

  /// 构建历史标签页
  Widget _buildHistoryTab() {
    if (_selectedServer == null) {
      return const Center(
        child: Text('请先选择一个MCP服务器'),
      );
    }

    // 暂时显示功能开发中的状态
    return _buildEmptyState(
      icon: Icons.history,
      title: '调用历史功能开发中',
      subtitle: '此功能将在后续版本中提供',
    );
  }


  /// 构建空状态
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示工具调用对话框
  void _showToolCallDialog(McpTool tool) {
    showDialog(
      context: context,
      builder: (context) => McpToolCallDialog(
        tool: tool,
        server: _selectedServer!,
        onCall: (arguments) async {
          // 调用工具逻辑
          await _callTool(tool, arguments);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  /// 调用MCP工具
  Future<void> _callTool(McpTool tool, Map<String, dynamic> arguments) async {
    try {
      final clientService = ref.read(mcpClientServiceProvider);
      
      // 显示加载提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('正在调用工具 ${tool.name}...')),
      );

      // 调用工具
      await clientService.callTool(
        _selectedServer!.id, 
        tool.name, 
        arguments,
      );

      // 显示成功结果
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('工具调用成功'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 刷新工具列表（移除历史记录相关功能）
      ref.invalidate(serverToolsProvider(_selectedServer!.id));
      
    } catch (error) {
      // 显示错误信息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('工具调用失败: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 显示资源详情
  void _showResourceDetails(McpResource resource) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 资源头部信息
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getResourceIcon(resource.mimeType),
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resource.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resource.uri,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 资源详情
              if (resource.description?.isNotEmpty == true) ...[
                const Text(
                  '描述',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    resource.description!,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // 资源信息
              const Text(
                '资源信息',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildResourceInfoItem('URI', resource.uri),
              if (resource.mimeType != null)
                _buildResourceInfoItem('MIME类型', resource.mimeType!),
              const SizedBox(height: 16),
              // 操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('关闭'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _loadResource(resource),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('加载资源'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建资源信息项
  Widget _buildResourceInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// 加载资源内容
  Future<void> _loadResource(McpResource resource) async {
    if (_selectedServer == null) return;
    
    try {
      final clientService = ref.read(mcpClientServiceProvider);
      final result = await clientService.getResource(
        _selectedServer!.id,
        resource.uri,
      );
      
      if (mounted) {
        // 显示资源内容
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              width: 700,
              constraints: const BoxConstraints(maxHeight: 600),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '资源内容: ${resource.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          result['contents']?.toString() ?? '无内容',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('关闭'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载资源失败: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  /// 获取资源图标
  IconData _getResourceIcon(String? mimeType) {
    if (mimeType == null) return Icons.insert_drive_file;
    
    if (mimeType.startsWith('image/')) return Icons.image;
    if (mimeType.startsWith('video/')) return Icons.video_file;
    if (mimeType.startsWith('audio/')) return Icons.audio_file;
    if (mimeType.startsWith('text/')) return Icons.text_snippet;
    if (mimeType.contains('json')) return Icons.data_object;
    if (mimeType.contains('xml') || mimeType.contains('html')) return Icons.code;
    
    return Icons.insert_drive_file;
  }

}