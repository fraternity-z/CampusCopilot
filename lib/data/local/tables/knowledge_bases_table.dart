import 'package:drift/drift.dart';

/// 知识库表
///
/// 存储多个知识库实例的信息
@DataClassName('KnowledgeBasesTableData')
class KnowledgeBasesTable extends Table {
  /// 知识库唯一标识符
  TextColumn get id => text()();

  /// 知识库名称
  TextColumn get name => text()();

  /// 知识库描述
  TextColumn get description => text().nullable()();

  /// 知识库图标（可选）
  TextColumn get icon => text().nullable()();

  /// 知识库颜色（可选）
  TextColumn get color => text().nullable()();

  /// 关联的配置ID（引用knowledge_base_configs_table.id）
  TextColumn get configId => text()();

  /// 文档数量
  IntColumn get documentCount => integer().withDefault(const Constant(0))();

  /// 文本块数量
  IntColumn get chunkCount => integer().withDefault(const Constant(0))();

  /// 是否为默认知识库
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// 是否启用
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime()();

  /// 最后使用时间
  DateTimeColumn get lastUsedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
