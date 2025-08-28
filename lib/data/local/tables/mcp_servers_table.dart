import 'package:drift/drift.dart';

/// MCP服务器配置表
class McpServersTable extends Table {
  @override
  String get tableName => 'mcp_servers';

  /// 服务器唯一标识
  TextColumn get id => text()();
  
  /// 服务器名称
  TextColumn get name => text()();
  
  /// 服务器基础URL
  TextColumn get baseUrl => text()();
  
  /// 传输协议类型 (sse, streamableHttp)
  TextColumn get type => text()();
  
  /// 自定义HTTP Headers (JSON格式存储)
  TextColumn get headers => text().nullable()();
  
  /// 连接超时时间(秒)
  IntColumn get timeout => integer().nullable()();
  
  /// 是否为长时间运行的服务
  BoolColumn get longRunning => boolean().withDefault(const Constant(false))();
  
  /// 是否禁用
  BoolColumn get disabled => boolean().withDefault(const Constant(false))();
  
  /// 错误信息
  TextColumn get error => text().nullable()();
  
  // OAuth配置
  /// OAuth客户端ID
  TextColumn get clientId => text().nullable()();
  
  /// OAuth客户端密钥 (加密存储)
  TextColumn get clientSecret => text().nullable()();
  
  /// OAuth授权端点
  TextColumn get authorizationEndpoint => text().nullable()();
  
  /// OAuth Token端点
  TextColumn get tokenEndpoint => text().nullable()();
  
  // 连接状态
  /// 是否已连接
  BoolColumn get isConnected => boolean().withDefault(const Constant(false))();
  
  /// 上次连接时间
  DateTimeColumn get lastConnected => dateTime().nullable()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

}

/// MCP连接状态表
class McpConnectionsTable extends Table {
  @override
  String get tableName => 'mcp_connections';

  /// 连接记录ID
  IntColumn get id => integer().autoIncrement()();
  
  /// 服务器ID (外键)
  TextColumn get serverId => text().references(McpServersTable, #id, onDelete: KeyAction.cascade)();
  
  /// 是否连接
  BoolColumn get isConnected => boolean()();
  
  /// 最后检查时间
  DateTimeColumn get lastCheck => dateTime()();
  
  /// 连接延迟 (毫秒)
  IntColumn get latency => integer().nullable()();
  
  /// 错误信息
  TextColumn get error => text().nullable()();
  
  // 服务器信息
  /// 服务器名称
  TextColumn get serverName => text().nullable()();
  
  /// 服务器版本
  TextColumn get serverVersion => text().nullable()();
  
  /// 协议版本
  TextColumn get protocolVersion => text().nullable()();
  
  // 能力信息
  /// 工具数量
  IntColumn get toolsCount => integer().nullable()();
  
  /// 资源数量
  IntColumn get resourcesCount => integer().nullable()();
  
  /// 提示数量
  IntColumn get promptsCount => integer().nullable()();
  
  /// 记录时间
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();

}

/// MCP工具缓存表
class McpToolsTable extends Table {
  @override
  String get tableName => 'mcp_tools';

  /// 工具记录ID
  IntColumn get id => integer().autoIncrement()();
  
  /// 服务器ID (外键)
  TextColumn get serverId => text().references(McpServersTable, #id, onDelete: KeyAction.cascade)();
  
  /// 工具名称
  TextColumn get name => text()();
  
  /// 工具描述
  TextColumn get description => text()();
  
  /// 输入模式 (JSON格式存储)
  TextColumn get inputSchema => text()();
  
  /// 缓存时间
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 过期时间
  DateTimeColumn get expiresAt => dateTime()();

}

/// MCP工具调用历史表
class McpCallHistoryTable extends Table {
  @override
  String get tableName => 'mcp_call_history';

  /// 调用记录ID
  TextColumn get id => text()();
  
  /// 服务器ID (外键)
  TextColumn get serverId => text().references(McpServersTable, #id, onDelete: KeyAction.cascade)();
  
  /// 工具名称
  TextColumn get toolName => text()();
  
  /// 调用参数 (JSON格式存储)
  TextColumn get arguments => text()();
  
  /// 调用时间
  DateTimeColumn get calledAt => dateTime()();
  
  /// 执行结果 (JSON格式存储)
  TextColumn get result => text().nullable()();
  
  /// 错误信息
  TextColumn get error => text().nullable()();
  
  /// 执行时长 (毫秒)
  IntColumn get duration => integer().nullable()();
  
  /// 是否成功
  BoolColumn get isSuccess => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

}

/// MCP资源缓存表
class McpResourcesTable extends Table {
  @override
  String get tableName => 'mcp_resources';

  /// 资源记录ID
  IntColumn get id => integer().autoIncrement()();
  
  /// 服务器ID (外键)
  TextColumn get serverId => text().references(McpServersTable, #id, onDelete: KeyAction.cascade)();
  
  /// 资源URI
  TextColumn get uri => text()();
  
  /// 资源名称
  TextColumn get name => text()();
  
  /// 资源描述
  TextColumn get description => text().nullable()();
  
  /// MIME类型
  TextColumn get mimeType => text().nullable()();
  
  /// 缓存时间
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 过期时间
  DateTimeColumn get expiresAt => dateTime()();

}

/// MCP OAuth令牌表 (加密存储)
class McpOAuthTokensTable extends Table {
  @override
  String get tableName => 'mcp_oauth_tokens';

  /// 服务器ID (外键)
  TextColumn get serverId => text().references(McpServersTable, #id, onDelete: KeyAction.cascade)();
  
  /// 访问令牌 (加密存储)
  TextColumn get accessToken => text()();
  
  /// 刷新令牌 (加密存储)
  TextColumn get refreshToken => text().nullable()();
  
  /// 令牌类型
  TextColumn get tokenType => text().nullable()();
  
  /// 过期时间
  DateTimeColumn get expiresAt => dateTime().nullable()();
  
  /// 权限范围
  TextColumn get scopes => text().nullable()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {serverId};

}