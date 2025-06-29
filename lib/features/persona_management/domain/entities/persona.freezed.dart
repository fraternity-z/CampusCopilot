// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persona.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Persona _$PersonaFromJson(Map<String, dynamic> json) {
  return _Persona.fromJson(json);
}

/// @nodoc
mixin _$Persona {
  /// 智能体唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 智能体名称
  String get name => throw _privateConstructorUsedError;

  /// 智能体描述
  String get description => throw _privateConstructorUsedError;

  /// 系统提示词
  String get systemPrompt => throw _privateConstructorUsedError;

  /// 关联的API配置ID
  String get apiConfigId => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 最后使用时间
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;

  /// 智能体类型/分类
  String get category => throw _privateConstructorUsedError;

  /// 智能体标签
  List<String> get tags => throw _privateConstructorUsedError;

  /// 智能体头像/图标
  String? get avatar => throw _privateConstructorUsedError;

  /// 是否为默认智能体
  bool get isDefault => throw _privateConstructorUsedError;

  /// 是否启用
  bool get isEnabled => throw _privateConstructorUsedError;

  /// 使用次数统计
  int get usageCount => throw _privateConstructorUsedError;

  /// 智能体配置
  PersonaConfig? get config => throw _privateConstructorUsedError;

  /// 智能体能力列表
  List<PersonaCapability> get capabilities =>
      throw _privateConstructorUsedError;

  /// 元数据
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Persona to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaCopyWith<Persona> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaCopyWith<$Res> {
  factory $PersonaCopyWith(Persona value, $Res Function(Persona) then) =
      _$PersonaCopyWithImpl<$Res, Persona>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String systemPrompt,
      String apiConfigId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastUsedAt,
      String category,
      List<String> tags,
      String? avatar,
      bool isDefault,
      bool isEnabled,
      int usageCount,
      PersonaConfig? config,
      List<PersonaCapability> capabilities,
      Map<String, dynamic>? metadata});

  $PersonaConfigCopyWith<$Res>? get config;
}

/// @nodoc
class _$PersonaCopyWithImpl<$Res, $Val extends Persona>
    implements $PersonaCopyWith<$Res> {
  _$PersonaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? systemPrompt = null,
    Object? apiConfigId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = freezed,
    Object? category = null,
    Object? tags = null,
    Object? avatar = freezed,
    Object? isDefault = null,
    Object? isEnabled = null,
    Object? usageCount = null,
    Object? config = freezed,
    Object? capabilities = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      apiConfigId: null == apiConfigId
          ? _value.apiConfigId
          : apiConfigId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as PersonaConfig?,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<PersonaCapability>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonaConfigCopyWith<$Res>? get config {
    if (_value.config == null) {
      return null;
    }

    return $PersonaConfigCopyWith<$Res>(_value.config!, (value) {
      return _then(_value.copyWith(config: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonaImplCopyWith<$Res> implements $PersonaCopyWith<$Res> {
  factory _$$PersonaImplCopyWith(
          _$PersonaImpl value, $Res Function(_$PersonaImpl) then) =
      __$$PersonaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String systemPrompt,
      String apiConfigId,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastUsedAt,
      String category,
      List<String> tags,
      String? avatar,
      bool isDefault,
      bool isEnabled,
      int usageCount,
      PersonaConfig? config,
      List<PersonaCapability> capabilities,
      Map<String, dynamic>? metadata});

  @override
  $PersonaConfigCopyWith<$Res>? get config;
}

/// @nodoc
class __$$PersonaImplCopyWithImpl<$Res>
    extends _$PersonaCopyWithImpl<$Res, _$PersonaImpl>
    implements _$$PersonaImplCopyWith<$Res> {
  __$$PersonaImplCopyWithImpl(
      _$PersonaImpl _value, $Res Function(_$PersonaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? systemPrompt = null,
    Object? apiConfigId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = freezed,
    Object? category = null,
    Object? tags = null,
    Object? avatar = freezed,
    Object? isDefault = null,
    Object? isEnabled = null,
    Object? usageCount = null,
    Object? config = freezed,
    Object? capabilities = null,
    Object? metadata = freezed,
  }) {
    return _then(_$PersonaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      apiConfigId: null == apiConfigId
          ? _value.apiConfigId
          : apiConfigId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as PersonaConfig?,
      capabilities: null == capabilities
          ? _value._capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<PersonaCapability>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaImpl implements _Persona {
  const _$PersonaImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.systemPrompt,
      required this.apiConfigId,
      required this.createdAt,
      required this.updatedAt,
      this.lastUsedAt,
      this.category = 'assistant',
      final List<String> tags = const [],
      this.avatar,
      this.isDefault = false,
      this.isEnabled = true,
      this.usageCount = 0,
      this.config,
      final List<PersonaCapability> capabilities = const [],
      final Map<String, dynamic>? metadata})
      : _tags = tags,
        _capabilities = capabilities,
        _metadata = metadata;

  factory _$PersonaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaImplFromJson(json);

  /// 智能体唯一标识符
  @override
  final String id;

  /// 智能体名称
  @override
  final String name;

  /// 智能体描述
  @override
  final String description;

  /// 系统提示词
  @override
  final String systemPrompt;

  /// 关联的API配置ID
  @override
  final String apiConfigId;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 最后更新时间
  @override
  final DateTime updatedAt;

  /// 最后使用时间
  @override
  final DateTime? lastUsedAt;

  /// 智能体类型/分类
  @override
  @JsonKey()
  final String category;

  /// 智能体标签
  final List<String> _tags;

  /// 智能体标签
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 智能体头像/图标
  @override
  final String? avatar;

  /// 是否为默认智能体
  @override
  @JsonKey()
  final bool isDefault;

  /// 是否启用
  @override
  @JsonKey()
  final bool isEnabled;

  /// 使用次数统计
  @override
  @JsonKey()
  final int usageCount;

  /// 智能体配置
  @override
  final PersonaConfig? config;

  /// 智能体能力列表
  final List<PersonaCapability> _capabilities;

  /// 智能体能力列表
  @override
  @JsonKey()
  List<PersonaCapability> get capabilities {
    if (_capabilities is EqualUnmodifiableListView) return _capabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capabilities);
  }

  /// 元数据
  final Map<String, dynamic>? _metadata;

  /// 元数据
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
    return 'Persona(id: $id, name: $name, description: $description, systemPrompt: $systemPrompt, apiConfigId: $apiConfigId, createdAt: $createdAt, updatedAt: $updatedAt, lastUsedAt: $lastUsedAt, category: $category, tags: $tags, avatar: $avatar, isDefault: $isDefault, isEnabled: $isEnabled, usageCount: $usageCount, config: $config, capabilities: $capabilities, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.apiConfigId, apiConfigId) ||
                other.apiConfigId == apiConfigId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.config, config) || other.config == config) &&
            const DeepCollectionEquality()
                .equals(other._capabilities, _capabilities) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      systemPrompt,
      apiConfigId,
      createdAt,
      updatedAt,
      lastUsedAt,
      category,
      const DeepCollectionEquality().hash(_tags),
      avatar,
      isDefault,
      isEnabled,
      usageCount,
      config,
      const DeepCollectionEquality().hash(_capabilities),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      __$$PersonaImplCopyWithImpl<_$PersonaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaImplToJson(
      this,
    );
  }
}

abstract class _Persona implements Persona {
  const factory _Persona(
      {required final String id,
      required final String name,
      required final String description,
      required final String systemPrompt,
      required final String apiConfigId,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? lastUsedAt,
      final String category,
      final List<String> tags,
      final String? avatar,
      final bool isDefault,
      final bool isEnabled,
      final int usageCount,
      final PersonaConfig? config,
      final List<PersonaCapability> capabilities,
      final Map<String, dynamic>? metadata}) = _$PersonaImpl;

  factory _Persona.fromJson(Map<String, dynamic> json) = _$PersonaImpl.fromJson;

  /// 智能体唯一标识符
  @override
  String get id;

  /// 智能体名称
  @override
  String get name;

  /// 智能体描述
  @override
  String get description;

  /// 系统提示词
  @override
  String get systemPrompt;

  /// 关联的API配置ID
  @override
  String get apiConfigId;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 最后更新时间
  @override
  DateTime get updatedAt;

  /// 最后使用时间
  @override
  DateTime? get lastUsedAt;

  /// 智能体类型/分类
  @override
  String get category;

  /// 智能体标签
  @override
  List<String> get tags;

  /// 智能体头像/图标
  @override
  String? get avatar;

  /// 是否为默认智能体
  @override
  bool get isDefault;

  /// 是否启用
  @override
  bool get isEnabled;

  /// 使用次数统计
  @override
  int get usageCount;

  /// 智能体配置
  @override
  PersonaConfig? get config;

  /// 智能体能力列表
  @override
  List<PersonaCapability> get capabilities;

  /// 元数据
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonaConfig _$PersonaConfigFromJson(Map<String, dynamic> json) {
  return _PersonaConfig.fromJson(json);
}

/// @nodoc
mixin _$PersonaConfig {
  /// 温度参数
  double get temperature => throw _privateConstructorUsedError;

  /// 最大生成token数
  int get maxTokens => throw _privateConstructorUsedError;

  /// Top-p参数
  double get topP => throw _privateConstructorUsedError;

  /// 频率惩罚
  double get frequencyPenalty => throw _privateConstructorUsedError;

  /// 存在惩罚
  double get presencePenalty => throw _privateConstructorUsedError;

  /// 停止词列表
  List<String> get stopSequences => throw _privateConstructorUsedError;

  /// 是否启用流式响应
  bool get enableStreaming => throw _privateConstructorUsedError;

  /// 上下文管理策略
  ContextStrategy get contextStrategy => throw _privateConstructorUsedError;

  /// 上下文窗口大小
  int get contextWindowSize => throw _privateConstructorUsedError;

  /// 是否启用RAG
  bool get enableRAG => throw _privateConstructorUsedError;

  /// 默认知识库ID列表
  List<String> get defaultKnowledgeBases => throw _privateConstructorUsedError;

  /// 自定义参数
  Map<String, dynamic>? get customParams => throw _privateConstructorUsedError;

  /// Serializes this PersonaConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonaConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaConfigCopyWith<PersonaConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaConfigCopyWith<$Res> {
  factory $PersonaConfigCopyWith(
          PersonaConfig value, $Res Function(PersonaConfig) then) =
      _$PersonaConfigCopyWithImpl<$Res, PersonaConfig>;
  @useResult
  $Res call(
      {double temperature,
      int maxTokens,
      double topP,
      double frequencyPenalty,
      double presencePenalty,
      List<String> stopSequences,
      bool enableStreaming,
      ContextStrategy contextStrategy,
      int contextWindowSize,
      bool enableRAG,
      List<String> defaultKnowledgeBases,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class _$PersonaConfigCopyWithImpl<$Res, $Val extends PersonaConfig>
    implements $PersonaConfigCopyWith<$Res> {
  _$PersonaConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonaConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? maxTokens = null,
    Object? topP = null,
    Object? frequencyPenalty = null,
    Object? presencePenalty = null,
    Object? stopSequences = null,
    Object? enableStreaming = null,
    Object? contextStrategy = null,
    Object? contextWindowSize = null,
    Object? enableRAG = null,
    Object? defaultKnowledgeBases = null,
    Object? customParams = freezed,
  }) {
    return _then(_value.copyWith(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      frequencyPenalty: null == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      presencePenalty: null == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double,
      stopSequences: null == stopSequences
          ? _value.stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enableStreaming: null == enableStreaming
          ? _value.enableStreaming
          : enableStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      contextStrategy: null == contextStrategy
          ? _value.contextStrategy
          : contextStrategy // ignore: cast_nullable_to_non_nullable
              as ContextStrategy,
      contextWindowSize: null == contextWindowSize
          ? _value.contextWindowSize
          : contextWindowSize // ignore: cast_nullable_to_non_nullable
              as int,
      enableRAG: null == enableRAG
          ? _value.enableRAG
          : enableRAG // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultKnowledgeBases: null == defaultKnowledgeBases
          ? _value.defaultKnowledgeBases
          : defaultKnowledgeBases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customParams: freezed == customParams
          ? _value.customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaConfigImplCopyWith<$Res>
    implements $PersonaConfigCopyWith<$Res> {
  factory _$$PersonaConfigImplCopyWith(
          _$PersonaConfigImpl value, $Res Function(_$PersonaConfigImpl) then) =
      __$$PersonaConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double temperature,
      int maxTokens,
      double topP,
      double frequencyPenalty,
      double presencePenalty,
      List<String> stopSequences,
      bool enableStreaming,
      ContextStrategy contextStrategy,
      int contextWindowSize,
      bool enableRAG,
      List<String> defaultKnowledgeBases,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class __$$PersonaConfigImplCopyWithImpl<$Res>
    extends _$PersonaConfigCopyWithImpl<$Res, _$PersonaConfigImpl>
    implements _$$PersonaConfigImplCopyWith<$Res> {
  __$$PersonaConfigImplCopyWithImpl(
      _$PersonaConfigImpl _value, $Res Function(_$PersonaConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonaConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? maxTokens = null,
    Object? topP = null,
    Object? frequencyPenalty = null,
    Object? presencePenalty = null,
    Object? stopSequences = null,
    Object? enableStreaming = null,
    Object? contextStrategy = null,
    Object? contextWindowSize = null,
    Object? enableRAG = null,
    Object? defaultKnowledgeBases = null,
    Object? customParams = freezed,
  }) {
    return _then(_$PersonaConfigImpl(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      frequencyPenalty: null == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      presencePenalty: null == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double,
      stopSequences: null == stopSequences
          ? _value._stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enableStreaming: null == enableStreaming
          ? _value.enableStreaming
          : enableStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      contextStrategy: null == contextStrategy
          ? _value.contextStrategy
          : contextStrategy // ignore: cast_nullable_to_non_nullable
              as ContextStrategy,
      contextWindowSize: null == contextWindowSize
          ? _value.contextWindowSize
          : contextWindowSize // ignore: cast_nullable_to_non_nullable
              as int,
      enableRAG: null == enableRAG
          ? _value.enableRAG
          : enableRAG // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultKnowledgeBases: null == defaultKnowledgeBases
          ? _value._defaultKnowledgeBases
          : defaultKnowledgeBases // ignore: cast_nullable_to_non_nullable
              as List<String>,
      customParams: freezed == customParams
          ? _value._customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaConfigImpl implements _PersonaConfig {
  const _$PersonaConfigImpl(
      {this.temperature = 0.7,
      this.maxTokens = 2048,
      this.topP = 1.0,
      this.frequencyPenalty = 0.0,
      this.presencePenalty = 0.0,
      final List<String> stopSequences = const [],
      this.enableStreaming = true,
      this.contextStrategy = ContextStrategy.truncate,
      this.contextWindowSize = 4096,
      this.enableRAG = false,
      final List<String> defaultKnowledgeBases = const [],
      final Map<String, dynamic>? customParams})
      : _stopSequences = stopSequences,
        _defaultKnowledgeBases = defaultKnowledgeBases,
        _customParams = customParams;

  factory _$PersonaConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaConfigImplFromJson(json);

  /// 温度参数
  @override
  @JsonKey()
  final double temperature;

  /// 最大生成token数
  @override
  @JsonKey()
  final int maxTokens;

  /// Top-p参数
  @override
  @JsonKey()
  final double topP;

  /// 频率惩罚
  @override
  @JsonKey()
  final double frequencyPenalty;

  /// 存在惩罚
  @override
  @JsonKey()
  final double presencePenalty;

  /// 停止词列表
  final List<String> _stopSequences;

  /// 停止词列表
  @override
  @JsonKey()
  List<String> get stopSequences {
    if (_stopSequences is EqualUnmodifiableListView) return _stopSequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stopSequences);
  }

  /// 是否启用流式响应
  @override
  @JsonKey()
  final bool enableStreaming;

  /// 上下文管理策略
  @override
  @JsonKey()
  final ContextStrategy contextStrategy;

  /// 上下文窗口大小
  @override
  @JsonKey()
  final int contextWindowSize;

  /// 是否启用RAG
  @override
  @JsonKey()
  final bool enableRAG;

  /// 默认知识库ID列表
  final List<String> _defaultKnowledgeBases;

  /// 默认知识库ID列表
  @override
  @JsonKey()
  List<String> get defaultKnowledgeBases {
    if (_defaultKnowledgeBases is EqualUnmodifiableListView)
      return _defaultKnowledgeBases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultKnowledgeBases);
  }

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
    return 'PersonaConfig(temperature: $temperature, maxTokens: $maxTokens, topP: $topP, frequencyPenalty: $frequencyPenalty, presencePenalty: $presencePenalty, stopSequences: $stopSequences, enableStreaming: $enableStreaming, contextStrategy: $contextStrategy, contextWindowSize: $contextWindowSize, enableRAG: $enableRAG, defaultKnowledgeBases: $defaultKnowledgeBases, customParams: $customParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaConfigImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.topP, topP) || other.topP == topP) &&
            (identical(other.frequencyPenalty, frequencyPenalty) ||
                other.frequencyPenalty == frequencyPenalty) &&
            (identical(other.presencePenalty, presencePenalty) ||
                other.presencePenalty == presencePenalty) &&
            const DeepCollectionEquality()
                .equals(other._stopSequences, _stopSequences) &&
            (identical(other.enableStreaming, enableStreaming) ||
                other.enableStreaming == enableStreaming) &&
            (identical(other.contextStrategy, contextStrategy) ||
                other.contextStrategy == contextStrategy) &&
            (identical(other.contextWindowSize, contextWindowSize) ||
                other.contextWindowSize == contextWindowSize) &&
            (identical(other.enableRAG, enableRAG) ||
                other.enableRAG == enableRAG) &&
            const DeepCollectionEquality()
                .equals(other._defaultKnowledgeBases, _defaultKnowledgeBases) &&
            const DeepCollectionEquality()
                .equals(other._customParams, _customParams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      temperature,
      maxTokens,
      topP,
      frequencyPenalty,
      presencePenalty,
      const DeepCollectionEquality().hash(_stopSequences),
      enableStreaming,
      contextStrategy,
      contextWindowSize,
      enableRAG,
      const DeepCollectionEquality().hash(_defaultKnowledgeBases),
      const DeepCollectionEquality().hash(_customParams));

  /// Create a copy of PersonaConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaConfigImplCopyWith<_$PersonaConfigImpl> get copyWith =>
      __$$PersonaConfigImplCopyWithImpl<_$PersonaConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaConfigImplToJson(
      this,
    );
  }
}

abstract class _PersonaConfig implements PersonaConfig {
  const factory _PersonaConfig(
      {final double temperature,
      final int maxTokens,
      final double topP,
      final double frequencyPenalty,
      final double presencePenalty,
      final List<String> stopSequences,
      final bool enableStreaming,
      final ContextStrategy contextStrategy,
      final int contextWindowSize,
      final bool enableRAG,
      final List<String> defaultKnowledgeBases,
      final Map<String, dynamic>? customParams}) = _$PersonaConfigImpl;

  factory _PersonaConfig.fromJson(Map<String, dynamic> json) =
      _$PersonaConfigImpl.fromJson;

  /// 温度参数
  @override
  double get temperature;

  /// 最大生成token数
  @override
  int get maxTokens;

  /// Top-p参数
  @override
  double get topP;

  /// 频率惩罚
  @override
  double get frequencyPenalty;

  /// 存在惩罚
  @override
  double get presencePenalty;

  /// 停止词列表
  @override
  List<String> get stopSequences;

  /// 是否启用流式响应
  @override
  bool get enableStreaming;

  /// 上下文管理策略
  @override
  ContextStrategy get contextStrategy;

  /// 上下文窗口大小
  @override
  int get contextWindowSize;

  /// 是否启用RAG
  @override
  bool get enableRAG;

  /// 默认知识库ID列表
  @override
  List<String> get defaultKnowledgeBases;

  /// 自定义参数
  @override
  Map<String, dynamic>? get customParams;

  /// Create a copy of PersonaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaConfigImplCopyWith<_$PersonaConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonaCapability _$PersonaCapabilityFromJson(Map<String, dynamic> json) {
  return _PersonaCapability.fromJson(json);
}

/// @nodoc
mixin _$PersonaCapability {
  /// 能力ID
  String get id => throw _privateConstructorUsedError;

  /// 能力名称
  String get name => throw _privateConstructorUsedError;

  /// 能力描述
  String get description => throw _privateConstructorUsedError;

  /// 能力类型
  CapabilityType get type => throw _privateConstructorUsedError;

  /// 是否启用
  bool get isEnabled => throw _privateConstructorUsedError;

  /// 能力配置
  Map<String, dynamic>? get config => throw _privateConstructorUsedError;

  /// Serializes this PersonaCapability to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonaCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaCapabilityCopyWith<PersonaCapability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaCapabilityCopyWith<$Res> {
  factory $PersonaCapabilityCopyWith(
          PersonaCapability value, $Res Function(PersonaCapability) then) =
      _$PersonaCapabilityCopyWithImpl<$Res, PersonaCapability>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      CapabilityType type,
      bool isEnabled,
      Map<String, dynamic>? config});
}

/// @nodoc
class _$PersonaCapabilityCopyWithImpl<$Res, $Val extends PersonaCapability>
    implements $PersonaCapabilityCopyWith<$Res> {
  _$PersonaCapabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonaCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? isEnabled = null,
    Object? config = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CapabilityType,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaCapabilityImplCopyWith<$Res>
    implements $PersonaCapabilityCopyWith<$Res> {
  factory _$$PersonaCapabilityImplCopyWith(_$PersonaCapabilityImpl value,
          $Res Function(_$PersonaCapabilityImpl) then) =
      __$$PersonaCapabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      CapabilityType type,
      bool isEnabled,
      Map<String, dynamic>? config});
}

/// @nodoc
class __$$PersonaCapabilityImplCopyWithImpl<$Res>
    extends _$PersonaCapabilityCopyWithImpl<$Res, _$PersonaCapabilityImpl>
    implements _$$PersonaCapabilityImplCopyWith<$Res> {
  __$$PersonaCapabilityImplCopyWithImpl(_$PersonaCapabilityImpl _value,
      $Res Function(_$PersonaCapabilityImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonaCapability
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? isEnabled = null,
    Object? config = freezed,
  }) {
    return _then(_$PersonaCapabilityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CapabilityType,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      config: freezed == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaCapabilityImpl implements _PersonaCapability {
  const _$PersonaCapabilityImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      this.isEnabled = true,
      final Map<String, dynamic>? config})
      : _config = config;

  factory _$PersonaCapabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaCapabilityImplFromJson(json);

  /// 能力ID
  @override
  final String id;

  /// 能力名称
  @override
  final String name;

  /// 能力描述
  @override
  final String description;

  /// 能力类型
  @override
  final CapabilityType type;

  /// 是否启用
  @override
  @JsonKey()
  final bool isEnabled;

  /// 能力配置
  final Map<String, dynamic>? _config;

  /// 能力配置
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PersonaCapability(id: $id, name: $name, description: $description, type: $type, isEnabled: $isEnabled, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaCapabilityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, type,
      isEnabled, const DeepCollectionEquality().hash(_config));

  /// Create a copy of PersonaCapability
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaCapabilityImplCopyWith<_$PersonaCapabilityImpl> get copyWith =>
      __$$PersonaCapabilityImplCopyWithImpl<_$PersonaCapabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaCapabilityImplToJson(
      this,
    );
  }
}

abstract class _PersonaCapability implements PersonaCapability {
  const factory _PersonaCapability(
      {required final String id,
      required final String name,
      required final String description,
      required final CapabilityType type,
      final bool isEnabled,
      final Map<String, dynamic>? config}) = _$PersonaCapabilityImpl;

  factory _PersonaCapability.fromJson(Map<String, dynamic> json) =
      _$PersonaCapabilityImpl.fromJson;

  /// 能力ID
  @override
  String get id;

  /// 能力名称
  @override
  String get name;

  /// 能力描述
  @override
  String get description;

  /// 能力类型
  @override
  CapabilityType get type;

  /// 是否启用
  @override
  bool get isEnabled;

  /// 能力配置
  @override
  Map<String, dynamic>? get config;

  /// Create a copy of PersonaCapability
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaCapabilityImplCopyWith<_$PersonaCapabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
