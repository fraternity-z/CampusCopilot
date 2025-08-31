import 'package:freezed_annotation/freezed_annotation.dart';

import 'learning_session.dart';

part 'learning_mode_state.freezed.dart';
part 'learning_mode_state.g.dart';

/// 学习模式状态
@freezed
class LearningModeState with _$LearningModeState {
  const factory LearningModeState({
    /// 是否启用学习模式
    @Default(false) bool isLearningMode,
    
    /// 学习风格
    @Default(LearningStyle.guided) LearningStyle style,
    
    /// 提示历史记录（用于上下文连贯性）
    @Default([]) List<String> hintHistory,
    
    /// 回答详细程度
    @Default(ResponseDetail.normal) ResponseDetail responseDetail,
    
    /// 是否显示学习提示
    @Default(true) bool showLearningHints,
    
    /// 苏格拉底式提问步骤计数
    @Default(0) int questionStep,
    
    /// 最大提问步骤数
    @Default(5) int maxQuestionSteps,
    
    /// 当前学习会话
    LearningSession? currentSession,
    
    /// 学习会话配置
    @Default(LearningSessionConfig()) LearningSessionConfig sessionConfig,
  }) = _LearningModeState;

  factory LearningModeState.fromJson(Map<String, dynamic> json) =>
      _$LearningModeStateFromJson(json);
}

/// 回答详细程度枚举
@JsonEnum()
enum ResponseDetail {
  /// 粗略回答
  @JsonValue('brief')
  brief('粗略', '简单引导，关键提示'),
  
  /// 默认回答
  @JsonValue('normal')
  normal('默认', '适中引导，逐步提示'),
  
  /// 详细回答
  @JsonValue('detailed')
  detailed('详细', '深入引导，充分解释');

  const ResponseDetail(this.displayName, this.description);
  
  final String displayName;
  final String description;
}

/// 学习风格枚举
@JsonEnum()
enum LearningStyle {
  /// 引导式学习（苏格拉底式提问）
  @JsonValue('guided')
  guided('引导式', '通过提问引导学生思考，逐步发现答案'),
  
  /// 探索式学习（开放性问题）
  @JsonValue('exploratory') 
  exploratory('探索式', '鼓励学生自主探索，提供开放性问题'),
  
  /// 结构化学习（循序渐进）
  @JsonValue('structured')
  structured('结构化', '按照知识点结构，循序渐进地学习');

  const LearningStyle(this.displayName, this.description);
  
  final String displayName;
  final String description;
}

/// 学习模式配置
@freezed
class LearningModeConfig with _$LearningModeConfig {
  const factory LearningModeConfig({
    /// 是否在答案前提供提示
    @Default(true) bool provideHintsFirst,
    
    /// 是否允许直接给出答案
    @Default(false) bool allowDirectAnswers,
    
    /// 提示间隔时间（秒）
    @Default(5) int hintInterval,
    
    /// 自定义提示模板
    Map<String, String>? customPromptTemplates,
    
  }) = _LearningModeConfig;

  factory LearningModeConfig.fromJson(Map<String, dynamic> json) =>
      _$LearningModeConfigFromJson(json);
}

/// 学习提示类型
enum LearningHintType {
  /// 引导性提示
  guidance('让我们一起思考这个问题'),
  
  /// 鼓励性提示  
  encouragement('你的想法很有意思，继续思考'),
  
  /// 方向性提示
  direction('也许可以从另一个角度考虑'),
  
  /// 知识点提示
  knowledge('回忆一下相关的知识点');

  const LearningHintType(this.template);
  
  final String template;
}