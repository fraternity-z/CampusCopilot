import 'package:drift/drift.dart';

/// 常规设置表
///
/// 存储应用的常规设置配置，包括话题自动命名等功能设置
@DataClassName('GeneralSettingsTableData')
class GeneralSettingsTable extends Table {
  /// 设置键名（主键）
  TextColumn get key => text()();

  /// 设置值（JSON字符串）
  TextColumn get value => text()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

/// 常规设置键名常量
class GeneralSettingsKeys {
  /// 话题自动命名功能是否启用
  static const String autoTopicNamingEnabled = 'auto_topic_naming_enabled';

  /// 话题自动命名使用的模型ID
  static const String autoTopicNamingModelId = 'auto_topic_naming_model_id';
}
