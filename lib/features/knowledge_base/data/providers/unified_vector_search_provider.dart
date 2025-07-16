import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/enhanced_vector_search_service.dart';
import '../../domain/services/vector_search_service.dart';
import 'enhanced_vector_search_provider.dart';
import '../../presentation/providers/document_processing_provider.dart';
import '../../../../core/di/database_providers.dart';

/// 统一向量搜索服务提供者
///
/// 默认使用增强向量搜索服务（ObjectBox），如果失败则回退到传统向量搜索服务
final unifiedVectorSearchServiceProvider = FutureProvider<dynamic>((ref) async {
  try {
    debugPrint('🔍 创建统一向量搜索服务（优先使用 ObjectBox）...');
    
    // 优先尝试使用增强向量搜索服务
    final enhancedService = await ref.watch(enhancedVectorSearchServiceProvider.future);
    
    // 检查服务健康状态
    final isHealthy = await enhancedService.isHealthy();
    if (isHealthy) {
      debugPrint('✅ 使用增强向量搜索服务（ObjectBox）');
      return enhancedService;
    } else {
      debugPrint('⚠️ 增强向量搜索服务不健康，回退到传统服务');
      throw Exception('增强向量搜索服务不健康');
    }
  } catch (e) {
    debugPrint('❌ 增强向量搜索服务创建失败: $e');
    debugPrint('🔄 回退到传统向量搜索服务...');
    
    try {
      // 回退到传统向量搜索服务
      final database = ref.read(appDatabaseProvider);
      final embeddingService = ref.read(embeddingServiceProvider);
      final fallbackService = VectorSearchService(database, embeddingService);
      
      debugPrint('✅ 使用传统向量搜索服务（SQLite）');
      return fallbackService;
    } catch (fallbackError) {
      debugPrint('❌ 传统向量搜索服务也创建失败: $fallbackError');
      rethrow;
    }
  }
});

/// 向量搜索服务类型提供者
final vectorSearchServiceTypeProvider = FutureProvider<VectorSearchServiceType>((ref) async {
  try {
    final service = await ref.watch(unifiedVectorSearchServiceProvider.future);
    
    if (service is EnhancedVectorSearchService) {
      return VectorSearchServiceType.enhanced;
    } else if (service is VectorSearchService) {
      return VectorSearchServiceType.traditional;
    } else {
      return VectorSearchServiceType.unknown;
    }
  } catch (e) {
    debugPrint('❌ 无法确定向量搜索服务类型: $e');
    return VectorSearchServiceType.unknown;
  }
});

/// 向量搜索服务健康状态提供者
final unifiedVectorSearchHealthProvider = FutureProvider<bool>((ref) async {
  try {
    final service = await ref.watch(unifiedVectorSearchServiceProvider.future);
    
    if (service is EnhancedVectorSearchService) {
      return await service.isHealthy();
    } else if (service is VectorSearchService) {
      // 传统服务没有健康检查方法，假设总是健康的
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('❌ 检查向量搜索服务健康状态失败: $e');
    return false;
  }
});

/// 向量搜索服务统计信息提供者
final unifiedVectorSearchStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    final service = await ref.watch(unifiedVectorSearchServiceProvider.future);
    final serviceType = await ref.watch(vectorSearchServiceTypeProvider.future);
    final isHealthy = await ref.watch(unifiedVectorSearchHealthProvider.future);
    
    final baseStats = {
      'serviceType': serviceType.name,
      'isHealthy': isHealthy,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (service is EnhancedVectorSearchService) {
      // 增强服务可以提供更详细的统计信息
      return {
        ...baseStats,
        'databaseType': 'ObjectBox',
        'supportsHNSW': true,
        'supportsRealTimeSearch': true,
      };
    } else if (service is VectorSearchService) {
      return {
        ...baseStats,
        'databaseType': 'SQLite',
        'supportsHNSW': false,
        'supportsRealTimeSearch': false,
      };
    } else {
      return baseStats;
    }
  } catch (e) {
    debugPrint('❌ 获取向量搜索服务统计失败: $e');
    return {
      'serviceType': 'unknown',
      'isHealthy': false,
      'error': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
});

/// 向量搜索服务类型枚举
enum VectorSearchServiceType {
  /// 增强向量搜索服务（ObjectBox）
  enhanced,
  /// 传统向量搜索服务（SQLite）
  traditional,
  /// 未知类型
  unknown,
}

extension VectorSearchServiceTypeExtension on VectorSearchServiceType {
  String get name {
    switch (this) {
      case VectorSearchServiceType.enhanced:
        return 'Enhanced (ObjectBox)';
      case VectorSearchServiceType.traditional:
        return 'Traditional (SQLite)';
      case VectorSearchServiceType.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case VectorSearchServiceType.enhanced:
        return '使用 ObjectBox 数据库，支持 HNSW 索引和高性能向量搜索';
      case VectorSearchServiceType.traditional:
        return '使用 SQLite 数据库，基础向量搜索功能';
      case VectorSearchServiceType.unknown:
        return '未知的向量搜索服务类型';
    }
  }

  bool get isEnhanced => this == VectorSearchServiceType.enhanced;
  bool get isTraditional => this == VectorSearchServiceType.traditional;
}
