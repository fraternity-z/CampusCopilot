import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../data/providers/embedding_service_provider.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';

/// 带提供商信息的模型信息
class ModelInfoWithProvider {
  final String id;
  final String name;
  final String provider;
  final String? description;
  final ModelType type;
  final int? contextWindow;
  final int? maxOutputTokens;
  final bool supportsStreaming;
  final bool supportsFunctionCalling;
  final bool supportsVision;

  const ModelInfoWithProvider({
    required this.id,
    required this.name,
    required this.provider,
    this.description,
    required this.type,
    this.contextWindow,
    this.maxOutputTokens,
    required this.supportsStreaming,
    required this.supportsFunctionCalling,
    required this.supportsVision,
  });
}

/// 知识库配置状态
class KnowledgeBaseConfigState {
  final List<KnowledgeBaseConfig> configs;
  final KnowledgeBaseConfig? currentConfig;
  final List<ModelInfoWithProvider> availableEmbeddingModels;
  final bool isLoading;
  final String? error;

  const KnowledgeBaseConfigState({
    this.configs = const [],
    this.currentConfig,
    this.availableEmbeddingModels = const [],
    this.isLoading = false,
    this.error,
  });

  KnowledgeBaseConfigState copyWith({
    List<KnowledgeBaseConfig>? configs,
    KnowledgeBaseConfig? currentConfig,
    List<ModelInfoWithProvider>? availableEmbeddingModels,
    bool? isLoading,
    String? error,
  }) {
    return KnowledgeBaseConfigState(
      configs: configs ?? this.configs,
      currentConfig: currentConfig ?? this.currentConfig,
      availableEmbeddingModels:
          availableEmbeddingModels ?? this.availableEmbeddingModels,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 知识库配置管理器
class KnowledgeBaseConfigNotifier
    extends StateNotifier<KnowledgeBaseConfigState> {
  final AppDatabase _database;
  final Ref _ref;

  KnowledgeBaseConfigNotifier(this._database, this._ref)
    : super(const KnowledgeBaseConfigState()) {
    _initializeConfigs();
  }

  /// 初始化配置
  Future<void> _initializeConfigs() async {
    await _loadConfigs();
    await _loadEmbeddingModels();
    // 只在有配置但都无效时才清理
    if (state.configs.isEmpty) {
      await forceCleanupAllConfigs();
      await _loadConfigs();
    }
  }

  /// 强制清理所有知识库配置（用于解决顽固的配置问题）
  Future<void> forceCleanupAllConfigs() async {
    try {
      debugPrint('🧹 强制清理所有知识库配置...');

      // 删除所有知识库配置
      final allConfigs = await _database.getAllKnowledgeBaseConfigs();
      for (final config in allConfigs) {
        debugPrint('🗑️ 删除配置: ${config.name}');
        await _database.deleteKnowledgeBaseConfig(config.id);
      }

      debugPrint('✅ 强制清理完成，删除了 ${allConfigs.length} 个配置');
    } catch (e) {
      debugPrint('❌ 强制清理失败: $e');
    }
  }

  /// 加载配置列表
  Future<void> _loadConfigs() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final dbConfigs = await _database.getAllKnowledgeBaseConfigs();
      final configs = dbConfigs.map(_convertToConfig).toList();

      // 过滤掉无效的配置（没有嵌入模型ID的配置）
      final validConfigs = configs
          .where((c) => c.embeddingModelId.isNotEmpty)
          .toList();

      // 获取当前配置（保持现有的当前配置，如果不存在则选择默认配置）
      KnowledgeBaseConfig? currentConfig = state.currentConfig;
      // 尝试在新加载的配置中找到当前配置的更新版本
      currentConfig = validConfigs
          .where((c) => c.id == currentConfig!.id)
          .firstOrNull;
    
      // 如果没有找到当前配置，则选择默认配置
      currentConfig ??=
          validConfigs.where((c) => c.isDefault).firstOrNull ??
          validConfigs.firstOrNull;

      debugPrint('📋 加载知识库配置: ${validConfigs.length}个有效配置');
      if (currentConfig != null) {
        debugPrint(
          '✅ 当前配置: ${currentConfig.name} - ${currentConfig.embeddingModelName} (${currentConfig.embeddingModelProvider})',
        );
      } else {
        debugPrint('⚠️ 未找到有效的知识库配置');
      }

      state = state.copyWith(
        configs: validConfigs,
        currentConfig: currentConfig,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('❌ 加载知识库配置失败: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 加载可用的嵌入模型
  /// 获取所有用户配置的启用模型，不依赖内置模型或特定类型
  Future<void> _loadEmbeddingModels() async {
    try {
      debugPrint('🔍 开始加载嵌入模型...');
      final allModels = <ModelInfoWithProvider>[];

      // 获取所有启用的LLM配置
      final allConfigs = await _database.getEnabledLlmConfigs();
      debugPrint('📋 找到 ${allConfigs.length} 个启用的LLM配置');

      // 获取每个配置下的模型
      for (final config in allConfigs) {
        debugPrint('🔧 检查配置: ${config.name} (${config.provider})');
        final configModels = await _database.getCustomModelsByConfig(config.id);
        debugPrint('📝 配置 ${config.name} 有 ${configModels.length} 个模型');

        for (final modelData in configModels) {
          if (modelData.isEnabled) {
            debugPrint('✅ 启用的模型: ${modelData.name} (${modelData.modelId})');
            debugPrint('   - 数据库中的类型: ${modelData.type}');

            final modelInfo = ModelInfoWithProvider(
              id: modelData.modelId,
              name: modelData.name,
              provider: config.provider,
              description: modelData.description,
              type: ModelType.values.firstWhere(
                (type) => type.name == modelData.type,
                orElse: () => ModelType.chat,
              ),
              contextWindow: modelData.contextWindow,
              maxOutputTokens: modelData.maxOutputTokens,
              supportsStreaming: modelData.supportsStreaming,
              supportsFunctionCalling: modelData.supportsFunctionCalling,
              supportsVision: modelData.supportsVision,
            );
            allModels.add(modelInfo);
          } else {
            debugPrint('❌ 禁用的模型: ${modelData.name} (${modelData.modelId})');
          }
        }
      }

      debugPrint('🎯 总共加载了 ${allModels.length} 个可用模型');

      // 过滤嵌入模型：只显示类型为embedding或名称包含"embedding"的模型
      final embeddingModels = allModels.where((model) {
        // 检查模型类型是否为embedding
        if (model.type == ModelType.embedding) {
          return true;
        }

        // 检查模型名称或ID是否包含"embedding"（不区分大小写）
        final nameContainsEmbedding = model.name.toLowerCase().contains(
          'embedding',
        );
        final idContainsEmbedding = model.id.toLowerCase().contains(
          'embedding',
        );

        return nameContainsEmbedding || idContainsEmbedding;
      }).toList();

      debugPrint('🔍 过滤后的嵌入模型: ${embeddingModels.length} 个');
      for (final model in embeddingModels) {
        debugPrint('  - ${model.name} (${model.id}) - 类型: ${model.type}');
      }

      state = state.copyWith(availableEmbeddingModels: embeddingModels);
    } catch (e) {
      debugPrint('❌ 加载嵌入模型列表失败: $e');
      // 忽略错误，使用空列表
      state = state.copyWith(availableEmbeddingModels: []);
    }
  }

  /// 创建新配置
  Future<void> createConfig({
    required String name,
    required String embeddingModelId,
    required String embeddingModelName,
    required String embeddingModelProvider,
    int? embeddingDimension, // 新增维度参数，null表示使用模型默认维度
    int chunkSize = 1000,
    int chunkOverlap = 200,
    int maxRetrievedChunks = 5,
    double similarityThreshold = 0.3, // 降低默认阈值，提高召回率
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final now = DateTime.now();
      final configId = 'kb_config_${now.millisecondsSinceEpoch}';

      final config = KnowledgeBaseConfigsTableCompanion.insert(
        id: configId,
        name: name,
        embeddingModelId: embeddingModelId,
        embeddingModelName: embeddingModelName,
        embeddingModelProvider: embeddingModelProvider,
        embeddingDimension: embeddingDimension != null ? Value(embeddingDimension) : const Value.absent(),
        chunkSize: Value(chunkSize),
        chunkOverlap: Value(chunkOverlap),
        maxRetrievedChunks: Value(maxRetrievedChunks),
        similarityThreshold: Value(similarityThreshold),
        isDefault: Value(state.configs.isEmpty), // 第一个配置设为默认
        createdAt: now,
        updatedAt: now,
      );

      await _database.upsertKnowledgeBaseConfig(config);
      await _loadConfigs();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 更新配置
  Future<void> updateConfig(KnowledgeBaseConfig config) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final companion = KnowledgeBaseConfigsTableCompanion(
        id: Value(config.id),
        name: Value(config.name),
        embeddingModelId: Value(config.embeddingModelId),
        embeddingModelName: Value(config.embeddingModelName),
        embeddingModelProvider: Value(config.embeddingModelProvider),
        embeddingDimension: config.embeddingDimension != null ? 
            Value(config.embeddingDimension!) : const Value.absent(),
        chunkSize: Value(config.chunkSize),
        chunkOverlap: Value(config.chunkOverlap),
        maxRetrievedChunks: Value(config.maxRetrievedChunks),
        similarityThreshold: Value(config.similarityThreshold),
        createdAt: Value(config.createdAt), // 添加缺失的 createdAt 字段
        updatedAt: Value(DateTime.now()),
      );

      await _database.upsertKnowledgeBaseConfig(companion);
      await _loadConfigs();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 删除配置
  Future<void> deleteConfig(String configId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _database.deleteKnowledgeBaseConfig(configId);
      await _loadConfigs();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 重新加载配置（公开方法）
  Future<void> reload() async {
    debugPrint('🔄 手动重新加载知识库配置');
    await _loadConfigs();
    await _loadEmbeddingModels();
  }

  /// 重新加载嵌入模型（公开方法，用于调试）
  Future<void> reloadEmbeddingModels() async {
    debugPrint('🔄 手动重新加载嵌入模型');
    await _loadEmbeddingModels();
  }

  /// 清理无效配置（没有对应LLM配置的知识库配置）
  Future<void> cleanupInvalidConfigs() async {
    try {
      debugPrint('🧹 开始清理无效的知识库配置...');

      final allKbConfigs = await _database.getAllKnowledgeBaseConfigs();
      final allLlmConfigs = await _database.getEnabledLlmConfigs();

      int deletedCount = 0;

      for (final kbConfig in allKbConfigs) {
        // 检查是否有对应的LLM配置
        final hasMatchingLlmConfig = allLlmConfigs.any(
          (llmConfig) =>
              llmConfig.provider.toLowerCase() ==
              kbConfig.embeddingModelProvider.toLowerCase(),
        );

        // 如果没有对应的LLM配置，或者嵌入模型ID为空，删除这个知识库配置
        if (!hasMatchingLlmConfig || kbConfig.embeddingModelId.isEmpty) {
          debugPrint(
            '🗑️ 删除无效配置: ${kbConfig.name} (${kbConfig.embeddingModelProvider})',
          );
          await _database.deleteKnowledgeBaseConfig(kbConfig.id);
          deletedCount++;
        }
      }

      debugPrint('✅ 清理完成，删除了 $deletedCount 个无效配置');
      await _loadConfigs();
    } catch (e) {
      debugPrint('❌ 清理无效配置失败: $e');
    }
  }

  /// 设置默认配置
  Future<void> setDefaultConfig(String configId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _database.setDefaultKnowledgeBaseConfig(configId);
      await _loadConfigs();

      // 刷新嵌入服务以应用新配置
      _refreshEmbeddingService();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 切换当前配置
  void switchConfig(String configId) {
    final config = state.configs.where((c) => c.id == configId).firstOrNull;
    if (config != null) {
      state = state.copyWith(currentConfig: config);

      // 刷新嵌入服务以应用新配置
      _refreshEmbeddingService();
    }
  }

  /// 刷新嵌入服务
  void _refreshEmbeddingService() {
    try {
      final currentConfig = state.currentConfig;
      if (currentConfig != null) {
        // 获取嵌入服务刷新函数并调用
        final refreshFunction = _ref.read(embeddingServiceRefreshProvider);
        refreshFunction(
          newProvider: currentConfig.embeddingModelProvider,
          newModel: currentConfig.embeddingModelId,
        );

        // 更新嵌入模型切换状态
        final switchFunction = _ref.read(embeddingModelSwitchProvider);
        switchFunction(
          currentConfig.embeddingModelProvider,
          currentConfig.embeddingModelId,
        );

        debugPrint(
          '🔄 已刷新嵌入服务: ${currentConfig.embeddingModelProvider}/${currentConfig.embeddingModelId}',
        );
      }
    } catch (e) {
      debugPrint('❌ 刷新嵌入服务失败: $e');
    }
  }

  /// 转换数据库配置为实体
  KnowledgeBaseConfig _convertToConfig(KnowledgeBaseConfigsTableData data) {
    return KnowledgeBaseConfig(
      id: data.id,
      name: data.name,
      embeddingModelId: data.embeddingModelId,
      embeddingModelName: data.embeddingModelName,
      embeddingModelProvider: data.embeddingModelProvider,
      embeddingDimension: data.embeddingDimension, // 新增维度字段
      chunkSize: data.chunkSize,
      chunkOverlap: data.chunkOverlap,
      maxRetrievedChunks: data.maxRetrievedChunks,
      similarityThreshold: data.similarityThreshold,
      isDefault: data.isDefault,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}

/// 知识库配置Provider
final knowledgeBaseConfigProvider =
    StateNotifierProvider<
      KnowledgeBaseConfigNotifier,
      KnowledgeBaseConfigState
    >((ref) {
      final database = ref.read(appDatabaseProvider);
      return KnowledgeBaseConfigNotifier(database, ref);
    });

/// 当前知识库配置Provider
final currentKnowledgeBaseConfigProvider = Provider<KnowledgeBaseConfig?>((
  ref,
) {
  return ref.watch(knowledgeBaseConfigProvider).currentConfig;
});

/// 可用嵌入模型Provider
final availableEmbeddingModelsProvider = Provider<List<ModelInfoWithProvider>>((
  ref,
) {
  return ref.watch(knowledgeBaseConfigProvider).availableEmbeddingModels;
});
