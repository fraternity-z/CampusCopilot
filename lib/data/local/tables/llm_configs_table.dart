import 'package:drift/drift.dart';

/// LLM配置表
///
/// 存储AI供应商的API配置信息
@DataClassName('LlmConfigsTableData')
class LlmConfigsTable extends Table {
  /// 配置唯一标识符
  TextColumn get id => text()();

  /// 配置名称
  TextColumn get name => text()();

  /// 提供商类型 (openai, google, anthropic)
  TextColumn get provider => text()();

  /// API密钥
  TextColumn get apiKey => text()();

  /// 基础URL（可选，用于代理）
  TextColumn get baseUrl => text().nullable()();

  /// 默认聊天模型
  TextColumn get defaultModel => text().nullable()();

  /// 默认嵌入模型
  TextColumn get defaultEmbeddingModel => text().nullable()();

  /// 组织ID（OpenAI专用）
  TextColumn get organizationId => text().nullable()();

  /// 项目ID（某些供应商）
  TextColumn get projectId => text().nullable()();

  /// 额外配置参数（JSON格式）
  TextColumn get extraParams => text().nullable()();

  /// 创建时间
  DateTimeColumn get createdAt => dateTime()();

  /// 最后更新时间
  DateTimeColumn get updatedAt => dateTime()();

  /// 是否启用
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// 是否为自定义提供商
  BoolColumn get isCustomProvider =>
      boolean().withDefault(const Constant(false))();

  /// API兼容性类型 (openai, gemini, anthropic, custom)
  TextColumn get apiCompatibilityType =>
      text().withDefault(const Constant('openai'))();

  /// 自定义提供商显示名称
  TextColumn get customProviderName => text().nullable()();

  /// 自定义提供商描述
  TextColumn get customProviderDescription => text().nullable()();

  /// 自定义提供商图标（可选）
  TextColumn get customProviderIcon => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
