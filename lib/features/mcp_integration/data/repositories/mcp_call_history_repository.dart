import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:logging/logging.dart';
import '../../../../data/local/app_database.dart';
import '../../domain/entities/mcp_server_config.dart';

/// MCP工具调用历史仓库
/// 负责工具调用历史记录的存储和查询
class McpCallHistoryRepository {
  static final Logger _logger = Logger('McpCallHistoryRepository');
  
  final AppDatabase _database;

  McpCallHistoryRepository(this._database);

  /// 保存工具调用记录
  Future<void> saveCallHistory(McpCallHistory callHistory) async {
    try {
      await _database.into(_database.mcpCallHistoryTable).insert(
        McpCallHistoryTableCompanion(
          id: Value(callHistory.id),
          serverId: Value(callHistory.serverId),
          toolName: Value(callHistory.toolName),
          arguments: Value(jsonEncode(callHistory.arguments)),
          calledAt: Value(callHistory.calledAt),
          result: Value(callHistory.result),
          error: Value(callHistory.error),
          duration: Value(callHistory.duration),
          isSuccess: Value(callHistory.error == null),
        ),
      );
      
      _logger.fine('Saved call history: ${callHistory.id}');
    } catch (e) {
      _logger.severe('Failed to save call history: $e');
      rethrow;
    }
  }

  /// 获取所有调用历史
  Future<List<McpCallHistory>> getAllCallHistory({
    int? limit,
    DateTime? since,
  }) async {
    try {
      var query = _database.select(_database.mcpCallHistoryTable)
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.calledAt)]);

      if (since != null) {
        query = query..where((tbl) => tbl.calledAt.isBiggerOrEqualValue(since));
      }

      if (limit != null) {
        query = query..limit(limit);
      }

      final records = await query.get();
      return records.map(_mapToCallHistory).toList();
    } catch (e) {
      _logger.severe('Failed to get all call history: $e');
      return [];
    }
  }

  /// 获取特定服务器的调用历史
  Future<List<McpCallHistory>> getCallHistoryByServer(
    String serverId, {
    int? limit,
    DateTime? since,
  }) async {
    try {
      var query = _database.select(_database.mcpCallHistoryTable)
        ..where((tbl) => tbl.serverId.equals(serverId))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.calledAt)]);

      if (since != null) {
        query = query..where((tbl) => tbl.calledAt.isBiggerOrEqualValue(since));
      }

      if (limit != null) {
        query = query..limit(limit);
      }

      final records = await query.get();
      return records.map(_mapToCallHistory).toList();
    } catch (e) {
      _logger.severe('Failed to get call history by server: $e');
      return [];
    }
  }

  /// 获取特定工具的调用历史
  Future<List<McpCallHistory>> getCallHistoryByTool(
    String serverId,
    String toolName, {
    int? limit,
    DateTime? since,
  }) async {
    try {
      var query = _database.select(_database.mcpCallHistoryTable)
        ..where((tbl) => tbl.serverId.equals(serverId) & tbl.toolName.equals(toolName))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.calledAt)]);

      if (since != null) {
        query = query..where((tbl) => tbl.calledAt.isBiggerOrEqualValue(since));
      }

      if (limit != null) {
        query = query..limit(limit);
      }

      final records = await query.get();
      return records.map(_mapToCallHistory).toList();
    } catch (e) {
      _logger.severe('Failed to get call history by tool: $e');
      return [];
    }
  }

  /// 获取失败的调用记录
  Future<List<McpCallHistory>> getFailedCalls({
    String? serverId,
    int? limit,
    DateTime? since,
  }) async {
    try {
      var query = _database.select(_database.mcpCallHistoryTable)
        ..where((tbl) => tbl.isSuccess.equals(false))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.calledAt)]);

      if (serverId != null) {
        query = query..where((tbl) => tbl.serverId.equals(serverId));
      }

      if (since != null) {
        query = query..where((tbl) => tbl.calledAt.isBiggerOrEqualValue(since));
      }

      if (limit != null) {
        query = query..limit(limit);
      }

      final records = await query.get();
      return records.map(_mapToCallHistory).toList();
    } catch (e) {
      _logger.severe('Failed to get failed calls: $e');
      return [];
    }
  }

  /// 获取调用统计信息
  Future<CallStatistics> getCallStatistics({
    String? serverId,
    DateTime? since,
  }) async {
    try {
      String whereClause = '';
      if (serverId != null || since != null) {
        whereClause = 'WHERE ';
        final conditions = <String>[];
        
        if (serverId != null) {
          conditions.add("server_id = '$serverId'");
        }
        
        if (since != null) {
          conditions.add("called_at >= '${since.toIso8601String()}'");
        }
        
        whereClause += conditions.join(' AND ');
      }

      final result = await _database.customSelect('''
        SELECT 
          COUNT(*) as total_calls,
          COUNT(CASE WHEN is_success = 1 THEN 1 END) as successful_calls,
          COUNT(CASE WHEN is_success = 0 THEN 1 END) as failed_calls,
          AVG(duration) as avg_duration,
          MIN(duration) as min_duration,
          MAX(duration) as max_duration
        FROM mcp_call_history 
        $whereClause
      ''').getSingleOrNull();

      if (result == null) {
        return const CallStatistics(
          totalCalls: 0,
          successfulCalls: 0,
          failedCalls: 0,
          avgDuration: null,
          minDuration: null,
          maxDuration: null,
        );
      }

      return CallStatistics(
        totalCalls: result.data['total_calls'] as int,
        successfulCalls: result.data['successful_calls'] as int,
        failedCalls: result.data['failed_calls'] as int,
        avgDuration: (result.data['avg_duration'] as num?)?.toDouble(),
        minDuration: result.data['min_duration'] as int?,
        maxDuration: result.data['max_duration'] as int?,
      );
    } catch (e) {
      _logger.severe('Failed to get call statistics: $e');
      return const CallStatistics(
        totalCalls: 0,
        successfulCalls: 0,
        failedCalls: 0,
        avgDuration: null,
        minDuration: null,
        maxDuration: null,
      );
    }
  }

  /// 获取最常用的工具
  Future<List<ToolUsageStats>> getMostUsedTools({
    String? serverId,
    DateTime? since,
    int limit = 10,
  }) async {
    try {
      String whereClause = '';
      if (serverId != null || since != null) {
        whereClause = 'WHERE ';
        final conditions = <String>[];
        
        if (serverId != null) {
          conditions.add("server_id = '$serverId'");
        }
        
        if (since != null) {
          conditions.add("called_at >= '${since.toIso8601String()}'");
        }
        
        whereClause += conditions.join(' AND ');
      }

      final results = await _database.customSelect('''
        SELECT 
          server_id,
          tool_name,
          COUNT(*) as call_count,
          COUNT(CASE WHEN is_success = 1 THEN 1 END) as success_count,
          AVG(duration) as avg_duration
        FROM mcp_call_history 
        $whereClause
        GROUP BY server_id, tool_name
        ORDER BY call_count DESC
        LIMIT $limit
      ''').get();

      return results.map((row) => ToolUsageStats(
        serverId: row.data['server_id'] as String,
        toolName: row.data['tool_name'] as String,
        callCount: row.data['call_count'] as int,
        successCount: row.data['success_count'] as int,
        avgDuration: (row.data['avg_duration'] as num?)?.toDouble(),
      )).toList();
    } catch (e) {
      _logger.severe('Failed to get most used tools: $e');
      return [];
    }
  }

  /// 删除调用历史记录
  Future<void> deleteCallHistory(String callId) async {
    try {
      await (_database.delete(_database.mcpCallHistoryTable)
            ..where((tbl) => tbl.id.equals(callId)))
          .go();
      
      _logger.fine('Deleted call history: $callId');
    } catch (e) {
      _logger.severe('Failed to delete call history: $e');
      rethrow;
    }
  }

  /// 清理过期的调用历史
  Future<void> cleanupOldHistory({Duration? olderThan}) async {
    try {
      final cutoffDate = DateTime.now().subtract(olderThan ?? const Duration(days: 30));
      
      final deletedCount = await (_database.delete(_database.mcpCallHistoryTable)
            ..where((tbl) => tbl.calledAt.isSmallerThanValue(cutoffDate)))
          .go();
      
      _logger.info('Cleaned up $deletedCount call history records older than $cutoffDate');
    } catch (e) {
      _logger.severe('Failed to cleanup old history: $e');
    }
  }

  /// 清理特定服务器的调用历史
  Future<void> cleanupServerHistory(String serverId) async {
    try {
      final deletedCount = await (_database.delete(_database.mcpCallHistoryTable)
            ..where((tbl) => tbl.serverId.equals(serverId)))
          .go();
      
      _logger.info('Cleaned up $deletedCount call history records for server: $serverId');
    } catch (e) {
      _logger.severe('Failed to cleanup server history: $e');
    }
  }

  /// 将数据库记录映射到领域实体
  McpCallHistory _mapToCallHistory(McpCallHistoryTableData data) {
    return McpCallHistory(
      id: data.id,
      serverId: data.serverId,
      toolName: data.toolName,
      arguments: Map<String, dynamic>.from(jsonDecode(data.arguments)),
      calledAt: data.calledAt,
      result: data.result,
      error: data.error,
      duration: data.duration,
    );
  }

  /// 监听调用历史变化
  Stream<List<McpCallHistory>> watchCallHistory({
    String? serverId,
    int limit = 50,
  }) {
    var query = _database.select(_database.mcpCallHistoryTable)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.calledAt)])
      ..limit(limit);

    if (serverId != null) {
      query = query..where((tbl) => tbl.serverId.equals(serverId));
    }

    return query.watch().map((records) => records.map(_mapToCallHistory).toList());
  }
}

/// 调用统计信息
class CallStatistics {
  final int totalCalls;
  final int successfulCalls;
  final int failedCalls;
  final double? avgDuration;
  final int? minDuration;
  final int? maxDuration;

  const CallStatistics({
    required this.totalCalls,
    required this.successfulCalls,
    required this.failedCalls,
    this.avgDuration,
    this.minDuration,
    this.maxDuration,
  });

  double get successRate => totalCalls > 0 ? (successfulCalls / totalCalls) : 0.0;
  double get failureRate => totalCalls > 0 ? (failedCalls / totalCalls) : 0.0;
}

/// 工具使用统计
class ToolUsageStats {
  final String serverId;
  final String toolName;
  final int callCount;
  final int successCount;
  final double? avgDuration;

  const ToolUsageStats({
    required this.serverId,
    required this.toolName,
    required this.callCount,
    required this.successCount,
    this.avgDuration,
  });

  double get successRate => callCount > 0 ? (successCount / callCount) : 0.0;
  int get failureCount => callCount - successCount;
}