// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mcp_server_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

McpServerConfig _$McpServerConfigFromJson(Map<String, dynamic> json) {
  return _McpServerConfig.fromJson(json);
}

/// @nodoc
mixin _$McpServerConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get baseUrl => throw _privateConstructorUsedError;
  McpTransportType get type => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  int? get timeout => throw _privateConstructorUsedError;
  bool? get longRunning => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // OAuth配置
  String? get clientId => throw _privateConstructorUsedError;
  String? get clientSecret => throw _privateConstructorUsedError;
  String? get authorizationEndpoint => throw _privateConstructorUsedError;
  String? get tokenEndpoint => throw _privateConstructorUsedError; // 连接状态
  bool get isConnected => throw _privateConstructorUsedError;
  DateTime? get lastConnected => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpServerConfigCopyWith<McpServerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpServerConfigCopyWith<$Res> {
  factory $McpServerConfigCopyWith(
          McpServerConfig value, $Res Function(McpServerConfig) then) =
      _$McpServerConfigCopyWithImpl<$Res, McpServerConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String baseUrl,
      McpTransportType type,
      Map<String, String>? headers,
      int? timeout,
      bool? longRunning,
      bool? disabled,
      String? error,
      String? clientId,
      String? clientSecret,
      String? authorizationEndpoint,
      String? tokenEndpoint,
      bool isConnected,
      DateTime? lastConnected,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$McpServerConfigCopyWithImpl<$Res, $Val extends McpServerConfig>
    implements $McpServerConfigCopyWith<$Res> {
  _$McpServerConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? baseUrl = null,
    Object? type = null,
    Object? headers = freezed,
    Object? timeout = freezed,
    Object? longRunning = freezed,
    Object? disabled = freezed,
    Object? error = freezed,
    Object? clientId = freezed,
    Object? clientSecret = freezed,
    Object? authorizationEndpoint = freezed,
    Object? tokenEndpoint = freezed,
    Object? isConnected = null,
    Object? lastConnected = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as McpTransportType,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      longRunning: freezed == longRunning
          ? _value.longRunning
          : longRunning // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSecret: freezed == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      authorizationEndpoint: freezed == authorizationEndpoint
          ? _value.authorizationEndpoint
          : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenEndpoint: freezed == tokenEndpoint
          ? _value.tokenEndpoint
          : tokenEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpServerConfigImplCopyWith<$Res>
    implements $McpServerConfigCopyWith<$Res> {
  factory _$$McpServerConfigImplCopyWith(_$McpServerConfigImpl value,
          $Res Function(_$McpServerConfigImpl) then) =
      __$$McpServerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String baseUrl,
      McpTransportType type,
      Map<String, String>? headers,
      int? timeout,
      bool? longRunning,
      bool? disabled,
      String? error,
      String? clientId,
      String? clientSecret,
      String? authorizationEndpoint,
      String? tokenEndpoint,
      bool isConnected,
      DateTime? lastConnected,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$McpServerConfigImplCopyWithImpl<$Res>
    extends _$McpServerConfigCopyWithImpl<$Res, _$McpServerConfigImpl>
    implements _$$McpServerConfigImplCopyWith<$Res> {
  __$$McpServerConfigImplCopyWithImpl(
      _$McpServerConfigImpl _value, $Res Function(_$McpServerConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? baseUrl = null,
    Object? type = null,
    Object? headers = freezed,
    Object? timeout = freezed,
    Object? longRunning = freezed,
    Object? disabled = freezed,
    Object? error = freezed,
    Object? clientId = freezed,
    Object? clientSecret = freezed,
    Object? authorizationEndpoint = freezed,
    Object? tokenEndpoint = freezed,
    Object? isConnected = null,
    Object? lastConnected = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$McpServerConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as McpTransportType,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      longRunning: freezed == longRunning
          ? _value.longRunning
          : longRunning // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientSecret: freezed == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      authorizationEndpoint: freezed == authorizationEndpoint
          ? _value.authorizationEndpoint
          : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenEndpoint: freezed == tokenEndpoint
          ? _value.tokenEndpoint
          : tokenEndpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpServerConfigImpl implements _McpServerConfig {
  const _$McpServerConfigImpl(
      {required this.id,
      required this.name,
      required this.baseUrl,
      required this.type,
      final Map<String, String>? headers,
      this.timeout,
      this.longRunning,
      this.disabled,
      this.error,
      this.clientId,
      this.clientSecret,
      this.authorizationEndpoint,
      this.tokenEndpoint,
      this.isConnected = false,
      this.lastConnected,
      this.createdAt,
      this.updatedAt})
      : _headers = headers;

  factory _$McpServerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpServerConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String baseUrl;
  @override
  final McpTransportType type;
  final Map<String, String>? _headers;
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int? timeout;
  @override
  final bool? longRunning;
  @override
  final bool? disabled;
  @override
  final String? error;
// OAuth配置
  @override
  final String? clientId;
  @override
  final String? clientSecret;
  @override
  final String? authorizationEndpoint;
  @override
  final String? tokenEndpoint;
// 连接状态
  @override
  @JsonKey()
  final bool isConnected;
  @override
  final DateTime? lastConnected;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'McpServerConfig(id: $id, name: $name, baseUrl: $baseUrl, type: $type, headers: $headers, timeout: $timeout, longRunning: $longRunning, disabled: $disabled, error: $error, clientId: $clientId, clientSecret: $clientSecret, authorizationEndpoint: $authorizationEndpoint, tokenEndpoint: $tokenEndpoint, isConnected: $isConnected, lastConnected: $lastConnected, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpServerConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.longRunning, longRunning) ||
                other.longRunning == longRunning) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.authorizationEndpoint, authorizationEndpoint) ||
                other.authorizationEndpoint == authorizationEndpoint) &&
            (identical(other.tokenEndpoint, tokenEndpoint) ||
                other.tokenEndpoint == tokenEndpoint) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.lastConnected, lastConnected) ||
                other.lastConnected == lastConnected) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      baseUrl,
      type,
      const DeepCollectionEquality().hash(_headers),
      timeout,
      longRunning,
      disabled,
      error,
      clientId,
      clientSecret,
      authorizationEndpoint,
      tokenEndpoint,
      isConnected,
      lastConnected,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpServerConfigImplCopyWith<_$McpServerConfigImpl> get copyWith =>
      __$$McpServerConfigImplCopyWithImpl<_$McpServerConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpServerConfigImplToJson(
      this,
    );
  }
}

abstract class _McpServerConfig implements McpServerConfig {
  const factory _McpServerConfig(
      {required final String id,
      required final String name,
      required final String baseUrl,
      required final McpTransportType type,
      final Map<String, String>? headers,
      final int? timeout,
      final bool? longRunning,
      final bool? disabled,
      final String? error,
      final String? clientId,
      final String? clientSecret,
      final String? authorizationEndpoint,
      final String? tokenEndpoint,
      final bool isConnected,
      final DateTime? lastConnected,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$McpServerConfigImpl;

  factory _McpServerConfig.fromJson(Map<String, dynamic> json) =
      _$McpServerConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get baseUrl;
  @override
  McpTransportType get type;
  @override
  Map<String, String>? get headers;
  @override
  int? get timeout;
  @override
  bool? get longRunning;
  @override
  bool? get disabled;
  @override
  String? get error;
  @override // OAuth配置
  String? get clientId;
  @override
  String? get clientSecret;
  @override
  String? get authorizationEndpoint;
  @override
  String? get tokenEndpoint;
  @override // 连接状态
  bool get isConnected;
  @override
  DateTime? get lastConnected;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$McpServerConfigImplCopyWith<_$McpServerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

McpConnectionStatus _$McpConnectionStatusFromJson(Map<String, dynamic> json) {
  return _McpConnectionStatus.fromJson(json);
}

/// @nodoc
mixin _$McpConnectionStatus {
  String get serverId => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  DateTime get lastCheck => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get latency => throw _privateConstructorUsedError; // 服务器信息
  String? get serverName => throw _privateConstructorUsedError;
  String? get serverVersion => throw _privateConstructorUsedError;
  String? get protocolVersion => throw _privateConstructorUsedError; // 能力信息
  int? get toolsCount => throw _privateConstructorUsedError;
  int? get resourcesCount => throw _privateConstructorUsedError;
  int? get promptsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpConnectionStatusCopyWith<McpConnectionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpConnectionStatusCopyWith<$Res> {
  factory $McpConnectionStatusCopyWith(
          McpConnectionStatus value, $Res Function(McpConnectionStatus) then) =
      _$McpConnectionStatusCopyWithImpl<$Res, McpConnectionStatus>;
  @useResult
  $Res call(
      {String serverId,
      bool isConnected,
      DateTime lastCheck,
      String? error,
      int? latency,
      String? serverName,
      String? serverVersion,
      String? protocolVersion,
      int? toolsCount,
      int? resourcesCount,
      int? promptsCount});
}

/// @nodoc
class _$McpConnectionStatusCopyWithImpl<$Res, $Val extends McpConnectionStatus>
    implements $McpConnectionStatusCopyWith<$Res> {
  _$McpConnectionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverId = null,
    Object? isConnected = null,
    Object? lastCheck = null,
    Object? error = freezed,
    Object? latency = freezed,
    Object? serverName = freezed,
    Object? serverVersion = freezed,
    Object? protocolVersion = freezed,
    Object? toolsCount = freezed,
    Object? resourcesCount = freezed,
    Object? promptsCount = freezed,
  }) {
    return _then(_value.copyWith(
      serverId: null == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCheck: null == lastCheck
          ? _value.lastCheck
          : lastCheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
      serverName: freezed == serverName
          ? _value.serverName
          : serverName // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      protocolVersion: freezed == protocolVersion
          ? _value.protocolVersion
          : protocolVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      toolsCount: freezed == toolsCount
          ? _value.toolsCount
          : toolsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      resourcesCount: freezed == resourcesCount
          ? _value.resourcesCount
          : resourcesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      promptsCount: freezed == promptsCount
          ? _value.promptsCount
          : promptsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpConnectionStatusImplCopyWith<$Res>
    implements $McpConnectionStatusCopyWith<$Res> {
  factory _$$McpConnectionStatusImplCopyWith(_$McpConnectionStatusImpl value,
          $Res Function(_$McpConnectionStatusImpl) then) =
      __$$McpConnectionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String serverId,
      bool isConnected,
      DateTime lastCheck,
      String? error,
      int? latency,
      String? serverName,
      String? serverVersion,
      String? protocolVersion,
      int? toolsCount,
      int? resourcesCount,
      int? promptsCount});
}

/// @nodoc
class __$$McpConnectionStatusImplCopyWithImpl<$Res>
    extends _$McpConnectionStatusCopyWithImpl<$Res, _$McpConnectionStatusImpl>
    implements _$$McpConnectionStatusImplCopyWith<$Res> {
  __$$McpConnectionStatusImplCopyWithImpl(_$McpConnectionStatusImpl _value,
      $Res Function(_$McpConnectionStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverId = null,
    Object? isConnected = null,
    Object? lastCheck = null,
    Object? error = freezed,
    Object? latency = freezed,
    Object? serverName = freezed,
    Object? serverVersion = freezed,
    Object? protocolVersion = freezed,
    Object? toolsCount = freezed,
    Object? resourcesCount = freezed,
    Object? promptsCount = freezed,
  }) {
    return _then(_$McpConnectionStatusImpl(
      serverId: null == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCheck: null == lastCheck
          ? _value.lastCheck
          : lastCheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      latency: freezed == latency
          ? _value.latency
          : latency // ignore: cast_nullable_to_non_nullable
              as int?,
      serverName: freezed == serverName
          ? _value.serverName
          : serverName // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      protocolVersion: freezed == protocolVersion
          ? _value.protocolVersion
          : protocolVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      toolsCount: freezed == toolsCount
          ? _value.toolsCount
          : toolsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      resourcesCount: freezed == resourcesCount
          ? _value.resourcesCount
          : resourcesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      promptsCount: freezed == promptsCount
          ? _value.promptsCount
          : promptsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpConnectionStatusImpl implements _McpConnectionStatus {
  const _$McpConnectionStatusImpl(
      {required this.serverId,
      required this.isConnected,
      required this.lastCheck,
      this.error,
      this.latency,
      this.serverName,
      this.serverVersion,
      this.protocolVersion,
      this.toolsCount,
      this.resourcesCount,
      this.promptsCount});

  factory _$McpConnectionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpConnectionStatusImplFromJson(json);

  @override
  final String serverId;
  @override
  final bool isConnected;
  @override
  final DateTime lastCheck;
  @override
  final String? error;
  @override
  final int? latency;
// 服务器信息
  @override
  final String? serverName;
  @override
  final String? serverVersion;
  @override
  final String? protocolVersion;
// 能力信息
  @override
  final int? toolsCount;
  @override
  final int? resourcesCount;
  @override
  final int? promptsCount;

  @override
  String toString() {
    return 'McpConnectionStatus(serverId: $serverId, isConnected: $isConnected, lastCheck: $lastCheck, error: $error, latency: $latency, serverName: $serverName, serverVersion: $serverVersion, protocolVersion: $protocolVersion, toolsCount: $toolsCount, resourcesCount: $resourcesCount, promptsCount: $promptsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpConnectionStatusImpl &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.lastCheck, lastCheck) ||
                other.lastCheck == lastCheck) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName) &&
            (identical(other.serverVersion, serverVersion) ||
                other.serverVersion == serverVersion) &&
            (identical(other.protocolVersion, protocolVersion) ||
                other.protocolVersion == protocolVersion) &&
            (identical(other.toolsCount, toolsCount) ||
                other.toolsCount == toolsCount) &&
            (identical(other.resourcesCount, resourcesCount) ||
                other.resourcesCount == resourcesCount) &&
            (identical(other.promptsCount, promptsCount) ||
                other.promptsCount == promptsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      serverId,
      isConnected,
      lastCheck,
      error,
      latency,
      serverName,
      serverVersion,
      protocolVersion,
      toolsCount,
      resourcesCount,
      promptsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpConnectionStatusImplCopyWith<_$McpConnectionStatusImpl> get copyWith =>
      __$$McpConnectionStatusImplCopyWithImpl<_$McpConnectionStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpConnectionStatusImplToJson(
      this,
    );
  }
}

abstract class _McpConnectionStatus implements McpConnectionStatus {
  const factory _McpConnectionStatus(
      {required final String serverId,
      required final bool isConnected,
      required final DateTime lastCheck,
      final String? error,
      final int? latency,
      final String? serverName,
      final String? serverVersion,
      final String? protocolVersion,
      final int? toolsCount,
      final int? resourcesCount,
      final int? promptsCount}) = _$McpConnectionStatusImpl;

  factory _McpConnectionStatus.fromJson(Map<String, dynamic> json) =
      _$McpConnectionStatusImpl.fromJson;

  @override
  String get serverId;
  @override
  bool get isConnected;
  @override
  DateTime get lastCheck;
  @override
  String? get error;
  @override
  int? get latency;
  @override // 服务器信息
  String? get serverName;
  @override
  String? get serverVersion;
  @override
  String? get protocolVersion;
  @override // 能力信息
  int? get toolsCount;
  @override
  int? get resourcesCount;
  @override
  int? get promptsCount;
  @override
  @JsonKey(ignore: true)
  _$$McpConnectionStatusImplCopyWith<_$McpConnectionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

McpTool _$McpToolFromJson(Map<String, dynamic> json) {
  return _McpTool.fromJson(json);
}

/// @nodoc
mixin _$McpTool {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get inputSchema => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpToolCopyWith<McpTool> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpToolCopyWith<$Res> {
  factory $McpToolCopyWith(McpTool value, $Res Function(McpTool) then) =
      _$McpToolCopyWithImpl<$Res, McpTool>;
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic> inputSchema,
      String? serverId});
}

/// @nodoc
class _$McpToolCopyWithImpl<$Res, $Val extends McpTool>
    implements $McpToolCopyWith<$Res> {
  _$McpToolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? inputSchema = null,
    Object? serverId = freezed,
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
      inputSchema: null == inputSchema
          ? _value.inputSchema
          : inputSchema // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpToolImplCopyWith<$Res> implements $McpToolCopyWith<$Res> {
  factory _$$McpToolImplCopyWith(
          _$McpToolImpl value, $Res Function(_$McpToolImpl) then) =
      __$$McpToolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic> inputSchema,
      String? serverId});
}

/// @nodoc
class __$$McpToolImplCopyWithImpl<$Res>
    extends _$McpToolCopyWithImpl<$Res, _$McpToolImpl>
    implements _$$McpToolImplCopyWith<$Res> {
  __$$McpToolImplCopyWithImpl(
      _$McpToolImpl _value, $Res Function(_$McpToolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? inputSchema = null,
    Object? serverId = freezed,
  }) {
    return _then(_$McpToolImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      inputSchema: null == inputSchema
          ? _value._inputSchema
          : inputSchema // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpToolImpl implements _McpTool {
  const _$McpToolImpl(
      {required this.name,
      required this.description,
      required final Map<String, dynamic> inputSchema,
      this.serverId})
      : _inputSchema = inputSchema;

  factory _$McpToolImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpToolImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  final Map<String, dynamic> _inputSchema;
  @override
  Map<String, dynamic> get inputSchema {
    if (_inputSchema is EqualUnmodifiableMapView) return _inputSchema;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_inputSchema);
  }

  @override
  final String? serverId;

  @override
  String toString() {
    return 'McpTool(name: $name, description: $description, inputSchema: $inputSchema, serverId: $serverId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpToolImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._inputSchema, _inputSchema) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description,
      const DeepCollectionEquality().hash(_inputSchema), serverId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpToolImplCopyWith<_$McpToolImpl> get copyWith =>
      __$$McpToolImplCopyWithImpl<_$McpToolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpToolImplToJson(
      this,
    );
  }
}

abstract class _McpTool implements McpTool {
  const factory _McpTool(
      {required final String name,
      required final String description,
      required final Map<String, dynamic> inputSchema,
      final String? serverId}) = _$McpToolImpl;

  factory _McpTool.fromJson(Map<String, dynamic> json) = _$McpToolImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, dynamic> get inputSchema;
  @override
  String? get serverId;
  @override
  @JsonKey(ignore: true)
  _$$McpToolImplCopyWith<_$McpToolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

McpResource _$McpResourceFromJson(Map<String, dynamic> json) {
  return _McpResource.fromJson(json);
}

/// @nodoc
mixin _$McpResource {
  String get uri => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpResourceCopyWith<McpResource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpResourceCopyWith<$Res> {
  factory $McpResourceCopyWith(
          McpResource value, $Res Function(McpResource) then) =
      _$McpResourceCopyWithImpl<$Res, McpResource>;
  @useResult
  $Res call(
      {String uri,
      String name,
      String? description,
      String? mimeType,
      String? serverId});
}

/// @nodoc
class _$McpResourceCopyWithImpl<$Res, $Val extends McpResource>
    implements $McpResourceCopyWith<$Res> {
  _$McpResourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? name = null,
    Object? description = freezed,
    Object? mimeType = freezed,
    Object? serverId = freezed,
  }) {
    return _then(_value.copyWith(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpResourceImplCopyWith<$Res>
    implements $McpResourceCopyWith<$Res> {
  factory _$$McpResourceImplCopyWith(
          _$McpResourceImpl value, $Res Function(_$McpResourceImpl) then) =
      __$$McpResourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uri,
      String name,
      String? description,
      String? mimeType,
      String? serverId});
}

/// @nodoc
class __$$McpResourceImplCopyWithImpl<$Res>
    extends _$McpResourceCopyWithImpl<$Res, _$McpResourceImpl>
    implements _$$McpResourceImplCopyWith<$Res> {
  __$$McpResourceImplCopyWithImpl(
      _$McpResourceImpl _value, $Res Function(_$McpResourceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? name = null,
    Object? description = freezed,
    Object? mimeType = freezed,
    Object? serverId = freezed,
  }) {
    return _then(_$McpResourceImpl(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpResourceImpl implements _McpResource {
  const _$McpResourceImpl(
      {required this.uri,
      required this.name,
      this.description,
      this.mimeType,
      this.serverId});

  factory _$McpResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpResourceImplFromJson(json);

  @override
  final String uri;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? mimeType;
  @override
  final String? serverId;

  @override
  String toString() {
    return 'McpResource(uri: $uri, name: $name, description: $description, mimeType: $mimeType, serverId: $serverId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpResourceImpl &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uri, name, description, mimeType, serverId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpResourceImplCopyWith<_$McpResourceImpl> get copyWith =>
      __$$McpResourceImplCopyWithImpl<_$McpResourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpResourceImplToJson(
      this,
    );
  }
}

abstract class _McpResource implements McpResource {
  const factory _McpResource(
      {required final String uri,
      required final String name,
      final String? description,
      final String? mimeType,
      final String? serverId}) = _$McpResourceImpl;

  factory _McpResource.fromJson(Map<String, dynamic> json) =
      _$McpResourceImpl.fromJson;

  @override
  String get uri;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get mimeType;
  @override
  String? get serverId;
  @override
  @JsonKey(ignore: true)
  _$$McpResourceImplCopyWith<_$McpResourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

McpCallHistory _$McpCallHistoryFromJson(Map<String, dynamic> json) {
  return _McpCallHistory.fromJson(json);
}

/// @nodoc
mixin _$McpCallHistory {
  String get id => throw _privateConstructorUsedError;
  String get serverId => throw _privateConstructorUsedError;
  String get toolName => throw _privateConstructorUsedError;
  Map<String, dynamic> get arguments => throw _privateConstructorUsedError;
  DateTime get calledAt => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpCallHistoryCopyWith<McpCallHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpCallHistoryCopyWith<$Res> {
  factory $McpCallHistoryCopyWith(
          McpCallHistory value, $Res Function(McpCallHistory) then) =
      _$McpCallHistoryCopyWithImpl<$Res, McpCallHistory>;
  @useResult
  $Res call(
      {String id,
      String serverId,
      String toolName,
      Map<String, dynamic> arguments,
      DateTime calledAt,
      String? result,
      String? error,
      int? duration});
}

/// @nodoc
class _$McpCallHistoryCopyWithImpl<$Res, $Val extends McpCallHistory>
    implements $McpCallHistoryCopyWith<$Res> {
  _$McpCallHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = null,
    Object? toolName = null,
    Object? arguments = null,
    Object? calledAt = null,
    Object? result = freezed,
    Object? error = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: null == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: null == arguments
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      calledAt: null == calledAt
          ? _value.calledAt
          : calledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpCallHistoryImplCopyWith<$Res>
    implements $McpCallHistoryCopyWith<$Res> {
  factory _$$McpCallHistoryImplCopyWith(_$McpCallHistoryImpl value,
          $Res Function(_$McpCallHistoryImpl) then) =
      __$$McpCallHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String serverId,
      String toolName,
      Map<String, dynamic> arguments,
      DateTime calledAt,
      String? result,
      String? error,
      int? duration});
}

/// @nodoc
class __$$McpCallHistoryImplCopyWithImpl<$Res>
    extends _$McpCallHistoryCopyWithImpl<$Res, _$McpCallHistoryImpl>
    implements _$$McpCallHistoryImplCopyWith<$Res> {
  __$$McpCallHistoryImplCopyWithImpl(
      _$McpCallHistoryImpl _value, $Res Function(_$McpCallHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serverId = null,
    Object? toolName = null,
    Object? arguments = null,
    Object? calledAt = null,
    Object? result = freezed,
    Object? error = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$McpCallHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serverId: null == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _value.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: null == arguments
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      calledAt: null == calledAt
          ? _value.calledAt
          : calledAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpCallHistoryImpl implements _McpCallHistory {
  const _$McpCallHistoryImpl(
      {required this.id,
      required this.serverId,
      required this.toolName,
      required final Map<String, dynamic> arguments,
      required this.calledAt,
      this.result,
      this.error,
      this.duration})
      : _arguments = arguments;

  factory _$McpCallHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpCallHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String serverId;
  @override
  final String toolName;
  final Map<String, dynamic> _arguments;
  @override
  Map<String, dynamic> get arguments {
    if (_arguments is EqualUnmodifiableMapView) return _arguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_arguments);
  }

  @override
  final DateTime calledAt;
  @override
  final String? result;
  @override
  final String? error;
  @override
  final int? duration;

  @override
  String toString() {
    return 'McpCallHistory(id: $id, serverId: $serverId, toolName: $toolName, arguments: $arguments, calledAt: $calledAt, result: $result, error: $error, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpCallHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments) &&
            (identical(other.calledAt, calledAt) ||
                other.calledAt == calledAt) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      serverId,
      toolName,
      const DeepCollectionEquality().hash(_arguments),
      calledAt,
      result,
      error,
      duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpCallHistoryImplCopyWith<_$McpCallHistoryImpl> get copyWith =>
      __$$McpCallHistoryImplCopyWithImpl<_$McpCallHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpCallHistoryImplToJson(
      this,
    );
  }
}

abstract class _McpCallHistory implements McpCallHistory {
  const factory _McpCallHistory(
      {required final String id,
      required final String serverId,
      required final String toolName,
      required final Map<String, dynamic> arguments,
      required final DateTime calledAt,
      final String? result,
      final String? error,
      final int? duration}) = _$McpCallHistoryImpl;

  factory _McpCallHistory.fromJson(Map<String, dynamic> json) =
      _$McpCallHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get serverId;
  @override
  String get toolName;
  @override
  Map<String, dynamic> get arguments;
  @override
  DateTime get calledAt;
  @override
  String? get result;
  @override
  String? get error;
  @override
  int? get duration;
  @override
  @JsonKey(ignore: true)
  _$$McpCallHistoryImplCopyWith<_$McpCallHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

McpPrompt _$McpPromptFromJson(Map<String, dynamic> json) {
  return _McpPrompt.fromJson(json);
}

/// @nodoc
mixin _$McpPrompt {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get arguments => throw _privateConstructorUsedError;
  String? get serverId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $McpPromptCopyWith<McpPrompt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $McpPromptCopyWith<$Res> {
  factory $McpPromptCopyWith(McpPrompt value, $Res Function(McpPrompt) then) =
      _$McpPromptCopyWithImpl<$Res, McpPrompt>;
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic>? arguments,
      String? serverId});
}

/// @nodoc
class _$McpPromptCopyWithImpl<$Res, $Val extends McpPrompt>
    implements $McpPromptCopyWith<$Res> {
  _$McpPromptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? arguments = freezed,
    Object? serverId = freezed,
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
      arguments: freezed == arguments
          ? _value.arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$McpPromptImplCopyWith<$Res>
    implements $McpPromptCopyWith<$Res> {
  factory _$$McpPromptImplCopyWith(
          _$McpPromptImpl value, $Res Function(_$McpPromptImpl) then) =
      __$$McpPromptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      Map<String, dynamic>? arguments,
      String? serverId});
}

/// @nodoc
class __$$McpPromptImplCopyWithImpl<$Res>
    extends _$McpPromptCopyWithImpl<$Res, _$McpPromptImpl>
    implements _$$McpPromptImplCopyWith<$Res> {
  __$$McpPromptImplCopyWithImpl(
      _$McpPromptImpl _value, $Res Function(_$McpPromptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? arguments = freezed,
    Object? serverId = freezed,
  }) {
    return _then(_$McpPromptImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      arguments: freezed == arguments
          ? _value._arguments
          : arguments // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$McpPromptImpl implements _McpPrompt {
  const _$McpPromptImpl(
      {required this.name,
      required this.description,
      final Map<String, dynamic>? arguments,
      this.serverId})
      : _arguments = arguments;

  factory _$McpPromptImpl.fromJson(Map<String, dynamic> json) =>
      _$$McpPromptImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  final Map<String, dynamic>? _arguments;
  @override
  Map<String, dynamic>? get arguments {
    final value = _arguments;
    if (value == null) return null;
    if (_arguments is EqualUnmodifiableMapView) return _arguments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? serverId;

  @override
  String toString() {
    return 'McpPrompt(name: $name, description: $description, arguments: $arguments, serverId: $serverId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$McpPromptImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._arguments, _arguments) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description,
      const DeepCollectionEquality().hash(_arguments), serverId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$McpPromptImplCopyWith<_$McpPromptImpl> get copyWith =>
      __$$McpPromptImplCopyWithImpl<_$McpPromptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$McpPromptImplToJson(
      this,
    );
  }
}

abstract class _McpPrompt implements McpPrompt {
  const factory _McpPrompt(
      {required final String name,
      required final String description,
      final Map<String, dynamic>? arguments,
      final String? serverId}) = _$McpPromptImpl;

  factory _McpPrompt.fromJson(Map<String, dynamic> json) =
      _$McpPromptImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, dynamic>? get arguments;
  @override
  String? get serverId;
  @override
  @JsonKey(ignore: true)
  _$$McpPromptImplCopyWith<_$McpPromptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
