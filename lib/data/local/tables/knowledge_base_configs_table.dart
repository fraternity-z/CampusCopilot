import 'package:drift/drift.dart';

/// 知识库配置表
///
/// 存储知识库的配置信息，包括嵌入模型、分块参数等
@DataClassName('KnowledgeBaseConfigsTableData')
class KnowledgeBaseConfigsTable extends Table {
  /// 配置唯一标识符
  TextColumn get id => text()();

  /// 配置名称
  TextColumn get name => text()();

  /// 嵌入模型ID
  TextColumn get embeddingModelId => text()();

  /// 嵌入模型名称
  TextColumn get embeddingModelName => text()();

  /// 嵌入模型提供商
  TextColumn get embeddingModelProvider => text()();

  /// 分块大小
  IntColumn get chunkSize => integer().withDefault(const Constant(1000))();

  /// 分块重叠
  IntColumn get chunkOverlap => integer().withDefault(const Constant(200))();

  /// 最大检索结果数
  IntColumn get maxRetrievedChunks =>
      integer().withDefault(const Constant(5))();

  /// 相似度阈值
  RealColumn get similarityThreshold =>
      real().withDefault(const Constant(0.3))(); // 降低默认阈值，提高召回率

  /// 是否为默认配置
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
