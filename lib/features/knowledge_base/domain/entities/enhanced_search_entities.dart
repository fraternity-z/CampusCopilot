import '../services/vector_database_interface.dart';

/// 文档块向量数据
class DocumentChunkVector {
  final String chunkId;
  final String documentId;
  final int chunkIndex;
  final String content;
  final List<double> vector;
  final int characterCount;
  final int tokenCount;
  final DateTime createdAt;

  const DocumentChunkVector({
    required this.chunkId,
    required this.documentId,
    required this.chunkIndex,
    required this.content,
    required this.vector,
    required this.characterCount,
    required this.tokenCount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'chunkId': chunkId,
    'documentId': documentId,
    'chunkIndex': chunkIndex,
    'content': content,
    'vector': vector,
    'characterCount': characterCount,
    'tokenCount': tokenCount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DocumentChunkVector.fromJson(Map<String, dynamic> json) =>
      DocumentChunkVector(
        chunkId: json['chunkId'] as String,
        documentId: json['documentId'] as String,
        chunkIndex: json['chunkIndex'] as int,
        content: json['content'] as String,
        vector: (json['vector'] as List).cast<double>(),
        characterCount: json['characterCount'] as int,
        tokenCount: json['tokenCount'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// 增强搜索结果项
class EnhancedSearchResultItem {
  final String chunkId;
  final String documentId;
  final String content;
  final double similarity;
  final int chunkIndex;
  final Map<String, dynamic> metadata;

  const EnhancedSearchResultItem({
    required this.chunkId,
    required this.documentId,
    required this.content,
    required this.similarity,
    required this.chunkIndex,
    required this.metadata,
  });

  /// 从向量搜索结果项创建
  factory EnhancedSearchResultItem.fromVectorSearchItem(VectorSearchItem item) {
    return EnhancedSearchResultItem(
      chunkId: item.id,
      documentId: item.metadata['documentId'] as String? ?? '',
      content: item.metadata['content'] as String? ?? '',
      similarity: item.score,
      chunkIndex: item.metadata['chunkIndex'] as int? ?? 0,
      metadata: {
        ...item.metadata,
        'searchType': 'vector',
        'vector': item.vector,
      },
    );
  }

  /// 复制并修改
  EnhancedSearchResultItem copyWith({
    String? chunkId,
    String? documentId,
    String? content,
    double? similarity,
    int? chunkIndex,
    Map<String, dynamic>? metadata,
  }) {
    return EnhancedSearchResultItem(
      chunkId: chunkId ?? this.chunkId,
      documentId: documentId ?? this.documentId,
      content: content ?? this.content,
      similarity: similarity ?? this.similarity,
      chunkIndex: chunkIndex ?? this.chunkIndex,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
    'chunkId': chunkId,
    'documentId': documentId,
    'content': content,
    'similarity': similarity,
    'chunkIndex': chunkIndex,
    'metadata': metadata,
  };

  factory EnhancedSearchResultItem.fromJson(Map<String, dynamic> json) =>
      EnhancedSearchResultItem(
        chunkId: json['chunkId'] as String,
        documentId: json['documentId'] as String,
        content: json['content'] as String,
        similarity: (json['similarity'] as num).toDouble(),
        chunkIndex: json['chunkIndex'] as int,
        metadata: json['metadata'] as Map<String, dynamic>,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnhancedSearchResultItem && other.chunkId == chunkId;
  }

  @override
  int get hashCode => chunkId.hashCode;

  @override
  String toString() {
    return 'EnhancedSearchResultItem(chunkId: $chunkId, similarity: $similarity)';
  }
}

/// 增强向量搜索结果
class EnhancedVectorSearchResult {
  final List<EnhancedSearchResultItem> items;
  final int totalResults;
  final double searchTime;
  final String? error;

  const EnhancedVectorSearchResult({
    required this.items,
    required this.totalResults,
    required this.searchTime,
    this.error,
  });

  bool get isSuccess => error == null;

  /// 从向量搜索结果创建
  factory EnhancedVectorSearchResult.fromVectorSearchResult(
    VectorSearchResult result,
  ) {
    return EnhancedVectorSearchResult(
      items: result.items
          .map((item) => EnhancedSearchResultItem.fromVectorSearchItem(item))
          .toList(),
      totalResults: result.totalResults,
      searchTime: result.searchTime,
      error: result.error,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
    'totalResults': totalResults,
    'searchTime': searchTime,
    'error': error,
    'isSuccess': isSuccess,
  };

  factory EnhancedVectorSearchResult.fromJson(Map<String, dynamic> json) =>
      EnhancedVectorSearchResult(
        items: (json['items'] as List)
            .map(
              (item) => EnhancedSearchResultItem.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList(),
        totalResults: json['totalResults'] as int,
        searchTime: (json['searchTime'] as num).toDouble(),
        error: json['error'] as String?,
      );

  @override
  String toString() {
    return 'EnhancedVectorSearchResult(items: ${items.length}, totalResults: $totalResults, searchTime: ${searchTime}ms, isSuccess: $isSuccess)';
  }
}

/// 向量数据库统计信息
class VectorDatabaseStats {
  final String databaseType;
  final bool isConnected;
  final int totalCollections;
  final int totalDocuments;
  final double totalStorageSize; // MB
  final Map<String, CollectionStats> collectionStats;
  final DateTime lastUpdated;

  const VectorDatabaseStats({
    required this.databaseType,
    required this.isConnected,
    required this.totalCollections,
    required this.totalDocuments,
    required this.totalStorageSize,
    required this.collectionStats,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'databaseType': databaseType,
    'isConnected': isConnected,
    'totalCollections': totalCollections,
    'totalDocuments': totalDocuments,
    'totalStorageSize': totalStorageSize,
    'collectionStats': collectionStats.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory VectorDatabaseStats.fromJson(Map<String, dynamic> json) =>
      VectorDatabaseStats(
        databaseType: json['databaseType'] as String,
        isConnected: json['isConnected'] as bool,
        totalCollections: json['totalCollections'] as int,
        totalDocuments: json['totalDocuments'] as int,
        totalStorageSize: (json['totalStorageSize'] as num).toDouble(),
        collectionStats: (json['collectionStats'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            CollectionStats.fromJson(value as Map<String, dynamic>),
          ),
        ),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}

/// 集合统计信息
class CollectionStats {
  final String collectionName;
  final int documentCount;
  final int vectorDimension;
  final double storageSize; // MB
  final DateTime lastUpdated;

  const CollectionStats({
    required this.collectionName,
    required this.documentCount,
    required this.vectorDimension,
    required this.storageSize,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'collectionName': collectionName,
    'documentCount': documentCount,
    'vectorDimension': vectorDimension,
    'storageSize': storageSize,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory CollectionStats.fromJson(Map<String, dynamic> json) =>
      CollectionStats(
        collectionName: json['collectionName'] as String,
        documentCount: json['documentCount'] as int,
        vectorDimension: json['vectorDimension'] as int,
        storageSize: (json['storageSize'] as num).toDouble(),
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}

/// 搜索性能指标
class SearchPerformanceMetrics {
  final double averageSearchTime;
  final double minSearchTime;
  final double maxSearchTime;
  final int totalSearches;
  final double cacheHitRate;
  final Map<String, int> searchTypeDistribution;
  final DateTime periodStart;
  final DateTime periodEnd;

  const SearchPerformanceMetrics({
    required this.averageSearchTime,
    required this.minSearchTime,
    required this.maxSearchTime,
    required this.totalSearches,
    required this.cacheHitRate,
    required this.searchTypeDistribution,
    required this.periodStart,
    required this.periodEnd,
  });

  Map<String, dynamic> toJson() => {
    'averageSearchTime': averageSearchTime,
    'minSearchTime': minSearchTime,
    'maxSearchTime': maxSearchTime,
    'totalSearches': totalSearches,
    'cacheHitRate': cacheHitRate,
    'searchTypeDistribution': searchTypeDistribution,
    'periodStart': periodStart.toIso8601String(),
    'periodEnd': periodEnd.toIso8601String(),
  };

  factory SearchPerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      SearchPerformanceMetrics(
        averageSearchTime: (json['averageSearchTime'] as num).toDouble(),
        minSearchTime: (json['minSearchTime'] as num).toDouble(),
        maxSearchTime: (json['maxSearchTime'] as num).toDouble(),
        totalSearches: json['totalSearches'] as int,
        cacheHitRate: (json['cacheHitRate'] as num).toDouble(),
        searchTypeDistribution:
            (json['searchTypeDistribution'] as Map<String, dynamic>)
                .cast<String, int>(),
        periodStart: DateTime.parse(json['periodStart'] as String),
        periodEnd: DateTime.parse(json['periodEnd'] as String),
      );
}

/// 向量迁移结果
class VectorMigrationResult {
  final bool success;
  final int totalKnowledgeBases;
  final int successfulMigrations;
  final int failedMigrations;
  final int totalMigratedVectors;
  final Duration duration;
  final Map<String, KnowledgeBaseMigrationResult>? knowledgeBaseResults;
  final String? error;

  const VectorMigrationResult({
    required this.success,
    required this.totalKnowledgeBases,
    required this.successfulMigrations,
    required this.failedMigrations,
    required this.totalMigratedVectors,
    required this.duration,
    this.knowledgeBaseResults,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'totalKnowledgeBases': totalKnowledgeBases,
    'successfulMigrations': successfulMigrations,
    'failedMigrations': failedMigrations,
    'totalMigratedVectors': totalMigratedVectors,
    'duration': duration.inMilliseconds,
    'knowledgeBaseResults': knowledgeBaseResults?.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'error': error,
  };

  factory VectorMigrationResult.fromJson(Map<String, dynamic> json) =>
      VectorMigrationResult(
        success: json['success'] as bool,
        totalKnowledgeBases: json['totalKnowledgeBases'] as int,
        successfulMigrations: json['successfulMigrations'] as int,
        failedMigrations: json['failedMigrations'] as int,
        totalMigratedVectors: json['totalMigratedVectors'] as int,
        duration: Duration(milliseconds: json['duration'] as int),
        knowledgeBaseResults: json['knowledgeBaseResults'] != null
            ? (json['knowledgeBaseResults'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  KnowledgeBaseMigrationResult.fromJson(
                    value as Map<String, dynamic>,
                  ),
                ),
              )
            : null,
        error: json['error'] as String?,
      );
}

/// 知识库迁移结果
class KnowledgeBaseMigrationResult {
  final bool success;
  final String knowledgeBaseId;
  final int migratedChunks;
  final int skippedChunks;
  final Duration duration;
  final String? error;

  const KnowledgeBaseMigrationResult({
    required this.success,
    required this.knowledgeBaseId,
    required this.migratedChunks,
    required this.skippedChunks,
    required this.duration,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'knowledgeBaseId': knowledgeBaseId,
    'migratedChunks': migratedChunks,
    'skippedChunks': skippedChunks,
    'duration': duration.inMilliseconds,
    'error': error,
  };

  factory KnowledgeBaseMigrationResult.fromJson(Map<String, dynamic> json) =>
      KnowledgeBaseMigrationResult(
        success: json['success'] as bool,
        knowledgeBaseId: json['knowledgeBaseId'] as String,
        migratedChunks: json['migratedChunks'] as int,
        skippedChunks: json['skippedChunks'] as int,
        duration: Duration(milliseconds: json['duration'] as int),
        error: json['error'] as String?,
      );
}

/// 向量回滚结果
class VectorRollbackResult {
  final bool success;
  final String knowledgeBaseId;
  final Duration duration;
  final String? error;

  const VectorRollbackResult({
    required this.success,
    required this.knowledgeBaseId,
    required this.duration,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'knowledgeBaseId': knowledgeBaseId,
    'duration': duration.inMilliseconds,
    'error': error,
  };

  factory VectorRollbackResult.fromJson(Map<String, dynamic> json) =>
      VectorRollbackResult(
        success: json['success'] as bool,
        knowledgeBaseId: json['knowledgeBaseId'] as String,
        duration: Duration(milliseconds: json['duration'] as int),
        error: json['error'] as String?,
      );
}

/// 迁移状态枚举
enum MigrationStatus { notMigrated, partiallyMigrated, fullyMigrated, unknown }

extension MigrationStatusExtension on MigrationStatus {
  String get displayName {
    switch (this) {
      case MigrationStatus.notMigrated:
        return '未迁移';
      case MigrationStatus.partiallyMigrated:
        return '部分迁移';
      case MigrationStatus.fullyMigrated:
        return '完全迁移';
      case MigrationStatus.unknown:
        return '状态未知';
    }
  }

  bool get isMigrated => this == MigrationStatus.fullyMigrated;
}
