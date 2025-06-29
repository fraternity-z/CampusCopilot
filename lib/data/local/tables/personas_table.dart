import 'package:drift/drift.dart';

/// 智能体表
/// 
/// 存储AI智能体的配置和信息
@DataClassName('PersonasTableData')
class PersonasTable extends Table {
  /// 智能体唯一标识符
  TextColumn get id => text()();
  
  /// 智能体名称
  TextColumn get name => text()();
  
  /// 智能体描述
  TextColumn get description => text()();
  
  /// 系统提示词
  TextColumn get systemPrompt => text()();
  
  /// 关联的API配置ID
  TextColumn get apiConfigId => text()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();
  
  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();
  
  /// 最后使用时间
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  
  /// 智能体类型/分类
  TextColumn get category => text().withDefault(const Constant('assistant'))();
  
  /// 智能体标签（JSON数组格式）
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  
  /// 智能体头像/图标URL
  TextColumn get avatar => text().nullable()();
  
  /// 是否为默认智能体
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  
  /// 是否启用
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  
  /// 使用次数统计
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  
  /// 智能体配置（JSON格式）
  TextColumn get config => text().nullable()();
  
  /// 智能体能力列表（JSON格式）
  TextColumn get capabilities => text().withDefault(const Constant('[]'))();
  
  /// 元数据（JSON格式）
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
