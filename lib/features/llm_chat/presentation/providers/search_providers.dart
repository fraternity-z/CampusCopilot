import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../settings/domain/entities/search_config.dart';
import '../../domain/services/ai_search_integration_service.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/tables/general_settings_table.dart';

/// 搜索配置Provider
final searchConfigProvider =
    StateNotifierProvider<SearchConfigNotifier, SearchConfig>((ref) {
      final database = ref.read(appDatabaseProvider);
      return SearchConfigNotifier(database);
    });

/// 搜索配置状态管理器
class SearchConfigNotifier extends StateNotifier<SearchConfig> {
  final dynamic _database;

  SearchConfigNotifier(this._database) : super(const SearchConfig()) {
    _loadConfig();
  }

  /// 加载搜索配置
  Future<void> _loadConfig() async {
    try {
      // 从数据库加载配置
      final searchEnabled =
          await _database.getSetting(GeneralSettingsKeys.searchEnabled) ==
          'true';
      final enabledEngines = await _database.getSetting(
        GeneralSettingsKeys.searchEnabledEngines,
      );
      final defaultEngine = await _database.getSetting(
        GeneralSettingsKeys.searchDefaultEngine,
      );
      final apiKey = await _database.getSetting(
        GeneralSettingsKeys.searchApiKey,
      );
      final maxResults =
          int.tryParse(
            await _database.getSetting(GeneralSettingsKeys.searchMaxResults) ??
                '5',
          ) ??
          5;
      final timeoutSeconds =
          int.tryParse(
            await _database.getSetting(
                  GeneralSettingsKeys.searchTimeoutSeconds,
                ) ??
                '10',
          ) ??
          10;
      final language =
          await _database.getSetting(GeneralSettingsKeys.searchLanguage) ??
          'zh-CN';
      final region =
          await _database.getSetting(GeneralSettingsKeys.searchRegion) ?? 'CN';
      final safeSearch =
          await _database.getSetting(GeneralSettingsKeys.searchSafeSearch) ==
          'true';

      List<String> engines = ['duckduckgo']; // 默认引擎
      if (enabledEngines != null && enabledEngines.isNotEmpty) {
        try {
          engines = enabledEngines.split(',').map((e) => e.trim()).toList();
        } catch (e) {
          debugPrint('解析启用搜索引擎失败: $e');
        }
      }

      state = SearchConfig(
        searchEnabled: searchEnabled,
        enabledEngines: engines,
        defaultEngine: defaultEngine ?? 'duckduckgo',
        apiKey: apiKey,
        maxResults: maxResults,
        timeoutSeconds: timeoutSeconds,
        language: language,
        region: region,
        safeSearch: safeSearch,
      );

      debugPrint(
        '✅ 搜索配置加载完成: 启用=${state.searchEnabled}, 引擎=${state.enabledEngines}',
      );
    } catch (e) {
      debugPrint('❌ 加载搜索配置失败: $e');
    }
  }

  /// 更新搜索启用状态
  Future<void> updateSearchEnabled(bool enabled) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchEnabled,
        enabled.toString(),
      );
      state = state.copyWith(searchEnabled: enabled);
      debugPrint('✅ 搜索启用状态已更新: $enabled');
    } catch (e) {
      debugPrint('❌ 更新搜索启用状态失败: $e');
    }
  }

  /// 更新启用的搜索引擎
  Future<void> updateEnabledEngines(List<String> engines) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchEnabledEngines,
        engines.join(','),
      );
      state = state.copyWith(enabledEngines: engines);
      debugPrint('✅ 启用搜索引擎已更新: $engines');
    } catch (e) {
      debugPrint('❌ 更新启用搜索引擎失败: $e');
    }
  }

  /// 更新默认搜索引擎
  Future<void> updateDefaultEngine(String engine) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchDefaultEngine,
        engine,
      );
      state = state.copyWith(defaultEngine: engine);
      debugPrint('✅ 默认搜索引擎已更新: $engine');
    } catch (e) {
      debugPrint('❌ 更新默认搜索引擎失败: $e');
    }
  }

  /// 更新API密钥
  Future<void> updateApiKey(String? apiKey) async {
    try {
      if (apiKey != null) {
        await _database.setSetting(GeneralSettingsKeys.searchApiKey, apiKey);
      } else {
        await _database.deleteSetting(GeneralSettingsKeys.searchApiKey);
      }
      state = state.copyWith(apiKey: apiKey);
      debugPrint('✅ 搜索API密钥已更新');
    } catch (e) {
      debugPrint('❌ 更新搜索API密钥失败: $e');
    }
  }

  /// 更新最大结果数
  Future<void> updateMaxResults(int maxResults) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchMaxResults,
        maxResults.toString(),
      );
      state = state.copyWith(maxResults: maxResults);
      debugPrint('✅ 搜索最大结果数已更新: $maxResults');
    } catch (e) {
      debugPrint('❌ 更新搜索最大结果数失败: $e');
    }
  }

  /// 更新超时时间
  Future<void> updateTimeoutSeconds(int timeoutSeconds) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchTimeoutSeconds,
        timeoutSeconds.toString(),
      );
      state = state.copyWith(timeoutSeconds: timeoutSeconds);
      debugPrint('✅ 搜索超时时间已更新: $timeoutSeconds');
    } catch (e) {
      debugPrint('❌ 更新搜索超时时间失败: $e');
    }
  }

  /// 更新搜索语言
  Future<void> updateLanguage(String language) async {
    try {
      await _database.setSetting(GeneralSettingsKeys.searchLanguage, language);
      state = state.copyWith(language: language);
      debugPrint('✅ 搜索语言已更新: $language');
    } catch (e) {
      debugPrint('❌ 更新搜索语言失败: $e');
    }
  }

  /// 更新搜索地区
  Future<void> updateRegion(String region) async {
    try {
      await _database.setSetting(GeneralSettingsKeys.searchRegion, region);
      state = state.copyWith(region: region);
      debugPrint('✅ 搜索地区已更新: $region');
    } catch (e) {
      debugPrint('❌ 更新搜索地区失败: $e');
    }
  }

  /// 更新安全搜索
  Future<void> updateSafeSearch(bool safeSearch) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchSafeSearch,
        safeSearch.toString(),
      );
      state = state.copyWith(safeSearch: safeSearch);
      debugPrint('✅ 安全搜索已更新: $safeSearch');
    } catch (e) {
      debugPrint('❌ 更新安全搜索失败: $e');
    }
  }

  /// 重置配置为默认值
  Future<void> resetToDefaults() async {
    try {
      const defaultConfig = SearchConfig();

      await _database.setSetting(
        GeneralSettingsKeys.searchEnabled,
        defaultConfig.searchEnabled.toString(),
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchEnabledEngines,
        defaultConfig.enabledEngines.join(','),
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchDefaultEngine,
        defaultConfig.defaultEngine,
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchMaxResults,
        defaultConfig.maxResults.toString(),
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchTimeoutSeconds,
        defaultConfig.timeoutSeconds.toString(),
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchLanguage,
        defaultConfig.language,
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchRegion,
        defaultConfig.region,
      );
      await _database.setSetting(
        GeneralSettingsKeys.searchSafeSearch,
        defaultConfig.safeSearch.toString(),
      );

      state = defaultConfig;
      debugPrint('✅ 搜索配置已重置为默认值');
    } catch (e) {
      debugPrint('❌ 重置搜索配置失败: $e');
    }
  }
}

/// AI搜索集成服务Provider
final aiSearchIntegrationProvider = Provider<AISearchIntegrationService>((ref) {
  return AISearchIntegrationService();
});

/// 可用搜索引擎列表Provider
final availableSearchEnginesProvider = Provider<List<Map<String, String>>>((
  ref,
) {
  return [
    {
      'id': 'tavily',
      'name': 'Tavily',
      'description': 'AI驱动的高质量搜索引擎，需要API密钥',
      'requiresApiKey': 'true',
      'icon': '🤖',
    },
    {
      'id': 'duckduckgo',
      'name': 'DuckDuckGo',
      'description': '隐私友好的搜索引擎，无需API密钥',
      'requiresApiKey': 'false',
      'icon': '🦆',
    },
    {
      'id': 'google',
      'name': 'Google',
      'description': 'Google自定义搜索，需要API密钥',
      'requiresApiKey': 'true',
      'icon': '🔍',
    },
    {
      'id': 'bing',
      'name': 'Bing',
      'description': 'Microsoft Bing搜索，需要API密钥',
      'requiresApiKey': 'true',
      'icon': '🔎',
    },
  ];
});

/// 搜索语言选项Provider
final searchLanguageOptionsProvider = Provider<List<Map<String, String>>>((
  ref,
) {
  return [
    {'code': 'zh-CN', 'name': '中文（简体）'},
    {'code': 'zh-TW', 'name': '中文（繁体）'},
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'en-GB', 'name': 'English (UK)'},
    {'code': 'ja-JP', 'name': '日本語'},
    {'code': 'ko-KR', 'name': '한국어'},
    {'code': 'fr-FR', 'name': 'Français'},
    {'code': 'de-DE', 'name': 'Deutsch'},
    {'code': 'es-ES', 'name': 'Español'},
    {'code': 'pt-PT', 'name': 'Português'},
    {'code': 'ru-RU', 'name': 'Русский'},
    {'code': 'ar-SA', 'name': 'العربية'},
  ];
});

/// 搜索地区选项Provider
final searchRegionOptionsProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {'code': 'CN', 'name': '中国'},
    {'code': 'US', 'name': '美国'},
    {'code': 'GB', 'name': '英国'},
    {'code': 'JP', 'name': '日本'},
    {'code': 'KR', 'name': '韩国'},
    {'code': 'DE', 'name': '德国'},
    {'code': 'FR', 'name': '法国'},
    {'code': 'ES', 'name': '西班牙'},
    {'code': 'IT', 'name': '意大利'},
    {'code': 'AU', 'name': '澳大利亚'},
    {'code': 'CA', 'name': '加拿大'},
    {'code': 'IN', 'name': '印度'},
  ];
});
