import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

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
    @Default([]) List<String> tags,

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
    @Default(4096) int contextWindowSize,

    /// 温度参数
    @Default(0.7) double temperature,

    /// 最大生成token数
    @Default(2048) int maxTokens,

    /// 是否启用流式响应
    @Default(true) bool enableStreaming,

    /// 是否启用RAG
    @Default(false) bool enableRAG,

    /// RAG知识库ID列表
    @Default([]) List<String> knowledgeBaseIds,

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
    return isNewSession ? '新对话' : '对话 ${id.substring(0, 8)}';
  }

  /// 获取最后活动时间描述
  String get lastActivityDescription {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 1) {
      return '刚刚活跃';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${updatedAt.month}/${updatedAt.day}';
    }
  }

  /// 更新会话标题
  ChatSession updateTitle(String newTitle) {
    return copyWith(title: newTitle, updatedAt: DateTime.now());
  }

  /// 增加消息计数
  ChatSession incrementMessageCount([int count = 1]) {
    return copyWith(
      messageCount: messageCount + count,
      updatedAt: DateTime.now(),
    );
  }

  /// 增加token使用量
  ChatSession addTokenUsage(int tokens) {
    return copyWith(
      totalTokens: totalTokens + tokens,
      updatedAt: DateTime.now(),
    );
  }

  /// 归档会话
  ChatSession archive() {
    return copyWith(isArchived: true, updatedAt: DateTime.now());
  }

  /// 取消归档
  ChatSession unarchive() {
    return copyWith(isArchived: false, updatedAt: DateTime.now());
  }

  /// 置顶会话
  ChatSession pin() {
    return copyWith(isPinned: true, updatedAt: DateTime.now());
  }

  /// 取消置顶
  ChatSession unpin() {
    return copyWith(isPinned: false, updatedAt: DateTime.now());
  }

  /// 添加标签
  ChatSession addTag(String tag) {
    if (tags.contains(tag)) return this;
    return copyWith(tags: [...tags, tag], updatedAt: DateTime.now());
  }

  /// 移除标签
  ChatSession removeTag(String tag) {
    return copyWith(
      tags: tags.where((t) => t != tag).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// 更新配置
  ChatSession updateConfig(ChatSessionConfig newConfig) {
    return copyWith(config: newConfig, updatedAt: DateTime.now());
  }
}

/// ChatSession工厂方法
extension ChatSessionFactory on ChatSession {
  /// 创建新会话
  static ChatSession createNew({
    required String personaId,
    String? title,
    ChatSessionConfig? config,
  }) {
    final now = DateTime.now();
    const uuid = Uuid();
    return ChatSession(
      id: uuid.v4(),
      title: title ?? '新对话',
      personaId: personaId,
      createdAt: now,
      updatedAt: now,
      config: config ?? const ChatSessionConfig(),
    );
  }
}
