import 'package:uuid/uuid.dart';
import '../entities/learning_session.dart';
import 'learning_prompt_service.dart';

/// 学习会话服务
/// 
/// 负责管理学习会话的生命周期，包括创建、更新、结束会话，
/// 以及生成对应的学习提示词
class LearningSessionService {
  static const _uuid = Uuid();

  /// 创建新的学习会话
  static LearningSession createSession({
    required String initialQuestion,
    int? maxRounds,
  }) {
    return LearningSession(
      sessionId: _uuid.v4(),
      initialQuestion: initialQuestion,
      maxRounds: maxRounds ?? 8,
      startTime: DateTime.now(),
    );
  }

  /// 检查是否应该触发直接答案
  static bool shouldTriggerDirectAnswer(
    String userMessage,
    List<String> triggerKeywords,
  ) {
    final messageLower = userMessage.toLowerCase();
    return triggerKeywords.any((keyword) => 
        messageLower.contains(keyword.toLowerCase()));
  }

  /// 检查会话是否应该结束
  static bool shouldEndSession(LearningSession session, String? userMessage, [List<String>? triggerKeywords]) {
    // 达到最大轮次
    if (session.currentRound >= session.maxRounds) {
      return true;
    }
    
    // 用户主动要求答案
    if (userMessage != null && shouldTriggerDirectAnswer(
        userMessage, 
        triggerKeywords ?? _getDefaultTriggerKeywords()
    )) {
      return true;
    }
    
    return false;
  }

  /// 推进会话到下一轮
  static LearningSession advanceSession(
    LearningSession session, 
    String messageId,
  ) {
    return session.copyWith(
      currentRound: session.currentRound + 1,
      messageIds: [...session.messageIds, messageId],
    );
  }

  /// 标记用户要求答案
  static LearningSession markUserRequestedAnswer(LearningSession session) {
    return session.copyWith(
      userRequestedAnswer: true,
      status: LearningSessionStatus.terminated,
    );
  }

  /// 完成会话
  static LearningSession completeSession(LearningSession session) {
    return session.copyWith(
      status: LearningSessionStatus.completed,
    );
  }

  /// 构建学习会话的系统提示词
  static String buildSessionSystemPrompt({
    required LearningSession session,
    required dynamic learningModeState,
  }) {
    final basePrompt = LearningPromptService.buildLearningSystemPrompt(
      style: learningModeState.style,
      responseDetail: learningModeState.responseDetail,
      questionStep: session.currentRound - 1,
      maxSteps: session.maxRounds,
    );

    final sessionContext = _buildSessionContext(session);
    final roundGuidance = _buildRoundGuidance(session);

    return '''$basePrompt

$sessionContext

$roundGuidance

请严格按照学习会话的引导原则进行回应。''';
  }

  /// 构建会话上下文信息
  static String _buildSessionContext(LearningSession session) {
    final isLastRound = session.currentRound >= session.maxRounds;
    
    return '''
===== 学习会话信息 =====
初始问题：${session.initialQuestion}
当前进度：第 ${session.currentRound} 轮（共 ${session.maxRounds} 轮）
会话状态：${_getStatusDescription(session.status)}
${isLastRound ? '⚠️ 这是最后一轮，需要给出完整答案！' : ''}
''';
  }

  /// 构建轮次引导
  static String _buildRoundGuidance(LearningSession session) {
    final isLastRound = session.currentRound >= session.maxRounds;
    final isFirstRound = session.currentRound == 1;

    if (isFirstRound) {
      return '''
===== 第一轮引导 =====
- 这是学习会话的开始，了解学生的基础水平
- 通过开放性问题引导学生思考问题的关键点  
- 不要给出答案，重点在于启发和引导
- 帮助学生分析问题的结构和要素
''';
    } else if (isLastRound || session.userRequestedAnswer) {
      return '''
===== 最终轮次 - 给出完整答案 =====
- 现在应该提供完整、详细的答案
- 总结整个学习过程中的关键思路
- 解释为什么之前的引导步骤是必要的
- 确保学生对完整解决方案有清晰理解
- 可以适当总结学习要点和方法
''';
    } else {
      final remainingRounds = session.maxRounds - session.currentRound;
      return '''
===== 中间轮次引导 =====
- 基于学生之前的回答，继续深入引导
- 还有 $remainingRounds 轮机会，逐步推进到答案
- 保持苏格拉底式提问，让学生自己发现
- 根据学生的理解程度调整引导深度
''';
    }
  }

  /// 获取状态描述
  static String _getStatusDescription(LearningSessionStatus status) {
    switch (status) {
      case LearningSessionStatus.active:
        return '学习进行中';
      case LearningSessionStatus.completed:
        return '学习完成';
      case LearningSessionStatus.terminated:
        return '用户要求答案';
      case LearningSessionStatus.paused:
        return '暂停中';
    }
  }

  /// 获取默认触发关键词
  static List<String> _getDefaultTriggerKeywords() {
    return [
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
    ];
  }

  /// 检查消息是否包含学习相关的问题
  static bool isLearningQuestion(String message) {
    // 在学习模式下，任何非空消息都应该能触发学习会话
    // 这样用户不需要特定格式就能开始学习
    return message.trim().isNotEmpty;
  }

  /// 包装用户消息为学习会话格式
  static String wrapUserMessageForSession({
    required String originalMessage,
    required LearningSession session,
    required dynamic learningModeState,
  }) {
    final sessionInfo = '''
[学习会话 ${session.sessionId.substring(0, 8)}]
当前轮次：${session.currentRound}/${session.maxRounds}
初始问题：${session.initialQuestion}
''';

    final userInput = '''
学生回应：$originalMessage
''';

    // 检查是否要求直接答案
    final isRequestingAnswer = shouldTriggerDirectAnswer(
      originalMessage, 
      _getDefaultTriggerKeywords()
    );

    final instruction = isRequestingAnswer
        ? '学生要求直接给出答案，请提供完整解答。'
        : '请继续引导学生思考，不要直接给出答案。';

    return '''$sessionInfo

$userInput

$instruction''';
  }
}