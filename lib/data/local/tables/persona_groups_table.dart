import 'package:drift/drift.dart';

/// 助手分组表
///
/// 存储用户定义的智能体（助手）分组信息
@DataClassName('PersonaGroupsTableData')
class PersonaGroupsTable extends Table {
  /// 分组唯一ID
  TextColumn get id => text()();

  /// 分组名称
  TextColumn get name => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
