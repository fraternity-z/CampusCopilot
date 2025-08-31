import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_session.freezed.dart';
part 'learning_session.g.dart';

/// 学习会话状态
@freezed
class LearningSession with _$LearningSession {
  const factory LearningSession({
    /// 会话ID
    required String sessionId,
    
    /// 初始问题
    required String initialQuestion,
    
    /// 当前轮次 (从1开始)
    @Default(1) int currentRound,
    
    /// 最大轮次
    @Default(8) int maxRounds,
    
    /// 会话状态
    @Default(LearningSessionStatus.active) LearningSessionStatus status,
    
    /// 会话开始时间
    required DateTime startTime,
    
    /// 会话消息ID列表（用于跟踪完整上下文）
    @Default([]) List<String> messageIds,
    
    /// 是否用户主动要求答案
    @Default(false) bool userRequestedAnswer,
    
    /// 会话元数据
    Map<String, dynamic>? metadata,
  }) = _LearningSession;

  factory LearningSession.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionFromJson(json);
}

/// 学习会话状态枚举
@JsonEnum()
enum LearningSessionStatus {
  /// 活跃中
  @JsonValue('active')
  active,
  
  /// 已完成（达到最大轮次）
  @JsonValue('completed')
  completed,
  
  /// 用户终止
  @JsonValue('terminated')
  terminated,
  
  /// 暂停
  @JsonValue('paused')
  paused;
}

/// 学习会话配置
@freezed
class LearningSessionConfig with _$LearningSessionConfig {
  const factory LearningSessionConfig({
    /// 默认最大轮次
    @Default(8) int defaultMaxRounds,
    
    /// 自动结束关键词
    @Default([
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
      '不用引导',
    ]) List<String> answerTriggerKeywords,
    
    /// 是否在最后一轮自动给出答案
    @Default(true) bool autoAnswerAtEnd,
    
    /// 是否显示学习进度
    @Default(true) bool showProgress,
    
    /// 上下文保持策略
    @Default(ContextStrategy.full) ContextStrategy contextStrategy,
  }) = _LearningSessionConfig;

  factory LearningSessionConfig.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionConfigFromJson(json);
}

/// 上下文保持策略
@JsonEnum()
enum ContextStrategy {
  /// 完整上下文
  @JsonValue('full')
  full,
  
  /// 滑动窗口
  @JsonValue('sliding')
  sliding,
  
  /// 关键轮次
  @JsonValue('key_rounds')
  keyRounds;
}