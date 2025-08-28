import 'package:freezed_annotation/freezed_annotation.dart';

part 'mcp_server_config.freezed.dart';
part 'mcp_server_config.g.dart';

/// MCP连接类型枚举
enum McpTransportType {
  @JsonValue('sse')
  sse,
  @JsonValue('streamableHttp') 
  streamableHttp,
}

/// MCP服务器配置实体
@freezed
class McpServerConfig with _$McpServerConfig {
  const factory McpServerConfig({
    required String id,
    required String name,
    required String baseUrl,
    required McpTransportType type,
    Map<String, String>? headers,
    int? timeout,
    bool? longRunning,
    bool? disabled,
    String? error,
    // OAuth配置
    String? clientId,
    String? clientSecret,
    String? authorizationEndpoint,
    String? tokenEndpoint,
    // 连接状态
    @Default(false) bool isConnected,
    DateTime? lastConnected,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _McpServerConfig;

  factory McpServerConfig.fromJson(Map<String, dynamic> json) =>
      _$McpServerConfigFromJson(json);
}

/// MCP连接状态
@freezed 
class McpConnectionStatus with _$McpConnectionStatus {
  const factory McpConnectionStatus({
    required String serverId,
    required bool isConnected,
    required DateTime lastCheck,
    String? error,
    int? latency,
    // 服务器信息
    String? serverName,
    String? serverVersion, 
    String? protocolVersion,
    // 能力信息
    int? toolsCount,
    int? resourcesCount,
    int? promptsCount,
  }) = _McpConnectionStatus;

  factory McpConnectionStatus.fromJson(Map<String, dynamic> json) =>
      _$McpConnectionStatusFromJson(json);
}

/// MCP工具定义
@freezed
class McpTool with _$McpTool {
  const factory McpTool({
    required String name,
    required String description,
    required Map<String, dynamic> inputSchema,
    String? serverId,
  }) = _McpTool;

  factory McpTool.fromJson(Map<String, dynamic> json) =>
      _$McpToolFromJson(json);
}

/// MCP资源定义
@freezed
class McpResource with _$McpResource {
  const factory McpResource({
    required String uri,
    required String name,
    String? description,
    String? mimeType,
    String? serverId,
  }) = _McpResource;

  factory McpResource.fromJson(Map<String, dynamic> json) =>
      _$McpResourceFromJson(json);
}

/// MCP工具调用历史
@freezed
class McpCallHistory with _$McpCallHistory {
  const factory McpCallHistory({
    required String id,
    required String serverId,
    required String toolName,
    required Map<String, dynamic> arguments,
    required DateTime calledAt,
    String? result,
    String? error,
    int? duration,
  }) = _McpCallHistory;

  factory McpCallHistory.fromJson(Map<String, dynamic> json) =>
      _$McpCallHistoryFromJson(json);
}

/// MCP提示定义
@freezed
class McpPrompt with _$McpPrompt {
  const factory McpPrompt({
    required String name,
    required String description,
    Map<String, dynamic>? arguments,
    String? serverId,
  }) = _McpPrompt;

  factory McpPrompt.fromJson(Map<String, dynamic> json) =>
      _$McpPromptFromJson(json);
}