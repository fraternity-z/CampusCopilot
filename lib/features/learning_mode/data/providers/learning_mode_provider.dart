import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../domain/entities/learning_mode_state.dart';
import '../../domain/entities/learning_session.dart';
import '../../domain/services/learning_prompt_service.dart';
import '../../domain/services/learning_session_service.dart';

part 'learning_mode_provider.g.dart';

/// 学习模式状态Provider
@Riverpod(keepAlive: true)
class LearningModeNotifier extends _$LearningModeNotifier {
  static const String _storageKey = 'learning_mode_state';

  @override
  LearningModeState build() {
    // 从本地存储加载状态
    _loadFromStorage();
    
    return const LearningModeState();
  }

  /// 切换学习模式
  Future<void> toggleLearningMode() async {
    state = state.copyWith(
      isLearningMode: !state.isLearningMode,
      questionStep: 0, // 重置提问步骤
      hintHistory: [], // 清空提示历史
    );
    await _saveToStorage();
  }

  /// 设置学习风格
  Future<void> setLearningStyle(LearningStyle style) async {
    state = state.copyWith(
      style: style,
      questionStep: 0, // 重置提问步骤
      hintHistory: [], // 清空提示历史  
    );
    await _saveToStorage();
  }

  /// 设置回答详细程度
  Future<void> setResponseDetail(ResponseDetail detail) async {
    state = state.copyWith(responseDetail: detail);
    await _saveToStorage();
  }

  /// 增加提问步骤
  void incrementQuestionStep() {
    if (state.questionStep < state.maxQuestionSteps) {
      state = state.copyWith(questionStep: state.questionStep + 1);
    }
  }

  /// 重置提问步骤
  void resetQuestionStep() {
    state = state.copyWith(
      questionStep: 0,
      hintHistory: [],
    );
  }

  /// 添加提示到历史记录
  void addToHintHistory(String hint) {
    final newHistory = [...state.hintHistory, hint];
    // 限制历史记录长度，避免提示词过长
    if (newHistory.length > 10) {
      newHistory.removeAt(0);
    }
    state = state.copyWith(hintHistory: newHistory);
  }

  /// 切换学习提示显示
  Future<void> toggleShowLearningHints() async {
    state = state.copyWith(showLearningHints: !state.showLearningHints);
    await _saveToStorage();
  }

  /// 设置最大提问步骤数
  Future<void> setMaxQuestionSteps(int maxSteps) async {
    if (maxSteps >= 1 && maxSteps <= 10) {
      state = state.copyWith(maxQuestionSteps: maxSteps);
      await _saveToStorage();
    }
  }

  // ===== 学习会话管理方法 =====

  /// 开始新的学习会话
  void startLearningSession(String initialQuestion, {int? maxRounds}) {
    if (state.isLearningMode) {
      final session = LearningSessionService.createSession(
        initialQuestion: initialQuestion,
        maxRounds: maxRounds ?? state.sessionConfig.defaultMaxRounds,
      );
      
      state = state.copyWith(
        currentSession: session,
        questionStep: 0, // 重置步骤计数
      );
      
      debugPrint('🎓 开始学习会话: ${session.sessionId.substring(0, 8)}, 问题: $initialQuestion');
    }
  }

  /// 推进学习会话
  void advanceLearningSession(String messageId) {
    final currentSession = state.currentSession;
    if (currentSession != null) {
      final updatedSession = LearningSessionService.advanceSession(
        currentSession, 
        messageId,
      );
      
      state = state.copyWith(currentSession: updatedSession);
      debugPrint('🎓 会话推进到第 ${updatedSession.currentRound} 轮');
    }
  }

  /// 检查是否应该结束会话
  bool shouldEndCurrentSession(String? userMessage) {
    final currentSession = state.currentSession;
    if (currentSession == null) return false;
    
    return LearningSessionService.shouldEndSession(
      currentSession, 
      userMessage, 
      state.sessionConfig.answerTriggerKeywords,
    );
  }

  /// 更新当前学习会话
  void updateCurrentSession(LearningSession session) {
    state = state.copyWith(currentSession: session);
  }

  /// 结束当前学习会话
  void endCurrentSession({bool userRequested = false}) {
    final currentSession = state.currentSession;
    if (currentSession != null) {
      final endedSession = userRequested
          ? LearningSessionService.markUserRequestedAnswer(currentSession)
          : LearningSessionService.completeSession(currentSession);
          
      state = state.copyWith(currentSession: endedSession);
      
      debugPrint('🎓 学习会话结束: ${endedSession.status}');
      
      // 延迟清除会话状态
      Future.delayed(const Duration(seconds: 2), () {
        if (state.currentSession?.sessionId == endedSession.sessionId) {
          state = state.copyWith(currentSession: null);
        }
      });
    }
  }

  /// 检查是否在学习会话中
  bool get isInLearningSession => 
      state.isLearningMode && 
      state.currentSession != null && 
      state.currentSession!.status == LearningSessionStatus.active;

  /// 获取当前会话进度
  String? get currentSessionProgress {
    final session = state.currentSession;
    if (session == null) return null;
    
    return '${session.currentRound}/${session.maxRounds}';
  }

  /// 更新会话配置
  Future<void> updateSessionConfig(LearningSessionConfig config) async {
    state = state.copyWith(sessionConfig: config);
    await _saveToStorage();
  }

  /// 设置默认最大轮数
  Future<void> setDefaultMaxRounds(int maxRounds) async {
    if (maxRounds >= 3 && maxRounds <= 20) {
      final newConfig = state.sessionConfig.copyWith(defaultMaxRounds: maxRounds);
      await updateSessionConfig(newConfig);
    }
  }

  /// 获取当前的学习系统提示词
  String getCurrentSystemPrompt() {
    return LearningPromptService.buildLearningSystemPrompt(
      style: state.style,
      responseDetail: state.responseDetail,
      questionStep: state.questionStep,
      maxSteps: state.maxQuestionSteps,
    );
  }

  /// 包装用户消息为学习模式格式
  String wrapUserMessage(String originalMessage) {
    return LearningPromptService.wrapUserMessage(
      originalMessage,
      style: state.style,
      questionStep: state.questionStep,
      hintHistory: state.hintHistory,
    );
  }

  /// 检查是否应该显示学习提示
  bool shouldShowLearningHint() {
    return state.isLearningMode && 
           state.showLearningHints && 
           state.questionStep == 0;
  }

  /// 从本地存储加载状态
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString(_storageKey);
      
      if (stateJson != null) {
        final stateMap = json.decode(stateJson) as Map<String, dynamic>;
        state = LearningModeState.fromJson(stateMap);
      }
    } catch (e) {
      // 加载失败时使用默认状态
      debugPrint('Failed to load learning mode state: $e');
    }
  }

  /// 保存状态到本地存储
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = json.encode(state.toJson());
      await prefs.setString(_storageKey, stateJson);
    } catch (e) {
      debugPrint('Failed to save learning mode state: $e');
    }
  }
}

/// 学习模式配置Provider
@Riverpod(keepAlive: true)
class LearningModeConfigNotifier extends _$LearningModeConfigNotifier {
  static const String _configKey = 'learning_mode_config';

  @override
  LearningModeConfig build() {
    _loadFromStorage();
    return const LearningModeConfig();
  }

  /// 更新配置
  Future<void> updateConfig(LearningModeConfig newConfig) async {
    state = newConfig;
    await _saveToStorage();
  }

  /// 设置是否提供提示优先
  Future<void> setProvideHintsFirst(bool value) async {
    state = state.copyWith(provideHintsFirst: value);
    await _saveToStorage();
  }

  /// 设置是否允许直接答案
  Future<void> setAllowDirectAnswers(bool value) async {
    state = state.copyWith(allowDirectAnswers: value);
    await _saveToStorage();
  }

  /// 设置提示间隔时间
  Future<void> setHintInterval(int seconds) async {
    if (seconds >= 1 && seconds <= 60) {
      state = state.copyWith(hintInterval: seconds);
      await _saveToStorage();
    }
  }


  /// 从本地存储加载配置
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_configKey);
      
      if (configJson != null) {
        final configMap = json.decode(configJson) as Map<String, dynamic>;
        state = LearningModeConfig.fromJson(configMap);
      }
    } catch (e) {
      debugPrint('Failed to load learning mode config: $e');
    }
  }

  /// 保存配置到本地存储
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(state.toJson());
      await prefs.setString(_configKey, configJson);
    } catch (e) {
      debugPrint('Failed to save learning mode config: $e');
    }
  }
}

/// 快捷访问Provider
final learningModeProvider = learningModeNotifierProvider;
final learningModeConfigProvider = learningModeConfigNotifierProvider;