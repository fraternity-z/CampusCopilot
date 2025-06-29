import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// 聊天消息实体
///
/// 领域层的核心实体，表示一条聊天消息
/// 使用Freezed确保不可变性和类型安全
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// 消息唯一标识符
    required String id,

    /// 消息内容
    required String content,

    /// 是否来自用户（false表示来自AI）
    required bool isFromUser,

    /// 消息创建时间
    required DateTime timestamp,

    /// 关联的聊天会话ID
    required String chatSessionId,

    /// 消息类型（文本、图片、文件等）
    @Default(MessageType.text) MessageType type,

    /// 消息状态（发送中、已发送、失败等）
    @Default(MessageStatus.sent) MessageStatus status,

    /// 消息元数据（可选）
    Map<String, dynamic>? metadata,

    /// 父消息ID（用于回复功能）
    String? parentMessageId,

    /// 消息使用的token数量
    int? tokenCount,

    /// 图片URL列表（用于多模态消息）
    @Default([]) List<String> imageUrls,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

/// 消息类型枚举
enum MessageType {
  /// 文本消息
  text,

  /// 图片消息
  image,

  /// 文件消息
  file,

  /// 系统消息
  system,

  /// 错误消息
  error,
}

/// 消息状态枚举
enum MessageStatus {
  /// 发送中
  sending,

  /// 已发送
  sent,

  /// 发送失败
  failed,

  /// 已读
  read,
}

/// ChatMessage扩展方法
extension ChatMessageExtensions on ChatMessage {
  /// 是否为AI消息
  bool get isFromAI => !isFromUser;

  /// 是否为系统消息
  bool get isSystemMessage => type == MessageType.system;

  /// 是否为错误消息
  bool get isErrorMessage => type == MessageType.error;

  /// 是否发送成功
  bool get isSent => status == MessageStatus.sent;

  /// 是否发送失败
  bool get isFailed => status == MessageStatus.failed;

  /// 是否正在发送
  bool get isSending => status == MessageStatus.sending;

  /// 获取显示时间
  String get displayTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

/// ChatMessage工厂方法
extension ChatMessageFactory on ChatMessage {
  /// 创建用户消息
  static ChatMessage createUserMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: true,
      timestamp: DateTime.now(),
      chatSessionId: chatSessionId,
      parentMessageId: parentMessageId,
    );
  }

  /// 创建AI消息
  static ChatMessage createAIMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
    int? tokenCount,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: false,
      timestamp: DateTime.now(),
      chatSessionId: chatSessionId,
      parentMessageId: parentMessageId,
      tokenCount: tokenCount,
    );
  }

  /// 创建系统消息
  static ChatMessage createSystemMessage({
    required String content,
    required String chatSessionId,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: false,
      timestamp: DateTime.now(),
      chatSessionId: chatSessionId,
      type: MessageType.system,
    );
  }

  /// 创建错误消息
  static ChatMessage createErrorMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: false,
      timestamp: DateTime.now(),
      chatSessionId: chatSessionId,
      type: MessageType.error,
      status: MessageStatus.failed,
      parentMessageId: parentMessageId,
    );
  }
}
