import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/app_settings.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/theme/color_theme.dart';
import 'custom_provider_notifier.dart';

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


  /// 更新Claude配置
  Future<void> updateClaudeConfig(ClaudeConfig config) async {
    state = state.copyWith(claudeConfig: config);
    await _saveSettings();
  }

  /// 更新Gemini配置
  Future<void> updateGeminiConfig(GeminiConfig config) async {
    state = state.copyWith(geminiConfig: config);
    await _saveSettings();
  }

  /// 更新DeepSeek配置
  Future<void> updateDeepSeekConfig(DeepSeekConfig config) async {
    state = state.copyWith(deepseekConfig: config);
    await _saveSettings();
  }

  /// 更新Qwen配置
  Future<void> updateQwenConfig(QwenConfig config) async {
    state = state.copyWith(qwenConfig: config);
    await _saveSettings();
  }

  /// 更新OpenRouter配置
  Future<void> updateOpenRouterConfig(OpenRouterConfig config) async {
    state = state.copyWith(openrouterConfig: config);
    await _saveSettings();
  }

  /// 更新Ollama配置
  Future<void> updateOllamaConfig(OllamaConfig config) async {
    state = state.copyWith(ollamaConfig: config);
    await _saveSettings();
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _saveSettings();
  }

  /// 更新颜色主题
  Future<void> updateColorTheme(AppColorTheme colorTheme) async {
    state = state.copyWith(colorTheme: colorTheme);
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


  /// 更新思考链设置
  Future<void> updateThinkingChainSettings(
    ThinkingChainSettings thinkingChainSettings,
  ) async {
    state = state.copyWith(thinkingChainSettings: thinkingChainSettings);
    await _saveSettings();
  }

  /// 更新RAG设置
  Future<void> updateRagEnabled(bool enabled) async {
    final updatedChatSettings = state.chatSettings.copyWith(enableRag: enabled);
    state = state.copyWith(chatSettings: updatedChatSettings);
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

  /// 验证OpenAI Responses配置

  /// 验证Claude配置
  bool validateClaudeConfig() {
    final config = state.claudeConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证Gemini配置
  bool validateGeminiConfig() {
    final config = state.geminiConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证DeepSeek配置
  bool validateDeepSeekConfig() {
    final config = state.deepseekConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证Qwen配置
  bool validateQwenConfig() {
    final config = state.qwenConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证OpenRouter配置
  bool validateOpenRouterConfig() {
    final config = state.openrouterConfig;
    return config != null && config.apiKey.isNotEmpty;
  }

  /// 验证Ollama配置
  bool validateOllamaConfig() {
    final config = state.ollamaConfig;
    return config != null; // Ollama不一定需要API密钥
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
    if (validateDeepSeekConfig()) {
      providers.add(AIProvider.deepseek);
    }
    if (validateQwenConfig()) {
      providers.add(AIProvider.qwen);
    }
    if (validateOpenRouterConfig()) {
      providers.add(AIProvider.openrouter);
    }
    if (validateOllamaConfig()) {
      providers.add(AIProvider.ollama);
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

    // 标记是否已切换
    var switched = false;

    // 获取所有启用的LLM配置
    final allConfigs = await _database.getEnabledLlmConfigs();

    for (final config in allConfigs) {
      // 先按configId查找模型
      var models = await _database.getCustomModelsByConfig(config.id);

      // 若未找到，再按provider查找（旧数据或未绑定configId）
      if (models.isEmpty) {
        models = await _database.getCustomModelsByProvider(config.provider);
      }

      final targetModel = models.where((m) => m.modelId == modelId).firstOrNull;
      if (targetModel == null) continue;

      final provider = _stringToAIProvider(config.provider);
      if (provider == null) continue;

      // 首先更新数据库中的默认模型
      final updatedConfig = LlmConfigsTableCompanion(
        id: Value(config.id),
        name: Value(config.name),
        provider: Value(config.provider),
        apiKey: Value(config.apiKey),
        baseUrl: Value(config.baseUrl),
        defaultModel: Value(modelId),
        defaultEmbeddingModel: Value(config.defaultEmbeddingModel),
        organizationId: Value(config.organizationId),
        projectId: Value(config.projectId),
        extraParams: Value(config.extraParams),
        createdAt: Value(config.createdAt),
        updatedAt: Value(DateTime.now()),
        isEnabled: Value(config.isEnabled),
        isCustomProvider: Value(config.isCustomProvider),
        apiCompatibilityType: Value(config.apiCompatibilityType),
        customProviderName: Value(config.customProviderName),
        customProviderDescription: Value(config.customProviderDescription),
        customProviderIcon: Value(config.customProviderIcon),
      );
      await _database.upsertLlmConfig(updatedConfig);

      // 批量更新AppSettings，避免多次状态更新
      AppSettings updatedState = state.copyWith(defaultProvider: provider);

      // 同步到AppSettings - 批量更新避免多次状态通知
      switch (provider) {
        case AIProvider.openai:
          updatedState = updatedState.copyWith(
            openaiConfig: updatedState.openaiConfig != null
                ? updatedState.openaiConfig!.copyWith(defaultModel: modelId)
                : OpenAIConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.gemini:
          updatedState = updatedState.copyWith(
            geminiConfig: updatedState.geminiConfig != null
                ? updatedState.geminiConfig!.copyWith(defaultModel: modelId)
                : GeminiConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.claude:
          updatedState = updatedState.copyWith(
            claudeConfig: updatedState.claudeConfig != null
                ? updatedState.claudeConfig!.copyWith(defaultModel: modelId)
                : ClaudeConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.deepseek:
          updatedState = updatedState.copyWith(
            deepseekConfig: updatedState.deepseekConfig != null
                ? updatedState.deepseekConfig!.copyWith(defaultModel: modelId)
                : DeepSeekConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.qwen:
          updatedState = updatedState.copyWith(
            qwenConfig: updatedState.qwenConfig != null
                ? updatedState.qwenConfig!.copyWith(defaultModel: modelId)
                : QwenConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.openrouter:
          updatedState = updatedState.copyWith(
            openrouterConfig: updatedState.openrouterConfig != null
                ? updatedState.openrouterConfig!.copyWith(defaultModel: modelId)
                : OpenRouterConfig(apiKey: '', defaultModel: modelId),
          );
          break;
        case AIProvider.ollama:
          updatedState = updatedState.copyWith(
            ollamaConfig: updatedState.ollamaConfig != null
                ? updatedState.ollamaConfig!.copyWith(defaultModel: modelId)
                : OllamaConfig(defaultModel: modelId),
          );
          break;
      }

      // 先更新状态
      state = updatedState;
      
      // 保存设置
      await _saveSettings();

      debugPrint('✅ 已切换模型到: $modelId (${config.provider})');
      switched = true;
    }

    if (!switched) {
      debugPrint('⚠️ 未找到模型 $modelId 对应的LLM配置，请检查数据库或配置');
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

/// OpenAI Responses配置有效性Provider

/// Claude配置有效性Provider
final claudeConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateClaudeConfig();
});

/// Gemini配置有效性Provider
final geminiConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateGeminiConfig();
});

/// DeepSeek配置有效性Provider
final deepseekConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateDeepSeekConfig();
});

/// Qwen配置有效性Provider
final qwenConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateQwenConfig();
});

/// OpenRouter配置有效性Provider
final openrouterConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateOpenRouterConfig();
});

/// Ollama配置有效性Provider
final ollamaConfigValidProvider = Provider<bool>((ref) {
  final notifier = ref.read(settingsProvider.notifier);
  return notifier.validateOllamaConfig();
});

/// 从数据库检查可用AI提供商Provider
final databaseAvailableProvidersProvider = FutureProvider<List<AIProvider>>((
  ref,
) async {
  final database = ref.watch(appDatabaseProvider);
  final configs = await database.getEnabledLlmConfigs();

  final providers = <AIProvider>[];
  for (final config in configs) {
    // 跳过自定义提供商，它们有单独的管理
    if (config.isCustomProvider) continue;

    switch (config.provider) {
      case 'openai':
        if (!providers.contains(AIProvider.openai)) {
          providers.add(AIProvider.openai);
        }
        break;
      case 'claude':
      case 'anthropic':
        if (!providers.contains(AIProvider.claude)) {
          providers.add(AIProvider.claude);
        }
        break;
      case 'google':
        if (!providers.contains(AIProvider.gemini)) {
          providers.add(AIProvider.gemini);
        }
        break;
      case 'deepseek':
        if (!providers.contains(AIProvider.deepseek)) {
          providers.add(AIProvider.deepseek);
        }
        break;
      case 'qwen':
        if (!providers.contains(AIProvider.qwen)) {
          providers.add(AIProvider.qwen);
        }
        break;
      case 'openrouter':
        if (!providers.contains(AIProvider.openrouter)) {
          providers.add(AIProvider.openrouter);
        }
        break;
      case 'ollama':
        if (!providers.contains(AIProvider.ollama)) {
          providers.add(AIProvider.ollama);
        }
        break;
    }
  }

  return providers;
});

/// 所有可用提供商（包括内置和自定义）Provider
final allAvailableProvidersProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  // 获取内置提供商
  final builtinProviders = await ref.watch(
    databaseAvailableProvidersProvider.future,
  );

  // 获取自定义提供商
  final customProviders = ref.watch(enabledCustomProvidersProvider);

  return {'builtin': builtinProviders, 'custom': customProviders};
});

/// 模型列表刷新触发器
final modelListRefreshProvider = StateProvider<int>((ref) => 0);

/// 从数据库检查所有可用模型Provider
final databaseAvailableModelsProvider =
    FutureProvider<List<ModelInfoWithProvider>>((ref) async {
      final database = ref.watch(appDatabaseProvider);
      // 监听刷新触发器，当触发器变化时重新获取数据
      ref.watch(modelListRefreshProvider);

      // 获取所有启用的LLM配置
      final configs = await database.getEnabledLlmConfigs();
      if (configs.isEmpty) return [];

      final models = <ModelInfoWithProvider>[];
      // 使用 set 去重：provider + modelId
      final Set<String> seen = {};

      // 获取每个配置下的模型
      for (final config in configs) {
        // 优先按 configId 关联查找
        var configModels = await database.getCustomModelsByConfig(config.id);

        // 兼容旧数据或“先刷新模型后保存配置”的情况：
        // 如果没有绑定 configId 的模型，则按 provider 回退查询
        if (configModels.isEmpty) {
          final fallback = await database.getCustomModelsByProvider(
            config.provider,
          );
          configModels = fallback;
        }

        for (final modelData in configModels) {
          if (!modelData.isEnabled) continue;
          final provider = _stringToAIProvider(config.provider);
          if (provider == null) continue;

          final dedupKey =
              '${config.provider.toLowerCase()}::${modelData.modelId}';
          if (seen.contains(dedupKey)) continue;
          seen.add(dedupKey);

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

      // 兜底：若仍为空，直接读取所有启用模型（兼容异常配置或遗留数据）
      if (models.isEmpty) {
        final all = await database.getAllCustomModels();
        for (final m in all) {
          if (!m.isEnabled) continue;
          final provider = _stringToAIProvider(m.provider);
          if (provider == null) continue;

          final dedupKey = '${m.provider.toLowerCase()}::${m.modelId}';
          if (seen.contains(dedupKey)) continue;
          seen.add(dedupKey);

          models.add(
            ModelInfoWithProvider(
              id: m.modelId,
              name: m.name,
              provider: provider,
              type: m.type,
              description: m.description,
              contextWindow: m.contextWindow,
              maxOutputTokens: m.maxOutputTokens,
              supportsStreaming: m.supportsStreaming,
              supportsFunctionCalling: m.supportsFunctionCalling,
              supportsVision: m.supportsVision,
            ),
          );
        }
      }

      return models;
    });

/// 从数据库检查聊天可用模型Provider（过滤掉嵌入模型）
final databaseChatModelsProvider = FutureProvider<List<ModelInfoWithProvider>>((
  ref,
) async {
  final allModels = await ref.watch(databaseAvailableModelsProvider.future);

  // 过滤出适合聊天的模型
  return allModels.where((model) {
    // 排除嵌入模型类型
    if (model.type.toLowerCase() == 'embedding') {
      return false;
    }

    // 排除名称或ID中包含 "embedding" 的模型（不区分大小写）
    final nameContainsEmbedding = model.name.toLowerCase().contains(
      'embedding',
    );
    final idContainsEmbedding = model.id.toLowerCase().contains('embedding');

    if (nameContainsEmbedding || idContainsEmbedding) {
      return false;
    }

    // 只保留聊天相关的模型类型
    final chatTypes = ['chat', 'multimodal', 'text', 'completion'];
    return chatTypes.contains(model.type.toLowerCase());
  }).toList();
});

/// 辅助函数：字符串转AIProvider
AIProvider? _stringToAIProvider(String provider) {
  switch (provider.toLowerCase()) {
    case 'openai':
      return AIProvider.openai;
    case 'claude':
    case 'anthropic':
      return AIProvider.claude;
    case 'google':
      return AIProvider.gemini;
    case 'deepseek':
      return AIProvider.deepseek;
    case 'qwen':
      return AIProvider.qwen;
    case 'openrouter':
      return AIProvider.openrouter;
    case 'ollama':
      return AIProvider.ollama;
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
      case AIProvider.claude:
        return 'Anthropic';
      case AIProvider.gemini:
        return 'Google Gemini';
      case AIProvider.deepseek:
        return 'DeepSeek';
      case AIProvider.qwen:
        return '阿里云通义千问';
      case AIProvider.openrouter:
        return 'OpenRouter';
      case AIProvider.ollama:
        return 'Ollama';
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

  final allModels = await ref.watch(databaseChatModelsProvider.future);
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
    case AIProvider.deepseek:
      defaultModel = settings.deepseekConfig?.defaultModel;
      break;
    case AIProvider.qwen:
      defaultModel = settings.qwenConfig?.defaultModel;
      break;
    case AIProvider.openrouter:
      defaultModel = settings.openrouterConfig?.defaultModel;
      break;
    case AIProvider.ollama:
      defaultModel = settings.ollamaConfig?.defaultModel;
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
