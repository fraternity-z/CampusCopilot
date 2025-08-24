// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileAttachment _$FileAttachmentFromJson(Map<String, dynamic> json) {
  return _FileAttachment.fromJson(json);
}

/// @nodoc
mixin _$FileAttachment {
  /// 文件名
  String get fileName => throw _privateConstructorUsedError;

  /// 文件大小（字节）
  int get fileSize => throw _privateConstructorUsedError;

  /// 文件类型/扩展名
  String get fileType => throw _privateConstructorUsedError;

  /// 文件路径（可选，用于本地文件）
  String? get filePath => throw _privateConstructorUsedError;

  /// 文件内容（用于传递给AI，但不在UI中显示）
  String? get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FileAttachmentCopyWith<FileAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileAttachmentCopyWith<$Res> {
  factory $FileAttachmentCopyWith(
          FileAttachment value, $Res Function(FileAttachment) then) =
      _$FileAttachmentCopyWithImpl<$Res, FileAttachment>;
  @useResult
  $Res call(
      {String fileName,
      int fileSize,
      String fileType,
      String? filePath,
      String? content});
}

/// @nodoc
class _$FileAttachmentCopyWithImpl<$Res, $Val extends FileAttachment>
    implements $FileAttachmentCopyWith<$Res> {
  _$FileAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? filePath = freezed,
    Object? content = freezed,
  }) {
    return _then(_value.copyWith(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileAttachmentImplCopyWith<$Res>
    implements $FileAttachmentCopyWith<$Res> {
  factory _$$FileAttachmentImplCopyWith(_$FileAttachmentImpl value,
          $Res Function(_$FileAttachmentImpl) then) =
      __$$FileAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fileName,
      int fileSize,
      String fileType,
      String? filePath,
      String? content});
}

/// @nodoc
class __$$FileAttachmentImplCopyWithImpl<$Res>
    extends _$FileAttachmentCopyWithImpl<$Res, _$FileAttachmentImpl>
    implements _$$FileAttachmentImplCopyWith<$Res> {
  __$$FileAttachmentImplCopyWithImpl(
      _$FileAttachmentImpl _value, $Res Function(_$FileAttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? filePath = freezed,
    Object? content = freezed,
  }) {
    return _then(_$FileAttachmentImpl(
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileAttachmentImpl implements _FileAttachment {
  const _$FileAttachmentImpl(
      {required this.fileName,
      required this.fileSize,
      required this.fileType,
      this.filePath,
      this.content});

  factory _$FileAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileAttachmentImplFromJson(json);

  /// 文件名
  @override
  final String fileName;

  /// 文件大小（字节）
  @override
  final int fileSize;

  /// 文件类型/扩展名
  @override
  final String fileType;

  /// 文件路径（可选，用于本地文件）
  @override
  final String? filePath;

  /// 文件内容（用于传递给AI，但不在UI中显示）
  @override
  final String? content;

  @override
  String toString() {
    return 'FileAttachment(fileName: $fileName, fileSize: $fileSize, fileType: $fileType, filePath: $filePath, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileAttachmentImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fileName, fileSize, fileType, filePath, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FileAttachmentImplCopyWith<_$FileAttachmentImpl> get copyWith =>
      __$$FileAttachmentImplCopyWithImpl<_$FileAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileAttachmentImplToJson(
      this,
    );
  }
}

abstract class _FileAttachment implements FileAttachment {
  const factory _FileAttachment(
      {required final String fileName,
      required final int fileSize,
      required final String fileType,
      final String? filePath,
      final String? content}) = _$FileAttachmentImpl;

  factory _FileAttachment.fromJson(Map<String, dynamic> json) =
      _$FileAttachmentImpl.fromJson;

  @override

  /// 文件名
  String get fileName;
  @override

  /// 文件大小（字节）
  int get fileSize;
  @override

  /// 文件类型/扩展名
  String get fileType;
  @override

  /// 文件路径（可选，用于本地文件）
  String? get filePath;
  @override

  /// 文件内容（用于传递给AI，但不在UI中显示）
  String? get content;
  @override
  @JsonKey(ignore: true)
  _$$FileAttachmentImplCopyWith<_$FileAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  /// 消息唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 消息内容
  String get content => throw _privateConstructorUsedError;

  /// 是否来自用户（false表示来自AI）
  bool get isFromUser => throw _privateConstructorUsedError;

  /// 消息创建时间
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// 关联的聊天会话ID
  String get chatSessionId => throw _privateConstructorUsedError;

  /// 消息类型（文本、图片、文件等）
  MessageType get type => throw _privateConstructorUsedError;

  /// 消息状态（发送中、已发送、失败等）
  MessageStatus get status => throw _privateConstructorUsedError;

  /// 消息元数据（可选）
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// 父消息ID（用于回复功能）
  String? get parentMessageId => throw _privateConstructorUsedError;

  /// 消息使用的token数量
  int? get tokenCount => throw _privateConstructorUsedError;

  /// 图片URL列表（用于多模态消息）
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// 附件文件信息列表
  List<FileAttachment> get attachments => throw _privateConstructorUsedError;

  /// 思考链内容（AI思考过程）
  String? get thinkingContent => throw _privateConstructorUsedError;

  /// 思考链是否完整
  bool get thinkingComplete => throw _privateConstructorUsedError;

  /// 使用的模型名称（用于特殊处理）
  String? get modelName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String content,
      bool isFromUser,
      DateTime timestamp,
      String chatSessionId,
      MessageType type,
      MessageStatus status,
      Map<String, dynamic>? metadata,
      String? parentMessageId,
      int? tokenCount,
      List<String> imageUrls,
      List<FileAttachment> attachments,
      String? thinkingContent,
      bool thinkingComplete,
      String? modelName});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isFromUser = null,
    Object? timestamp = null,
    Object? chatSessionId = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? parentMessageId = freezed,
    Object? tokenCount = freezed,
    Object? imageUrls = null,
    Object? attachments = null,
    Object? thinkingContent = freezed,
    Object? thinkingComplete = null,
    Object? modelName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isFromUser: null == isFromUser
          ? _value.isFromUser
          : isFromUser // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      chatSessionId: null == chatSessionId
          ? _value.chatSessionId
          : chatSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      parentMessageId: freezed == parentMessageId
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenCount: freezed == tokenCount
          ? _value.tokenCount
          : tokenCount // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<FileAttachment>,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingComplete: null == thinkingComplete
          ? _value.thinkingComplete
          : thinkingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      bool isFromUser,
      DateTime timestamp,
      String chatSessionId,
      MessageType type,
      MessageStatus status,
      Map<String, dynamic>? metadata,
      String? parentMessageId,
      int? tokenCount,
      List<String> imageUrls,
      List<FileAttachment> attachments,
      String? thinkingContent,
      bool thinkingComplete,
      String? modelName});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isFromUser = null,
    Object? timestamp = null,
    Object? chatSessionId = null,
    Object? type = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? parentMessageId = freezed,
    Object? tokenCount = freezed,
    Object? imageUrls = null,
    Object? attachments = null,
    Object? thinkingContent = freezed,
    Object? thinkingComplete = null,
    Object? modelName = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isFromUser: null == isFromUser
          ? _value.isFromUser
          : isFromUser // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      chatSessionId: null == chatSessionId
          ? _value.chatSessionId
          : chatSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      parentMessageId: freezed == parentMessageId
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenCount: freezed == tokenCount
          ? _value.tokenCount
          : tokenCount // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<FileAttachment>,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingComplete: null == thinkingComplete
          ? _value.thinkingComplete
          : thinkingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.content,
      required this.isFromUser,
      required this.timestamp,
      required this.chatSessionId,
      this.type = MessageType.text,
      this.status = MessageStatus.sent,
      final Map<String, dynamic>? metadata,
      this.parentMessageId,
      this.tokenCount,
      final List<String> imageUrls = ChatMessageDefaults.emptyStringList,
      final List<FileAttachment> attachments =
          ChatMessageDefaults.emptyAttachmentList,
      this.thinkingContent,
      this.thinkingComplete = false,
      this.modelName})
      : _metadata = metadata,
        _imageUrls = imageUrls,
        _attachments = attachments;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  /// 消息唯一标识符
  @override
  final String id;

  /// 消息内容
  @override
  final String content;

  /// 是否来自用户（false表示来自AI）
  @override
  final bool isFromUser;

  /// 消息创建时间
  @override
  final DateTime timestamp;

  /// 关联的聊天会话ID
  @override
  final String chatSessionId;

  /// 消息类型（文本、图片、文件等）
  @override
  @JsonKey()
  final MessageType type;

  /// 消息状态（发送中、已发送、失败等）
  @override
  @JsonKey()
  final MessageStatus status;

  /// 消息元数据（可选）
  final Map<String, dynamic>? _metadata;

  /// 消息元数据（可选）
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 父消息ID（用于回复功能）
  @override
  final String? parentMessageId;

  /// 消息使用的token数量
  @override
  final int? tokenCount;

  /// 图片URL列表（用于多模态消息）
  final List<String> _imageUrls;

  /// 图片URL列表（用于多模态消息）
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// 附件文件信息列表
  final List<FileAttachment> _attachments;

  /// 附件文件信息列表
  @override
  @JsonKey()
  List<FileAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  /// 思考链内容（AI思考过程）
  @override
  final String? thinkingContent;

  /// 思考链是否完整
  @override
  @JsonKey()
  final bool thinkingComplete;

  /// 使用的模型名称（用于特殊处理）
  @override
  final String? modelName;

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, isFromUser: $isFromUser, timestamp: $timestamp, chatSessionId: $chatSessionId, type: $type, status: $status, metadata: $metadata, parentMessageId: $parentMessageId, tokenCount: $tokenCount, imageUrls: $imageUrls, attachments: $attachments, thinkingContent: $thinkingContent, thinkingComplete: $thinkingComplete, modelName: $modelName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isFromUser, isFromUser) ||
                other.isFromUser == isFromUser) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.chatSessionId, chatSessionId) ||
                other.chatSessionId == chatSessionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.parentMessageId, parentMessageId) ||
                other.parentMessageId == parentMessageId) &&
            (identical(other.tokenCount, tokenCount) ||
                other.tokenCount == tokenCount) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.thinkingContent, thinkingContent) ||
                other.thinkingContent == thinkingContent) &&
            (identical(other.thinkingComplete, thinkingComplete) ||
                other.thinkingComplete == thinkingComplete) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      content,
      isFromUser,
      timestamp,
      chatSessionId,
      type,
      status,
      const DeepCollectionEquality().hash(_metadata),
      parentMessageId,
      tokenCount,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_attachments),
      thinkingContent,
      thinkingComplete,
      modelName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String content,
      required final bool isFromUser,
      required final DateTime timestamp,
      required final String chatSessionId,
      final MessageType type,
      final MessageStatus status,
      final Map<String, dynamic>? metadata,
      final String? parentMessageId,
      final int? tokenCount,
      final List<String> imageUrls,
      final List<FileAttachment> attachments,
      final String? thinkingContent,
      final bool thinkingComplete,
      final String? modelName}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override

  /// 消息唯一标识符
  String get id;
  @override

  /// 消息内容
  String get content;
  @override

  /// 是否来自用户（false表示来自AI）
  bool get isFromUser;
  @override

  /// 消息创建时间
  DateTime get timestamp;
  @override

  /// 关联的聊天会话ID
  String get chatSessionId;
  @override

  /// 消息类型（文本、图片、文件等）
  MessageType get type;
  @override

  /// 消息状态（发送中、已发送、失败等）
  MessageStatus get status;
  @override

  /// 消息元数据（可选）
  Map<String, dynamic>? get metadata;
  @override

  /// 父消息ID（用于回复功能）
  String? get parentMessageId;
  @override

  /// 消息使用的token数量
  int? get tokenCount;
  @override

  /// 图片URL列表（用于多模态消息）
  List<String> get imageUrls;
  @override

  /// 附件文件信息列表
  List<FileAttachment> get attachments;
  @override

  /// 思考链内容（AI思考过程）
  String? get thinkingContent;
  @override

  /// 思考链是否完整
  bool get thinkingComplete;
  @override

  /// 使用的模型名称（用于特殊处理）
  String? get modelName;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
