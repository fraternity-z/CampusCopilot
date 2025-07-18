import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'chat_message_defaults.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

/// 聊天会话实体
///
/// 表示一个完整的聊天会话，包含会话信息和配置
@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    /// 会话唯一标识符
    required String id,

    /// 会话标题
    required String title,

    /// 关联的智能体ID
    required String personaId,

    /// 会话创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 会话是否已归档
    @Default(false) bool isArchived,

    /// 会话是否置顶
    @Default(false) bool isPinned,

    /// 会话标签
    @Default(ChatMessageDefaults.emptyStringList) List<String> tags,

    /// 消息总数
    @Default(0) int messageCount,

    /// 总token使用量
    @Default(0) int totalTokens,

    /// 会话配置
    ChatSessionConfig? config,

    /// 会话元数据
    Map<String, dynamic>? metadata,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}

/// 聊天会话配置
@freezed
class ChatSessionConfig with _$ChatSessionConfig {
  const factory ChatSessionConfig({
    /// 上下文窗口大小
    @Default(ChatMessageDefaults.defaultContextWindowSize)
    int contextWindowSize,

    /// 温度参数
    @Default(ChatMessageDefaults.defaultTemperature) double temperature,

    /// 最大生成token数
    @Default(ChatMessageDefaults.defaultMaxTokens) int maxTokens,

    /// 是否启用流式响应
    @Default(true) bool enableStreaming,

    /// 是否启用RAG
    @Default(false) bool enableRAG,

    /// RAG知识库ID列表
    @Default(ChatMessageDefaults.emptyKnowledgeBaseIds)
    List<String> knowledgeBaseIds,

    /// 系统提示词覆盖（可选）
    String? systemPromptOverride,

    /// 自定义参数
    Map<String, dynamic>? customParams,
  }) = _ChatSessionConfig;

  factory ChatSessionConfig.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionConfigFromJson(json);
}

/// ChatSession扩展方法
extension ChatSessionExtensions on ChatSession {
  /// 是否为新会话（无消息）
  bool get isNewSession => messageCount == 0;

  /// 是否为活跃会话
  bool get isActive => !isArchived;

  /// 获取显示标题
  String get displayTitle {
    if (title.isNotEmpty) return title;
    return isNewSession
        ? ChatMessageDefaults.newChatTitle
        : '${ChatMessageDefaults.chatPrefix}${id.substring(0, ChatMessageDefaults.idSubstringLength)}';
  }

  /// 获取最后活动时间描述
  String get lastActivityDescription => getLastActivityDescription();

  /// 获取最后活动时间描述（支持传入当前时间参数，用于批量处理优化）
  String getLastActivityDescription([DateTime? currentTime]) {
    final now = currentTime ?? TimeCache.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < ChatMessageDefaults.minuteThreshold) {
      return ChatMessageDefaults.justActiveText;
    } else if (difference.inHours < ChatMessageDefaults.hourThreshold) {
      return '${difference.inMinutes}${ChatMessageDefaults.minutesAgoText}';
    } else if (difference.inDays < ChatMessageDefaults.dayThreshold) {
      return '${difference.inHours}${ChatMessageDefaults.hoursAgoText}';
    } else if (difference.inDays < ChatMessageDefaults.weekThreshold) {
      return '${difference.inDays}${ChatMessageDefaults.daysAgoText}';
    } else {
      return '${updatedAt.month}/${updatedAt.day}';
    }
  }

  /// 通用更新方法（私有方法，用于减少重复代码）
  ChatSession _updateWith({
    String? title,
    bool? isArchived,
    bool? isPinned,
    List<String>? tags,
    int? messageCount,
    int? totalTokens,
    ChatSessionConfig? config,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? TimeCache.now();
    return copyWith(
      title: title ?? this.title,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      messageCount: messageCount ?? this.messageCount,
      totalTokens: totalTokens ?? this.totalTokens,
      config: config ?? this.config,
      metadata: metadata ?? this.metadata,
      updatedAt: now,
    );
  }

  /// 更新会话标题
  ChatSession updateTitle(String newTitle, [DateTime? timestamp]) {
    return _updateWith(title: newTitle, timestamp: timestamp);
  }

  /// 增加消息计数
  ChatSession incrementMessageCount([int count = 1, DateTime? timestamp]) {
    return _updateWith(
      messageCount: messageCount + count,
      timestamp: timestamp,
    );
  }

  /// 增加token使用量
  ChatSession addTokenUsage(int tokens, [DateTime? timestamp]) {
    return _updateWith(totalTokens: totalTokens + tokens, timestamp: timestamp);
  }

  /// 归档会话
  ChatSession archive([DateTime? timestamp]) {
    return _updateWith(isArchived: true, timestamp: timestamp);
  }

  /// 取消归档
  ChatSession unarchive([DateTime? timestamp]) {
    return _updateWith(isArchived: false, timestamp: timestamp);
  }

  /// 置顶会话
  ChatSession pin([DateTime? timestamp]) {
    return _updateWith(isPinned: true, timestamp: timestamp);
  }

  /// 取消置顶
  ChatSession unpin([DateTime? timestamp]) {
    return _updateWith(isPinned: false, timestamp: timestamp);
  }

  /// 添加标签（优化版本，带提前返回）
  ChatSession addTag(String tag, [DateTime? timestamp]) {
    // 提前返回，避免不必要的操作
    if (tags.contains(tag)) return this;

    // 使用高效的列表操作
    final newTags = List<String>.unmodifiable([...tags, tag]);
    return _updateWith(tags: newTags, timestamp: timestamp);
  }

  /// 移除标签（优化版本，带提前返回）
  ChatSession removeTag(String tag, [DateTime? timestamp]) {
    // 提前返回，避免不必要的操作
    if (!tags.contains(tag)) return this;

    // 使用高效的列表操作
    final newTags = List<String>.unmodifiable(
      tags.where((t) => t != tag).toList(),
    );
    return _updateWith(tags: newTags, timestamp: timestamp);
  }

  /// 批量添加标签（性能优化版本）
  ChatSession addTags(List<String> newTags, [DateTime? timestamp]) {
    if (newTags.isEmpty) return this;

    // 过滤掉已存在的标签
    final tagsToAdd = newTags.where((tag) => !tags.contains(tag)).toList();
    if (tagsToAdd.isEmpty) return this;

    final updatedTags = List<String>.unmodifiable([...tags, ...tagsToAdd]);
    return _updateWith(tags: updatedTags, timestamp: timestamp);
  }

  /// 批量移除标签（性能优化版本）
  ChatSession removeTags(List<String> tagsToRemove, [DateTime? timestamp]) {
    if (tagsToRemove.isEmpty) return this;

    // 检查是否有标签需要移除
    final hasTagsToRemove = tagsToRemove.any((tag) => tags.contains(tag));
    if (!hasTagsToRemove) return this;

    final updatedTags = List<String>.unmodifiable(
      tags.where((tag) => !tagsToRemove.contains(tag)).toList(),
    );
    return _updateWith(tags: updatedTags, timestamp: timestamp);
  }

  /// 更新配置
  ChatSession updateConfig(ChatSessionConfig newConfig, [DateTime? timestamp]) {
    return _updateWith(config: newConfig, timestamp: timestamp);
  }
}

/// ChatSession工厂方法
extension ChatSessionFactory on ChatSession {
  /// 创建新会话（优化版本，使用缓存时间）
  static ChatSession createNew({
    required String personaId,
    String? title,
    ChatSessionConfig? config,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? TimeCache.now();
    const uuid = Uuid();
    return ChatSession(
      id: uuid.v4(),
      title: title ?? ChatMessageDefaults.newChatTitle,
      personaId: personaId,
      createdAt: now,
      updatedAt: now,
      config: config ?? const ChatSessionConfig(),
    );
  }

  /// 批量创建会话（性能优化版本）
  static List<ChatSession> createBatch({
    required List<String> personaIds,
    String? titlePrefix,
    ChatSessionConfig? config,
    DateTime? timestamp,
  }) {
    if (personaIds.isEmpty) return [];

    final now = timestamp ?? TimeCache.now();
    const uuid = Uuid();

    return personaIds.map((personaId) {
      return ChatSession(
        id: uuid.v4(),
        title: titlePrefix != null
            ? '$titlePrefix ${personaIds.indexOf(personaId) + 1}'
            : ChatMessageDefaults.newChatTitle,
        personaId: personaId,
        createdAt: now,
        updatedAt: now,
        config: config ?? const ChatSessionConfig(),
      );
    }).toList();
  }
}
