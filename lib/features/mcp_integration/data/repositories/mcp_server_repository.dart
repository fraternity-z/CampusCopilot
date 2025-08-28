import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart';
import 'package:logging/logging.dart';
import '../../../../data/local/app_database.dart';
import '../../domain/entities/mcp_server_config.dart';
import '../providers/mcp_oauth_provider.dart';

/// MCP服务器配置仓库
/// 负责MCP服务器配置的持久化存储和管理
class McpServerRepository {
  static final Logger _logger = Logger('McpServerRepository');
  
  final AppDatabase _database;
  final Encrypter _encrypter;
  
  McpServerRepository(this._database) : _encrypter = _createEncrypter();

  /// 创建加密器用于敏感数据
  static Encrypter _createEncrypter() {
    // 在生产环境中，应该使用更安全的密钥管理
    // 这里使用固定密钥仅用于演示
    final key = Key.fromSecureRandom(32);
    return Encrypter(AES(key));
  }

  /// 获取所有服务器配置
  Future<List<McpServerConfig>> getAllServers() async {
    try {
      final servers = await _database.select(_database.mcpServersTable).get();
      return servers.map(_mapToServerConfig).toList();
    } catch (e) {
      _logger.severe('Failed to get all servers: $e');
      return [];
    }
  }

  /// 根据ID获取服务器配置
  Future<McpServerConfig?> getServerById(String id) async {
    try {
      final server = await (_database.select(_database.mcpServersTable)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      
      return server != null ? _mapToServerConfig(server) : null;
    } catch (e) {
      _logger.severe('Failed to get server by ID: $e');
      return null;
    }
  }

  /// 获取已启用的服务器
  Future<List<McpServerConfig>> getEnabledServers() async {
    try {
      final servers = await (_database.select(_database.mcpServersTable)
            ..where((tbl) => tbl.disabled.equals(false)))
          .get();
      
      return servers.map(_mapToServerConfig).toList();
    } catch (e) {
      _logger.severe('Failed to get enabled servers: $e');
      return [];
    }
  }

  /// 创建服务器配置
  Future<void> createServer(McpServerConfig server) async {
    try {
      await _database.into(_database.mcpServersTable).insert(
        McpServersTableCompanion(
          id: Value(server.id),
          name: Value(server.name),
          baseUrl: Value(server.baseUrl),
          type: Value(server.type.name),
          headers: Value(server.headers != null ? jsonEncode(server.headers) : null),
          timeout: Value(server.timeout),
          longRunning: Value(server.longRunning ?? false),
          disabled: Value(server.disabled ?? false),
          error: Value(server.error),
          // OAuth配置（加密存储敏感信息）
          clientId: Value(server.clientId),
          clientSecret: Value(server.clientSecret != null 
              ? _encrypter.encrypt(server.clientSecret!).base64 
              : null),
          authorizationEndpoint: Value(server.authorizationEndpoint),
          tokenEndpoint: Value(server.tokenEndpoint),
          // 连接状态
          isConnected: Value(server.isConnected),
          lastConnected: Value(server.lastConnected),
          createdAt: Value(server.createdAt ?? DateTime.now()),
          updatedAt: Value(server.updatedAt ?? DateTime.now()),
        ),
      );
      
      _logger.info('Created server configuration: ${server.name}');
    } catch (e) {
      _logger.severe('Failed to create server: $e');
      rethrow;
    }
  }

  /// 更新服务器配置
  Future<void> updateServer(McpServerConfig server) async {
    try {
      await (_database.update(_database.mcpServersTable)
            ..where((tbl) => tbl.id.equals(server.id)))
          .write(
        McpServersTableCompanion(
          name: Value(server.name),
          baseUrl: Value(server.baseUrl),
          type: Value(server.type.name),
          headers: Value(server.headers != null ? jsonEncode(server.headers) : null),
          timeout: Value(server.timeout),
          longRunning: Value(server.longRunning ?? false),
          disabled: Value(server.disabled ?? false),
          error: Value(server.error),
          // OAuth配置
          clientId: Value(server.clientId),
          clientSecret: Value(server.clientSecret != null 
              ? _encrypter.encrypt(server.clientSecret!).base64 
              : null),
          authorizationEndpoint: Value(server.authorizationEndpoint),
          tokenEndpoint: Value(server.tokenEndpoint),
          // 连接状态
          isConnected: Value(server.isConnected),
          lastConnected: Value(server.lastConnected),
          updatedAt: Value(DateTime.now()),
        ),
      );
      
      _logger.info('Updated server configuration: ${server.name}');
    } catch (e) {
      _logger.severe('Failed to update server: $e');
      rethrow;
    }
  }

  /// 删除服务器配置
  Future<void> deleteServer(String id) async {
    try {
      await (_database.delete(_database.mcpServersTable)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      
      _logger.info('Deleted server configuration: $id');
    } catch (e) {
      _logger.severe('Failed to delete server: $e');
      rethrow;
    }
  }

  /// 更新连接状态
  Future<void> updateConnectionStatus(String serverId, bool isConnected, {String? error}) async {
    try {
      await (_database.update(_database.mcpServersTable)
            ..where((tbl) => tbl.id.equals(serverId)))
          .write(
        McpServersTableCompanion(
          isConnected: Value(isConnected),
          lastConnected: Value(isConnected ? DateTime.now() : null),
          error: Value(error),
          updatedAt: Value(DateTime.now()),
        ),
      );
      
      _logger.fine('Updated connection status for $serverId: $isConnected');
    } catch (e) {
      _logger.severe('Failed to update connection status: $e');
    }
  }

  /// 保存连接状态记录
  Future<void> saveConnectionStatus(McpConnectionStatus status) async {
    try {
      await _database.into(_database.mcpConnectionsTable).insert(
        McpConnectionsTableCompanion(
          serverId: Value(status.serverId),
          isConnected: Value(status.isConnected),
          lastCheck: Value(status.lastCheck),
          latency: Value(status.latency),
          error: Value(status.error),
          serverName: Value(status.serverName),
          serverVersion: Value(status.serverVersion),
          protocolVersion: Value(status.protocolVersion),
          toolsCount: Value(status.toolsCount),
          resourcesCount: Value(status.resourcesCount),
          promptsCount: Value(status.promptsCount),
          recordedAt: Value(DateTime.now()),
        ),
      );
    } catch (e) {
      _logger.severe('Failed to save connection status: $e');
    }
  }

  /// 获取最新连接状态
  Future<McpConnectionStatus?> getLatestConnectionStatus(String serverId) async {
    try {
      final status = await (_database.select(_database.mcpConnectionsTable)
            ..where((tbl) => tbl.serverId.equals(serverId))
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)])
            ..limit(1))
          .getSingleOrNull();

      if (status == null) return null;

      return McpConnectionStatus(
        serverId: status.serverId,
        isConnected: status.isConnected,
        lastCheck: status.lastCheck,
        latency: status.latency,
        error: status.error,
        serverName: status.serverName,
        serverVersion: status.serverVersion,
        protocolVersion: status.protocolVersion,
        toolsCount: status.toolsCount,
        resourcesCount: status.resourcesCount,
        promptsCount: status.promptsCount,
      );
    } catch (e) {
      _logger.severe('Failed to get latest connection status: $e');
      return null;
    }
  }

  /// 清理过期的连接状态记录
  Future<void> cleanupOldConnectionRecords({Duration? olderThan}) async {
    try {
      final cutoffDate = DateTime.now().subtract(olderThan ?? const Duration(days: 7));
      
      await (_database.delete(_database.mcpConnectionsTable)
            ..where((tbl) => tbl.recordedAt.isSmallerThanValue(cutoffDate)))
          .go();
      
      _logger.info('Cleaned up connection records older than $cutoffDate');
    } catch (e) {
      _logger.severe('Failed to cleanup old connection records: $e');
    }
  }

  /// 保存或更新OAuth令牌
  Future<void> saveOAuthToken(String serverId, TokenInfo tokenInfo) async {
    try {
      // 加密敏感令牌信息
      final encryptedAccessToken = _encrypter.encrypt(tokenInfo.accessToken).base64;
      final encryptedRefreshToken = tokenInfo.refreshToken != null
          ? _encrypter.encrypt(tokenInfo.refreshToken!).base64
          : null;

      await _database.into(_database.mcpOAuthTokensTable).insertOnConflictUpdate(
        McpOAuthTokensTableCompanion(
          serverId: Value(serverId),
          accessToken: Value(encryptedAccessToken),
          refreshToken: Value(encryptedRefreshToken),
          tokenType: Value(tokenInfo.tokenType),
          expiresAt: Value(tokenInfo.expiresAt),
          scopes: Value(tokenInfo.scopes?.join(' ')),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      
      _logger.info('Saved OAuth token for server: $serverId');
    } catch (e) {
      _logger.severe('Failed to save OAuth token: $e');
      rethrow;
    }
  }

  /// 获取OAuth令牌
  Future<TokenInfo?> getOAuthToken(String serverId) async {
    try {
      final tokenData = await (_database.select(_database.mcpOAuthTokensTable)
            ..where((tbl) => tbl.serverId.equals(serverId)))
          .getSingleOrNull();

      if (tokenData == null) return null;

      // 解密敏感信息
      final accessToken = _encrypter.decrypt64(tokenData.accessToken);
      final refreshToken = tokenData.refreshToken != null
          ? _encrypter.decrypt64(tokenData.refreshToken!)
          : null;

      return TokenInfo(
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenData.tokenType,
        expiresAt: tokenData.expiresAt,
        scopes: tokenData.scopes?.split(' '),
      );
    } catch (e) {
      _logger.severe('Failed to get OAuth token: $e');
      return null;
    }
  }

  /// 删除OAuth令牌
  Future<void> deleteOAuthToken(String serverId) async {
    try {
      await (_database.delete(_database.mcpOAuthTokensTable)
            ..where((tbl) => tbl.serverId.equals(serverId)))
          .go();
      
      _logger.info('Deleted OAuth token for server: $serverId');
    } catch (e) {
      _logger.severe('Failed to delete OAuth token: $e');
    }
  }

  /// 将数据库记录映射到领域实体
  McpServerConfig _mapToServerConfig(McpServersTableData data) {
    return McpServerConfig(
      id: data.id,
      name: data.name,
      baseUrl: data.baseUrl,
      type: McpTransportType.values.firstWhere(
        (t) => t.name == data.type,
        orElse: () => McpTransportType.sse,
      ),
      headers: data.headers != null 
          ? Map<String, String>.from(jsonDecode(data.headers!))
          : null,
      timeout: data.timeout,
      longRunning: data.longRunning,
      disabled: data.disabled,
      error: data.error,
      clientId: data.clientId,
      clientSecret: data.clientSecret != null 
          ? _encrypter.decrypt64(data.clientSecret!) 
          : null,
      authorizationEndpoint: data.authorizationEndpoint,
      tokenEndpoint: data.tokenEndpoint,
      isConnected: data.isConnected,
      lastConnected: data.lastConnected,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// 监听服务器配置变化
  Stream<List<McpServerConfig>> watchServers() {
    return _database
        .select(_database.mcpServersTable)
        .watch()
        .map((servers) => servers.map(_mapToServerConfig).toList());
  }

  /// 监听特定服务器的配置变化
  Stream<McpServerConfig?> watchServer(String id) {
    return (_database.select(_database.mcpServersTable)
          ..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((server) => server != null ? _mapToServerConfig(server) : null);
  }
}