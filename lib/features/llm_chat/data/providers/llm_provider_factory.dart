import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/llm_provider.dart';
import 'openai_llm_provider.dart';
import 'google_llm_provider.dart';
import 'anthropic_llm_provider.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../settings/domain/entities/app_settings.dart';

/// LLM Provider工厂
///
/// 负责根据配置创建相应的LLM Provider实例
class LlmProviderFactory {
  // Provider 缓存，避免重复创建实例
  static final Map<String, LlmProvider> _providerCache = {};

  /// 创建LLM Provider实例
  static LlmProvider createProvider(LlmConfig config) {
    final cacheKey = '${config.provider}_${config.apiKey.hashCode}';

    // 优先返回缓存实例
    final cached = _providerCache[cacheKey];
    if (cached != null) return cached;

    late final LlmProvider provider;

    // 对于自定义提供商，根据API兼容性类型创建Provider
    if (config.isCustomProvider) {
      provider = _createProviderByCompatibility(config);
    } else {
      // 内置提供商的处理逻辑
      switch (config.provider.toLowerCase()) {
        case 'openai':
          provider = OpenAiLlmProvider(config);
          break;
        case 'google':
          provider = GoogleLlmProvider(config);
          break;
        case 'anthropic':
          provider = AnthropicLlmProvider(config);
          break;
        case 'deepseek':
        case 'qwen':
        case 'openrouter':
        case 'ollama':
          // 这些提供商使用OpenAI兼容的API
          provider = OpenAiLlmProvider(config);
          break;
        default:
          throw ApiException('不支持的AI供应商: ${config.provider}');
      }
    }

    _providerCache[cacheKey] = provider;
    return provider;
  }

  /// 根据API兼容性类型创建Provider
  static LlmProvider _createProviderByCompatibility(LlmConfig config) {
    switch (config.apiCompatibilityType.toLowerCase()) {
      case 'openai':
        return OpenAiLlmProvider(config);
      case 'gemini':
        return GoogleLlmProvider(config);
      case 'anthropic':
        return AnthropicLlmProvider(config);
      default:
        // 默认使用OpenAI兼容
        return OpenAiLlmProvider(config);
    }
  }

  /// 从AppSettings创建LLM Provider实例
  static LlmProvider createProviderFromSettings(
    AIProvider provider,
    AppSettings settings,
  ) {
    switch (provider) {
      case AIProvider.openai:
        final config = settings.openaiConfig;
        if (config == null) {
          throw ApiException('OpenAI configuration not found');
        }
        final now = DateTime.now();
        final llmConfig = LlmConfig(
          id: 'openai-${now.millisecondsSinceEpoch}',
          name: 'OpenAI Configuration',
          provider: 'openai',
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
          defaultModel: config.defaultModel,
          organizationId: config.organizationId,
          createdAt: now,
          updatedAt: now,
        );
        return OpenAiLlmProvider(llmConfig);

      case AIProvider.gemini:
        final config = settings.geminiConfig;
        if (config == null) {
          throw ApiException('Google Gemini configuration not found');
        }
        final now = DateTime.now();
        final llmConfig = LlmConfig(
          id: 'google-${now.millisecondsSinceEpoch}',
          name: 'Google Gemini Configuration',
          provider: 'google',
          apiKey: config.apiKey,
          createdAt: now,
          updatedAt: now,
        );
        return GoogleLlmProvider(llmConfig);

      case AIProvider.claude:
        final config = settings.claudeConfig;
        if (config == null) {
          throw ApiException('Anthropic Claude configuration not found');
        }
        final now = DateTime.now();
        final llmConfig = LlmConfig(
          id: 'anthropic-${now.millisecondsSinceEpoch}',
          name: 'Anthropic Claude Configuration',
          provider: 'anthropic',
          apiKey: config.apiKey,
          createdAt: now,
          updatedAt: now,
        );
        return AnthropicLlmProvider(llmConfig);

      case AIProvider.deepseek:
      case AIProvider.qwen:
      case AIProvider.openrouter:
      case AIProvider.ollama:
        // 新的提供商暂时抛出异常，需要通过数据库配置
        throw ApiException('${provider.toString()} 需要通过模型管理界面进行配置');
    }
  }

  /// 获取支持的供应商列表
  static List<String> getSupportedProviders() {
    return [
      'openai',
      'google',
      'anthropic',
      'deepseek',
      'qwen',
      'openrouter',
      'ollama',
    ];
  }

  /// 检查供应商是否支持
  static bool isProviderSupported(String provider) {
    return getSupportedProviders().contains(provider.toLowerCase());
  }

  /// 检查是否为内置提供商
  static bool isBuiltinProvider(String provider) {
    return getSupportedProviders().contains(provider.toLowerCase());
  }

  /// 检查是否为自定义提供商
  static bool isCustomProvider(String provider) {
    return !isBuiltinProvider(provider);
  }

  /// 获取供应商的默认模型
  static String? getDefaultModel(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return 'gpt-3.5-turbo';
      case 'google':
        return 'gemini-pro';
      case 'anthropic':
        return 'claude-3-sonnet-20240229';
      case 'deepseek':
        return 'deepseek-chat';
      case 'qwen':
        return 'qwen-turbo';
      case 'openrouter':
        return 'meta-llama/llama-3.1-8b-instruct:free';
      case 'ollama':
        return 'llama3.2';

      default:
        return null;
    }
  }

  /// 获取供应商的默认嵌入模型
  static String? getDefaultEmbeddingModel(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return 'text-embedding-3-small';
      case 'google':
        return 'embedding-001';
      case 'anthropic':
        return null; // Anthropic目前不提供嵌入模型
      case 'deepseek':
        return 'deepseek-embedding';
      case 'qwen':
        return 'text-embedding-v1';
      case 'openrouter':
        return null; // OpenRouter支持多种嵌入模型，需要用户选择
      case 'ollama':
        return null; // Ollama支持多种嵌入模型，需要用户选择

      default:
        return null;
    }
  }

  /// 获取供应商的显示名称
  static String getProviderDisplayName(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return 'OpenAI';
      case 'google':
        return 'Google Gemini';
      case 'anthropic':
        return 'Anthropic Claude';
      case 'deepseek':
        return 'DeepSeek';
      case 'qwen':
        return '阿里云通义千问';
      case 'openrouter':
        return 'OpenRouter';
      case 'ollama':
        return 'Ollama';

      default:
        return provider;
    }
  }

  /// 获取自定义提供商的显示名称
  static String getCustomProviderDisplayName(LlmConfig config) {
    if (config.isCustomProvider && config.customProviderName != null) {
      return config.customProviderName!;
    }
    return getProviderDisplayName(config.provider);
  }

  /// 获取供应商的描述
  static String getProviderDescription(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return 'OpenAI的GPT系列模型，包括GPT-3.5和GPT-4';
      case 'google':
        return 'Google的Gemini系列模型，支持多模态输入';
      case 'anthropic':
        return 'Anthropic的Claude系列模型，注重安全性和有用性';
      case 'deepseek':
        return 'DeepSeek的高性能大语言模型，支持推理和代码生成';
      case 'qwen':
        return '阿里云通义千问系列模型，支持中文和多语言对话';
      case 'openrouter':
        return 'OpenRouter聚合平台，提供多种AI模型的统一接口';
      case 'ollama':
        return 'Ollama本地模型运行平台，支持私有化部署';

      default:
        return '未知供应商';
    }
  }

  /// 获取自定义提供商的描述
  static String getCustomProviderDescription(LlmConfig config) {
    if (config.isCustomProvider && config.customProviderDescription != null) {
      return config.customProviderDescription!;
    }
    return getProviderDescription(config.provider);
  }

  /// 获取供应商的配置要求
  static List<String> getProviderRequiredFields(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return ['apiKey'];
      case 'google':
        return ['apiKey'];
      case 'anthropic':
        return ['apiKey'];
      case 'deepseek':
        return ['apiKey'];
      case 'qwen':
        return ['apiKey'];
      case 'openrouter':
        return ['apiKey'];
      case 'ollama':
        return []; // Ollama本地运行，不需要API密钥

      default:
        return ['apiKey'];
    }
  }

  /// 获取供应商的可选字段
  static List<String> getProviderOptionalFields(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return ['baseUrl', 'organizationId'];
      case 'google':
        return ['baseUrl'];
      case 'anthropic':
        return ['baseUrl'];
      case 'deepseek':
        return ['baseUrl'];
      case 'qwen':
        return ['baseUrl'];
      case 'openrouter':
        return ['baseUrl'];
      case 'ollama':
        return ['baseUrl']; // Ollama可以配置自定义端点

      default:
        return [];
    }
  }

  /// 获取供应商的默认端点
  static String? getProviderDefaultEndpoint(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return 'https://api.openai.com/v1';
      case 'google':
        return 'https://generativelanguage.googleapis.com/v1beta';
      case 'anthropic':
        return 'https://api.anthropic.com';
      case 'deepseek':
        return 'https://api.deepseek.com';
      case 'qwen':
        return 'https://dashscope.aliyuncs.com/compatible-mode/v1';
      case 'openrouter':
        return 'https://openrouter.ai/api/v1';
      case 'ollama':
        return 'http://localhost:11434/v1';

      default:
        return null;
    }
  }

  /// 获取供应商的API兼容性类型
  static String getProviderCompatibilityType(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
      case 'deepseek':
      case 'qwen':
      case 'openrouter':
      case 'ollama':
        return 'openai';
      case 'google':
        return 'gemini';
      case 'anthropic':
        return 'anthropic';

      default:
        return 'openai'; // 默认使用OpenAI兼容
    }
  }

  /// 验证供应商配置
  static bool validateProviderConfig(LlmConfig config) {
    // 对于自定义提供商，使用不同的验证逻辑
    if (config.isCustomProvider) {
      return _validateCustomProviderConfig(config);
    }

    final requiredFields = getProviderRequiredFields(config.provider);

    // 检查API密钥
    if (requiredFields.contains('apiKey') && config.apiKey.isEmpty) {
      return false;
    }

    return true;
  }

  /// 验证自定义提供商配置
  static bool _validateCustomProviderConfig(LlmConfig config) {
    // 检查必需字段
    if (config.apiKey.isEmpty) {
      return false;
    }

    if (config.customProviderName?.isEmpty != false) {
      return false;
    }

    // 检查API兼容性类型
    if (!getSupportedCompatibilityTypes().contains(
      config.apiCompatibilityType,
    )) {
      return false;
    }

    // 检查baseUrl格式
    if (config.baseUrl != null && config.baseUrl!.isNotEmpty) {
      final uri = Uri.tryParse(config.baseUrl!);
      if (uri == null || !uri.hasAbsolutePath) {
        return false;
      }
    }

    return true;
  }

  /// 异步验证提供商连接
  static Future<bool> validateProviderConnection(LlmConfig config) async {
    try {
      final provider = createProvider(config);
      return await provider.validateConfig();
    } catch (e) {
      return false;
    }
  }

  /// 创建自定义提供商配置
  static LlmConfig createCustomProviderConfig({
    required String id,
    required String name,
    required String customProviderName,
    required String apiKey,
    required String apiCompatibilityType,
    String? baseUrl,
    String? customProviderDescription,
    String? customProviderIcon,
    String? defaultModel,
    String? defaultEmbeddingModel,
  }) {
    final now = DateTime.now();
    return LlmConfig(
      id: id,
      name: name,
      provider: 'custom-$id', // 自定义提供商使用特殊的provider标识
      apiKey: apiKey,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      defaultEmbeddingModel: defaultEmbeddingModel,
      createdAt: now,
      updatedAt: now,
      isCustomProvider: true,
      apiCompatibilityType: apiCompatibilityType,
      customProviderName: customProviderName,
      customProviderDescription: customProviderDescription,
      customProviderIcon: customProviderIcon,
    );
  }

  /// 获取支持的API兼容性类型
  static List<String> getSupportedCompatibilityTypes() {
    return ['openai', 'gemini', 'anthropic'];
  }

  /// 获取API兼容性类型的显示名称
  static String getCompatibilityTypeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'openai':
        return 'OpenAI API 兼容';
      case 'gemini':
        return 'Gemini API 兼容';
      case 'anthropic':
        return 'Anthropic API 兼容';
      default:
        return type;
    }
  }

  /// 释放并清理所有缓存的 Provider
  static void clearCache() {
    for (final provider in _providerCache.values) {
      provider.dispose();
    }
    _providerCache.clear();
  }
}

/// LLM Provider工厂Provider
final llmProviderFactoryProvider = Provider<LlmProviderFactory>((ref) {
  return LlmProviderFactory();
});

/// 根据配置创建LLM Provider的Provider
final llmProviderProvider = Provider.family<LlmProvider, LlmConfig>((
  ref,
  config,
) {
  return LlmProviderFactory.createProvider(config);
});

/// 支持的供应商列表Provider
final supportedProvidersProvider = Provider<List<String>>((ref) {
  return LlmProviderFactory.getSupportedProviders();
});

/// 供应商信息Provider
final providerInfoProvider = Provider.family<ProviderInfo, String>((
  ref,
  provider,
) {
  return ProviderInfo(
    id: provider,
    displayName: LlmProviderFactory.getProviderDisplayName(provider),
    description: LlmProviderFactory.getProviderDescription(provider),
    defaultModel: LlmProviderFactory.getDefaultModel(provider),
    defaultEmbeddingModel: LlmProviderFactory.getDefaultEmbeddingModel(
      provider,
    ),
    requiredFields: LlmProviderFactory.getProviderRequiredFields(provider),
    optionalFields: LlmProviderFactory.getProviderOptionalFields(provider),
    isSupported: LlmProviderFactory.isProviderSupported(provider),
  );
});

/// 供应商信息模型
class ProviderInfo {
  final String id;
  final String displayName;
  final String description;
  final String? defaultModel;
  final String? defaultEmbeddingModel;
  final List<String> requiredFields;
  final List<String> optionalFields;
  final bool isSupported;
  final bool isCustomProvider;
  final String? apiCompatibilityType;
  final String? customProviderIcon;

  const ProviderInfo({
    required this.id,
    required this.displayName,
    required this.description,
    this.defaultModel,
    this.defaultEmbeddingModel,
    required this.requiredFields,
    required this.optionalFields,
    required this.isSupported,
    this.isCustomProvider = false,
    this.apiCompatibilityType,
    this.customProviderIcon,
  });

  @override
  String toString() {
    return 'ProviderInfo(id: $id, displayName: $displayName, isSupported: $isSupported, isCustomProvider: $isCustomProvider)';
  }
}

/// 从LlmConfig创建ProviderInfo
ProviderInfo createProviderInfoFromConfig(LlmConfig config) {
  return ProviderInfo(
    id: config.id,
    displayName: LlmProviderFactory.getCustomProviderDisplayName(config),
    description: LlmProviderFactory.getCustomProviderDescription(config),
    defaultModel: config.defaultModel,
    defaultEmbeddingModel: config.defaultEmbeddingModel,
    requiredFields: config.isCustomProvider
        ? ['apiKey']
        : LlmProviderFactory.getProviderRequiredFields(config.provider),
    optionalFields: config.isCustomProvider
        ? ['baseUrl']
        : LlmProviderFactory.getProviderOptionalFields(config.provider),
    isSupported: true,
    isCustomProvider: config.isCustomProvider,
    apiCompatibilityType: config.apiCompatibilityType,
    customProviderIcon: config.customProviderIcon,
  );
}
