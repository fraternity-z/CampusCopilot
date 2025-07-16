import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';
import 'proxy_config.dart';

/// Dio HTTP客户端配置
///
/// 提供统一的网络请求配置，包括：
/// - 单例模式优化
/// - 连接池配置
/// - 超时设置
/// - 拦截器配置
/// - 错误处理
/// - 智能重试机制
/// - 条件日志记录
class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  ProxyConfig _proxyConfig = const ProxyConfig();
  bool _proxyConfigChanged = false;
  HttpClient? _cachedHttpClient;

  DioClient._internal() {
    _dio = Dio();
    _configureDio();
  }

  /// 配置Dio实例
  void _configureDio() {
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: AppConstants.networkTimeoutSeconds),
      receiveTimeout: Duration(seconds: AppConstants.networkTimeoutSeconds),
      sendTimeout: Duration(seconds: AppConstants.networkTimeoutSeconds),
      // 启用连接复用
      persistentConnection: true,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 启用Keep-Alive
        'Connection': 'keep-alive',
      },
    );

    // 配置HTTP适配器以启用连接池和代理
    _configureHttpAdapter();

    // 添加拦截器
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(),
    ]);
  }

  /// 配置HTTP适配器
  void _configureHttpAdapter() {
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;

      adapter.createHttpClient = () {
        // 如果代理配置没有变化且有缓存的客户端，复用之前的客户端
        if (_cachedHttpClient != null && !_proxyConfigChanged) {
          return _cachedHttpClient!;
        }

        final client = HttpClient();

        // 配置连接池
        client.maxConnectionsPerHost = 5; // 每个主机最大连接数
        client.idleTimeout = Duration(seconds: 15); // 连接空闲超时

        // 配置代理
        _configureProxy(client);

        // 缓存客户端并重置变化标志
        _cachedHttpClient = client;
        _proxyConfigChanged = false;

        return client;
      };
    }
  }

  /// 配置代理设置
  void _configureProxy(HttpClient client) {
    switch (_proxyConfig.mode) {
      case ProxyMode.none:
        // 不使用代理，清除代理设置
        client.findProxy = null;
        break;

      case ProxyMode.system:
        // 使用系统代理，让HttpClient自动检测
        client.findProxy = HttpClient.findProxyFromEnvironment;
        break;

      case ProxyMode.custom:
        // 使用自定义代理
        if (_proxyConfig.isValid) {
          client.findProxy = (uri) {
            return '${_proxyConfig.proxyProtocol} ${_proxyConfig.proxyUrl}';
          };

          // 如果需要认证，设置代理认证
          if (_proxyConfig.requiresAuth) {
            client.addProxyCredentials(
              _proxyConfig.host,
              _proxyConfig.port,
              'realm', // 通常代理不需要realm，但API需要
              HttpClientBasicCredentials(
                _proxyConfig.username,
                _proxyConfig.password,
              ),
            );
          }
        }
        break;
    }
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// 更新代理配置
  void updateProxyConfig(ProxyConfig config) {
    // 只有配置真正改变时才更新
    if (_proxyConfig != config) {
      _proxyConfig = config;
      _proxyConfigChanged = true;

      // 清除缓存的客户端，强制重新创建
      _cachedHttpClient?.close(force: true);
      _cachedHttpClient = null;

      // 重新配置HTTP适配器以应用新的代理设置
      _configureHttpAdapter();

      if (kDebugMode) {
        debugPrint('🌐 代理配置已更新: ${config.mode.displayName}');
        if (config.isCustom && config.isValid) {
          debugPrint('🌐 代理地址: ${config.host}:${config.port}');
        }
      }
    }
  }

  /// 获取当前代理配置
  ProxyConfig get proxyConfig => _proxyConfig;

  /// GET请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE请求
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 流式请求（优化版本）
  Stream<String> getStream(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async* {
    try {
      final response = await _dio.get<ResponseBody>(
        path,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(
          responseType: ResponseType.stream,
        ),
        cancelToken: cancelToken,
      );

      final stream = response.data!.stream;
      final buffer = StringBuffer();

      // 使用缓冲区减少字符串创建次数
      await for (final chunk in stream) {
        buffer.write(String.fromCharCodes(chunk));

        // 当缓冲区达到一定大小时才输出，减少 yield 次数
        if (buffer.length >= 1024) {
          yield buffer.toString();
          buffer.clear();
        }
      }

      // 输出剩余内容
      if (buffer.isNotEmpty) {
        yield buffer.toString();
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 错误处理
  AppException _handleError(dynamic error) {
    if (error is DioException) {
      // 添加请求路径信息，方便调试
      final path = error.requestOptions.uri.path;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException('请求超时: $path', code: 'NETWORK_TIMEOUT');

        case DioExceptionType.connectionError:
          // 检查是否是代理连接错误
          if (error.error is SocketException) {
            final socketError = error.error as SocketException;
            if (socketError.message.contains('proxy')) {
              return NetworkException('代理连接失败: $path', originalError: error);
            }
          }
          return NetworkException.noInternet();

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          if (statusCode == 401) {
            return ApiException.invalidApiKey();
          } else if (statusCode == 429) {
            return ApiException.rateLimitExceeded();
          } else if (statusCode == 402) {
            return ApiException.quotaExceeded();
          }
          return NetworkException.serverError(statusCode);

        default:
          return NetworkException(
            error.message ?? '网络请求失败: $path',
            originalError: error,
          );
      }
    }

    return NetworkException('未知网络错误', originalError: error);
  }

  /// 清理资源（在应用退出时调用）
  void dispose() {
    _cachedHttpClient?.close(force: true);
    _cachedHttpClient = null;
    _dio.close(force: true);
  }
}

/// 日志拦截器（优化版本）
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 只在Debug模式下记录日志
    if (kDebugMode) {
      debugPrint('🚀 REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('📤 DATA: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: ${err.type} ${err.requestOptions.uri}');
      debugPrint('📝 MESSAGE: ${err.message}');
    }
    super.onError(err, handler);
  }
}

/// 错误拦截器
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 可以在这里添加全局错误处理逻辑
    // 比如自动刷新token、显示错误提示等
    super.onError(err, handler);
  }
}

/// 重试拦截器（优化版本）
class _RetryInterceptor extends Interceptor {
  // 添加静态配置，避免重复计算
  static const _retryableStatusCodes = {500, 502, 503, 504};

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < AppConstants.maxRetryAttempts) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // 使用更合理的退避策略：min(2^n * 1000, 16000) ms
        final delayMs = math.min(1000 * (1 << retryCount), 16000);
        await Future.delayed(Duration(milliseconds: delayMs));

        try {
          // 重用原始Dio实例而不是创建新的
          final response = await DioClient._instance._dio.fetch(
            err.requestOptions,
          );
          handler.resolve(response);
          return;
        } catch (e) {
          // 重试失败，继续抛出原错误
        }
      }
    }

    super.onError(err, handler);
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException err) {
    // 优化判断逻辑，使用集合查找
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            _retryableStatusCodes.contains(err.response!.statusCode));
  }
}

/// Dio客户端Provider（优化版本）
final dioClientProvider = Provider<DioClient>((ref) {
  ref.keepAlive(); // 防止自动销毁，确保单例在整个应用生命周期内保持活跃
  return DioClient();
});
