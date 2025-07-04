import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';

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

    // 配置HTTP适配器以启用连接池
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
      adapter.createHttpClient = () {
        final client = adapter.createHttpClient!();
        client.maxConnectionsPerHost = 5; // 每个主机最大连接数
        client.idleTimeout = Duration(seconds: 15); // 连接空闲超时
        return client;
      };
    }

    // 添加拦截器
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
      _RetryInterceptor(),
    ]);
  }

  /// 获取Dio实例
  Dio get dio => _dio;

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
      // 直接处理数据流
      await for (final chunk in stream) {
        yield String.fromCharCodes(chunk);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 错误处理
  AppException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException.connectionTimeout();

        case DioExceptionType.connectionError:
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
            error.message ?? '网络请求失败',
            originalError: error,
          );
      }
    }

    return NetworkException('未知网络错误', originalError: error);
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
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < AppConstants.maxRetryAttempts) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // 指数退避：1s, 2s, 4s...
        final delay = Duration(seconds: (1 << retryCount));
        await Future.delayed(delay);

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
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Dio客户端Provider（优化版本）
final dioClientProvider = Provider<DioClient>((ref) {
  ref.keepAlive(); // 防止自动销毁，确保单例在整个应用生命周期内保持活跃
  return DioClient();
});
