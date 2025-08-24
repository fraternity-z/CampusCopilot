// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) {
  return _ChatSession.fromJson(json);
}

/// @nodoc
mixin _$ChatSession {
  /// 会话唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 会话标题
  String get title => throw _privateConstructorUsedError;

  /// 关联的智能体ID
  String get personaId => throw _privateConstructorUsedError;

  /// 会话创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 会话是否已归档
  bool get isArchived => throw _privateConstructorUsedError;

  /// 会话是否置顶
  bool get isPinned => throw _privateConstructorUsedError;

  /// 会话标签
  List<String> get tags => throw _privateConstructorUsedError;

  /// 消息总数
  int get messageCount => throw _privateConstructorUsedError;

  /// 总token使用量
  int get totalTokens => throw _privateConstructorUsedError;

  /// 会话配置
  ChatSessionConfig? get config => throw _privateConstructorUsedError;

  /// 会话元数据
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatSessionCopyWith<ChatSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionCopyWith<$Res> {
  factory $ChatSessionCopyWith(
          ChatSession value, $Res Function(ChatSession) then) =
      _$ChatSessionCopyWithImpl<$Res, ChatSession>;
  @useResult
  $Res call(
      {String id,
      String title,
      String personaId,
      DateTime createdAt,
      DateTime updatedAt,
      bool isArchived,
      bool isPinned,
      List<String> tags,
      int messageCount,
      int totalTokens,
      ChatSessionConfig? config,
      Map<String, dynamic>? metadata});

  $ChatSessionConfigCopyWith<$Res>? get config;
}

/// @nodoc
class _$ChatSessionCopyWithImpl<$Res, $Val extends ChatSession>
    implements $ChatSessionCopyWith<$Res> {
  _$ChatSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? personaId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
    Object? isPinned = null,
    Object? tags = null,
    Object? messageCount = null,
    Object? totalTokens = null,
    Object? config = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      personaId: null == personaId
          ? _value.personaId
          : personaId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ChatSessionConfig?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatSessionConfigCopyWith<$Res>? get config {
    if (_value.config == null) {
      return null;
    }

    return $ChatSessionConfigCopyWith<$Res>(_value.config!, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatSessionImplCopyWith<$Res>
    implements $ChatSessionCopyWith<$Res> {
  factory _$$ChatSessionImplCopyWith(
          _$ChatSessionImpl value, $Res Function(_$ChatSessionImpl) then) =
      __$$ChatSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String personaId,
      DateTime createdAt,
      DateTime updatedAt,
      bool isArchived,
      bool isPinned,
      List<String> tags,
      int messageCount,
      int totalTokens,
      ChatSessionConfig? config,
      Map<String, dynamic>? metadata});

  @override
  $ChatSessionConfigCopyWith<$Res>? get config;
}

/// @nodoc
class __$$ChatSessionImplCopyWithImpl<$Res>
    extends _$ChatSessionCopyWithImpl<$Res, _$ChatSessionImpl>
    implements _$$ChatSessionImplCopyWith<$Res> {
  __$$ChatSessionImplCopyWithImpl(
      _$ChatSessionImpl _value, $Res Function(_$ChatSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? personaId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
    Object? isPinned = null,
    Object? tags = null,
    Object? messageCount = null,
    Object? totalTokens = null,
    Object? config = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ChatSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      personaId: null == personaId
          ? _value.personaId
          : personaId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ChatSessionConfig?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSessionImpl implements _ChatSession {
  const _$ChatSessionImpl(
      {required this.id,
      required this.title,
      required this.personaId,
      required this.createdAt,
      required this.updatedAt,
      this.isArchived = false,
      this.isPinned = false,
      final List<String> tags = ChatMessageDefaults.emptyStringList,
      this.messageCount = 0,
      this.totalTokens = 0,
      this.config,
      final Map<String, dynamic>? metadata})
      : _tags = tags,
        _metadata = metadata;

  factory _$ChatSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSessionImplFromJson(json);

  /// 会话唯一标识符
  @override
  final String id;

  /// 会话标题
  @override
  final String title;

  /// 关联的智能体ID
  @override
  final String personaId;

  /// 会话创建时间
  @override
  final DateTime createdAt;

  /// 最后更新时间
  @override
  final DateTime updatedAt;

  /// 会话是否已归档
  @override
  @JsonKey()
  final bool isArchived;

  /// 会话是否置顶
  @override
  @JsonKey()
  final bool isPinned;

  /// 会话标签
  final List<String> _tags;

  /// 会话标签
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 消息总数
  @override
  @JsonKey()
  final int messageCount;

  /// 总token使用量
  @override
  @JsonKey()
  final int totalTokens;

  /// 会话配置
  @override
  final ChatSessionConfig? config;

  /// 会话元数据
  final Map<String, dynamic>? _metadata;

  /// 会话元数据
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ChatSession(id: $id, title: $title, personaId: $personaId, createdAt: $createdAt, updatedAt: $updatedAt, isArchived: $isArchived, isPinned: $isPinned, tags: $tags, messageCount: $messageCount, totalTokens: $totalTokens, config: $config, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.personaId, personaId) ||
                other.personaId == personaId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens) &&
            (identical(other.config, config) || other.config == config) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      personaId,
      createdAt,
      updatedAt,
      isArchived,
      isPinned,
      const DeepCollectionEquality().hash(_tags),
      messageCount,
      totalTokens,
      config,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      __$$ChatSessionImplCopyWithImpl<_$ChatSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSessionImplToJson(
      this,
    );
  }
}

abstract class _ChatSession implements ChatSession {
  const factory _ChatSession(
      {required final String id,
      required final String title,
      required final String personaId,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isArchived,
      final bool isPinned,
      final List<String> tags,
      final int messageCount,
      final int totalTokens,
      final ChatSessionConfig? config,
      final Map<String, dynamic>? metadata}) = _$ChatSessionImpl;

  factory _ChatSession.fromJson(Map<String, dynamic> json) =
      _$ChatSessionImpl.fromJson;

  @override

  /// 会话唯一标识符
  String get id;
  @override

  /// 会话标题
  String get title;
  @override

  /// 关联的智能体ID
  String get personaId;
  @override

  /// 会话创建时间
  DateTime get createdAt;
  @override

  /// 最后更新时间
  DateTime get updatedAt;
  @override

  /// 会话是否已归档
  bool get isArchived;
  @override

  /// 会话是否置顶
  bool get isPinned;
  @override

  /// 会话标签
  List<String> get tags;
  @override

  /// 消息总数
  int get messageCount;
  @override

  /// 总token使用量
  int get totalTokens;
  @override

  /// 会话配置
  ChatSessionConfig? get config;
  @override

  /// 会话元数据
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ChatSessionImplCopyWith<_$ChatSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatSessionConfig _$ChatSessionConfigFromJson(Map<String, dynamic> json) {
  return _ChatSessionConfig.fromJson(json);
}

/// @nodoc
mixin _$ChatSessionConfig {
  /// 上下文窗口大小
  int get contextWindowSize => throw _privateConstructorUsedError;

  /// 温度参数
  double get temperature => throw _privateConstructorUsedError;

  /// 最大生成token数
  int get maxTokens => throw _privateConstructorUsedError;

  /// 是否启用流式响应
  bool get enableStreaming => throw _privateConstructorUsedError;

  /// 是否启用RAG
  bool get enableRAG => throw _privateConstructorUsedError;

  /// RAG知识库ID列表
  List<String> get knowledgeBaseIds => throw _privateConstructorUsedError;

  /// 系统提示词覆盖（可选）
  String? get systemPromptOverride => throw _privateConstructorUsedError;

  /// 自定义参数
  Map<String, dynamic>? get customParams => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatSessionConfigCopyWith<ChatSessionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSessionConfigCopyWith<$Res> {
  factory $ChatSessionConfigCopyWith(
          ChatSessionConfig value, $Res Function(ChatSessionConfig) then) =
      _$ChatSessionConfigCopyWithImpl<$Res, ChatSessionConfig>;
  @useResult
  $Res call(
      {int contextWindowSize,
      double temperature,
      int maxTokens,
      bool enableStreaming,
      bool enableRAG,
      List<String> knowledgeBaseIds,
      String? systemPromptOverride,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class _$ChatSessionConfigCopyWithImpl<$Res, $Val extends ChatSessionConfig>
    implements $ChatSessionConfigCopyWith<$Res> {
  _$ChatSessionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contextWindowSize = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? enableRAG = null,
    Object? knowledgeBaseIds = null,
    Object? systemPromptOverride = freezed,
    Object? customParams = freezed,
  }) {
    return _then(_value.copyWith(
      contextWindowSize: null == contextWindowSize
          ? _value.contextWindowSize
          : contextWindowSize // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      enableStreaming: null == enableStreaming
          ? _value.enableStreaming
          : enableStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      enableRAG: null == enableRAG
          ? _value.enableRAG
          : enableRAG // ignore: cast_nullable_to_non_nullable
              as bool,
      knowledgeBaseIds: null == knowledgeBaseIds
          ? _value.knowledgeBaseIds
          : knowledgeBaseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      systemPromptOverride: freezed == systemPromptOverride
          ? _value.systemPromptOverride
          : systemPromptOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      customParams: freezed == customParams
          ? _value.customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSessionConfigImplCopyWith<$Res>
    implements $ChatSessionConfigCopyWith<$Res> {
  factory _$$ChatSessionConfigImplCopyWith(_$ChatSessionConfigImpl value,
          $Res Function(_$ChatSessionConfigImpl) then) =
      __$$ChatSessionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int contextWindowSize,
      double temperature,
      int maxTokens,
      bool enableStreaming,
      bool enableRAG,
      List<String> knowledgeBaseIds,
      String? systemPromptOverride,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class __$$ChatSessionConfigImplCopyWithImpl<$Res>
    extends _$ChatSessionConfigCopyWithImpl<$Res, _$ChatSessionConfigImpl>
    implements _$$ChatSessionConfigImplCopyWith<$Res> {
  __$$ChatSessionConfigImplCopyWithImpl(_$ChatSessionConfigImpl _value,
      $Res Function(_$ChatSessionConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contextWindowSize = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? enableRAG = null,
    Object? knowledgeBaseIds = null,
    Object? systemPromptOverride = freezed,
    Object? customParams = freezed,
  }) {
    return _then(_$ChatSessionConfigImpl(
      contextWindowSize: null == contextWindowSize
          ? _value.contextWindowSize
          : contextWindowSize // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      enableStreaming: null == enableStreaming
          ? _value.enableStreaming
          : enableStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      enableRAG: null == enableRAG
          ? _value.enableRAG
          : enableRAG // ignore: cast_nullable_to_non_nullable
              as bool,
      knowledgeBaseIds: null == knowledgeBaseIds
          ? _value._knowledgeBaseIds
          : knowledgeBaseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      systemPromptOverride: freezed == systemPromptOverride
          ? _value.systemPromptOverride
          : systemPromptOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      customParams: freezed == customParams
          ? _value._customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSessionConfigImpl implements _ChatSessionConfig {
  const _$ChatSessionConfigImpl(
      {this.contextWindowSize = ChatMessageDefaults.defaultContextWindowSize,
      this.temperature = ChatMessageDefaults.defaultTemperature,
      this.maxTokens = ChatMessageDefaults.defaultMaxTokens,
      this.enableStreaming = true,
      this.enableRAG = false,
      final List<String> knowledgeBaseIds =
          ChatMessageDefaults.emptyKnowledgeBaseIds,
      this.systemPromptOverride,
      final Map<String, dynamic>? customParams})
      : _knowledgeBaseIds = knowledgeBaseIds,
        _customParams = customParams;

  factory _$ChatSessionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSessionConfigImplFromJson(json);

  /// 上下文窗口大小
  @override
  @JsonKey()
  final int contextWindowSize;

  /// 温度参数
  @override
  @JsonKey()
  final double temperature;

  /// 最大生成token数
  @override
  @JsonKey()
  final int maxTokens;

  /// 是否启用流式响应
  @override
  @JsonKey()
  final bool enableStreaming;

  /// 是否启用RAG
  @override
  @JsonKey()
  final bool enableRAG;

  /// RAG知识库ID列表
  final List<String> _knowledgeBaseIds;

  /// RAG知识库ID列表
  @override
  @JsonKey()
  List<String> get knowledgeBaseIds {
    if (_knowledgeBaseIds is EqualUnmodifiableListView)
      return _knowledgeBaseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_knowledgeBaseIds);
  }

  /// 系统提示词覆盖（可选）
  @override
  final String? systemPromptOverride;

  /// 自定义参数
  final Map<String, dynamic>? _customParams;

  /// 自定义参数
  @override
  Map<String, dynamic>? get customParams {
    final value = _customParams;
    if (value == null) return null;
    if (_customParams is EqualUnmodifiableMapView) return _customParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ChatSessionConfig(contextWindowSize: $contextWindowSize, temperature: $temperature, maxTokens: $maxTokens, enableStreaming: $enableStreaming, enableRAG: $enableRAG, knowledgeBaseIds: $knowledgeBaseIds, systemPromptOverride: $systemPromptOverride, customParams: $customParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSessionConfigImpl &&
            (identical(other.contextWindowSize, contextWindowSize) ||
                other.contextWindowSize == contextWindowSize) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.enableStreaming, enableStreaming) ||
                other.enableStreaming == enableStreaming) &&
            (identical(other.enableRAG, enableRAG) ||
                other.enableRAG == enableRAG) &&
            const DeepCollectionEquality()
                .equals(other._knowledgeBaseIds, _knowledgeBaseIds) &&
            (identical(other.systemPromptOverride, systemPromptOverride) ||
                other.systemPromptOverride == systemPromptOverride) &&
            const DeepCollectionEquality()
                .equals(other._customParams, _customParams));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contextWindowSize,
      temperature,
      maxTokens,
      enableStreaming,
      enableRAG,
      const DeepCollectionEquality().hash(_knowledgeBaseIds),
      systemPromptOverride,
      const DeepCollectionEquality().hash(_customParams));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSessionConfigImplCopyWith<_$ChatSessionConfigImpl> get copyWith =>
      __$$ChatSessionConfigImplCopyWithImpl<_$ChatSessionConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSessionConfigImplToJson(
      this,
    );
  }
}

abstract class _ChatSessionConfig implements ChatSessionConfig {
  const factory _ChatSessionConfig(
      {final int contextWindowSize,
      final double temperature,
      final int maxTokens,
      final bool enableStreaming,
      final bool enableRAG,
      final List<String> knowledgeBaseIds,
      final String? systemPromptOverride,
      final Map<String, dynamic>? customParams}) = _$ChatSessionConfigImpl;

  factory _ChatSessionConfig.fromJson(Map<String, dynamic> json) =
      _$ChatSessionConfigImpl.fromJson;

  @override

  /// 上下文窗口大小
  int get contextWindowSize;
  @override

  /// 温度参数
  double get temperature;
  @override

  /// 最大生成token数
  int get maxTokens;
  @override

  /// 是否启用流式响应
  bool get enableStreaming;
  @override

  /// 是否启用RAG
  bool get enableRAG;
  @override

  /// RAG知识库ID列表
  List<String> get knowledgeBaseIds;
  @override

  /// 系统提示词覆盖（可选）
  String? get systemPromptOverride;
  @override

  /// 自定义参数
  Map<String, dynamic>? get customParams;
  @override
  @JsonKey(ignore: true)
  _$$ChatSessionConfigImplCopyWith<_$ChatSessionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
