// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_mode_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LearningModeState _$LearningModeStateFromJson(Map<String, dynamic> json) {
  return _LearningModeState.fromJson(json);
}

/// @nodoc
mixin _$LearningModeState {
  /// 是否启用学习模式
  bool get isLearningMode => throw _privateConstructorUsedError;

  /// 学习风格
  LearningStyle get style => throw _privateConstructorUsedError;

  /// 提示历史记录（用于上下文连贯性）
  List<String> get hintHistory => throw _privateConstructorUsedError;

  /// 回答详细程度
  ResponseDetail get responseDetail => throw _privateConstructorUsedError;

  /// 是否显示学习提示
  bool get showLearningHints => throw _privateConstructorUsedError;

  /// 苏格拉底式提问步骤计数
  int get questionStep => throw _privateConstructorUsedError;

  /// 最大提问步骤数
  int get maxQuestionSteps => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningModeStateCopyWith<LearningModeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningModeStateCopyWith<$Res> {
  factory $LearningModeStateCopyWith(
          LearningModeState value, $Res Function(LearningModeState) then) =
      _$LearningModeStateCopyWithImpl<$Res, LearningModeState>;
  @useResult
  $Res call(
      {bool isLearningMode,
      LearningStyle style,
      List<String> hintHistory,
      ResponseDetail responseDetail,
      bool showLearningHints,
      int questionStep,
      int maxQuestionSteps});
}

/// @nodoc
class _$LearningModeStateCopyWithImpl<$Res, $Val extends LearningModeState>
    implements $LearningModeStateCopyWith<$Res> {
  _$LearningModeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLearningMode = null,
    Object? style = null,
    Object? hintHistory = null,
    Object? responseDetail = null,
    Object? showLearningHints = null,
    Object? questionStep = null,
    Object? maxQuestionSteps = null,
  }) {
    return _then(_value.copyWith(
      isLearningMode: null == isLearningMode
          ? _value.isLearningMode
          : isLearningMode // ignore: cast_nullable_to_non_nullable
              as bool,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as LearningStyle,
      hintHistory: null == hintHistory
          ? _value.hintHistory
          : hintHistory // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responseDetail: null == responseDetail
          ? _value.responseDetail
          : responseDetail // ignore: cast_nullable_to_non_nullable
              as ResponseDetail,
      showLearningHints: null == showLearningHints
          ? _value.showLearningHints
          : showLearningHints // ignore: cast_nullable_to_non_nullable
              as bool,
      questionStep: null == questionStep
          ? _value.questionStep
          : questionStep // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuestionSteps: null == maxQuestionSteps
          ? _value.maxQuestionSteps
          : maxQuestionSteps // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningModeStateImplCopyWith<$Res>
    implements $LearningModeStateCopyWith<$Res> {
  factory _$$LearningModeStateImplCopyWith(_$LearningModeStateImpl value,
          $Res Function(_$LearningModeStateImpl) then) =
      __$$LearningModeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLearningMode,
      LearningStyle style,
      List<String> hintHistory,
      ResponseDetail responseDetail,
      bool showLearningHints,
      int questionStep,
      int maxQuestionSteps});
}

/// @nodoc
class __$$LearningModeStateImplCopyWithImpl<$Res>
    extends _$LearningModeStateCopyWithImpl<$Res, _$LearningModeStateImpl>
    implements _$$LearningModeStateImplCopyWith<$Res> {
  __$$LearningModeStateImplCopyWithImpl(_$LearningModeStateImpl _value,
      $Res Function(_$LearningModeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLearningMode = null,
    Object? style = null,
    Object? hintHistory = null,
    Object? responseDetail = null,
    Object? showLearningHints = null,
    Object? questionStep = null,
    Object? maxQuestionSteps = null,
  }) {
    return _then(_$LearningModeStateImpl(
      isLearningMode: null == isLearningMode
          ? _value.isLearningMode
          : isLearningMode // ignore: cast_nullable_to_non_nullable
              as bool,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as LearningStyle,
      hintHistory: null == hintHistory
          ? _value._hintHistory
          : hintHistory // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responseDetail: null == responseDetail
          ? _value.responseDetail
          : responseDetail // ignore: cast_nullable_to_non_nullable
              as ResponseDetail,
      showLearningHints: null == showLearningHints
          ? _value.showLearningHints
          : showLearningHints // ignore: cast_nullable_to_non_nullable
              as bool,
      questionStep: null == questionStep
          ? _value.questionStep
          : questionStep // ignore: cast_nullable_to_non_nullable
              as int,
      maxQuestionSteps: null == maxQuestionSteps
          ? _value.maxQuestionSteps
          : maxQuestionSteps // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningModeStateImpl implements _LearningModeState {
  const _$LearningModeStateImpl(
      {this.isLearningMode = false,
      this.style = LearningStyle.guided,
      final List<String> hintHistory = const [],
      this.responseDetail = ResponseDetail.normal,
      this.showLearningHints = true,
      this.questionStep = 0,
      this.maxQuestionSteps = 5})
      : _hintHistory = hintHistory;

  factory _$LearningModeStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningModeStateImplFromJson(json);

  /// 是否启用学习模式
  @override
  @JsonKey()
  final bool isLearningMode;

  /// 学习风格
  @override
  @JsonKey()
  final LearningStyle style;

  /// 提示历史记录（用于上下文连贯性）
  final List<String> _hintHistory;

  /// 提示历史记录（用于上下文连贯性）
  @override
  @JsonKey()
  List<String> get hintHistory {
    if (_hintHistory is EqualUnmodifiableListView) return _hintHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hintHistory);
  }

  /// 回答详细程度
  @override
  @JsonKey()
  final ResponseDetail responseDetail;

  /// 是否显示学习提示
  @override
  @JsonKey()
  final bool showLearningHints;

  /// 苏格拉底式提问步骤计数
  @override
  @JsonKey()
  final int questionStep;

  /// 最大提问步骤数
  @override
  @JsonKey()
  final int maxQuestionSteps;

  @override
  String toString() {
    return 'LearningModeState(isLearningMode: $isLearningMode, style: $style, hintHistory: $hintHistory, responseDetail: $responseDetail, showLearningHints: $showLearningHints, questionStep: $questionStep, maxQuestionSteps: $maxQuestionSteps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningModeStateImpl &&
            (identical(other.isLearningMode, isLearningMode) ||
                other.isLearningMode == isLearningMode) &&
            (identical(other.style, style) || other.style == style) &&
            const DeepCollectionEquality()
                .equals(other._hintHistory, _hintHistory) &&
            (identical(other.responseDetail, responseDetail) ||
                other.responseDetail == responseDetail) &&
            (identical(other.showLearningHints, showLearningHints) ||
                other.showLearningHints == showLearningHints) &&
            (identical(other.questionStep, questionStep) ||
                other.questionStep == questionStep) &&
            (identical(other.maxQuestionSteps, maxQuestionSteps) ||
                other.maxQuestionSteps == maxQuestionSteps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLearningMode,
      style,
      const DeepCollectionEquality().hash(_hintHistory),
      responseDetail,
      showLearningHints,
      questionStep,
      maxQuestionSteps);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningModeStateImplCopyWith<_$LearningModeStateImpl> get copyWith =>
      __$$LearningModeStateImplCopyWithImpl<_$LearningModeStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningModeStateImplToJson(
      this,
    );
  }
}

abstract class _LearningModeState implements LearningModeState {
  const factory _LearningModeState(
      {final bool isLearningMode,
      final LearningStyle style,
      final List<String> hintHistory,
      final ResponseDetail responseDetail,
      final bool showLearningHints,
      final int questionStep,
      final int maxQuestionSteps}) = _$LearningModeStateImpl;

  factory _LearningModeState.fromJson(Map<String, dynamic> json) =
      _$LearningModeStateImpl.fromJson;

  @override

  /// 是否启用学习模式
  bool get isLearningMode;
  @override

  /// 学习风格
  LearningStyle get style;
  @override

  /// 提示历史记录（用于上下文连贯性）
  List<String> get hintHistory;
  @override

  /// 回答详细程度
  ResponseDetail get responseDetail;
  @override

  /// 是否显示学习提示
  bool get showLearningHints;
  @override

  /// 苏格拉底式提问步骤计数
  int get questionStep;
  @override

  /// 最大提问步骤数
  int get maxQuestionSteps;
  @override
  @JsonKey(ignore: true)
  _$$LearningModeStateImplCopyWith<_$LearningModeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningModeConfig _$LearningModeConfigFromJson(Map<String, dynamic> json) {
  return _LearningModeConfig.fromJson(json);
}

/// @nodoc
mixin _$LearningModeConfig {
  /// 是否在答案前提供提示
  bool get provideHintsFirst => throw _privateConstructorUsedError;

  /// 是否允许直接给出答案
  bool get allowDirectAnswers => throw _privateConstructorUsedError;

  /// 提示间隔时间（秒）
  int get hintInterval => throw _privateConstructorUsedError;

  /// 自定义提示模板
  Map<String, String>? get customPromptTemplates =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningModeConfigCopyWith<LearningModeConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningModeConfigCopyWith<$Res> {
  factory $LearningModeConfigCopyWith(
          LearningModeConfig value, $Res Function(LearningModeConfig) then) =
      _$LearningModeConfigCopyWithImpl<$Res, LearningModeConfig>;
  @useResult
  $Res call(
      {bool provideHintsFirst,
      bool allowDirectAnswers,
      int hintInterval,
      Map<String, String>? customPromptTemplates});
}

/// @nodoc
class _$LearningModeConfigCopyWithImpl<$Res, $Val extends LearningModeConfig>
    implements $LearningModeConfigCopyWith<$Res> {
  _$LearningModeConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provideHintsFirst = null,
    Object? allowDirectAnswers = null,
    Object? hintInterval = null,
    Object? customPromptTemplates = freezed,
  }) {
    return _then(_value.copyWith(
      provideHintsFirst: null == provideHintsFirst
          ? _value.provideHintsFirst
          : provideHintsFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectAnswers: null == allowDirectAnswers
          ? _value.allowDirectAnswers
          : allowDirectAnswers // ignore: cast_nullable_to_non_nullable
              as bool,
      hintInterval: null == hintInterval
          ? _value.hintInterval
          : hintInterval // ignore: cast_nullable_to_non_nullable
              as int,
      customPromptTemplates: freezed == customPromptTemplates
          ? _value.customPromptTemplates
          : customPromptTemplates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningModeConfigImplCopyWith<$Res>
    implements $LearningModeConfigCopyWith<$Res> {
  factory _$$LearningModeConfigImplCopyWith(_$LearningModeConfigImpl value,
          $Res Function(_$LearningModeConfigImpl) then) =
      __$$LearningModeConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool provideHintsFirst,
      bool allowDirectAnswers,
      int hintInterval,
      Map<String, String>? customPromptTemplates});
}

/// @nodoc
class __$$LearningModeConfigImplCopyWithImpl<$Res>
    extends _$LearningModeConfigCopyWithImpl<$Res, _$LearningModeConfigImpl>
    implements _$$LearningModeConfigImplCopyWith<$Res> {
  __$$LearningModeConfigImplCopyWithImpl(_$LearningModeConfigImpl _value,
      $Res Function(_$LearningModeConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provideHintsFirst = null,
    Object? allowDirectAnswers = null,
    Object? hintInterval = null,
    Object? customPromptTemplates = freezed,
  }) {
    return _then(_$LearningModeConfigImpl(
      provideHintsFirst: null == provideHintsFirst
          ? _value.provideHintsFirst
          : provideHintsFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectAnswers: null == allowDirectAnswers
          ? _value.allowDirectAnswers
          : allowDirectAnswers // ignore: cast_nullable_to_non_nullable
              as bool,
      hintInterval: null == hintInterval
          ? _value.hintInterval
          : hintInterval // ignore: cast_nullable_to_non_nullable
              as int,
      customPromptTemplates: freezed == customPromptTemplates
          ? _value._customPromptTemplates
          : customPromptTemplates // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningModeConfigImpl implements _LearningModeConfig {
  const _$LearningModeConfigImpl(
      {this.provideHintsFirst = true,
      this.allowDirectAnswers = false,
      this.hintInterval = 5,
      final Map<String, String>? customPromptTemplates})
      : _customPromptTemplates = customPromptTemplates;

  factory _$LearningModeConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningModeConfigImplFromJson(json);

  /// 是否在答案前提供提示
  @override
  @JsonKey()
  final bool provideHintsFirst;

  /// 是否允许直接给出答案
  @override
  @JsonKey()
  final bool allowDirectAnswers;

  /// 提示间隔时间（秒）
  @override
  @JsonKey()
  final int hintInterval;

  /// 自定义提示模板
  final Map<String, String>? _customPromptTemplates;

  /// 自定义提示模板
  @override
  Map<String, String>? get customPromptTemplates {
    final value = _customPromptTemplates;
    if (value == null) return null;
    if (_customPromptTemplates is EqualUnmodifiableMapView)
      return _customPromptTemplates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LearningModeConfig(provideHintsFirst: $provideHintsFirst, allowDirectAnswers: $allowDirectAnswers, hintInterval: $hintInterval, customPromptTemplates: $customPromptTemplates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningModeConfigImpl &&
            (identical(other.provideHintsFirst, provideHintsFirst) ||
                other.provideHintsFirst == provideHintsFirst) &&
            (identical(other.allowDirectAnswers, allowDirectAnswers) ||
                other.allowDirectAnswers == allowDirectAnswers) &&
            (identical(other.hintInterval, hintInterval) ||
                other.hintInterval == hintInterval) &&
            const DeepCollectionEquality()
                .equals(other._customPromptTemplates, _customPromptTemplates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      provideHintsFirst,
      allowDirectAnswers,
      hintInterval,
      const DeepCollectionEquality().hash(_customPromptTemplates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningModeConfigImplCopyWith<_$LearningModeConfigImpl> get copyWith =>
      __$$LearningModeConfigImplCopyWithImpl<_$LearningModeConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningModeConfigImplToJson(
      this,
    );
  }
}

abstract class _LearningModeConfig implements LearningModeConfig {
  const factory _LearningModeConfig(
          {final bool provideHintsFirst,
          final bool allowDirectAnswers,
          final int hintInterval,
          final Map<String, String>? customPromptTemplates}) =
      _$LearningModeConfigImpl;

  factory _LearningModeConfig.fromJson(Map<String, dynamic> json) =
      _$LearningModeConfigImpl.fromJson;

  @override

  /// 是否在答案前提供提示
  bool get provideHintsFirst;
  @override

  /// 是否允许直接给出答案
  bool get allowDirectAnswers;
  @override

  /// 提示间隔时间（秒）
  int get hintInterval;
  @override

  /// 自定义提示模板
  Map<String, String>? get customPromptTemplates;
  @override
  @JsonKey(ignore: true)
  _$$LearningModeConfigImplCopyWith<_$LearningModeConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
