// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$McpServerConfigImpl _$$McpServerConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$McpServerConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      baseUrl: json['baseUrl'] as String,
      type: $enumDecode(_$McpTransportTypeEnumMap, json['type']),
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      timeout: (json['timeout'] as num?)?.toInt(),
      longRunning: json['longRunning'] as bool?,
      disabled: json['disabled'] as bool?,
      error: json['error'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      authorizationEndpoint: json['authorizationEndpoint'] as String?,
      tokenEndpoint: json['tokenEndpoint'] as String?,
      isConnected: json['isConnected'] as bool? ?? false,
      lastConnected: json['lastConnected'] == null
          ? null
          : DateTime.parse(json['lastConnected'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$McpServerConfigImplToJson(
        _$McpServerConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'baseUrl': instance.baseUrl,
      'type': _$McpTransportTypeEnumMap[instance.type]!,
      'headers': instance.headers,
      'timeout': instance.timeout,
      'longRunning': instance.longRunning,
      'disabled': instance.disabled,
      'error': instance.error,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'authorizationEndpoint': instance.authorizationEndpoint,
      'tokenEndpoint': instance.tokenEndpoint,
      'isConnected': instance.isConnected,
      'lastConnected': instance.lastConnected?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$McpTransportTypeEnumMap = {
  McpTransportType.sse: 'sse',
  McpTransportType.streamableHttp: 'streamableHttp',
};

_$McpConnectionStatusImpl _$$McpConnectionStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$McpConnectionStatusImpl(
      serverId: json['serverId'] as String,
      isConnected: json['isConnected'] as bool,
      lastCheck: DateTime.parse(json['lastCheck'] as String),
      error: json['error'] as String?,
      latency: (json['latency'] as num?)?.toInt(),
      serverName: json['serverName'] as String?,
      serverVersion: json['serverVersion'] as String?,
      protocolVersion: json['protocolVersion'] as String?,
      toolsCount: (json['toolsCount'] as num?)?.toInt(),
      resourcesCount: (json['resourcesCount'] as num?)?.toInt(),
      promptsCount: (json['promptsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$McpConnectionStatusImplToJson(
        _$McpConnectionStatusImpl instance) =>
    <String, dynamic>{
      'serverId': instance.serverId,
      'isConnected': instance.isConnected,
      'lastCheck': instance.lastCheck.toIso8601String(),
      'error': instance.error,
      'latency': instance.latency,
      'serverName': instance.serverName,
      'serverVersion': instance.serverVersion,
      'protocolVersion': instance.protocolVersion,
      'toolsCount': instance.toolsCount,
      'resourcesCount': instance.resourcesCount,
      'promptsCount': instance.promptsCount,
    };

_$McpToolImpl _$$McpToolImplFromJson(Map<String, dynamic> json) =>
    _$McpToolImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      inputSchema: json['inputSchema'] as Map<String, dynamic>,
      serverId: json['serverId'] as String?,
    );

Map<String, dynamic> _$$McpToolImplToJson(_$McpToolImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'inputSchema': instance.inputSchema,
      'serverId': instance.serverId,
    };

_$McpResourceImpl _$$McpResourceImplFromJson(Map<String, dynamic> json) =>
    _$McpResourceImpl(
      uri: json['uri'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      mimeType: json['mimeType'] as String?,
      serverId: json['serverId'] as String?,
    );

Map<String, dynamic> _$$McpResourceImplToJson(_$McpResourceImpl instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'name': instance.name,
      'description': instance.description,
      'mimeType': instance.mimeType,
      'serverId': instance.serverId,
    };

_$McpCallHistoryImpl _$$McpCallHistoryImplFromJson(Map<String, dynamic> json) =>
    _$McpCallHistoryImpl(
      id: json['id'] as String,
      serverId: json['serverId'] as String,
      toolName: json['toolName'] as String,
      arguments: json['arguments'] as Map<String, dynamic>,
      calledAt: DateTime.parse(json['calledAt'] as String),
      result: json['result'] as String?,
      error: json['error'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$McpCallHistoryImplToJson(
        _$McpCallHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'toolName': instance.toolName,
      'arguments': instance.arguments,
      'calledAt': instance.calledAt.toIso8601String(),
      'result': instance.result,
      'error': instance.error,
      'duration': instance.duration,
    };

_$McpPromptImpl _$$McpPromptImplFromJson(Map<String, dynamic> json) =>
    _$McpPromptImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      arguments: json['arguments'] as Map<String, dynamic>?,
      serverId: json['serverId'] as String?,
    );

Map<String, dynamic> _$$McpPromptImplToJson(_$McpPromptImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'arguments': instance.arguments,
      'serverId': instance.serverId,
    };
