import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';
import '../../domain/entities/knowledge_base.dart';

/// 多知识库状态
@immutable
class MultiKnowledgeBaseState {
  /// 所有知识库列表
  final List<KnowledgeBase> knowledgeBases;

  /// 当前选中的知识库
  final KnowledgeBase? currentKnowledgeBase;

  /// 是否正在加载
  final bool isLoading;

  /// 错误信息
  final String? error;

  const MultiKnowledgeBaseState({
    this.knowledgeBases = const [],
    this.currentKnowledgeBase,
    this.isLoading = false,
    this.error,
  });

  MultiKnowledgeBaseState copyWith({
    List<KnowledgeBase>? knowledgeBases,
    KnowledgeBase? currentKnowledgeBase,
    bool? isLoading,
    String? error,
  }) {
    return MultiKnowledgeBaseState(
      knowledgeBases: knowledgeBases ?? this.knowledgeBases,
      currentKnowledgeBase: currentKnowledgeBase ?? this.currentKnowledgeBase,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 多知识库管理Notifier
class MultiKnowledgeBaseNotifier
    extends StateNotifier<MultiKnowledgeBaseState> {
  final AppDatabase _database;

  MultiKnowledgeBaseNotifier(this._database)
    : super(const MultiKnowledgeBaseState()) {
    _loadKnowledgeBases();
  }

  /// 加载所有知识库
  Future<void> _loadKnowledgeBases() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      debugPrint('🔍 开始加载知识库...');
      final knowledgeBasesData = await _database.getAllKnowledgeBases();
      debugPrint('📋 从数据库获取到 ${knowledgeBasesData.length} 个知识库');

      final knowledgeBases = <KnowledgeBase>[];
      for (final data in knowledgeBasesData) {
        try {
          debugPrint('🔍 处理知识库数据: ${data.toString()}');
          final kb = KnowledgeBase.fromTableData(data);
          knowledgeBases.add(kb);
          debugPrint('✅ 成功加载知识库: ${kb.name} (${kb.id})');
        } catch (e, stackTrace) {
          debugPrint('❌ 加载知识库失败: $e');
          debugPrint('📊 数据内容: ${data.toString()}');
          debugPrint('📍 堆栈跟踪: $stackTrace');
          // 跳过有问题的知识库，继续加载其他的
        }
      }

      // 如果没有知识库，尝试创建默认知识库
      if (knowledgeBases.isEmpty) {
        debugPrint('⚠️ 没有找到知识库，尝试创建默认知识库...');
        await _createDefaultKnowledgeBaseIfNeeded();
        // 重新加载
        final retryData = await _database.getAllKnowledgeBases();
        for (final data in retryData) {
          try {
            final kb = KnowledgeBase.fromTableData(data);
            knowledgeBases.add(kb);
          } catch (e) {
            debugPrint('❌ 重试加载知识库失败: $e');
          }
        }
      }

      // 如果没有当前选中的知识库，选择默认知识库
      KnowledgeBase? currentKnowledgeBase = state.currentKnowledgeBase;
      if (currentKnowledgeBase == null && knowledgeBases.isNotEmpty) {
        currentKnowledgeBase = knowledgeBases.firstWhere(
          (kb) => kb.isDefault,
          orElse: () => knowledgeBases.first,
        );
      }

      state = state.copyWith(
        knowledgeBases: knowledgeBases,
        currentKnowledgeBase: currentKnowledgeBase,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('加载知识库失败: $e');
      state = state.copyWith(isLoading: false, error: '加载知识库失败: $e');
    }
  }

  /// 创建知识库
  Future<void> createKnowledgeBase(CreateKnowledgeBaseRequest request) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final companion = KnowledgeBasesTableCompanion.insert(
        id: id,
        name: request.name,
        description: Value(request.description),
        icon: Value(request.icon),
        color: Value(request.color),
        configId: request.configId,
        createdAt: now,
        updatedAt: now,
      );

      await _database.createKnowledgeBase(companion);
      await _loadKnowledgeBases();
    } catch (e) {
      debugPrint('创建知识库失败: $e');
      state = state.copyWith(isLoading: false, error: '创建知识库失败: $e');
    }
  }

  /// 更新知识库
  Future<void> updateKnowledgeBase(
    String id,
    UpdateKnowledgeBaseRequest request,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final companion = KnowledgeBasesTableCompanion(
        name: request.name != null
            ? Value(request.name!)
            : const Value.absent(),
        description: request.description != null
            ? Value(request.description)
            : const Value.absent(),
        icon: request.icon != null ? Value(request.icon) : const Value.absent(),
        color: request.color != null
            ? Value(request.color)
            : const Value.absent(),
        configId: request.configId != null
            ? Value(request.configId!)
            : const Value.absent(),
        isEnabled: request.isEnabled != null
            ? Value(request.isEnabled!)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await _database.updateKnowledgeBase(id, companion);
      await _loadKnowledgeBases();
    } catch (e) {
      debugPrint('更新知识库失败: $e');
      state = state.copyWith(isLoading: false, error: '更新知识库失败: $e');
    }
  }

  /// 删除知识库
  Future<void> deleteKnowledgeBase(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 检查是否为默认知识库
      final knowledgeBase = state.knowledgeBases.firstWhere(
        (kb) => kb.id == id,
      );
      if (knowledgeBase.isDefault) {
        throw Exception('不能删除默认知识库');
      }

      // 删除知识库及其相关数据
      await _database.deleteKnowledgeBase(id);

      // 如果删除的是当前选中的知识库，切换到默认知识库
      if (state.currentKnowledgeBase?.id == id) {
        final defaultKb = state.knowledgeBases.firstWhere(
          (kb) => kb.isDefault && kb.id != id,
          orElse: () => state.knowledgeBases.firstWhere((kb) => kb.id != id),
        );
        state = state.copyWith(currentKnowledgeBase: defaultKb);
      }

      await _loadKnowledgeBases();
    } catch (e) {
      debugPrint('删除知识库失败: $e');
      state = state.copyWith(isLoading: false, error: '删除知识库失败: $e');
    }
  }

  /// 选择知识库
  void selectKnowledgeBase(String id) {
    final knowledgeBase = state.knowledgeBases.firstWhere(
      (kb) => kb.id == id,
      orElse: () => state.knowledgeBases.first,
    );

    state = state.copyWith(currentKnowledgeBase: knowledgeBase);

    // 更新最后使用时间
    _updateLastUsedTime(id);
  }

  /// 更新最后使用时间
  Future<void> _updateLastUsedTime(String id) async {
    try {
      final companion = KnowledgeBasesTableCompanion(
        lastUsedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );
      await _database.updateKnowledgeBase(id, companion);
    } catch (e) {
      debugPrint('更新知识库使用时间失败: $e');
    }
  }

  /// 刷新知识库统计信息
  Future<void> refreshStats(String id) async {
    try {
      await _database.updateKnowledgeBaseStats(id);
      await _loadKnowledgeBases();
    } catch (e) {
      debugPrint('刷新知识库统计失败: $e');
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 重新加载知识库
  Future<void> reload() async {
    await _loadKnowledgeBases();
  }

  /// 创建默认知识库（如果需要）
  Future<void> _createDefaultKnowledgeBaseIfNeeded() async {
    try {
      debugPrint('🔧 创建默认知识库...');

      // 检查是否已存在默认知识库
      final existing = await _database.getDefaultKnowledgeBase();
      if (existing != null) {
        debugPrint('✅ 默认知识库已存在');
        return;
      }

      // 创建默认配置（如果不存在）
      final configs = await _database.getAllKnowledgeBaseConfigs();
      String configId = 'default_config';

      if (configs.isEmpty) {
        await _database.upsertKnowledgeBaseConfig(
          KnowledgeBaseConfigsTableCompanion.insert(
            id: configId,
            name: '默认配置',
            embeddingModelId: 'text-embedding-3-small',
            embeddingModelName: 'Text Embedding 3 Small',
            embeddingModelProvider: 'openai',
            chunkSize: Value(1000),
            chunkOverlap: Value(200),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        configId = configs.first.id;
      }

      // 创建默认知识库
      final now = DateTime.now();
      await _database.createKnowledgeBase(
        KnowledgeBasesTableCompanion.insert(
          id: 'default_kb',
          name: '默认知识库',
          description: Value('系统默认知识库'),
          configId: configId,
          isDefault: Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

      debugPrint('✅ 默认知识库创建成功');
    } catch (e) {
      debugPrint('❌ 创建默认知识库失败: $e');
    }
  }
}

/// 多知识库Provider
final multiKnowledgeBaseProvider =
    StateNotifierProvider<MultiKnowledgeBaseNotifier, MultiKnowledgeBaseState>((
      ref,
    ) {
      final database = ref.watch(appDatabaseProvider);
      return MultiKnowledgeBaseNotifier(database);
    });
