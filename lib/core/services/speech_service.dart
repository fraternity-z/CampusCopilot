import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

/// 语音识别服务
///
/// 提供统一的语音识别功能，包括：
/// - 权限管理
/// - 语音识别初始化
/// - 开始/停止录音
/// - 识别结果处理
/// - 错误处理
class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  late final stt.SpeechToText _speechToText;
  bool _isInitialized = false;
  bool _isListening = false;
  String _recognizedText = '';
  Function(String)? _onResult;
  Function(String)? _onError;
  Function(bool)? _onListeningStatusChanged;

  /// 初始化语音识别服务
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _speechToText = stt.SpeechToText();

    try {
      // 检查并请求权限
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        if (kDebugMode) {
          debugPrint('SpeechService: 麦克风权限被拒绝');
        }
        return false;
      }

      // 初始化语音识别
      _isInitialized = await _speechToText.initialize(
        onError: (error) {
          if (kDebugMode) {
            debugPrint('SpeechService Error: ${error.errorMsg}');
          }
          _onError?.call(error.errorMsg);
          _setListeningStatus(false);
        },
        onStatus: (status) {
          if (kDebugMode) {
            debugPrint('SpeechService Status: $status');
          }

          if (status == 'done' || status == 'notListening') {
            _setListeningStatus(false);
          }
        },
      );

      if (kDebugMode) {
        debugPrint('SpeechService: 初始化${_isInitialized ? '成功' : '失败'}');
      }

      return _isInitialized;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechService: 初始化异常 - $e');
      }
      _onError?.call('语音识别初始化失败: $e');
      return false;
    }
  }

  /// 检查并请求必要权限
  Future<bool> _requestPermissions() async {
    try {
      // 在Windows和Web平台上，permission_handler可能不完全支持
      if (kIsWeb || Platform.isWindows || Platform.isLinux) {
        if (kDebugMode) {
          debugPrint('SpeechService: 桌面/Web平台，跳过权限检查，直接使用语音识别');
        }
        return true;
      }

      final micPermission = await Permission.microphone.status;

      if (micPermission.isDenied) {
        final result = await Permission.microphone.request();
        return result.isGranted;
      }

      return micPermission.isGranted;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechService: 权限检查异常 - $e');
        debugPrint('SpeechService: 将尝试直接使用语音识别');
      }
      // 权限检查失败时，直接返回true让speech_to_text自己处理
      return true;
    }
  }

  /// 开始语音识别
  Future<bool> startListening({
    String? localeId,
    Duration? listenFor,
    bool partialResults = true,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }

    if (_isListening) {
      if (kDebugMode) {
        debugPrint('SpeechService: 已经在监听中');
      }
      return true;
    }

    try {
      _recognizedText = '';

      await _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          _onResult?.call(_recognizedText);

          // 如果识别完成且有结果，自动停止监听
          if (result.finalResult && _recognizedText.isNotEmpty) {
            stopListening();
          }
        },
        localeId: localeId ?? 'zh_CN', // 默认中文
        listenFor: listenFor ?? const Duration(seconds: 30),
        listenOptions: stt.SpeechListenOptions(
          partialResults: partialResults,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );

      _setListeningStatus(true);

      if (kDebugMode) {
        debugPrint('SpeechService: 开始监听');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechService: 开始监听异常 - $e');
      }
      _onError?.call('开始语音识别失败: $e');
      return false;
    }
  }

  /// 停止语音识别
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _setListeningStatus(false);

      if (kDebugMode) {
        debugPrint('SpeechService: 停止监听');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechService: 停止监听异常 - $e');
      }
      _onError?.call('停止语音识别失败: $e');
    }
  }

  /// 取消语音识别
  Future<void> cancel() async {
    if (!_isListening) return;

    try {
      await _speechToText.cancel();
      _setListeningStatus(false);
      _recognizedText = '';

      if (kDebugMode) {
        debugPrint('SpeechService: 取消监听');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechService: 取消监听异常 - $e');
      }
    }
  }

  /// 设置监听状态
  void _setListeningStatus(bool isListening) {
    _isListening = isListening;
    _onListeningStatusChanged?.call(_isListening);
  }

  /// 设置结果回调
  void setOnResult(Function(String) callback) {
    _onResult = callback;
  }

  /// 设置错误回调
  void setOnError(Function(String) callback) {
    _onError = callback;
  }

  /// 设置监听状态变化回调
  void setOnListeningStatusChanged(Function(bool) callback) {
    _onListeningStatusChanged = callback;
  }

  /// 获取当前识别的文本
  String get recognizedText => _recognizedText;

  /// 是否正在监听
  bool get isListening => _isListening;

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 是否可用
  bool get isAvailable => _isInitialized && _speechToText.isAvailable;

  /// 获取支持的语言列表
  Future<List<stt.LocaleName>> get supportedLocales async {
    if (!_isInitialized) return [];
    return await _speechToText.locales();
  }

  /// 释放资源
  Future<void> dispose() async {
    if (_isListening) {
      await cancel();
    }
    _onResult = null;
    _onError = null;
    _onListeningStatusChanged = null;
    _isInitialized = false;

    if (kDebugMode) {
      debugPrint('SpeechService: 资源已释放');
    }
  }
}
