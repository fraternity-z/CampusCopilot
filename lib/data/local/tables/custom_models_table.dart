import 'package:drift/drift.dart';

/// 自定义模型表
///
/// 存储用户自定义的模型信息
@DataClassName('CustomModelsTableData')
class CustomModelsTable extends Table {
  /// 模型唯一标识符
  TextColumn get id => text()();

  /// 模型名称
  TextColumn get name => text()();

  /// 模型ID（API调用时使用）
  TextColumn get modelId => text()();

  /// 所属 LLM 配置 ID（llm_configs_table.id）
  /// 为空表示旧数据或与具体配置无关
  TextColumn get configId => text().nullable()();

  /// 所属提供商 (openai, google, anthropic)
  TextColumn get provider => text()();

  /// 模型描述
  TextColumn get description => text().nullable()();

  /// 模型类型 (chat, embedding, multimodal)
  TextColumn get type => text()();

  /// 上下文窗口大小
  IntColumn get contextWindow => integer().nullable()();

  /// 最大输出token数
  IntColumn get maxOutputTokens => integer().nullable()();

  /// 是否支持流式响应
  BoolColumn get supportsStreaming =>
      boolean().withDefault(const Constant(true))();

  /// 是否支持函数调用
  BoolColumn get supportsFunctionCalling =>
      boolean().withDefault(const Constant(false))();

  /// 是否支持视觉输入
  BoolColumn get supportsVision =>
      boolean().withDefault(const Constant(false))();

  /// 输入token价格（每1K token）
  RealColumn get inputPrice => real().nullable()();

  /// 输出token价格（每1K token）
  RealColumn get outputPrice => real().nullable()();

  /// 货币单位
  TextColumn get currency => text().withDefault(const Constant('USD'))();

  /// 模型能力标签（JSON格式）
  TextColumn get capabilities => text().nullable()();

  /// 是否为内置模型
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();

  /// 是否启用
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
