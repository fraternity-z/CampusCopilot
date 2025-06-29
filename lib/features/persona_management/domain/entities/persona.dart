import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona.freezed.dart';
part 'persona.g.dart';

/// 智能体实体
///
/// 表示一个AI智能体，包含其配置、行为和能力定义
@freezed
class Persona with _$Persona {
  const factory Persona({
    /// 智能体唯一标识符
    required String id,

    /// 智能体名称
    required String name,

    /// 智能体描述
    required String description,

    /// 系统提示词
    required String systemPrompt,

    /// 关联的API配置ID
    required String apiConfigId,

    /// 创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 最后使用时间
    DateTime? lastUsedAt,

    /// 智能体类型/分类
    @Default('assistant') String category,

    /// 智能体标签
    @Default([]) List<String> tags,

    /// 智能体头像/图标
    String? avatar,

    /// 是否为默认智能体
    @Default(false) bool isDefault,

    /// 是否启用
    @Default(true) bool isEnabled,

    /// 使用次数统计
    @Default(0) int usageCount,

    /// 智能体配置
    PersonaConfig? config,

    /// 智能体能力列表
    @Default([]) List<PersonaCapability> capabilities,

    /// 元数据
    Map<String, dynamic>? metadata,
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);
}

/// 智能体配置
@freezed
class PersonaConfig with _$PersonaConfig {
  const factory PersonaConfig({
    /// 温度参数
    @Default(0.7) double temperature,

    /// 最大生成token数
    @Default(2048) int maxTokens,

    /// Top-p参数
    @Default(1.0) double topP,

    /// 频率惩罚
    @Default(0.0) double frequencyPenalty,

    /// 存在惩罚
    @Default(0.0) double presencePenalty,

    /// 停止词列表
    @Default([]) List<String> stopSequences,

    /// 是否启用流式响应
    @Default(true) bool enableStreaming,

    /// 上下文管理策略
    @Default(ContextStrategy.truncate) ContextStrategy contextStrategy,

    /// 上下文窗口大小
    @Default(4096) int contextWindowSize,

    /// 是否启用RAG
    @Default(false) bool enableRAG,

    /// 默认知识库ID列表
    @Default([]) List<String> defaultKnowledgeBases,

    /// 自定义参数
    Map<String, dynamic>? customParams,
  }) = _PersonaConfig;

  factory PersonaConfig.fromJson(Map<String, dynamic> json) =>
      _$PersonaConfigFromJson(json);
}

/// 智能体能力
@freezed
class PersonaCapability with _$PersonaCapability {
  const factory PersonaCapability({
    /// 能力ID
    required String id,

    /// 能力名称
    required String name,

    /// 能力描述
    required String description,

    /// 能力类型
    required CapabilityType type,

    /// 是否启用
    @Default(true) bool isEnabled,

    /// 能力配置
    Map<String, dynamic>? config,
  }) = _PersonaCapability;

  factory PersonaCapability.fromJson(Map<String, dynamic> json) =>
      _$PersonaCapabilityFromJson(json);
}

/// 上下文管理策略
enum ContextStrategy {
  /// 截断策略（保留最新消息）
  truncate,

  /// 摘要策略（摘要旧消息）
  summarize,

  /// 滑动窗口策略
  slidingWindow,
}

/// 能力类型
enum CapabilityType {
  /// 工具调用
  tool,

  /// 知识库检索
  knowledgeBase,

  /// 代码执行
  codeExecution,

  /// 图像生成
  imageGeneration,

  /// 文件处理
  fileProcessing,

  /// 网络搜索
  webSearch,
}

/// Persona扩展方法
extension PersonaExtensions on Persona {
  /// 是否为新创建的智能体
  bool get isNew => usageCount == 0;

  /// 是否最近使用过
  bool get isRecentlyUsed {
    if (lastUsedAt == null) return false;
    final difference = DateTime.now().difference(lastUsedAt!);
    return difference.inDays < 7;
  }

  /// 获取显示名称
  String get displayName => name.isNotEmpty ? name : 'Unnamed Persona';

  /// 获取最后使用时间描述
  String get lastUsedDescription {
    if (lastUsedAt == null) return '从未使用';

    final now = DateTime.now();
    final difference = now.difference(lastUsedAt!);

    if (difference.inMinutes < 1) {
      return '刚刚使用';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${lastUsedAt!.month}/${lastUsedAt!.day}';
    }
  }

  /// 更新使用统计
  Persona updateUsage() {
    return copyWith(
      usageCount: usageCount + 1,
      lastUsedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 更新配置
  Persona updateConfig(PersonaConfig newConfig) {
    return copyWith(config: newConfig, updatedAt: DateTime.now());
  }

  /// 添加能力
  Persona addCapability(PersonaCapability capability) {
    if (capabilities.any((c) => c.id == capability.id)) return this;
    return copyWith(
      capabilities: [...capabilities, capability],
      updatedAt: DateTime.now(),
    );
  }

  /// 移除能力
  Persona removeCapability(String capabilityId) {
    return copyWith(
      capabilities: capabilities.where((c) => c.id != capabilityId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// 启用/禁用能力
  Persona toggleCapability(String capabilityId, bool enabled) {
    final updatedCapabilities = capabilities.map((c) {
      if (c.id == capabilityId) {
        return c.copyWith(isEnabled: enabled);
      }
      return c;
    }).toList();

    return copyWith(
      capabilities: updatedCapabilities,
      updatedAt: DateTime.now(),
    );
  }

  /// 添加标签
  Persona addTag(String tag) {
    if (tags.contains(tag)) return this;
    return copyWith(tags: [...tags, tag], updatedAt: DateTime.now());
  }

  /// 移除标签
  Persona removeTag(String tag) {
    return copyWith(
      tags: tags.where((t) => t != tag).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// 设为默认
  Persona setAsDefault() {
    return copyWith(isDefault: true, updatedAt: DateTime.now());
  }

  /// 取消默认
  Persona unsetAsDefault() {
    return copyWith(isDefault: false, updatedAt: DateTime.now());
  }
}
