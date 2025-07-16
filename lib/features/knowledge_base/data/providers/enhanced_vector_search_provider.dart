import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/di/database_providers.dart';
import '../../domain/services/enhanced_vector_search_service.dart';
import '../../presentation/providers/document_processing_provider.dart';
import 'vector_database_provider.dart';

/// 增强向量搜索服务提供者
///
/// 使用统一的向量数据库提供者创建增强向量搜索服务
final enhancedVectorSearchServiceProvider = FutureProvider<EnhancedVectorSearchService>((ref) async {
  try {
    debugPrint('🔍 创建增强向量搜索服务...');
    
    // 获取依赖
    final database = ref.read(appDatabaseProvider);
    final vectorDatabase = await ref.watch(vectorDatabaseProvider.future);
    final embeddingService = ref.read(embeddingServiceProvider);
    
    // 创建服务实例
    final service = EnhancedVectorSearchService(
      database,
      vectorDatabase,
      embeddingService,
    );
    
    // 初始化服务
    final initialized = await service.initialize();
    if (!initialized) {
      debugPrint('❌ 增强向量搜索服务初始化失败');
      throw Exception('增强向量搜索服务初始化失败');
    }
    
    debugPrint('✅ 增强向量搜索服务创建成功');
    return service;
  } catch (e) {
    debugPrint('❌ 创建增强向量搜索服务失败: $e');
    rethrow;
  }
});

/// 增强向量搜索服务健康状态提供者
final enhancedVectorSearchHealthProvider = FutureProvider<bool>((ref) async {
  try {
    final service = await ref.watch(enhancedVectorSearchServiceProvider.future);
    return await service.isHealthy();
  } catch (e) {
    debugPrint('❌ 检查增强向量搜索服务健康状态失败: $e');
    return false;
  }
});

/// 增强向量搜索服务状态提供者
final enhancedVectorSearchStatusProvider = Provider<AsyncValue<EnhancedVectorSearchService>>((ref) {
  return ref.watch(enhancedVectorSearchServiceProvider);
});
