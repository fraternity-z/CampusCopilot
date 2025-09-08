import 'package:flutter/foundation.dart';
import '../../repository/preference.dart' as preference;

/// 应用启动配置服务
/// 
/// 管理应用启动时的行为配置，包括聊天会话的初始化策略
class AppLaunchService {
  static const String _autoCreateNewSessionKey = 'auto_create_new_session_on_launch';
  
  /// 是否在应用启动时自动创建新会话
  /// 默认为true，确保每次打开应用都是新对话
  static bool get autoCreateNewSessionOnLaunch {
    try {
      return preference.prefs.getBool(_autoCreateNewSessionKey) ?? true;
    } catch (e) {
      debugPrint('读取自动创建新会话配置失败: $e');
      return true; // 默认启用
    }
  }
  
  /// 设置是否在应用启动时自动创建新会话
  static Future<bool> setAutoCreateNewSessionOnLaunch(bool value) async {
    try {
      await preference.prefs.setBool(_autoCreateNewSessionKey, value);
      return true;
    } catch (e) {
      debugPrint('设置自动创建新会话配置失败: $e');
      return false;
    }
  }
  
  /// 检查是否为应用首次启动（本次运行周期内）
  static bool _hasInitialized = false;
  
  /// 标记应用已完成启动初始化
  static void markInitialized() {
    _hasInitialized = true;
  }
  
  /// 检查是否需要执行启动时的特殊逻辑
  static bool shouldExecuteLaunchLogic() {
    return !_hasInitialized;
  }
  
  /// 重置启动状态（用于测试或特殊情况）
  static void resetLaunchState() {
    _hasInitialized = false;
  }
}
