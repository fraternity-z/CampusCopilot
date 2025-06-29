import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';

/// 数据库相关的Provider定义
///
/// 提供应用中所有数据库相关的依赖注入

/// 应用数据库Provider
///
/// 提供AppDatabase的单例实例
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// 数据库初始化Provider
///
/// 确保数据库在应用启动时正确初始化
final databaseInitProvider = FutureProvider<void>((ref) async {
  ref.read(appDatabaseProvider);

  // 这里可以添加数据库初始化逻辑
  // 例如：检查数据库版本、执行迁移等

  // 暂时不需要特殊的初始化逻辑，因为Drift会自动处理
  return;
});

/// 数据库健康检查Provider
///
/// 检查数据库连接状态和基本功能
final databaseHealthProvider = FutureProvider<bool>((ref) async {
  try {
    final database = ref.read(appDatabaseProvider);

    // 执行一个简单的查询来测试数据库连接
    await database.getAllLlmConfigs();

    return true;
  } catch (e) {
    // 数据库连接失败
    return false;
  }
});

/// 数据库统计信息Provider
///
/// 提供数据库中各种数据的统计信息
final databaseStatsProvider = FutureProvider<DatabaseStats>((ref) async {
  final database = ref.read(appDatabaseProvider);

  // 并行获取各种统计信息
  final results = await Future.wait([
    database.getAllLlmConfigs(),
    database.getAllPersonas(),
    database.getAllChatSessions(),
    database.getAllKnowledgeDocuments(),
  ]);

  return DatabaseStats(
    llmConfigsCount: results[0].length,
    personasCount: results[1].length,
    chatSessionsCount: results[2].length,
    knowledgeDocumentsCount: results[3].length,
  );
});

/// 数据库统计信息模型
class DatabaseStats {
  final int llmConfigsCount;
  final int personasCount;
  final int chatSessionsCount;
  final int knowledgeDocumentsCount;

  const DatabaseStats({
    required this.llmConfigsCount,
    required this.personasCount,
    required this.chatSessionsCount,
    required this.knowledgeDocumentsCount,
  });

  /// 总数据条目数
  int get totalCount =>
      llmConfigsCount +
      personasCount +
      chatSessionsCount +
      knowledgeDocumentsCount;

  @override
  String toString() {
    return 'DatabaseStats('
        'llmConfigs: $llmConfigsCount, '
        'personas: $personasCount, '
        'chatSessions: $chatSessionsCount, '
        'knowledgeDocs: $knowledgeDocumentsCount'
        ')';
  }
}
