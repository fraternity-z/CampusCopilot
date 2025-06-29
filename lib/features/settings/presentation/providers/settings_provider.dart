import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../domain/entities/app_settings.dart';

/// 设置状态管理
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
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
  Future<void> updateThemeMode(String themeModeString) async {
    ThemeMode themeMode;
    switch (themeModeString) {
      case '浅色':
        themeMode = ThemeMode.light;
        break;
      case '深色':
        themeMode = ThemeMode.dark;
        break;
      case '跟随系统':
      default:
        themeMode = ThemeMode.system;
        break;
    }
    state = state.copyWith(themeMode: themeMode);
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

  /// 更新语言
  Future<void> updateLanguage(String languageCode) async {
    state = state.copyWith(language: languageCode);
    await _saveSettings();
  }

  /// 更新动画设置
  Future<void> updateEnableAnimations(bool enable) async {
    state = state.copyWith(enableAnimations: enable);
    await _saveSettings();
  }

  /// 重置所有设置
  Future<void> resetSettings() async {
    state = const AppSettings();
    await _saveSettings();
  }

  /// 清空API密钥
  Future<void> clearApiKeys() async {
    state = state.copyWith(
      openaiConfig: null,
      geminiConfig: null,
      claudeConfig: null,
    );
    await _saveSettings();
  }

  /// 验证OpenAI配置
  bool validateOpenAIConfig() {
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
}

/// 设置Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

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
