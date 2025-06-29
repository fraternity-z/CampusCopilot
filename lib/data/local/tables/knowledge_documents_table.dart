import 'package:drift/drift.dart';

/// 知识库文档表
/// 
/// 存储上传到知识库的文档信息
@DataClassName('KnowledgeDocumentsTableData')
class KnowledgeDocumentsTable extends Table {
  /// 文档唯一标识符
  TextColumn get id => text()();
  
  /// 文档名称
  TextColumn get name => text()();
  
  /// 文档类型 (pdf, txt, md, docx, etc.)
  TextColumn get type => text()();
  
  /// 文件大小（字节）
  IntColumn get size => integer()();
  
  /// 文档路径
  TextColumn get filePath => text()();
  
  /// 文档哈希值（用于去重）
  TextColumn get fileHash => text()();
  
  /// 文本块数量
  IntColumn get chunks => integer().withDefault(const Constant(0))();
  
  /// 处理状态 (pending, processing, completed, failed)
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// 索引进度 (0.0 - 1.0)
  RealColumn get indexProgress => real().withDefault(const Constant(0.0))();
  
  /// 上传时间
  DateTimeColumn get uploadedAt => dateTime()();
  
  /// 最后处理时间
  DateTimeColumn get processedAt => dateTime().nullable()();
  
  /// 文档元数据（JSON格式）
  TextColumn get metadata => text().nullable()();
  
  /// 错误信息（如果处理失败）
  TextColumn get errorMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
