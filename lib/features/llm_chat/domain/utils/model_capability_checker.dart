import '../entities/model_capabilities.dart';

/// 模型能力检查器
/// 
class ModelCapabilityChecker {
  
  // ==================== 视觉模型检测 ====================
  
  /// 支持视觉功能的模型正则表达式列表
  static const List<String> _visionModelPatterns = [
    r'llava',
    r'moondream',
    r'minicpm',
    r'gemini-1\.5',
    r'gemini-2\.0',
    r'gemini-2\.5',
    r'gemini-exp',
    r'claude-3',
    r'claude-sonnet-4',
    r'claude-opus-4',
    r'vision',
    r'glm-4(?:\.\\d+)?v(?:-[\\w-]+)?',
    r'qwen-vl',
    r'qwen2-vl',
    r'qwen2\.5-vl',
    r'qwen2\.5-omni',
    r'qvq',
    r'internvl2',
    r'grok-vision-beta',
    r'grok-4(?:-[\\w-]+)?',
    r'pixtral',
    r'gpt-4(?:-[\\w-]+)',
    r'gpt-4\.1(?:-[\\w-]+)?',
    r'gpt-4o(?:-[\\w-]+)?',
    r'gpt-4\.5(?:-[\\w-]+)',
    r'gpt-5(?:-[\\w-]+)?',
    r'chatgpt-4o(?:-[\\w-]+)?',
    r'o1(?:-[\\w-]+)?',
    r'o3(?:-[\\w-]+)?',
    r'o4(?:-[\\w-]+)?',
    r'deepseek-vl(?:[\\w-]+)?',
    r'kimi-latest',
    r'gemma-3(?:-[\\w-]+)',
    r'doubao-seed-1[.-]6(?:-[\\w-]+)?',
    r'kimi-thinking-preview',
    r'gemma3(?:[-:\\w]+)?',
    r'kimi-vl-a3b-thinking(?:-[\\w-]+)?',
    r'llama-guard-4(?:-[\\w-]+)?',
    r'llama-4(?:-[\\w-]+)?',
    r'step-1o(?:.*vision)?',
    r'step-1v(?:-[\\w-]+)?',
  ];
  
  /// 不支持视觉的模型（排除列表）
  static const List<String> _visionExcludedPatterns = [
    r'gpt-4-\\d+-preview',
    r'gpt-4-turbo-preview',
    r'gpt-4-32k',
    r'gpt-4-\\d+',
    r'o1-mini',
    r'o3-mini',
    r'o1-preview',
    r'AIDC-AI/Marco-o1',
  ];
  
  // ==================== 函数调用模型检测 ====================
  
  /// 支持函数调用的模型正则表达式列表
  static const List<String> _functionCallingModelPatterns = [
    r'gpt-4o',
    r'gpt-4o-mini',
    r'gpt-4',
    r'gpt-4\.5',
    r'gpt-oss(?:-[\\w-]+)',
    r'gpt-5(?:-[0-9-]+)?',
    r'o[134](?:-[\\w-]+)?',
    r'claude',
    r'qwen',
    r'qwen3',
    r'hunyuan',
    r'deepseek',
    r'glm-4(?:-[\\w-]+)?',
    r'glm-4\.5(?:-[\\w-]+)?',
    r'learnlm(?:-[\\w-]+)?',
    r'gemini(?:-[\\w-]+)?',
    r'grok-3(?:-[\\w-]+)?',
    r'doubao-seed-1[.-]6(?:-[\\w-]+)?',
    r'kimi-k2(?:-[\\w-]+)?',
  ];
  
  /// 不支持函数调用的模型（排除列表）
  static const List<String> _functionCallingExcludedPatterns = [
    r'aqa(?:-[\\w-]+)?',
    r'imagen(?:-[\\w-]+)?',
    r'o1-mini',
    r'o1-preview',
    r'AIDC-AI/Marco-o1',
    r'gemini-1(?:\\.[\\w-]+)?',
    r'qwen-mt(?:-[\\w-]+)?',
    r'gpt-5-chat(?:-[\\w-]+)?',
    r'glm-4\\.5v',
  ];
  
  // ==================== 推理模型检测 ====================
  
  /// 支持推理功能的模型正则表达式
  static const String _reasoningModelPattern = 
      r'^(o\d+(?:-[\w-]+)?|.*\b(?:reasoning|reasoner|thinking)\b.*|.*-[rR]\d+.*|.*\bqwq(?:-[\w-]+)?\b.*|.*\bhunyuan-t1(?:-[\w-]+)?\b.*|.*\bglm-zero-preview\b.*|.*\bgrok-(?:3-mini|4)(?:-[\w-]+)?\b.*)$';
  
  // ==================== 嵌入模型检测 ====================
  
  /// 嵌入模型正则表达式
  static const String _embeddingModelPattern = 
      r'(?:^text-|embed|bge-|e5-|LLM2Vec|retrieval|uae-|gte-|jina-clip|jina-embeddings|voyage-)';
  
  // ==================== 重排序模型检测 ====================
  
  /// 重排序模型正则表达式
  static const String _rerankModelPattern = 
      r'(?:rerank|re-rank|re-ranker|re-ranking|retrieval|retriever)';
  
  // ==================== 网络搜索模型检测 ====================
  
  /// Claude支持网络搜索的模型
  static const String _claudeWebSearchPattern = 
      r'\b(?:claude-3(-|\.)(7|5)-sonnet(?:-[\w-]+)|claude-3(-|\.)5-haiku(?:-[\w-]+)|claude-sonnet-4(?:-[\w-]+)?|claude-opus-4(?:-[\w-]+)?)\b';
  
  /// Perplexity搜索模型
  static const List<String> _perplexitySearchModels = [
    'sonar-pro',
    'sonar',
    'sonar-reasoning',
    'sonar-reasoning-pro',
    'sonar-deep-research',
  ];
  
  // ==================== 图像生成模型检测 ====================
  
  /// 图像生成模型正则表达式
  static const String _imageGenerationPattern = 
      r'flux|diffusion|stabilityai|sd-|dall|cogview|janus|midjourney|mj-|image|gpt-image';
  
  // ==================== 不支持的模型检测 ====================
  
  /// 不支持的模型类型
  static const String _notSupportedPattern = r'(?:^tts|whisper|speech)';
  
  // ==================== 公共方法 ====================
  
  /// 检查模型是否支持指定能力
  static bool hasCapability(String? modelName, ModelCapabilityType capability) {
    if (modelName == null || modelName.isEmpty) return false;
    
    final normalizedName = modelName.toLowerCase().trim();
    
    switch (capability) {
      case ModelCapabilityType.chat:
        return _isChatModel(normalizedName);
      case ModelCapabilityType.vision:
        return _isVisionModel(normalizedName);
      case ModelCapabilityType.functionCalling:
        return _isFunctionCallingModel(normalizedName);
      case ModelCapabilityType.reasoning:
        return _isReasoningModel(normalizedName);
      case ModelCapabilityType.webSearch:
        return _isWebSearchModel(normalizedName);
      case ModelCapabilityType.embedding:
        return _isEmbeddingModel(normalizedName);
      case ModelCapabilityType.rerank:
        return _isRerankModel(normalizedName);
      case ModelCapabilityType.imageGeneration:
        return _isImageGenerationModel(normalizedName);
      case ModelCapabilityType.audio:
        return _isAudioModel(normalizedName);
    }
  }
  
  /// 获取模型的所有能力
  static List<ModelCapabilityType> getModelCapabilities(String? modelName) {
    if (modelName == null || modelName.isEmpty) return [ModelCapabilityType.chat];
    
    final capabilities = <ModelCapabilityType>[];
    
    for (final capability in ModelCapabilityType.values) {
      if (hasCapability(modelName, capability)) {
        capabilities.add(capability);
      }
    }
    
    // 确保所有模型至少有chat能力
    if (!capabilities.contains(ModelCapabilityType.chat)) {
      capabilities.insert(0, ModelCapabilityType.chat);
    }
    
    return capabilities;
  }
  
  /// 检查模型是否为不支持的类型
  static bool isUnsupportedModel(String? modelName) {
    if (modelName == null || modelName.isEmpty) return false;
    return RegExp(_notSupportedPattern, caseSensitive: false).hasMatch(modelName);
  }
  
  // ==================== 私有检查方法 ====================
  
  /// 检查是否为聊天模型（基础能力）
  static bool _isChatModel(String modelName) {
    // 排除专门的嵌入、重排序、图像生成等特殊模型
    if (_isEmbeddingModel(modelName) || 
        _isRerankModel(modelName) || 
        _isImageGenerationModel(modelName)) {
      return false;
    }
    
    // 排除不支持的模型
    if (RegExp(_notSupportedPattern, caseSensitive: false).hasMatch(modelName)) {
      return false;
    }
    
    return true;
  }
  
  /// 检查是否为视觉模型
  static bool _isVisionModel(String modelName) {
    // 先检查排除列表
    for (final pattern in _visionExcludedPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(modelName)) {
        return false;
      }
    }
    
    // 检查支持列表
    for (final pattern in _visionModelPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(modelName)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// 检查是否为函数调用模型
  static bool _isFunctionCallingModel(String modelName) {
    // 排除嵌入、重排序等特殊模型
    if (_isEmbeddingModel(modelName) || 
        _isRerankModel(modelName) || 
        _isImageGenerationModel(modelName)) {
      return false;
    }
    
    // 先检查排除列表
    for (final pattern in _functionCallingExcludedPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(modelName)) {
        return false;
      }
    }
    
    // 检查支持列表
    for (final pattern in _functionCallingModelPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(modelName)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// 检查是否为推理模型
  static bool _isReasoningModel(String modelName) {
    // 排除嵌入、重排序等特殊模型
    if (_isEmbeddingModel(modelName) || 
        _isRerankModel(modelName) || 
        _isImageGenerationModel(modelName)) {
      return false;
    }
    
    return RegExp(_reasoningModelPattern, caseSensitive: false).hasMatch(modelName);
  }
  
  /// 检查是否为网络搜索模型
  static bool _isWebSearchModel(String modelName) {
    // 排除嵌入、重排序等特殊模型
    if (_isEmbeddingModel(modelName) || 
        _isRerankModel(modelName) || 
        _isImageGenerationModel(modelName)) {
      return false;
    }
    
    // Claude模型
    if (RegExp(_claudeWebSearchPattern, caseSensitive: false).hasMatch(modelName)) {
      return true;
    }
    
    // Perplexity模型
    if (_perplexitySearchModels.any((model) => modelName.contains(model))) {
      return true;
    }
    
    // Gemini 2.x模型
    if (RegExp(r'gemini-2\..*', caseSensitive: false).hasMatch(modelName)) {
      return true;
    }
    
    // OpenAI网络搜索模型
    if (RegExp(r'gpt-4o-search-preview|gpt-4o-mini-search-preview', caseSensitive: false).hasMatch(modelName)) {
      return true;
    }
    
    // Grok模型
    if (modelName.contains('grok')) {
      return true;
    }
    
    // 智谱GLM-4系列
    if (RegExp(r'glm-4-', caseSensitive: false).hasMatch(modelName)) {
      return true;
    }
    
    // 通义千问部分模型
    final qwenSearchModels = ['qwen-turbo', 'qwen-max', 'qwen-plus', 'qwq', 'qwen-flash'];
    if (qwenSearchModels.any((model) => modelName.startsWith(model))) {
      return true;
    }
    
    // 混元模型（除了lite版本）
    if (modelName.contains('hunyuan') && !modelName.contains('hunyuan-lite')) {
      return true;
    }
    
    return false;
  }
  
  /// 检查是否为嵌入模型
  static bool _isEmbeddingModel(String modelName) {
    // 排除重排序模型
    if (_isRerankModel(modelName)) {
      return false;
    }
    
    return RegExp(_embeddingModelPattern, caseSensitive: false).hasMatch(modelName);
  }
  
  /// 检查是否为重排序模型
  static bool _isRerankModel(String modelName) {
    return RegExp(_rerankModelPattern, caseSensitive: false).hasMatch(modelName);
  }
  
  /// 检查是否为图像生成模型
  static bool _isImageGenerationModel(String modelName) {
    return RegExp(_imageGenerationPattern, caseSensitive: false).hasMatch(modelName);
  }
  
  /// 检查是否为语音模型
  static bool _isAudioModel(String modelName) {
    const audioPatterns = [
      r'whisper',
      r'tts-1',
      r'speech',
      r'voice',
      r'audio',
      r'flashaudio',
    ];
    
    for (final pattern in audioPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(modelName)) {
        return true;
      }
    }
    
    return false;
  }
  
  // ==================== 高级功能方法 ====================
  
  /// 获取模型的能力标签列表
  static List<ModelCapability> getModelCapabilityTags(String? modelName) {
    final capabilities = getModelCapabilities(modelName);
    
    return capabilities.map((type) => ModelCapability(type: type)).toList();
  }
  
  /// 检查模型是否支持多模态
  static bool isMultimodalModel(String? modelName) {
    return hasCapability(modelName, ModelCapabilityType.vision) ||
           hasCapability(modelName, ModelCapabilityType.audio) ||
           hasCapability(modelName, ModelCapabilityType.imageGeneration);
  }
  
  /// 获取模型能力的简短描述
  static String getCapabilityDescription(String? modelName) {
    if (modelName == null || modelName.isEmpty) return '基础文本模型';
    
    final capabilities = getModelCapabilities(modelName);
    
    if (capabilities.length == 1 && capabilities.contains(ModelCapabilityType.chat)) {
      return '文本聊天';
    }
    
    final specialCapabilities = capabilities
        .where((cap) => cap != ModelCapabilityType.chat)
        .map((cap) => cap.displayName)
        .toList();
    
    if (specialCapabilities.isEmpty) {
      return '文本聊天';
    } else if (specialCapabilities.length == 1) {
      return '${specialCapabilities.first}模型';
    } else {
      return '多模态模型 (${specialCapabilities.join('、')})';
    }
  }
  
  /// 获取推荐的模型（按能力分类）
  static Map<ModelCapabilityType, List<String>> getRecommendedModelsByCapability() {
    return {
      ModelCapabilityType.vision: [
        'gpt-4o',
        'gpt-4o-mini',
        'gemini-1.5-pro',
        'gemini-1.5-flash',
        'claude-3-5-sonnet-20241022',
        'claude-3-haiku-20240307',
        'qwen-vl-max',
        'qwen2-vl-72b',
      ],
      ModelCapabilityType.functionCalling: [
        'gpt-4o',
        'gpt-4o-mini',
        'claude-3-5-sonnet-20241022',
        'gemini-1.5-pro',
        'qwen-max',
        'deepseek-chat',
        'glm-4-plus',
      ],
      ModelCapabilityType.reasoning: [
        'o1-preview',
        'o1-mini',
        'claude-3-5-sonnet-20241022',
        'qwq-32b-preview',
        'deepseek-reasoner',
        'gemini-2.5-flash-thinking',
      ],
      ModelCapabilityType.webSearch: [
        'claude-3-5-sonnet-20241022',
        'gpt-4o-search-preview',
        'gemini-2.0-flash',
        'perplexity-sonar-pro',
        'qwen-max',
      ],
      ModelCapabilityType.embedding: [
        'text-embedding-3-large',
        'text-embedding-3-small',
        'text-embedding-ada-002',
        'bge-large-zh-v1.5',
        'jina-embeddings-v2-base-zh',
      ],
    };
  }
}
