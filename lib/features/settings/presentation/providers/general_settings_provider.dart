import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart';
import '../../../../data/local/tables/general_settings_table.dart';
import '../../../../core/di/database_providers.dart';

/// 常规设置状态
class GeneralSettingsState {
  final bool autoTopicNamingEnabled;
  final String? autoTopicNamingModelId;
  final bool isLoading;
  final String? error;

  const GeneralSettingsState({
    this.autoTopicNamingEnabled = false,
    this.autoTopicNamingModelId,
    this.isLoading = false,
    this.error,
  });

  GeneralSettingsState copyWith({
    bool? autoTopicNamingEnabled,
    String? autoTopicNamingModelId,
    bool? isLoading,
    String? error,
  }) {
    return GeneralSettingsState(
      autoTopicNamingEnabled:
          autoTopicNamingEnabled ?? this.autoTopicNamingEnabled,
      autoTopicNamingModelId:
          autoTopicNamingModelId ?? this.autoTopicNamingModelId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 常规设置状态管理
class GeneralSettingsNotifier extends StateNotifier<GeneralSettingsState> {
  final AppDatabase _database;

  GeneralSettingsNotifier(this._database)
    : super(const GeneralSettingsState()) {
    _loadSettings();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final autoNamingEnabled = await _database.getSetting(
        GeneralSettingsKeys.autoTopicNamingEnabled,
      );
      final autoNamingModelId = await _database.getSetting(
        GeneralSettingsKeys.autoTopicNamingModelId,
      );

      state = state.copyWith(
        autoTopicNamingEnabled: autoNamingEnabled == 'true',
        autoTopicNamingModelId: autoNamingModelId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载设置失败: $e');
    }
  }

  /// 设置话题自动命名开关
  Future<void> setAutoTopicNamingEnabled(bool enabled) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.autoTopicNamingEnabled,
        enabled.toString(),
      );
      state = state.copyWith(autoTopicNamingEnabled: enabled);
    } catch (e) {
      state = state.copyWith(error: '保存设置失败: $e');
    }
  }

  /// 设置话题自动命名模型
  Future<void> setAutoTopicNamingModelId(String? modelId) async {
    try {
      if (modelId != null) {
        await _database.setSetting(
          GeneralSettingsKeys.autoTopicNamingModelId,
          modelId,
        );
      } else {
        await _database.deleteSetting(
          GeneralSettingsKeys.autoTopicNamingModelId,
        );
      }
      state = state.copyWith(autoTopicNamingModelId: modelId);
    } catch (e) {
      state = state.copyWith(error: '保存设置失败: $e');
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 常规设置Provider
final generalSettingsProvider =
    StateNotifierProvider<GeneralSettingsNotifier, GeneralSettingsState>(
      (ref) => GeneralSettingsNotifier(ref.read(appDatabaseProvider)),
    );

/// 可用聊天模型Provider
final availableChatModelsProvider = FutureProvider<List<CustomModelsTableData>>(
  (ref) async {
    final database = ref.read(appDatabaseProvider);

    // 获取所有启用的LLM配置
    final enabledConfigs = await database.getEnabledLlmConfigs();
    final availableModels = <CustomModelsTableData>[];

    // 为每个启用的配置获取其关联的聊天模型
    for (final config in enabledConfigs) {
      final configModels = await database.getCustomModelsByConfig(config.id);
      final chatModels = configModels.where(
        (model) => model.isEnabled && model.type == 'chat',
      );
      availableModels.addAll(chatModels);
    }

    // 如果没有找到配置关联的模型，则获取所有启用的聊天模型作为备选
    if (availableModels.isEmpty) {
      final allModels = await database.getAllCustomModels();
      availableModels.addAll(
        allModels.where((model) => model.isEnabled && model.type == 'chat'),
      );
    }

    return availableModels;
  },
);
