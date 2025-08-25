import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message_defaults.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// 文件附件信息
@freezed
class FileAttachment with _$FileAttachment {
  const factory FileAttachment({
    /// 文件名
    required String fileName,

    /// 文件大小（字节）
    required int fileSize,

    /// 文件类型/扩展名
    required String fileType,

    /// 文件路径（可选，用于本地文件）
    String? filePath,

    /// 文件内容（用于传递给AI，但不在UI中显示）
    String? content,
  }) = _FileAttachment;

  factory FileAttachment.fromJson(Map<String, dynamic> json) =>
      _$FileAttachmentFromJson(json);
}

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
    @Default(ChatMessageDefaults.emptyStringList) List<String> imageUrls,

    /// 附件文件信息列表
    @Default(ChatMessageDefaults.emptyAttachmentList)
    List<FileAttachment> attachments,

    /// 思考链内容（AI思考过程）
    String? thinkingContent,

    /// 思考链是否完整
    @Default(false) bool thinkingComplete,

    /// 使用的模型名称（用于特殊处理）
    String? modelName,
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

  /// 生成中（加载占位符）
  generating,
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

  /// 是否为图片消息
  bool get isImageMessage => type == MessageType.image;

  /// 是否包含图片
  bool get hasImages => imageUrls.isNotEmpty;

  /// 是否为多模态消息（包含文本和图片）
  bool get isMultimodal => hasImages && content.trim().isNotEmpty;

  /// 是否发送成功
  bool get isSent => status == MessageStatus.sent;

  /// 是否发送失败
  bool get isFailed => status == MessageStatus.failed;

  /// 是否正在发送
  bool get isSending => status == MessageStatus.sending;

  /// 获取显示时间
  String get displayTime => getDisplayTime();

  /// 获取显示时间（支持传入当前时间参数，用于批量处理优化）
  String getDisplayTime([DateTime? currentTime]) {
    final now = currentTime ?? TimeCache.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < ChatMessageDefaults.minuteThreshold) {
      return ChatMessageDefaults.justNowText;
    } else if (difference.inHours < ChatMessageDefaults.hourThreshold) {
      return '${difference.inMinutes}${ChatMessageDefaults.minutesAgoText}';
    } else if (difference.inDays < ChatMessageDefaults.dayThreshold) {
      return '${difference.inHours}${ChatMessageDefaults.hoursAgoText}';
    } else if (difference.inDays < ChatMessageDefaults.weekThreshold) {
      return '${difference.inDays}${ChatMessageDefaults.daysAgoText}';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

/// ChatMessage工厂方法
extension ChatMessageFactory on ChatMessage {
  /// 通用创建方法（核心方法）
  static ChatMessage create({
    required String content,
    required String chatSessionId,
    required bool isFromUser,
    MessageType type = MessageType.text,
    MessageStatus status = MessageStatus.sent,
    String? parentMessageId,
    int? tokenCount,
    List<String>? imageUrls,
    List<FileAttachment>? attachments,
    String? thinkingContent,
    bool thinkingComplete = false,
    String? modelName,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? TimeCache.now();
    return ChatMessage(
      id: now.millisecondsSinceEpoch.toString(),
      content: content,
      isFromUser: isFromUser,
      timestamp: now,
      chatSessionId: chatSessionId,
      type: type,
      status: status,
      parentMessageId: parentMessageId,
      tokenCount: tokenCount,
      imageUrls: imageUrls ?? ChatMessageDefaults.emptyStringList,
      attachments: attachments ?? ChatMessageDefaults.emptyAttachmentList,
      thinkingContent: thinkingContent,
      thinkingComplete: thinkingComplete,
      modelName: modelName,
      metadata: metadata,
    );
  }

  /// 创建用户消息（便捷方法）
  static ChatMessage createUserMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
    DateTime? timestamp,
  }) {
    return create(
      content: content,
      chatSessionId: chatSessionId,
      isFromUser: true,
      parentMessageId: parentMessageId,
      timestamp: timestamp,
    );
  }

  /// 创建AI消息（便捷方法）
  static ChatMessage createAIMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
    int? tokenCount,
    String? thinkingContent,
    bool thinkingComplete = false,
    String? modelName,
    DateTime? timestamp,
  }) {
    return create(
      content: content,
      chatSessionId: chatSessionId,
      isFromUser: false,
      parentMessageId: parentMessageId,
      tokenCount: tokenCount,
      thinkingContent: thinkingContent,
      thinkingComplete: thinkingComplete,
      modelName: modelName,
      timestamp: timestamp,
    );
  }

  /// 创建系统消息（便捷方法）
  static ChatMessage createSystemMessage({
    required String content,
    required String chatSessionId,
    DateTime? timestamp,
  }) {
    return create(
      content: content,
      chatSessionId: chatSessionId,
      isFromUser: false,
      type: MessageType.system,
      timestamp: timestamp,
    );
  }

  /// 创建图片消息（便捷方法）
  static ChatMessage createImageMessage({
    required String content,
    required String chatSessionId,
    required List<String> imageUrls,
    String? parentMessageId,
    bool isFromUser = true,
    DateTime? timestamp,
  }) {
    return create(
      content: content,
      chatSessionId: chatSessionId,
      isFromUser: isFromUser,
      type: MessageType.image,
      imageUrls: imageUrls,
      parentMessageId: parentMessageId,
      timestamp: timestamp,
    );
  }

  /// 创建用户图片消息（便捷方法）
  static ChatMessage createUserImageMessage({
    required String content,
    required String chatSessionId,
    required List<String> imageUrls,
    String? parentMessageId,
    DateTime? timestamp,
  }) {
    return createImageMessage(
      content: content,
      chatSessionId: chatSessionId,
      imageUrls: imageUrls,
      parentMessageId: parentMessageId,
      isFromUser: true,
      timestamp: timestamp,
    );
  }

  /// 创建错误消息（便捷方法）
  static ChatMessage createErrorMessage({
    required String content,
    required String chatSessionId,
    String? parentMessageId,
    DateTime? timestamp,
  }) {
    return create(
      content: content,
      chatSessionId: chatSessionId,
      isFromUser: false,
      type: MessageType.error,
      status: MessageStatus.failed,
      parentMessageId: parentMessageId,
      timestamp: timestamp,
    );
  }
}
