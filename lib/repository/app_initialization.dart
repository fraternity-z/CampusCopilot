// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

// 应用初始化管理器

import 'package:ai_assistant/shared/utils/debug_log.dart';
import 'package:ai_assistant/repository/preference.dart' as preference;
import 'package:ai_assistant/repository/xidian_ids/ids_session.dart';
import 'package:ai_assistant/repository/xidian_ids/classtable_session.dart';
import 'package:ai_assistant/repository/classtable_cache_manager.dart';

class AppInitializationManager {
  /// 应用初始化
  static Future<void> initialize() async {
    debugLog(() => "[AppInitializationManager] Starting app initialization");
    
    try {
      // 1. 恢复登录状态
      await restoreLoginState();
      debugLog(() => "[AppInitializationManager] Login state restored");
      
      // 2. 尝试自动登录（如果启用且有凭据）
      if (preference.getBool(preference.Preference.autoLogin)) {
        debugLog(() => "[AppInitializationManager] Auto login is enabled, attempting...");
        final success = await tryAutoLogin();
        if (success) {
          debugLog(() => "[AppInitializationManager] Auto login successful");
          
          // 3. 后台预加载课程表
          _preloadClassTableInBackground();
        } else {
          debugLog(() => "[AppInitializationManager] Auto login failed");
        }
      } else {
        debugLog(() => "[AppInitializationManager] Auto login is disabled");
      }
      
      debugLog(() => "[AppInitializationManager] App initialization completed");
    } catch (e) {
      debugLog(() => "[AppInitializationManager] Error during initialization: $e");
    }
  }

  /// 在后台预加载课程表
  static void _preloadClassTableInBackground() {
    // 异步执行，不阻塞主流程
    Future.delayed(Duration.zero, () async {
      try {
        debugLog(() => "[AppInitializationManager] Starting background class table preload");
        
        final classTableFile = ClassTableFile();
        
        // 检查是否需要强制刷新
        final currentSemester = preference.getString(preference.Preference.currentSemester);
        final shouldForceRefresh = await ClassTableCacheManager.shouldForceRefresh(currentSemester);
        
        // 预加载课程表（优先使用缓存）
        await classTableFile.getClassTableWithCache(forceRefresh: shouldForceRefresh);
        
        debugLog(() => "[AppInitializationManager] Class table preloaded successfully");
      } catch (e) {
        debugLog(() => "[AppInitializationManager] Failed to preload class table: $e");
        // 预加载失败不影响应用启动
      }
    });
  }

  /// 清除所有缓存数据（用于登出或重置）
  static Future<void> clearAllCache() async {
    try {
      debugLog(() => "[AppInitializationManager] Clearing all cache");
      
      // 清除登录状态
      await clearLoginState();
      
      // 清除课程表缓存
      await ClassTableCacheManager.clearCache();
      
      // 清除自动登录设置
      await preference.setBool(preference.Preference.autoLogin, false);
      await preference.setBool(preference.Preference.rememberLogin, false);
      await preference.setString(preference.Preference.idsPassword, "");
      
      debugLog(() => "[AppInitializationManager] All cache cleared");
    } catch (e) {
      debugLog(() => "[AppInitializationManager] Error clearing cache: $e");
    }
  }
  
  /// 获取缓存状态信息（用于调试和设置界面）
  static Future<Map<String, dynamic>> getCacheStatus() async {
    final cacheInfo = await ClassTableCacheManager.getCacheInfo();
    final currentLoginState = loginState.toString();
    final autoLoginEnabled = preference.getBool(preference.Preference.autoLogin);
    final rememberLoginEnabled = preference.getBool(preference.Preference.rememberLogin);
    final hasAccount = preference.getString(preference.Preference.idsAccount).isNotEmpty;
    final hasPassword = preference.getString(preference.Preference.idsPassword).isNotEmpty;
    
    return {
      'loginState': currentLoginState,
      'autoLoginEnabled': autoLoginEnabled,
      'rememberLoginEnabled': rememberLoginEnabled,
      'hasAccount': hasAccount,
      'hasPassword': hasPassword,
      'classTableCache': cacheInfo,
      'cacheValid': await ClassTableCacheManager.isCacheValid(),
    };
  }
}