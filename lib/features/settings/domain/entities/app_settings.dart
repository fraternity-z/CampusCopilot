import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// 应用设置实体
///
/// 包含应用的所有配置信息
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// OpenAI API配置
    OpenAIConfig? openaiConfig,
    
    /// Google Gemini API配置
    GeminiConfig? geminiConfig,
    
    /// Anthropic Claude API配置
    ClaudeConfig? claudeConfig,
    
    /// 主题设置
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    /// 语言设置
    @Default('zh') String language,
    
    /// 默认AI提供商
    @Default(AIProvider.openai) AIProvider defaultProvider,
    
    /// 聊天设置
    @Default(ChatSettings()) ChatSettings chatSettings,
    
    /// 隐私设置
    @Default(PrivacySettings()) PrivacySettings privacySettings,
    
    /// 动画设置
    @Default(true) bool enableAnimations,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

/// OpenAI配置
@freezed
class OpenAIConfig with _$OpenAIConfig {
  const factory OpenAIConfig({
    /// API密钥
    required String apiKey,
    
    /// 基础URL（可选，用于代理）
    String? baseUrl,
    
    /// 默认模型
    @Default('gpt-3.5-turbo') String defaultModel,
    
    /// 组织ID（可选）
    String? organizationId,
  }) = _OpenAIConfig;

  factory OpenAIConfig.fromJson(Map<String, dynamic> json) =>
      _$OpenAIConfigFromJson(json);
}

/// Google Gemini配置
@freezed
class GeminiConfig with _$GeminiConfig {
  const factory GeminiConfig({
    /// API密钥
    required String apiKey,
    
    /// 默认模型
    @Default('gemini-pro') String defaultModel,
  }) = _GeminiConfig;

  factory GeminiConfig.fromJson(Map<String, dynamic> json) =>
      _$GeminiConfigFromJson(json);
}

/// Anthropic Claude配置
@freezed
class ClaudeConfig with _$ClaudeConfig {
  const factory ClaudeConfig({
    /// API密钥
    required String apiKey,
    
    /// 默认模型
    @Default('claude-3-sonnet-20240229') String defaultModel,
  }) = _ClaudeConfig;

  factory ClaudeConfig.fromJson(Map<String, dynamic> json) =>
      _$ClaudeConfigFromJson(json);
}

/// AI提供商枚举
enum AIProvider {
  openai,
  gemini,
  claude,
}

/// 主题模式枚举
enum ThemeMode {
  system,
  light,
  dark,
}

/// 聊天设置
@freezed
class ChatSettings with _$ChatSettings {
  const factory ChatSettings({
    /// 最大历史消息数
    @Default(50) int maxHistoryLength,
    
    /// 默认温度
    @Default(0.7) double temperature,
    
    /// 最大token数
    @Default(2048) int maxTokens,
    
    /// 是否启用流式响应
    @Default(true) bool enableStreaming,
    
    /// 是否自动保存聊天
    @Default(true) bool autoSaveChat,
  }) = _ChatSettings;

  factory ChatSettings.fromJson(Map<String, dynamic> json) =>
      _$ChatSettingsFromJson(json);
}

/// 隐私设置
@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    /// 是否启用数据收集
    @Default(false) bool enableDataCollection,
    
    /// 是否启用崩溃报告
    @Default(true) bool enableCrashReporting,
    
    /// 是否启用使用统计
    @Default(false) bool enableUsageStats,
    
    /// 数据保留天数
    @Default(30) int dataRetentionDays,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);
}
