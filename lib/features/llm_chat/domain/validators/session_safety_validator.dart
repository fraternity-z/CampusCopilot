import 'package:flutter/foundation.dart';
import '../entities/chat_session.dart';
import '../usecases/chat_service.dart';

/// 会话安全验证器
/// 
/// 负责检查会话状态的安全性，确保在发送消息前会话处于有效状态
/// 采用独立模块设计，保持与现有代码的低耦合性
class SessionSafetyValidator {
  final ChatService _chatService;
  
  SessionSafetyValidator(this._chatService);
  
  /// 验证会话安全性并自动修复
  /// 
  /// [currentSession] 当前会话对象
  /// [availableSessions] 可用的会话列表
  /// 
  /// 返回验证结果，包含是否安全、修复后的会话、错误信息
  Future<SessionValidationResult> validateAndFixSession({
    ChatSession? currentSession,
    required List<ChatSession> availableSessions,
  }) async {
    try {
      // 1. 检查当前会话是否存在
      if (currentSession == null) {
        debugPrint('🛡️ 会话安全检查: 当前会话为null，尝试自动修复');
        return await _handleNullSession(availableSessions);
      }
      
      // 2. 检查当前会话是否在可用会话列表中
      final sessionExists = availableSessions.any((s) => s.id == currentSession.id);
      if (!sessionExists) {
        debugPrint('🛡️ 会话安全检查: 当前会话不在可用列表中，会话ID: ${currentSession.id}');
        return await _handleInvalidSession(currentSession, availableSessions);
      }
      
      // 3. 检查会话是否被归档或删除
      if (currentSession.isArchived) {
        debugPrint('🛡️ 会话安全检查: 当前会话已归档，尝试选择其他会话');
        return await _handleArchivedSession(currentSession, availableSessions);
      }
      
      // 4. 验证会话在数据库中是否真实存在
      final isValidInDb = await _validateSessionInDatabase(currentSession.id);
      if (!isValidInDb) {
        debugPrint('🛡️ 会话安全检查: 当前会话在数据库中不存在，会话ID: ${currentSession.id}');
        return await _handleDatabaseMismatch(currentSession, availableSessions);
      }
      
      // 所有检查通过
      debugPrint('🛡️ 会话安全检查: 当前会话安全有效，会话ID: ${currentSession.id}');
      return SessionValidationResult.success(currentSession);
      
    } catch (e) {
      debugPrint('🛡️ 会话安全检查: 验证过程出错: $e');
      return SessionValidationResult.error('会话安全验证失败: $e');
    }
  }
  
  /// 处理null会话的情况
  Future<SessionValidationResult> _handleNullSession(List<ChatSession> availableSessions) async {
    // 如果有可用会话，选择最新的一个
    if (availableSessions.isNotEmpty) {
      final latestSession = availableSessions.first; // 假设列表已按时间排序
      debugPrint('🛡️ 会话修复: 选择最新的可用会话，会话ID: ${latestSession.id}');
      return SessionValidationResult.recovered(latestSession, '已自动选择最新的会话');
    }
    
    // 如果没有可用会话，创建新会话
    try {
      final newSession = await _chatService.createChatSession(
        personaId: 'default', 
        title: '新对话'
      );
      debugPrint('🛡️ 会话修复: 创建新会话成功，会话ID: ${newSession.id}');
      return SessionValidationResult.recovered(newSession, '已自动创建新会话');
    } catch (e) {
      debugPrint('🛡️ 会话修复: 创建新会话失败: $e');
      return SessionValidationResult.error('无法创建新会话: $e');
    }
  }
  
  /// 处理无效会话的情况
  Future<SessionValidationResult> _handleInvalidSession(
    ChatSession currentSession, 
    List<ChatSession> availableSessions
  ) async {
    // 尝试从可用会话中找到替代会话
    if (availableSessions.isNotEmpty) {
      final replacementSession = availableSessions.first;
      debugPrint('🛡️ 会话修复: 替换无效会话，从 ${currentSession.id} 到 ${replacementSession.id}');
      return SessionValidationResult.recovered(
        replacementSession, 
        '当前会话已失效，已切换到其他可用会话'
      );
    }
    
    // 如果没有可用会话，创建新会话
    return await _handleNullSession(availableSessions);
  }
  
  /// 处理已归档会话的情况
  Future<SessionValidationResult> _handleArchivedSession(
    ChatSession archivedSession,
    List<ChatSession> availableSessions
  ) async {
    // 查找未归档的会话
    final activeSession = availableSessions.where((s) => !s.isArchived).firstOrNull;
    if (activeSession != null) {
      debugPrint('🛡️ 会话修复: 切换到活跃会话，会话ID: ${activeSession.id}');
      return SessionValidationResult.recovered(
        activeSession,
        '当前会话已归档，已切换到活跃会话'
      );
    }
    
    // 如果没有活跃会话，创建新会话
    return await _handleNullSession([]);
  }
  
  /// 处理数据库不匹配的情况
  Future<SessionValidationResult> _handleDatabaseMismatch(
    ChatSession currentSession,
    List<ChatSession> availableSessions
  ) async {
    // 尝试重新加载会话列表，可能是缓存问题
    // 这里假设传入的availableSessions是最新的，直接选择替代会话
    return await _handleInvalidSession(currentSession, availableSessions);
  }
  
  /// 验证会话在数据库中是否存在
  Future<bool> _validateSessionInDatabase(String sessionId) async {
    try {
      final sessions = await _chatService.getChatSessions();
      return sessions.any((s) => s.id == sessionId);
    } catch (e) {
      debugPrint('🛡️ 数据库验证失败: $e');
      return false; // 谨慎起见，验证失败时返回false
    }
  }
}

/// 会话验证结果
class SessionValidationResult {
  final bool isValid;
  final bool isRecovered;
  final ChatSession? session;
  final String? message;
  final String? error;
  
  const SessionValidationResult._({
    required this.isValid,
    required this.isRecovered,
    this.session,
    this.message,
    this.error,
  });
  
  /// 创建成功结果
  factory SessionValidationResult.success(ChatSession session) {
    return SessionValidationResult._(
      isValid: true,
      isRecovered: false,
      session: session,
    );
  }
  
  /// 创建恢复结果
  factory SessionValidationResult.recovered(ChatSession session, String message) {
    return SessionValidationResult._(
      isValid: true,
      isRecovered: true,
      session: session,
      message: message,
    );
  }
  
  /// 创建错误结果
  factory SessionValidationResult.error(String error) {
    return SessionValidationResult._(
      isValid: false,
      isRecovered: false,
      error: error,
    );
  }
  
  /// 是否需要更新UI状态
  bool get needsStateUpdate => isRecovered || !isValid;
  
  @override
  String toString() {
    if (error != null) return 'SessionValidationResult.error($error)';
    if (isRecovered) return 'SessionValidationResult.recovered(${session?.id}, $message)';
    return 'SessionValidationResult.success(${session?.id})';
  }
}

/// 扩展方法，为列表添加安全的first方法
extension SafeFirst<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
