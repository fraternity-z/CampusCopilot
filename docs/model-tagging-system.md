# Anywherechat 模型标签系统

## 概述

模型标签系统为Anywherechat提供了完整的AI模型能力识别和展示功能，参考CherryStudio的实现，支持自动检测模型的各种能力，并在UI中清晰地显示这些能力标签。

## 核心功能

### 支持的能力类型

- **文本聊天** (`chat`) - 基础对话能力
- **视觉理解** (`vision`) - 图片分析和理解
- **工具调用** (`functionCalling`) - 外部工具和函数调用
- **推理思考** (`reasoning`) - 深度推理和思考
- **内置联网** (`webSearch`) - 实时网络搜索
- **文本嵌入** (`embedding`) - 文本向量化
- **重排序** (`rerank`) - 搜索结果重排序
- **图像生成** (`imageGeneration`) - 图像创作
- **语音处理** (`audio`) - 语音识别和生成

### 自动检测机制

系统使用正则表达式和模型名称匹配来自动检测模型能力：

```dart
// 检查单个模型的能力
final capabilities = ModelCapabilityChecker.getModelCapabilities('gpt-4o');
// 结果: [ModelCapabilityType.chat, ModelCapabilityType.vision, ModelCapabilityType.functionCalling]

// 检查特定能力
final hasVision = ModelCapabilityChecker.hasCapability('claude-3-5-sonnet', ModelCapabilityType.vision);
// 结果: true
```

## 核心组件

### 1. 数据结构

#### ModelCapabilityType 枚举
```dart
enum ModelCapabilityType {
  chat,           // 文本聊天
  vision,         // 视觉理解
  functionCalling, // 工具调用
  reasoning,      // 推理思考
  webSearch,      // 内置联网
  embedding,      // 文本嵌入
  rerank,         // 重排序
  imageGeneration, // 图像生成
  audio,          // 语音处理
}
```

#### ModelCapability 类
```dart
class ModelCapability {
  final ModelCapabilityType type;      // 能力类型
  final bool? isUserSelected;         // 用户手动设置状态
}
```

### 2. 检测器

#### ModelCapabilityChecker
核心能力检测器，提供以下功能：

```dart
// 检查模型是否支持特定能力
bool hasCapability(String? modelName, ModelCapabilityType capability)

// 获取模型的所有能力
List<ModelCapabilityType> getModelCapabilities(String? modelName)

// 获取模型能力描述
String getCapabilityDescription(String? modelName)

// 检查是否为多模态模型
bool isMultimodalModel(String? modelName)
```

### 3. 聚合器

#### ModelTagAggregator
提供模型列表的能力聚合功能：

```dart
// 聚合模型列表的所有能力
Map<ModelCapabilityType, bool> getModelTags(List<ModelInfo> models)

// 筛选具备特定能力的模型
List<ModelInfo> getModelsWithCapability(List<ModelInfo> models, ModelCapabilityType capability)

// 获取能力统计信息
ModelCapabilityStatistics getCapabilityStatistics(List<ModelInfo> models)
```

### 4. UI组件

#### ModelCapabilityTags
显示模型能力标签的组件：

```dart
ModelCapabilityTags(
  modelName: 'gpt-4o',
  size: TagSize.medium,
  maxTags: 4,
  compact: false,
)
```

#### CapabilityTag
单个能力标签组件：

```dart
CapabilityTag(
  capability: ModelCapabilityType.vision,
  size: TagSize.small,
  iconOnly: false,
)
```

#### ModelCapabilityCard
详细的模型能力展示卡片：

```dart
ModelCapabilityCard(
  modelName: 'claude-3-5-sonnet',
  showDescription: true,
)
```

## 使用示例

### 在模型选择器中显示标签

```dart
// 在现有的模型选择器中，已经集成了能力标签显示
ModelCapabilityTags(
  modelName: model.id,
  compact: true,    // 紧凑显示，只显示图标
  maxTags: 3,       // 最多显示3个标签
)
```

### 过滤聊天模型

```dart
// 新的过滤逻辑使用能力检测
List<ModelInfoWithProvider> _filterChatModels(List<ModelInfoWithProvider> models) {
  return models.where((model) {
    final capabilities = ModelCapabilityChecker.getModelCapabilities(model.id);
    
    // 必须支持chat能力
    if (!capabilities.contains(ModelCapabilityType.chat)) {
      return false;
    }
    
    // 排除纯嵌入模型
    if (capabilities.length == 1 && capabilities.contains(ModelCapabilityType.embedding)) {
      return false;
    }
    
    return true;
  }).toList();
}
```

### 能力聚合示例

```dart
// 分析模型列表的能力分布
final models = [
  ModelInfo(id: 'gpt-4o', name: 'GPT-4o', type: ModelType.chat),
  ModelInfo(id: 'claude-3-5-sonnet', name: 'Claude 3.5 Sonnet', type: ModelType.chat),
];

final aggregatedTags = ModelTagAggregator.getModelTags(models);
// 结果: {vision: true, functionCalling: true, reasoning: true, ...}

final statistics = ModelTagAggregator.getCapabilityStatistics(models);
print('视觉模型覆盖率: ${(statistics.getCoverageRate(ModelCapabilityType.vision) * 100).toStringAsFixed(1)}%');
```

## 检测规则

### 视觉模型检测
- **支持**: `llava`, `minicpm`, `gemini-1.5`, `claude-3`, `gpt-4o`, `qwen-vl` 等
- **排除**: `gpt-4-turbo-preview`, `o1-mini`, `o1-preview` 等

### 函数调用模型检测
- **支持**: `gpt-4o`, `claude`, `qwen`, `deepseek`, `glm-4` 等
- **排除**: `o1-mini`, `o1-preview`, `imagen`, `aqa` 等

### 推理模型检测
- **支持**: `o1`, `o3`, `qwq`, `deepseek-reasoner`, `gemini-thinking` 等

### 网络搜索模型检测
- **支持**: `claude-3.5-sonnet`, `gemini-2.0`, `perplexity-sonar`, `grok` 等

## 测试和验证

### 使用测试页面
```dart
// 导航到测试页面（开发模式）
Navigator.push(context, MaterialPageRoute(
  builder: (context) => const ModelCapabilityTestPage(),
));
```

### 手动测试
1. 在测试页面输入模型名称
2. 查看自动检测的能力标签
3. 验证检测结果的准确性

### 预设模型测试
测试页面包含多个预设模型，点击可快速切换并查看检测结果。

## 性能考虑

- **缓存优化**: 能力检测结果可以缓存以提高性能
- **批量检测**: 使用`ModelTagAggregator`进行批量处理
- **延迟加载**: UI组件支持按需显示标签

## 扩展指南

### 添加新的能力类型

1. 在`ModelCapabilityType`枚举中添加新类型
2. 在`ModelCapabilityChecker`中添加检测逻辑
3. 在扩展方法中添加显示信息
4. 更新UI组件的颜色和图标映射

### 自定义检测规则

在`ModelCapabilityChecker`中修改相应的正则表达式模式：

```dart
// 添加新的视觉模型模式
static const List<String> _visionModelPatterns = [
  // 现有模式...
  r'your-new-vision-model-pattern',
];
```

## 与现有系统的兼容性

- **向后兼容**: 保留了原有的`VisionModelChecker`功能
- **数据兼容**: 支持现有的`supportsVision`和`supportsFunctionCalling`字段
- **UI兼容**: 无缝集成到现有的模型选择界面

## 最佳实践

1. **能力检测**: 优先使用自动检测，用户可手动覆盖
2. **UI显示**: 在列表中使用紧凑模式，详情页使用完整模式
3. **性能优化**: 对频繁访问的能力检测结果进行缓存
4. **错误处理**: 对无效模型名称提供合理的默认行为
