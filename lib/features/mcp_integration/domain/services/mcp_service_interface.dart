import '../entities/mcp_server_config.dart';

/// MCP客户端服务接口
/// 定义所有MCP相关操作的抽象接口
abstract class McpServiceInterface {
  /// 连接管理
  Future<bool> connect(McpServerConfig server);
  Future<void> disconnect(String serverId);
  Future<bool> isConnected(String serverId);
  Future<McpConnectionStatus?> getConnectionStatus(String serverId);
  Future<bool> ping(String serverId);
  
  /// 服务器信息
  Future<Map<String, dynamic>?> getServerInfo(String serverId);
  Future<List<String>> getSupportedProtocolVersions(String serverId);
  
  /// 工具管理
  Future<List<McpTool>> listTools(String serverId);
  Future<Map<String, dynamic>> callTool(
    String serverId, 
    String toolName, 
    Map<String, dynamic> arguments,
  );
  Future<void> cancelToolCall(String callId);
  
  /// 资源管理
  Future<List<McpResource>> listResources(String serverId);
  Future<Map<String, dynamic>> getResource(String serverId, String uri);
  Future<void> subscribeToResource(String serverId, String uri);
  Future<void> unsubscribeFromResource(String serverId, String uri);
  
  /// 提示管理
  Future<List<McpPrompt>> listPrompts(String serverId);
  Future<Map<String, dynamic>> getPrompt(
    String serverId, 
    String name, 
    Map<String, dynamic>? arguments,
  );
  
  /// 健康检查和监控
  Future<void> startHealthMonitoring(String serverId);
  Future<void> stopHealthMonitoring(String serverId);
  Stream<McpConnectionStatus> watchConnectionStatus(String serverId);
  
  /// 批量操作
  Future<List<Map<String, dynamic>>> batchRequest(
    String serverId,
    List<Map<String, dynamic>> requests,
  );
  
  /// 错误处理
  Future<void> handleConnectionError(String serverId, String error);
  Future<bool> attemptReconnection(String serverId);
  
  /// 清理资源
  Future<void> dispose();
}

