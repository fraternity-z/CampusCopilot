import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/utils/debug_log.dart';

import '../../../../core/di/database_providers.dart';

/// UI设置状态
class UISettingsState {
  final bool sidebarCollapsed;
  final double sidebarWidth;
  final bool isLoading;
  final String? error;

  const UISettingsState({
    this.sidebarCollapsed = false,
    this.sidebarWidth = 280.0,
    this.isLoading = false,
    this.error,
  });

  UISettingsState copyWith({
    bool? sidebarCollapsed,
    double? sidebarWidth,
    bool? isLoading,
    String? error,
  }) {
    return UISettingsState(
      sidebarCollapsed: sidebarCollapsed ?? this.sidebarCollapsed,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// UI设置键名常量
class UISettingsKeys {
  /// 侧边栏是否折叠
  static const String sidebarCollapsed = 'sidebar_collapsed';

  /// 侧边栏宽度
  static const String sidebarWidth = 'sidebar_width';
}

/// UI设置状态管理
class UISettingsNotifier extends StateNotifier<UISettingsState> {
  final AppDatabase _database;

  UISettingsNotifier(this._database) : super(const UISettingsState()) {
    _loadSettings();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final sidebarCollapsedStr = await _database.getSetting(
        UISettingsKeys.sidebarCollapsed,
      );
      final sidebarWidthStr = await _database.getSetting(
        UISettingsKeys.sidebarWidth,
      );

      state = state.copyWith(
        sidebarCollapsed: sidebarCollapsedStr == 'true',
        sidebarWidth: double.tryParse(sidebarWidthStr ?? '') ?? 280.0,
        isLoading: false,
      );

      debugLog(() =>
        '🎨 UI设置已加载: 侧边栏折叠=${state.sidebarCollapsed}, 宽度=${state.sidebarWidth}',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载UI设置失败: $e');
      debugLog(() =>'❌ 加载UI设置失败: $e');
    }
  }

  /// 设置侧边栏折叠状态
  Future<void> setSidebarCollapsed(bool collapsed) async {
    try {
      await _database.setSetting(
        UISettingsKeys.sidebarCollapsed,
        collapsed.toString(),
      );
      state = state.copyWith(sidebarCollapsed: collapsed);
      debugLog(() =>'🎨 侧边栏折叠状态已保存: $collapsed');
    } catch (e) {
      state = state.copyWith(error: '保存侧边栏设置失败: $e');
      debugLog(() =>'❌ 保存侧边栏折叠状态失败: $e');
    }
  }

  /// 设置侧边栏宽度
  Future<void> setSidebarWidth(double width) async {
    try {
      await _database.setSetting(UISettingsKeys.sidebarWidth, width.toString());
      state = state.copyWith(sidebarWidth: width);
      debugLog(() =>'🎨 侧边栏宽度已保存: $width');
    } catch (e) {
      state = state.copyWith(error: '保存侧边栏宽度失败: $e');
      debugLog(() =>'❌ 保存侧边栏宽度失败: $e');
    }
  }

  /// 切换侧边栏折叠状态
  Future<void> toggleSidebarCollapsed() async {
    await setSidebarCollapsed(!state.sidebarCollapsed);
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// UI设置Provider
final uiSettingsProvider =
    StateNotifierProvider<UISettingsNotifier, UISettingsState>(
      (ref) => UISettingsNotifier(ref.read(appDatabaseProvider)),
    );

/// 侧边栏折叠状态Provider（兼容现有代码）
final sidebarCollapsedProvider = Provider<bool>((ref) {
  return ref.watch(uiSettingsProvider).sidebarCollapsed;
});

/// 侧边栏宽度Provider
final sidebarWidthProvider = Provider<double>((ref) {
  return ref.watch(uiSettingsProvider).sidebarWidth;
});
