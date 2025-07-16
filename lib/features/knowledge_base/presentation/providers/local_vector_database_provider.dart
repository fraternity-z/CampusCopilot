import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../domain/services/vector_database_interface.dart';
import '../../data/vector_databases/local_file_vector_client.dart';

/// 本地向量数据库路径Provider
final localVectorDatabasePathProvider = FutureProvider<String>((ref) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final vectorDbPath = path.join(appDir.path, 'vector_database');
    debugPrint('📁 本地向量数据库路径: $vectorDbPath');
    return vectorDbPath;
  } catch (e) {
    debugPrint('❌ 获取向量数据库路径失败: $e');
    return 'vector_database'; // 回退路径
  }
});

/// 本地向量数据库实例Provider
final localVectorDatabaseProvider = FutureProvider<VectorDatabaseInterface?>((
  ref,
) async {
  try {
    final dbPath = await ref.watch(localVectorDatabasePathProvider.future);
    final client = LocalFileVectorClient(dbPath);

    debugPrint('🔌 创建本地文件向量数据库客户端: $dbPath');
    return client;
  } catch (e) {
    debugPrint('❌ 创建本地向量数据库客户端失败: $e');
    return null;
  }
});

/// 本地向量数据库连接状态Provider
final localVectorDatabaseConnectionProvider = FutureProvider<bool>((ref) async {
  try {
    final vectorDb = await ref.watch(localVectorDatabaseProvider.future);

    if (vectorDb == null) {
      debugPrint('⚠️ 本地向量数据库客户端为空');
      return false;
    }

    final isConnected = await vectorDb.initialize();
    debugPrint('🔌 本地向量数据库连接状态: ${isConnected ? "已连接" : "连接失败"}');
    return isConnected;
  } catch (e) {
    debugPrint('❌ 检查本地向量数据库连接失败: $e');
    return false;
  }
});

/// 本地向量数据库健康状态Provider
final localVectorDatabaseHealthProvider = FutureProvider<bool>((ref) async {
  try {
    final vectorDb = await ref.watch(localVectorDatabaseProvider.future);

    if (vectorDb == null) {
      return false;
    }

    final isHealthy = await vectorDb.isHealthy();
    return isHealthy;
  } catch (e) {
    debugPrint('❌ 检查本地向量数据库健康状态失败: $e');
    return false;
  }
});

/// 本地向量数据库设置
class LocalVectorDatabaseSettings {
  final bool enabled;
  final bool autoBackup;
  final Duration backupInterval;
  final int maxCacheSize;
  final bool compressData;

  const LocalVectorDatabaseSettings({
    this.enabled = true,
    this.autoBackup = true,
    this.backupInterval = const Duration(hours: 24),
    this.maxCacheSize = 1000,
    this.compressData = false,
  });

  LocalVectorDatabaseSettings copyWith({
    bool? enabled,
    bool? autoBackup,
    Duration? backupInterval,
    int? maxCacheSize,
    bool? compressData,
  }) {
    return LocalVectorDatabaseSettings(
      enabled: enabled ?? this.enabled,
      autoBackup: autoBackup ?? this.autoBackup,
      backupInterval: backupInterval ?? this.backupInterval,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
      compressData: compressData ?? this.compressData,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'autoBackup': autoBackup,
    'backupInterval': backupInterval.inMilliseconds,
    'maxCacheSize': maxCacheSize,
    'compressData': compressData,
  };

  factory LocalVectorDatabaseSettings.fromJson(Map<String, dynamic> json) =>
      LocalVectorDatabaseSettings(
        enabled: json['enabled'] as bool? ?? true,
        autoBackup: json['autoBackup'] as bool? ?? true,
        backupInterval: Duration(
          milliseconds: json['backupInterval'] as int? ?? 86400000,
        ),
        maxCacheSize: json['maxCacheSize'] as int? ?? 1000,
        compressData: json['compressData'] as bool? ?? false,
      );
}

/// 本地向量数据库设置Provider
final localVectorDatabaseSettingsProvider =
    StateNotifierProvider<
      LocalVectorDatabaseSettingsNotifier,
      LocalVectorDatabaseSettings
    >((ref) => LocalVectorDatabaseSettingsNotifier());

/// 本地向量数据库设置状态管理
class LocalVectorDatabaseSettingsNotifier
    extends StateNotifier<LocalVectorDatabaseSettings> {
  LocalVectorDatabaseSettingsNotifier()
    : super(const LocalVectorDatabaseSettings());

  void updateEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
  }

  void updateAutoBackup(bool autoBackup) {
    state = state.copyWith(autoBackup: autoBackup);
  }

  void updateBackupInterval(Duration interval) {
    state = state.copyWith(backupInterval: interval);
  }

  void updateMaxCacheSize(int size) {
    state = state.copyWith(maxCacheSize: size);
  }

  void updateCompressData(bool compress) {
    state = state.copyWith(compressData: compress);
  }

  void updateSettings(LocalVectorDatabaseSettings settings) {
    state = settings;
  }
}

/// 本地向量数据库统计信息Provider
final localVectorDatabaseStatsProvider =
    FutureProvider<LocalVectorDatabaseStats?>((ref) async {
      try {
        final vectorDb = await ref.watch(localVectorDatabaseProvider.future);
        final dbPath = await ref.watch(localVectorDatabasePathProvider.future);

        if (vectorDb == null) {
          return null;
        }

        // 这里可以实现统计信息收集逻辑
        return LocalVectorDatabaseStats(
          databasePath: dbPath,
          isConnected: await vectorDb.isHealthy(),
          totalCollections: 0, // 需要实现统计逻辑
          totalDocuments: 0,
          totalStorageSize: 0.0,
          lastUpdated: DateTime.now(),
        );
      } catch (e) {
        debugPrint('❌ 获取本地向量数据库统计失败: $e');
        return null;
      }
    });

/// 本地向量数据库统计信息
class LocalVectorDatabaseStats {
  final String databasePath;
  final bool isConnected;
  final int totalCollections;
  final int totalDocuments;
  final double totalStorageSize; // MB
  final DateTime lastUpdated;

  const LocalVectorDatabaseStats({
    required this.databasePath,
    required this.isConnected,
    required this.totalCollections,
    required this.totalDocuments,
    required this.totalStorageSize,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'databasePath': databasePath,
    'isConnected': isConnected,
    'totalCollections': totalCollections,
    'totalDocuments': totalDocuments,
    'totalStorageSize': totalStorageSize,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory LocalVectorDatabaseStats.fromJson(Map<String, dynamic> json) =>
      LocalVectorDatabaseStats(
        databasePath: json['databasePath'] as String,
        isConnected: json['isConnected'] as bool,
        totalCollections: json['totalCollections'] as int,
        totalDocuments: json['totalDocuments'] as int,
        totalStorageSize: (json['totalStorageSize'] as num).toDouble(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );

  @override
  String toString() {
    return 'LocalVectorDatabaseStats(collections: $totalCollections, documents: $totalDocuments, size: ${totalStorageSize}MB)';
  }
}

/// 本地向量数据库操作结果
class LocalVectorDatabaseOperationResult {
  final bool success;
  final String? error;
  final Map<String, dynamic>? data;

  const LocalVectorDatabaseOperationResult({
    required this.success,
    this.error,
    this.data,
  });

  factory LocalVectorDatabaseOperationResult.success([
    Map<String, dynamic>? data,
  ]) => LocalVectorDatabaseOperationResult(success: true, data: data);

  factory LocalVectorDatabaseOperationResult.failure(String error) =>
      LocalVectorDatabaseOperationResult(success: false, error: error);

  @override
  String toString() {
    return 'LocalVectorDatabaseOperationResult(success: $success, error: $error)';
  }
}
