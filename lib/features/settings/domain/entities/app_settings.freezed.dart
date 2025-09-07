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

  /// DeepSeek API配置
  DeepSeekConfig? get deepseekConfig => throw _privateConstructorUsedError;

  /// 阿里云通义千问 API配置
  QwenConfig? get qwenConfig => throw _privateConstructorUsedError;

  /// OpenRouter API配置
  OpenRouterConfig? get openrouterConfig => throw _privateConstructorUsedError;

  /// Ollama API配置
  OllamaConfig? get ollamaConfig => throw _privateConstructorUsedError;

  /// 主题设置
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// 颜色主题设置
  AppColorTheme get colorTheme => throw _privateConstructorUsedError;

  /// 语言设置
  String get language => throw _privateConstructorUsedError;

  /// 默认AI提供商
  AIProvider get defaultProvider => throw _privateConstructorUsedError;

  /// 聊天设置
  ChatSettings get chatSettings => throw _privateConstructorUsedError;

  /// 隐私设置
  PrivacySettings get privacySettings => throw _privateConstructorUsedError;

  /// 思考链设置
  ThinkingChainSettings get thinkingChainSettings =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      DeepSeekConfig? deepseekConfig,
      QwenConfig? qwenConfig,
      OpenRouterConfig? openrouterConfig,
      OllamaConfig? ollamaConfig,
      ThemeMode themeMode,
      AppColorTheme colorTheme,
      String language,
      AIProvider defaultProvider,
      ChatSettings chatSettings,
      PrivacySettings privacySettings,
      ThinkingChainSettings thinkingChainSettings});

  $OpenAIConfigCopyWith<$Res>? get openaiConfig;
  $GeminiConfigCopyWith<$Res>? get geminiConfig;
  $ClaudeConfigCopyWith<$Res>? get claudeConfig;
  $DeepSeekConfigCopyWith<$Res>? get deepseekConfig;
  $QwenConfigCopyWith<$Res>? get qwenConfig;
  $OpenRouterConfigCopyWith<$Res>? get openrouterConfig;
  $OllamaConfigCopyWith<$Res>? get ollamaConfig;
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openaiConfig = freezed,
    Object? geminiConfig = freezed,
    Object? claudeConfig = freezed,
    Object? deepseekConfig = freezed,
    Object? qwenConfig = freezed,
    Object? openrouterConfig = freezed,
    Object? ollamaConfig = freezed,
    Object? themeMode = null,
    Object? colorTheme = null,
    Object? language = null,
    Object? defaultProvider = null,
    Object? chatSettings = null,
    Object? privacySettings = null,
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
      deepseekConfig: freezed == deepseekConfig
          ? _value.deepseekConfig
          : deepseekConfig // ignore: cast_nullable_to_non_nullable
              as DeepSeekConfig?,
      qwenConfig: freezed == qwenConfig
          ? _value.qwenConfig
          : qwenConfig // ignore: cast_nullable_to_non_nullable
              as QwenConfig?,
      openrouterConfig: freezed == openrouterConfig
          ? _value.openrouterConfig
          : openrouterConfig // ignore: cast_nullable_to_non_nullable
              as OpenRouterConfig?,
      ollamaConfig: freezed == ollamaConfig
          ? _value.ollamaConfig
          : ollamaConfig // ignore: cast_nullable_to_non_nullable
              as OllamaConfig?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      colorTheme: null == colorTheme
          ? _value.colorTheme
          : colorTheme // ignore: cast_nullable_to_non_nullable
              as AppColorTheme,
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
      thinkingChainSettings: null == thinkingChainSettings
          ? _value.thinkingChainSettings
          : thinkingChainSettings // ignore: cast_nullable_to_non_nullable
              as ThinkingChainSettings,
    ) as $Val);
  }

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

  @override
  @pragma('vm:prefer-inline')
  $DeepSeekConfigCopyWith<$Res>? get deepseekConfig {
    if (_value.deepseekConfig == null) {
      return null;
    }

    return $DeepSeekConfigCopyWith<$Res>(_value.deepseekConfig!, (value) {
      return _then(_value.copyWith(deepseekConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QwenConfigCopyWith<$Res>? get qwenConfig {
    if (_value.qwenConfig == null) {
      return null;
    }

    return $QwenConfigCopyWith<$Res>(_value.qwenConfig!, (value) {
      return _then(_value.copyWith(qwenConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OpenRouterConfigCopyWith<$Res>? get openrouterConfig {
    if (_value.openrouterConfig == null) {
      return null;
    }

    return $OpenRouterConfigCopyWith<$Res>(_value.openrouterConfig!, (value) {
      return _then(_value.copyWith(openrouterConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OllamaConfigCopyWith<$Res>? get ollamaConfig {
    if (_value.ollamaConfig == null) {
      return null;
    }

    return $OllamaConfigCopyWith<$Res>(_value.ollamaConfig!, (value) {
      return _then(_value.copyWith(ollamaConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatSettingsCopyWith<$Res> get chatSettings {
    return $ChatSettingsCopyWith<$Res>(_value.chatSettings, (value) {
      return _then(_value.copyWith(chatSettings: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PrivacySettingsCopyWith<$Res> get privacySettings {
    return $PrivacySettingsCopyWith<$Res>(_value.privacySettings, (value) {
      return _then(_value.copyWith(privacySettings: value) as $Val);
    });
  }

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
      DeepSeekConfig? deepseekConfig,
      QwenConfig? qwenConfig,
      OpenRouterConfig? openrouterConfig,
      OllamaConfig? ollamaConfig,
      ThemeMode themeMode,
      AppColorTheme colorTheme,
      String language,
      AIProvider defaultProvider,
      ChatSettings chatSettings,
      PrivacySettings privacySettings,
      ThinkingChainSettings thinkingChainSettings});

  @override
  $OpenAIConfigCopyWith<$Res>? get openaiConfig;
  @override
  $GeminiConfigCopyWith<$Res>? get geminiConfig;
  @override
  $ClaudeConfigCopyWith<$Res>? get claudeConfig;
  @override
  $DeepSeekConfigCopyWith<$Res>? get deepseekConfig;
  @override
  $QwenConfigCopyWith<$Res>? get qwenConfig;
  @override
  $OpenRouterConfigCopyWith<$Res>? get openrouterConfig;
  @override
  $OllamaConfigCopyWith<$Res>? get ollamaConfig;
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openaiConfig = freezed,
    Object? geminiConfig = freezed,
    Object? claudeConfig = freezed,
    Object? deepseekConfig = freezed,
    Object? qwenConfig = freezed,
    Object? openrouterConfig = freezed,
    Object? ollamaConfig = freezed,
    Object? themeMode = null,
    Object? colorTheme = null,
    Object? language = null,
    Object? defaultProvider = null,
    Object? chatSettings = null,
    Object? privacySettings = null,
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
      deepseekConfig: freezed == deepseekConfig
          ? _value.deepseekConfig
          : deepseekConfig // ignore: cast_nullable_to_non_nullable
              as DeepSeekConfig?,
      qwenConfig: freezed == qwenConfig
          ? _value.qwenConfig
          : qwenConfig // ignore: cast_nullable_to_non_nullable
              as QwenConfig?,
      openrouterConfig: freezed == openrouterConfig
          ? _value.openrouterConfig
          : openrouterConfig // ignore: cast_nullable_to_non_nullable
              as OpenRouterConfig?,
      ollamaConfig: freezed == ollamaConfig
          ? _value.ollamaConfig
          : ollamaConfig // ignore: cast_nullable_to_non_nullable
              as OllamaConfig?,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      colorTheme: null == colorTheme
          ? _value.colorTheme
          : colorTheme // ignore: cast_nullable_to_non_nullable
              as AppColorTheme,
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
      this.deepseekConfig,
      this.qwenConfig,
      this.openrouterConfig,
      this.ollamaConfig,
      this.themeMode = ThemeMode.system,
      this.colorTheme = AppColorTheme.purple,
      this.language = 'zh',
      this.defaultProvider = AIProvider.openai,
      this.chatSettings = const ChatSettings(),
      this.privacySettings = const PrivacySettings(),
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

  /// DeepSeek API配置
  @override
  final DeepSeekConfig? deepseekConfig;

  /// 阿里云通义千问 API配置
  @override
  final QwenConfig? qwenConfig;

  /// OpenRouter API配置
  @override
  final OpenRouterConfig? openrouterConfig;

  /// Ollama API配置
  @override
  final OllamaConfig? ollamaConfig;

  /// 主题设置
  @override
  @JsonKey()
  final ThemeMode themeMode;

  /// 颜色主题设置
  @override
  @JsonKey()
  final AppColorTheme colorTheme;

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

  /// 思考链设置
  @override
  @JsonKey()
  final ThinkingChainSettings thinkingChainSettings;

  @override
  String toString() {
    return 'AppSettings(openaiConfig: $openaiConfig, geminiConfig: $geminiConfig, claudeConfig: $claudeConfig, deepseekConfig: $deepseekConfig, qwenConfig: $qwenConfig, openrouterConfig: $openrouterConfig, ollamaConfig: $ollamaConfig, themeMode: $themeMode, colorTheme: $colorTheme, language: $language, defaultProvider: $defaultProvider, chatSettings: $chatSettings, privacySettings: $privacySettings, thinkingChainSettings: $thinkingChainSettings)';
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
            (identical(other.deepseekConfig, deepseekConfig) ||
                other.deepseekConfig == deepseekConfig) &&
            (identical(other.qwenConfig, qwenConfig) ||
                other.qwenConfig == qwenConfig) &&
            (identical(other.openrouterConfig, openrouterConfig) ||
                other.openrouterConfig == openrouterConfig) &&
            (identical(other.ollamaConfig, ollamaConfig) ||
                other.ollamaConfig == ollamaConfig) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.colorTheme, colorTheme) ||
                other.colorTheme == colorTheme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.defaultProvider, defaultProvider) ||
                other.defaultProvider == defaultProvider) &&
            (identical(other.chatSettings, chatSettings) ||
                other.chatSettings == chatSettings) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings) &&
            (identical(other.thinkingChainSettings, thinkingChainSettings) ||
                other.thinkingChainSettings == thinkingChainSettings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      openaiConfig,
      geminiConfig,
      claudeConfig,
      deepseekConfig,
      qwenConfig,
      openrouterConfig,
      ollamaConfig,
      themeMode,
      colorTheme,
      language,
      defaultProvider,
      chatSettings,
      privacySettings,
      thinkingChainSettings);

  @JsonKey(ignore: true)
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
      final DeepSeekConfig? deepseekConfig,
      final QwenConfig? qwenConfig,
      final OpenRouterConfig? openrouterConfig,
      final OllamaConfig? ollamaConfig,
      final ThemeMode themeMode,
      final AppColorTheme colorTheme,
      final String language,
      final AIProvider defaultProvider,
      final ChatSettings chatSettings,
      final PrivacySettings privacySettings,
      final ThinkingChainSettings thinkingChainSettings}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override

  /// OpenAI API配置
  OpenAIConfig? get openaiConfig;
  @override

  /// Google Gemini API配置
  GeminiConfig? get geminiConfig;
  @override

  /// Anthropic Claude API配置
  ClaudeConfig? get claudeConfig;
  @override

  /// DeepSeek API配置
  DeepSeekConfig? get deepseekConfig;
  @override

  /// 阿里云通义千问 API配置
  QwenConfig? get qwenConfig;
  @override

  /// OpenRouter API配置
  OpenRouterConfig? get openrouterConfig;
  @override

  /// Ollama API配置
  OllamaConfig? get ollamaConfig;
  @override

  /// 主题设置
  ThemeMode get themeMode;
  @override

  /// 颜色主题设置
  AppColorTheme get colorTheme;
  @override

  /// 语言设置
  String get language;
  @override

  /// 默认AI提供商
  AIProvider get defaultProvider;
  @override

  /// 聊天设置
  ChatSettings get chatSettings;
  @override

  /// 隐私设置
  PrivacySettings get privacySettings;
  @override

  /// 思考链设置
  ThinkingChainSettings get thinkingChainSettings;
  @override
  @JsonKey(ignore: true)
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, apiKey, baseUrl, defaultModel, organizationId);

  @JsonKey(ignore: true)
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

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override

  /// 组织ID（可选）
  String? get organizationId;
  @override
  @JsonKey(ignore: true)
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, defaultModel);

  @JsonKey(ignore: true)
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

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
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

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClaudeConfigCopyWith<ClaudeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaudeConfigCopyWith<$Res> {
  factory $ClaudeConfigCopyWith(
          ClaudeConfig value, $Res Function(ClaudeConfig) then) =
      _$ClaudeConfigCopyWithImpl<$Res, ClaudeConfig>;
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class _$ClaudeConfigCopyWithImpl<$Res, $Val extends ClaudeConfig>
    implements $ClaudeConfigCopyWith<$Res> {
  _$ClaudeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
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
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class __$$ClaudeConfigImplCopyWithImpl<$Res>
    extends _$ClaudeConfigCopyWithImpl<$Res, _$ClaudeConfigImpl>
    implements _$$ClaudeConfigImplCopyWith<$Res> {
  __$$ClaudeConfigImplCopyWithImpl(
      _$ClaudeConfigImpl _value, $Res Function(_$ClaudeConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
  }) {
    return _then(_$ClaudeConfigImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClaudeConfigImpl implements _ClaudeConfig {
  const _$ClaudeConfigImpl(
      {required this.apiKey,
      this.baseUrl,
      this.defaultModel = 'claude-3-sonnet-20240229'});

  factory _$ClaudeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClaudeConfigImplFromJson(json);

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

  @override
  String toString() {
    return 'ClaudeConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaudeConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, baseUrl, defaultModel);

  @JsonKey(ignore: true)
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
      final String? baseUrl,
      final String defaultModel}) = _$ClaudeConfigImpl;

  factory _ClaudeConfig.fromJson(Map<String, dynamic> json) =
      _$ClaudeConfigImpl.fromJson;

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
  _$$ClaudeConfigImplCopyWith<_$ClaudeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeepSeekConfig _$DeepSeekConfigFromJson(Map<String, dynamic> json) {
  return _DeepSeekConfig.fromJson(json);
}

/// @nodoc
mixin _$DeepSeekConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeepSeekConfigCopyWith<DeepSeekConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeepSeekConfigCopyWith<$Res> {
  factory $DeepSeekConfigCopyWith(
          DeepSeekConfig value, $Res Function(DeepSeekConfig) then) =
      _$DeepSeekConfigCopyWithImpl<$Res, DeepSeekConfig>;
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class _$DeepSeekConfigCopyWithImpl<$Res, $Val extends DeepSeekConfig>
    implements $DeepSeekConfigCopyWith<$Res> {
  _$DeepSeekConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeepSeekConfigImplCopyWith<$Res>
    implements $DeepSeekConfigCopyWith<$Res> {
  factory _$$DeepSeekConfigImplCopyWith(_$DeepSeekConfigImpl value,
          $Res Function(_$DeepSeekConfigImpl) then) =
      __$$DeepSeekConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class __$$DeepSeekConfigImplCopyWithImpl<$Res>
    extends _$DeepSeekConfigCopyWithImpl<$Res, _$DeepSeekConfigImpl>
    implements _$$DeepSeekConfigImplCopyWith<$Res> {
  __$$DeepSeekConfigImplCopyWithImpl(
      _$DeepSeekConfigImpl _value, $Res Function(_$DeepSeekConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
  }) {
    return _then(_$DeepSeekConfigImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeepSeekConfigImpl implements _DeepSeekConfig {
  const _$DeepSeekConfigImpl(
      {required this.apiKey,
      this.baseUrl,
      this.defaultModel = 'deepseek-chat'});

  factory _$DeepSeekConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeepSeekConfigImplFromJson(json);

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

  @override
  String toString() {
    return 'DeepSeekConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeepSeekConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, baseUrl, defaultModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeepSeekConfigImplCopyWith<_$DeepSeekConfigImpl> get copyWith =>
      __$$DeepSeekConfigImplCopyWithImpl<_$DeepSeekConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeepSeekConfigImplToJson(
      this,
    );
  }
}

abstract class _DeepSeekConfig implements DeepSeekConfig {
  const factory _DeepSeekConfig(
      {required final String apiKey,
      final String? baseUrl,
      final String defaultModel}) = _$DeepSeekConfigImpl;

  factory _DeepSeekConfig.fromJson(Map<String, dynamic> json) =
      _$DeepSeekConfigImpl.fromJson;

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
  _$$DeepSeekConfigImplCopyWith<_$DeepSeekConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QwenConfig _$QwenConfigFromJson(Map<String, dynamic> json) {
  return _QwenConfig.fromJson(json);
}

/// @nodoc
mixin _$QwenConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QwenConfigCopyWith<QwenConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QwenConfigCopyWith<$Res> {
  factory $QwenConfigCopyWith(
          QwenConfig value, $Res Function(QwenConfig) then) =
      _$QwenConfigCopyWithImpl<$Res, QwenConfig>;
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class _$QwenConfigCopyWithImpl<$Res, $Val extends QwenConfig>
    implements $QwenConfigCopyWith<$Res> {
  _$QwenConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QwenConfigImplCopyWith<$Res>
    implements $QwenConfigCopyWith<$Res> {
  factory _$$QwenConfigImplCopyWith(
          _$QwenConfigImpl value, $Res Function(_$QwenConfigImpl) then) =
      __$$QwenConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class __$$QwenConfigImplCopyWithImpl<$Res>
    extends _$QwenConfigCopyWithImpl<$Res, _$QwenConfigImpl>
    implements _$$QwenConfigImplCopyWith<$Res> {
  __$$QwenConfigImplCopyWithImpl(
      _$QwenConfigImpl _value, $Res Function(_$QwenConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
  }) {
    return _then(_$QwenConfigImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QwenConfigImpl implements _QwenConfig {
  const _$QwenConfigImpl(
      {required this.apiKey, this.baseUrl, this.defaultModel = 'qwen-turbo'});

  factory _$QwenConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$QwenConfigImplFromJson(json);

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

  @override
  String toString() {
    return 'QwenConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QwenConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, baseUrl, defaultModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QwenConfigImplCopyWith<_$QwenConfigImpl> get copyWith =>
      __$$QwenConfigImplCopyWithImpl<_$QwenConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QwenConfigImplToJson(
      this,
    );
  }
}

abstract class _QwenConfig implements QwenConfig {
  const factory _QwenConfig(
      {required final String apiKey,
      final String? baseUrl,
      final String defaultModel}) = _$QwenConfigImpl;

  factory _QwenConfig.fromJson(Map<String, dynamic> json) =
      _$QwenConfigImpl.fromJson;

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
  _$$QwenConfigImplCopyWith<_$QwenConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenRouterConfig _$OpenRouterConfigFromJson(Map<String, dynamic> json) {
  return _OpenRouterConfig.fromJson(json);
}

/// @nodoc
mixin _$OpenRouterConfig {
  /// API密钥
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（可选，用于代理）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpenRouterConfigCopyWith<OpenRouterConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenRouterConfigCopyWith<$Res> {
  factory $OpenRouterConfigCopyWith(
          OpenRouterConfig value, $Res Function(OpenRouterConfig) then) =
      _$OpenRouterConfigCopyWithImpl<$Res, OpenRouterConfig>;
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class _$OpenRouterConfigCopyWithImpl<$Res, $Val extends OpenRouterConfig>
    implements $OpenRouterConfigCopyWith<$Res> {
  _$OpenRouterConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenRouterConfigImplCopyWith<$Res>
    implements $OpenRouterConfigCopyWith<$Res> {
  factory _$$OpenRouterConfigImplCopyWith(_$OpenRouterConfigImpl value,
          $Res Function(_$OpenRouterConfigImpl) then) =
      __$$OpenRouterConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class __$$OpenRouterConfigImplCopyWithImpl<$Res>
    extends _$OpenRouterConfigCopyWithImpl<$Res, _$OpenRouterConfigImpl>
    implements _$$OpenRouterConfigImplCopyWith<$Res> {
  __$$OpenRouterConfigImplCopyWithImpl(_$OpenRouterConfigImpl _value,
      $Res Function(_$OpenRouterConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
  }) {
    return _then(_$OpenRouterConfigImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenRouterConfigImpl implements _OpenRouterConfig {
  const _$OpenRouterConfigImpl(
      {required this.apiKey,
      this.baseUrl,
      this.defaultModel = 'meta-llama/llama-3.1-8b-instruct:free'});

  factory _$OpenRouterConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenRouterConfigImplFromJson(json);

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

  @override
  String toString() {
    return 'OpenRouterConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenRouterConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, baseUrl, defaultModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenRouterConfigImplCopyWith<_$OpenRouterConfigImpl> get copyWith =>
      __$$OpenRouterConfigImplCopyWithImpl<_$OpenRouterConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenRouterConfigImplToJson(
      this,
    );
  }
}

abstract class _OpenRouterConfig implements OpenRouterConfig {
  const factory _OpenRouterConfig(
      {required final String apiKey,
      final String? baseUrl,
      final String defaultModel}) = _$OpenRouterConfigImpl;

  factory _OpenRouterConfig.fromJson(Map<String, dynamic> json) =
      _$OpenRouterConfigImpl.fromJson;

  @override

  /// API密钥
  String get apiKey;
  @override

  /// 基础URL（可选，用于代理）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
  _$$OpenRouterConfigImplCopyWith<_$OpenRouterConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OllamaConfig _$OllamaConfigFromJson(Map<String, dynamic> json) {
  return _OllamaConfig.fromJson(json);
}

/// @nodoc
mixin _$OllamaConfig {
  /// API密钥（Ollama通常不需要，但保持一致性）
  String get apiKey => throw _privateConstructorUsedError;

  /// 基础URL（Ollama服务地址）
  String? get baseUrl => throw _privateConstructorUsedError;

  /// 默认模型
  String get defaultModel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OllamaConfigCopyWith<OllamaConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OllamaConfigCopyWith<$Res> {
  factory $OllamaConfigCopyWith(
          OllamaConfig value, $Res Function(OllamaConfig) then) =
      _$OllamaConfigCopyWithImpl<$Res, OllamaConfig>;
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class _$OllamaConfigCopyWithImpl<$Res, $Val extends OllamaConfig>
    implements $OllamaConfigCopyWith<$Res> {
  _$OllamaConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OllamaConfigImplCopyWith<$Res>
    implements $OllamaConfigCopyWith<$Res> {
  factory _$$OllamaConfigImplCopyWith(
          _$OllamaConfigImpl value, $Res Function(_$OllamaConfigImpl) then) =
      __$$OllamaConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String apiKey, String? baseUrl, String defaultModel});
}

/// @nodoc
class __$$OllamaConfigImplCopyWithImpl<$Res>
    extends _$OllamaConfigCopyWithImpl<$Res, _$OllamaConfigImpl>
    implements _$$OllamaConfigImplCopyWith<$Res> {
  __$$OllamaConfigImplCopyWithImpl(
      _$OllamaConfigImpl _value, $Res Function(_$OllamaConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? baseUrl = freezed,
    Object? defaultModel = null,
  }) {
    return _then(_$OllamaConfigImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OllamaConfigImpl implements _OllamaConfig {
  const _$OllamaConfigImpl(
      {this.apiKey = '',
      this.baseUrl = 'http://localhost:11434/v1',
      this.defaultModel = 'llama3.2'});

  factory _$OllamaConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$OllamaConfigImplFromJson(json);

  /// API密钥（Ollama通常不需要，但保持一致性）
  @override
  @JsonKey()
  final String apiKey;

  /// 基础URL（Ollama服务地址）
  @override
  @JsonKey()
  final String? baseUrl;

  /// 默认模型
  @override
  @JsonKey()
  final String defaultModel;

  @override
  String toString() {
    return 'OllamaConfig(apiKey: $apiKey, baseUrl: $baseUrl, defaultModel: $defaultModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OllamaConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.defaultModel, defaultModel) ||
                other.defaultModel == defaultModel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, apiKey, baseUrl, defaultModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OllamaConfigImplCopyWith<_$OllamaConfigImpl> get copyWith =>
      __$$OllamaConfigImplCopyWithImpl<_$OllamaConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OllamaConfigImplToJson(
      this,
    );
  }
}

abstract class _OllamaConfig implements OllamaConfig {
  const factory _OllamaConfig(
      {final String apiKey,
      final String? baseUrl,
      final String defaultModel}) = _$OllamaConfigImpl;

  factory _OllamaConfig.fromJson(Map<String, dynamic> json) =
      _$OllamaConfigImpl.fromJson;

  @override

  /// API密钥（Ollama通常不需要，但保持一致性）
  String get apiKey;
  @override

  /// 基础URL（Ollama服务地址）
  String? get baseUrl;
  @override

  /// 默认模型
  String get defaultModel;
  @override
  @JsonKey(ignore: true)
  _$$OllamaConfigImplCopyWith<_$OllamaConfigImpl> get copyWith =>
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

  /// 是否启用RAG知识库增强
  bool get enableRag => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      bool autoSaveChat,
      bool enableRag});
}

/// @nodoc
class _$ChatSettingsCopyWithImpl<$Res, $Val extends ChatSettings>
    implements $ChatSettingsCopyWith<$Res> {
  _$ChatSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxHistoryLength = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? autoSaveChat = null,
    Object? enableRag = null,
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
      enableRag: null == enableRag
          ? _value.enableRag
          : enableRag // ignore: cast_nullable_to_non_nullable
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
      bool autoSaveChat,
      bool enableRag});
}

/// @nodoc
class __$$ChatSettingsImplCopyWithImpl<$Res>
    extends _$ChatSettingsCopyWithImpl<$Res, _$ChatSettingsImpl>
    implements _$$ChatSettingsImplCopyWith<$Res> {
  __$$ChatSettingsImplCopyWithImpl(
      _$ChatSettingsImpl _value, $Res Function(_$ChatSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxHistoryLength = null,
    Object? temperature = null,
    Object? maxTokens = null,
    Object? enableStreaming = null,
    Object? autoSaveChat = null,
    Object? enableRag = null,
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
      enableRag: null == enableRag
          ? _value.enableRag
          : enableRag // ignore: cast_nullable_to_non_nullable
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
      this.autoSaveChat = true,
      this.enableRag = false});

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

  /// 是否启用RAG知识库增强
  @override
  @JsonKey()
  final bool enableRag;

  @override
  String toString() {
    return 'ChatSettings(maxHistoryLength: $maxHistoryLength, temperature: $temperature, maxTokens: $maxTokens, enableStreaming: $enableStreaming, autoSaveChat: $autoSaveChat, enableRag: $enableRag)';
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
                other.autoSaveChat == autoSaveChat) &&
            (identical(other.enableRag, enableRag) ||
                other.enableRag == enableRag));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, maxHistoryLength, temperature,
      maxTokens, enableStreaming, autoSaveChat, enableRag);

  @JsonKey(ignore: true)
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
      final bool autoSaveChat,
      final bool enableRag}) = _$ChatSettingsImpl;

  factory _ChatSettings.fromJson(Map<String, dynamic> json) =
      _$ChatSettingsImpl.fromJson;

  @override

  /// 最大历史消息数
  int get maxHistoryLength;
  @override

  /// 默认温度
  double get temperature;
  @override

  /// 最大token数
  int get maxTokens;
  @override

  /// 是否启用流式响应
  bool get enableStreaming;
  @override

  /// 是否自动保存聊天
  bool get autoSaveChat;
  @override

  /// 是否启用RAG知识库增强
  bool get enableRag;
  @override
  @JsonKey(ignore: true)
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, enableDataCollection,
      enableCrashReporting, enableUsageStats, dataRetentionDays);

  @JsonKey(ignore: true)
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

  @override

  /// 是否启用数据收集
  bool get enableDataCollection;
  @override

  /// 是否启用崩溃报告
  bool get enableCrashReporting;
  @override

  /// 是否启用使用统计
  bool get enableUsageStats;
  @override

  /// 数据保留天数
  int get dataRetentionDays;
  @override
  @JsonKey(ignore: true)
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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      showThinkingChain,
      animationSpeed,
      enableAnimation,
      maxDisplayLength,
      autoCollapseOnLongContent,
      enableGeminiSpecialHandling);

  @JsonKey(ignore: true)
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

  @override

  /// 是否显示思考链
  bool get showThinkingChain;
  @override

  /// 思考链动画速度（毫秒）
  int get animationSpeed;
  @override

  /// 是否启用思考链动画
  bool get enableAnimation;
  @override

  /// 思考链最大显示长度
  int get maxDisplayLength;
  @override

  /// 是否自动折叠长思考链
  bool get autoCollapseOnLongContent;
  @override

  /// 是否为Gemini模型特殊处理
  bool get enableGeminiSpecialHandling;
  @override
  @JsonKey(ignore: true)
  _$$ThinkingChainSettingsImplCopyWith<_$ThinkingChainSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
