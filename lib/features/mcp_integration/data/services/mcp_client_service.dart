import 'dart:async';
import 'package:logging/logging.dart' as logging;
import 'package:mcp_client/mcp_client.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../../domain/services/mcp_service_interface.dart';

/// MCP客户端服务实现
/// 负责与MCP服务器的实际通信和状态管理
class McpClientService implements McpServiceInterface {
  static final logging.Logger _logger = logging.Logger('McpClientService');
  
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
  

  /// 检查客户端是否健康
  Future<bool> _isClientHealthy(Client client) async {
    try {
      // 尝试获取服务器健康状态
      final health = await client.healthCheck();
      return health.isRunning;
    } catch (e) {
      return false;
    }
  }

  /// 检查是否需要OAuth认证
  bool _needsOAuth(McpServerConfig server) {
    return server.clientId?.isNotEmpty == true &&
           server.authorizationEndpoint?.isNotEmpty == true &&
           server.tokenEndpoint?.isNotEmpty == true;
  }
  

  @override
  Future<bool> connect(McpServerConfig server) async {
    final serverId = server.id;
    
    // 如果已经连接，直接返回
    if (_clients.containsKey(serverId)) {
      try {
        final isConnected = await _isClientHealthy(_clients[serverId]!);
        if (isConnected) return true;
      } catch (e) {
        // 健康检查失败，需要重连
        _logger.warning('Health check failed for $serverId: $e');
      }
      
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

    // 实现重试机制
    const maxRetries = 3;
    Exception? lastException;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      _logger.info('Connection attempt $attempt/$maxRetries for ${server.name}');
      
      try {
        // 开始新连接
        final connectionFuture = _createConnection(server);
        _pendingConnections[serverId] = connectionFuture;

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
        lastException = e is Exception ? e : Exception(e.toString());
        _pendingConnections.remove(serverId);
        _logger.warning('Connection attempt $attempt failed for ${server.name}: $e');
        
        // 如果不是最后一次重试，等待一段时间再重试
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }

    // 所有重试都失败了
    await _updateConnectionStatus(serverId, false, error: lastException?.toString());
    _logger.severe('All connection attempts failed for MCP server ${server.name}: $lastException');
    return false;
  }

  /// 创建新的客户端连接
  Future<Client> _createConnection(McpServerConfig server) async {
    _logger.info('Creating connection to ${server.name} (${server.type.name})');
    _logger.info('Server URL: ${server.baseUrl}');
    
    // 验证URL格式
    final uri = Uri.tryParse(server.baseUrl);
    if (uri == null || !uri.hasScheme) {
      throw Exception('Invalid server URL: ${server.baseUrl}');
    }
    
    // 检查SSE URL是否以/sse结尾
    if (server.type == McpTransportType.sse && !server.baseUrl.endsWith('/sse')) {
      _logger.warning('SSE URL should typically end with /sse: ${server.baseUrl}');
    }
    
    try {
      // 创建客户端配置
      final config = McpClient.simpleConfig(
        name: 'AnywhereChat',
        version: '1.0.0',
        enableDebugLogging: true, // 启用调试日志
      );
      
      // 根据服务器类型创建传输配置
      TransportConfig transportConfig;
      switch (server.type) {
        case McpTransportType.sse:
          _logger.info('Creating SSE transport config for URL: ${server.baseUrl}');
          transportConfig = TransportConfig.sse(
            serverUrl: server.baseUrl,
            headers: server.headers ?? {},
            oauthConfig: _needsOAuth(server) ? OAuthConfig(
              authorizationEndpoint: server.authorizationEndpoint!,
              tokenEndpoint: server.tokenEndpoint!,
              clientId: server.clientId!,
            ) : null,
            // 优化连接配置，禁用压缩以避免超时
            heartbeatInterval: const Duration(seconds: 60),
            maxMissedHeartbeats: 3,
            enableCompression: false, // 暂时禁用压缩，避免连接超时
            connectionTimeout: Duration(seconds: server.timeout ?? 30), // 连接超时设置
          );
          break;
        case McpTransportType.streamableHttp:
          _logger.info('Creating StreamableHTTP transport config for URL: ${server.baseUrl}');
          transportConfig = TransportConfig.streamableHttp(
            baseUrl: server.baseUrl,
            headers: server.headers ?? {},
            useHttp2: false, // 禁用HTTP2以提高兼容性
            maxConcurrentRequests: 5, // 减少并发请求数
            timeout: Duration(seconds: server.timeout ?? 30), // 减少超时时间
            oauthConfig: _needsOAuth(server) ? OAuthConfig(
              authorizationEndpoint: server.authorizationEndpoint!,
              tokenEndpoint: server.tokenEndpoint!,
              clientId: server.clientId!,
            ) : null,
            enableCompression: false,
            heartbeatInterval: const Duration(seconds: 60),
          );
          break;
      }
      
      // 创建并连接客户端，添加超时控制
      _logger.info('Attempting to create and connect MCP client...');
      final clientResult = await McpClient.createAndConnect(
        config: config,
        transportConfig: transportConfig,
      ).timeout(
        Duration(seconds: (server.timeout ?? 30) + 10),
        onTimeout: () {
          _logger.severe('MCP client connection timeout');
          throw Exception('Connection timeout after ${server.timeout ?? 30} seconds');
        },
      );
      
      final client = clientResult.fold(
        (c) {
          _logger.info('Successfully created MCP client');
          return c;
        },
        (error) {
          _logger.severe('Failed to create MCP client: $error');
          throw Exception('Failed to connect to MCP server: $error');
        },
      );
      
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
    _logger.info('Setting up event handlers for server: $serverId');
    
    try {
      // 连接事件处理
      client.onConnect.listen((serverInfo) {
        _logger.info('Connected to MCP server: ${serverInfo.name} v${serverInfo.version}');
        _logger.info('Protocol version: ${serverInfo.protocolVersion}');
        _updateConnectionStatus(serverId, true);
      });
      
      // 断开连接事件处理
      client.onDisconnect.listen((reason) {
        _logger.warning('MCP server disconnected: $reason');
        _handleDisconnection(serverId, reason.toString());
      });
      
      // 错误事件处理
      client.onError.listen((error) {
        _logger.severe('MCP client error: ${error.message}');
        _updateConnectionStatus(serverId, false, error: error.message);
      });
      
      // 日志事件处理（如果可用）
      try {
        client.onLogging((level, message, logger, data) {
          _logger.info('MCP Server log [$level]${logger != null ? " [$logger]" : ""}: $message');
          if (data != null) {
            _logger.fine('Additional data: $data');
          }
        });
      } catch (e) {
        _logger.fine('onLogging callback not available: $e');
      }
      
    } catch (e) {
      _logger.warning('Some event handlers may not be available: $e');
    }
  }
  
  /// 处理连接断开
  void _handleDisconnection(String serverId, String reason) {
    _updateConnectionStatus(serverId, false, error: reason);
    
    // 根据断开原因决定是否尝试重连
    if (reason.contains('transport') || reason.contains('error')) {
      _logger.info('Scheduling reconnection attempt for server: $serverId');
      Future.delayed(const Duration(seconds: 5), () {
        attemptReconnection(serverId);
      });
    }
  }

  // 连接断开由健康检查与异常处理触发清理。

  @override
  Future<void> disconnect(String serverId) async {
    final client = _clients[serverId];
    if (client != null) {
      try {
        client.disconnect();
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
  final health = await client.healthCheck();
  return health.isRunning;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> ping(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return false;
    
    try {
  final health = await client.healthCheck();
  await _updateConnectionStatus(serverId, health.isRunning);
  return health.isRunning;
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
        inputSchema: tool.inputSchema,
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
    bool isConnected = false;
    if (client != null) {
      try {
        final health = await client.healthCheck();
        isConnected = health.isRunning;
      } catch (_) {
        isConnected = false;
      }
    }
    
    return McpConnectionStatus(
      serverId: serverId,
      isConnected: isConnected,
      lastCheck: DateTime.now(),
      latency: isConnected && client != null ? await _measureLatency(client) : null,
    );
  }

  /// 测量连接延迟
  Future<int> _measureLatency(Client client) async {
    final stopwatch = Stopwatch()..start();
    try {
      await client.healthCheck();
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
    latency: isConnected && _clients[serverId] != null
      ? await _measureLatency(_clients[serverId]!)
      : null,
    );

    _statusControllers[serverId]?.add(status);
  }

  @override
  Future<bool> attemptReconnection(String serverId) async {
    _logger.info('Attempting reconnection for server: $serverId');
    
    try {
      // 从数据层获取服务器配置
      // 这里暂时返回false，等待Repository层完成后再连接实际数据源
      _logger.fine('Server configuration retrieval not yet implemented');
      
      // 基础重连逻辑
      final client = _clients[serverId];
      if (client != null) {
        // 暂时直接移除客户端，实际关闭操作留待后续完善
        _clients.remove(serverId);
        _logger.fine('Client removed from cache for server: $serverId');
      }
      
      return false; // 需要实际服务器配置才能重连
    } catch (e) {
      _logger.severe('Reconnection failed for server $serverId: $e');
      return false;
    }
  }

  // 其他接口方法的简化实现
  @override
  Future<Map<String, dynamic>?> getServerInfo(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return null;
    
    try {
      // 基础服务器信息实现
      return {
        'serverId': serverId,
        'connected': true,
        'protocolVersion': '2025-03-26',
        'capabilities': {
          'tools': true,
          'resources': true,
          'prompts': true,
        },
        'serverName': 'MCP Server',
        'serverVersion': '1.0.0',
      };
    } catch (e) {
      _logger.severe('Failed to get server info for $serverId: $e');
      return null;
    }
  }

  @override
  Future<List<String>> getSupportedProtocolVersions(String serverId) async {
    return ['2025-03-26']; // 支持的协议版本
  }

  @override
  Future<void> subscribeToResource(String serverId, String uri) async {
    final client = _clients[serverId];
    if (client == null) {
      throw Exception('Server $serverId not connected');
    }
    
    try {
      // 基础资源订阅实现
      _logger.info('Subscribing to resource: $uri on server: $serverId');
      
      // 暂时只记录订阅，实际的消息传输留待后续完善
      _logger.fine('Resource subscription placeholder implementation');
      
    } catch (e) {
      _logger.severe('Failed to subscribe to resource $uri: $e');
      rethrow;
    }
  }

  @override
  Future<void> unsubscribeFromResource(String serverId, String uri) async {
    final client = _clients[serverId];
    if (client == null) {
      throw Exception('Server $serverId not connected');
    }
    
    try {
      // 基础取消资源订阅实现
      _logger.info('Unsubscribing from resource: $uri on server: $serverId');
      
      // 暂时只记录取消订阅，实际的消息传输留待后续完善
      _logger.fine('Resource unsubscription placeholder implementation');
      
    } catch (e) {
      _logger.severe('Failed to unsubscribe from resource $uri: $e');
      rethrow;
    }
  }

  @override
  Future<List<McpPrompt>> listPrompts(String serverId) async {
    final client = _clients[serverId];
    if (client == null) return [];
    
    try {
      // 从实际MCP服务器获取提示数据
      _logger.info('Listing prompts for server: $serverId');
      
      final prompts = await client.listPrompts();
      return prompts.map((prompt) => McpPrompt(
        name: prompt.name,
        description: prompt.description ?? '',
        arguments: prompt.arguments.fold<Map<String, dynamic>>(
          {}, 
          (map, arg) => map..[arg.name] = arg.description ?? '',
        ),
        serverId: serverId,
      )).toList();
      
    } catch (e) {
      _logger.severe('Failed to list prompts for server $serverId: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getPrompt(
    String serverId, 
    String name, 
    Map<String, dynamic>? arguments,
  ) async {
    final client = _clients[serverId];
    if (client == null) {
      throw Exception('Server $serverId not connected');
    }
    
    try {
      // 从实际MCP服务器获取提示内容
      _logger.info('Getting prompt "$name" from server: $serverId');
      
      final result = await client.getPrompt(name, arguments);
      return {
        'name': name,
        'description': result.description ?? 'MCP Prompt',
        'arguments': arguments ?? {},
        'messages': result.messages,
      };
      
    } catch (e) {
      _logger.severe('Failed to get prompt "$name" from server $serverId: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> batchRequest(
    String serverId,
    List<Map<String, dynamic>> requests,
  ) async {
    final client = _clients[serverId];
    if (client == null) {
      throw Exception('Server $serverId not connected');
    }
    
    try {
      // 基础批量请求实现
      _logger.info('Executing batch request with ${requests.length} requests to server: $serverId');
      
      final results = <Map<String, dynamic>>[];
      
      // 暂时返回每个请求的空结果，实际处理需要通过MCP协议
      for (int i = 0; i < requests.length; i++) {
        results.add({
          'id': i,
          'result': {},
          'error': null,
        });
      }
      
      return results;
      
    } catch (e) {
      _logger.severe('Failed to execute batch request to server $serverId: $e');
      rethrow;
    }
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