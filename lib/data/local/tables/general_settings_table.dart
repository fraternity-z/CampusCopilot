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

  // 代理服务配置
  /// 代理模式 (none/system/custom)
  static const String proxyMode = 'proxy_mode';

  /// 代理类型 (http/https/socks5)
  static const String proxyType = 'proxy_type';

  /// 代理服务器地址
  static const String proxyHost = 'proxy_host';

  /// 代理服务器端口
  static const String proxyPort = 'proxy_port';

  /// 代理用户名（可选）
  static const String proxyUsername = 'proxy_username';

  /// 代理密码（可选）
  static const String proxyPassword = 'proxy_password';

  // 搜索功能配置
  /// 搜索功能是否启用
  static const String searchEnabled = 'search_enabled';

  /// 启用的搜索引擎列表（逗号分隔）
  static const String searchEnabledEngines = 'search_enabled_engines';

  /// 默认搜索引擎
  static const String searchDefaultEngine = 'search_default_engine';

  /// 搜索API密钥
  static const String searchApiKey = 'search_api_key';

  /// 搜索最大结果数
  static const String searchMaxResults = 'search_max_results';

  /// 搜索超时时间（秒）
  static const String searchTimeoutSeconds = 'search_timeout_seconds';

  /// 搜索语言偏好
  static const String searchLanguage = 'search_language';

  /// 搜索地区偏好
  static const String searchRegion = 'search_region';

  /// 是否启用安全搜索
  static const String searchSafeSearch = 'search_safe_search';
}
