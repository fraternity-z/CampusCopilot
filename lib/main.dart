import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'app/app.dart';
import 'shared/utils/keyboard_utils.dart';
import 'shared/utils/debug_log.dart';
import 'repository/preference.dart' as preference;
import 'repository/network_session.dart' as network;
import 'repository/app_initialization.dart';

/// 应用程序入口点
///
/// 初始化Riverpod状态管理并启动应用
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化应用依赖
  await _initializePreferences();
  await _initializePaths();
  
  // 配置系统UI样式
  _configureSystemUI();

  // 启动应用
  runApp(const ProviderScope(child: AIAssistantApp()));
  
  // 异步初始化应用状态（登录和缓存）
  AppInitializationManager.initialize();
}

/// 初始化应用偏好设置
Future<void> _initializePreferences() async {
  try {
    // 初始化SharedPreferences
    preference.prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: null, // 缓存所有key
      ),
    );
    
    // 初始化PackageInfo
    preference.packageInfo = await PackageInfo.fromPlatform();
  } catch (e) {
    debugLog(() => '❌ 初始化偏好设置失败: $e');
    // 如果初始化失败，使用默认的SharedPreferences
    preference.prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }
}

/// 初始化应用路径
Future<void> _initializePaths() async {
  try {
    // 初始化应用支持目录
    network.supportPath = await getApplicationSupportDirectory();
    debugLog(() => '📁 应用支持目录已初始化: ${network.supportPath.path}');
  } catch (e) {
    debugLog(() => '❌ 初始化应用路径失败: $e');
    // 使用临时目录作为备用方案
    network.supportPath = Directory.systemTemp;
  }
}


/// 配置系统UI样式
void _configureSystemUI() {
  // 启用边到边显示模式
  KeyboardUtils.enableEdgeToEdge();

  // 配置状态栏样式
  KeyboardUtils.configureSystemUI(
    statusBarTransparent: true,
    statusBarIconBrightness: Brightness.dark,
  );
}
