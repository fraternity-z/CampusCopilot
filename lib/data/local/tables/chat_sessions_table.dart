import 'package:drift/drift.dart';

/// 聊天会话表
/// 
/// 存储聊天会话的基本信息和配置
@DataClassName('ChatSessionsTableData')
class ChatSessionsTable extends Table {
  /// 会话唯一标识符
  TextColumn get id => text()();
  
  /// 会话标题
  TextColumn get title => text()();
  
  /// 关联的智能体ID
  TextColumn get personaId => text()();
  
  /// 会话创建时间
  DateTimeColumn get createdAt => dateTime()();
  
  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();
  
  /// 会话是否已归档
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  
  /// 会话是否置顶
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  
  /// 会话标签（JSON数组格式）
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  
  /// 消息总数
  IntColumn get messageCount => integer().withDefault(const Constant(0))();
  
  /// 总token使用量
  IntColumn get totalTokens => integer().withDefault(const Constant(0))();
  
  /// 会话配置（JSON格式）
  TextColumn get config => text().nullable()();
  
  /// 会话元数据（JSON格式）
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
