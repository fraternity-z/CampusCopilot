import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 启动屏状态枚举
enum SplashState {
  /// 显示启动屏
  showing,
  /// 启动屏完成，准备进入应用
  completed,
}

/// 启动屏状态通知器
class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(SplashState.showing);

  /// 完成启动屏动画
  void completeAnimation() {
    state = SplashState.completed;
  }

  /// 重置启动屏状态（用于测试）
  void reset() {
    state = SplashState.showing;
  }
}

/// 启动屏状态提供器
final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier();
});

/// 启动屏设置
class SplashSettings {
  /// 是否启用启动屏
  final bool enabled;
  
  /// 启动屏动画持续时间（毫秒）
  final int durationMs;
  
  /// 是否跳过启动屏（调试用）
  final bool skipInDebug;

  const SplashSettings({
    this.enabled = true,
    this.durationMs = 2000,
    this.skipInDebug = false,
  });

  SplashSettings copyWith({
    bool? enabled,
    int? durationMs,
    bool? skipInDebug,
  }) {
    return SplashSettings(
      enabled: enabled ?? this.enabled,
      durationMs: durationMs ?? this.durationMs,
      skipInDebug: skipInDebug ?? this.skipInDebug,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'durationMs': durationMs,
      'skipInDebug': skipInDebug,
    };
  }

  factory SplashSettings.fromJson(Map<String, dynamic> json) {
    return SplashSettings(
      enabled: json['enabled'] as bool? ?? true,
      durationMs: json['durationMs'] as int? ?? 3000,
      skipInDebug: json['skipInDebug'] as bool? ?? false,
    );
  }
}

/// 启动屏设置通知器
class SplashSettingsNotifier extends StateNotifier<SplashSettings> {
  SplashSettingsNotifier() : super(const SplashSettings()) {
    _loadSettings();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('splash_settings');
      
      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = 
            json.decode(settingsJson) as Map<String, dynamic>;
        state = SplashSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // 加载失败时使用默认设置
    }
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(state.toJson());
      await prefs.setString('splash_settings', settingsJson);
    } catch (e) {
      // 保存失败时忽略
    }
  }

  /// 更新启用状态
  Future<void> updateEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    await _saveSettings();
  }

  /// 更新动画持续时间
  Future<void> updateDuration(int durationMs) async {
    state = state.copyWith(durationMs: durationMs);
    await _saveSettings();
  }

  /// 更新调试跳过设置
  Future<void> updateSkipInDebug(bool skipInDebug) async {
    state = state.copyWith(skipInDebug: skipInDebug);
    await _saveSettings();
  }
}

/// 启动屏设置提供器
final splashSettingsProvider = 
    StateNotifierProvider<SplashSettingsNotifier, SplashSettings>((ref) {
  return SplashSettingsNotifier();
});

/// 是否应该显示启动屏的计算提供器
final shouldShowSplashProvider = Provider<bool>((ref) {
  final settings = ref.watch(splashSettingsProvider);
  final splashState = ref.watch(splashProvider);
  
  // 如果未启用，直接返回false
  if (!settings.enabled) return false;
  
  // 在调试模式下且设置跳过时，返回false
  if (settings.skipInDebug) {
    // 这里可以添加判断是否为调试模式的逻辑
    // if (kDebugMode) return false;
  }
  
  // 如果启动屏已完成，返回false
  if (splashState == SplashState.completed) return false;
  
  return true;
});