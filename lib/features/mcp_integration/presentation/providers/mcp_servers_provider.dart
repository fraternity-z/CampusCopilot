import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import '../../../../core/di/database_providers.dart';
import '../../data/repositories/mcp_server_repository.dart';
import '../../data/services/mcp_client_service.dart';
import '../../domain/entities/mcp_server_config.dart';

final _logger = Logger('McpServersProvider');

/// MCP服务器仓库Provider
final mcpServerRepositoryProvider = Provider<McpServerRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return McpServerRepository(database);
});

/// MCP客户端服务Provider
final mcpClientServiceProvider = Provider<McpClientService>((ref) {
  return McpClientService();
});

/// MCP服务器列表状态管理
class McpServersNotifier extends StateNotifier<AsyncValue<List<McpServerConfig>>> {
  final McpServerRepository _repository;
  final McpClientService _clientService;

  McpServersNotifier(this._repository, this._clientService) : super(const AsyncValue.loading()) {
    _loadServers();
  }

  /// 加载所有服务器
  Future<void> _loadServers() async {
    try {
      state = const AsyncValue.loading();
      final servers = await _repository.getAllServers();
      state = AsyncValue.data(servers);
      _logger.info('Loaded ${servers.length} MCP servers');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _logger.severe('Failed to load servers: $error');
    }
  }

  /// 刷新服务器列表
  Future<void> refresh() async {
    await _loadServers();
  }

  /// 添加新服务器
  Future<void> addServer(McpServerConfig server) async {
    try {
      await _repository.createServer(server);
      await _loadServers(); // 重新加载列表
      _logger.info('Added server: ${server.name}');
    } catch (error) {
      _logger.severe('Failed to add server: $error');
      rethrow;
    }
  }

  /// 更新服务器
  Future<void> updateServer(McpServerConfig server) async {
    try {
      await _repository.updateServer(server);
      await _loadServers(); // 重新加载列表
      _logger.info('Updated server: ${server.name}');
    } catch (error) {
      _logger.severe('Failed to update server: $error');
      rethrow;
    }
  }

  /// 删除服务器
  Future<void> deleteServer(String serverId) async {
    try {
      // 先断开连接
      await _clientService.disconnect(serverId);
      // 然后删除配置
      await _repository.deleteServer(serverId);
      await _loadServers(); // 重新加载列表
      _logger.info('Deleted server: $serverId');
    } catch (error) {
      _logger.severe('Failed to delete server: $error');
      rethrow;
    }
  }

  /// 连接到服务器
  Future<void> connectToServer(String serverId) async {
    try {
      final server = await _repository.getServerById(serverId);
      if (server != null) {
        await _clientService.connect(server);
        await _loadServers(); // 刷新状态
        _logger.info('Connected to server: ${server.name}');
      }
    } catch (error) {
      _logger.severe('Failed to connect to server: $error');
      rethrow;
    }
  }

  /// 断开服务器连接
  Future<void> disconnectFromServer(String serverId) async {
    try {
      await _clientService.disconnect(serverId);
      await _loadServers(); // 刷新状态
      _logger.info('Disconnected from server: $serverId');
    } catch (error) {
      _logger.severe('Failed to disconnect from server: $error');
      rethrow;
    }
  }

  /// 切换服务器启用状态
  Future<void> toggleServer(String serverId) async {
    try {
      final server = await _repository.getServerById(serverId);
      if (server != null) {
        final updatedServer = server.copyWith(disabled: !(server.disabled ?? false));
        await updateServer(updatedServer);
        
        // 如果禁用了服务器，断开连接
        if (updatedServer.disabled ?? false) {
          await disconnectFromServer(serverId);
        }
        _logger.info('Toggled server ${server.name}: ${updatedServer.disabled! ? 'disabled' : 'enabled'}');
      }
    } catch (error) {
      _logger.severe('Failed to toggle server: $error');
      rethrow;
    }
  }

  /// 重新连接失败的服务器
  Future<void> reconnectFailedServers() async {
    try {
      final currentServers = state.value ?? [];
      final failedServers = currentServers.where((s) => !s.isConnected && !(s.disabled ?? false));
      
      for (final server in failedServers) {
        try {
          await connectToServer(server.id);
        } catch (e) {
          _logger.warning('Failed to reconnect server ${server.name}: $e');
        }
      }
    } catch (error) {
      _logger.severe('Failed to reconnect failed servers: $error');
    }
  }
}

/// MCP服务器列表Provider
final mcpServersProvider = StateNotifierProvider<McpServersNotifier, AsyncValue<List<McpServerConfig>>>((ref) {
  final repository = ref.watch(mcpServerRepositoryProvider);
  final clientService = ref.watch(mcpClientServiceProvider);
  return McpServersNotifier(repository, clientService);
});

/// 已连接的服务器Provider
final connectedServersProvider = Provider<List<McpServerConfig>>((ref) {
  final serversAsync = ref.watch(mcpServersProvider);
  return serversAsync.when(
    data: (servers) => servers.where((s) => s.isConnected).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// 服务器统计信息Provider
final serverStatsProvider = Provider<Map<String, int>>((ref) {
  final serversAsync = ref.watch(mcpServersProvider);
  return serversAsync.when(
    data: (servers) {
      final connected = servers.where((s) => s.isConnected).length;
      final total = servers.length;
      final failed = servers.where((s) => !s.isConnected && !(s.disabled ?? false)).length;
      
      return {
        'total': total,
        'connected': connected,
        'failed': failed,
        'disabled': total - connected - failed,
      };
    },
    loading: () => {'total': 0, 'connected': 0, 'failed': 0, 'disabled': 0},
    error: (_, _) => {'total': 0, 'connected': 0, 'failed': 0, 'disabled': 0},
  );
});