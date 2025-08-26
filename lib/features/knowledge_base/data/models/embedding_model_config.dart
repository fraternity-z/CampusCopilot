/// 嵌入模型配置
/// 
/// 包含各种嵌入模型的默认维度和上下文长度配置
/// 支持自动根据模型选择设置合适的维度
class EmbeddingModelConfig {
  final String id;
  final String name;
  final String provider;
  final int defaultDimension;
  final int maxContext;
  final bool supportsDynamicDimension;
  final List<int>? supportedDimensions;
  final String? description;

  const EmbeddingModelConfig({
    required this.id,
    required this.name,
    required this.provider,
    required this.defaultDimension,
    required this.maxContext,
    this.supportsDynamicDimension = false,
    this.supportedDimensions,
    this.description,
  });

  @override
  String toString() {
    return 'EmbeddingModelConfig(id: $id, provider: $provider, defaultDimension: $defaultDimension, maxContext: $maxContext)';
  }
}

/// 嵌入模型配置常量
/// 
/// 基于各模型厂商的官方文档和实际测试结果
class EmbeddingModelConfigs {
  EmbeddingModelConfigs._();

  /// 所有支持的嵌入模型配置
  static const List<EmbeddingModelConfig> allModels = [
    // OpenAI 系列
    EmbeddingModelConfig(
      id: 'text-embedding-3-large',
      name: 'Text Embedding 3 Large',
      provider: 'openai',
      defaultDimension: 3072,
      maxContext: 8191,
      supportsDynamicDimension: true,
      supportedDimensions: [256, 512, 1024, 1536, 2048, 3072],
      description: 'OpenAI最大的嵌入模型，支持动态维度调整',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-3-small',
      name: 'Text Embedding 3 Small',
      provider: 'openai',
      defaultDimension: 1536,
      maxContext: 8191,
      supportsDynamicDimension: true,
      supportedDimensions: [256, 512, 1024, 1536],
      description: 'OpenAI小型嵌入模型，性价比高',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-ada-002',
      name: 'Text Embedding Ada 002',
      provider: 'openai',
      defaultDimension: 1536,
      maxContext: 8191,
      description: 'OpenAI经典嵌入模型',
    ),

    // 阿里巴巴通义千问系列
    EmbeddingModelConfig(
      id: 'text-embedding-v3',
      name: 'Text Embedding V3',
      provider: 'qwen',
      defaultDimension: 1024,
      maxContext: 8192,
      description: '通义千问最新嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-v2',
      name: 'Text Embedding V2',
      provider: 'qwen',
      defaultDimension: 1536,
      maxContext: 2048,
      description: '通义千问V2嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-v1',
      name: 'Text Embedding V1',
      provider: 'qwen',
      defaultDimension: 1536,
      maxContext: 2048,
      description: '通义千问V1嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-async-v2',
      name: 'Text Embedding Async V2',
      provider: 'qwen',
      defaultDimension: 1536,
      maxContext: 2048,
      description: '通义千问异步V2嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'text-embedding-async-v1',
      name: 'Text Embedding Async V1',
      provider: 'qwen',
      defaultDimension: 1536,
      maxContext: 2048,
      description: '通义千问异步V1嵌入模型',
    ),

    // 字节跳动豆包系列
    EmbeddingModelConfig(
      id: 'Doubao-embedding',
      name: 'Doubao Embedding',
      provider: 'doubao',
      defaultDimension: 1024,
      maxContext: 4095,
      description: '豆包标准嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'Doubao-embedding-vision',
      name: 'Doubao Embedding Vision',
      provider: 'doubao',
      defaultDimension: 1024,
      maxContext: 8191,
      description: '豆包多模态嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'Doubao-embedding-large',
      name: 'Doubao Embedding Large',
      provider: 'doubao',
      defaultDimension: 1536,
      maxContext: 4095,
      description: '豆包大型嵌入模型',
    ),

    // 百度文心系列
    EmbeddingModelConfig(
      id: 'Embedding-V1',
      name: 'ERNIE Embedding V1',
      provider: 'baidu',
      defaultDimension: 384,
      maxContext: 384,
      description: '文心嵌入模型V1',
    ),
    EmbeddingModelConfig(
      id: 'tao-8k',
      name: 'TAO 8K',
      provider: 'baidu',
      defaultDimension: 1024,
      maxContext: 8192,
      description: '文心TAO 8K嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'embedding-2',
      name: 'ERNIE Embedding 2',
      provider: 'baidu',
      defaultDimension: 768,
      maxContext: 1024,
      description: '文心嵌入模型2.0',
    ),
    EmbeddingModelConfig(
      id: 'embedding-3',
      name: 'ERNIE Embedding 3',
      provider: 'baidu',
      defaultDimension: 1024,
      maxContext: 2048,
      description: '文心嵌入模型3.0',
    ),

    // 腾讯混元系列
    EmbeddingModelConfig(
      id: 'hunyuan-embedding',
      name: 'Hunyuan Embedding',
      provider: 'tencent',
      defaultDimension: 1024,
      maxContext: 1024,
      description: '腾讯混元嵌入模型',
    ),

    // 百川智能系列
    EmbeddingModelConfig(
      id: 'Baichuan-Text-Embedding',
      name: 'Baichuan Text Embedding',
      provider: 'baichuan',
      defaultDimension: 1024,
      maxContext: 512,
      description: '百川文本嵌入模型',
    ),

    // MiniMax系列
    EmbeddingModelConfig(
      id: 'M2-BERT-80M-2K-Retrieval',
      name: 'M2 BERT 80M 2K',
      provider: 'minimax',
      defaultDimension: 1536,
      maxContext: 2048,
      description: 'MiniMax 2K检索模型',
    ),
    EmbeddingModelConfig(
      id: 'M2-BERT-80M-8K-Retrieval',
      name: 'M2 BERT 80M 8K',
      provider: 'minimax',
      defaultDimension: 1536,
      maxContext: 8192,
      description: 'MiniMax 8K检索模型',
    ),
    EmbeddingModelConfig(
      id: 'M2-BERT-80M-32K-Retrieval',
      name: 'M2 BERT 80M 32K',
      provider: 'minimax',
      defaultDimension: 1536,
      maxContext: 32768,
      description: 'MiniMax 32K检索模型',
    ),

    // 深度求索系列
    EmbeddingModelConfig(
      id: 'UAE-Large-v1',
      name: 'UAE Large v1',
      provider: 'deepseek',
      defaultDimension: 1024,
      maxContext: 512,
      description: '深度求索UAE大型模型',
    ),

    // BGE系列 (智源研究院)
    EmbeddingModelConfig(
      id: 'BAAI/bge-m3',
      name: 'BGE M3',
      provider: 'bge',
      defaultDimension: 1024,
      maxContext: 8191,
      description: 'BGE M3多语言嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'Pro/BAAI/bge-m3',
      name: 'BGE M3 Pro',
      provider: 'bge',
      defaultDimension: 1024,
      maxContext: 8191,
      description: 'BGE M3专业版',
    ),
    EmbeddingModelConfig(
      id: 'BAAI/bge-large-zh-v1.5',
      name: 'BGE Large Chinese v1.5',
      provider: 'bge',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'BGE中文大型模型v1.5',
    ),
    EmbeddingModelConfig(
      id: 'BAAI/bge-large-en-v1.5',
      name: 'BGE Large English v1.5',
      provider: 'bge',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'BGE英文大型模型v1.5',
    ),
    EmbeddingModelConfig(
      id: 'BGE-Large-EN-v1.5',
      name: 'BGE Large EN v1.5',
      provider: 'bge',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'BGE英文大型模型v1.5',
    ),
    EmbeddingModelConfig(
      id: 'BGE-Base-EN-v1.5',
      name: 'BGE Base EN v1.5',
      provider: 'bge',
      defaultDimension: 768,
      maxContext: 512,
      description: 'BGE英文基础模型v1.5',
    ),
    EmbeddingModelConfig(
      id: 'netease-youdao/bce-embedding-base_v1',
      name: 'BCE Embedding Base v1',
      provider: 'netease',
      defaultDimension: 768,
      maxContext: 512,
      description: '网易有道BCE嵌入基础模型',
    ),

    // Jina AI系列
    EmbeddingModelConfig(
      id: 'jina-embedding-b-en-v1',
      name: 'Jina Embedding B EN v1',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 512,
      description: 'Jina英文嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v2-base-en',
      name: 'Jina Embeddings v2 Base EN',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina v2英文基础模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v2-base-zh',
      name: 'Jina Embeddings v2 Base ZH',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina v2中文基础模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v2-base-de',
      name: 'Jina Embeddings v2 Base DE',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina v2德文基础模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v2-base-code',
      name: 'Jina Embeddings v2 Base Code',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina v2代码嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v2-base-es',
      name: 'Jina Embeddings v2 Base ES',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina v2西班牙文模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-colbert-v1-en',
      name: 'Jina ColBERT v1 EN',
      provider: 'jina',
      defaultDimension: 128,
      maxContext: 8191,
      description: 'Jina ColBERT英文模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-colbert-v2',
      name: 'Jina ColBERT v2',
      provider: 'jina',
      defaultDimension: 128,
      maxContext: 8191,
      description: 'Jina ColBERT v2模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-embeddings-v3',
      name: 'Jina Embeddings v3',
      provider: 'jina',
      defaultDimension: 1024,
      maxContext: 8191,
      description: 'Jina v3最新嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'jina-clip-v1',
      name: 'Jina CLIP v1',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 8191,
      description: 'Jina多模态CLIP模型',
    ),
    EmbeddingModelConfig(
      id: 'reader-lm-1.5b',
      name: 'Reader LM 1.5B',
      provider: 'jina',
      defaultDimension: 1024,
      maxContext: 256000,
      description: 'Jina Reader LM大模型',
    ),
    EmbeddingModelConfig(
      id: 'reader-lm-0.5b',
      name: 'Reader LM 0.5B',
      provider: 'jina',
      defaultDimension: 768,
      maxContext: 256000,
      description: 'Jina Reader LM中型模型',
    ),

    // Nomic系列
    EmbeddingModelConfig(
      id: 'nomic-embed-text-v1',
      name: 'Nomic Embed Text v1',
      provider: 'nomic',
      defaultDimension: 768,
      maxContext: 8192,
      description: 'Nomic文本嵌入v1',
    ),
    EmbeddingModelConfig(
      id: 'nomic-embed-text-v1.5',
      name: 'Nomic Embed Text v1.5',
      provider: 'nomic',
      defaultDimension: 768,
      maxContext: 8192,
      description: 'Nomic文本嵌入v1.5',
    ),

    // GTE系列
    EmbeddingModelConfig(
      id: 'gte-multilingual-base',
      name: 'GTE Multilingual Base',
      provider: 'gte',
      defaultDimension: 768,
      maxContext: 8192,
      description: 'GTE多语言基础模型',
    ),

    // Cohere系列
    EmbeddingModelConfig(
      id: 'embed-english-v3.0',
      name: 'Embed English v3.0',
      provider: 'cohere',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'Cohere英文嵌入v3.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-english-light-v3.0',
      name: 'Embed English Light v3.0',
      provider: 'cohere',
      defaultDimension: 384,
      maxContext: 512,
      description: 'Cohere英文轻量v3.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-multilingual-v3.0',
      name: 'Embed Multilingual v3.0',
      provider: 'cohere',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'Cohere多语言v3.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-multilingual-light-v3.0',
      name: 'Embed Multilingual Light v3.0',
      provider: 'cohere',
      defaultDimension: 384,
      maxContext: 512,
      description: 'Cohere多语言轻量v3.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-english-v2.0',
      name: 'Embed English v2.0',
      provider: 'cohere',
      defaultDimension: 4096,
      maxContext: 512,
      description: 'Cohere英文嵌入v2.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-english-light-v2.0',
      name: 'Embed English Light v2.0',
      provider: 'cohere',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'Cohere英文轻量v2.0',
    ),
    EmbeddingModelConfig(
      id: 'embed-multilingual-v2.0',
      name: 'Embed Multilingual v2.0',
      provider: 'cohere',
      defaultDimension: 768,
      maxContext: 256,
      description: 'Cohere多语言v2.0',
    ),
    EmbeddingModelConfig(
      id: 'embedding-query',
      name: 'Embedding Query',
      provider: 'cohere',
      defaultDimension: 1024,
      maxContext: 4000,
      description: 'Cohere查询嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'embedding-passage',
      name: 'Embedding Passage',
      provider: 'cohere',
      defaultDimension: 1024,
      maxContext: 4000,
      description: 'Cohere段落嵌入模型',
    ),

    // Google系列
    EmbeddingModelConfig(
      id: 'text-embedding-004',
      name: 'Text Embedding 004',
      provider: 'google',
      defaultDimension: 768,
      maxContext: 2048,
      description: 'Google文本嵌入004',
    ),

    // MixedBread系列
    EmbeddingModelConfig(
      id: 'deepset-mxbai-embed-de-large-v1',
      name: 'MXBAI Embed DE Large v1',
      provider: 'mixedbread',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'MixedBread德文大型模型',
    ),
    EmbeddingModelConfig(
      id: 'mxbai-embed-large-v1',
      name: 'MXBAI Embed Large v1',
      provider: 'mixedbread',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'MixedBread大型嵌入模型',
    ),
    EmbeddingModelConfig(
      id: 'mxbai-embed-2d-large-v1',
      name: 'MXBAI Embed 2D Large v1',
      provider: 'mixedbread',
      defaultDimension: 1024,
      maxContext: 512,
      description: 'MixedBread 2D大型模型',
    ),

    // Mistral系列
    EmbeddingModelConfig(
      id: 'mistral-embed',
      name: 'Mistral Embed',
      provider: 'mistral',
      defaultDimension: 1024,
      maxContext: 8000,
      description: 'Mistral嵌入模型',
    ),

    // Voyage AI系列
    EmbeddingModelConfig(
      id: 'voyage-3-large',
      name: 'Voyage 3 Large',
      provider: 'voyageai',
      defaultDimension: 1024,
      maxContext: 2048,
      description: 'Voyage 3大型模型',
    ),
    EmbeddingModelConfig(
      id: 'voyage-3',
      name: 'Voyage 3',
      provider: 'voyageai',
      defaultDimension: 1024,
      maxContext: 1024,
      description: 'Voyage 3标准模型',
    ),
    EmbeddingModelConfig(
      id: 'voyage-3-lite',
      name: 'Voyage 3 Lite',
      provider: 'voyageai',
      defaultDimension: 512,
      maxContext: 512,
      description: 'Voyage 3轻量模型',
    ),
    EmbeddingModelConfig(
      id: 'voyage-code-3',
      name: 'Voyage Code 3',
      provider: 'voyageai',
      defaultDimension: 1024,
      maxContext: 1024,
      description: 'Voyage代码嵌入v3',
    ),
    EmbeddingModelConfig(
      id: 'voyage-code-2',
      name: 'Voyage Code 2',
      provider: 'voyageai',
      defaultDimension: 1536,
      maxContext: 1536,
      description: 'Voyage代码嵌入v2',
    ),
    EmbeddingModelConfig(
      id: 'voyage-finance-2',
      name: 'Voyage Finance 2',
      provider: 'voyageai',
      defaultDimension: 1024,
      maxContext: 1024,
      description: 'Voyage金融嵌入v2',
    ),
    EmbeddingModelConfig(
      id: 'voyage-law-2',
      name: 'Voyage Law 2',
      provider: 'voyageai',
      defaultDimension: 1024,
      maxContext: 1024,
      description: 'Voyage法律嵌入v2',
    ),
  ];

  /// 根据模型ID获取配置
  static EmbeddingModelConfig? getConfig(String modelId) {
    try {
      return allModels.firstWhere((model) => model.id == modelId);
    } catch (e) {
      return null;
    }
  }

  /// 根据提供商获取所有模型
  static List<EmbeddingModelConfig> getModelsByProvider(String provider) {
    return allModels.where((model) => 
      model.provider.toLowerCase() == provider.toLowerCase()).toList();
  }

  /// 获取模型的默认维度
  static int? getDefaultDimension(String modelId) {
    final config = getConfig(modelId);
    return config?.defaultDimension;
  }

  /// 获取模型的最大上下文长度
  static int? getMaxContext(String modelId) {
    final config = getConfig(modelId);
    return config?.maxContext;
  }

  /// 检查模型是否支持动态维度
  static bool supportsDynamicDimension(String modelId) {
    final config = getConfig(modelId);
    return config?.supportsDynamicDimension ?? false;
  }

  /// 获取支持的维度列表
  static List<int>? getSupportedDimensions(String modelId) {
    final config = getConfig(modelId);
    return config?.supportedDimensions;
  }

  /// 获取所有提供商列表
  static List<String> getAllProviders() {
    return allModels.map((model) => model.provider).toSet().toList()..sort();
  }

  /// 获取推荐维度（基于性能和兼容性考虑）
  static int getRecommendedDimension(String modelId) {
    final config = getConfig(modelId);
    if (config == null) {
      return 1536; // 默认使用OpenAI兼容维度
    }

    // 对于支持动态维度的模型，推荐使用1536（OpenAI兼容）
    if (config.supportsDynamicDimension && 
        config.supportedDimensions?.contains(1536) == true) {
      return 1536;
    }

    // 否则使用模型的默认维度
    return config.defaultDimension;
  }
}