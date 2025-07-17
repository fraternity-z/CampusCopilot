import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/providers/llm_provider_factory.dart';
import '../providers/llm_provider.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/di/database_providers.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

/// 模型管理服务
///
/// 负责管理自定义模型和内置模型的CRUD操作
class ModelManagementService {
  final AppDatabase _database;
  final Ref? _ref;

  ModelManagementService(this._database, [this._ref]);

  /// 获取所有模型（内置 + 自定义）
  Future<List<ModelInfo>> getAllModels() async {
    final customModels = await _database.getAllCustomModels();
    return customModels.map(_convertToModelInfo).toList();
  }

  /// 根据提供商获取模型
  Future<List<ModelInfo>> getModelsByProvider(String provider) async {
    final customModels = await _database.getCustomModelsByProvider(provider);
    return customModels.map(_convertToModelInfo).toList();
  }

  /// 获取启用的模型
  Future<List<ModelInfo>> getEnabledModels() async {
    final customModels = await _database.getEnabledCustomModels();
    return customModels.map(_convertToModelInfo).toList();
  }

  /// 添加自定义模型
  Future<void> addCustomModel({
    required String name,
    required String modelId,
    required String provider,
    String? configId,
    String? description,
    required ModelType type,
    int? contextWindow,
    int? maxOutputTokens,
    bool supportsStreaming = true,
    bool supportsFunctionCalling = false,
    bool supportsVision = false,
    double? inputPrice,
    double? outputPrice,
    String currency = 'USD',
    List<String> capabilities = const [],
  }) async {
    // 检查是否已存在相同的模型（基于 modelId 和 provider）
    final existingModels = await _database.getAllCustomModels();
    final duplicateModel = existingModels
        .where(
          (model) =>
              model.modelId == modelId &&
              model.provider.toLowerCase() == provider.toLowerCase(),
        )
        .firstOrNull;

    if (duplicateModel != null) {
      debugPrint('⚠️ 模型已存在，跳过添加: $modelId ($provider)');
      return; // 如果模型已存在，直接返回，不抛出异常
    }

    final now = DateTime.now();
    final id = 'custom-${provider.toLowerCase()}-${now.millisecondsSinceEpoch}';

    final model = CustomModelsTableCompanion.insert(
      id: id,
      name: name,
      modelId: modelId,
      provider: provider.toLowerCase(),
      configId: configId != null ? Value(configId) : const Value.absent(),
      description: description != null
          ? Value(description)
          : const Value.absent(),
      type: type.name,
      contextWindow: Value(contextWindow),
      maxOutputTokens: Value(maxOutputTokens),
      supportsStreaming: Value(supportsStreaming),
      supportsFunctionCalling: Value(supportsFunctionCalling),
      supportsVision: Value(supportsVision),
      inputPrice: Value(inputPrice),
      outputPrice: Value(outputPrice),
      currency: Value(currency),
      capabilities: Value(
        capabilities.isNotEmpty ? jsonEncode(capabilities) : null,
      ),
      isBuiltIn: const Value(false),
      createdAt: now,
      updatedAt: now,
    );

    await _database.upsertCustomModel(model);
    debugPrint('✅ 成功添加模型: $name ($modelId)');

    // 触发模型列表刷新
    _triggerModelListRefresh();
  }

  /// 更新自定义模型
  Future<void> updateCustomModel({
    required String id,
    String? name,
    String? modelId,
    String? description,
    ModelType? type,
    int? contextWindow,
    int? maxOutputTokens,
    bool? supportsStreaming,
    bool? supportsFunctionCalling,
    bool? supportsVision,
    double? inputPrice,
    double? outputPrice,
    String? currency,
    List<String>? capabilities,
    bool? isEnabled,
    String? configId,
  }) async {
    // 首先尝试通过数据库主键ID查找
    CustomModelsTableData? existingModel = await _database.getCustomModelById(
      id,
    );

    // 如果没找到，尝试通过modelId查找（兼容性处理）
    if (existingModel == null) {
      final allModels = await _database.getAllCustomModels();
      existingModel = allModels.where((m) => m.modelId == id).firstOrNull;
    }

    if (existingModel == null) {
      throw DatabaseException('模型不存在: $id');
    }

    final model = CustomModelsTableCompanion(
      id: Value(existingModel.id), // 使用找到的模型的数据库主键ID
      name: name != null ? Value(name) : const Value.absent(),
      modelId: modelId != null ? Value(modelId) : const Value.absent(),
      description: description != null
          ? Value(description)
          : const Value.absent(),
      type: type != null ? Value(type.name) : const Value.absent(),
      contextWindow: contextWindow != null
          ? Value(contextWindow)
          : const Value.absent(),
      maxOutputTokens: maxOutputTokens != null
          ? Value(maxOutputTokens)
          : const Value.absent(),
      supportsStreaming: supportsStreaming != null
          ? Value(supportsStreaming)
          : const Value.absent(),
      supportsFunctionCalling: supportsFunctionCalling != null
          ? Value(supportsFunctionCalling)
          : const Value.absent(),
      supportsVision: supportsVision != null
          ? Value(supportsVision)
          : const Value.absent(),
      inputPrice: inputPrice != null ? Value(inputPrice) : const Value.absent(),
      outputPrice: outputPrice != null
          ? Value(outputPrice)
          : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      configId: configId != null ? Value(configId) : const Value.absent(),
      capabilities: capabilities != null
          ? Value(capabilities.isNotEmpty ? jsonEncode(capabilities) : null)
          : const Value.absent(),
      isEnabled: isEnabled != null ? Value(isEnabled) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await _database.upsertCustomModel(model);

    // 触发模型列表刷新
    _triggerModelListRefresh();
  }

  /// 删除自定义模型
  Future<void> deleteCustomModel(String modelId) async {
    debugPrint('🗑️ 尝试删除模型: $modelId');

    // 通过modelId查找数据库记录
    final allModels = await _database.getAllCustomModels();
    debugPrint('🗑️ 数据库中共有 ${allModels.length} 个模型');

    final existingModel = allModels
        .where((m) => m.modelId == modelId)
        .firstOrNull;

    if (existingModel == null) {
      debugPrint('🗑️ 未找到模型: $modelId');
      debugPrint('🗑️ 可用的模型ID: ${allModels.map((m) => m.modelId).join(', ')}');
      throw DatabaseException('模型不存在: $modelId');
    }

    debugPrint('🗑️ 找到模型: ${existingModel.name} (数据库ID: ${existingModel.id})');

    if (existingModel.isBuiltIn) {
      throw Exception('不能删除内置模型');
    }

    // 使用数据库主键ID删除
    await _database.deleteCustomModel(existingModel.id);
    debugPrint('🗑️ 模型删除成功: ${existingModel.name}');

    // 触发模型列表刷新
    _triggerModelListRefresh();
  }

  /// 从API获取模型列表
  Future<List<ModelInfo>> fetchModelsFromAPI(LlmConfig config) async {
    try {
      final provider = LlmProviderFactory.createProvider(config);
      return await provider.listModels();
    } catch (e) {
      throw ApiException('获取模型列表失败: ${e.toString()}');
    }
  }

  /// 同步内置模型到数据库
  Future<void> syncBuiltInModels() async {
    final providers = ['openai', 'google', 'anthropic'];
    final allBuiltInModels = <CustomModelsTableCompanion>[];

    for (final provider in providers) {
      final models = _getBuiltInModelsForProvider(provider);
      allBuiltInModels.addAll(models);
    }

    await _database.insertBuiltInModels(allBuiltInModels);
  }

  /// 获取提供商的内置模型
  List<CustomModelsTableCompanion> _getBuiltInModelsForProvider(
    String provider,
  ) {
    final now = DateTime.now();

    switch (provider.toLowerCase()) {
      case 'openai':
        return [
          CustomModelsTableCompanion.insert(
            id: 'builtin-openai-gpt-3.5-turbo',
            name: 'GPT-3.5 Turbo',
            modelId: 'gpt-3.5-turbo',
            provider: 'openai',
            description: Value('OpenAI的GPT-3.5 Turbo模型，快速且经济实惠'),
            type: ModelType.chat.name,
            contextWindow: const Value(4096),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(true),
            supportsVision: const Value(false),
            inputPrice: const Value(0.0015),
            outputPrice: const Value(0.002),
            capabilities: const Value('["chat", "function_calling"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-openai-gpt-4',
            name: 'GPT-4',
            modelId: 'gpt-4',
            provider: 'openai',
            description: Value('OpenAI的GPT-4模型，更强大的推理能力'),
            type: ModelType.chat.name,
            contextWindow: const Value(8192),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(true),
            supportsVision: const Value(false),
            inputPrice: const Value(0.03),
            outputPrice: const Value(0.06),
            capabilities: const Value('["chat", "function_calling"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-openai-gpt-4-turbo',
            name: 'GPT-4 Turbo',
            modelId: 'gpt-4-turbo',
            provider: 'openai',
            description: Value('OpenAI的GPT-4 Turbo模型，更大的上下文窗口'),
            type: ModelType.chat.name,
            contextWindow: const Value(128000),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(true),
            supportsVision: const Value(true),
            inputPrice: const Value(0.01),
            outputPrice: const Value(0.03),
            capabilities: const Value('["chat", "function_calling", "vision"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-openai-text-embedding-3-small',
            name: 'Text Embedding 3 Small',
            modelId: 'text-embedding-3-small',
            provider: 'openai',
            description: Value('OpenAI的文本嵌入模型'),
            type: ModelType.embedding.name,
            contextWindow: const Value(8191),
            supportsStreaming: const Value(false),
            supportsFunctionCalling: const Value(false),
            supportsVision: const Value(false),
            inputPrice: const Value(0.00002),
            capabilities: const Value('["embedding"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'google':
        return [
          CustomModelsTableCompanion.insert(
            id: 'builtin-google-gemini-pro',
            name: 'Gemini Pro',
            modelId: 'gemini-pro',
            provider: 'google',
            description: Value('Google的Gemini Pro模型'),
            type: ModelType.chat.name,
            contextWindow: const Value(30720),
            maxOutputTokens: const Value(2048),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(true),
            supportsVision: const Value(false),
            capabilities: const Value('["chat", "function_calling"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-google-gemini-1.5-pro',
            name: 'Gemini 1.5 Pro',
            modelId: 'gemini-1.5-pro-latest',
            provider: 'google',
            description: Value('Google的Gemini 1.5 Pro模型，支持超长上下文'),
            type: ModelType.multimodal.name,
            contextWindow: const Value(1000000),
            maxOutputTokens: const Value(8192),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(true),
            supportsVision: const Value(true),
            capabilities: const Value(
              '["chat", "function_calling", "vision", "multimodal"]',
            ),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        ];

      case 'anthropic':
        return [
          CustomModelsTableCompanion.insert(
            id: 'builtin-anthropic-claude-3-haiku',
            name: 'Claude 3 Haiku',
            modelId: 'claude-3-haiku-20240307',
            provider: 'anthropic',
            description: Value('Anthropic的Claude 3 Haiku模型，快速且经济'),
            type: ModelType.chat.name,
            contextWindow: const Value(200000),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(false),
            supportsVision: const Value(true),
            inputPrice: const Value(0.00025),
            outputPrice: const Value(0.00125),
            capabilities: const Value('["chat", "vision"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-anthropic-claude-3-sonnet',
            name: 'Claude 3 Sonnet',
            modelId: 'claude-3-sonnet-20240229',
            provider: 'anthropic',
            description: Value('Anthropic的Claude 3 Sonnet模型，平衡性能和成本'),
            type: ModelType.chat.name,
            contextWindow: const Value(200000),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(false),
            supportsVision: const Value(true),
            inputPrice: const Value(0.003),
            outputPrice: const Value(0.015),
            capabilities: const Value('["chat", "vision"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          CustomModelsTableCompanion.insert(
            id: 'builtin-anthropic-claude-3-opus',
            name: 'Claude 3 Opus',
            modelId: 'claude-3-opus-20240229',
            provider: 'anthropic',
            description: Value('Anthropic的Claude 3 Opus模型，最强大的推理能力'),
            type: ModelType.chat.name,
            contextWindow: const Value(200000),
            maxOutputTokens: const Value(4096),
            supportsStreaming: const Value(true),
            supportsFunctionCalling: const Value(false),
            supportsVision: const Value(true),
            inputPrice: const Value(0.015),
            outputPrice: const Value(0.075),
            capabilities: const Value('["chat", "vision"]'),
            isBuiltIn: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        ];

      default:
        return [];
    }
  }

  /// 转换数据库模型到域模型
  ModelInfo _convertToModelInfo(CustomModelsTableData data) {
    List<String> capabilities = [];
    if (data.capabilities != null) {
      try {
        capabilities = List<String>.from(jsonDecode(data.capabilities!));
      } catch (e) {
        // 忽略解析错误
      }
    }

    PricingInfo? pricing;
    if (data.inputPrice != null || data.outputPrice != null) {
      pricing = PricingInfo(
        inputPrice: data.inputPrice,
        outputPrice: data.outputPrice,
        currency: data.currency,
      );
    }

    return ModelInfo(
      id: data.modelId, // 恢复使用modelId以保持兼容性
      name: data.name,
      description: data.description,
      type: ModelType.values.firstWhere(
        (type) => type.name == data.type,
        orElse: () => ModelType.chat,
      ),
      contextWindow: data.contextWindow,
      maxOutputTokens: data.maxOutputTokens,
      supportsStreaming: data.supportsStreaming,
      supportsFunctionCalling: data.supportsFunctionCalling,
      supportsVision: data.supportsVision,
      pricing: pricing,
      capabilities: capabilities,
    );
  }

  /// 根据配置ID获取模型
  Future<List<ModelInfo>> getModelsByConfig(String configId) async {
    final customModels = await _database.getCustomModelsByConfig(configId);
    return customModels.map(_convertToModelInfo).toList();
  }

  /// 触发模型列表刷新
  void _triggerModelListRefresh() {
    if (_ref != null) {
      try {
        // 增加刷新计数器来触发 FutureProvider 重新获取数据
        final currentCount = _ref.read(modelListRefreshProvider);
        _ref.read(modelListRefreshProvider.notifier).state = currentCount + 1;
      } catch (e) {
        // 忽略错误，可能是在测试环境中
      }
    }
  }
}

/// 模型管理服务Provider
final modelManagementServiceProvider = Provider<ModelManagementService>((ref) {
  final database = ref.read(appDatabaseProvider);
  return ModelManagementService(database, ref);
});

/// 所有模型Provider
final allModelsProvider = FutureProvider<List<ModelInfo>>((ref) async {
  final service = ref.read(modelManagementServiceProvider);
  return await service.getAllModels();
});

/// 根据提供商获取模型Provider
final modelsByProviderProvider = FutureProvider.family<List<ModelInfo>, String>(
  (ref, provider) async {
    final service = ref.read(modelManagementServiceProvider);
    return await service.getModelsByProvider(provider);
  },
);

/// 启用的模型Provider
final enabledModelsProvider = FutureProvider<List<ModelInfo>>((ref) async {
  final service = ref.read(modelManagementServiceProvider);
  return await service.getEnabledModels();
});
