import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../domain/entities/app_settings.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';

/// 设置状态管理
class SettingsNotifier extends StateNotifier<AppSettings> {
  final AppDatabase? _database;

  SettingsNotifier({
    required AppDatabase? database,
    WidgetRef? ref, // 保持参数兼容性，但不存储
  }) : _database = database,
       super(const AppSettings()) {
    _loadSettings(); // 初始化时加载设置
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('app_settings');

      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        state = AppSettings.fromJson(settingsMap);
      }
    } catch (e) {
      // 加载失败时使用默认设置
      debugPrint('Failed to load settings: $e');
    }
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(state.toJson());
      await prefs.setString('app_settings', settingsJson);
    } catch (e) {
      debugPrint('Failed to save settings: $e');
    }
  }

  /// 更新OpenAI配置
  Future<void> updateOpenAIConfig(OpenAIConfig config) async {
    state = state.copyWith(openaiConfig: config);
    await _saveSettings();
  }

  /// 更新Gemini配置
  Future<void> updateGeminiConfig(GeminiConfig config) async {
    state = state.copyWith(geminiConfig: config);
    await _saveSettings();
  }

  /// 更新Claude配置
  Future<void> updateClaudeConfig(ClaudeConfig config) async {
    state = state.copyWith(claudeConfig: config);
    await _saveSettings();
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _saveSettings();
  }

  /// 更新语言
  Future<void> updateLanguage(String language) async {
    state = state.copyWith(language: language);
    await _saveSettings();
  }

  /// 更新默认AI提供商
  Future<void> updateDefaultProvider(AIProvider provider) async {
    state = state.copyWith(defaultProvider: provider);
    await _saveSettings();
  }

  /// 更新聊天设置
  Future<void> updateChatSettings(ChatSettings chatSettings) async {
    state = state.copyWith(chatSettings: chatSettings);
    await _saveSettings();
  }

  /// 更新隐私设置
  Future<void> updatePrivacySettings(PrivacySettings privacySettings) async {
    state = state.copyWith(privacySettings: privacySettings);
    await _saveSettings();
  }

  /// 更新动画设置
  Future<void> updateEnableAnimations(bool enableAnimations) async {
    state = state.copyWith(enableAnimations: enableAnimations);
    await _saveSettings();
  }

  /// 重置所有设置
  Future<void> resetSettings() async {
    state = const AppSettings();
    await _saveSettings();
  }

  /// 导出设置
  String exportSettings() {
    return json.encode(state.toJson());
  }

  /// 导入设置
  Future<void> importSettings(String settingsJson) async {
    try {
      final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
      state = AppSettings.fromJson(settingsMap);
      await _saveSettings();
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }

  /// 清除所有设置
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_settings');
    state = const AppSettings();
  }

  /// 验证OpenAI配置
  bool validateOpenAIConfig() {
    // 从数据库检查配置而不是AppSettings
    final config = state.openaiConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证Gemini配置
  bool validateGeminiConfig() {
    final config = state.geminiConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证Claude配置
  bool validateClaudeConfig() {
    final config = state.claudeConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 获取当前可用的AI提供商
  List<AIProvider> getAvailableProviders() {
    final providers = <AIProvider>[];

    if (validateOpenAIConfig()) {
      providers.add(AIProvider.openai);
    }
    if (validateGeminiConfig()) {
      providers.add(AIProvider.gemini);
    }
    if (validateClaudeConfig()) {
      providers.add(AIProvider.claude);
    }

    return providers;
  }

  /// 获取当前有效的AI提供商
  AIProvider? getCurrentProvider() {
    final availableProviders = getAvailableProviders();

    if (availableProviders.contains(state.defaultProvider)) {
      return state.defaultProvider;
    }

    return availableProviders.isNotEmpty ? availableProviders.first : null;
  }

  /// 获取所有可用的模型
  List<ModelInfoWithProvider> getAllAvailableModels() {
    // 这个方法已被databaseAvailableModelsProvider替代
    return [];
  }

  /// 获取当前模型信息
  ModelInfoWithProvider? getCurrentModelInfo() {
    // 这个方法已被databaseCurrentModelProvider替代
    return null;
  }

  /// 切换模型
  Future<void> switchModel(String modelId) async {
    if (_database == null) return;

    // 从数据库查找目标模型
    final allConfigs = await _database.getEnabledLlmConfigs();

    for (final config in allConfigs) {
      final models = await _database.getCustomModelsByConfig(config.id);
      final targetModel = models.where((m) => m.modelId == modelId).firstOrNull;

      if (targetModel != null) {
        final provider = _stringToAIProvider(config.provider);
        if (provider != null) {
          // 更新默认提供商
          await updateDefaultProvider(provider);

          // 根据提供商更新相应的配置
          switch (provider) {
            case AIProvider.openai:
              if (state.openaiConfig != null) {
                await updateOpenAIConfig(
                  state.openaiConfig!.copyWith(defaultModel: modelId),
                );
              } else {
                // 如果没有AppSettings配置，创建一个基本配置
                await updateOpenAIConfig(
                  OpenAIConfig(apiKey: '', defaultModel: modelId),
                );
              }
              break;
            case AIProvider.gemini:
              if (state.geminiConfig != null) {
                await updateGeminiConfig(
                  state.geminiConfig!.copyWith(defaultModel: modelId),
                );
              } else {
                await updateGeminiConfig(
                  GeminiConfig(apiKey: '', defaultModel: modelId),
                );
              }
              break;
            case AIProvider.claude:
              if (state.claudeConfig != null) {
                await updateClaudeConfig(
                  state.claudeConfig!.copyWith(defaultModel: modelId),
                );
              } else {
                await updateClaudeConfig(
                  ClaudeConfig(apiKey: '', defaultModel: modelId),
                );
              }
              break;
          }

          // 不再手动invalidate，让依赖这些设置的provider自动重新计算
          break;
        }
      }
    }
  }
}

/// 设置Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  final database = ref.read(appDatabaseProvider);
  return SettingsNotifier(database: database);
});

/// 当前AI提供商Provider
final currentAIProviderProvider = Provider<AIProvider?>((ref) {
  final _ = ref.watch(settingsProvider);
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.getCurrentProvider();
});

/// 可用AI提供商Provider
final availableAIProvidersProvider = Provider<List<AIProvider>>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.getAvailableProviders();
});

/// 所有可用模型Provider
final allAvailableModelsProvider = Provider<List<ModelInfoWithProvider>>((ref) {
  final _ = ref.watch(settingsProvider);
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.getAllAvailableModels();
});

/// 当前模型信息Provider
final currentModelInfoProvider = Provider<ModelInfoWithProvider?>((ref) {
  final _ = ref.watch(settingsProvider);
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.getCurrentModelInfo();
});

/// OpenAI配置有效性Provider
final openaiConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateOpenAIConfig();
});

/// Gemini配置有效性Provider
final geminiConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateGeminiConfig();
});

/// Claude配置有效性Provider
final claudeConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateClaudeConfig();
});

/// 从数据库检查可用AI提供商Provider
final databaseAvailableProvidersProvider = FutureProvider<List<AIProvider>>((
  ref,
) async {
  final database = ref.watch(appDatabaseProvider);
  final configs = await database.getEnabledLlmConfigs();

  final providers = <AIProvider>[];
  for (final config in configs) {
    switch (config.provider) {
      case 'openai':
        if (!providers.contains(AIProvider.openai)) {
          providers.add(AIProvider.openai);
        }
        break;
      case 'gemini':
        if (!providers.contains(AIProvider.gemini)) {
          providers.add(AIProvider.gemini);
        }
        break;
      case 'claude':
        if (!providers.contains(AIProvider.claude)) {
          providers.add(AIProvider.claude);
        }
        break;
    }
  }

  return providers;
});

/// 从数据库检查所有可用模型Provider
final databaseAvailableModelsProvider =
    FutureProvider<List<ModelInfoWithProvider>>((ref) async {
      final database = ref.watch(appDatabaseProvider);

      // 获取所有启用的LLM配置
      final configs = await database.getEnabledLlmConfigs();
      if (configs.isEmpty) return [];

      final models = <ModelInfoWithProvider>[];

      // 获取每个配置下的模型
      for (final config in configs) {
        final configModels = await database.getCustomModelsByConfig(config.id);

        for (final modelData in configModels) {
          if (modelData.isEnabled) {
            final provider = _stringToAIProvider(config.provider);
            if (provider != null) {
              models.add(
                ModelInfoWithProvider(
                  id: modelData.modelId,
                  name: modelData.name,
                  provider: provider,
                  type: modelData.type,
                  description: modelData.description,
                  contextWindow: modelData.contextWindow,
                  maxOutputTokens: modelData.maxOutputTokens,
                  supportsStreaming: modelData.supportsStreaming,
                  supportsFunctionCalling: modelData.supportsFunctionCalling,
                  supportsVision: modelData.supportsVision,
                ),
              );
            }
          }
        }
      }

      return models;
    });

/// 辅助函数：字符串转AIProvider
AIProvider? _stringToAIProvider(String provider) {
  switch (provider.toLowerCase()) {
    case 'openai':
      return AIProvider.openai;
    case 'gemini':
    case 'google':
      return AIProvider.gemini;
    case 'claude':
    case 'anthropic':
      return AIProvider.claude;
    default:
      return null;
  }
}

/// 带提供商信息的模型信息类
class ModelInfoWithProvider {
  final String id;
  final String name;
  final AIProvider provider;
  final String type;
  final String? description;
  final int? contextWindow;
  final int? maxOutputTokens;
  final bool supportsStreaming;
  final bool supportsFunctionCalling;
  final bool supportsVision;

  const ModelInfoWithProvider({
    required this.id,
    required this.name,
    required this.provider,
    required this.type,
    this.description,
    this.contextWindow,
    this.maxOutputTokens,
    required this.supportsStreaming,
    required this.supportsFunctionCalling,
    required this.supportsVision,
  });

  String get providerName {
    switch (provider) {
      case AIProvider.openai:
        return 'OpenAI';
      case AIProvider.gemini:
        return 'Google';
      case AIProvider.claude:
        return 'Anthropic';
    }
  }
}

/// 从数据库检查当前AI提供商Provider
final databaseCurrentProviderProvider = FutureProvider<AIProvider?>((
  ref,
) async {
  final availableProviders = await ref.watch(
    databaseAvailableProvidersProvider.future,
  );
  final settings = ref.watch(settingsProvider);

  if (availableProviders.contains(settings.defaultProvider)) {
    return settings.defaultProvider;
  }

  return availableProviders.isNotEmpty ? availableProviders.first : null;
});

/// 从数据库检查当前模型信息Provider
final databaseCurrentModelProvider = FutureProvider<ModelInfoWithProvider?>((
  ref,
) async {
  final currentProvider = await ref.watch(
    databaseCurrentProviderProvider.future,
  );
  if (currentProvider == null) return null;

  final allModels = await ref.watch(databaseAvailableModelsProvider.future);
  final settings = ref.watch(settingsProvider);

  // 先尝试找到当前配置的默认模型
  String? defaultModel;
  switch (currentProvider) {
    case AIProvider.openai:
      defaultModel = settings.openaiConfig?.defaultModel;
      break;
    case AIProvider.gemini:
      defaultModel = settings.geminiConfig?.defaultModel;
      break;
    case AIProvider.claude:
      defaultModel = settings.claudeConfig?.defaultModel;
      break;
  }

  if (defaultModel != null) {
    final modelInfo = allModels
        .where((m) => m.provider == currentProvider && m.id == defaultModel)
        .firstOrNull;
    if (modelInfo != null) return modelInfo;
  }

  // 如果找不到默认模型，返回该提供商的第一个模型
  return allModels.where((m) => m.provider == currentProvider).firstOrNull;
});
