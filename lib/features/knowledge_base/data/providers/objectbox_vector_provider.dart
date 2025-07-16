import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../vector_databases/objectbox_vector_client.dart';

/// ObjectBox 向量数据库客户端提供者
///
/// 提供 ObjectBox 向量数据库客户端的单例实例
final objectBoxVectorClientProvider = Provider<ObjectBoxVectorClient>((ref) {
  return ObjectBoxVectorClient();
});

/// ObjectBox 向量数据库初始化提供者
///
/// 确保 ObjectBox 向量数据库在应用启动时正确初始化
final objectBoxVectorInitProvider = FutureProvider<bool>((ref) async {
  final client = ref.read(objectBoxVectorClientProvider);
  return await client.initialize();
});

/// ObjectBox 向量数据库健康状态提供者
///
/// 监控 ObjectBox 向量数据库的健康状态
final objectBoxVectorHealthProvider = FutureProvider<bool>((ref) async {
  final client = ref.read(objectBoxVectorClientProvider);
  return await client.isHealthy();
});
