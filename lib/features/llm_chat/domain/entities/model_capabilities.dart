/// 模型能力枚举
/// 
/// 定义AI模型支持的各种能力类型
enum ModelCapabilityType {
  /// 文本聊天（基础能力）
  chat,
  
  /// 视觉理解（图片处理）
  vision,
  
  /// 函数调用/工具使用
  functionCalling,
  
  /// 推理思考
  reasoning,
  
  /// 内置网络搜索
  webSearch,
  
  /// 文本嵌入
  embedding,
  
  /// 重排序
  rerank,
  
  /// 图像生成
  imageGeneration,
  
  /// 语音处理
  audio,
}

/// 模型能力标签
/// 
/// 表示模型具备的特定能力，包含类型和用户是否手动设置
class ModelCapability {
  /// 能力类型
  final ModelCapabilityType type;
  
  /// 是否为用户手动选择
  /// - true: 用户手动启用该能力
  /// - false: 用户手动禁用该能力  
  /// - null: 使用自动检测结果
  final bool? isUserSelected;
  
  const ModelCapability({
    required this.type,
    this.isUserSelected,
  });
  
  /// 创建副本
  ModelCapability copyWith({
    ModelCapabilityType? type,
    bool? isUserSelected,
  }) {
    return ModelCapability(
      type: type ?? this.type,
      isUserSelected: isUserSelected ?? this.isUserSelected,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModelCapability &&
        other.type == type &&
        other.isUserSelected == isUserSelected;
  }
  
  @override
  int get hashCode => type.hashCode ^ isUserSelected.hashCode;
  
  @override
  String toString() {
    return 'ModelCapability(type: $type, isUserSelected: $isUserSelected)';
  }
}

/// 模型能力扩展方法
extension ModelCapabilityTypeExtension on ModelCapabilityType {
  /// 获取能力类型的显示名称
  String get displayName {
    switch (this) {
      case ModelCapabilityType.chat:
        return '文本聊天';
      case ModelCapabilityType.vision:
        return '视觉理解';
      case ModelCapabilityType.functionCalling:
        return '工具调用';
      case ModelCapabilityType.reasoning:
        return '推理思考';
      case ModelCapabilityType.webSearch:
        return '内置联网';
      case ModelCapabilityType.embedding:
        return '文本嵌入';
      case ModelCapabilityType.rerank:
        return '重排序';
      case ModelCapabilityType.imageGeneration:
        return '图像生成';
      case ModelCapabilityType.audio:
        return '语音处理';
    }
  }
  
  /// 获取能力类型的图标
  String get iconName {
    switch (this) {
      case ModelCapabilityType.chat:
        return 'chat';
      case ModelCapabilityType.vision:
        return 'visibility';
      case ModelCapabilityType.functionCalling:
        return 'build';
      case ModelCapabilityType.reasoning:
        return 'psychology';
      case ModelCapabilityType.webSearch:
        return 'search';
      case ModelCapabilityType.embedding:
        return 'scatter_plot';
      case ModelCapabilityType.rerank:
        return 'sort';
      case ModelCapabilityType.imageGeneration:
        return 'image';
      case ModelCapabilityType.audio:
        return 'headphones';
    }
  }
  
  /// 获取能力类型的描述
  String get description {
    switch (this) {
      case ModelCapabilityType.chat:
        return '支持文本对话交流';
      case ModelCapabilityType.vision:
        return '可以理解和分析图片内容';
      case ModelCapabilityType.functionCalling:
        return '支持调用外部工具和函数';
      case ModelCapabilityType.reasoning:
        return '具备深度推理和思考能力';
      case ModelCapabilityType.webSearch:
        return '内置实时网络搜索功能';
      case ModelCapabilityType.embedding:
        return '可将文本转换为向量表示';
      case ModelCapabilityType.rerank:
        return '支持搜索结果重排序';
      case ModelCapabilityType.imageGeneration:
        return '可生成图像内容';
      case ModelCapabilityType.audio:
        return '支持语音识别和生成';
    }
  }
}
