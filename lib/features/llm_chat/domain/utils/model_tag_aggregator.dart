import '../entities/model_capabilities.dart';
import '../providers/llm_provider.dart';
import 'model_capability_checker.dart';

/// 模型标签聚合器
/// 
/// 提供从模型列表聚合能力标签的功能，参考CherryStudio的getModelTags实现
class ModelTagAggregator {
  
  /// 从模型列表聚合所有能力标签
  /// 
  /// 检查提供的模型列表，返回一个映射表示是否有任何模型具备每种能力
  /// 参数：
  /// - [models]: 要检查的模型列表
  /// 
  /// 返回：Map<ModelCapabilityType, bool> 能力类型到是否存在的映射
  static Map<ModelCapabilityType, bool> getModelTags(List<ModelInfo> models) {
    // 初始化所有能力为false
    final result = <ModelCapabilityType, bool>{};
    for (final capability in ModelCapabilityType.values) {
      result[capability] = false;
    }
    
    // 遍历所有模型，检查每种能力
    for (final model in models) {
      final modelName = model.id;
      
      // 逐一检查每种能力，一旦发现就标记为true
      for (final capability in ModelCapabilityType.values) {
        if (!result[capability]! && 
            ModelCapabilityChecker.hasCapability(modelName, capability)) {
          result[capability] = true;
        }
      }
      
      // 如果所有能力都已检测到，可以提前退出
      if (result.values.every((hasCapability) => hasCapability)) {
        break;
      }
    }
    
    return result;
  }
  
  /// 获取模型列表中支持特定能力的模型
  /// 
  /// 参数：
  /// - [models]: 要过滤的模型列表
  /// - [capability]: 要查找的能力类型
  /// 
  /// 返回：支持该能力的模型列表
  static List<ModelInfo> getModelsWithCapability(
    List<ModelInfo> models,
    ModelCapabilityType capability,
  ) {
    return models.where((model) {
      return ModelCapabilityChecker.hasCapability(model.id, capability);
    }).toList();
  }
  
  /// 获取模型列表中所有能力的统计信息
  /// 
  /// 参数：
  /// - [models]: 要分析的模型列表
  /// 
  /// 返回：能力统计信息
  static ModelCapabilityStatistics getCapabilityStatistics(List<ModelInfo> models) {
    final capabilities = <ModelCapabilityType, int>{};
    
    for (final capability in ModelCapabilityType.values) {
      capabilities[capability] = models.where((model) {
        return ModelCapabilityChecker.hasCapability(model.id, capability);
      }).length;
    }
    
    return ModelCapabilityStatistics(
      totalModels: models.length,
      capabilityCounts: capabilities,
    );
  }
  
  /// 获取模型的主要能力类型
  /// 
  /// 返回模型最显著的能力（排除基础chat能力）
  static ModelCapabilityType? getPrimaryCapability(String? modelName) {
    if (modelName == null || modelName.isEmpty) return null;
    
    final capabilities = ModelCapabilityChecker.getModelCapabilities(modelName);
    
    // 优先级排序：特殊功能 > 通用功能
    const priorityOrder = [
      ModelCapabilityType.embedding,
      ModelCapabilityType.rerank,
      ModelCapabilityType.imageGeneration,
      ModelCapabilityType.audio,
      ModelCapabilityType.reasoning,
      ModelCapabilityType.vision,
      ModelCapabilityType.functionCalling,
      ModelCapabilityType.webSearch,
      ModelCapabilityType.chat,
    ];
    
    for (final priority in priorityOrder) {
      if (capabilities.contains(priority) && priority != ModelCapabilityType.chat) {
        return priority;
      }
    }
    
    return ModelCapabilityType.chat;
  }
  
  /// 按能力类型分组模型
  /// 
  /// 参数：
  /// - [models]: 要分组的模型列表
  /// 
  /// 返回：按能力类型分组的模型映射
  static Map<ModelCapabilityType, List<ModelInfo>> groupModelsByCapability(
    List<ModelInfo> models,
  ) {
    final grouped = <ModelCapabilityType, List<ModelInfo>>{};
    
    for (final capability in ModelCapabilityType.values) {
      grouped[capability] = getModelsWithCapability(models, capability);
    }
    
    return grouped;
  }
  
  /// 检查模型列表是否包含完整的能力覆盖
  /// 
  /// 参数：
  /// - [models]: 要检查的模型列表
  /// - [requiredCapabilities]: 必需的能力列表
  /// 
  /// 返回：是否满足所有必需能力
  static bool hasCompleteCapabilityCoverage(
    List<ModelInfo> models,
    List<ModelCapabilityType> requiredCapabilities,
  ) {
    final availableCapabilities = getModelTags(models);
    
    return requiredCapabilities.every((required) {
      return availableCapabilities[required] == true;
    });
  }
}

/// 模型能力统计信息
class ModelCapabilityStatistics {
  /// 模型总数
  final int totalModels;
  
  /// 各能力的模型数量
  final Map<ModelCapabilityType, int> capabilityCounts;
  
  const ModelCapabilityStatistics({
    required this.totalModels,
    required this.capabilityCounts,
  });
  
  /// 获取某种能力的覆盖率
  double getCoverageRate(ModelCapabilityType capability) {
    if (totalModels == 0) return 0.0;
    final count = capabilityCounts[capability] ?? 0;
    return count / totalModels;
  }
  
  /// 获取具备最多能力的能力类型
  ModelCapabilityType? getMostCommonCapability() {
    if (capabilityCounts.isEmpty) return null;
    
    var maxCount = 0;
    ModelCapabilityType? mostCommon;
    
    capabilityCounts.forEach((capability, count) {
      if (count > maxCount && capability != ModelCapabilityType.chat) {
        maxCount = count;
        mostCommon = capability;
      }
    });
    
    return mostCommon;
  }
  
  @override
  String toString() {
    return 'ModelCapabilityStatistics(totalModels: $totalModels, capabilityCounts: $capabilityCounts)';
  }
}
