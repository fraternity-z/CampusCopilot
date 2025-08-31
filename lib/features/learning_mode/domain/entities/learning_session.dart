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
      '我想直接知道答案',
      '我想知道答案',
      '直接给出答案',
      '请直接告诉我',
      '我要直接答案',
      '给我完整答案',
      '完整答案',
      '最终答案',
      '标准答案',
      '正确答案',
      '我不想引导',
      '不想步骤',
      '不要步骤',
      '省略步骤',
      '跳过步骤',
      '直接结果',
      '我要结果',
      '给我结果',
      '告诉我结果',
      '想直接知道',
      '直接知道',
      '想知道答案',
      '直接得到答案',
      '得到答案',
      '接得到答案',
      '想要直接答案',
      '要直接答案',
      '直接给答案',
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