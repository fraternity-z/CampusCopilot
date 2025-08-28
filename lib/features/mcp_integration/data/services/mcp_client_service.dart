import 'dart:async';
import 'dart:convert';
import 'package:mcp_client/mcp_client.dart';
import 'package:logging/logging.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../../domain/services/mcp_service_interface.dart';
import '../providers/mcp_transport_factory.dart';
import '../providers/mcp_oauth_provider.dart';

/// MCP客户端服务实现
/// 负责与MCP服务器的实际通信和状态管理
class McpClientService implements McpServiceInterface {
  static final Logger _logger = Logger('McpClientService');
  
  /// 客户端实例缓存 serverId -> Client
  final Map<String, Client> _clients = {};
  
  /// 等待连接的客户端 serverId -> Future<Client>
  final Map<String, Future<Client>> _pendingConnections = {};
  
  /// 连接状态流控制器 serverId -> StreamController<McpConnectionStatus>
  final Map<String, StreamController<McpConnectionStatus>> _statusControllers = {};
  
  /// 活动的工具调用 callId -> 取消控制器
  final Map<String, StreamController<dynamic>> _activeToolCalls = {};
  
  /// 健康检查定时器 serverId -> Timer
  final Map<String, Timer> _healthTimers = {};
  
  /// 传输层工厂
  final McpTransportFactory _transportFactory = McpTransportFactory();
  
  /// OAuth提供者
  final McpOAuthProvider _oauthProvider = McpOAuthProvider();

  @override
  Future<bool> connect(McpServerConfig server) async {
    final serverId = server.id;
    
    // 如果已经连接，直接返回
    if (_clients.containsKey(serverId)) {
      final isConnected = await _clients[serverId]!.ping();
      if (isConnected) return true;
      
      // 连接已失效，清理并重新连接
      await _cleanupClient(serverId);
    }

    // 如果正在连接，等待连接完成
    if (_pendingConnections.containsKey(serverId)) {
      try {
        await _pendingConnections[serverId];
        return _clients.containsKey(serverId);
      } catch (e) {
        _pendingConnections.remove(serverId);
        return false;
      }
    }

    // 开始新连接
    final connectionFuture = _createConnection(server);
    _pendingConnections[serverId] = connectionFuture;

    try {
      final client = await connectionFuture;
      _clients[serverId] = client;
      _pendingConnections.remove(serverId);
      
      // 更新连接状态
      await _updateConnectionStatus(serverId, true);
      
      // 开始健康检查
      await startHealthMonitoring(serverId);
      
      _logger.info('Successfully connected to MCP server: ${server.name}');
      return true;
    } catch (e) {
      _pendingConnections.remove(serverId);
      await _updateConnectionStatus(serverId, false, error: e.toString());
      _logger.severe('Failed to connect to MCP server ${server.name}: $e');
      return false;
    }
  }

  /// 创建新的客户端连接
  Future<Client> _createConnection(McpServerConfig server) async {
    _logger.info('Creating connection to ${server.name} (${server.type.name})');
    
    // 创建客户端配置
    final config = ClientInfo(
      name: 'AnywhereChat',
      version: '1.0.0',
    );
    
    // 创建客户端
    final client = McpClient(config);
    
    try {
      // 创建传输层
      final transport = await _transportFactory.createTransport(server);
      
      // 连接客户端
      await client.connect(transport);
      
      // 设置事件处理器
      _setupEventHandlers(client, server.id);
      
      return client;
    } catch (e) {
      _logger.severe('Failed to create connection: $e');
      rethrow;
    }
  }

  /// 设置客户端事件处理器
  void _setupEventHandlers(Client client, String serverId) {
    // 监听连接断开事件
    client.onClose.listen((_) {
      _logger.warning('Connection closed for server: $serverId');
      _handleDisconnection(serverId);
    });
    
    // 监听错误事件  
    client.onError.listen((error) {
      _logger.severe('Client error for server $serverId: $error');
      _updateConnectionStatus(serverId, false, error: error.toString());
    });
  }

  /// 处理连接断开
  void _handleDisconnection(String serverId) {
    _updateConnectionStatus(serverId, false);
    _cleanupClient(serverId);
  }

  @override
  Future<void> disconnect(String serverId) async {
    final client = _clients[serverId];
    if (client != null) {
      try {
        await client.close();
        _logger.info('Disconnected from server: $serverId');
      } catch (e) {
        _logger.warning('Error during disconnection: $e');
      }
    }
    
    await _cleanupClient(serverId);
    await _updateConnectionStatus(serverId, false);
  }

  /// 清理客户端资源
  Future<void> _cleanupClient(String serverId) async {
    _clients.remove(serverId);
    _pendingConnections.remove(serverId);
    
    // 停止健康检查
    _healthTimers[serverId]?.cancel();
    _healthTimers.remove(serverId);
    
    // 取消所有活动的工具调用
    final activeCallsToCancel = _activeToolCalls.entries
        .where((entry) => entry.key.startsWith(serverId))
        .toList();
    
    for (final entry in activeCallsToCancel) {
      entry.value.close();
      _activeToolCalls.remove(entry.key);
    }
  }

  @override
  Future<bool> isConnected(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return false;
    
    try {
      return await client.ping();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> ping(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return false;
    
    try {
      final result = await client.ping();
      await _updateConnectionStatus(serverId, result);
      return result;
    } catch (e) {
      await _updateConnectionStatus(serverId, false, error: e.toString());
      return false;
    }
  }

  @override
  Future<List<McpTool>> listTools(String serverId) async {
    final client = _clients[serverId];
    if (client == null) throw Exception('Client not connected: $serverId');

    try {
      final tools = await client.listTools();
      return tools.map((tool) => McpTool(
        name: tool.name,
        description: tool.description,
        inputSchema: tool.inputSchema.toJson(),
        serverId: serverId,
      )).toList();
    } catch (e) {
      _logger.severe('Failed to list tools for $serverId: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> callTool(
    String serverId, 
    String toolName, 
    Map<String, dynamic> arguments,
  ) async {
    final client = _clients[serverId];
    if (client == null) throw Exception('Client not connected: $serverId');

    final callId = '${serverId}_${toolName}_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      _logger.info('Calling tool $toolName on server $serverId with args: $arguments');
      
      final result = await client.callTool(toolName, arguments);
      
      // 处理结果
      final response = {
        'callId': callId,
        'toolName': toolName,
        'serverId': serverId,
        'result': result.content,
        'isError': result.isError,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      _logger.info('Tool call completed successfully: $callId');
      return response;
    } catch (e) {
      _logger.severe('Tool call failed: $callId - $e');
      return {
        'callId': callId,
        'toolName': toolName,
        'serverId': serverId,
        'error': e.toString(),
        'isError': true,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<void> cancelToolCall(String callId) async {
    final controller = _activeToolCalls[callId];
    if (controller != null) {
      controller.close();
      _activeToolCalls.remove(callId);
      _logger.info('Cancelled tool call: $callId');
    }
  }

  @override
  Future<List<McpResource>> listResources(String serverId) async {
    final client = _clients[serverId];
    if (client == null) throw Exception('Client not connected: $serverId');

    try {
      final resources = await client.listResources();
      return resources.map((resource) => McpResource(
        uri: resource.uri,
        name: resource.name,
        description: resource.description,
        mimeType: resource.mimeType,
        serverId: serverId,
      )).toList();
    } catch (e) {
      _logger.severe('Failed to list resources for $serverId: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getResource(String serverId, String uri) async {
    final client = _clients[serverId];
    if (client == null) throw Exception('Client not connected: $serverId');

    try {
      final result = await client.readResource(uri);
      return {
        'uri': uri,
        'contents': result.contents,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.severe('Failed to get resource $uri from $serverId: $e');
      rethrow;
    }
  }

  @override
  Future<McpConnectionStatus?> getConnectionStatus(String serverId) async {
    final client = _clients[serverId];
    final isConnected = client != null && await client.ping();
    
    return McpConnectionStatus(
      serverId: serverId,
      isConnected: isConnected,
      lastCheck: DateTime.now(),
      latency: isConnected ? await _measureLatency(client) : null,
    );
  }

  /// 测量连接延迟
  Future<int> _measureLatency(Client client) async {
    final stopwatch = Stopwatch()..start();
    try {
      await client.ping();
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<void> startHealthMonitoring(String serverId) async {
    // 停止现有的监控
    _healthTimers[serverId]?.cancel();
    
    // 开始新的监控
    _healthTimers[serverId] = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performHealthCheck(serverId),
    );
    
    _logger.info('Started health monitoring for server: $serverId');
  }

  @override
  Future<void> stopHealthMonitoring(String serverId) async {
    _healthTimers[serverId]?.cancel();
    _healthTimers.remove(serverId);
    _logger.info('Stopped health monitoring for server: $serverId');
  }

  /// 执行健康检查
  Future<void> _performHealthCheck(String serverId) async {
    try {
      final isHealthy = await ping(serverId);
      if (!isHealthy) {
        _logger.warning('Health check failed for server: $serverId');
        await attemptReconnection(serverId);
      }
    } catch (e) {
      _logger.warning('Health check error for server $serverId: $e');
    }
  }

  @override
  Stream<McpConnectionStatus> watchConnectionStatus(String serverId) {
    final controller = _statusControllers[serverId] ??= StreamController<McpConnectionStatus>.broadcast();
    return controller.stream;
  }

  /// 更新连接状态并通知监听器
  Future<void> _updateConnectionStatus(
    String serverId, 
    bool isConnected, 
    {String? error}
  ) async {
    final status = McpConnectionStatus(
      serverId: serverId,
      isConnected: isConnected,
      lastCheck: DateTime.now(),
      error: error,
      latency: isConnected ? await _measureLatency(_clients[serverId]!) : null,
    );

    _statusControllers[serverId]?.add(status);
  }

  @override
  Future<bool> attemptReconnection(String serverId) async {
    _logger.info('Attempting reconnection for server: $serverId');
    
    // 这里需要获取服务器配置，实际实现时需要从存储中获取
    // TODO: 从数据层获取服务器配置
    
    return false; // 临时返回false，等数据层实现后完善
  }

  // 其他接口方法的简化实现
  @override
  Future<Map<String, dynamic>?> getServerInfo(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return null;
    
    // TODO: 实现获取服务器信息
    return {};
  }

  @override
  Future<List<String>> getSupportedProtocolVersions(String serverId) async {
    return ['2025-03-26']; // 支持的协议版本
  }

  @override
  Future<void> subscribeToResource(String serverId, String uri) async {
    // TODO: 实现资源订阅
  }

  @override
  Future<void> unsubscribeFromResource(String serverId, String uri) async {
    // TODO: 实现取消资源订阅
  }

  @override
  Future<List<McpPrompt>> listPrompts(String serverId) async {
    // TODO: 实现获取提示列表
    return [];
  }

  @override
  Future<Map<String, dynamic>> getPrompt(
    String serverId, 
    String name, 
    Map<String, dynamic>? arguments,
  ) async {
    // TODO: 实现获取提示内容
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> batchRequest(
    String serverId,
    List<Map<String, dynamic>> requests,
  ) async {
    // TODO: 实现批量请求
    return [];
  }

  @override
  Future<void> handleConnectionError(String serverId, String error) async {
    _logger.severe('Connection error for $serverId: $error');
    await _updateConnectionStatus(serverId, false, error: error);
  }

  @override
  Future<void> dispose() async {
    _logger.info('Disposing MCP client service');
    
    // 关闭所有连接
    for (final serverId in _clients.keys.toList()) {
      await disconnect(serverId);
    }
    
    // 关闭状态流
    for (final controller in _statusControllers.values) {
      await controller.close();
    }
    _statusControllers.clear();
    
    // 清理资源
    _clients.clear();
    _pendingConnections.clear();
    _activeToolCalls.clear();
    
    for (final timer in _healthTimers.values) {
      timer.cancel();
    }
    _healthTimers.clear();
  }
}