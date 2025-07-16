import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../domain/services/vector_search_service.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import 'document_processing_provider.dart';
import 'knowledge_base_config_provider.dart';

/// 知识库状态
class KnowledgeBaseState {
  final List<KnowledgeDocument> documents;
  final List<KnowledgeDocument> searchResults;
  final List<SearchResultItem> vectorSearchResults;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final double? searchTime;

  const KnowledgeBaseState({
    this.documents = const [],
    this.searchResults = const [],
    this.vectorSearchResults = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.searchTime,
  });

  KnowledgeBaseState copyWith({
    List<KnowledgeDocument>? documents,
    List<KnowledgeDocument>? searchResults,
    List<SearchResultItem>? vectorSearchResults,
    bool? isLoading,
    String? error,
    String? searchQuery,
    double? searchTime,
  }) {
    return KnowledgeBaseState(
      documents: documents ?? this.documents,
      searchResults: searchResults ?? this.searchResults,
      vectorSearchResults: vectorSearchResults ?? this.vectorSearchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      searchTime: searchTime ?? this.searchTime,
    );
  }
}

/// 知识库状态管理
class KnowledgeBaseNotifier extends StateNotifier<KnowledgeBaseState> {
  final AppDatabase _database;
  final Ref _ref;

  KnowledgeBaseNotifier(this._database, this._ref)
    : super(const KnowledgeBaseState()) {
    _loadDocuments();
  }

  /// 加载文档列表
  Future<void> _loadDocuments() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final dbDocuments = await _database.getAllKnowledgeDocuments();
      final documents = dbDocuments
          .map(
            (doc) => KnowledgeDocument(
              id: doc.id,
              title: doc.name,
              content: '', // 知识库表没有content字段，需要从文件读取
              filePath: doc.filePath,
              fileType: doc.type,
              fileSize: doc.size,
              uploadedAt: doc.uploadedAt,
              lastModified: doc.processedAt ?? doc.uploadedAt,
              status: doc.status,
              tags: doc.metadata != null && doc.metadata!.isNotEmpty
                  ? _parseTagsFromMetadata(doc.metadata!)
                  : [],
              metadata: doc.metadata != null && doc.metadata!.isNotEmpty
                  ? jsonDecode(doc.metadata!)
                  : {},
            ),
          )
          .toList();

      state = state.copyWith(documents: documents, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 上传文档
  Future<void> uploadDocument({
    required String title,
    required String content,
    required String filePath,
    required String fileType,
    required int fileSize,
    String? knowledgeBaseId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final documentId = DateTime.now().millisecondsSinceEpoch.toString();
      final document = KnowledgeDocument(
        id: documentId,
        title: title,
        content: content,
        filePath: filePath,
        fileType: fileType,
        fileSize: fileSize,
        uploadedAt: DateTime.now(),
        lastModified: DateTime.now(),
        status: 'pending', // 设置为待处理状态
        tags: [],
        metadata: {},
      );

      // 使用指定的知识库ID或默认知识库
      final targetKnowledgeBaseId = knowledgeBaseId ?? 'default_kb';

      // 保存到数据库
      await _database.upsertKnowledgeDocument(
        KnowledgeDocumentsTableCompanion.insert(
          id: document.id,
          knowledgeBaseId: targetKnowledgeBaseId,
          name: document.title,
          type: document.fileType,
          size: document.fileSize,
          filePath: document.filePath,
          fileHash: await _calculateFileHash(document.filePath),
          uploadedAt: document.uploadedAt,
          status: Value(document.status),
        ),
      );

      // 重新加载文档列表
      await _loadDocuments();

      // 启动文档处理（使用配置中的分块参数）
      final processingNotifier = _ref.read(documentProcessingProvider.notifier);
      final config = _ref.read(knowledgeBaseConfigProvider).currentConfig;

      await processingNotifier.processDocument(
        documentId: documentId,
        filePath: filePath,
        fileType: fileType,
        knowledgeBaseId: targetKnowledgeBaseId,
        chunkSize: config?.chunkSize ?? 1000,
        chunkOverlap: config?.chunkOverlap ?? 200,
      );

      // 处理完成后重新加载文档列表
      await _loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 删除文档
  Future<void> deleteDocument(String documentId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _database.deleteKnowledgeDocument(documentId);
      await _loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 搜索文档
  Future<void> searchDocuments(String query) async {
    try {
      state = state.copyWith(isLoading: true, error: null, searchQuery: query);

      if (query.isEmpty) {
        state = state.copyWith(
          searchResults: [],
          vectorSearchResults: [],
          isLoading: false,
          searchTime: null,
        );
        return;
      }

      // 获取知识库配置
      final config = _ref.read(knowledgeBaseConfigProvider).currentConfig;

      if (config != null) {
        // 使用向量搜索
        final vectorSearchService = VectorSearchService(
          _database,
          _ref.read(embeddingServiceProvider),
        );

        final searchResult = await vectorSearchService.hybridSearch(
          query: query,
          config: config,
          similarityThreshold: config.similarityThreshold,
          maxResults: config.maxRetrievedChunks,
        );

        if (searchResult.isSuccess) {
          state = state.copyWith(
            vectorSearchResults: searchResult.items,
            searchResults: [], // 清空旧的文档搜索结果
            isLoading: false,
            searchTime: searchResult.searchTime,
          );
        } else {
          // 向量搜索失败，回退到简单文本搜索
          await _fallbackTextSearch(query);
        }
      } else {
        // 没有配置，使用简单文本搜索
        await _fallbackTextSearch(query);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 回退到简单文本搜索
  Future<void> _fallbackTextSearch(String query) async {
    final results = state.documents.where((doc) {
      return doc.title.toLowerCase().contains(query.toLowerCase()) ||
          doc.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(
      searchResults: results,
      vectorSearchResults: [],
      isLoading: false,
      searchTime: null,
    );
  }

  /// 清空搜索
  void clearSearch() {
    state = state.copyWith(
      searchResults: [],
      vectorSearchResults: [],
      searchQuery: '',
      searchTime: null,
    );
  }

  /// 重新索引所有文档
  Future<void> reindexDocuments() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 实现基础的文档索引逻辑
      await _reindexAllDocuments();

      await _loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 清空所有文档
  Future<void> clearAllDocuments() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      for (final doc in state.documents) {
        await _database.deleteKnowledgeDocument(doc.id);
      }

      await _loadDocuments();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 从元数据中解析标签
  List<String> _parseTagsFromMetadata(String metadata) {
    try {
      final Map<String, dynamic> metadataMap = jsonDecode(metadata);
      if (metadataMap.containsKey('tags') && metadataMap['tags'] is List) {
        return List<String>.from(metadataMap['tags']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// 计算文件哈希值
  Future<String> _calculateFileHash(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return '';
      }

      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      return '';
    }
  }

  /// 重新索引所有文档
  Future<void> _reindexAllDocuments() async {
    try {
      // 获取所有文档
      final dbDocuments = await _database.getAllKnowledgeDocuments();

      // 清除所有现有的文本块
      for (final doc in dbDocuments) {
        await _database.deleteChunksByDocument(doc.id);
      }

      // 重新处理所有文档
      final processingNotifier = _ref.read(documentProcessingProvider.notifier);
      for (final doc in dbDocuments) {
        await processingNotifier.processDocument(
          documentId: doc.id,
          filePath: doc.filePath,
          fileType: doc.type,
          knowledgeBaseId: doc.knowledgeBaseId,
        );
      }

      // 重新加载文档列表
      await _loadDocuments();
    } catch (e) {
      // 处理错误，将文档状态设置为失败
      final dbDocuments = await _database.getAllKnowledgeDocuments();
      for (final doc in dbDocuments) {
        await (_database.update(
          _database.knowledgeDocumentsTable,
        )..where((t) => t.id.equals(doc.id))).write(
          KnowledgeDocumentsTableCompanion(
            status: const Value('failed'),
            errorMessage: Value(e.toString()),
          ),
        );
      }
      rethrow;
    }
  }
}

/// 知识库Provider
final knowledgeBaseProvider =
    StateNotifierProvider<KnowledgeBaseNotifier, KnowledgeBaseState>((ref) {
      final database = ref.read(appDatabaseProvider);
      return KnowledgeBaseNotifier(database, ref);
    });

/// 文档列表Provider
final documentsProvider = Provider<List<KnowledgeDocument>>((ref) {
  return ref.watch(knowledgeBaseProvider).documents;
});

/// 搜索结果Provider
final searchResultsProvider = Provider<List<KnowledgeDocument>>((ref) {
  return ref.watch(knowledgeBaseProvider).searchResults;
});

/// 向量搜索结果Provider
final vectorSearchResultsProvider = Provider<List<SearchResultItem>>((ref) {
  return ref.watch(knowledgeBaseProvider).vectorSearchResults;
});

/// 搜索时间Provider
final searchTimeProvider = Provider<double?>((ref) {
  return ref.watch(knowledgeBaseProvider).searchTime;
});
