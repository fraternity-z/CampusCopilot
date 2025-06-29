import 'package:drift/drift.dart';

/// 知识库文本块表
///
/// 存储文档的分块内容和向量索引
@DataClassName('KnowledgeChunksTableData')
class KnowledgeChunksTable extends Table {
  /// 文本块唯一标识符
  TextColumn get id => text()();

  /// 所属文档ID
  TextColumn get documentId => text()();

  /// 文本块内容
  TextColumn get content => text()();

  /// 文本块在文档中的序号
  IntColumn get chunkIndex => integer()();

  /// 文本块的字符数
  IntColumn get characterCount => integer()();

  /// 文本块的token数
  IntColumn get tokenCount => integer()();

  /// 嵌入向量（JSON格式存储）
  TextColumn get embedding => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
