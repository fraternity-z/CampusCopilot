/// 向量数据库抽象接口
///
/// 定义统一的向量数据库操作接口，支持多种后端实现
abstract class VectorDatabaseInterface {
  /// 初始化连接
  Future<bool> initialize();

  /// 关闭连接
  Future<void> close();

  /// 检查连接状态
  Future<bool> isHealthy();

  /// 创建集合/索引
  Future<VectorCollectionResult> createCollection({
    required String collectionName,
    required int vectorDimension,
    String? description,
    Map<String, dynamic>? metadata,
  });

  /// 删除集合
  Future<VectorOperationResult> deleteCollection(String collectionName);

  /// 检查集合是否存在
  Future<bool> collectionExists(String collectionName);

  /// 获取集合信息
  Future<VectorCollectionInfo?> getCollectionInfo(String collectionName);

  /// 插入向量数据
  Future<VectorOperationResult> insertVectors({
    required String collectionName,
    required List<VectorDocument> documents,
  });

  /// 更新向量数据
  Future<VectorOperationResult> updateVectors({
    required String collectionName,
    required List<VectorDocument> documents,
  });

  /// 删除向量数据
  Future<VectorOperationResult> deleteVectors({
    required String collectionName,
    required List<String> documentIds,
  });

  /// 向量搜索
  Future<VectorSearchResult> search({
    required String collectionName,
    required List<double> queryVector,
    int limit = 10,
    double? scoreThreshold,
    Map<String, dynamic>? filter,
  });

  /// 批量向量搜索
  Future<List<VectorSearchResult>> batchSearch({
    required String collectionName,
    required List<List<double>> queryVectors,
    int limit = 10,
    double? scoreThreshold,
    Map<String, dynamic>? filter,
  });

  /// 获取向量数据
  Future<VectorDocument?> getVector({
    required String collectionName,
    required String documentId,
  });

  /// 批量获取向量数据
  Future<List<VectorDocument>> getVectors({
    required String collectionName,
    required List<String> documentIds,
  });

  /// 统计信息
  Future<VectorCollectionStats> getCollectionStats(String collectionName);

  /// 备份集合数据
  Future<VectorBackupResult> backupCollection({
    required String collectionName,
    required String backupPath,
  });

  /// 恢复集合数据
  Future<VectorOperationResult> restoreCollection({
    required String collectionName,
    required String backupPath,
  });
}

/// 向量文档
class VectorDocument {
  final String id;
  final List<double> vector;
  final Map<String, dynamic> metadata;

  const VectorDocument({
    required this.id,
    required this.vector,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'vector': vector,
    'metadata': metadata,
  };

  factory VectorDocument.fromJson(Map<String, dynamic> json) => VectorDocument(
    id: json['id'] as String,
    vector: (json['vector'] as List).cast<double>(),
    metadata: json['metadata'] as Map<String, dynamic>,
  );
}

/// 向量搜索结果
class VectorSearchResult {
  final List<VectorSearchItem> items;
  final int totalResults;
  final double searchTime;
  final String? error;

  const VectorSearchResult({
    required this.items,
    required this.totalResults,
    required this.searchTime,
    this.error,
  });

  bool get isSuccess => error == null;
}

/// 向量搜索结果项
class VectorSearchItem {
  final String id;
  final List<double> vector;
  final Map<String, dynamic> metadata;
  final double score;

  const VectorSearchItem({
    required this.id,
    required this.vector,
    required this.metadata,
    required this.score,
  });
}

/// 向量操作结果
class VectorOperationResult {
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  const VectorOperationResult({
    required this.success,
    this.error,
    this.metadata,
  });
}

/// 向量集合结果
class VectorCollectionResult {
  final bool success;
  final String? collectionName;
  final String? error;
  final Map<String, dynamic>? metadata;

  const VectorCollectionResult({
    required this.success,
    this.collectionName,
    this.error,
    this.metadata,
  });
}

/// 向量集合信息
class VectorCollectionInfo {
  final String name;
  final int vectorDimension;
  final int documentCount;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VectorCollectionInfo({
    required this.name,
    required this.vectorDimension,
    required this.documentCount,
    this.description,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// 向量集合统计信息
class VectorCollectionStats {
  final String collectionName;
  final int documentCount;
  final int vectorDimension;
  final double averageVectorSize;
  final Map<String, dynamic>? additionalStats;

  const VectorCollectionStats({
    required this.collectionName,
    required this.documentCount,
    required this.vectorDimension,
    required this.averageVectorSize,
    this.additionalStats,
  });
}

/// 向量备份结果
class VectorBackupResult {
  final bool success;
  final String? backupPath;
  final int documentCount;
  final double backupSize; // MB
  final String? error;

  const VectorBackupResult({
    required this.success,
    this.backupPath,
    required this.documentCount,
    required this.backupSize,
    this.error,
  });
}

/// 向量数据库配置
class VectorDatabaseConfig {
  final String host;
  final int port;
  final String? apiKey;
  final bool useHttps;
  final Duration timeout;
  final Map<String, dynamic>? additionalConfig;

  const VectorDatabaseConfig({
    required this.host,
    required this.port,
    this.apiKey,
    this.useHttps = false,
    this.timeout = const Duration(seconds: 30),
    this.additionalConfig,
  });

  String get baseUrl => '${useHttps ? 'https' : 'http'}://$host:$port';
}
