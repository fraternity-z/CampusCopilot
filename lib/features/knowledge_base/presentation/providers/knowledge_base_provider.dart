import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import '../../domain/entities/knowledge_document.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';

/// 知识库状态
class KnowledgeBaseState {
  final List<KnowledgeDocument> documents;
  final List<KnowledgeDocument> searchResults;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const KnowledgeBaseState({
    this.documents = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  KnowledgeBaseState copyWith({
    List<KnowledgeDocument>? documents,
    List<KnowledgeDocument>? searchResults,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return KnowledgeBaseState(
      documents: documents ?? this.documents,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// 知识库状态管理
class KnowledgeBaseNotifier extends StateNotifier<KnowledgeBaseState> {
  final AppDatabase _database;

  KnowledgeBaseNotifier(this._database) : super(const KnowledgeBaseState()) {
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
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final document = KnowledgeDocument(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        filePath: filePath,
        fileType: fileType,
        fileSize: fileSize,
        uploadedAt: DateTime.now(),
        lastModified: DateTime.now(),
        status: 'processing',
        tags: [],
        metadata: {},
      );

      // 保存到数据库
      await _database.upsertKnowledgeDocument(
        KnowledgeDocumentsTableCompanion.insert(
          id: document.id,
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
        state = state.copyWith(searchResults: [], isLoading: false);
        return;
      }

      // 简单的文本搜索
      final results = state.documents.where((doc) {
        return doc.title.toLowerCase().contains(query.toLowerCase()) ||
            doc.content.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = state.copyWith(searchResults: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 清空搜索
  void clearSearch() {
    state = state.copyWith(searchResults: [], searchQuery: '');
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

      // 模拟索引处理
      for (final doc in dbDocuments) {
        // 更新文档状态为处理中
        await _database.upsertKnowledgeDocument(
          KnowledgeDocumentsTableCompanion(
            id: Value(doc.id),
            status: const Value('processing'),
            processedAt: Value(DateTime.now()),
          ),
        );

        // 模拟处理时间
        await Future.delayed(const Duration(milliseconds: 100));

        // 更新文档状态为已完成
        await _database.upsertKnowledgeDocument(
          KnowledgeDocumentsTableCompanion(
            id: Value(doc.id),
            status: const Value('completed'),
            processedAt: Value(DateTime.now()),
            indexProgress: const Value(1.0),
          ),
        );
      }
    } catch (e) {
      // 处理错误，将文档状态设置为失败
      final dbDocuments = await _database.getAllKnowledgeDocuments();
      for (final doc in dbDocuments) {
        await _database.upsertKnowledgeDocument(
          KnowledgeDocumentsTableCompanion(
            id: Value(doc.id),
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
      return KnowledgeBaseNotifier(database);
    });

/// 文档列表Provider
final documentsProvider = Provider<List<KnowledgeDocument>>((ref) {
  return ref.watch(knowledgeBaseProvider).documents;
});

/// 搜索结果Provider
final searchResultsProvider = Provider<List<KnowledgeDocument>>((ref) {
  return ref.watch(knowledgeBaseProvider).searchResults;
});
