import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../domain/services/vector_search_service.dart';
import '../../domain/services/enhanced_vector_search_service.dart';
import '../../data/providers/unified_vector_search_provider.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';
import 'document_processing_provider.dart';
import 'knowledge_base_config_provider.dart';
import 'multi_knowledge_base_provider.dart';

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

  /// 重新加载文档列表（当知识库选择改变时调用）
  Future<void> reloadDocuments() async {
    await _loadDocuments();
  }

  /// 加载文档列表
  Future<void> _loadDocuments() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 获取当前选中的知识库ID
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;

      // 根据选中的知识库加载文档
      final dbDocuments = currentKnowledgeBase != null
          ? await _database.getDocumentsByKnowledgeBase(currentKnowledgeBase.id)
          : await _database.getAllKnowledgeDocuments();
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
    String? documentId, // 添加可选的documentId参数
    required String title,
    required String content,
    required String filePath,
    required String fileType,
    required int fileSize,
    String? knowledgeBaseId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 使用传入的documentId或生成新的
      final finalDocumentId =
          documentId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final document = KnowledgeDocument(
        id: finalDocumentId,
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

      // 使用指定的知识库ID或当前选中的知识库
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;
      final targetKnowledgeBaseId =
          knowledgeBaseId ?? currentKnowledgeBase?.id ?? 'default_kb';

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

      // 注意：文档处理将由并发处理服务统一处理，这里不再单独处理
      // 文档列表将在并发处理器中统一刷新
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 删除文档
  Future<void> deleteDocument(String documentId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 首先获取文档的所有chunk ID（在删除之前）
      final chunks = await _database.getChunksByDocument(documentId);
      
      // 删除向量数据库中的相关数据
      if (chunks.isNotEmpty) {
        try {
          final vectorService = await _ref.read(unifiedVectorSearchServiceProvider.future);
          if (vectorService is EnhancedVectorSearchService) {
            final currentKnowledgeBase = _ref
                .read(multiKnowledgeBaseProvider)
                .currentKnowledgeBase;
            final knowledgeBaseId = currentKnowledgeBase?.id ?? 'default_kb';
            
            await vectorService.deleteDocumentVectors(
              knowledgeBaseId: knowledgeBaseId,
              chunkIds: chunks.map((chunk) => chunk.id).toList(),
            );
          }
        } catch (e) {
          debugPrint('⚠️ 删除向量数据失败，但继续删除文档记录: $e');
        }
      }
      
      // 删除文档相关的文本块
      await _database.deleteChunksByDocument(documentId);
      
      // 最后删除文档记录
      await _database.deleteKnowledgeDocument(documentId);
      
      // 更新知识库统计信息
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;
      if (currentKnowledgeBase != null) {
        await _ref.read(multiKnowledgeBaseProvider.notifier)
            .refreshStats(currentKnowledgeBase.id);
      }
      
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
        try {
          // 使用统一向量搜索服务
          final vectorSearchService = await _ref.read(
            unifiedVectorSearchServiceProvider.future,
          );
          final serviceType = await _ref.read(
            vectorSearchServiceTypeProvider.future,
          );

          debugPrint('🔍 使用向量搜索服务: ${serviceType.name}');

          if (vectorSearchService is EnhancedVectorSearchService) {
            // 使用增强向量搜索服务
            final searchResult = await vectorSearchService.hybridSearch(
              query: query,
              config: config,
              similarityThreshold: config.similarityThreshold,
              maxResults: config.maxRetrievedChunks,
            );

            if (searchResult.isSuccess) {
              // 转换增强搜索结果为标准搜索结果
              final convertedItems = searchResult.items.map((item) {
                return SearchResultItem(
                  chunkId: item.chunkId,
                  documentId: item.documentId,
                  content: item.content,
                  similarity: item.similarity,
                  chunkIndex: item.chunkIndex,
                  metadata: item.metadata,
                );
              }).toList();

              state = state.copyWith(
                vectorSearchResults: convertedItems,
                searchResults: [], // 清空旧的文档搜索结果
                isLoading: false,
                searchTime: searchResult.searchTime,
              );
            } else {
              // 向量搜索失败，回退到简单文本搜索
              await _fallbackTextSearch(query);
            }
          } else if (vectorSearchService is VectorSearchService) {
            // 使用传统向量搜索服务
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
            debugPrint('❌ 未知的向量搜索服务类型');
            await _fallbackTextSearch(query);
          }
        } catch (e) {
          debugPrint('❌ 向量搜索失败，回退到简单搜索: $e');
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

      // 首先获取所有文档的chunk ID（在删除之前）
      final allChunkIds = <String>[];
      for (final doc in state.documents) {
        final chunks = await _database.getChunksByDocument(doc.id);
        allChunkIds.addAll(chunks.map((chunk) => chunk.id));
      }
      
      // 清空向量数据库
      if (allChunkIds.isNotEmpty) {
        try {
          final vectorService = await _ref.read(unifiedVectorSearchServiceProvider.future);
          if (vectorService is EnhancedVectorSearchService) {
            final currentKnowledgeBase = _ref
                .read(multiKnowledgeBaseProvider)
                .currentKnowledgeBase;
            final knowledgeBaseId = currentKnowledgeBase?.id ?? 'default_kb';
            
            await vectorService.deleteDocumentVectors(
              knowledgeBaseId: knowledgeBaseId,
              chunkIds: allChunkIds,
            );
          }
        } catch (e) {
          debugPrint('⚠️ 清空向量数据库失败，但继续清空文档记录: $e');
        }
      }
      
      // 删除所有文档及其相关数据
      for (final doc in state.documents) {
        // 删除文档相关的文本块
        await _database.deleteChunksByDocument(doc.id);
        // 删除文档记录
        await _database.deleteKnowledgeDocument(doc.id);
      }
      
      // 更新知识库统计信息
      final currentKnowledgeBase = _ref
          .read(multiKnowledgeBaseProvider)
          .currentKnowledgeBase;
      if (currentKnowledgeBase != null) {
        await _ref.read(multiKnowledgeBaseProvider.notifier)
            .refreshStats(currentKnowledgeBase.id);
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
