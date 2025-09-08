import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../shared/utils/debug_log.dart';
import '../../domain/entities/theme_color.dart';

/// 主题颜色状态管理
class ThemeColorNotifier extends StateNotifier<ThemeColorSettings> {
  ThemeColorNotifier() : super(const ThemeColorSettings()) {
    _loadColorSettings();
  }

  static const String _storageKey = 'theme_color_settings';

  /// 加载颜色设置
  Future<void> _loadColorSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_storageKey);

      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        state = ThemeColorSettings.fromJson(settingsMap);
        debugLog(() => '🎨 已加载主题颜色设置: ${state.currentColor.displayName}');
      } else {
        debugLog(() => '🎨 使用默认主题颜色设置');
      }
    } catch (e) {
      debugLog(() => '❌ 加载主题颜色设置失败: $e');
      // 使用默认设置
    }
  }

  /// 保存颜色设置
  Future<void> _saveColorSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(state.toJson());
      await prefs.setString(_storageKey, settingsJson);
      debugLog(() => '🎨 已保存主题颜色设置');
    } catch (e) {
      debugLog(() => '❌ 保存主题颜色设置失败: $e');
    }
  }

  /// 更新当前颜色主题
  Future<void> updateCurrentColor(ThemeColorType colorType) async {
    state = state.copyWith(
      currentColor: colorType,
      lastUpdated: DateTime.now(),
    );
    await _saveColorSettings();
    debugLog(() => '🎨 已切换主题颜色到: ${colorType.displayName}');
  }

  /// 切换动态颜色设置
  Future<void> toggleDynamicColor(bool enabled) async {
    state = state.copyWith(
      enableDynamicColor: enabled,
      lastUpdated: DateTime.now(),
    );
    await _saveColorSettings();
    debugLog(() => '🎨 动态颜色设置: ${enabled ? "已启用" : "已禁用"}');
  }

  /// 重置颜色设置
  Future<void> resetColorSettings() async {
    state = const ThemeColorSettings();
    await _saveColorSettings();
    debugLog(() => '🎨 已重置主题颜色设置');
  }
}

/// 主题颜色Provider
final themeColorProvider = StateNotifierProvider<ThemeColorNotifier, ThemeColorSettings>((ref) {
  return ThemeColorNotifier();
});

/// 当前颜色主题Provider
final currentThemeColorProvider = Provider<ThemeColorType>((ref) {
  return ref.watch(themeColorProvider).currentColor;
});

/// 动态颜色启用状态Provider
final dynamicColorEnabledProvider = Provider<bool>((ref) {
  return ref.watch(themeColorProvider).enableDynamicColor;
});
