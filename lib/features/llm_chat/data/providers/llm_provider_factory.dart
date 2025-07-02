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
  /// 创建LLM Provider实例
  static LlmProvider createProvider(LlmConfig config) {
    switch (config.provider.toLowerCase()) {
      case 'openai':
        return OpenAiLlmProvider(config);
      case 'google':
        return GoogleLlmProvider(config);
      case 'anthropic':
        return AnthropicLlmProvider(config);

      default:
        throw ApiException('不支持的AI供应商: ${config.provider}');
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
    }
  }

  /// 获取支持的供应商列表
  static List<String> getSupportedProviders() {
    return ['openai', 'google', 'anthropic'];
  }

  /// 检查供应商是否支持
  static bool isProviderSupported(String provider) {
    return getSupportedProviders().contains(provider.toLowerCase());
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

      default:
        return provider;
    }
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

      default:
        return '未知供应商';
    }
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

      default:
        return [];
    }
  }

  /// 验证供应商配置
  static bool validateProviderConfig(LlmConfig config) {
    final requiredFields = getProviderRequiredFields(config.provider);

    // 检查API密钥
    if (requiredFields.contains('apiKey') && config.apiKey.isEmpty) {
      return false;
    }

    return true;
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

  const ProviderInfo({
    required this.id,
    required this.displayName,
    required this.description,
    this.defaultModel,
    this.defaultEmbeddingModel,
    required this.requiredFields,
    required this.optionalFields,
    required this.isSupported,
  });

  @override
  String toString() {
    return 'ProviderInfo(id: $id, displayName: $displayName, isSupported: $isSupported)';
  }
}
