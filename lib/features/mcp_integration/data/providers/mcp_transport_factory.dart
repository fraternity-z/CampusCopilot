import 'package:mcp_client/mcp_client.dart';
import '../../domain/entities/mcp_server_config.dart';
import 'mcp_oauth_provider.dart';

/// MCP传输层工厂
/// 负责根据服务器配置创建适当的传输层实例
class McpTransportFactory {
  static final Logger _logger = Logger('McpTransportFactory');
  final McpOAuthProvider _oauthProvider = McpOAuthProvider();

  /// 根据服务器配置创建传输层
  Future<Transport> createTransport(McpServerConfig server) async {
    _logger.info('Creating transport for ${server.name} (${server.type.name})');

    switch (server.type) {
      case McpTransportType.sse:
        return _createSSETransport(server);
      case McpTransportType.streamableHttp:
        return _createStreamableHTTPTransport(server);
    }
  }

  /// 创建SSE传输层
  Future<Transport> _createSSETransport(McpServerConfig server) async {
    _logger.info('Creating SSE transport for ${server.baseUrl}');

    try {
      final options = SSEClientTransportOptions(
        // 基本配置
        eventSourceInit: EventSourceInit(
          headers: await _buildHeaders(server),
        ),
        // OAuth认证
        authProvider: _needsOAuth(server) ? _oauthProvider : null,
        // 超时配置
        timeout: Duration(seconds: server.timeout ?? 60),
      );

      final transport = SSEClientTransport(
        Uri.parse(server.baseUrl),
        options,
      );

      _logger.info('SSE transport created successfully');
      return transport;
    } catch (e) {
      _logger.severe('Failed to create SSE transport: $e');
      rethrow;
    }
  }

  /// 创建StreamableHTTP传输层
  Future<Transport> _createStreamableHTTPTransport(McpServerConfig server) async {
    _logger.info('Creating StreamableHTTP transport for ${server.baseUrl}');

    try {
      final options = StreamableHTTPClientTransportOptions(
        // 基本配置
        headers: await _buildHeaders(server),
        // OAuth认证
        authProvider: _needsOAuth(server) ? _oauthProvider : null,
        // 超时配置
        timeout: Duration(seconds: server.timeout ?? 60),
        // HTTP/2支持
        useHttp2: true,
        // 并发请求限制
        maxConcurrentRequests: 10,
      );

      final transport = StreamableHTTPClientTransport(
        Uri.parse(server.baseUrl),
        options,
      );

      _logger.info('StreamableHTTP transport created successfully');
      return transport;
    } catch (e) {
      _logger.severe('Failed to create StreamableHTTP transport: $e');
      rethrow;
    }
  }

  /// 构建HTTP头
  Future<Map<String, String>> _buildHeaders(McpServerConfig server) async {
    final headers = <String, String>{
      'User-Agent': 'AnywhereChat/1.0.0',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // 添加自定义Headers
    if (server.headers != null) {
      headers.addAll(server.headers!);
    }

    // 添加OAuth认证头
    if (_needsOAuth(server)) {
      try {
        final token = await _oauthProvider.getAccessToken(server);
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        _logger.warning('Failed to get OAuth token: $e');
      }
    }

    return headers;
  }

  /// 检查是否需要OAuth认证
  bool _needsOAuth(McpServerConfig server) {
    return server.clientId?.isNotEmpty == true &&
           server.authorizationEndpoint?.isNotEmpty == true &&
           server.tokenEndpoint?.isNotEmpty == true;
  }

  /// 验证服务器配置
  void _validateServerConfig(McpServerConfig server) {
    if (server.baseUrl.isEmpty) {
      throw ArgumentError('Base URL cannot be empty');
    }

    final uri = Uri.tryParse(server.baseUrl);
    if (uri == null || !uri.hasScheme) {
      throw ArgumentError('Invalid base URL: ${server.baseUrl}');
    }

    if (!['http', 'https'].contains(uri.scheme)) {
      throw ArgumentError('Unsupported URL scheme: ${uri.scheme}');
    }

    // 验证超时配置
    if (server.timeout != null && server.timeout! <= 0) {
      throw ArgumentError('Timeout must be positive: ${server.timeout}');
    }

    // 验证OAuth配置
    if (_needsOAuth(server)) {
      if (server.clientSecret?.isEmpty == true) {
        throw ArgumentError('Client secret is required for OAuth');
      }
    }
  }

  /// 测试连接
  Future<bool> testConnection(McpServerConfig server) async {
    _logger.info('Testing connection to ${server.name}');
    
    try {
      _validateServerConfig(server);
      
      final transport = await createTransport(server);
      
      // 创建临时客户端进行测试
      final client = McpClient(ClientInfo(
        name: 'AnywhereChat-Test',
        version: '1.0.0',
      ));

      await client.connect(transport);
      final result = await client.ping();
      await client.close();

      _logger.info('Connection test ${result ? 'successful' : 'failed'} for ${server.name}');
      return result;
    } catch (e) {
      _logger.severe('Connection test failed for ${server.name}: $e');
      return false;
    }
  }
}

/// SSE传输选项
class SSEClientTransportOptions {
  final EventSourceInit eventSourceInit;
  final AuthProvider? authProvider;
  final Duration? timeout;

  const SSEClientTransportOptions({
    required this.eventSourceInit,
    this.authProvider,
    this.timeout,
  });
}

/// StreamableHTTP传输选项
class StreamableHTTPClientTransportOptions {
  final Map<String, String>? headers;
  final AuthProvider? authProvider;
  final Duration? timeout;
  final bool useHttp2;
  final int maxConcurrentRequests;

  const StreamableHTTPClientTransportOptions({
    this.headers,
    this.authProvider,
    this.timeout,
    this.useHttp2 = false,
    this.maxConcurrentRequests = 5,
  });
}

/// EventSource初始化配置
class EventSourceInit {
  final Map<String, String>? headers;
  final bool withCredentials;

  const EventSourceInit({
    this.headers,
    this.withCredentials = false,
  });
}

/// 认证提供者接口
abstract class AuthProvider {
  Future<String?> getAccessToken();
  Future<void> refreshToken();
}

/// SSE客户端传输层
class SSEClientTransport implements Transport {
  final Uri uri;
  final SSEClientTransportOptions options;

  SSEClientTransport(this.uri, this.options);

  @override
  Future<void> connect() async {
    // TODO: 实现SSE连接逻辑
    throw UnimplementedError('SSE transport not fully implemented');
  }

  @override
  Future<void> close() async {
    // TODO: 实现SSE关闭逻辑
  }

  @override
  Stream<Map<String, dynamic>> get messages => Stream.empty();

  @override
  Future<void> send(Map<String, dynamic> message) async {
    // TODO: 实现SSE消息发送逻辑
  }
}

/// StreamableHTTP客户端传输层
class StreamableHTTPClientTransport implements Transport {
  final Uri uri;
  final StreamableHTTPClientTransportOptions options;

  StreamableHTTPClientTransport(this.uri, this.options);

  @override
  Future<void> connect() async {
    // TODO: 实现HTTP连接逻辑
    throw UnimplementedError('StreamableHTTP transport not fully implemented');
  }

  @override
  Future<void> close() async {
    // TODO: 实现HTTP关闭逻辑
  }

  @override
  Stream<Map<String, dynamic>> get messages => Stream.empty();

  @override
  Future<void> send(Map<String, dynamic> message) async {
    // TODO: 实现HTTP消息发送逻辑
  }
}

/// 传输层接口
abstract class Transport {
  Future<void> connect();
  Future<void> close();
  Stream<Map<String, dynamic>> get messages;
  Future<void> send(Map<String, dynamic> message);
}