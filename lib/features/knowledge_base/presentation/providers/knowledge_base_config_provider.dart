import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';

/// 知识库配置状态
class KnowledgeBaseConfigState {
  final List<KnowledgeBaseConfig> configs;
  final KnowledgeBaseConfig? currentConfig;
  final List<ModelInfo> availableEmbeddingModels;
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
    List<ModelInfo>? availableEmbeddingModels,
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

  KnowledgeBaseConfigNotifier(this._database)
    : super(const KnowledgeBaseConfigState()) {
    _loadConfigs();
    _loadEmbeddingModels();
  }

  /// 加载配置列表
  Future<void> _loadConfigs() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final dbConfigs = await _database.getAllKnowledgeBaseConfigs();
      final configs = dbConfigs.map(_convertToConfig).toList();

      // 获取默认配置
      final defaultConfig =
          configs.where((c) => c.id == 'default').firstOrNull ??
          configs.firstOrNull;

      state = state.copyWith(
        configs: configs,
        currentConfig: defaultConfig,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 加载可用的嵌入模型
  /// 获取所有用户配置的启用模型，不依赖内置模型或特定类型
  Future<void> _loadEmbeddingModels() async {
    try {
      final allModels = <ModelInfo>[];

      // 获取所有启用的LLM配置
      final allConfigs = await _database.getEnabledLlmConfigs();

      // 获取每个配置下的模型
      for (final config in allConfigs) {
        final configModels = await _database.getCustomModelsByConfig(config.id);

        for (final modelData in configModels) {
          if (modelData.isEnabled) {
            final modelInfo = ModelInfo(
              id: modelData.modelId,
              name: modelData.name,
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
          }
        }
      }

      // 返回所有启用的模型，让用户选择任何模型作为嵌入模型
      // 不再限制只能选择embedding类型的模型
      state = state.copyWith(availableEmbeddingModels: allModels);
    } catch (e) {
      debugPrint('加载嵌入模型列表失败: $e');
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
    int chunkSize = 1000,
    int chunkOverlap = 200,
    int maxRetrievedChunks = 5,
    double similarityThreshold = 0.7,
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
        chunkSize: Value(config.chunkSize),
        chunkOverlap: Value(config.chunkOverlap),
        maxRetrievedChunks: Value(config.maxRetrievedChunks),
        similarityThreshold: Value(config.similarityThreshold),
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

  /// 设置默认配置
  Future<void> setDefaultConfig(String configId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _database.setDefaultKnowledgeBaseConfig(configId);
      await _loadConfigs();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 切换当前配置
  void switchConfig(String configId) {
    final config = state.configs.where((c) => c.id == configId).firstOrNull;
    if (config != null) {
      state = state.copyWith(currentConfig: config);
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
      chunkSize: data.chunkSize,
      chunkOverlap: data.chunkOverlap,
      maxRetrievedChunks: data.maxRetrievedChunks,
      similarityThreshold: data.similarityThreshold,
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
      return KnowledgeBaseConfigNotifier(database);
    });

/// 当前知识库配置Provider
final currentKnowledgeBaseConfigProvider = Provider<KnowledgeBaseConfig?>((
  ref,
) {
  return ref.watch(knowledgeBaseConfigProvider).currentConfig;
});

/// 可用嵌入模型Provider
final availableEmbeddingModelsProvider = Provider<List<ModelInfo>>((ref) {
  return ref.watch(knowledgeBaseConfigProvider).availableEmbeddingModels;
});
