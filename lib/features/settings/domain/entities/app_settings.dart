import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/theme/color_theme.dart';

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

    /// DeepSeek API配置
    DeepSeekConfig? deepseekConfig,

    /// 阿里云通义千问 API配置
    QwenConfig? qwenConfig,

    /// OpenRouter API配置
    OpenRouterConfig? openrouterConfig,

    /// Ollama API配置
    OllamaConfig? ollamaConfig,

    /// 主题设置
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// 颜色主题设置
    @Default(AppColorTheme.purple) AppColorTheme colorTheme,

    /// 语言设置
    @Default('zh') String language,

    /// 默认AI提供商
    @Default(AIProvider.openai) AIProvider defaultProvider,

    /// 聊天设置
    @Default(ChatSettings()) ChatSettings chatSettings,

    /// 隐私设置
    @Default(PrivacySettings()) PrivacySettings privacySettings,

    /// 思考链设置
    @Default(ThinkingChainSettings())
    ThinkingChainSettings thinkingChainSettings,
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

    /// 基础URL（可选，用于代理）
    String? baseUrl,

    /// 默认模型
    @Default('claude-3-sonnet-20240229') String defaultModel,
  }) = _ClaudeConfig;

  factory ClaudeConfig.fromJson(Map<String, dynamic> json) =>
      _$ClaudeConfigFromJson(json);
}

/// DeepSeek配置
@freezed
class DeepSeekConfig with _$DeepSeekConfig {
  const factory DeepSeekConfig({
    /// API密钥
    required String apiKey,

    /// 基础URL（可选，用于代理）
    String? baseUrl,

    /// 默认模型
    @Default('deepseek-chat') String defaultModel,
  }) = _DeepSeekConfig;

  factory DeepSeekConfig.fromJson(Map<String, dynamic> json) =>
      _$DeepSeekConfigFromJson(json);
}

/// 阿里云通义千问配置
@freezed
class QwenConfig with _$QwenConfig {
  const factory QwenConfig({
    /// API密钥
    required String apiKey,

    /// 基础URL（可选，用于代理）
    String? baseUrl,

    /// 默认模型
    @Default('qwen-turbo') String defaultModel,
  }) = _QwenConfig;

  factory QwenConfig.fromJson(Map<String, dynamic> json) =>
      _$QwenConfigFromJson(json);
}

/// OpenRouter配置
@freezed
class OpenRouterConfig with _$OpenRouterConfig {
  const factory OpenRouterConfig({
    /// API密钥
    required String apiKey,

    /// 基础URL（可选，用于代理）
    String? baseUrl,

    /// 默认模型
    @Default('meta-llama/llama-3.1-8b-instruct:free') String defaultModel,
  }) = _OpenRouterConfig;

  factory OpenRouterConfig.fromJson(Map<String, dynamic> json) =>
      _$OpenRouterConfigFromJson(json);
}

/// Ollama配置
@freezed
class OllamaConfig with _$OllamaConfig {
  const factory OllamaConfig({
    /// API密钥（Ollama通常不需要，但保持一致性）
    @Default('') String apiKey,

    /// 基础URL（Ollama服务地址）
    @Default('http://localhost:11434/v1') String? baseUrl,

    /// 默认模型
    @Default('llama3.2') String defaultModel,
  }) = _OllamaConfig;

  factory OllamaConfig.fromJson(Map<String, dynamic> json) =>
      _$OllamaConfigFromJson(json);
}

/// AI提供商枚举
enum AIProvider {
  openai,
  gemini,
  claude,
  deepseek,
  qwen,
  openrouter,
  ollama,
}

/// 主题模式枚举
enum ThemeMode { system, light, dark }

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

    /// 是否启用RAG知识库增强
    @Default(false) bool enableRag,
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

/// 思考链设置
@freezed
class ThinkingChainSettings with _$ThinkingChainSettings {
  const factory ThinkingChainSettings({
    /// 是否显示思考链
    @Default(true) bool showThinkingChain,

    /// 思考链动画速度（毫秒）
    @Default(50) int animationSpeed,

    /// 是否启用思考链动画
    @Default(true) bool enableAnimation,

    /// 思考链最大显示长度
    @Default(2000) int maxDisplayLength,

    /// 是否自动折叠长思考链
    @Default(true) bool autoCollapseOnLongContent,

    /// 是否为Gemini模型特殊处理
    @Default(true) bool enableGeminiSpecialHandling,
  }) = _ThinkingChainSettings;

  factory ThinkingChainSettings.fromJson(Map<String, dynamic> json) =>
      _$ThinkingChainSettingsFromJson(json);
}
