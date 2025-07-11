import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/chat_message.dart';

part 'llm_provider.freezed.dart';
part 'llm_provider.g.dart';

/// LLM提供商抽象接口
///
/// 定义了与AI供应商交互的统一接口，支持：
/// - 多种AI供应商（OpenAI、Google、Anthropic等）
/// - 聊天对话生成
/// - 流式响应
/// - 文本嵌入生成
/// - 模型信息查询
abstract class LlmProvider {
  /// 提供商配置
  final LlmConfig config;

  LlmProvider(this.config);

  /// 提供商名称
  String get providerName;

  /// 获取可用模型列表
  Future<List<ModelInfo>> listModels();

  /// 生成聊天回复
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  });

  /// 生成流式聊天回复
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  });

  /// 生成文本嵌入向量
  Future<EmbeddingResult> generateEmbeddings(List<String> texts);

  /// 验证配置是否有效
  Future<bool> validateConfig();

  /// 估算token数量
  int estimateTokens(String text);

  /// 释放资源
  void dispose();
}

/// LLM配置
@freezed
class LlmConfig with _$LlmConfig {
  const factory LlmConfig({
    /// 配置ID
    required String id,

    /// 配置名称
    required String name,

    /// 提供商类型
    required String provider,

    /// API密钥
    required String apiKey,

    /// 基础URL（可选，用于代理）
    String? baseUrl,

    /// 默认模型
    String? defaultModel,

    /// 默认嵌入模型
    String? defaultEmbeddingModel,

    /// 组织ID（OpenAI）
    String? organizationId,

    /// 项目ID（某些供应商）
    String? projectId,

    /// 额外配置参数
    Map<String, dynamic>? extraParams,

    /// 创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 是否启用
    @Default(true) bool isEnabled,

    /// 是否为自定义提供商
    @Default(false) bool isCustomProvider,

    /// API兼容性类型 (openai, gemini, anthropic, custom)
    @Default('openai') String apiCompatibilityType,

    /// 自定义提供商显示名称
    String? customProviderName,

    /// 自定义提供商描述
    String? customProviderDescription,

    /// 自定义提供商图标（可选）
    String? customProviderIcon,
  }) = _LlmConfig;

  factory LlmConfig.fromJson(Map<String, dynamic> json) =>
      _$LlmConfigFromJson(json);
}

/// 模型信息
@freezed
class ModelInfo with _$ModelInfo {
  const factory ModelInfo({
    /// 模型ID
    required String id,

    /// 模型名称
    required String name,

    /// 模型描述
    String? description,

    /// 模型类型
    required ModelType type,

    /// 上下文窗口大小
    int? contextWindow,

    /// 最大输出token数
    int? maxOutputTokens,

    /// 是否支持流式响应
    @Default(true) bool supportsStreaming,

    /// 是否支持函数调用
    @Default(false) bool supportsFunctionCalling,

    /// 是否支持视觉输入
    @Default(false) bool supportsVision,

    /// 定价信息
    PricingInfo? pricing,

    /// 模型能力标签
    @Default([]) List<String> capabilities,
  }) = _ModelInfo;

  factory ModelInfo.fromJson(Map<String, dynamic> json) =>
      _$ModelInfoFromJson(json);
}

/// 模型类型
enum ModelType {
  /// 聊天模型
  chat,

  /// 嵌入模型
  embedding,

  /// 图像生成模型
  imageGeneration,

  /// 语音模型
  speech,

  /// 多模态模型
  multimodal,
}

/// 定价信息
@freezed
class PricingInfo with _$PricingInfo {
  const factory PricingInfo({
    /// 输入token价格（每1K token）
    double? inputPrice,

    /// 输出token价格（每1K token）
    double? outputPrice,

    /// 货币单位
    @Default('USD') String currency,
  }) = _PricingInfo;

  factory PricingInfo.fromJson(Map<String, dynamic> json) =>
      _$PricingInfoFromJson(json);
}

/// 聊天选项
@freezed
class ChatOptions with _$ChatOptions {
  const factory ChatOptions({
    /// 使用的模型
    String? model,

    /// 温度参数
    double? temperature,

    /// 最大生成token数
    int? maxTokens,

    /// Top-p参数
    double? topP,

    /// 频率惩罚
    double? frequencyPenalty,

    /// 存在惩罚
    double? presencePenalty,

    /// 停止词
    List<String>? stopSequences,

    /// 是否启用流式响应
    bool? stream,

    /// 系统提示词
    String? systemPrompt,

    /// 工具列表（函数调用）
    List<ToolDefinition>? tools,

    /// 思考努力程度（用于o1/o3等模型）
    /// 可选值：'low', 'medium', 'high'
    String? reasoningEffort,

    /// 最大思考token数（用于Gemini等模型）
    int? maxReasoningTokens,

    /// 自定义参数
    Map<String, dynamic>? customParams,
  }) = _ChatOptions;

  factory ChatOptions.fromJson(Map<String, dynamic> json) =>
      _$ChatOptionsFromJson(json);
}

/// 工具定义（函数调用）
@freezed
class ToolDefinition with _$ToolDefinition {
  const factory ToolDefinition({
    /// 工具名称
    required String name,

    /// 工具描述
    required String description,

    /// 参数定义
    required Map<String, dynamic> parameters,
  }) = _ToolDefinition;

  factory ToolDefinition.fromJson(Map<String, dynamic> json) =>
      _$ToolDefinitionFromJson(json);
}

/// 聊天结果
@freezed
class ChatResult with _$ChatResult {
  const factory ChatResult({
    /// 生成的内容
    required String content,

    /// 使用的模型
    required String model,

    /// token使用情况
    required TokenUsage tokenUsage,

    /// 完成原因
    required FinishReason finishReason,

    /// 工具调用（如果有）
    List<ToolCall>? toolCalls,

    /// 响应时间（毫秒）
    int? responseTimeMs,

    /// 额外元数据
    Map<String, dynamic>? metadata,

    /// 思考链内容（AI思考过程）
    String? thinkingContent,
  }) = _ChatResult;

  factory ChatResult.fromJson(Map<String, dynamic> json) =>
      _$ChatResultFromJson(json);
}

/// 流式聊天结果
@freezed
class StreamedChatResult with _$StreamedChatResult {
  const factory StreamedChatResult({
    /// 增量内容
    String? delta,

    /// 累积内容
    String? content,

    /// 是否完成
    @Default(false) bool isDone,

    /// 使用的模型
    String? model,

    /// token使用情况（仅在完成时）
    TokenUsage? tokenUsage,

    /// 完成原因（仅在完成时）
    FinishReason? finishReason,

    /// 工具调用（如果有）
    List<ToolCall>? toolCalls,

    /// 思考链增量内容
    String? thinkingDelta,

    /// 思考链累积内容
    String? thinkingContent,

    /// 思考链是否完成
    @Default(false) bool thinkingComplete,
  }) = _StreamedChatResult;

  factory StreamedChatResult.fromJson(Map<String, dynamic> json) =>
      _$StreamedChatResultFromJson(json);
}

/// Token使用情况
@freezed
class TokenUsage with _$TokenUsage {
  const factory TokenUsage({
    /// 输入token数
    required int inputTokens,

    /// 输出token数
    required int outputTokens,

    /// 总token数
    required int totalTokens,
  }) = _TokenUsage;

  factory TokenUsage.fromJson(Map<String, dynamic> json) =>
      _$TokenUsageFromJson(json);
}

/// 完成原因
enum FinishReason {
  /// 正常完成
  stop,

  /// 达到最大长度
  length,

  /// 内容过滤
  contentFilter,

  /// 工具调用
  toolCalls,

  /// 错误
  error,
}

/// 工具调用
@freezed
class ToolCall with _$ToolCall {
  const factory ToolCall({
    /// 调用ID
    required String id,

    /// 工具名称
    required String name,

    /// 调用参数
    required Map<String, dynamic> arguments,
  }) = _ToolCall;

  factory ToolCall.fromJson(Map<String, dynamic> json) =>
      _$ToolCallFromJson(json);
}

/// 嵌入结果
@freezed
class EmbeddingResult with _$EmbeddingResult {
  const factory EmbeddingResult({
    /// 嵌入向量列表
    required List<List<double>> embeddings,

    /// 使用的模型
    required String model,

    /// token使用情况
    required TokenUsage tokenUsage,
  }) = _EmbeddingResult;

  factory EmbeddingResult.fromJson(Map<String, dynamic> json) =>
      _$EmbeddingResultFromJson(json);
}
