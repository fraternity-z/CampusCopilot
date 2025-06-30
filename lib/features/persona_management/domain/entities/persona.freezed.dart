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

  /// 系统提示词（角色设定）
  String get systemPrompt => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 最后使用时间
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;

  /// 智能体头像图片路径（本地文件路径）
  String? get avatarImagePath => throw _privateConstructorUsedError;

  /// 智能体头像emoji（当没有图片时使用）
  String get avatarEmoji => throw _privateConstructorUsedError;

  /// 智能体头像 (兼容性字段)
  String? get avatar => throw _privateConstructorUsedError;

  /// API配置ID
  String? get apiConfigId => throw _privateConstructorUsedError;

  /// 是否为默认智能体
  bool get isDefault => throw _privateConstructorUsedError;

  /// 是否启用
  bool get isEnabled => throw _privateConstructorUsedError;

  /// 使用次数统计
  int get usageCount => throw _privateConstructorUsedError;

  /// 智能体简短描述（可选）
  String? get description => throw _privateConstructorUsedError;

  /// 智能体标签
  List<String> get tags => throw _privateConstructorUsedError;

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
      String systemPrompt,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastUsedAt,
      String? avatarImagePath,
      String avatarEmoji,
      String? avatar,
      String? apiConfigId,
      bool isDefault,
      bool isEnabled,
      int usageCount,
      String? description,
      List<String> tags,
      Map<String, dynamic>? metadata});
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
    Object? systemPrompt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = freezed,
    Object? avatarImagePath = freezed,
    Object? avatarEmoji = null,
    Object? avatar = freezed,
    Object? apiConfigId = freezed,
    Object? isDefault = null,
    Object? isEnabled = null,
    Object? usageCount = null,
    Object? description = freezed,
    Object? tags = null,
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
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
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
      avatarImagePath: freezed == avatarImagePath
          ? _value.avatarImagePath
          : avatarImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarEmoji: null == avatarEmoji
          ? _value.avatarEmoji
          : avatarEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      apiConfigId: freezed == apiConfigId
          ? _value.apiConfigId
          : apiConfigId // ignore: cast_nullable_to_non_nullable
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
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
      String systemPrompt,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? lastUsedAt,
      String? avatarImagePath,
      String avatarEmoji,
      String? avatar,
      String? apiConfigId,
      bool isDefault,
      bool isEnabled,
      int usageCount,
      String? description,
      List<String> tags,
      Map<String, dynamic>? metadata});
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
    Object? systemPrompt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastUsedAt = freezed,
    Object? avatarImagePath = freezed,
    Object? avatarEmoji = null,
    Object? avatar = freezed,
    Object? apiConfigId = freezed,
    Object? isDefault = null,
    Object? isEnabled = null,
    Object? usageCount = null,
    Object? description = freezed,
    Object? tags = null,
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
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
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
      avatarImagePath: freezed == avatarImagePath
          ? _value.avatarImagePath
          : avatarImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarEmoji: null == avatarEmoji
          ? _value.avatarEmoji
          : avatarEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      apiConfigId: freezed == apiConfigId
          ? _value.apiConfigId
          : apiConfigId // ignore: cast_nullable_to_non_nullable
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
      required this.systemPrompt,
      required this.createdAt,
      required this.updatedAt,
      this.lastUsedAt,
      this.avatarImagePath,
      this.avatarEmoji = '🤖',
      this.avatar,
      this.apiConfigId,
      this.isDefault = false,
      this.isEnabled = true,
      this.usageCount = 0,
      this.description,
      final List<String> tags = const [],
      final Map<String, dynamic>? metadata})
      : _tags = tags,
        _metadata = metadata;

  factory _$PersonaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaImplFromJson(json);

  /// 智能体唯一标识符
  @override
  final String id;

  /// 智能体名称
  @override
  final String name;

  /// 系统提示词（角色设定）
  @override
  final String systemPrompt;

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 最后更新时间
  @override
  final DateTime updatedAt;

  /// 最后使用时间
  @override
  final DateTime? lastUsedAt;

  /// 智能体头像图片路径（本地文件路径）
  @override
  final String? avatarImagePath;

  /// 智能体头像emoji（当没有图片时使用）
  @override
  @JsonKey()
  final String avatarEmoji;

  /// 智能体头像 (兼容性字段)
  @override
  final String? avatar;

  /// API配置ID
  @override
  final String? apiConfigId;

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

  /// 智能体简短描述（可选）
  @override
  final String? description;

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
    return 'Persona(id: $id, name: $name, systemPrompt: $systemPrompt, createdAt: $createdAt, updatedAt: $updatedAt, lastUsedAt: $lastUsedAt, avatarImagePath: $avatarImagePath, avatarEmoji: $avatarEmoji, avatar: $avatar, apiConfigId: $apiConfigId, isDefault: $isDefault, isEnabled: $isEnabled, usageCount: $usageCount, description: $description, tags: $tags, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.avatarImagePath, avatarImagePath) ||
                other.avatarImagePath == avatarImagePath) &&
            (identical(other.avatarEmoji, avatarEmoji) ||
                other.avatarEmoji == avatarEmoji) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.apiConfigId, apiConfigId) ||
                other.apiConfigId == apiConfigId) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      systemPrompt,
      createdAt,
      updatedAt,
      lastUsedAt,
      avatarImagePath,
      avatarEmoji,
      avatar,
      apiConfigId,
      isDefault,
      isEnabled,
      usageCount,
      description,
      const DeepCollectionEquality().hash(_tags),
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
      required final String systemPrompt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? lastUsedAt,
      final String? avatarImagePath,
      final String avatarEmoji,
      final String? avatar,
      final String? apiConfigId,
      final bool isDefault,
      final bool isEnabled,
      final int usageCount,
      final String? description,
      final List<String> tags,
      final Map<String, dynamic>? metadata}) = _$PersonaImpl;

  factory _Persona.fromJson(Map<String, dynamic> json) = _$PersonaImpl.fromJson;

  /// 智能体唯一标识符
  @override
  String get id;

  /// 智能体名称
  @override
  String get name;

  /// 系统提示词（角色设定）
  @override
  String get systemPrompt;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// 最后更新时间
  @override
  DateTime get updatedAt;

  /// 最后使用时间
  @override
  DateTime? get lastUsedAt;

  /// 智能体头像图片路径（本地文件路径）
  @override
  String? get avatarImagePath;

  /// 智能体头像emoji（当没有图片时使用）
  @override
  String get avatarEmoji;

  /// 智能体头像 (兼容性字段)
  @override
  String? get avatar;

  /// API配置ID
  @override
  String? get apiConfigId;

  /// 是否为默认智能体
  @override
  bool get isDefault;

  /// 是否启用
  @override
  bool get isEnabled;

  /// 使用次数统计
  @override
  int get usageCount;

  /// 智能体简短描述（可选）
  @override
  String? get description;

  /// 智能体标签
  @override
  List<String> get tags;

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
