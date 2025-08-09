import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// 优化的 HTTP 客户端池管理器
class HttpClientPool {
  static final Map<String, IOClient> _clientPool = {};

  static const int _maxConnectionsPerHost = 10;
  static const Duration _idleTimeout = Duration(seconds: 15);
  static const Duration _connectionTimeout = Duration(seconds: 30);

  /// 获取或创建优化的 HTTP 客户端
  static http.Client getClient(String key) {
    return _clientPool.putIfAbsent(key, () {
      final httpClient = HttpClient()
        ..connectionTimeout = _connectionTimeout
        ..maxConnectionsPerHost = _maxConnectionsPerHost
        ..idleTimeout = _idleTimeout
        ..autoUncompress = true
        // 生产环境必须校验证书
        ..badCertificateCallback = (cert, host, port) => false;

      return IOClient(httpClient);
    });
  }

  /// 清理所有客户端
  static void disposeAll() {
    for (final client in _clientPool.values) {
      client.close();
    }
    _clientPool.clear();
  }

  /// 清理特定客户端
  static void disposeClient(String key) {
    _clientPool[key]?.close();
    _clientPool.remove(key);
  }
}

/// 请求重试装饰器
class RetryClient extends http.BaseClient {
  final http.Client _inner;
  final int maxRetries;
  final Duration retryDelay;

  RetryClient(
    this._inner, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(milliseconds: 800),
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    int attempts = 0;

    while (true) {
      try {
        final response = await _inner.send(_copyRequest(request));
        // 对 5xx 做指数退避重试
        if (response.statusCode >= 500 && attempts < maxRetries) {
          await Future.delayed(_backoff(attempts));
          attempts++;
          continue;
        }
        return response;
      } catch (e) {
        if (attempts < maxRetries && _isRetryableError(e)) {
          await Future.delayed(_backoff(attempts));
          attempts++;
          continue;
        }
        rethrow;
      }
    }
  }

  Duration _backoff(int attempts) {
    final int factor = attempts + 1;
    final delayMs = retryDelay.inMilliseconds * factor * factor; // 二次退避
    return Duration(milliseconds: delayMs > 3000 ? 3000 : delayMs);
  }

  bool _isRetryableError(Object error) {
    return error is SocketException ||
        error is HttpException ||
        error is TlsException ||
        error.toString().contains('Connection closed') ||
        error.toString().contains('Handshake error');
  }

  http.BaseRequest _copyRequest(http.BaseRequest request) {
    if (request is http.Request) {
      return http.Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..bodyBytes = request.bodyBytes
        ..encoding = request.encoding;
    }
    // 其它类型（如 MultipartRequest）直接返回原对象（其自身在 send 内部可复用）
    return request;
  }
}
