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

  /// 思考链内容（AI思考过程）
  String? get thinkingContent => throw _privateConstructorUsedError;

  /// 思考链是否完整
  bool get thinkingComplete => throw _privateConstructorUsedError;

  /// 使用的模型名称（用于特殊处理）
  String? get modelName => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
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
      final List<String> imageUrls = const [],
      this.thinkingContent,
      this.thinkingComplete = false,
      this.modelName})
      : _metadata = metadata,
        _imageUrls = imageUrls;

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
    return 'ChatMessage(id: $id, content: $content, isFromUser: $isFromUser, timestamp: $timestamp, chatSessionId: $chatSessionId, type: $type, status: $status, metadata: $metadata, parentMessageId: $parentMessageId, tokenCount: $tokenCount, imageUrls: $imageUrls, thinkingContent: $thinkingContent, thinkingComplete: $thinkingComplete, modelName: $modelName)';
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
            (identical(other.thinkingContent, thinkingContent) ||
                other.thinkingContent == thinkingContent) &&
            (identical(other.thinkingComplete, thinkingComplete) ||
                other.thinkingComplete == thinkingComplete) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      thinkingContent,
      thinkingComplete,
      modelName);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      final String? thinkingContent,
      final bool thinkingComplete,
      final String? modelName}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  /// 消息唯一标识符
  @override
  String get id;

  /// 消息内容
  @override
  String get content;

  /// 是否来自用户（false表示来自AI）
  @override
  bool get isFromUser;

  /// 消息创建时间
  @override
  DateTime get timestamp;

  /// 关联的聊天会话ID
  @override
  String get chatSessionId;

  /// 消息类型（文本、图片、文件等）
  @override
  MessageType get type;

  /// 消息状态（发送中、已发送、失败等）
  @override
  MessageStatus get status;

  /// 消息元数据（可选）
  @override
  Map<String, dynamic>? get metadata;

  /// 父消息ID（用于回复功能）
  @override
  String? get parentMessageId;

  /// 消息使用的token数量
  @override
  int? get tokenCount;

  /// 图片URL列表（用于多模态消息）
  @override
  List<String> get imageUrls;

  /// 思考链内容（AI思考过程）
  @override
  String? get thinkingContent;

  /// 思考链是否完整
  @override
  bool get thinkingComplete;

  /// 使用的模型名称（用于特殊处理）
  @override
  String? get modelName;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
