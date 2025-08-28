import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/modern_scaffold.dart';
import '../../domain/entities/mcp_server_config.dart';
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
        items: const [], // TODO: 从Provider获取服务器列表
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

    // TODO: 从Provider获取工具列表
    final tools = <McpTool>[];

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

    // TODO: 从Provider获取资源列表
    final resources = <McpResource>[];

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
    // TODO: 从Provider获取调用历史
    final history = <McpCallHistory>[];

    if (history.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: '暂无调用历史',
        subtitle: '开始使用工具后将显示调用记录',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final call = history[index];
        return Card(
          child: ListTile(
            leading: Icon(
              call.error != null ? Icons.error : Icons.check_circle,
              color: call.error != null ? Colors.red : Colors.green,
            ),
            title: Text(call.toolName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDateTime(call.calledAt)),
                if (call.error != null) 
                  Text(
                    call.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
            trailing: Text(
              call.duration != null ? '${call.duration}ms' : '',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () => _showCallDetails(call),
          ),
        );
      },
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
        onCall: (arguments) {
          // TODO: 调用工具逻辑
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 显示资源详情
  void _showResourceDetails(McpResource resource) {
    // TODO: 显示资源详情对话框或页面
  }

  /// 显示调用详情
  void _showCallDetails(McpCallHistory call) {
    // TODO: 显示调用详情对话框
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