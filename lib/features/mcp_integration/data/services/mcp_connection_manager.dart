import 'dart:async';
import 'package:logging/logging.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../../domain/services/mcp_service_interface.dart';

/// MCP连接管理器
/// 负责管理多个MCP服务器的连接状态、健康检查和自动重连
class McpConnectionManager {
  static final Logger _logger = Logger('McpConnectionManager');
  
  final McpServiceInterface _mcpService;
  
  /// 连接状态缓存 serverId -> ConnectionState
  final Map<String, ConnectionState> _connectionStates = {};
  
  /// 健康检查定时器 serverId -> Timer
  final Map<String, Timer> _healthCheckTimers = {};
  
  /// 重连定时器 serverId -> Timer
  final Map<String, Timer> _reconnectTimers = {};
  
  /// 连接状态变化流控制器
  final StreamController<ConnectionStateEvent> _stateController = 
      StreamController<ConnectionStateEvent>.broadcast();
  
  /// 配置参数
  final Duration healthCheckInterval;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;
  final Duration connectionTimeout;

  McpConnectionManager(
    this._mcpService, {
    this.healthCheckInterval = const Duration(seconds: 30),
    this.reconnectDelay = const Duration(seconds: 5),
    this.maxReconnectAttempts = 3,
    this.connectionTimeout = const Duration(seconds: 10),
  });

  /// 连接状态变化流
  Stream<ConnectionStateEvent> get onStateChanged => _stateController.stream;

  /// 注册服务器进行管理
  Future<void> registerServer(McpServerConfig server) async {
    final serverId = server.id;
    
    _logger.info('Registering server for management: ${server.name}');
    
    // 初始化连接状态
    _connectionStates[serverId] = ConnectionState(
      server: server,
      status: ConnectionStatus.disconnected,
      lastCheck: DateTime.now(),
    );
    
    // 通知状态变化
    _notifyStateChange(serverId, ConnectionStatus.disconnected);
  }

  /// 取消服务器管理
  Future<void> unregisterServer(String serverId) async {
    _logger.info('Unregistering server: $serverId');
    
    // 停止健康检查
    await stopHealthCheck(serverId);
    
    // 停止重连
    _stopReconnection(serverId);
    
    // 断开连接
    await _mcpService.disconnect(serverId);
    
    // 清理状态
    _connectionStates.remove(serverId);
  }

  /// 连接到服务器
  Future<bool> connectToServer(String serverId) async {
    final state = _connectionStates[serverId];
    if (state == null) {
      throw Exception('Server not registered: $serverId');
    }

    if (state.status == ConnectionStatus.connecting) {
      _logger.info('Server already connecting: $serverId');
      return false;
    }

    _logger.info('Connecting to server: ${state.server.name}');
    
    // 更新状态为连接中
    await _updateConnectionState(serverId, ConnectionStatus.connecting);

    try {
      // 尝试连接
      final connected = await _mcpService.connect(state.server)
          .timeout(connectionTimeout);
      
      if (connected) {
        await _updateConnectionState(serverId, ConnectionStatus.connected);
        
        // 开始健康检查
        await startHealthCheck(serverId);
        
        // 重置重连计数
        state.reconnectAttempts = 0;
        
        _logger.info('Successfully connected to: ${state.server.name}');
        return true;
      } else {
        await _updateConnectionState(
          serverId, 
          ConnectionStatus.failed,
          error: 'Connection failed',
        );
        
        // 安排重连
        _scheduleReconnection(serverId);
        return false;
      }
    } catch (e) {
      _logger.severe('Connection error for ${state.server.name}: $e');
      
      await _updateConnectionState(
        serverId,
        ConnectionStatus.failed,
        error: e.toString(),
      );
      
      // 安排重连
      _scheduleReconnection(serverId);
      return false;
    }
  }

  /// 断开服务器连接
  Future<void> disconnectFromServer(String serverId) async {
    final state = _connectionStates[serverId];
    if (state == null) return;

    _logger.info('Disconnecting from server: ${state.server.name}');
    
    // 停止健康检查和重连
    await stopHealthCheck(serverId);
    _stopReconnection(serverId);
    
    try {
      await _mcpService.disconnect(serverId);
      await _updateConnectionState(serverId, ConnectionStatus.disconnected);
    } catch (e) {
      _logger.warning('Error during disconnection: $e');
      await _updateConnectionState(
        serverId,
        ConnectionStatus.failed,
        error: e.toString(),
      );
    }
  }

  /// 开始健康检查
  Future<void> startHealthCheck(String serverId) async {
    final state = _connectionStates[serverId];
    if (state == null) return;

    // 停止现有的健康检查
    await stopHealthCheck(serverId);

    _logger.info('Starting health check for: ${state.server.name}');
    
    _healthCheckTimers[serverId] = Timer.periodic(
      healthCheckInterval,
      (_) => _performHealthCheck(serverId),
    );
    
    // 立即执行一次健康检查
    await _performHealthCheck(serverId);
  }

  /// 停止健康检查
  Future<void> stopHealthCheck(String serverId) async {
    final timer = _healthCheckTimers.remove(serverId);
    timer?.cancel();
    
    _logger.info('Stopped health check for: $serverId');
  }

  /// 执行健康检查
  Future<void> _performHealthCheck(String serverId) async {
    final state = _connectionStates[serverId];
    if (state == null || state.status != ConnectionStatus.connected) {
      return;
    }

    try {
      final isHealthy = await _mcpService.ping(serverId);
      
      if (isHealthy) {
        // 连接正常，更新最后检查时间
        state.lastCheck = DateTime.now();
        state.error = null;
        
        // 获取详细状态
        final connectionStatus = await _mcpService.getConnectionStatus(serverId);
        if (connectionStatus != null) {
          state.latency = connectionStatus.latency;
        }
      } else {
        _logger.warning('Health check failed for: ${state.server.name}');
        
        await _updateConnectionState(
          serverId,
          ConnectionStatus.unhealthy,
          error: 'Health check failed',
        );
        
        // 安排重连
        _scheduleReconnection(serverId);
      }
    } catch (e) {
      _logger.warning('Health check error for ${state.server.name}: $e');
      
      await _updateConnectionState(
        serverId,
        ConnectionStatus.failed,
        error: e.toString(),
      );
      
      // 安排重连
      _scheduleReconnection(serverId);
    }
  }

  /// 安排重连
  void _scheduleReconnection(String serverId) {
    final state = _connectionStates[serverId];
    if (state == null || state.server.disabled == true) return;

    // 检查重连次数限制
    if (state.reconnectAttempts >= maxReconnectAttempts) {
      _logger.warning('Max reconnect attempts reached for: ${state.server.name}');
      _updateConnectionState(
        serverId,
        ConnectionStatus.failed,
        error: 'Max reconnect attempts exceeded',
      );
      return;
    }

    // 停止现有的重连定时器
    _stopReconnection(serverId);

    // 计算重连延迟（指数退避）
    final delay = Duration(
      seconds: reconnectDelay.inSeconds * (1 << state.reconnectAttempts),
    );

    _logger.info('Scheduling reconnection for ${state.server.name} in ${delay.inSeconds}s (attempt ${state.reconnectAttempts + 1})');

    _reconnectTimers[serverId] = Timer(delay, () {
      _attemptReconnection(serverId);
    });
  }

  /// 尝试重连
  Future<void> _attemptReconnection(String serverId) async {
    final state = _connectionStates[serverId];
    if (state == null || state.server.disabled == true) return;

    state.reconnectAttempts++;
    
    _logger.info('Attempting reconnection for ${state.server.name} (attempt ${state.reconnectAttempts})');

    final success = await connectToServer(serverId);
    
    if (!success) {
      // 重连失败，继续安排下次重连
      _scheduleReconnection(serverId);
    }
  }

  /// 停止重连
  void _stopReconnection(String serverId) {
    final timer = _reconnectTimers.remove(serverId);
    timer?.cancel();
  }

  /// 更新连接状态
  Future<void> _updateConnectionState(
    String serverId,
    ConnectionStatus status, {
    String? error,
  }) async {
    final state = _connectionStates[serverId];
    if (state == null) return;

    state.status = status;
    state.lastCheck = DateTime.now();
    state.error = error;

    _notifyStateChange(serverId, status, error: error);
  }

  /// 通知状态变化
  void _notifyStateChange(
    String serverId,
    ConnectionStatus status, {
    String? error,
  }) {
    final state = _connectionStates[serverId];
    if (state == null) return;

    final event = ConnectionStateEvent(
      serverId: serverId,
      server: state.server,
      status: status,
      error: error,
      timestamp: DateTime.now(),
    );

    _stateController.add(event);
  }

  /// 获取连接状态
  ConnectionState? getConnectionState(String serverId) {
    return _connectionStates[serverId];
  }

  /// 获取所有连接状态
  Map<String, ConnectionState> getAllConnectionStates() {
    return Map.unmodifiable(_connectionStates);
  }

  /// 获取连接统计信息
  ConnectionStatistics getStatistics() {
    final states = _connectionStates.values;
    
    return ConnectionStatistics(
      total: states.length,
      connected: states.where((s) => s.status == ConnectionStatus.connected).length,
      connecting: states.where((s) => s.status == ConnectionStatus.connecting).length,
      failed: states.where((s) => s.status == ConnectionStatus.failed).length,
      unhealthy: states.where((s) => s.status == ConnectionStatus.unhealthy).length,
      disabled: states.where((s) => s.server.disabled == true).length,
    );
  }

  /// 清理资源
  Future<void> dispose() async {
    _logger.info('Disposing connection manager');
    
    // 停止所有定时器
    for (final timer in _healthCheckTimers.values) {
      timer.cancel();
    }
    _healthCheckTimers.clear();
    
    for (final timer in _reconnectTimers.values) {
      timer.cancel();
    }
    _reconnectTimers.clear();
    
    // 关闭状态流
    await _stateController.close();
    
    // 清理状态
    _connectionStates.clear();
  }
}

/// 连接状态
class ConnectionState {
  final McpServerConfig server;
  ConnectionStatus status;
  DateTime lastCheck;
  String? error;
  int? latency;
  int reconnectAttempts;

  ConnectionState({
    required this.server,
    required this.status,
    required this.lastCheck,
    this.error,
    this.latency,
    this.reconnectAttempts = 0,
  });
}

/// 连接状态枚举
enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  unhealthy,
  failed,
}

/// 连接状态事件
class ConnectionStateEvent {
  final String serverId;
  final McpServerConfig server;
  final ConnectionStatus status;
  final String? error;
  final DateTime timestamp;

  const ConnectionStateEvent({
    required this.serverId,
    required this.server,
    required this.status,
    this.error,
    required this.timestamp,
  });
}

/// 连接统计信息
class ConnectionStatistics {
  final int total;
  final int connected;
  final int connecting;
  final int failed;
  final int unhealthy;
  final int disabled;

  const ConnectionStatistics({
    required this.total,
    required this.connected,
    required this.connecting,
    required this.failed,
    required this.unhealthy,
    required this.disabled,
  });

  int get healthy => connected;
  int get problematic => failed + unhealthy;
  double get healthPercentage => total > 0 ? (healthy / total) : 0.0;
}