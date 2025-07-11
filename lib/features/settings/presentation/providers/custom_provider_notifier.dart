import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../llm_chat/domain/usecases/chat_service.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';

/// 自定义提供商状态
class CustomProviderState {
  final List<LlmConfigsTableData> providers;
  final bool isLoading;
  final String? error;

  const CustomProviderState({
    this.providers = const [],
    this.isLoading = false,
    this.error,
  });

  CustomProviderState copyWith({
    List<LlmConfigsTableData>? providers,
    bool? isLoading,
    String? error,
  }) {
    return CustomProviderState(
      providers: providers ?? this.providers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 自定义提供商状态管理
class CustomProviderNotifier extends StateNotifier<CustomProviderState> {
  final AppDatabase _database;

  CustomProviderNotifier(this._database) : super(const CustomProviderState()) {
    loadProviders();
  }

  /// 加载自定义提供商列表
  Future<void> loadProviders() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final providers = await _database.getCustomProviderConfigs();
      state = state.copyWith(providers: providers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 添加自定义提供商
  Future<bool> addProvider({
    required String name,
    required String customProviderName,
    required String apiKey,
    required String apiCompatibilityType,
    String? baseUrl,
    String? customProviderDescription,
    String? customProviderIcon,
    String? defaultModel,
    String? defaultEmbeddingModel,
    bool isEnabled = true,
  }) async {
    try {
      final now = DateTime.now();
      final configId = 'custom-${now.millisecondsSinceEpoch}';

      final config = LlmProviderFactory.createCustomProviderConfig(
        id: configId,
        name: name,
        customProviderName: customProviderName,
        apiKey: apiKey,
        apiCompatibilityType: apiCompatibilityType,
        baseUrl: baseUrl,
        customProviderDescription: customProviderDescription,
        customProviderIcon: customProviderIcon,
        defaultModel: defaultModel,
        defaultEmbeddingModel: defaultEmbeddingModel,
      );

      // 验证配置
      if (!LlmProviderFactory.validateProviderConfig(config)) {
        state = state.copyWith(error: '配置验证失败');
        return false;
      }

      // 保存到数据库
      final companion = LlmConfigsTableCompanion.insert(
        id: config.id,
        name: config.name,
        provider: config.provider,
        apiKey: config.apiKey,
        baseUrl: drift.Value(config.baseUrl),
        defaultModel: drift.Value(config.defaultModel),
        defaultEmbeddingModel: drift.Value(config.defaultEmbeddingModel),
        createdAt: config.createdAt,
        updatedAt: config.updatedAt,
        isEnabled: drift.Value(isEnabled),
        isCustomProvider: drift.Value(config.isCustomProvider),
        apiCompatibilityType: drift.Value(config.apiCompatibilityType),
        customProviderName: drift.Value(config.customProviderName),
        customProviderDescription: drift.Value(
          config.customProviderDescription,
        ),
        customProviderIcon: drift.Value(config.customProviderIcon),
      );

      await _database.upsertLlmConfig(companion);
      await loadProviders(); // 重新加载列表
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 更新自定义提供商
  Future<bool> updateProvider({
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
    bool? isEnabled,
  }) async {
    try {
      final existingProvider = state.providers.firstWhere((p) => p.id == id);

      final updatedConfig = LlmConfigsTableCompanion(
        id: drift.Value(id),
        name: drift.Value(name),
        provider: drift.Value(existingProvider.provider),
        apiKey: drift.Value(apiKey),
        baseUrl: drift.Value(baseUrl),
        defaultModel: drift.Value(defaultModel),
        defaultEmbeddingModel: drift.Value(defaultEmbeddingModel),
        createdAt: drift.Value(existingProvider.createdAt),
        updatedAt: drift.Value(DateTime.now()),
        isEnabled: drift.Value(isEnabled ?? existingProvider.isEnabled),
        isCustomProvider: drift.Value(existingProvider.isCustomProvider),
        apiCompatibilityType: drift.Value(apiCompatibilityType),
        customProviderName: drift.Value(customProviderName),
        customProviderDescription: drift.Value(customProviderDescription),
        customProviderIcon: drift.Value(customProviderIcon),
      );

      await _database.upsertLlmConfig(updatedConfig);
      await loadProviders(); // 重新加载列表
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 删除自定义提供商
  Future<bool> deleteProvider(String id) async {
    try {
      await _database.deleteLlmConfig(id);
      await loadProviders(); // 重新加载列表
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 切换提供商启用状态
  Future<bool> toggleProviderStatus(String id) async {
    try {
      final provider = state.providers.firstWhere((p) => p.id == id);

      final updatedConfig = LlmConfigsTableCompanion(
        id: drift.Value(id),
        name: drift.Value(provider.name),
        provider: drift.Value(provider.provider),
        apiKey: drift.Value(provider.apiKey),
        baseUrl: drift.Value(provider.baseUrl),
        defaultModel: drift.Value(provider.defaultModel),
        defaultEmbeddingModel: drift.Value(provider.defaultEmbeddingModel),
        organizationId: drift.Value(provider.organizationId),
        projectId: drift.Value(provider.projectId),
        extraParams: drift.Value(provider.extraParams),
        createdAt: drift.Value(provider.createdAt),
        updatedAt: drift.Value(DateTime.now()),
        isEnabled: drift.Value(!provider.isEnabled),
        isCustomProvider: drift.Value(provider.isCustomProvider),
        apiCompatibilityType: drift.Value(provider.apiCompatibilityType),
        customProviderName: drift.Value(provider.customProviderName),
        customProviderDescription: drift.Value(
          provider.customProviderDescription,
        ),
        customProviderIcon: drift.Value(provider.customProviderIcon),
      );

      await _database.upsertLlmConfig(updatedConfig);
      await loadProviders(); // 重新加载列表
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 验证提供商连接
  Future<bool> validateProviderConnection(String id) async {
    try {
      final provider = state.providers.firstWhere((p) => p.id == id);
      final config = provider.toLlmConfig();
      return await LlmProviderFactory.validateProviderConnection(config);
    } catch (e) {
      return false;
    }
  }

  /// 清除错误状态
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 自定义提供商状态管理Provider
final customProviderNotifierProvider =
    StateNotifierProvider<CustomProviderNotifier, CustomProviderState>((ref) {
      final database = ref.watch(appDatabaseProvider);
      return CustomProviderNotifier(database);
    });

/// 自定义提供商列表Provider（只读）
final customProvidersListProvider = Provider<List<LlmConfigsTableData>>((ref) {
  return ref.watch(customProviderNotifierProvider).providers;
});

/// 启用的自定义提供商列表Provider
final enabledCustomProvidersProvider = Provider<List<LlmConfigsTableData>>((
  ref,
) {
  final providers = ref.watch(customProvidersListProvider);
  return providers.where((p) => p.isEnabled).toList();
});

/// 自定义提供商加载状态Provider
final customProvidersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(customProviderNotifierProvider).isLoading;
});

/// 自定义提供商错误状态Provider
final customProvidersErrorProvider = Provider<String?>((ref) {
  return ref.watch(customProviderNotifierProvider).error;
});
