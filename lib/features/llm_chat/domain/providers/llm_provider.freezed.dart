// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LlmConfig _$LlmConfigFromJson(Map<String, dynamic> json) {
  return _LlmConfig.fromJson(json);
}

/// @nodoc
mixin _$LlmConfig {
  /// 配置ID
  String get id => throw _privateConstructorUsedError;

  /// 配置名称
  String get name => throw _privateConstructorUsedError;

  /// 提供商类型
  String get provider => throw _privateConstructorUsedError;

  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String? get defaultModel => throw _privateConstructorUsedError;

  /// 默认嵌入模型
  String? get defaultEmbeddingModel => throw _privateConstructorUsedError;

  /// 组织ID（OpenAI）
  String? get organizationId => throw _privateConstructorUsedError;

  /// 项目ID（某些供应商）
  String? get projectId => throw _privateConstructorUsedError;

  /// 额外配置参数
  Map<String, dynamic>? get extraParams => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 是否启用
  bool get isEnabled => throw _privateConstructorUsedError;

  /// 是否为自定义提供商
  bool get isCustomProvider => throw _privateConstructorUsedError;

  /// API兼容性类型 (openai, gemini, anthropic, custom)
  String get apiCompatibilityType => throw _privateConstructorUsedError;

  /// 自定义提供商显示名称
  String? get customProviderName => throw _privateConstructorUsedError;

  /// 自定义提供商描述
  String? get customProviderDescription => throw _privateConstructorUsedError;

  /// 自定义提供商图标（可选）
  String? get customProviderIcon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LlmConfigCopyWith<LlmConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LlmConfigCopyWith<$Res> {
  factory $LlmConfigCopyWith(LlmConfig value, $Res Function(LlmConfig) then) =
      _$LlmConfigCopyWithImpl<$Res, LlmConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String provider,
      String apiKey,
      String? baseUrl,
      String? defaultModel,
      String? defaultEmbeddingModel,
      String? organizationId,
      String? projectId,
      Map<String, dynamic>? extraParams,
      DateTime createdAt,
      DateTime updatedAt,
      bool isEnabled,
      bool isCustomProvider,
      String apiCompatibilityType,
      String? customProviderName,
      String? customProviderDescription,
      String? customProviderIcon});
}

/// @nodoc
class _$LlmConfigCopyWithImpl<$Res, $Val extends LlmConfig>
    implements $LlmConfigCopyWith<$Res> {
  _$LlmConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = freezed,
    Object? defaultEmbeddingModel = freezed,
    Object? organizationId = freezed,
    Object? projectId = freezed,
    Object? extraParams = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isEnabled = null,
    Object? isCustomProvider = null,
    Object? apiCompatibilityType = null,
    Object? customProviderName = freezed,
    Object? customProviderDescription = freezed,
    Object? customProviderIcon = freezed,
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
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultModel: freezed == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultEmbeddingModel: freezed == defaultEmbeddingModel
          ? _value.defaultEmbeddingModel
          : defaultEmbeddingModel // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      extraParams: freezed == extraParams
          ? _value.extraParams
          : extraParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isCustomProvider: null == isCustomProvider
          ? _value.isCustomProvider
          : isCustomProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      apiCompatibilityType: null == apiCompatibilityType
          ? _value.apiCompatibilityType
          : apiCompatibilityType // ignore: cast_nullable_to_non_nullable
              as String,
      customProviderName: freezed == customProviderName
          ? _value.customProviderName
          : customProviderName // ignore: cast_nullable_to_non_nullable
              as String?,
      customProviderDescription: freezed == customProviderDescription
          ? _value.customProviderDescription
          : customProviderDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      customProviderIcon: freezed == customProviderIcon
          ? _value.customProviderIcon
          : customProviderIcon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LlmConfigImplCopyWith<$Res>
    implements $LlmConfigCopyWith<$Res> {
  factory _$$LlmConfigImplCopyWith(
          _$LlmConfigImpl value, $Res Function(_$LlmConfigImpl) then) =
      __$$LlmConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String provider,
      String apiKey,
      String? baseUrl,
      String? defaultModel,
      String? defaultEmbeddingModel,
      String? organizationId,
      String? projectId,
      Map<String, dynamic>? extraParams,
      DateTime createdAt,
      DateTime updatedAt,
      bool isEnabled,
      bool isCustomProvider,
      String apiCompatibilityType,
      String? customProviderName,
      String? customProviderDescription,
      String? customProviderIcon});
}

/// @nodoc
class __$$LlmConfigImplCopyWithImpl<$Res>
    extends _$LlmConfigCopyWithImpl<$Res, _$LlmConfigImpl>
    implements _$$LlmConfigImplCopyWith<$Res> {
  __$$LlmConfigImplCopyWithImpl(
      _$LlmConfigImpl _value, $Res Function(_$LlmConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = freezed,
    Object? defaultEmbeddingModel = freezed,
    Object? organizationId = freezed,
    Object? projectId = freezed,
    Object? extraParams = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isEnabled = null,
    Object? isCustomProvider = null,
    Object? apiCompatibilityType = null,
    Object? customProviderName = freezed,
    Object? customProviderDescription = freezed,
    Object? customProviderIcon = freezed,
  }) {
    return _then(_$LlmConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultModel: freezed == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultEmbeddingModel: freezed == defaultEmbeddingModel
          ? _value.defaultEmbeddingModel
          : defaultEmbeddingModel // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      extraParams: freezed == extraParams
          ? _value._extraParams
          : extraParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isCustomProvider: null == isCustomProvider
          ? _value.isCustomProvider
          : isCustomProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      apiCompatibilityType: null == apiCompatibilityType
          ? _value.apiCompatibilityType
          : apiCompatibilityType // ignore: cast_nullable_to_non_nullable
              as String,
      customProviderName: freezed == customProviderName
          ? _value.customProviderName
          : customProviderName // ignore: cast_nullable_to_non_nullable
              as String?,
      customProviderDescription: freezed == customProviderDescription
          ? _value.customProviderDescription
          : customProviderDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      customProviderIcon: freezed == customProviderIcon
          ? _value.customProviderIcon
          : customProviderIcon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LlmConfigImpl implements _LlmConfig {
  const _$LlmConfigImpl(
      {required this.id,
      required this.name,
      required this.provider,
      required this.apiKey,
      this.baseUrl,
      this.defaultModel,
      this.defaultEmbeddingModel,
      this.organizationId,
      this.projectId,
      final Map<String, dynamic>? extraParams,
      required this.createdAt,
      required this.updatedAt,
      this.isEnabled = true,
      this.isCustomProvider = false,
      this.apiCompatibilityType = 'openai',
      this.customProviderName,
      this.customProviderDescription,
      this.customProviderIcon})
      : _extraParams = extraParams;

  factory _$LlmConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LlmConfigImplFromJson(json);

  /// 配置ID
  @override
  final String id;

  /// 配置名称
  @override
  final String name;

  /// 提供商类型
  @override
  final String provider;

  /// API密钥
  @override
  final String apiKey;

  /// 基础URL（可选，用于代理）
  @override
  final String? baseUrl;

  /// 默认模型
  @override
  final String? defaultModel;

  /// 默认嵌入模型
  @override
  final String? defaultEmbeddingModel;

  /// 组织ID（OpenAI）
  @override
  final String? organizationId;

  /// 项目ID（某些供应商）
  @override
  final String? projectId;

  /// 额外配置参数
  final Map<String, dynamic>? _extraParams;

  /// 额外配置参数
  @override
  Map<String, dynamic>? get extraParams {
    final value = _extraParams;
    if (value == null) return null;
    if (_extraParams is EqualUnmodifiableMapView) return _extraParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 创建时间
  @override
  final DateTime createdAt;

  /// 最后更新时间
  @override
  final DateTime updatedAt;

  /// 是否启用
  @override
  @JsonKey()
  final bool isEnabled;

  /// 是否为自定义提供商
  @override
  @JsonKey()
  final bool isCustomProvider;

  /// API兼容性类型 (openai, gemini, anthropic, custom)
  @override
  @JsonKey()
  final String apiCompatibilityType;

  /// 自定义提供商显示名称
  @override
  final String? customProviderName;

  /// 自定义提供商描述
  @override
  final String? customProviderDescription;

  /// 自定义提供商图标（可选）
  @override
  final String? customProviderIcon;

  @override
  String toString() {
    return 'LlmConfig(id: $id, name: $name, provider: $provider, apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel, defaultEmbeddingModel: $defaultEmbeddingModel, organizationId: $organizationId, projectId: $projectId, extraParams: $extraParams, createdAt: $createdAt, updatedAt: $updatedAt, isEnabled: $isEnabled, isCustomProvider: $isCustomProvider, apiCompatibilityType: $apiCompatibilityType, customProviderName: $customProviderName, customProviderDescription: $customProviderDescription, customProviderIcon: $customProviderIcon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LlmConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel) &&
            (identical(other.defaultEmbeddingModel, defaultEmbeddingModel) ||
                other.defaultEmbeddingModel == defaultEmbeddingModel) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            const DeepCollectionEquality()
                .equals(other._extraParams, _extraParams) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.isCustomProvider, isCustomProvider) ||
                other.isCustomProvider == isCustomProvider) &&
            (identical(other.apiCompatibilityType, apiCompatibilityType) ||
                other.apiCompatibilityType == apiCompatibilityType) &&
            (identical(other.customProviderName, customProviderName) ||
                other.customProviderName == customProviderName) &&
            (identical(other.customProviderDescription,
                    customProviderDescription) ||
                other.customProviderDescription == customProviderDescription) &&
            (identical(other.customProviderIcon, customProviderIcon) ||
                other.customProviderIcon == customProviderIcon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      provider,
      apiKey,
      baseUrl,
      defaultModel,
      defaultEmbeddingModel,
      organizationId,
      projectId,
      const DeepCollectionEquality().hash(_extraParams),
      createdAt,
      updatedAt,
      isEnabled,
      isCustomProvider,
      apiCompatibilityType,
      customProviderName,
      customProviderDescription,
      customProviderIcon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LlmConfigImplCopyWith<_$LlmConfigImpl> get copyWith =>
      __$$LlmConfigImplCopyWithImpl<_$LlmConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LlmConfigImplToJson(
      this,
    );
  }
}

abstract class _LlmConfig implements LlmConfig {
  const factory _LlmConfig(
      {required final String id,
      required final String name,
      required final String provider,
      required final String apiKey,
      final String? baseUrl,
      final String? defaultModel,
      final String? defaultEmbeddingModel,
      final String? organizationId,
      final String? projectId,
      final Map<String, dynamic>? extraParams,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isEnabled,
      final bool isCustomProvider,
      final String apiCompatibilityType,
      final String? customProviderName,
      final String? customProviderDescription,
      final String? customProviderIcon}) = _$LlmConfigImpl;

  factory _LlmConfig.fromJson(Map<String, dynamic> json) =
      _$LlmConfigImpl.fromJson;

  @override

  /// 配置ID
  String get id;
  @override

  /// 配置名称
  String get name;
  @override

  /// 提供商类型
  String get provider;
  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String? get defaultModel;
  @override

  /// 默认嵌入模型
  String? get defaultEmbeddingModel;
  @override

  /// 组织ID（OpenAI）
  String? get organizationId;
  @override

  /// 项目ID（某些供应商）
  String? get projectId;
  @override

  /// 额外配置参数
  Map<String, dynamic>? get extraParams;
  @override

  /// 创建时间
  DateTime get createdAt;
  @override

  /// 最后更新时间
  DateTime get updatedAt;
  @override

  /// 是否启用
  bool get isEnabled;
  @override

  /// 是否为自定义提供商
  bool get isCustomProvider;
  @override

  /// API兼容性类型 (openai, gemini, anthropic, custom)
  String get apiCompatibilityType;
  @override

  /// 自定义提供商显示名称
  String? get customProviderName;
  @override

  /// 自定义提供商描述
  String? get customProviderDescription;
  @override

  /// 自定义提供商图标（可选）
  String? get customProviderIcon;
  @override
  @JsonKey(ignore: true)
  _$$LlmConfigImplCopyWith<_$LlmConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ModelInfo _$ModelInfoFromJson(Map<String, dynamic> json) {
  return _ModelInfo.fromJson(json);
}

/// @nodoc
mixin _$ModelInfo {
  /// 模型ID
  String get id => throw _privateConstructorUsedError;

  /// 模型名称
  String get name => throw _privateConstructorUsedError;

  /// 模型描述
  String? get description => throw _privateConstructorUsedError;

  /// 模型类型
  ModelType get type => throw _privateConstructorUsedError;

  /// 上下文窗口大小
  int? get contextWindow => throw _privateConstructorUsedError;

  /// 最大输出token数
  int? get maxOutputTokens => throw _privateConstructorUsedError;

  /// 是否支持流式响应
  bool get supportsStreaming => throw _privateConstructorUsedError;

  /// 是否支持函数调用
  bool get supportsFunctionCalling => throw _privateConstructorUsedError;

  /// 是否支持视觉输入
  bool get supportsVision => throw _privateConstructorUsedError;

  /// 定价信息
  PricingInfo? get pricing => throw _privateConstructorUsedError;

  /// 模型能力标签
  List<String> get capabilities => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModelInfoCopyWith<ModelInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelInfoCopyWith<$Res> {
  factory $ModelInfoCopyWith(ModelInfo value, $Res Function(ModelInfo) then) =
      _$ModelInfoCopyWithImpl<$Res, ModelInfo>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      ModelType type,
      int? contextWindow,
      int? maxOutputTokens,
      bool supportsStreaming,
      bool supportsFunctionCalling,
      bool supportsVision,
      PricingInfo? pricing,
      List<String> capabilities});

  $PricingInfoCopyWith<$Res>? get pricing;
}

/// @nodoc
class _$ModelInfoCopyWithImpl<$Res, $Val extends ModelInfo>
    implements $ModelInfoCopyWith<$Res> {
  _$ModelInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? contextWindow = freezed,
    Object? maxOutputTokens = freezed,
    Object? supportsStreaming = null,
    Object? supportsFunctionCalling = null,
    Object? supportsVision = null,
    Object? pricing = freezed,
    Object? capabilities = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModelType,
      contextWindow: freezed == contextWindow
          ? _value.contextWindow
          : contextWindow // ignore: cast_nullable_to_non_nullable
              as int?,
      maxOutputTokens: freezed == maxOutputTokens
          ? _value.maxOutputTokens
          : maxOutputTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      supportsStreaming: null == supportsStreaming
          ? _value.supportsStreaming
          : supportsStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsFunctionCalling: null == supportsFunctionCalling
          ? _value.supportsFunctionCalling
          : supportsFunctionCalling // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsVision: null == supportsVision
          ? _value.supportsVision
          : supportsVision // ignore: cast_nullable_to_non_nullable
              as bool,
      pricing: freezed == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as PricingInfo?,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PricingInfoCopyWith<$Res>? get pricing {
    if (_value.pricing == null) {
      return null;
    }

    return $PricingInfoCopyWith<$Res>(_value.pricing!, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ModelInfoImplCopyWith<$Res>
    implements $ModelInfoCopyWith<$Res> {
  factory _$$ModelInfoImplCopyWith(
          _$ModelInfoImpl value, $Res Function(_$ModelInfoImpl) then) =
      __$$ModelInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      ModelType type,
      int? contextWindow,
      int? maxOutputTokens,
      bool supportsStreaming,
      bool supportsFunctionCalling,
      bool supportsVision,
      PricingInfo? pricing,
      List<String> capabilities});

  @override
  $PricingInfoCopyWith<$Res>? get pricing;
}

/// @nodoc
class __$$ModelInfoImplCopyWithImpl<$Res>
    extends _$ModelInfoCopyWithImpl<$Res, _$ModelInfoImpl>
    implements _$$ModelInfoImplCopyWith<$Res> {
  __$$ModelInfoImplCopyWithImpl(
      _$ModelInfoImpl _value, $Res Function(_$ModelInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? contextWindow = freezed,
    Object? maxOutputTokens = freezed,
    Object? supportsStreaming = null,
    Object? supportsFunctionCalling = null,
    Object? supportsVision = null,
    Object? pricing = freezed,
    Object? capabilities = null,
  }) {
    return _then(_$ModelInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ModelType,
      contextWindow: freezed == contextWindow
          ? _value.contextWindow
          : contextWindow // ignore: cast_nullable_to_non_nullable
              as int?,
      maxOutputTokens: freezed == maxOutputTokens
          ? _value.maxOutputTokens
          : maxOutputTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      supportsStreaming: null == supportsStreaming
          ? _value.supportsStreaming
          : supportsStreaming // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsFunctionCalling: null == supportsFunctionCalling
          ? _value.supportsFunctionCalling
          : supportsFunctionCalling // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsVision: null == supportsVision
          ? _value.supportsVision
          : supportsVision // ignore: cast_nullable_to_non_nullable
              as bool,
      pricing: freezed == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as PricingInfo?,
      capabilities: null == capabilities
          ? _value._capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelInfoImpl implements _ModelInfo {
  const _$ModelInfoImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.type,
      this.contextWindow,
      this.maxOutputTokens,
      this.supportsStreaming = true,
      this.supportsFunctionCalling = false,
      this.supportsVision = false,
      this.pricing,
      final List<String> capabilities = const []})
      : _capabilities = capabilities;

  factory _$ModelInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelInfoImplFromJson(json);

  /// 模型ID
  @override
  final String id;

  /// 模型名称
  @override
  final String name;

  /// 模型描述
  @override
  final String? description;

  /// 模型类型
  @override
  final ModelType type;

  /// 上下文窗口大小
  @override
  final int? contextWindow;

  /// 最大输出token数
  @override
  final int? maxOutputTokens;

  /// 是否支持流式响应
  @override
  @JsonKey()
  final bool supportsStreaming;

  /// 是否支持函数调用
  @override
  @JsonKey()
  final bool supportsFunctionCalling;

  /// 是否支持视觉输入
  @override
  @JsonKey()
  final bool supportsVision;

  /// 定价信息
  @override
  final PricingInfo? pricing;

  /// 模型能力标签
  final List<String> _capabilities;

  /// 模型能力标签
  @override
  @JsonKey()
  List<String> get capabilities {
    if (_capabilities is EqualUnmodifiableListView) return _capabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capabilities);
  }

  @override
  String toString() {
    return 'ModelInfo(id: $id, name: $name, description: $description, type: $type, contextWindow: $contextWindow, maxOutputTokens: $maxOutputTokens, supportsStreaming: $supportsStreaming, supportsFunctionCalling: $supportsFunctionCalling, supportsVision: $supportsVision, pricing: $pricing, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.contextWindow, contextWindow) ||
                other.contextWindow == contextWindow) &&
            (identical(other.maxOutputTokens, maxOutputTokens) ||
                other.maxOutputTokens == maxOutputTokens) &&
            (identical(other.supportsStreaming, supportsStreaming) ||
                other.supportsStreaming == supportsStreaming) &&
            (identical(
                    other.supportsFunctionCalling, supportsFunctionCalling) ||
                other.supportsFunctionCalling == supportsFunctionCalling) &&
            (identical(other.supportsVision, supportsVision) ||
                other.supportsVision == supportsVision) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            const DeepCollectionEquality()
                .equals(other._capabilities, _capabilities));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      type,
      contextWindow,
      maxOutputTokens,
      supportsStreaming,
      supportsFunctionCalling,
      supportsVision,
      pricing,
      const DeepCollectionEquality().hash(_capabilities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelInfoImplCopyWith<_$ModelInfoImpl> get copyWith =>
      __$$ModelInfoImplCopyWithImpl<_$ModelInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelInfoImplToJson(
      this,
    );
  }
}

abstract class _ModelInfo implements ModelInfo {
  const factory _ModelInfo(
      {required final String id,
      required final String name,
      final String? description,
      required final ModelType type,
      final int? contextWindow,
      final int? maxOutputTokens,
      final bool supportsStreaming,
      final bool supportsFunctionCalling,
      final bool supportsVision,
      final PricingInfo? pricing,
      final List<String> capabilities}) = _$ModelInfoImpl;

  factory _ModelInfo.fromJson(Map<String, dynamic> json) =
      _$ModelInfoImpl.fromJson;

  @override

  /// 模型ID
  String get id;
  @override

  /// 模型名称
  String get name;
  @override

  /// 模型描述
  String? get description;
  @override

  /// 模型类型
  ModelType get type;
  @override

  /// 上下文窗口大小
  int? get contextWindow;
  @override

  /// 最大输出token数
  int? get maxOutputTokens;
  @override

  /// 是否支持流式响应
  bool get supportsStreaming;
  @override

  /// 是否支持函数调用
  bool get supportsFunctionCalling;
  @override

  /// 是否支持视觉输入
  bool get supportsVision;
  @override

  /// 定价信息
  PricingInfo? get pricing;
  @override

  /// 模型能力标签
  List<String> get capabilities;
  @override
  @JsonKey(ignore: true)
  _$$ModelInfoImplCopyWith<_$ModelInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PricingInfo _$PricingInfoFromJson(Map<String, dynamic> json) {
  return _PricingInfo.fromJson(json);
}

/// @nodoc
mixin _$PricingInfo {
  /// 输入token价格（每1K token）
  double? get inputPrice => throw _privateConstructorUsedError;

  /// 输出token价格（每1K token）
  double? get outputPrice => throw _privateConstructorUsedError;

  /// 货币单位
  String get currency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PricingInfoCopyWith<PricingInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PricingInfoCopyWith<$Res> {
  factory $PricingInfoCopyWith(
          PricingInfo value, $Res Function(PricingInfo) then) =
      _$PricingInfoCopyWithImpl<$Res, PricingInfo>;
  @useResult
  $Res call({double? inputPrice, double? outputPrice, String currency});
}

/// @nodoc
class _$PricingInfoCopyWithImpl<$Res, $Val extends PricingInfo>
    implements $PricingInfoCopyWith<$Res> {
  _$PricingInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputPrice = freezed,
    Object? outputPrice = freezed,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      inputPrice: freezed == inputPrice
          ? _value.inputPrice
          : inputPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      outputPrice: freezed == outputPrice
          ? _value.outputPrice
          : outputPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PricingInfoImplCopyWith<$Res>
    implements $PricingInfoCopyWith<$Res> {
  factory _$$PricingInfoImplCopyWith(
          _$PricingInfoImpl value, $Res Function(_$PricingInfoImpl) then) =
      __$$PricingInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? inputPrice, double? outputPrice, String currency});
}

/// @nodoc
class __$$PricingInfoImplCopyWithImpl<$Res>
    extends _$PricingInfoCopyWithImpl<$Res, _$PricingInfoImpl>
    implements _$$PricingInfoImplCopyWith<$Res> {
  __$$PricingInfoImplCopyWithImpl(
      _$PricingInfoImpl _value, $Res Function(_$PricingInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputPrice = freezed,
    Object? outputPrice = freezed,
    Object? currency = null,
  }) {
    return _then(_$PricingInfoImpl(
      inputPrice: freezed == inputPrice
          ? _value.inputPrice
          : inputPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      outputPrice: freezed == outputPrice
          ? _value.outputPrice
          : outputPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PricingInfoImpl implements _PricingInfo {
  const _$PricingInfoImpl(
      {this.inputPrice, this.outputPrice, this.currency = 'USD'});

  factory _$PricingInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PricingInfoImplFromJson(json);

  /// 输入token价格（每1K token）
  @override
  final double? inputPrice;

  /// 输出token价格（每1K token）
  @override
  final double? outputPrice;

  /// 货币单位
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'PricingInfo(inputPrice: $inputPrice, outputPrice: $outputPrice, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PricingInfoImpl &&
            (identical(other.inputPrice, inputPrice) ||
                other.inputPrice == inputPrice) &&
            (identical(other.outputPrice, outputPrice) ||
                other.outputPrice == outputPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, inputPrice, outputPrice, currency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PricingInfoImplCopyWith<_$PricingInfoImpl> get copyWith =>
      __$$PricingInfoImplCopyWithImpl<_$PricingInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PricingInfoImplToJson(
      this,
    );
  }
}

abstract class _PricingInfo implements PricingInfo {
  const factory _PricingInfo(
      {final double? inputPrice,
      final double? outputPrice,
      final String currency}) = _$PricingInfoImpl;

  factory _PricingInfo.fromJson(Map<String, dynamic> json) =
      _$PricingInfoImpl.fromJson;

  @override

  /// 输入token价格（每1K token）
  double? get inputPrice;
  @override

  /// 输出token价格（每1K token）
  double? get outputPrice;
  @override

  /// 货币单位
  String get currency;
  @override
  @JsonKey(ignore: true)
  _$$PricingInfoImplCopyWith<_$PricingInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatOptions _$ChatOptionsFromJson(Map<String, dynamic> json) {
  return _ChatOptions.fromJson(json);
}

/// @nodoc
mixin _$ChatOptions {
  /// 使用的模型
  String? get model => throw _privateConstructorUsedError;

  /// 温度参数
  double? get temperature => throw _privateConstructorUsedError;

  /// 最大生成token数
  int? get maxTokens => throw _privateConstructorUsedError;

  /// Top-p参数
  double? get topP => throw _privateConstructorUsedError;

  /// 频率惩罚
  double? get frequencyPenalty => throw _privateConstructorUsedError;

  /// 存在惩罚
  double? get presencePenalty => throw _privateConstructorUsedError;

  /// 停止词
  List<String>? get stopSequences => throw _privateConstructorUsedError;

  /// 是否启用流式响应
  bool? get stream => throw _privateConstructorUsedError;

  /// 系统提示词
  String? get systemPrompt => throw _privateConstructorUsedError;

  /// 工具列表（函数调用）
  List<ToolDefinition>? get tools => throw _privateConstructorUsedError;

  /// 思考努力程度（用于o1/o3等模型）
  /// 可选值：'low', 'medium', 'high'
  String? get reasoningEffort => throw _privateConstructorUsedError;

  /// 最大思考token数（用于Gemini等模型）
  int? get maxReasoningTokens => throw _privateConstructorUsedError;

  /// 自定义参数
  Map<String, dynamic>? get customParams => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatOptionsCopyWith<ChatOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatOptionsCopyWith<$Res> {
  factory $ChatOptionsCopyWith(
          ChatOptions value, $Res Function(ChatOptions) then) =
      _$ChatOptionsCopyWithImpl<$Res, ChatOptions>;
  @useResult
  $Res call(
      {String? model,
      double? temperature,
      int? maxTokens,
      double? topP,
      double? frequencyPenalty,
      double? presencePenalty,
      List<String>? stopSequences,
      bool? stream,
      String? systemPrompt,
      List<ToolDefinition>? tools,
      String? reasoningEffort,
      int? maxReasoningTokens,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class _$ChatOptionsCopyWithImpl<$Res, $Val extends ChatOptions>
    implements $ChatOptionsCopyWith<$Res> {
  _$ChatOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? temperature = freezed,
    Object? maxTokens = freezed,
    Object? topP = freezed,
    Object? frequencyPenalty = freezed,
    Object? presencePenalty = freezed,
    Object? stopSequences = freezed,
    Object? stream = freezed,
    Object? systemPrompt = freezed,
    Object? tools = freezed,
    Object? reasoningEffort = freezed,
    Object? maxReasoningTokens = freezed,
    Object? customParams = freezed,
  }) {
    return _then(_value.copyWith(
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTokens: freezed == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      topP: freezed == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double?,
      frequencyPenalty: freezed == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double?,
      presencePenalty: freezed == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double?,
      stopSequences: freezed == stopSequences
          ? _value.stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as bool?,
      systemPrompt: freezed == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      tools: freezed == tools
          ? _value.tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ToolDefinition>?,
      reasoningEffort: freezed == reasoningEffort
          ? _value.reasoningEffort
          : reasoningEffort // ignore: cast_nullable_to_non_nullable
              as String?,
      maxReasoningTokens: freezed == maxReasoningTokens
          ? _value.maxReasoningTokens
          : maxReasoningTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      customParams: freezed == customParams
          ? _value.customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatOptionsImplCopyWith<$Res>
    implements $ChatOptionsCopyWith<$Res> {
  factory _$$ChatOptionsImplCopyWith(
          _$ChatOptionsImpl value, $Res Function(_$ChatOptionsImpl) then) =
      __$$ChatOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? model,
      double? temperature,
      int? maxTokens,
      double? topP,
      double? frequencyPenalty,
      double? presencePenalty,
      List<String>? stopSequences,
      bool? stream,
      String? systemPrompt,
      List<ToolDefinition>? tools,
      String? reasoningEffort,
      int? maxReasoningTokens,
      Map<String, dynamic>? customParams});
}

/// @nodoc
class __$$ChatOptionsImplCopyWithImpl<$Res>
    extends _$ChatOptionsCopyWithImpl<$Res, _$ChatOptionsImpl>
    implements _$$ChatOptionsImplCopyWith<$Res> {
  __$$ChatOptionsImplCopyWithImpl(
      _$ChatOptionsImpl _value, $Res Function(_$ChatOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? temperature = freezed,
    Object? maxTokens = freezed,
    Object? topP = freezed,
    Object? frequencyPenalty = freezed,
    Object? presencePenalty = freezed,
    Object? stopSequences = freezed,
    Object? stream = freezed,
    Object? systemPrompt = freezed,
    Object? tools = freezed,
    Object? reasoningEffort = freezed,
    Object? maxReasoningTokens = freezed,
    Object? customParams = freezed,
  }) {
    return _then(_$ChatOptionsImpl(
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTokens: freezed == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      topP: freezed == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double?,
      frequencyPenalty: freezed == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double?,
      presencePenalty: freezed == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double?,
      stopSequences: freezed == stopSequences
          ? _value._stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as bool?,
      systemPrompt: freezed == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      tools: freezed == tools
          ? _value._tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ToolDefinition>?,
      reasoningEffort: freezed == reasoningEffort
          ? _value.reasoningEffort
          : reasoningEffort // ignore: cast_nullable_to_non_nullable
              as String?,
      maxReasoningTokens: freezed == maxReasoningTokens
          ? _value.maxReasoningTokens
          : maxReasoningTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      customParams: freezed == customParams
          ? _value._customParams
          : customParams // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatOptionsImpl implements _ChatOptions {
  const _$ChatOptionsImpl(
      {this.model,
      this.temperature,
      this.maxTokens,
      this.topP,
      this.frequencyPenalty,
      this.presencePenalty,
      final List<String>? stopSequences,
      this.stream,
      this.systemPrompt,
      final List<ToolDefinition>? tools,
      this.reasoningEffort,
      this.maxReasoningTokens,
      final Map<String, dynamic>? customParams})
      : _stopSequences = stopSequences,
        _tools = tools,
        _customParams = customParams;

  factory _$ChatOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatOptionsImplFromJson(json);

  /// 使用的模型
  @override
  final String? model;

  /// 温度参数
  @override
  final double? temperature;

  /// 最大生成token数
  @override
  final int? maxTokens;

  /// Top-p参数
  @override
  final double? topP;

  /// 频率惩罚
  @override
  final double? frequencyPenalty;

  /// 存在惩罚
  @override
  final double? presencePenalty;

  /// 停止词
  final List<String>? _stopSequences;

  /// 停止词
  @override
  List<String>? get stopSequences {
    final value = _stopSequences;
    if (value == null) return null;
    if (_stopSequences is EqualUnmodifiableListView) return _stopSequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 是否启用流式响应
  @override
  final bool? stream;

  /// 系统提示词
  @override
  final String? systemPrompt;

  /// 工具列表（函数调用）
  final List<ToolDefinition>? _tools;

  /// 工具列表（函数调用）
  @override
  List<ToolDefinition>? get tools {
    final value = _tools;
    if (value == null) return null;
    if (_tools is EqualUnmodifiableListView) return _tools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 思考努力程度（用于o1/o3等模型）
  /// 可选值：'low', 'medium', 'high'
  @override
  final String? reasoningEffort;

  /// 最大思考token数（用于Gemini等模型）
  @override
  final int? maxReasoningTokens;

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
    return 'ChatOptions(model: $model, temperature: $temperature, maxTokens: $maxTokens, topP: $topP, frequencyPenalty: $frequencyPenalty, presencePenalty: $presencePenalty, stopSequences: $stopSequences, stream: $stream, systemPrompt: $systemPrompt, tools: $tools, reasoningEffort: $reasoningEffort, maxReasoningTokens: $maxReasoningTokens, customParams: $customParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatOptionsImpl &&
            (identical(other.model, model) || other.model == model) &&
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
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            const DeepCollectionEquality().equals(other._tools, _tools) &&
            (identical(other.reasoningEffort, reasoningEffort) ||
                other.reasoningEffort == reasoningEffort) &&
            (identical(other.maxReasoningTokens, maxReasoningTokens) ||
                other.maxReasoningTokens == maxReasoningTokens) &&
            const DeepCollectionEquality()
                .equals(other._customParams, _customParams));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      model,
      temperature,
      maxTokens,
      topP,
      frequencyPenalty,
      presencePenalty,
      const DeepCollectionEquality().hash(_stopSequences),
      stream,
      systemPrompt,
      const DeepCollectionEquality().hash(_tools),
      reasoningEffort,
      maxReasoningTokens,
      const DeepCollectionEquality().hash(_customParams));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatOptionsImplCopyWith<_$ChatOptionsImpl> get copyWith =>
      __$$ChatOptionsImplCopyWithImpl<_$ChatOptionsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatOptionsImplToJson(
      this,
    );
  }
}

abstract class _ChatOptions implements ChatOptions {
  const factory _ChatOptions(
      {final String? model,
      final double? temperature,
      final int? maxTokens,
      final double? topP,
      final double? frequencyPenalty,
      final double? presencePenalty,
      final List<String>? stopSequences,
      final bool? stream,
      final String? systemPrompt,
      final List<ToolDefinition>? tools,
      final String? reasoningEffort,
      final int? maxReasoningTokens,
      final Map<String, dynamic>? customParams}) = _$ChatOptionsImpl;

  factory _ChatOptions.fromJson(Map<String, dynamic> json) =
      _$ChatOptionsImpl.fromJson;

  @override

  /// 使用的模型
  String? get model;
  @override

  /// 温度参数
  double? get temperature;
  @override

  /// 最大生成token数
  int? get maxTokens;
  @override

  /// Top-p参数
  double? get topP;
  @override

  /// 频率惩罚
  double? get frequencyPenalty;
  @override

  /// 存在惩罚
  double? get presencePenalty;
  @override

  /// 停止词
  List<String>? get stopSequences;
  @override

  /// 是否启用流式响应
  bool? get stream;
  @override

  /// 系统提示词
  String? get systemPrompt;
  @override

  /// 工具列表（函数调用）
  List<ToolDefinition>? get tools;
  @override

  /// 思考努力程度（用于o1/o3等模型）
  /// 可选值：'low', 'medium', 'high'
  String? get reasoningEffort;
  @override

  /// 最大思考token数（用于Gemini等模型）
  int? get maxReasoningTokens;
  @override

  /// 自定义参数
  Map<String, dynamic>? get customParams;
  @override
  @JsonKey(ignore: true)
  _$$ChatOptionsImplCopyWith<_$ChatOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolDefinition _$ToolDefinitionFromJson(Map<String, dynamic> json) {
  return _ToolDefinition.fromJson(json);
}

/// @nodoc
mixin _$ToolDefinition {
  /// 工具名称
  String get name => throw _privateConstructorUsedError;

  /// 工具描述
  String get description => throw _privateConstructorUsedError;

  /// 参数定义
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolDefinitionCopyWith<ToolDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolDefinitionCopyWith<$Res> {
  factory $ToolDefinitionCopyWith(
          ToolDefinition value, $Res Function(ToolDefinition) then) =
      _$ToolDefinitionCopyWithImpl<$Res, ToolDefinition>;
  @useResult
  $Res call({String name, String description, Map<String, dynamic> parameters});
}

/// @nodoc
class _$ToolDefinitionCopyWithImpl<$Res, $Val extends ToolDefinition>
    implements $ToolDefinitionCopyWith<$Res> {
  _$ToolDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? parameters = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolDefinitionImplCopyWith<$Res>
    implements $ToolDefinitionCopyWith<$Res> {
  factory _$$ToolDefinitionImplCopyWith(_$ToolDefinitionImpl value,
          $Res Function(_$ToolDefinitionImpl) then) =
      __$$ToolDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String description, Map<String, dynamic> parameters});
}

/// @nodoc
class __$$ToolDefinitionImplCopyWithImpl<$Res>
    extends _$ToolDefinitionCopyWithImpl<$Res, _$ToolDefinitionImpl>
    implements _$$ToolDefinitionImplCopyWith<$Res> {
  __$$ToolDefinitionImplCopyWithImpl(
      _$ToolDefinitionImpl _value, $Res Function(_$ToolDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? parameters = null,
  }) {
    return _then(_$ToolDefinitionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolDefinitionImpl implements _ToolDefinition {
  const _$ToolDefinitionImpl(
      {required this.name,
      required this.description,
      required final Map<String, dynamic> parameters})
      : _parameters = parameters;

  factory _$ToolDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolDefinitionImplFromJson(json);

  /// 工具名称
  @override
  final String name;

  /// 工具描述
  @override
  final String description;

  /// 参数定义
  final Map<String, dynamic> _parameters;

  /// 参数定义
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  String toString() {
    return 'ToolDefinition(name: $name, description: $description, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolDefinitionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description,
      const DeepCollectionEquality().hash(_parameters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolDefinitionImplCopyWith<_$ToolDefinitionImpl> get copyWith =>
      __$$ToolDefinitionImplCopyWithImpl<_$ToolDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolDefinitionImplToJson(
      this,
    );
  }
}

abstract class _ToolDefinition implements ToolDefinition {
  const factory _ToolDefinition(
      {required final String name,
      required final String description,
      required final Map<String, dynamic> parameters}) = _$ToolDefinitionImpl;

  factory _ToolDefinition.fromJson(Map<String, dynamic> json) =
      _$ToolDefinitionImpl.fromJson;

  @override

  /// 工具名称
  String get name;
  @override

  /// 工具描述
  String get description;
  @override

  /// 参数定义
  Map<String, dynamic> get parameters;
  @override
  @JsonKey(ignore: true)
  _$$ToolDefinitionImplCopyWith<_$ToolDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatResult _$ChatResultFromJson(Map<String, dynamic> json) {
  return _ChatResult.fromJson(json);
}

/// @nodoc
mixin _$ChatResult {
  /// 生成的内容
  String get content => throw _privateConstructorUsedError;

  /// 使用的模型
  String get model => throw _privateConstructorUsedError;

  /// token使用情况
  TokenUsage get tokenUsage => throw _privateConstructorUsedError;

  /// 完成原因
  FinishReason get finishReason => throw _privateConstructorUsedError;

  /// 工具调用（如果有）
  List<ToolCall>? get toolCalls => throw _privateConstructorUsedError;

  /// 响应时间（毫秒）
  int? get responseTimeMs => throw _privateConstructorUsedError;

  /// 额外元数据
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// 思考链内容（AI思考过程）
  String? get thinkingContent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatResultCopyWith<ChatResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatResultCopyWith<$Res> {
  factory $ChatResultCopyWith(
          ChatResult value, $Res Function(ChatResult) then) =
      _$ChatResultCopyWithImpl<$Res, ChatResult>;
  @useResult
  $Res call(
      {String content,
      String model,
      TokenUsage tokenUsage,
      FinishReason finishReason,
      List<ToolCall>? toolCalls,
      int? responseTimeMs,
      Map<String, dynamic>? metadata,
      String? thinkingContent});

  $TokenUsageCopyWith<$Res> get tokenUsage;
}

/// @nodoc
class _$ChatResultCopyWithImpl<$Res, $Val extends ChatResult>
    implements $ChatResultCopyWith<$Res> {
  _$ChatResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? model = null,
    Object? tokenUsage = null,
    Object? finishReason = null,
    Object? toolCalls = freezed,
    Object? responseTimeMs = freezed,
    Object? metadata = freezed,
    Object? thinkingContent = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUsage: null == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage,
      finishReason: null == finishReason
          ? _value.finishReason
          : finishReason // ignore: cast_nullable_to_non_nullable
              as FinishReason,
      toolCalls: freezed == toolCalls
          ? _value.toolCalls
          : toolCalls // ignore: cast_nullable_to_non_nullable
              as List<ToolCall>?,
      responseTimeMs: freezed == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TokenUsageCopyWith<$Res> get tokenUsage {
    return $TokenUsageCopyWith<$Res>(_value.tokenUsage, (value) {
      return _then(_value.copyWith(tokenUsage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatResultImplCopyWith<$Res>
    implements $ChatResultCopyWith<$Res> {
  factory _$$ChatResultImplCopyWith(
          _$ChatResultImpl value, $Res Function(_$ChatResultImpl) then) =
      __$$ChatResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      String model,
      TokenUsage tokenUsage,
      FinishReason finishReason,
      List<ToolCall>? toolCalls,
      int? responseTimeMs,
      Map<String, dynamic>? metadata,
      String? thinkingContent});

  @override
  $TokenUsageCopyWith<$Res> get tokenUsage;
}

/// @nodoc
class __$$ChatResultImplCopyWithImpl<$Res>
    extends _$ChatResultCopyWithImpl<$Res, _$ChatResultImpl>
    implements _$$ChatResultImplCopyWith<$Res> {
  __$$ChatResultImplCopyWithImpl(
      _$ChatResultImpl _value, $Res Function(_$ChatResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? model = null,
    Object? tokenUsage = null,
    Object? finishReason = null,
    Object? toolCalls = freezed,
    Object? responseTimeMs = freezed,
    Object? metadata = freezed,
    Object? thinkingContent = freezed,
  }) {
    return _then(_$ChatResultImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUsage: null == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage,
      finishReason: null == finishReason
          ? _value.finishReason
          : finishReason // ignore: cast_nullable_to_non_nullable
              as FinishReason,
      toolCalls: freezed == toolCalls
          ? _value._toolCalls
          : toolCalls // ignore: cast_nullable_to_non_nullable
              as List<ToolCall>?,
      responseTimeMs: freezed == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatResultImpl implements _ChatResult {
  const _$ChatResultImpl(
      {required this.content,
      required this.model,
      required this.tokenUsage,
      required this.finishReason,
      final List<ToolCall>? toolCalls,
      this.responseTimeMs,
      final Map<String, dynamic>? metadata,
      this.thinkingContent})
      : _toolCalls = toolCalls,
        _metadata = metadata;

  factory _$ChatResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatResultImplFromJson(json);

  /// 生成的内容
  @override
  final String content;

  /// 使用的模型
  @override
  final String model;

  /// token使用情况
  @override
  final TokenUsage tokenUsage;

  /// 完成原因
  @override
  final FinishReason finishReason;

  /// 工具调用（如果有）
  final List<ToolCall>? _toolCalls;

  /// 工具调用（如果有）
  @override
  List<ToolCall>? get toolCalls {
    final value = _toolCalls;
    if (value == null) return null;
    if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 响应时间（毫秒）
  @override
  final int? responseTimeMs;

  /// 额外元数据
  final Map<String, dynamic>? _metadata;

  /// 额外元数据
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 思考链内容（AI思考过程）
  @override
  final String? thinkingContent;

  @override
  String toString() {
    return 'ChatResult(content: $content, model: $model, tokenUsage: $tokenUsage, finishReason: $finishReason, toolCalls: $toolCalls, responseTimeMs: $responseTimeMs, metadata: $metadata, thinkingContent: $thinkingContent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatResultImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.tokenUsage, tokenUsage) ||
                other.tokenUsage == tokenUsage) &&
            (identical(other.finishReason, finishReason) ||
                other.finishReason == finishReason) &&
            const DeepCollectionEquality()
                .equals(other._toolCalls, _toolCalls) &&
            (identical(other.responseTimeMs, responseTimeMs) ||
                other.responseTimeMs == responseTimeMs) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.thinkingContent, thinkingContent) ||
                other.thinkingContent == thinkingContent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      content,
      model,
      tokenUsage,
      finishReason,
      const DeepCollectionEquality().hash(_toolCalls),
      responseTimeMs,
      const DeepCollectionEquality().hash(_metadata),
      thinkingContent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatResultImplCopyWith<_$ChatResultImpl> get copyWith =>
      __$$ChatResultImplCopyWithImpl<_$ChatResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatResultImplToJson(
      this,
    );
  }
}

abstract class _ChatResult implements ChatResult {
  const factory _ChatResult(
      {required final String content,
      required final String model,
      required final TokenUsage tokenUsage,
      required final FinishReason finishReason,
      final List<ToolCall>? toolCalls,
      final int? responseTimeMs,
      final Map<String, dynamic>? metadata,
      final String? thinkingContent}) = _$ChatResultImpl;

  factory _ChatResult.fromJson(Map<String, dynamic> json) =
      _$ChatResultImpl.fromJson;

  @override

  /// 生成的内容
  String get content;
  @override

  /// 使用的模型
  String get model;
  @override

  /// token使用情况
  TokenUsage get tokenUsage;
  @override

  /// 完成原因
  FinishReason get finishReason;
  @override

  /// 工具调用（如果有）
  List<ToolCall>? get toolCalls;
  @override

  /// 响应时间（毫秒）
  int? get responseTimeMs;
  @override

  /// 额外元数据
  Map<String, dynamic>? get metadata;
  @override

  /// 思考链内容（AI思考过程）
  String? get thinkingContent;
  @override
  @JsonKey(ignore: true)
  _$$ChatResultImplCopyWith<_$ChatResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreamedChatResult _$StreamedChatResultFromJson(Map<String, dynamic> json) {
  return _StreamedChatResult.fromJson(json);
}

/// @nodoc
mixin _$StreamedChatResult {
  /// 增量内容
  String? get delta => throw _privateConstructorUsedError;

  /// 累积内容
  String? get content => throw _privateConstructorUsedError;

  /// 是否完成
  bool get isDone => throw _privateConstructorUsedError;

  /// 使用的模型
  String? get model => throw _privateConstructorUsedError;

  /// token使用情况（仅在完成时）
  TokenUsage? get tokenUsage => throw _privateConstructorUsedError;

  /// 完成原因（仅在完成时）
  FinishReason? get finishReason => throw _privateConstructorUsedError;

  /// 工具调用（如果有）
  List<ToolCall>? get toolCalls => throw _privateConstructorUsedError;

  /// 思考链增量内容
  String? get thinkingDelta => throw _privateConstructorUsedError;

  /// 思考链累积内容
  String? get thinkingContent => throw _privateConstructorUsedError;

  /// 思考链是否完成
  bool get thinkingComplete => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreamedChatResultCopyWith<StreamedChatResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamedChatResultCopyWith<$Res> {
  factory $StreamedChatResultCopyWith(
          StreamedChatResult value, $Res Function(StreamedChatResult) then) =
      _$StreamedChatResultCopyWithImpl<$Res, StreamedChatResult>;
  @useResult
  $Res call(
      {String? delta,
      String? content,
      bool isDone,
      String? model,
      TokenUsage? tokenUsage,
      FinishReason? finishReason,
      List<ToolCall>? toolCalls,
      String? thinkingDelta,
      String? thinkingContent,
      bool thinkingComplete});

  $TokenUsageCopyWith<$Res>? get tokenUsage;
}

/// @nodoc
class _$StreamedChatResultCopyWithImpl<$Res, $Val extends StreamedChatResult>
    implements $StreamedChatResultCopyWith<$Res> {
  _$StreamedChatResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delta = freezed,
    Object? content = freezed,
    Object? isDone = null,
    Object? model = freezed,
    Object? tokenUsage = freezed,
    Object? finishReason = freezed,
    Object? toolCalls = freezed,
    Object? thinkingDelta = freezed,
    Object? thinkingContent = freezed,
    Object? thinkingComplete = null,
  }) {
    return _then(_value.copyWith(
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenUsage: freezed == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage?,
      finishReason: freezed == finishReason
          ? _value.finishReason
          : finishReason // ignore: cast_nullable_to_non_nullable
              as FinishReason?,
      toolCalls: freezed == toolCalls
          ? _value.toolCalls
          : toolCalls // ignore: cast_nullable_to_non_nullable
              as List<ToolCall>?,
      thinkingDelta: freezed == thinkingDelta
          ? _value.thinkingDelta
          : thinkingDelta // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingComplete: null == thinkingComplete
          ? _value.thinkingComplete
          : thinkingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TokenUsageCopyWith<$Res>? get tokenUsage {
    if (_value.tokenUsage == null) {
      return null;
    }

    return $TokenUsageCopyWith<$Res>(_value.tokenUsage!, (value) {
      return _then(_value.copyWith(tokenUsage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StreamedChatResultImplCopyWith<$Res>
    implements $StreamedChatResultCopyWith<$Res> {
  factory _$$StreamedChatResultImplCopyWith(_$StreamedChatResultImpl value,
          $Res Function(_$StreamedChatResultImpl) then) =
      __$$StreamedChatResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? delta,
      String? content,
      bool isDone,
      String? model,
      TokenUsage? tokenUsage,
      FinishReason? finishReason,
      List<ToolCall>? toolCalls,
      String? thinkingDelta,
      String? thinkingContent,
      bool thinkingComplete});

  @override
  $TokenUsageCopyWith<$Res>? get tokenUsage;
}

/// @nodoc
class __$$StreamedChatResultImplCopyWithImpl<$Res>
    extends _$StreamedChatResultCopyWithImpl<$Res, _$StreamedChatResultImpl>
    implements _$$StreamedChatResultImplCopyWith<$Res> {
  __$$StreamedChatResultImplCopyWithImpl(_$StreamedChatResultImpl _value,
      $Res Function(_$StreamedChatResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delta = freezed,
    Object? content = freezed,
    Object? isDone = null,
    Object? model = freezed,
    Object? tokenUsage = freezed,
    Object? finishReason = freezed,
    Object? toolCalls = freezed,
    Object? thinkingDelta = freezed,
    Object? thinkingContent = freezed,
    Object? thinkingComplete = null,
  }) {
    return _then(_$StreamedChatResultImpl(
      delta: freezed == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenUsage: freezed == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage?,
      finishReason: freezed == finishReason
          ? _value.finishReason
          : finishReason // ignore: cast_nullable_to_non_nullable
              as FinishReason?,
      toolCalls: freezed == toolCalls
          ? _value._toolCalls
          : toolCalls // ignore: cast_nullable_to_non_nullable
              as List<ToolCall>?,
      thinkingDelta: freezed == thinkingDelta
          ? _value.thinkingDelta
          : thinkingDelta // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingContent: freezed == thinkingContent
          ? _value.thinkingContent
          : thinkingContent // ignore: cast_nullable_to_non_nullable
              as String?,
      thinkingComplete: null == thinkingComplete
          ? _value.thinkingComplete
          : thinkingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamedChatResultImpl implements _StreamedChatResult {
  const _$StreamedChatResultImpl(
      {this.delta,
      this.content,
      this.isDone = false,
      this.model,
      this.tokenUsage,
      this.finishReason,
      final List<ToolCall>? toolCalls,
      this.thinkingDelta,
      this.thinkingContent,
      this.thinkingComplete = false})
      : _toolCalls = toolCalls;

  factory _$StreamedChatResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreamedChatResultImplFromJson(json);

  /// 增量内容
  @override
  final String? delta;

  /// 累积内容
  @override
  final String? content;

  /// 是否完成
  @override
  @JsonKey()
  final bool isDone;

  /// 使用的模型
  @override
  final String? model;

  /// token使用情况（仅在完成时）
  @override
  final TokenUsage? tokenUsage;

  /// 完成原因（仅在完成时）
  @override
  final FinishReason? finishReason;

  /// 工具调用（如果有）
  final List<ToolCall>? _toolCalls;

  /// 工具调用（如果有）
  @override
  List<ToolCall>? get toolCalls {
    final value = _toolCalls;
    if (value == null) return null;
    if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 思考链增量内容
  @override
  final String? thinkingDelta;

  /// 思考链累积内容
  @override
  final String? thinkingContent;

  /// 思考链是否完成
  @override
  @JsonKey()
  final bool thinkingComplete;

  @override
  String toString() {
    return 'StreamedChatResult(delta: $delta, content: $content, isDone: $isDone, model: $model, tokenUsage: $tokenUsage, finishReason: $finishReason, toolCalls: $toolCalls, thinkingDelta: $thinkingDelta, thinkingContent: $thinkingContent, thinkingComplete: $thinkingComplete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamedChatResultImpl &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.tokenUsage, tokenUsage) ||
                other.tokenUsage == tokenUsage) &&
            (identical(other.finishReason, finishReason) ||
                other.finishReason == finishReason) &&
            const DeepCollectionEquality()
                .equals(other._toolCalls, _toolCalls) &&
            (identical(other.thinkingDelta, thinkingDelta) ||
                other.thinkingDelta == thinkingDelta) &&
            (identical(other.thinkingContent, thinkingContent) ||
                other.thinkingContent == thinkingContent) &&
            (identical(other.thinkingComplete, thinkingComplete) ||
                other.thinkingComplete == thinkingComplete));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      delta,
      content,
      isDone,
      model,
      tokenUsage,
      finishReason,
      const DeepCollectionEquality().hash(_toolCalls),
      thinkingDelta,
      thinkingContent,
      thinkingComplete);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamedChatResultImplCopyWith<_$StreamedChatResultImpl> get copyWith =>
      __$$StreamedChatResultImplCopyWithImpl<_$StreamedChatResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamedChatResultImplToJson(
      this,
    );
  }
}

abstract class _StreamedChatResult implements StreamedChatResult {
  const factory _StreamedChatResult(
      {final String? delta,
      final String? content,
      final bool isDone,
      final String? model,
      final TokenUsage? tokenUsage,
      final FinishReason? finishReason,
      final List<ToolCall>? toolCalls,
      final String? thinkingDelta,
      final String? thinkingContent,
      final bool thinkingComplete}) = _$StreamedChatResultImpl;

  factory _StreamedChatResult.fromJson(Map<String, dynamic> json) =
      _$StreamedChatResultImpl.fromJson;

  @override

  /// 增量内容
  String? get delta;
  @override

  /// 累积内容
  String? get content;
  @override

  /// 是否完成
  bool get isDone;
  @override

  /// 使用的模型
  String? get model;
  @override

  /// token使用情况（仅在完成时）
  TokenUsage? get tokenUsage;
  @override

  /// 完成原因（仅在完成时）
  FinishReason? get finishReason;
  @override

  /// 工具调用（如果有）
  List<ToolCall>? get toolCalls;
  @override

  /// 思考链增量内容
  String? get thinkingDelta;
  @override

  /// 思考链累积内容
  String? get thinkingContent;
  @override

  /// 思考链是否完成
  bool get thinkingComplete;
  @override
  @JsonKey(ignore: true)
  _$$StreamedChatResultImplCopyWith<_$StreamedChatResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TokenUsage _$TokenUsageFromJson(Map<String, dynamic> json) {
  return _TokenUsage.fromJson(json);
}

/// @nodoc
mixin _$TokenUsage {
  /// 输入token数
  int get inputTokens => throw _privateConstructorUsedError;

  /// 输出token数
  int get outputTokens => throw _privateConstructorUsedError;

  /// 总token数
  int get totalTokens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TokenUsageCopyWith<TokenUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenUsageCopyWith<$Res> {
  factory $TokenUsageCopyWith(
          TokenUsage value, $Res Function(TokenUsage) then) =
      _$TokenUsageCopyWithImpl<$Res, TokenUsage>;
  @useResult
  $Res call({int inputTokens, int outputTokens, int totalTokens});
}

/// @nodoc
class _$TokenUsageCopyWithImpl<$Res, $Val extends TokenUsage>
    implements $TokenUsageCopyWith<$Res> {
  _$TokenUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputTokens = null,
    Object? outputTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(_value.copyWith(
      inputTokens: null == inputTokens
          ? _value.inputTokens
          : inputTokens // ignore: cast_nullable_to_non_nullable
              as int,
      outputTokens: null == outputTokens
          ? _value.outputTokens
          : outputTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenUsageImplCopyWith<$Res>
    implements $TokenUsageCopyWith<$Res> {
  factory _$$TokenUsageImplCopyWith(
          _$TokenUsageImpl value, $Res Function(_$TokenUsageImpl) then) =
      __$$TokenUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int inputTokens, int outputTokens, int totalTokens});
}

/// @nodoc
class __$$TokenUsageImplCopyWithImpl<$Res>
    extends _$TokenUsageCopyWithImpl<$Res, _$TokenUsageImpl>
    implements _$$TokenUsageImplCopyWith<$Res> {
  __$$TokenUsageImplCopyWithImpl(
      _$TokenUsageImpl _value, $Res Function(_$TokenUsageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inputTokens = null,
    Object? outputTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(_$TokenUsageImpl(
      inputTokens: null == inputTokens
          ? _value.inputTokens
          : inputTokens // ignore: cast_nullable_to_non_nullable
              as int,
      outputTokens: null == outputTokens
          ? _value.outputTokens
          : outputTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenUsageImpl implements _TokenUsage {
  const _$TokenUsageImpl(
      {required this.inputTokens,
      required this.outputTokens,
      required this.totalTokens});

  factory _$TokenUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenUsageImplFromJson(json);

  /// 输入token数
  @override
  final int inputTokens;

  /// 输出token数
  @override
  final int outputTokens;

  /// 总token数
  @override
  final int totalTokens;

  @override
  String toString() {
    return 'TokenUsage(inputTokens: $inputTokens, outputTokens: $outputTokens, totalTokens: $totalTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenUsageImpl &&
            (identical(other.inputTokens, inputTokens) ||
                other.inputTokens == inputTokens) &&
            (identical(other.outputTokens, outputTokens) ||
                other.outputTokens == outputTokens) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, inputTokens, outputTokens, totalTokens);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenUsageImplCopyWith<_$TokenUsageImpl> get copyWith =>
      __$$TokenUsageImplCopyWithImpl<_$TokenUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenUsageImplToJson(
      this,
    );
  }
}

abstract class _TokenUsage implements TokenUsage {
  const factory _TokenUsage(
      {required final int inputTokens,
      required final int outputTokens,
      required final int totalTokens}) = _$TokenUsageImpl;

  factory _TokenUsage.fromJson(Map<String, dynamic> json) =
      _$TokenUsageImpl.fromJson;

  @override

  /// 输入token数
  int get inputTokens;
  @override

  /// 输出token数
  int get outputTokens;
  @override

  /// 总token数
  int get totalTokens;
  @override
  @JsonKey(ignore: true)
  _$$TokenUsageImplCopyWith<_$TokenUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ToolCall _$ToolCallFromJson(Map<String, dynamic> json) {
  return _ToolCall.fromJson(json);
}

/// @nodoc
mixin _$ToolCall {
  /// 调用ID
  String get id => throw _privateConstructorUsedError;

  /// 工具名称
  String get name => throw _privateConstructorUsedError;

  /// 调用参数
  Map<String, dynamic> get arguments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolCallCopyWith<ToolCall> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolCallCopyWith<$Res> {
  factory $ToolCallCopyWith(ToolCall value, $Res Function(ToolCall) then) =
      _$ToolCallCopyWithImpl<$Res, ToolCall>;
  @useResult
  $Res call({String id, String name, Map<String, dynamic> arguments});
}

/// @nodoc
class _$ToolCallCopyWithImpl<$Res, $Val extends ToolCall>
    implements $ToolCallCopyWith<$Res> {
  _$ToolCallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? arguments = null,
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
      arguments: null == arguments
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolCallImplCopyWith<$Res>
    implements $ToolCallCopyWith<$Res> {
  factory _$$ToolCallImplCopyWith(
          _$ToolCallImpl value, $Res Function(_$ToolCallImpl) then) =
      __$$ToolCallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, Map<String, dynamic> arguments});
}

/// @nodoc
class __$$ToolCallImplCopyWithImpl<$Res>
    extends _$ToolCallCopyWithImpl<$Res, _$ToolCallImpl>
    implements _$$ToolCallImplCopyWith<$Res> {
  __$$ToolCallImplCopyWithImpl(
      _$ToolCallImpl _value, $Res Function(_$ToolCallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? arguments = null,
  }) {
    return _then(_$ToolCallImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: null == arguments
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolCallImpl implements _ToolCall {
  const _$ToolCallImpl(
      {required this.id,
      required this.name,
      required final Map<String, dynamic> arguments})
      : _arguments = arguments;

  factory _$ToolCallImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolCallImplFromJson(json);

  /// 调用ID
  @override
  final String id;

  /// 工具名称
  @override
  final String name;

  /// 调用参数
  final Map<String, dynamic> _arguments;

  /// 调用参数
  @override
  Map<String, dynamic> get arguments {
    if (_arguments is EqualUnmodifiableMapView) return _arguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_arguments);
  }

  @override
  String toString() {
    return 'ToolCall(id: $id, name: $name, arguments: $arguments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolCallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_arguments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolCallImplCopyWith<_$ToolCallImpl> get copyWith =>
      __$$ToolCallImplCopyWithImpl<_$ToolCallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolCallImplToJson(
      this,
    );
  }
}

abstract class _ToolCall implements ToolCall {
  const factory _ToolCall(
      {required final String id,
      required final String name,
      required final Map<String, dynamic> arguments}) = _$ToolCallImpl;

  factory _ToolCall.fromJson(Map<String, dynamic> json) =
      _$ToolCallImpl.fromJson;

  @override

  /// 调用ID
  String get id;
  @override

  /// 工具名称
  String get name;
  @override

  /// 调用参数
  Map<String, dynamic> get arguments;
  @override
  @JsonKey(ignore: true)
  _$$ToolCallImplCopyWith<_$ToolCallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmbeddingResult _$EmbeddingResultFromJson(Map<String, dynamic> json) {
  return _EmbeddingResult.fromJson(json);
}

/// @nodoc
mixin _$EmbeddingResult {
  /// 嵌入向量列表
  List<List<double>> get embeddings => throw _privateConstructorUsedError;

  /// 使用的模型
  String get model => throw _privateConstructorUsedError;

  /// token使用情况
  TokenUsage get tokenUsage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmbeddingResultCopyWith<EmbeddingResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmbeddingResultCopyWith<$Res> {
  factory $EmbeddingResultCopyWith(
          EmbeddingResult value, $Res Function(EmbeddingResult) then) =
      _$EmbeddingResultCopyWithImpl<$Res, EmbeddingResult>;
  @useResult
  $Res call(
      {List<List<double>> embeddings, String model, TokenUsage tokenUsage});

  $TokenUsageCopyWith<$Res> get tokenUsage;
}

/// @nodoc
class _$EmbeddingResultCopyWithImpl<$Res, $Val extends EmbeddingResult>
    implements $EmbeddingResultCopyWith<$Res> {
  _$EmbeddingResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? embeddings = null,
    Object? model = null,
    Object? tokenUsage = null,
  }) {
    return _then(_value.copyWith(
      embeddings: null == embeddings
          ? _value.embeddings
          : embeddings // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUsage: null == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TokenUsageCopyWith<$Res> get tokenUsage {
    return $TokenUsageCopyWith<$Res>(_value.tokenUsage, (value) {
      return _then(_value.copyWith(tokenUsage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EmbeddingResultImplCopyWith<$Res>
    implements $EmbeddingResultCopyWith<$Res> {
  factory _$$EmbeddingResultImplCopyWith(_$EmbeddingResultImpl value,
          $Res Function(_$EmbeddingResultImpl) then) =
      __$$EmbeddingResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<List<double>> embeddings, String model, TokenUsage tokenUsage});

  @override
  $TokenUsageCopyWith<$Res> get tokenUsage;
}

/// @nodoc
class __$$EmbeddingResultImplCopyWithImpl<$Res>
    extends _$EmbeddingResultCopyWithImpl<$Res, _$EmbeddingResultImpl>
    implements _$$EmbeddingResultImplCopyWith<$Res> {
  __$$EmbeddingResultImplCopyWithImpl(
      _$EmbeddingResultImpl _value, $Res Function(_$EmbeddingResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? embeddings = null,
    Object? model = null,
    Object? tokenUsage = null,
  }) {
    return _then(_$EmbeddingResultImpl(
      embeddings: null == embeddings
          ? _value._embeddings
          : embeddings // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokenUsage: null == tokenUsage
          ? _value.tokenUsage
          : tokenUsage // ignore: cast_nullable_to_non_nullable
              as TokenUsage,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmbeddingResultImpl implements _EmbeddingResult {
  const _$EmbeddingResultImpl(
      {required final List<List<double>> embeddings,
      required this.model,
      required this.tokenUsage})
      : _embeddings = embeddings;

  factory _$EmbeddingResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmbeddingResultImplFromJson(json);

  /// 嵌入向量列表
  final List<List<double>> _embeddings;

  /// 嵌入向量列表
  @override
  List<List<double>> get embeddings {
    if (_embeddings is EqualUnmodifiableListView) return _embeddings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_embeddings);
  }

  /// 使用的模型
  @override
  final String model;

  /// token使用情况
  @override
  final TokenUsage tokenUsage;

  @override
  String toString() {
    return 'EmbeddingResult(embeddings: $embeddings, model: $model, tokenUsage: $tokenUsage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmbeddingResultImpl &&
            const DeepCollectionEquality()
                .equals(other._embeddings, _embeddings) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.tokenUsage, tokenUsage) ||
                other.tokenUsage == tokenUsage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_embeddings), model, tokenUsage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmbeddingResultImplCopyWith<_$EmbeddingResultImpl> get copyWith =>
      __$$EmbeddingResultImplCopyWithImpl<_$EmbeddingResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmbeddingResultImplToJson(
      this,
    );
  }
}

abstract class _EmbeddingResult implements EmbeddingResult {
  const factory _EmbeddingResult(
      {required final List<List<double>> embeddings,
      required final String model,
      required final TokenUsage tokenUsage}) = _$EmbeddingResultImpl;

  factory _EmbeddingResult.fromJson(Map<String, dynamic> json) =
      _$EmbeddingResultImpl.fromJson;

  @override

  /// 嵌入向量列表
  List<List<double>> get embeddings;
  @override

  /// 使用的模型
  String get model;
  @override

  /// token使用情况
  TokenUsage get tokenUsage;
  @override
  @JsonKey(ignore: true)
  _$$EmbeddingResultImplCopyWith<_$EmbeddingResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
