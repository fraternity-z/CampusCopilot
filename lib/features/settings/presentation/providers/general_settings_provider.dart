import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/app_database.dart';
import '../../../../data/local/tables/general_settings_table.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../core/network/proxy_config.dart';

/// 常规设置状态
class GeneralSettingsState {
  final bool autoTopicNamingEnabled;
  final String? autoTopicNamingModelId;
  final ProxyConfig proxyConfig;
  final bool isLoading;
  final String? error;

  const GeneralSettingsState({
    this.autoTopicNamingEnabled = false,
    this.autoTopicNamingModelId,
    this.proxyConfig = const ProxyConfig(),
    this.isLoading = false,
    this.error,
  });

  GeneralSettingsState copyWith({
    bool? autoTopicNamingEnabled,
    String? autoTopicNamingModelId,
    ProxyConfig? proxyConfig,
    bool? isLoading,
    String? error,
  }) {
    return GeneralSettingsState(
      autoTopicNamingEnabled:
          autoTopicNamingEnabled ?? this.autoTopicNamingEnabled,
      autoTopicNamingModelId:
          autoTopicNamingModelId ?? this.autoTopicNamingModelId,
      proxyConfig: proxyConfig ?? this.proxyConfig,
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

      // 加载代理配置
      final proxyConfig = await _loadProxyConfig();

      state = state.copyWith(
        autoTopicNamingEnabled: autoNamingEnabled == 'true',
        autoTopicNamingModelId: autoNamingModelId,
        proxyConfig: proxyConfig,
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

  /// 加载代理配置
  Future<ProxyConfig> _loadProxyConfig() async {
    try {
      final proxyMode = await _database.getSetting(
        GeneralSettingsKeys.proxyMode,
      );
      final proxyType = await _database.getSetting(
        GeneralSettingsKeys.proxyType,
      );
      final proxyHost = await _database.getSetting(
        GeneralSettingsKeys.proxyHost,
      );
      final proxyPort = await _database.getSetting(
        GeneralSettingsKeys.proxyPort,
      );
      final proxyUsername = await _database.getSetting(
        GeneralSettingsKeys.proxyUsername,
      );
      final proxyPassword = await _database.getSetting(
        GeneralSettingsKeys.proxyPassword,
      );

      return ProxyConfig(
        mode: _parseProxyMode(proxyMode),
        type: _parseProxyType(proxyType),
        host: proxyHost ?? '',
        port: int.tryParse(proxyPort ?? '8080') ?? 8080,
        username: proxyUsername ?? '',
        password: proxyPassword ?? '',
      );
    } catch (e) {
      return const ProxyConfig(); // 返回默认配置
    }
  }

  /// 解析代理模式
  ProxyMode _parseProxyMode(String? mode) {
    switch (mode) {
      case 'system':
        return ProxyMode.system;
      case 'custom':
        return ProxyMode.custom;
      default:
        return ProxyMode.none;
    }
  }

  /// 解析代理类型
  ProxyType _parseProxyType(String? type) {
    switch (type) {
      case 'https':
        return ProxyType.https;
      case 'socks5':
        return ProxyType.socks5;
      default:
        return ProxyType.http;
    }
  }

  /// 设置代理配置
  Future<void> setProxyConfig(ProxyConfig config) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.proxyMode,
        config.mode.name,
      );
      await _database.setSetting(
        GeneralSettingsKeys.proxyType,
        config.type.name,
      );
      await _database.setSetting(GeneralSettingsKeys.proxyHost, config.host);
      await _database.setSetting(
        GeneralSettingsKeys.proxyPort,
        config.port.toString(),
      );
      await _database.setSetting(
        GeneralSettingsKeys.proxyUsername,
        config.username,
      );
      await _database.setSetting(
        GeneralSettingsKeys.proxyPassword,
        config.password,
      );

      state = state.copyWith(proxyConfig: config);
    } catch (e) {
      state = state.copyWith(error: '保存代理配置失败: $e');
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
