// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      openaiConfig: json['openaiConfig'] == null
          ? null
          : OpenAIConfig.fromJson(json['openaiConfig'] as Map<String, dynamic>),
      geminiConfig: json['geminiConfig'] == null
          ? null
          : GeminiConfig.fromJson(json['geminiConfig'] as Map<String, dynamic>),
      claudeConfig: json['claudeConfig'] == null
          ? null
          : ClaudeConfig.fromJson(json['claudeConfig'] as Map<String, dynamic>),
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      language: json['language'] as String? ?? 'zh',
      defaultProvider:
          $enumDecodeNullable(_$AIProviderEnumMap, json['defaultProvider']) ??
              AIProvider.openai,
      chatSettings: json['chatSettings'] == null
          ? const ChatSettings()
          : ChatSettings.fromJson(json['chatSettings'] as Map<String, dynamic>),
      privacySettings: json['privacySettings'] == null
          ? const PrivacySettings()
          : PrivacySettings.fromJson(
              json['privacySettings'] as Map<String, dynamic>),
      enableAnimations: json['enableAnimations'] as bool? ?? true,
      thinkingChainSettings: json['thinkingChainSettings'] == null
          ? const ThinkingChainSettings()
          : ThinkingChainSettings.fromJson(
              json['thinkingChainSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'openaiConfig': instance.openaiConfig,
      'geminiConfig': instance.geminiConfig,
      'claudeConfig': instance.claudeConfig,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'language': instance.language,
      'defaultProvider': _$AIProviderEnumMap[instance.defaultProvider]!,
      'chatSettings': instance.chatSettings,
      'privacySettings': instance.privacySettings,
      'enableAnimations': instance.enableAnimations,
      'thinkingChainSettings': instance.thinkingChainSettings,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AIProviderEnumMap = {
  AIProvider.openai: 'openai',
  AIProvider.gemini: 'gemini',
  AIProvider.claude: 'claude',
  AIProvider.deepseek: 'deepseek',
  AIProvider.qwen: 'qwen',
  AIProvider.openrouter: 'openrouter',
  AIProvider.ollama: 'ollama',
};

_$OpenAIConfigImpl _$$OpenAIConfigImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIConfigImpl(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      defaultModel: json['defaultModel'] as String? ?? 'gpt-3.5-turbo',
      organizationId: json['organizationId'] as String?,
    );

Map<String, dynamic> _$$OpenAIConfigImplToJson(_$OpenAIConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
      'organizationId': instance.organizationId,
    };

_$GeminiConfigImpl _$$GeminiConfigImplFromJson(Map<String, dynamic> json) =>
    _$GeminiConfigImpl(
      apiKey: json['apiKey'] as String,
      defaultModel: json['defaultModel'] as String? ?? 'gemini-pro',
    );

Map<String, dynamic> _$$GeminiConfigImplToJson(_$GeminiConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'defaultModel': instance.defaultModel,
    };

_$ClaudeConfigImpl _$$ClaudeConfigImplFromJson(Map<String, dynamic> json) =>
    _$ClaudeConfigImpl(
      apiKey: json['apiKey'] as String,
      defaultModel:
          json['defaultModel'] as String? ?? 'claude-3-sonnet-20240229',
    );

Map<String, dynamic> _$$ClaudeConfigImplToJson(_$ClaudeConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'defaultModel': instance.defaultModel,
    };

_$ChatSettingsImpl _$$ChatSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ChatSettingsImpl(
      maxHistoryLength: (json['maxHistoryLength'] as num?)?.toInt() ?? 50,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 2048,
      enableStreaming: json['enableStreaming'] as bool? ?? true,
      autoSaveChat: json['autoSaveChat'] as bool? ?? true,
      enableRag: json['enableRag'] as bool? ?? true,
    );

Map<String, dynamic> _$$ChatSettingsImplToJson(_$ChatSettingsImpl instance) =>
    <String, dynamic>{
      'maxHistoryLength': instance.maxHistoryLength,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'enableStreaming': instance.enableStreaming,
      'autoSaveChat': instance.autoSaveChat,
      'enableRag': instance.enableRag,
    };

_$PrivacySettingsImpl _$$PrivacySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacySettingsImpl(
      enableDataCollection: json['enableDataCollection'] as bool? ?? false,
      enableCrashReporting: json['enableCrashReporting'] as bool? ?? true,
      enableUsageStats: json['enableUsageStats'] as bool? ?? false,
      dataRetentionDays: (json['dataRetentionDays'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$PrivacySettingsImplToJson(
        _$PrivacySettingsImpl instance) =>
    <String, dynamic>{
      'enableDataCollection': instance.enableDataCollection,
      'enableCrashReporting': instance.enableCrashReporting,
      'enableUsageStats': instance.enableUsageStats,
      'dataRetentionDays': instance.dataRetentionDays,
    };

_$ThinkingChainSettingsImpl _$$ThinkingChainSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ThinkingChainSettingsImpl(
      showThinkingChain: json['showThinkingChain'] as bool? ?? true,
      animationSpeed: (json['animationSpeed'] as num?)?.toInt() ?? 50,
      enableAnimation: json['enableAnimation'] as bool? ?? true,
      maxDisplayLength: (json['maxDisplayLength'] as num?)?.toInt() ?? 2000,
      autoCollapseOnLongContent:
          json['autoCollapseOnLongContent'] as bool? ?? true,
      enableGeminiSpecialHandling:
          json['enableGeminiSpecialHandling'] as bool? ?? true,
    );

Map<String, dynamic> _$$ThinkingChainSettingsImplToJson(
        _$ThinkingChainSettingsImpl instance) =>
    <String, dynamic>{
      'showThinkingChain': instance.showThinkingChain,
      'animationSpeed': instance.animationSpeed,
      'enableAnimation': instance.enableAnimation,
      'maxDisplayLength': instance.maxDisplayLength,
      'autoCollapseOnLongContent': instance.autoCollapseOnLongContent,
      'enableGeminiSpecialHandling': instance.enableGeminiSpecialHandling,
    };
