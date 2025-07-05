import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/domain/services/model_management_service.dart';

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
      availableEmbeddingModels: availableEmbeddingModels ?? this.availableEmbeddingModels,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 知识库配置管理器
class KnowledgeBaseConfigNotifier extends StateNotifier<KnowledgeBaseConfigState> {
  final AppDatabase _database;
  final ModelManagementService _modelService;

  KnowledgeBaseConfigNotifier(this._database, this._modelService)
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
      final defaultConfig = configs.where((c) => c.id == 'default').firstOrNull ??
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
  Future<void> _loadEmbeddingModels() async {
    try {
      final allModels = await _modelService.getEnabledModels();
      final embeddingModels = allModels
          .where((model) => model.type == ModelType.embedding)
          .toList();

      state = state.copyWith(availableEmbeddingModels: embeddingModels);
    } catch (e) {
      // 忽略错误，使用空列表
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
    StateNotifierProvider<KnowledgeBaseConfigNotifier, KnowledgeBaseConfigState>((ref) {
  final database = ref.read(appDatabaseProvider);
  final modelService = ref.read(modelManagementServiceProvider);
  return KnowledgeBaseConfigNotifier(database, modelService);
});

/// 当前知识库配置Provider
final currentKnowledgeBaseConfigProvider = Provider<KnowledgeBaseConfig?>((ref) {
  return ref.watch(knowledgeBaseConfigProvider).currentConfig;
});

/// 可用嵌入模型Provider
final availableEmbeddingModelsProvider = Provider<List<ModelInfo>>((ref) {
  return ref.watch(knowledgeBaseConfigProvider).availableEmbeddingModels;
});
