import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/vector_database_interface.dart';
import '../factories/vector_database_factory.dart';

/// 向量数据库类型配置提供者
final vectorDatabaseTypeProvider = StateProvider<VectorDatabaseType>((ref) {
  // 默认使用 ObjectBox
  return VectorDatabaseType.objectBox;
});

/// 向量数据库实例提供者
final vectorDatabaseProvider = FutureProvider<VectorDatabaseInterface>((ref) async {
  final type = ref.watch(vectorDatabaseTypeProvider);
  
  debugPrint('🏭 创建向量数据库实例: ${VectorDatabaseFactory.getDisplayName(type)}');
  
  final database = await VectorDatabaseFactory.createDatabase(type: type);
  
  // 自动初始化数据库
  final initialized = await database.initialize();
  if (!initialized) {
    debugPrint('❌ 向量数据库初始化失败');
    throw Exception('向量数据库初始化失败');
  }
  
  debugPrint('✅ 向量数据库初始化成功');
  return database;
});

/// 向量数据库健康状态提供者
final vectorDatabaseHealthProvider = FutureProvider<bool>((ref) async {
  try {
    final database = await ref.watch(vectorDatabaseProvider.future);
    return await database.isHealthy();
  } catch (e) {
    debugPrint('❌ 检查向量数据库健康状态失败: $e');
    return false;
  }
});

/// 向量数据库配置提供者
final vectorDatabaseConfigProvider = StateNotifierProvider<
    VectorDatabaseConfigNotifier,
    VectorDatabaseConfiguration
>((ref) => VectorDatabaseConfigNotifier());

/// 向量数据库配置
class VectorDatabaseConfiguration {
  final VectorDatabaseType type;
  final bool autoBackup;
  final Duration backupInterval;
  final int maxCacheSize;
  final bool enableIndexOptimization;
  final Map<String, dynamic> additionalConfig;

  const VectorDatabaseConfiguration({
    this.type = VectorDatabaseType.objectBox,
    this.autoBackup = true,
    this.backupInterval = const Duration(hours: 24),
    this.maxCacheSize = 1000,
    this.enableIndexOptimization = true,
    this.additionalConfig = const {},
  });

  VectorDatabaseConfiguration copyWith({
    VectorDatabaseType? type,
    bool? autoBackup,
    Duration? backupInterval,
    int? maxCacheSize,
    bool? enableIndexOptimization,
    Map<String, dynamic>? additionalConfig,
  }) {
    return VectorDatabaseConfiguration(
      type: type ?? this.type,
      autoBackup: autoBackup ?? this.autoBackup,
      backupInterval: backupInterval ?? this.backupInterval,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
      enableIndexOptimization: enableIndexOptimization ?? this.enableIndexOptimization,
      additionalConfig: additionalConfig ?? this.additionalConfig,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'autoBackup': autoBackup,
    'backupInterval': backupInterval.inMilliseconds,
    'maxCacheSize': maxCacheSize,
    'enableIndexOptimization': enableIndexOptimization,
    'additionalConfig': additionalConfig,
  };

  factory VectorDatabaseConfiguration.fromJson(Map<String, dynamic> json) =>
      VectorDatabaseConfiguration(
        type: VectorDatabaseType.values[json['type'] as int? ?? 1],
        autoBackup: json['autoBackup'] as bool? ?? true,
        backupInterval: Duration(
          milliseconds: json['backupInterval'] as int? ?? 86400000,
        ),
        maxCacheSize: json['maxCacheSize'] as int? ?? 1000,
        enableIndexOptimization: json['enableIndexOptimization'] as bool? ?? true,
        additionalConfig: json['additionalConfig'] as Map<String, dynamic>? ?? {},
      );
}

/// 向量数据库配置状态管理器
class VectorDatabaseConfigNotifier extends StateNotifier<VectorDatabaseConfiguration> {
  VectorDatabaseConfigNotifier() : super(const VectorDatabaseConfiguration());

  /// 更新数据库类型
  void updateType(VectorDatabaseType type) {
    state = state.copyWith(type: type);
    debugPrint('🔄 向量数据库类型已更新: ${VectorDatabaseFactory.getDisplayName(type)}');
  }

  /// 更新自动备份设置
  void updateAutoBackup(bool enabled) {
    state = state.copyWith(autoBackup: enabled);
    debugPrint('🔄 自动备份设置已更新: $enabled');
  }

  /// 更新备份间隔
  void updateBackupInterval(Duration interval) {
    state = state.copyWith(backupInterval: interval);
    debugPrint('🔄 备份间隔已更新: ${interval.inHours}小时');
  }

  /// 更新缓存大小
  void updateCacheSize(int size) {
    state = state.copyWith(maxCacheSize: size);
    debugPrint('🔄 缓存大小已更新: $size');
  }

  /// 更新索引优化设置
  void updateIndexOptimization(bool enabled) {
    state = state.copyWith(enableIndexOptimization: enabled);
    debugPrint('🔄 索引优化设置已更新: $enabled');
  }

  /// 更新额外配置
  void updateAdditionalConfig(Map<String, dynamic> config) {
    state = state.copyWith(additionalConfig: config);
    debugPrint('🔄 额外配置已更新');
  }

  /// 重置为默认配置
  void reset() {
    state = const VectorDatabaseConfiguration();
    debugPrint('🔄 向量数据库配置已重置为默认值');
  }

  /// 从JSON加载配置
  void loadFromJson(Map<String, dynamic> json) {
    state = VectorDatabaseConfiguration.fromJson(json);
    debugPrint('📥 向量数据库配置已从JSON加载');
  }
}
