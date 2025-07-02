// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  /// OpenAI API配置
  OpenAIConfig? get openaiConfig => throw _privateConstructorUsedError;

  /// Google Gemini API配置
  GeminiConfig? get geminiConfig => throw _privateConstructorUsedError;

  /// Anthropic Claude API配置
  ClaudeConfig? get claudeConfig => throw _privateConstructorUsedError;

  /// 主题设置
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// 语言设置
  String get language => throw _privateConstructorUsedError;

  /// 默认AI提供商
  AIProvider get defaultProvider => throw _privateConstructorUsedError;

  /// 聊天设置
  ChatSettings get chatSettings => throw _privateConstructorUsedError;

  /// 隐私设置
  PrivacySettings get privacySettings => throw _privateConstructorUsedError;

  /// 动画设置
  bool get enableAnimations => throw _privateConstructorUsedError;

  /// 思考链设置
  ThinkingChainSettings get thinkingChainSettings =>
      throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {OpenAIConfig? openaiConfig,
      GeminiConfig? geminiConfig,
      ClaudeConfig? claudeConfig,
      ThemeMode themeMode,
      String language,
      AIProvider defaultProvider,
      ChatSettings chatSettings,
      PrivacySettings privacySettings,
      bool enableAnimations,
      ThinkingChainSettings thinkingChainSettings});

  $OpenAIConfigCopyWith<$Res>? get openaiConfig;
  $GeminiConfigCopyWith<$Res>? get geminiConfig;
  $ClaudeConfigCopyWith<$Res>? get claudeConfig;
  $ChatSettingsCopyWith<$Res> get chatSettings;
  $PrivacySettingsCopyWith<$Res> get privacySettings;
  $ThinkingChainSettingsCopyWith<$Res> get thinkingChainSettings;
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openaiConfig = freezed,
    Object? geminiConfig = freezed,
    Object? claudeConfig = freezed,
    Object? themeMode = null,
    Object? language = null,
    Object? defaultProvider = null,
    Object? chatSettings = null,
    Object? privacySettings = null,
    Object? enableAnimations = null,
    Object? thinkingChainSettings = null,
  }) {
    return _then(_value.copyWith(
      openaiConfig: freezed == openaiConfig
          ? _value.openaiConfig
          : openaiConfig // ignore: cast_nullable_to_non_nullable
              as OpenAIConfig?,
      geminiConfig: freezed == geminiConfig
          ? _value.geminiConfig
          : geminiConfig // ignore: cast_nullable_to_non_nullable
              as GeminiConfig?,
      claudeConfig: freezed == claudeConfig
          ? _value.claudeConfig
          : claudeConfig // ignore: cast_nullable_to_non_nullable
              as ClaudeConfig?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      defaultProvider: null == defaultProvider
          ? _value.defaultProvider
          : defaultProvider // ignore: cast_nullable_to_non_nullable
              as AIProvider,
      chatSettings: null == chatSettings
          ? _value.chatSettings
          : chatSettings // ignore: cast_nullable_to_non_nullable
              as ChatSettings,
      privacySettings: null == privacySettings
          ? _value.privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as PrivacySettings,
      enableAnimations: null == enableAnimations
          ? _value.enableAnimations
          : enableAnimations // ignore: cast_nullable_to_non_nullable
              as bool,
      thinkingChainSettings: null == thinkingChainSettings
          ? _value.thinkingChainSettings
          : thinkingChainSettings // ignore: cast_nullable_to_non_nullable
              as ThinkingChainSettings,
    ) as $Val);
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenAIConfigCopyWith<$Res>? get openaiConfig {
    if (_value.openaiConfig == null) {
      return null;
    }

    return $OpenAIConfigCopyWith<$Res>(_value.openaiConfig!, (value) {
      return _then(_value.copyWith(openaiConfig: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeminiConfigCopyWith<$Res>? get geminiConfig {
    if (_value.geminiConfig == null) {
      return null;
    }

    return $GeminiConfigCopyWith<$Res>(_value.geminiConfig!, (value) {
      return _then(_value.copyWith(geminiConfig: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClaudeConfigCopyWith<$Res>? get claudeConfig {
    if (_value.claudeConfig == null) {
      return null;
    }

    return $ClaudeConfigCopyWith<$Res>(_value.claudeConfig!, (value) {
      return _then(_value.copyWith(claudeConfig: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatSettingsCopyWith<$Res> get chatSettings {
    return $ChatSettingsCopyWith<$Res>(_value.chatSettings, (value) {
      return _then(_value.copyWith(chatSettings: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrivacySettingsCopyWith<$Res> get privacySettings {
    return $PrivacySettingsCopyWith<$Res>(_value.privacySettings, (value) {
      return _then(_value.copyWith(privacySettings: value) as $Val);
    });
  }

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThinkingChainSettingsCopyWith<$Res> get thinkingChainSettings {
    return $ThinkingChainSettingsCopyWith<$Res>(_value.thinkingChainSettings,
        (value) {
      return _then(_value.copyWith(thinkingChainSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OpenAIConfig? openaiConfig,
      GeminiConfig? geminiConfig,
      ClaudeConfig? claudeConfig,
      ThemeMode themeMode,
      String language,
      AIProvider defaultProvider,
      ChatSettings chatSettings,
      PrivacySettings privacySettings,
      bool enableAnimations,
      ThinkingChainSettings thinkingChainSettings});

  @override
  $OpenAIConfigCopyWith<$Res>? get openaiConfig;
  @override
  $GeminiConfigCopyWith<$Res>? get geminiConfig;
  @override
  $ClaudeConfigCopyWith<$Res>? get claudeConfig;
  @override
  $ChatSettingsCopyWith<$Res> get chatSettings;
  @override
  $PrivacySettingsCopyWith<$Res> get privacySettings;
  @override
  $ThinkingChainSettingsCopyWith<$Res> get thinkingChainSettings;
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openaiConfig = freezed,
    Object? geminiConfig = freezed,
    Object? claudeConfig = freezed,
    Object? themeMode = null,
    Object? language = null,
    Object? defaultProvider = null,
    Object? chatSettings = null,
    Object? privacySettings = null,
    Object? enableAnimations = null,
    Object? thinkingChainSettings = null,
  }) {
    return _then(_$AppSettingsImpl(
      openaiConfig: freezed == openaiConfig
          ? _value.openaiConfig
          : openaiConfig // ignore: cast_nullable_to_non_nullable
              as OpenAIConfig?,
      geminiConfig: freezed == geminiConfig
          ? _value.geminiConfig
          : geminiConfig // ignore: cast_nullable_to_non_nullable
              as GeminiConfig?,
      claudeConfig: freezed == claudeConfig
          ? _value.claudeConfig
          : claudeConfig // ignore: cast_nullable_to_non_nullable
              as ClaudeConfig?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      defaultProvider: null == defaultProvider
          ? _value.defaultProvider
          : defaultProvider // ignore: cast_nullable_to_non_nullable
              as AIProvider,
      chatSettings: null == chatSettings
          ? _value.chatSettings
          : chatSettings // ignore: cast_nullable_to_non_nullable
              as ChatSettings,
      privacySettings: null == privacySettings
          ? _value.privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as PrivacySettings,
      enableAnimations: null == enableAnimations
          ? _value.enableAnimations
          : enableAnimations // ignore: cast_nullable_to_non_nullable
              as bool,
      thinkingChainSettings: null == thinkingChainSettings
          ? _value.thinkingChainSettings
          : thinkingChainSettings // ignore: cast_nullable_to_non_nullable
              as ThinkingChainSettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.openaiConfig,
      this.geminiConfig,
      this.claudeConfig,
      this.themeMode = ThemeMode.system,
      this.language = 'zh',
      this.defaultProvider = AIProvider.openai,
      this.chatSettings = const ChatSettings(),
      this.privacySettings = const PrivacySettings(),
      this.enableAnimations = true,
      this.thinkingChainSettings = const ThinkingChainSettings()});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  /// OpenAI API配置
  @override
  final OpenAIConfig? openaiConfig;

  /// Google Gemini API配置
  @override
  final GeminiConfig? geminiConfig;

  /// Anthropic Claude API配置
  @override
  final ClaudeConfig? claudeConfig;

  /// 主题设置
  @override
  @JsonKey()
  final ThemeMode themeMode;

  /// 语言设置
  @override
  @JsonKey()
  final String language;

  /// 默认AI提供商
  @override
  @JsonKey()
  final AIProvider defaultProvider;

  /// 聊天设置
  @override
  @JsonKey()
  final ChatSettings chatSettings;

  /// 隐私设置
  @override
  @JsonKey()
  final PrivacySettings privacySettings;

  /// 动画设置
  @override
  @JsonKey()
  final bool enableAnimations;

  /// 思考链设置
  @override
  @JsonKey()
  final ThinkingChainSettings thinkingChainSettings;

  @override
  String toString() {
    return 'AppSettings(openaiConfig: $openaiConfig, geminiConfig: $geminiConfig, claudeConfig: $claudeConfig, themeMode: $themeMode, language: $language, defaultProvider: $defaultProvider, chatSettings: $chatSettings, privacySettings: $privacySettings, enableAnimations: $enableAnimations, thinkingChainSettings: $thinkingChainSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.openaiConfig, openaiConfig) ||
                other.openaiConfig == openaiConfig) &&
            (identical(other.geminiConfig, geminiConfig) ||
                other.geminiConfig == geminiConfig) &&
            (identical(other.claudeConfig, claudeConfig) ||
                other.claudeConfig == claudeConfig) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.defaultProvider, defaultProvider) ||
                other.defaultProvider == defaultProvider) &&
            (identical(other.chatSettings, chatSettings) ||
                other.chatSettings == chatSettings) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings) &&
            (identical(other.enableAnimations, enableAnimations) ||
                other.enableAnimations == enableAnimations) &&
            (identical(other.thinkingChainSettings, thinkingChainSettings) ||
                other.thinkingChainSettings == thinkingChainSettings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      openaiConfig,
      geminiConfig,
      claudeConfig,
      themeMode,
      language,
      defaultProvider,
      chatSettings,
      privacySettings,
      enableAnimations,
      thinkingChainSettings);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final OpenAIConfig? openaiConfig,
      final GeminiConfig? geminiConfig,
      final ClaudeConfig? claudeConfig,
      final ThemeMode themeMode,
      final String language,
      final AIProvider defaultProvider,
      final ChatSettings chatSettings,
      final PrivacySettings privacySettings,
      final bool enableAnimations,
      final ThinkingChainSettings thinkingChainSettings}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  /// OpenAI API配置
  @override
  OpenAIConfig? get openaiConfig;

  /// Google Gemini API配置
  @override
  GeminiConfig? get geminiConfig;

  /// Anthropic Claude API配置
  @override
  ClaudeConfig? get claudeConfig;

  /// 主题设置
  @override
  ThemeMode get themeMode;

  /// 语言设置
  @override
  String get language;

  /// 默认AI提供商
  @override
  AIProvider get defaultProvider;

  /// 聊天设置
  @override
  ChatSettings get chatSettings;

  /// 隐私设置
  @override
  PrivacySettings get privacySettings;

  /// 动画设置
  @override
  bool get enableAnimations;

  /// 思考链设置
  @override
  ThinkingChainSettings get thinkingChainSettings;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenAIConfig _$OpenAIConfigFromJson(Map<String, dynamic> json) {
  return _OpenAIConfig.fromJson(json);
}

/// @nodoc
mixin _$OpenAIConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  /// 组织ID（可选）
  String? get organizationId => throw _privateConstructorUsedError;

  /// Serializes this OpenAIConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIConfigCopyWith<OpenAIConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIConfigCopyWith<$Res> {
  factory $OpenAIConfigCopyWith(
          OpenAIConfig value, $Res Function(OpenAIConfig) then) =
      _$OpenAIConfigCopyWithImpl<$Res, OpenAIConfig>;
  @useResult
  $Res call(
      {String apiKey,
      String? baseUrl,
      String defaultModel,
      String? organizationId});
}

/// @nodoc
class _$OpenAIConfigCopyWithImpl<$Res, $Val extends OpenAIConfig>
    implements $OpenAIConfigCopyWith<$Res> {
  _$OpenAIConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
    Object? organizationId = freezed,
  }) {
    return _then(_value.copyWith(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenAIConfigImplCopyWith<$Res>
    implements $OpenAIConfigCopyWith<$Res> {
  factory _$$OpenAIConfigImplCopyWith(
          _$OpenAIConfigImpl value, $Res Function(_$OpenAIConfigImpl) then) =
      __$$OpenAIConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String apiKey,
      String? baseUrl,
      String defaultModel,
      String? organizationId});
}

/// @nodoc
class __$$OpenAIConfigImplCopyWithImpl<$Res>
    extends _$OpenAIConfigCopyWithImpl<$Res, _$OpenAIConfigImpl>
    implements _$$OpenAIConfigImplCopyWith<$Res> {
  __$$OpenAIConfigImplCopyWithImpl(
      _$OpenAIConfigImpl _value, $Res Function(_$OpenAIConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenAIConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
    Object? organizationId = freezed,
  }) {
    return _then(_$OpenAIConfigImpl(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIConfigImpl implements _OpenAIConfig {
  const _$OpenAIConfigImpl(
      {required this.apiKey,
      this.baseUrl,
      this.defaultModel = 'gpt-3.5-turbo',
      this.organizationId});

  factory _$OpenAIConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIConfigImplFromJson(json);

  /// API密钥
  @override
  final String apiKey;

  /// 基础URL（可选，用于代理）
  @override
  final String? baseUrl;

  /// 默认模型
  @override
  @JsonKey()
  final String defaultModel;

  /// 组织ID（可选）
  @override
  final String? organizationId;

  @override
  String toString() {
    return 'OpenAIConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel, organizationId: $organizationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, apiKey, baseUrl, defaultModel, organizationId);

  /// Create a copy of OpenAIConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIConfigImplCopyWith<_$OpenAIConfigImpl> get copyWith =>
      __$$OpenAIConfigImplCopyWithImpl<_$OpenAIConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIConfigImplToJson(
      this,
    );
  }
}

abstract class _OpenAIConfig implements OpenAIConfig {
  const factory _OpenAIConfig(
      {required final String apiKey,
      final String? baseUrl,
      final String defaultModel,
      final String? organizationId}) = _$OpenAIConfigImpl;

  factory _OpenAIConfig.fromJson(Map<String, dynamic> json) =
      _$OpenAIConfigImpl.fromJson;

  /// API密钥
  @override
  String get apiKey;

  /// 基础URL（可选，用于代理）
  @override
  String? get baseUrl;

  /// 默认模型
  @override
  String get defaultModel;

  /// 组织ID（可选）
  @override
  String? get organizationId;

  /// Create a copy of OpenAIConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIConfigImplCopyWith<_$OpenAIConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeminiConfig _$GeminiConfigFromJson(Map<String, dynamic> json) {
  return _GeminiConfig.fromJson(json);
}

/// @nodoc
mixin _$GeminiConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  /// Serializes this GeminiConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeminiConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeminiConfigCopyWith<GeminiConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeminiConfigCopyWith<$Res> {
  factory $GeminiConfigCopyWith(
          GeminiConfig value, $Res Function(GeminiConfig) then) =
      _$GeminiConfigCopyWithImpl<$Res, GeminiConfig>;
  @useResult
  $Res call({String apiKey, String defaultModel});
}

/// @nodoc
class _$GeminiConfigCopyWithImpl<$Res, $Val extends GeminiConfig>
    implements $GeminiConfigCopyWith<$Res> {
  _$GeminiConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeminiConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultModel = null,
  }) {
    return _then(_value.copyWith(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeminiConfigImplCopyWith<$Res>
    implements $GeminiConfigCopyWith<$Res> {
  factory _$$GeminiConfigImplCopyWith(
          _$GeminiConfigImpl value, $Res Function(_$GeminiConfigImpl) then) =
      __$$GeminiConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String defaultModel});
}

/// @nodoc
class __$$GeminiConfigImplCopyWithImpl<$Res>
    extends _$GeminiConfigCopyWithImpl<$Res, _$GeminiConfigImpl>
    implements _$$GeminiConfigImplCopyWith<$Res> {
  __$$GeminiConfigImplCopyWithImpl(
      _$GeminiConfigImpl _value, $Res Function(_$GeminiConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeminiConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultModel = null,
  }) {
    return _then(_$GeminiConfigImpl(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeminiConfigImpl implements _GeminiConfig {
  const _$GeminiConfigImpl(
      {required this.apiKey, this.defaultModel = 'gemini-pro'});

  factory _$GeminiConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeminiConfigImplFromJson(json);

  /// API密钥
  @override
  final String apiKey;

  /// 默认模型
  @override
  @JsonKey()
  final String defaultModel;

  @override
  String toString() {
    return 'GeminiConfig(apiKey: $apiKey, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeminiConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, defaultModel);

  /// Create a copy of GeminiConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeminiConfigImplCopyWith<_$GeminiConfigImpl> get copyWith =>
      __$$GeminiConfigImplCopyWithImpl<_$GeminiConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeminiConfigImplToJson(
      this,
    );
  }
}

abstract class _GeminiConfig implements GeminiConfig {
  const factory _GeminiConfig(
      {required final String apiKey,
      final String defaultModel}) = _$GeminiConfigImpl;

  factory _GeminiConfig.fromJson(Map<String, dynamic> json) =
      _$GeminiConfigImpl.fromJson;

  /// API密钥
  @override
  String get apiKey;

  /// 默认模型
  @override
  String get defaultModel;

  /// Create a copy of GeminiConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeminiConfigImplCopyWith<_$GeminiConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClaudeConfig _$ClaudeConfigFromJson(Map<String, dynamic> json) {
  return _ClaudeConfig.fromJson(json);
}

/// @nodoc
mixin _$ClaudeConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  /// Serializes this ClaudeConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClaudeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaudeConfigCopyWith<ClaudeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaudeConfigCopyWith<$Res> {
  factory $ClaudeConfigCopyWith(
          ClaudeConfig value, $Res Function(ClaudeConfig) then) =
      _$ClaudeConfigCopyWithImpl<$Res, ClaudeConfig>;
  @useResult
  $Res call({String apiKey, String defaultModel});
}

/// @nodoc
class _$ClaudeConfigCopyWithImpl<$Res, $Val extends ClaudeConfig>
    implements $ClaudeConfigCopyWith<$Res> {
  _$ClaudeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaudeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultModel = null,
  }) {
    return _then(_value.copyWith(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaudeConfigImplCopyWith<$Res>
    implements $ClaudeConfigCopyWith<$Res> {
  factory _$$ClaudeConfigImplCopyWith(
          _$ClaudeConfigImpl value, $Res Function(_$ClaudeConfigImpl) then) =
      __$$ClaudeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String defaultModel});
}

/// @nodoc
class __$$ClaudeConfigImplCopyWithImpl<$Res>
    extends _$ClaudeConfigCopyWithImpl<$Res, _$ClaudeConfigImpl>
    implements _$$ClaudeConfigImplCopyWith<$Res> {
  __$$ClaudeConfigImplCopyWithImpl(
      _$ClaudeConfigImpl _value, $Res Function(_$ClaudeConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaudeConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultModel = null,
  }) {
    return _then(_$ClaudeConfigImpl(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultModel: null == defaultModel
          ? _value.defaultModel
          : defaultModel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClaudeConfigImpl implements _ClaudeConfig {
  const _$ClaudeConfigImpl(
      {required this.apiKey, this.defaultModel = 'claude-3-sonnet-20240229'});

  factory _$ClaudeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClaudeConfigImplFromJson(json);

  /// API密钥
  @override
  final String apiKey;

  /// 默认模型
  @override
  @JsonKey()
  final String defaultModel;

  @override
  String toString() {
    return 'ClaudeConfig(apiKey: $apiKey, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaudeConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, defaultModel);

  /// Create a copy of ClaudeConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaudeConfigImplCopyWith<_$ClaudeConfigImpl> get copyWith =>
      __$$ClaudeConfigImplCopyWithImpl<_$ClaudeConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClaudeConfigImplToJson(
      this,
    );
  }
}

abstract class _ClaudeConfig implements ClaudeConfig {
  const factory _ClaudeConfig(
      {required final String apiKey,
      final String defaultModel}) = _$ClaudeConfigImpl;

  factory _ClaudeConfig.fromJson(Map<String, dynamic> json) =
      _$ClaudeConfigImpl.fromJson;

  /// API密钥
  @override
  String get apiKey;

  /// 默认模型
  @override
  String get defaultModel;

  /// Create a copy of ClaudeConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaudeConfigImplCopyWith<_$ClaudeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatSettings _$ChatSettingsFromJson(Map<String, dynamic> json) {
  return _ChatSettings.fromJson(json);
}

/// @nodoc
mixin _$ChatSettings {
  /// 最大历史消息数
  int get maxHistoryLength => throw _privateConstructorUsedError;

  /// 默认温度
  double get temperature => throw _privateConstructorUsedError;

  /// 最大token数
  int get maxTokens => throw _privateConstructorUsedError;

  /// 是否启用流式响应
  bool get enableStreaming => throw _privateConstructorUsedError;

  /// 是否自动保存聊天
  bool get autoSaveChat => throw _privateConstructorUsedError;

  /// Serializes this ChatSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatSettingsCopyWith<ChatSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatSettingsCopyWith<$Res> {
  factory $ChatSettingsCopyWith(
          ChatSettings value, $Res Function(ChatSettings) then) =
      _$ChatSettingsCopyWithImpl<$Res, ChatSettings>;
  @useResult
  $Res call(
      {int maxHistoryLength,
      double temperature,
      int maxTokens,
      bool enableStreaming,
      bool autoSaveChat});
}

/// @nodoc
class _$ChatSettingsCopyWithImpl<$Res, $Val extends ChatSettings>
    implements $ChatSettingsCopyWith<$Res> {
  _$ChatSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxHistoryLength = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? autoSaveChat = null,
  }) {
    return _then(_value.copyWith(
      maxHistoryLength: null == maxHistoryLength
          ? _value.maxHistoryLength
          : maxHistoryLength // ignore: cast_nullable_to_non_nullable
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
      autoSaveChat: null == autoSaveChat
          ? _value.autoSaveChat
          : autoSaveChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatSettingsImplCopyWith<$Res>
    implements $ChatSettingsCopyWith<$Res> {
  factory _$$ChatSettingsImplCopyWith(
          _$ChatSettingsImpl value, $Res Function(_$ChatSettingsImpl) then) =
      __$$ChatSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int maxHistoryLength,
      double temperature,
      int maxTokens,
      bool enableStreaming,
      bool autoSaveChat});
}

/// @nodoc
class __$$ChatSettingsImplCopyWithImpl<$Res>
    extends _$ChatSettingsCopyWithImpl<$Res, _$ChatSettingsImpl>
    implements _$$ChatSettingsImplCopyWith<$Res> {
  __$$ChatSettingsImplCopyWithImpl(
      _$ChatSettingsImpl _value, $Res Function(_$ChatSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxHistoryLength = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? autoSaveChat = null,
  }) {
    return _then(_$ChatSettingsImpl(
      maxHistoryLength: null == maxHistoryLength
          ? _value.maxHistoryLength
          : maxHistoryLength // ignore: cast_nullable_to_non_nullable
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
      autoSaveChat: null == autoSaveChat
          ? _value.autoSaveChat
          : autoSaveChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatSettingsImpl implements _ChatSettings {
  const _$ChatSettingsImpl(
      {this.maxHistoryLength = 50,
      this.temperature = 0.7,
      this.maxTokens = 2048,
      this.enableStreaming = true,
      this.autoSaveChat = true});

  factory _$ChatSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatSettingsImplFromJson(json);

  /// 最大历史消息数
  @override
  @JsonKey()
  final int maxHistoryLength;

  /// 默认温度
  @override
  @JsonKey()
  final double temperature;

  /// 最大token数
  @override
  @JsonKey()
  final int maxTokens;

  /// 是否启用流式响应
  @override
  @JsonKey()
  final bool enableStreaming;

  /// 是否自动保存聊天
  @override
  @JsonKey()
  final bool autoSaveChat;

  @override
  String toString() {
    return 'ChatSettings(maxHistoryLength: $maxHistoryLength, temperature: $temperature, maxTokens: $maxTokens, enableStreaming: $enableStreaming, autoSaveChat: $autoSaveChat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatSettingsImpl &&
            (identical(other.maxHistoryLength, maxHistoryLength) ||
                other.maxHistoryLength == maxHistoryLength) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.enableStreaming, enableStreaming) ||
                other.enableStreaming == enableStreaming) &&
            (identical(other.autoSaveChat, autoSaveChat) ||
                other.autoSaveChat == autoSaveChat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, maxHistoryLength, temperature,
      maxTokens, enableStreaming, autoSaveChat);

  /// Create a copy of ChatSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatSettingsImplCopyWith<_$ChatSettingsImpl> get copyWith =>
      __$$ChatSettingsImplCopyWithImpl<_$ChatSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatSettingsImplToJson(
      this,
    );
  }
}

abstract class _ChatSettings implements ChatSettings {
  const factory _ChatSettings(
      {final int maxHistoryLength,
      final double temperature,
      final int maxTokens,
      final bool enableStreaming,
      final bool autoSaveChat}) = _$ChatSettingsImpl;

  factory _ChatSettings.fromJson(Map<String, dynamic> json) =
      _$ChatSettingsImpl.fromJson;

  /// 最大历史消息数
  @override
  int get maxHistoryLength;

  /// 默认温度
  @override
  double get temperature;

  /// 最大token数
  @override
  int get maxTokens;

  /// 是否启用流式响应
  @override
  bool get enableStreaming;

  /// 是否自动保存聊天
  @override
  bool get autoSaveChat;

  /// Create a copy of ChatSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatSettingsImplCopyWith<_$ChatSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) {
  return _PrivacySettings.fromJson(json);
}

/// @nodoc
mixin _$PrivacySettings {
  /// 是否启用数据收集
  bool get enableDataCollection => throw _privateConstructorUsedError;

  /// 是否启用崩溃报告
  bool get enableCrashReporting => throw _privateConstructorUsedError;

  /// 是否启用使用统计
  bool get enableUsageStats => throw _privateConstructorUsedError;

  /// 数据保留天数
  int get dataRetentionDays => throw _privateConstructorUsedError;

  /// Serializes this PrivacySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacySettingsCopyWith<PrivacySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacySettingsCopyWith<$Res> {
  factory $PrivacySettingsCopyWith(
          PrivacySettings value, $Res Function(PrivacySettings) then) =
      _$PrivacySettingsCopyWithImpl<$Res, PrivacySettings>;
  @useResult
  $Res call(
      {bool enableDataCollection,
      bool enableCrashReporting,
      bool enableUsageStats,
      int dataRetentionDays});
}

/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res, $Val extends PrivacySettings>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableDataCollection = null,
    Object? enableCrashReporting = null,
    Object? enableUsageStats = null,
    Object? dataRetentionDays = null,
  }) {
    return _then(_value.copyWith(
      enableDataCollection: null == enableDataCollection
          ? _value.enableDataCollection
          : enableDataCollection // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashReporting: null == enableCrashReporting
          ? _value.enableCrashReporting
          : enableCrashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
      enableUsageStats: null == enableUsageStats
          ? _value.enableUsageStats
          : enableUsageStats // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionDays: null == dataRetentionDays
          ? _value.dataRetentionDays
          : dataRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacySettingsImplCopyWith<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  factory _$$PrivacySettingsImplCopyWith(_$PrivacySettingsImpl value,
          $Res Function(_$PrivacySettingsImpl) then) =
      __$$PrivacySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableDataCollection,
      bool enableCrashReporting,
      bool enableUsageStats,
      int dataRetentionDays});
}

/// @nodoc
class __$$PrivacySettingsImplCopyWithImpl<$Res>
    extends _$PrivacySettingsCopyWithImpl<$Res, _$PrivacySettingsImpl>
    implements _$$PrivacySettingsImplCopyWith<$Res> {
  __$$PrivacySettingsImplCopyWithImpl(
      _$PrivacySettingsImpl _value, $Res Function(_$PrivacySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableDataCollection = null,
    Object? enableCrashReporting = null,
    Object? enableUsageStats = null,
    Object? dataRetentionDays = null,
  }) {
    return _then(_$PrivacySettingsImpl(
      enableDataCollection: null == enableDataCollection
          ? _value.enableDataCollection
          : enableDataCollection // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashReporting: null == enableCrashReporting
          ? _value.enableCrashReporting
          : enableCrashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
      enableUsageStats: null == enableUsageStats
          ? _value.enableUsageStats
          : enableUsageStats // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionDays: null == dataRetentionDays
          ? _value.dataRetentionDays
          : dataRetentionDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacySettingsImpl implements _PrivacySettings {
  const _$PrivacySettingsImpl(
      {this.enableDataCollection = false,
      this.enableCrashReporting = true,
      this.enableUsageStats = false,
      this.dataRetentionDays = 30});

  factory _$PrivacySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacySettingsImplFromJson(json);

  /// 是否启用数据收集
  @override
  @JsonKey()
  final bool enableDataCollection;

  /// 是否启用崩溃报告
  @override
  @JsonKey()
  final bool enableCrashReporting;

  /// 是否启用使用统计
  @override
  @JsonKey()
  final bool enableUsageStats;

  /// 数据保留天数
  @override
  @JsonKey()
  final int dataRetentionDays;

  @override
  String toString() {
    return 'PrivacySettings(enableDataCollection: $enableDataCollection, enableCrashReporting: $enableCrashReporting, enableUsageStats: $enableUsageStats, dataRetentionDays: $dataRetentionDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacySettingsImpl &&
            (identical(other.enableDataCollection, enableDataCollection) ||
                other.enableDataCollection == enableDataCollection) &&
            (identical(other.enableCrashReporting, enableCrashReporting) ||
                other.enableCrashReporting == enableCrashReporting) &&
            (identical(other.enableUsageStats, enableUsageStats) ||
                other.enableUsageStats == enableUsageStats) &&
            (identical(other.dataRetentionDays, dataRetentionDays) ||
                other.dataRetentionDays == dataRetentionDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enableDataCollection,
      enableCrashReporting, enableUsageStats, dataRetentionDays);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      __$$PrivacySettingsImplCopyWithImpl<_$PrivacySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacySettingsImplToJson(
      this,
    );
  }
}

abstract class _PrivacySettings implements PrivacySettings {
  const factory _PrivacySettings(
      {final bool enableDataCollection,
      final bool enableCrashReporting,
      final bool enableUsageStats,
      final int dataRetentionDays}) = _$PrivacySettingsImpl;

  factory _PrivacySettings.fromJson(Map<String, dynamic> json) =
      _$PrivacySettingsImpl.fromJson;

  /// 是否启用数据收集
  @override
  bool get enableDataCollection;

  /// 是否启用崩溃报告
  @override
  bool get enableCrashReporting;

  /// 是否启用使用统计
  @override
  bool get enableUsageStats;

  /// 数据保留天数
  @override
  int get dataRetentionDays;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThinkingChainSettings _$ThinkingChainSettingsFromJson(
    Map<String, dynamic> json) {
  return _ThinkingChainSettings.fromJson(json);
}

/// @nodoc
mixin _$ThinkingChainSettings {
  /// 是否显示思考链
  bool get showThinkingChain => throw _privateConstructorUsedError;

  /// 思考链动画速度（毫秒）
  int get animationSpeed => throw _privateConstructorUsedError;

  /// 是否启用思考链动画
  bool get enableAnimation => throw _privateConstructorUsedError;

  /// 思考链最大显示长度
  int get maxDisplayLength => throw _privateConstructorUsedError;

  /// 是否自动折叠长思考链
  bool get autoCollapseOnLongContent => throw _privateConstructorUsedError;

  /// 是否为Gemini模型特殊处理
  bool get enableGeminiSpecialHandling => throw _privateConstructorUsedError;

  /// Serializes this ThinkingChainSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ThinkingChainSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThinkingChainSettingsCopyWith<ThinkingChainSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThinkingChainSettingsCopyWith<$Res> {
  factory $ThinkingChainSettingsCopyWith(ThinkingChainSettings value,
          $Res Function(ThinkingChainSettings) then) =
      _$ThinkingChainSettingsCopyWithImpl<$Res, ThinkingChainSettings>;
  @useResult
  $Res call(
      {bool showThinkingChain,
      int animationSpeed,
      bool enableAnimation,
      int maxDisplayLength,
      bool autoCollapseOnLongContent,
      bool enableGeminiSpecialHandling});
}

/// @nodoc
class _$ThinkingChainSettingsCopyWithImpl<$Res,
        $Val extends ThinkingChainSettings>
    implements $ThinkingChainSettingsCopyWith<$Res> {
  _$ThinkingChainSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThinkingChainSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showThinkingChain = null,
    Object? animationSpeed = null,
    Object? enableAnimation = null,
    Object? maxDisplayLength = null,
    Object? autoCollapseOnLongContent = null,
    Object? enableGeminiSpecialHandling = null,
  }) {
    return _then(_value.copyWith(
      showThinkingChain: null == showThinkingChain
          ? _value.showThinkingChain
          : showThinkingChain // ignore: cast_nullable_to_non_nullable
              as bool,
      animationSpeed: null == animationSpeed
          ? _value.animationSpeed
          : animationSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      enableAnimation: null == enableAnimation
          ? _value.enableAnimation
          : enableAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      maxDisplayLength: null == maxDisplayLength
          ? _value.maxDisplayLength
          : maxDisplayLength // ignore: cast_nullable_to_non_nullable
              as int,
      autoCollapseOnLongContent: null == autoCollapseOnLongContent
          ? _value.autoCollapseOnLongContent
          : autoCollapseOnLongContent // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGeminiSpecialHandling: null == enableGeminiSpecialHandling
          ? _value.enableGeminiSpecialHandling
          : enableGeminiSpecialHandling // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThinkingChainSettingsImplCopyWith<$Res>
    implements $ThinkingChainSettingsCopyWith<$Res> {
  factory _$$ThinkingChainSettingsImplCopyWith(
          _$ThinkingChainSettingsImpl value,
          $Res Function(_$ThinkingChainSettingsImpl) then) =
      __$$ThinkingChainSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showThinkingChain,
      int animationSpeed,
      bool enableAnimation,
      int maxDisplayLength,
      bool autoCollapseOnLongContent,
      bool enableGeminiSpecialHandling});
}

/// @nodoc
class __$$ThinkingChainSettingsImplCopyWithImpl<$Res>
    extends _$ThinkingChainSettingsCopyWithImpl<$Res,
        _$ThinkingChainSettingsImpl>
    implements _$$ThinkingChainSettingsImplCopyWith<$Res> {
  __$$ThinkingChainSettingsImplCopyWithImpl(_$ThinkingChainSettingsImpl _value,
      $Res Function(_$ThinkingChainSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThinkingChainSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showThinkingChain = null,
    Object? animationSpeed = null,
    Object? enableAnimation = null,
    Object? maxDisplayLength = null,
    Object? autoCollapseOnLongContent = null,
    Object? enableGeminiSpecialHandling = null,
  }) {
    return _then(_$ThinkingChainSettingsImpl(
      showThinkingChain: null == showThinkingChain
          ? _value.showThinkingChain
          : showThinkingChain // ignore: cast_nullable_to_non_nullable
              as bool,
      animationSpeed: null == animationSpeed
          ? _value.animationSpeed
          : animationSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      enableAnimation: null == enableAnimation
          ? _value.enableAnimation
          : enableAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      maxDisplayLength: null == maxDisplayLength
          ? _value.maxDisplayLength
          : maxDisplayLength // ignore: cast_nullable_to_non_nullable
              as int,
      autoCollapseOnLongContent: null == autoCollapseOnLongContent
          ? _value.autoCollapseOnLongContent
          : autoCollapseOnLongContent // ignore: cast_nullable_to_non_nullable
              as bool,
      enableGeminiSpecialHandling: null == enableGeminiSpecialHandling
          ? _value.enableGeminiSpecialHandling
          : enableGeminiSpecialHandling // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThinkingChainSettingsImpl implements _ThinkingChainSettings {
  const _$ThinkingChainSettingsImpl(
      {this.showThinkingChain = true,
      this.animationSpeed = 50,
      this.enableAnimation = true,
      this.maxDisplayLength = 2000,
      this.autoCollapseOnLongContent = true,
      this.enableGeminiSpecialHandling = true});

  factory _$ThinkingChainSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThinkingChainSettingsImplFromJson(json);

  /// 是否显示思考链
  @override
  @JsonKey()
  final bool showThinkingChain;

  /// 思考链动画速度（毫秒）
  @override
  @JsonKey()
  final int animationSpeed;

  /// 是否启用思考链动画
  @override
  @JsonKey()
  final bool enableAnimation;

  /// 思考链最大显示长度
  @override
  @JsonKey()
  final int maxDisplayLength;

  /// 是否自动折叠长思考链
  @override
  @JsonKey()
  final bool autoCollapseOnLongContent;

  /// 是否为Gemini模型特殊处理
  @override
  @JsonKey()
  final bool enableGeminiSpecialHandling;

  @override
  String toString() {
    return 'ThinkingChainSettings(showThinkingChain: $showThinkingChain, animationSpeed: $animationSpeed, enableAnimation: $enableAnimation, maxDisplayLength: $maxDisplayLength, autoCollapseOnLongContent: $autoCollapseOnLongContent, enableGeminiSpecialHandling: $enableGeminiSpecialHandling)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThinkingChainSettingsImpl &&
            (identical(other.showThinkingChain, showThinkingChain) ||
                other.showThinkingChain == showThinkingChain) &&
            (identical(other.animationSpeed, animationSpeed) ||
                other.animationSpeed == animationSpeed) &&
            (identical(other.enableAnimation, enableAnimation) ||
                other.enableAnimation == enableAnimation) &&
            (identical(other.maxDisplayLength, maxDisplayLength) ||
                other.maxDisplayLength == maxDisplayLength) &&
            (identical(other.autoCollapseOnLongContent,
                    autoCollapseOnLongContent) ||
                other.autoCollapseOnLongContent == autoCollapseOnLongContent) &&
            (identical(other.enableGeminiSpecialHandling,
                    enableGeminiSpecialHandling) ||
                other.enableGeminiSpecialHandling ==
                    enableGeminiSpecialHandling));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      showThinkingChain,
      animationSpeed,
      enableAnimation,
      maxDisplayLength,
      autoCollapseOnLongContent,
      enableGeminiSpecialHandling);

  /// Create a copy of ThinkingChainSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThinkingChainSettingsImplCopyWith<_$ThinkingChainSettingsImpl>
      get copyWith => __$$ThinkingChainSettingsImplCopyWithImpl<
          _$ThinkingChainSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThinkingChainSettingsImplToJson(
      this,
    );
  }
}

abstract class _ThinkingChainSettings implements ThinkingChainSettings {
  const factory _ThinkingChainSettings(
      {final bool showThinkingChain,
      final int animationSpeed,
      final bool enableAnimation,
      final int maxDisplayLength,
      final bool autoCollapseOnLongContent,
      final bool enableGeminiSpecialHandling}) = _$ThinkingChainSettingsImpl;

  factory _ThinkingChainSettings.fromJson(Map<String, dynamic> json) =
      _$ThinkingChainSettingsImpl.fromJson;

  /// 是否显示思考链
  @override
  bool get showThinkingChain;

  /// 思考链动画速度（毫秒）
  @override
  int get animationSpeed;

  /// 是否启用思考链动画
  @override
  bool get enableAnimation;

  /// 思考链最大显示长度
  @override
  int get maxDisplayLength;

  /// 是否自动折叠长思考链
  @override
  bool get autoCollapseOnLongContent;

  /// 是否为Gemini模型特殊处理
  @override
  bool get enableGeminiSpecialHandling;

  /// Create a copy of ThinkingChainSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThinkingChainSettingsImplCopyWith<_$ThinkingChainSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
