import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import '../../domain/entities/mcp_server_config.dart';

/// MCP OAuth认证提供者
/// 实现OAuth 2.1流程，支持授权码流和PKCE
class McpOAuthProvider {
  static final Logger _logger = Logger('McpOAuthProvider');
  
  /// 存储服务器的访问令牌 serverId -> TokenInfo
  final Map<String, TokenInfo> _tokens = {};
  
  /// 存储正在进行的认证流程 serverId -> Future<TokenInfo>
  final Map<String, Future<TokenInfo>> _pendingAuth = {};
  
  /// OAuth配置
  static const int callbackPort = 3000;
  static const String callbackPath = '/oauth/callback';
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);

  /// 获取指定服务器的访问令牌
  Future<String?> getAccessToken(String serverId) async {
    final tokenInfo = _tokens[serverId];
    
    // 如果没有token，返回null
    if (tokenInfo == null) {
      return null;
    }
    
    // 检查token是否过期
    if (_isTokenExpired(tokenInfo)) {
      _tokens.remove(serverId);
      return null;
    }
    
    return tokenInfo.accessToken;
  }

  /// 为指定服务器启动完整认证流程
  Future<String?> authenticateServer(McpServerConfig server) async {
    final serverId = server.id;
    final tokenInfo = _tokens[serverId];
    
    // 如果没有token，启动认证流程
    if (tokenInfo == null) {
      return await _authenticateServer(server);
    }
    
    // 检查token是否过期
    if (_isTokenExpired(tokenInfo)) {
      try {
        // 尝试刷新token
        if (tokenInfo.refreshToken != null) {
          await _refreshToken(server, tokenInfo);
          return _tokens[serverId]?.accessToken;
        } else {
          // 没有refresh token，重新认证
          return await _authenticateServer(server);
        }
      } catch (e) {
        _logger.warning('Failed to refresh token, re-authenticating: $e');
        return await _authenticateServer(server);
      }
    }
    
    return tokenInfo.accessToken;
  }

  /// 为指定服务器启动完整认证流程（内部方法）
  Future<String?> _authenticateServer(McpServerConfig server) async {
    final serverId = server.id;
    
    // 如果已经在认证中，等待完成
    if (_pendingAuth.containsKey(serverId)) {
      try {
        final tokenInfo = await _pendingAuth[serverId]!;
        return tokenInfo.accessToken;
      } catch (e) {
        _pendingAuth.remove(serverId);
        return null;
      }
    }
    
    // 开始认证流程
    final authFuture = _performAuthentication(server);
    _pendingAuth[serverId] = authFuture;
    
    try {
      final tokenInfo = await authFuture;
      _tokens[serverId] = tokenInfo;
      _pendingAuth.remove(serverId);
      
      _logger.info('Authentication successful for server: ${server.name}');
      return tokenInfo.accessToken;
    } catch (e) {
      _pendingAuth.remove(serverId);
      _logger.severe('Authentication failed for server ${server.name}: $e');
      return null;
    }
  }

  /// 执行OAuth认证流程
  Future<TokenInfo> _performAuthentication(McpServerConfig server) async {
    _logger.info('Starting OAuth authentication for ${server.name}');
    
    // 验证OAuth配置
    if (server.clientId == null || server.clientId!.isEmpty) {
      throw Exception('Client ID is required for OAuth authentication');
    }
    
    if (server.authorizationEndpoint == null || server.authorizationEndpoint!.isEmpty) {
      throw Exception('Authorization endpoint is required');
    }
    
    if (server.tokenEndpoint == null || server.tokenEndpoint!.isEmpty) {
      throw Exception('Token endpoint is required');
    }

    // 生成PKCE参数
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);
    final state = _generateState();
    
    // 构建授权URL
    final authUrl = _buildAuthorizationUrl(server, codeChallenge, state);
    
    _logger.info('Authorization URL: $authUrl');
    
    // 启动本地HTTP服务器接收回调
    final authCode = await _startCallbackServer(state);
    
    // 交换授权码获取token
    final tokenInfo = await _exchangeCodeForToken(
      server,
      authCode,
      codeVerifier,
    );
    
    return tokenInfo;
  }

  /// 构建授权URL
  String _buildAuthorizationUrl(McpServerConfig server, String codeChallenge, String state) {
    final params = <String, String>{
      'response_type': 'code',
      'client_id': server.clientId!,
      'redirect_uri': 'http://localhost:$callbackPort$callbackPath',
      'scope': 'read write', // 默认权限范围
      'state': state,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };
    
    final uri = Uri.parse(server.authorizationEndpoint!);
    final authUri = uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...params,
    });
    
    return authUri.toString();
  }

  /// 启动回调服务器
  Future<String> _startCallbackServer(String expectedState) async {
    final completer = Completer<String>();
    late HttpServer server;
    
    try {
      server = await HttpServer.bind('localhost', callbackPort);
      _logger.info('Callback server started on port $callbackPort');
      
      // 设置超时
      Timer(const Duration(minutes: 10), () {
        if (!completer.isCompleted) {
          completer.completeError('Authentication timeout');
          server.close();
        }
      });
      
      server.listen((request) async {
        if (request.uri.path == callbackPath) {
          final params = request.uri.queryParameters;
          final error = params['error'];
          final code = params['code'];
          final state = params['state'];
          
          // 发送响应页面
          final response = request.response;
          response.headers.contentType = ContentType.html;
          
          if (error != null) {
            response.write(_getErrorPage(error));
            await response.close();
            
            if (!completer.isCompleted) {
              completer.completeError('Authorization error: $error');
            }
          } else if (code != null && state == expectedState) {
            response.write(_getSuccessPage());
            await response.close();
            
            if (!completer.isCompleted) {
              completer.complete(code);
            }
          } else {
            response.statusCode = 400;
            response.write(_getBadRequestPage());
            await response.close();
            
            if (!completer.isCompleted) {
              completer.completeError('Invalid authorization response');
            }
          }
          
          server.close();
        } else {
          request.response.statusCode = 404;
          await request.response.close();
        }
      });
      
    } catch (e) {
      _logger.severe('Failed to start callback server: $e');
      rethrow;
    }
    
    return completer.future;
  }

  /// 交换授权码获取token
  Future<TokenInfo> _exchangeCodeForToken(
    McpServerConfig server,
    String authCode,
    String codeVerifier,
  ) async {
    _logger.info('Exchanging authorization code for token');
    
    final body = {
      'grant_type': 'authorization_code',
      'client_id': server.clientId!,
      'code': authCode,
      'redirect_uri': 'http://localhost:$callbackPort$callbackPath',
      'code_verifier': codeVerifier,
    };
    
    // 如果有client_secret，添加到请求中
    if (server.clientSecret != null && server.clientSecret!.isNotEmpty) {
      body['client_secret'] = server.clientSecret!;
    }
    
    final response = await http.post(
      Uri.parse(server.tokenEndpoint!),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body,
    );
    
    if (response.statusCode == 200) {
      final tokenData = jsonDecode(response.body) as Map<String, dynamic>;
      return TokenInfo.fromJson(tokenData);
    } else {
      throw Exception('Token exchange failed: ${response.statusCode} - ${response.body}');
    }
  }


  /// 刷新指定服务器的token
  Future<void> _refreshToken(McpServerConfig server, TokenInfo tokenInfo) async {
    if (tokenInfo.refreshToken == null) {
      throw Exception('No refresh token available');
    }
    
    _logger.info('Refreshing token for server: ${server.name}');
    
    final body = {
      'grant_type': 'refresh_token',
      'refresh_token': tokenInfo.refreshToken!,
      'client_id': server.clientId!,
    };
    
    if (server.clientSecret != null && server.clientSecret!.isNotEmpty) {
      body['client_secret'] = server.clientSecret!;
    }
    
    final response = await http.post(
      Uri.parse(server.tokenEndpoint!),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body,
    );
    
    if (response.statusCode == 200) {
      final tokenData = jsonDecode(response.body) as Map<String, dynamic>;
      final newTokenInfo = TokenInfo.fromJson(tokenData);
      
      // 如果没有新的refresh token，保留旧的
      if (newTokenInfo.refreshToken == null) {
        newTokenInfo.refreshToken = tokenInfo.refreshToken;
      }
      
      _tokens[server.id] = newTokenInfo;
      _logger.info('Token refreshed successfully for server: ${server.name}');
    } else {
      throw Exception('Token refresh failed: ${response.statusCode} - ${response.body}');
    }
  }

  /// 检查token是否过期
  bool _isTokenExpired(TokenInfo tokenInfo) {
    if (tokenInfo.expiresAt == null) return false;
    
    final now = DateTime.now();
    final expiryWithBuffer = tokenInfo.expiresAt!.subtract(tokenRefreshBuffer);
    
    return now.isAfter(expiryWithBuffer);
  }

  /// 生成PKCE code verifier
  String _generateCodeVerifier() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(128, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// 生成PKCE code challenge
  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  /// 生成状态参数
  String _generateState() {
    final random = Random.secure();
    final bytes = List.generate(32, (index) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// 获取成功页面
  String _getSuccessPage() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>认证成功</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .success { color: #28a745; font-size: 24px; margin-bottom: 20px; }
        .message { color: #333; font-size: 16px; }
    </style>
</head>
<body>
    <div class="success">✓ 认证成功</div>
    <div class="message">您可以关闭此页面，返回AnywhereChat应用。</div>
    <script>
        setTimeout(function() { window.close(); }, 3000);
    </script>
</body>
</html>
    ''';
  }

  /// 获取错误页面
  String _getErrorPage(String error) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>认证失败</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .error { color: #dc3545; font-size: 24px; margin-bottom: 20px; }
        .message { color: #333; font-size: 16px; }
    </style>
</head>
<body>
    <div class="error">✗ 认证失败</div>
    <div class="message">错误: $error</div>
    <div class="message">请返回应用重试。</div>
</body>
</html>
    ''';
  }

  /// 获取错误请求页面
  String _getBadRequestPage() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>请求错误</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .error { color: #dc3545; font-size: 24px; margin-bottom: 20px; }
        .message { color: #333; font-size: 16px; }
    </style>
</head>
<body>
    <div class="error">✗ 请求错误</div>
    <div class="message">认证参数无效，请返回应用重试。</div>
</body>
</html>
    ''';
  }

  /// 清除服务器的认证信息
  void clearAuthentication(String serverId) {
    _tokens.remove(serverId);
    _pendingAuth.remove(serverId);
    _logger.info('Cleared authentication for server: $serverId');
  }

  /// 清理所有认证信息
  void dispose() {
    _tokens.clear();
    _pendingAuth.clear();
    _logger.info('OAuth provider disposed');
  }
}

/// Token信息
class TokenInfo {
  String accessToken;
  String? refreshToken;
  String? tokenType;
  DateTime? expiresAt;
  List<String>? scopes;

  TokenInfo({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresAt,
    this.scopes,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int?;
    DateTime? expiresAt;
    
    if (expiresIn != null) {
      expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    }

    return TokenInfo(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String?,
      expiresAt: expiresAt,
      scopes: (json['scope'] as String?)?.split(' '),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_at': expiresAt?.toIso8601String(),
      'scope': scopes?.join(' '),
    };
  }
}