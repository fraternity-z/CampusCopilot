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
      openaiResponsesConfig: json['openaiResponsesConfig'] == null
          ? null
          : OpenAIResponsesConfig.fromJson(
              json['openaiResponsesConfig'] as Map<String, dynamic>),
      geminiConfig: json['geminiConfig'] == null
          ? null
          : GeminiConfig.fromJson(json['geminiConfig'] as Map<String, dynamic>),
      claudeConfig: json['claudeConfig'] == null
          ? null
          : ClaudeConfig.fromJson(json['claudeConfig'] as Map<String, dynamic>),
      deepseekConfig: json['deepseekConfig'] == null
          ? null
          : DeepSeekConfig.fromJson(
              json['deepseekConfig'] as Map<String, dynamic>),
      qwenConfig: json['qwenConfig'] == null
          ? null
          : QwenConfig.fromJson(json['qwenConfig'] as Map<String, dynamic>),
      openrouterConfig: json['openrouterConfig'] == null
          ? null
          : OpenRouterConfig.fromJson(
              json['openrouterConfig'] as Map<String, dynamic>),
      ollamaConfig: json['ollamaConfig'] == null
          ? null
          : OllamaConfig.fromJson(json['ollamaConfig'] as Map<String, dynamic>),
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
      thinkingChainSettings: json['thinkingChainSettings'] == null
          ? const ThinkingChainSettings()
          : ThinkingChainSettings.fromJson(
              json['thinkingChainSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'openaiConfig': instance.openaiConfig,
      'openaiResponsesConfig': instance.openaiResponsesConfig,
      'geminiConfig': instance.geminiConfig,
      'claudeConfig': instance.claudeConfig,
      'deepseekConfig': instance.deepseekConfig,
      'qwenConfig': instance.qwenConfig,
      'openrouterConfig': instance.openrouterConfig,
      'ollamaConfig': instance.ollamaConfig,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'language': instance.language,
      'defaultProvider': _$AIProviderEnumMap[instance.defaultProvider]!,
      'chatSettings': instance.chatSettings,
      'privacySettings': instance.privacySettings,
      'thinkingChainSettings': instance.thinkingChainSettings,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AIProviderEnumMap = {
  AIProvider.openai: 'openai',
  AIProvider.openaiResponses: 'openaiResponses',
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

_$OpenAIResponsesConfigImpl _$$OpenAIResponsesConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenAIResponsesConfigImpl(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      organizationId: json['organizationId'] as String?,
      defaultModel: json['defaultModel'] as String? ?? 'gpt-4o',
      enableWebSearch: json['enableWebSearch'] as bool? ?? false,
      reasoningEffort: json['reasoningEffort'] as String?,
      maxReasoningTokens: (json['maxReasoningTokens'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OpenAIResponsesConfigImplToJson(
        _$OpenAIResponsesConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'organizationId': instance.organizationId,
      'defaultModel': instance.defaultModel,
      'enableWebSearch': instance.enableWebSearch,
      'reasoningEffort': instance.reasoningEffort,
      'maxReasoningTokens': instance.maxReasoningTokens,
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
      baseUrl: json['baseUrl'] as String?,
      defaultModel:
          json['defaultModel'] as String? ?? 'claude-3-sonnet-20240229',
    );

Map<String, dynamic> _$$ClaudeConfigImplToJson(_$ClaudeConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
    };

_$DeepSeekConfigImpl _$$DeepSeekConfigImplFromJson(Map<String, dynamic> json) =>
    _$DeepSeekConfigImpl(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      defaultModel: json['defaultModel'] as String? ?? 'deepseek-chat',
    );

Map<String, dynamic> _$$DeepSeekConfigImplToJson(
        _$DeepSeekConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
    };

_$QwenConfigImpl _$$QwenConfigImplFromJson(Map<String, dynamic> json) =>
    _$QwenConfigImpl(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      defaultModel: json['defaultModel'] as String? ?? 'qwen-turbo',
    );

Map<String, dynamic> _$$QwenConfigImplToJson(_$QwenConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
    };

_$OpenRouterConfigImpl _$$OpenRouterConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$OpenRouterConfigImpl(
      apiKey: json['apiKey'] as String,
      baseUrl: json['baseUrl'] as String?,
      defaultModel: json['defaultModel'] as String? ??
          'meta-llama/llama-3.1-8b-instruct:free',
    );

Map<String, dynamic> _$$OpenRouterConfigImplToJson(
        _$OpenRouterConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
    };

_$OllamaConfigImpl _$$OllamaConfigImplFromJson(Map<String, dynamic> json) =>
    _$OllamaConfigImpl(
      apiKey: json['apiKey'] as String? ?? '',
      baseUrl: json['baseUrl'] as String? ?? 'http://localhost:11434/v1',
      defaultModel: json['defaultModel'] as String? ?? 'llama3.2',
    );

Map<String, dynamic> _$$OllamaConfigImplToJson(_$OllamaConfigImpl instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'baseUrl': instance.baseUrl,
      'defaultModel': instance.defaultModel,
    };

_$ChatSettingsImpl _$$ChatSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ChatSettingsImpl(
      maxHistoryLength: (json['maxHistoryLength'] as num?)?.toInt() ?? 50,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 2048,
      enableStreaming: json['enableStreaming'] as bool? ?? true,
      autoSaveChat: json['autoSaveChat'] as bool? ?? true,
      enableRag: json['enableRag'] as bool? ?? false,
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
