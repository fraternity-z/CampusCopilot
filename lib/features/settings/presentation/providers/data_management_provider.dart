import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/database_providers.dart';

/// 数据统计信息
class DataStatistics {
  final int chatCount;
  final int messageCount;
  final int personaCount;
  final int knowledgeCount;

  DataStatistics({
    required this.chatCount,
    required this.messageCount,
    required this.personaCount,
    required this.knowledgeCount,
  });
}

/// 数据统计Provider
final dataStatisticsProvider = FutureProvider<DataStatistics>((ref) async {
  final db = ref.watch(appDatabaseProvider);

  final chatCount = await db.getChatSessionCount();
  final messageCount = await db.getMessageCount();
  final personaCount = await db.getPersonaCount();
  final knowledgeCount = await db.getKnowledgeDocumentCount();

  return DataStatistics(
    chatCount: chatCount,
    messageCount: messageCount,
    personaCount: personaCount,
    knowledgeCount: knowledgeCount,
  );
});
