import 'chat_message.dart';
import 'chat_session.dart';
import 'chat_message_defaults.dart';

/// 批量操作工具类
/// 
/// 提供高性能的批量操作方法，减少重复的时间创建和列表操作
class BatchOperations {
  // 私有构造函数，防止实例化
  BatchOperations._();

  /// 批量获取消息显示时间
  /// 
  /// 使用单一时间戳为所有消息计算显示时间，提高性能
  static Map<String, String> getDisplayTimes(List<ChatMessage> messages) {
    if (messages.isEmpty) return {};
    
    final now = TimeCache.now();
    final result = <String, String>{};
    
    for (final message in messages) {
      result[message.id] = message.getDisplayTime(now);
    }
    
    return result;
  }

  /// 批量获取会话活动时间描述
  /// 
  /// 使用单一时间戳为所有会话计算活动时间，提高性能
  static Map<String, String> getLastActivityDescriptions(List<ChatSession> sessions) {
    if (sessions.isEmpty) return {};
    
    final now = TimeCache.now();
    final result = <String, String>{};
    
    for (final session in sessions) {
      result[session.id] = session.getLastActivityDescription(now);
    }
    
    return result;
  }

  /// 批量创建用户消息
  /// 
  /// 使用单一时间戳创建多条消息，提高性能
  static List<ChatMessage> createUserMessages({
    required List<String> contents,
    required String chatSessionId,
    String? parentMessageId,
  }) {
    if (contents.isEmpty) return [];
    
    final now = TimeCache.now();
    final result = <ChatMessage>[];
    
    for (int i = 0; i < contents.length; i++) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch + i, // 确保每条消息有唯一时间戳
      );
      
      result.add(ChatMessageFactory.createUserMessage(
        content: contents[i],
        chatSessionId: chatSessionId,
        parentMessageId: parentMessageId,
        timestamp: timestamp,
      ));
    }
    
    return result;
  }

  /// 批量更新会话标题
  /// 
  /// 使用单一时间戳更新多个会话，提高性能
  static List<ChatSession> updateSessionTitles({
    required List<ChatSession> sessions,
    required Map<String, String> titleUpdates,
  }) {
    if (sessions.isEmpty || titleUpdates.isEmpty) return sessions;
    
    final now = TimeCache.now();
    final result = <ChatSession>[];
    
    for (final session in sessions) {
      final newTitle = titleUpdates[session.id];
      if (newTitle != null) {
        result.add(session.updateTitle(newTitle, now));
      } else {
        result.add(session);
      }
    }
    
    return result;
  }

  /// 批量归档会话
  /// 
  /// 使用单一时间戳归档多个会话，提高性能
  static List<ChatSession> archiveSessions({
    required List<ChatSession> sessions,
    required List<String> sessionIds,
  }) {
    if (sessions.isEmpty || sessionIds.isEmpty) return sessions;
    
    final now = TimeCache.now();
    final idsToArchive = Set<String>.from(sessionIds);
    
    return sessions.map((session) {
      return idsToArchive.contains(session.id) 
          ? session.archive(now)
          : session;
    }).toList();
  }

  /// 批量取消归档会话
  /// 
  /// 使用单一时间戳取消归档多个会话，提高性能
  static List<ChatSession> unarchiveSessions({
    required List<ChatSession> sessions,
    required List<String> sessionIds,
  }) {
    if (sessions.isEmpty || sessionIds.isEmpty) return sessions;
    
    final now = TimeCache.now();
    final idsToUnarchive = Set<String>.from(sessionIds);
    
    return sessions.map((session) {
      return idsToUnarchive.contains(session.id) 
          ? session.unarchive(now)
          : session;
    }).toList();
  }

  /// 批量添加标签到会话
  /// 
  /// 高效地为多个会话添加标签
  static List<ChatSession> addTagsToSessions({
    required List<ChatSession> sessions,
    required Map<String, List<String>> sessionTags,
  }) {
    if (sessions.isEmpty || sessionTags.isEmpty) return sessions;
    
    final now = TimeCache.now();
    
    return sessions.map((session) {
      final tagsToAdd = sessionTags[session.id];
      if (tagsToAdd != null && tagsToAdd.isNotEmpty) {
        return session.addTags(tagsToAdd, now);
      }
      return session;
    }).toList();
  }

  /// 批量过滤消息
  /// 
  /// 高效地过滤消息列表，支持多种条件
  static List<ChatMessage> filterMessages({
    required List<ChatMessage> messages,
    bool? isFromUser,
    MessageType? type,
    MessageStatus? status,
    DateTime? afterDate,
    DateTime? beforeDate,
    List<String>? sessionIds,
  }) {
    if (messages.isEmpty) return [];
    
    return messages.where((message) {
      // 用户过滤
      if (isFromUser != null && message.isFromUser != isFromUser) {
        return false;
      }
      
      // 类型过滤
      if (type != null && message.type != type) {
        return false;
      }
      
      // 状态过滤
      if (status != null && message.status != status) {
        return false;
      }
      
      // 时间范围过滤
      if (afterDate != null && message.timestamp.isBefore(afterDate)) {
        return false;
      }
      
      if (beforeDate != null && message.timestamp.isAfter(beforeDate)) {
        return false;
      }
      
      // 会话ID过滤
      if (sessionIds != null && !sessionIds.contains(message.chatSessionId)) {
        return false;
      }
      
      return true;
    }).toList();
  }

  /// 批量统计消息
  /// 
  /// 高效地统计消息的各种指标
  static Map<String, dynamic> getMessageStatistics(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return {
        'total': 0,
        'userMessages': 0,
        'aiMessages': 0,
        'systemMessages': 0,
        'errorMessages': 0,
        'imageMessages': 0,
        'totalTokens': 0,
        'averageTokens': 0.0,
      };
    }
    
    int userMessages = 0;
    int aiMessages = 0;
    int systemMessages = 0;
    int errorMessages = 0;
    int imageMessages = 0;
    int totalTokens = 0;
    int messagesWithTokens = 0;
    
    for (final message in messages) {
      if (message.isFromUser) {
        userMessages++;
      } else {
        aiMessages++;
      }
      
      switch (message.type) {
        case MessageType.system:
          systemMessages++;
          break;
        case MessageType.error:
          errorMessages++;
          break;
        case MessageType.image:
          imageMessages++;
          break;
        default:
          break;
      }
      
      if (message.tokenCount != null) {
        totalTokens += message.tokenCount!;
        messagesWithTokens++;
      }
    }
    
    return {
      'total': messages.length,
      'userMessages': userMessages,
      'aiMessages': aiMessages,
      'systemMessages': systemMessages,
      'errorMessages': errorMessages,
      'imageMessages': imageMessages,
      'totalTokens': totalTokens,
      'averageTokens': messagesWithTokens > 0 ? totalTokens / messagesWithTokens : 0.0,
    };
  }
}
