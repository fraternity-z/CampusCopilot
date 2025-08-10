import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

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

      // 黑名单设置
      final blacklistEnabled =
          await _database.getSetting(
            GeneralSettingsKeys.searchBlacklistEnabled,
          ) ==
          'true';
      final blacklistRules = await _database.getSetting(
        GeneralSettingsKeys.searchBlacklistRules,
      );

      // 仅 direct 模式会用到 enabledEngines；默认不再强塞 duckduckgo
      List<String> engines = const [];
      try {
        final v = enabledEngines;
        if (v == null) {
          engines = const [];
        } else if (v is String) {
          final s = v.trim();
          if (s.isEmpty) {
            engines = const [];
          } else if (s.startsWith('[') && s.endsWith(']')) {
            // JSON 数组字符串
            final decoded = jsonDecode(s);
            if (decoded is List) {
              engines = decoded.map((e) => e.toString()).toList();
            }
          } else {
            // 逗号分隔
            engines = s
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        } else if (v is List) {
          engines = v.map((e) => e.toString()).toList();
        }
      } catch (e) {
        debugPrint('解析启用搜索引擎失败: $e');
        engines = const [];
      }

      state = SearchConfig(
        searchEnabled: searchEnabled,
        enabledEngines: engines,
        // defaultEngine 仅用于兼容旧字段；真实来源看 searchSource
        defaultEngine: defaultEngine ?? 'direct',
        apiKey: apiKey,
        maxResults: maxResults,
        timeoutSeconds: timeoutSeconds,
        language: language,
        region: region,
        safeSearch: safeSearch,
        blacklistEnabled: blacklistEnabled,
        blacklistRules: blacklistRules ?? '',
      );

      // 统一打印联网来源与启用引擎，避免误解
      final source = await _database.getSetting(
        GeneralSettingsKeys.searchSource,
      );
      final orchestrator = await _database.getSetting(
        GeneralSettingsKeys.searchOrchestratorEndpoint,
      );
      debugPrint(
        '✅ 搜索配置加载完成: 启用=${state.searchEnabled}, 来源=${source ?? state.defaultEngine}, 启用引擎=${state.enabledEngines}, 默认=${state.defaultEngine}, orchestrator=${orchestrator ?? ''}',
      );
    } catch (e) {
      debugPrint('❌ 加载搜索配置失败: $e');
    }
  }

  // ============ 新增：联网来源与 orchestrator、策略相关设置 ============
  Future<void> updateSearchSource(String source) async {
    try {
      await _database.setSetting(GeneralSettingsKeys.searchSource, source);
      // 维持兼容，默认引擎不变
      state = state; // 占位，UI 可通过 provider 获取 source
      debugPrint('✅ 联网来源已更新: $source');
    } catch (e) {
      debugPrint('❌ 更新联网来源失败: $e');
    }
  }

  // orchestrator 已弃用；保留空实现以兼容旧调用
  Future<void> updateOrchestratorEndpoint(String endpoint) async {
    debugPrint('ℹ️ orchestrator 已弃用，忽略设置: $endpoint');
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

  /// 更新黑名单开关
  Future<void> updateBlacklistEnabled(bool enabled) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchBlacklistEnabled,
        enabled.toString(),
      );
      state = state.copyWith(blacklistEnabled: enabled);
      debugPrint('✅ 搜索黑名单开关已更新: $enabled');
    } catch (e) {
      debugPrint('❌ 更新搜索黑名单开关失败: $e');
    }
  }

  /// 更新黑名单规则
  Future<void> updateBlacklistRules(String rules) async {
    try {
      await _database.setSetting(
        GeneralSettingsKeys.searchBlacklistRules,
        rules,
      );
      state = state.copyWith(blacklistRules: rules);
      debugPrint('✅ 搜索黑名单规则已更新');
    } catch (e) {
      debugPrint('❌ 更新搜索黑名单规则失败: $e');
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
