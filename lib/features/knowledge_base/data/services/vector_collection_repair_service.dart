import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/vector_database_provider.dart';
import '../../../../core/di/database_providers.dart';

/// 向量集合修复服务
/// 
/// 用于修复缺失的向量集合，确保所有知识库都有对应的向量集合
class VectorCollectionRepairService {
  static VectorCollectionRepairService? _instance;
  
  VectorCollectionRepairService._();
  
  /// 获取单例实例
  static VectorCollectionRepairService get instance {
    _instance ??= VectorCollectionRepairService._();
    return _instance!;
  }

  /// 修复所有缺失的向量集合
  Future<VectorCollectionRepairResult> repairAllCollections(WidgetRef ref) async {
    try {
      debugPrint('🔧 开始修复向量集合...');
      
      final result = VectorCollectionRepairResult();
      
      // 获取数据库和向量数据库
      final database = ref.read(appDatabaseProvider);
      final vectorDatabase = await ref.read(vectorDatabaseProvider.future);
      
      // 获取所有知识库
      final knowledgeBases = await database.getAllKnowledgeBases();
      debugPrint('📊 发现 ${knowledgeBases.length} 个知识库');
      
      for (final kb in knowledgeBases) {
        try {
          // 检查向量集合是否存在
          final collectionExists = await vectorDatabase.collectionExists(kb.id);
          
          if (!collectionExists) {
            debugPrint('🔧 为知识库创建向量集合: ${kb.id} (${kb.name})');
            
            // 创建向量集合
            const defaultVectorDimension = 1536;
            final createResult = await vectorDatabase.createCollection(
              collectionName: kb.id,
              vectorDimension: defaultVectorDimension,
              description: '知识库 ${kb.name} 的向量集合',
              metadata: {
                'knowledgeBaseId': kb.id,
                'knowledgeBaseName': kb.name,
                'createdAt': DateTime.now().toIso8601String(),
                'repairedAt': DateTime.now().toIso8601String(),
                'autoCreated': 'true',
              },
            );
            
            if (createResult.success) {
              result.createdCollections.add(kb.id);
              debugPrint('✅ 向量集合创建成功: ${kb.id}');
            } else {
              result.failedCollections[kb.id] = createResult.error ?? '未知错误';
              debugPrint('❌ 向量集合创建失败: ${kb.id} - ${createResult.error}');
            }
          } else {
            result.existingCollections.add(kb.id);
            debugPrint('✅ 向量集合已存在: ${kb.id}');
          }
        } catch (e) {
          result.failedCollections[kb.id] = e.toString();
          debugPrint('❌ 处理知识库失败: ${kb.id} - $e');
        }
      }
      
      result.success = result.failedCollections.isEmpty;
      result.message = _generateResultMessage(result);
      
      debugPrint('📊 向量集合修复完成: ${result.message}');
      return result;
    } catch (e) {
      debugPrint('❌ 向量集合修复失败: $e');
      return VectorCollectionRepairResult(
        success: false,
        message: '向量集合修复失败: $e',
      );
    }
  }

  /// 修复单个知识库的向量集合
  Future<bool> repairSingleCollection(
    WidgetRef ref,
    String knowledgeBaseId,
    String knowledgeBaseName,
  ) async {
    try {
      debugPrint('🔧 修复单个向量集合: $knowledgeBaseId');
      
      final vectorDatabase = await ref.read(vectorDatabaseProvider.future);
      
      // 检查向量集合是否存在
      final collectionExists = await vectorDatabase.collectionExists(knowledgeBaseId);
      
      if (collectionExists) {
        debugPrint('✅ 向量集合已存在: $knowledgeBaseId');
        return true;
      }
      
      // 创建向量集合
      const defaultVectorDimension = 1536;
      final result = await vectorDatabase.createCollection(
        collectionName: knowledgeBaseId,
        vectorDimension: defaultVectorDimension,
        description: '知识库 $knowledgeBaseName 的向量集合',
        metadata: {
          'knowledgeBaseId': knowledgeBaseId,
          'knowledgeBaseName': knowledgeBaseName,
          'createdAt': DateTime.now().toIso8601String(),
          'repairedAt': DateTime.now().toIso8601String(),
          'autoCreated': 'true',
        },
      );
      
      if (result.success) {
        debugPrint('✅ 向量集合创建成功: $knowledgeBaseId');
        return true;
      } else {
        debugPrint('❌ 向量集合创建失败: $knowledgeBaseId - ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ 修复单个向量集合失败: $knowledgeBaseId - $e');
      return false;
    }
  }

  /// 生成结果消息
  String _generateResultMessage(VectorCollectionRepairResult result) {
    final parts = <String>[];
    
    if (result.existingCollections.isNotEmpty) {
      parts.add('已存在 ${result.existingCollections.length} 个');
    }
    
    if (result.createdCollections.isNotEmpty) {
      parts.add('新创建 ${result.createdCollections.length} 个');
    }
    
    if (result.failedCollections.isNotEmpty) {
      parts.add('失败 ${result.failedCollections.length} 个');
    }
    
    return '向量集合修复完成: ${parts.join('，')}';
  }
}

/// 向量集合修复结果
class VectorCollectionRepairResult {
  bool success;
  String message;
  final List<String> existingCollections;
  final List<String> createdCollections;
  final Map<String, String> failedCollections;
  final DateTime timestamp;

  VectorCollectionRepairResult({
    this.success = false,
    this.message = '',
    List<String>? existingCollections,
    List<String>? createdCollections,
    Map<String, String>? failedCollections,
  }) : existingCollections = existingCollections ?? [],
       createdCollections = createdCollections ?? [],
       failedCollections = failedCollections ?? {},
       timestamp = DateTime.now();

  /// 是否有任何操作
  bool get hasAnyOperation => 
      existingCollections.isNotEmpty || 
      createdCollections.isNotEmpty || 
      failedCollections.isNotEmpty;

  /// 总数
  int get totalCount => 
      existingCollections.length + 
      createdCollections.length + 
      failedCollections.length;

  @override
  String toString() {
    return 'VectorCollectionRepairResult('
        'success: $success, '
        'message: $message, '
        'existing: ${existingCollections.length}, '
        'created: ${createdCollections.length}, '
        'failed: ${failedCollections.length}'
        ')';
  }
}

/// 向量集合修复服务提供者
final vectorCollectionRepairServiceProvider = Provider<VectorCollectionRepairService>((ref) {
  return VectorCollectionRepairService.instance;
});
