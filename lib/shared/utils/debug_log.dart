import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// 惰性调试日志：仅在 Debug 模式下执行字符串插值并输出
/// 使用示例：
///   debugLog(() => '会话更新: ${state.currentSession?.id}');
void debugLog(String Function() msg) {
  if (kDebugMode) {
    // 只有在 Debug 模式才会执行字符串插值
    debugPrint(msg());
  }
}
