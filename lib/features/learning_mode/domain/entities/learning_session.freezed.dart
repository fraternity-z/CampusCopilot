// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LearningSession _$LearningSessionFromJson(Map<String, dynamic> json) {
  return _LearningSession.fromJson(json);
}

/// @nodoc
mixin _$LearningSession {
  /// 会话ID
  String get sessionId => throw _privateConstructorUsedError;

  /// 初始问题
  String get initialQuestion => throw _privateConstructorUsedError;

  /// 当前轮次 (从1开始)
  int get currentRound => throw _privateConstructorUsedError;

  /// 最大轮次
  int get maxRounds => throw _privateConstructorUsedError;

  /// 会话状态
  LearningSessionStatus get status => throw _privateConstructorUsedError;

  /// 会话开始时间
  DateTime get startTime => throw _privateConstructorUsedError;

  /// 会话消息ID列表（用于跟踪完整上下文）
  List<String> get messageIds => throw _privateConstructorUsedError;

  /// 是否用户主动要求答案
  bool get userRequestedAnswer => throw _privateConstructorUsedError;

  /// 会话元数据
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningSessionCopyWith<LearningSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningSessionCopyWith<$Res> {
  factory $LearningSessionCopyWith(
          LearningSession value, $Res Function(LearningSession) then) =
      _$LearningSessionCopyWithImpl<$Res, LearningSession>;
  @useResult
  $Res call(
      {String sessionId,
      String initialQuestion,
      int currentRound,
      int maxRounds,
      LearningSessionStatus status,
      DateTime startTime,
      List<String> messageIds,
      bool userRequestedAnswer,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$LearningSessionCopyWithImpl<$Res, $Val extends LearningSession>
    implements $LearningSessionCopyWith<$Res> {
  _$LearningSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? initialQuestion = null,
    Object? currentRound = null,
    Object? maxRounds = null,
    Object? status = null,
    Object? startTime = null,
    Object? messageIds = null,
    Object? userRequestedAnswer = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      initialQuestion: null == initialQuestion
          ? _value.initialQuestion
          : initialQuestion // ignore: cast_nullable_to_non_nullable
              as String,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      maxRounds: null == maxRounds
          ? _value.maxRounds
          : maxRounds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LearningSessionStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageIds: null == messageIds
          ? _value.messageIds
          : messageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userRequestedAnswer: null == userRequestedAnswer
          ? _value.userRequestedAnswer
          : userRequestedAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningSessionImplCopyWith<$Res>
    implements $LearningSessionCopyWith<$Res> {
  factory _$$LearningSessionImplCopyWith(_$LearningSessionImpl value,
          $Res Function(_$LearningSessionImpl) then) =
      __$$LearningSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String initialQuestion,
      int currentRound,
      int maxRounds,
      LearningSessionStatus status,
      DateTime startTime,
      List<String> messageIds,
      bool userRequestedAnswer,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$LearningSessionImplCopyWithImpl<$Res>
    extends _$LearningSessionCopyWithImpl<$Res, _$LearningSessionImpl>
    implements _$$LearningSessionImplCopyWith<$Res> {
  __$$LearningSessionImplCopyWithImpl(
      _$LearningSessionImpl _value, $Res Function(_$LearningSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? initialQuestion = null,
    Object? currentRound = null,
    Object? maxRounds = null,
    Object? status = null,
    Object? startTime = null,
    Object? messageIds = null,
    Object? userRequestedAnswer = null,
    Object? metadata = freezed,
  }) {
    return _then(_$LearningSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      initialQuestion: null == initialQuestion
          ? _value.initialQuestion
          : initialQuestion // ignore: cast_nullable_to_non_nullable
              as String,
      currentRound: null == currentRound
          ? _value.currentRound
          : currentRound // ignore: cast_nullable_to_non_nullable
              as int,
      maxRounds: null == maxRounds
          ? _value.maxRounds
          : maxRounds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LearningSessionStatus,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageIds: null == messageIds
          ? _value._messageIds
          : messageIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userRequestedAnswer: null == userRequestedAnswer
          ? _value.userRequestedAnswer
          : userRequestedAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningSessionImpl implements _LearningSession {
  const _$LearningSessionImpl(
      {required this.sessionId,
      required this.initialQuestion,
      this.currentRound = 1,
      this.maxRounds = 8,
      this.status = LearningSessionStatus.active,
      required this.startTime,
      final List<String> messageIds = const [],
      this.userRequestedAnswer = false,
      final Map<String, dynamic>? metadata})
      : _messageIds = messageIds,
        _metadata = metadata;

  factory _$LearningSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningSessionImplFromJson(json);

  /// 会话ID
  @override
  final String sessionId;

  /// 初始问题
  @override
  final String initialQuestion;

  /// 当前轮次 (从1开始)
  @override
  @JsonKey()
  final int currentRound;

  /// 最大轮次
  @override
  @JsonKey()
  final int maxRounds;

  /// 会话状态
  @override
  @JsonKey()
  final LearningSessionStatus status;

  /// 会话开始时间
  @override
  final DateTime startTime;

  /// 会话消息ID列表（用于跟踪完整上下文）
  final List<String> _messageIds;

  /// 会话消息ID列表（用于跟踪完整上下文）
  @override
  @JsonKey()
  List<String> get messageIds {
    if (_messageIds is EqualUnmodifiableListView) return _messageIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messageIds);
  }

  /// 是否用户主动要求答案
  @override
  @JsonKey()
  final bool userRequestedAnswer;

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
    return 'LearningSession(sessionId: $sessionId, initialQuestion: $initialQuestion, currentRound: $currentRound, maxRounds: $maxRounds, status: $status, startTime: $startTime, messageIds: $messageIds, userRequestedAnswer: $userRequestedAnswer, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.initialQuestion, initialQuestion) ||
                other.initialQuestion == initialQuestion) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.maxRounds, maxRounds) ||
                other.maxRounds == maxRounds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            const DeepCollectionEquality()
                .equals(other._messageIds, _messageIds) &&
            (identical(other.userRequestedAnswer, userRequestedAnswer) ||
                other.userRequestedAnswer == userRequestedAnswer) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      initialQuestion,
      currentRound,
      maxRounds,
      status,
      startTime,
      const DeepCollectionEquality().hash(_messageIds),
      userRequestedAnswer,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningSessionImplCopyWith<_$LearningSessionImpl> get copyWith =>
      __$$LearningSessionImplCopyWithImpl<_$LearningSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningSessionImplToJson(
      this,
    );
  }
}

abstract class _LearningSession implements LearningSession {
  const factory _LearningSession(
      {required final String sessionId,
      required final String initialQuestion,
      final int currentRound,
      final int maxRounds,
      final LearningSessionStatus status,
      required final DateTime startTime,
      final List<String> messageIds,
      final bool userRequestedAnswer,
      final Map<String, dynamic>? metadata}) = _$LearningSessionImpl;

  factory _LearningSession.fromJson(Map<String, dynamic> json) =
      _$LearningSessionImpl.fromJson;

  @override

  /// 会话ID
  String get sessionId;
  @override

  /// 初始问题
  String get initialQuestion;
  @override

  /// 当前轮次 (从1开始)
  int get currentRound;
  @override

  /// 最大轮次
  int get maxRounds;
  @override

  /// 会话状态
  LearningSessionStatus get status;
  @override

  /// 会话开始时间
  DateTime get startTime;
  @override

  /// 会话消息ID列表（用于跟踪完整上下文）
  List<String> get messageIds;
  @override

  /// 是否用户主动要求答案
  bool get userRequestedAnswer;
  @override

  /// 会话元数据
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$LearningSessionImplCopyWith<_$LearningSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningSessionConfig _$LearningSessionConfigFromJson(
    Map<String, dynamic> json) {
  return _LearningSessionConfig.fromJson(json);
}

/// @nodoc
mixin _$LearningSessionConfig {
  /// 默认最大轮次
  int get defaultMaxRounds => throw _privateConstructorUsedError;

  /// 自动结束关键词
  List<String> get answerTriggerKeywords => throw _privateConstructorUsedError;

  /// 是否在最后一轮自动给出答案
  bool get autoAnswerAtEnd => throw _privateConstructorUsedError;

  /// 是否显示学习进度
  bool get showProgress => throw _privateConstructorUsedError;

  /// 上下文保持策略
  ContextStrategy get contextStrategy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningSessionConfigCopyWith<LearningSessionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningSessionConfigCopyWith<$Res> {
  factory $LearningSessionConfigCopyWith(LearningSessionConfig value,
          $Res Function(LearningSessionConfig) then) =
      _$LearningSessionConfigCopyWithImpl<$Res, LearningSessionConfig>;
  @useResult
  $Res call(
      {int defaultMaxRounds,
      List<String> answerTriggerKeywords,
      bool autoAnswerAtEnd,
      bool showProgress,
      ContextStrategy contextStrategy});
}

/// @nodoc
class _$LearningSessionConfigCopyWithImpl<$Res,
        $Val extends LearningSessionConfig>
    implements $LearningSessionConfigCopyWith<$Res> {
  _$LearningSessionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultMaxRounds = null,
    Object? answerTriggerKeywords = null,
    Object? autoAnswerAtEnd = null,
    Object? showProgress = null,
    Object? contextStrategy = null,
  }) {
    return _then(_value.copyWith(
      defaultMaxRounds: null == defaultMaxRounds
          ? _value.defaultMaxRounds
          : defaultMaxRounds // ignore: cast_nullable_to_non_nullable
              as int,
      answerTriggerKeywords: null == answerTriggerKeywords
          ? _value.answerTriggerKeywords
          : answerTriggerKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      autoAnswerAtEnd: null == autoAnswerAtEnd
          ? _value.autoAnswerAtEnd
          : autoAnswerAtEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      showProgress: null == showProgress
          ? _value.showProgress
          : showProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      contextStrategy: null == contextStrategy
          ? _value.contextStrategy
          : contextStrategy // ignore: cast_nullable_to_non_nullable
              as ContextStrategy,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningSessionConfigImplCopyWith<$Res>
    implements $LearningSessionConfigCopyWith<$Res> {
  factory _$$LearningSessionConfigImplCopyWith(
          _$LearningSessionConfigImpl value,
          $Res Function(_$LearningSessionConfigImpl) then) =
      __$$LearningSessionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int defaultMaxRounds,
      List<String> answerTriggerKeywords,
      bool autoAnswerAtEnd,
      bool showProgress,
      ContextStrategy contextStrategy});
}

/// @nodoc
class __$$LearningSessionConfigImplCopyWithImpl<$Res>
    extends _$LearningSessionConfigCopyWithImpl<$Res,
        _$LearningSessionConfigImpl>
    implements _$$LearningSessionConfigImplCopyWith<$Res> {
  __$$LearningSessionConfigImplCopyWithImpl(_$LearningSessionConfigImpl _value,
      $Res Function(_$LearningSessionConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultMaxRounds = null,
    Object? answerTriggerKeywords = null,
    Object? autoAnswerAtEnd = null,
    Object? showProgress = null,
    Object? contextStrategy = null,
  }) {
    return _then(_$LearningSessionConfigImpl(
      defaultMaxRounds: null == defaultMaxRounds
          ? _value.defaultMaxRounds
          : defaultMaxRounds // ignore: cast_nullable_to_non_nullable
              as int,
      answerTriggerKeywords: null == answerTriggerKeywords
          ? _value._answerTriggerKeywords
          : answerTriggerKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      autoAnswerAtEnd: null == autoAnswerAtEnd
          ? _value.autoAnswerAtEnd
          : autoAnswerAtEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      showProgress: null == showProgress
          ? _value.showProgress
          : showProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      contextStrategy: null == contextStrategy
          ? _value.contextStrategy
          : contextStrategy // ignore: cast_nullable_to_non_nullable
              as ContextStrategy,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningSessionConfigImpl implements _LearningSessionConfig {
  const _$LearningSessionConfigImpl(
      {this.defaultMaxRounds = 8,
      final List<String> answerTriggerKeywords = const [
        '直接告诉我答案',
        '给我答案',
        '直接给我答案',
        '不要引导了',
        '直接说',
        '我想要答案',
        '告诉我答案',
        '跳过引导',
        '直接回答',
        '我要答案',
        '给答案',
        '说答案',
        '直接讲答案',
        '别引导了',
        '不用引导'
      ],
      this.autoAnswerAtEnd = true,
      this.showProgress = true,
      this.contextStrategy = ContextStrategy.full})
      : _answerTriggerKeywords = answerTriggerKeywords;

  factory _$LearningSessionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningSessionConfigImplFromJson(json);

  /// 默认最大轮次
  @override
  @JsonKey()
  final int defaultMaxRounds;

  /// 自动结束关键词
  final List<String> _answerTriggerKeywords;

  /// 自动结束关键词
  @override
  @JsonKey()
  List<String> get answerTriggerKeywords {
    if (_answerTriggerKeywords is EqualUnmodifiableListView)
      return _answerTriggerKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answerTriggerKeywords);
  }

  /// 是否在最后一轮自动给出答案
  @override
  @JsonKey()
  final bool autoAnswerAtEnd;

  /// 是否显示学习进度
  @override
  @JsonKey()
  final bool showProgress;

  /// 上下文保持策略
  @override
  @JsonKey()
  final ContextStrategy contextStrategy;

  @override
  String toString() {
    return 'LearningSessionConfig(defaultMaxRounds: $defaultMaxRounds, answerTriggerKeywords: $answerTriggerKeywords, autoAnswerAtEnd: $autoAnswerAtEnd, showProgress: $showProgress, contextStrategy: $contextStrategy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningSessionConfigImpl &&
            (identical(other.defaultMaxRounds, defaultMaxRounds) ||
                other.defaultMaxRounds == defaultMaxRounds) &&
            const DeepCollectionEquality()
                .equals(other._answerTriggerKeywords, _answerTriggerKeywords) &&
            (identical(other.autoAnswerAtEnd, autoAnswerAtEnd) ||
                other.autoAnswerAtEnd == autoAnswerAtEnd) &&
            (identical(other.showProgress, showProgress) ||
                other.showProgress == showProgress) &&
            (identical(other.contextStrategy, contextStrategy) ||
                other.contextStrategy == contextStrategy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      defaultMaxRounds,
      const DeepCollectionEquality().hash(_answerTriggerKeywords),
      autoAnswerAtEnd,
      showProgress,
      contextStrategy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningSessionConfigImplCopyWith<_$LearningSessionConfigImpl>
      get copyWith => __$$LearningSessionConfigImplCopyWithImpl<
          _$LearningSessionConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningSessionConfigImplToJson(
      this,
    );
  }
}

abstract class _LearningSessionConfig implements LearningSessionConfig {
  const factory _LearningSessionConfig(
      {final int defaultMaxRounds,
      final List<String> answerTriggerKeywords,
      final bool autoAnswerAtEnd,
      final bool showProgress,
      final ContextStrategy contextStrategy}) = _$LearningSessionConfigImpl;

  factory _LearningSessionConfig.fromJson(Map<String, dynamic> json) =
      _$LearningSessionConfigImpl.fromJson;

  @override

  /// 默认最大轮次
  int get defaultMaxRounds;
  @override

  /// 自动结束关键词
  List<String> get answerTriggerKeywords;
  @override

  /// 是否在最后一轮自动给出答案
  bool get autoAnswerAtEnd;
  @override

  /// 是否显示学习进度
  bool get showProgress;
  @override

  /// 上下文保持策略
  ContextStrategy get contextStrategy;
  @override
  @JsonKey(ignore: true)
  _$$LearningSessionConfigImplCopyWith<_$LearningSessionConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}
