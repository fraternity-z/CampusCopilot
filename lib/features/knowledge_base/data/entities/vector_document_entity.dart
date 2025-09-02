import 'package:objectbox/objectbox.dart';

/// ObjectBox 向量文档实体
///
/// 存储向量文档数据，支持HNSW向量索引
@Entity()
class VectorDocumentEntity {
  /// ObjectBox 自动生成的ID
  @Id()
  int id = 0;

  /// 文档唯一标识符
  @Unique()
  String documentId;

  /// 所属集合名称
  @Index()
  String collectionName;

  /// 向量数据（使用HNSW索引进行高性能近似最近邻搜索）
  /// 使用余弦距离算法，支持1536维向量（OpenAI embedding标准）
  /// 配置优化参数：neighborsPerNode=32, indexingSearchCount=200
  @HnswIndex(
    dimensions: 1536,
    distanceType: VectorDistanceType.cosine,
    neighborsPerNode: 32,
    indexingSearchCount: 200,
  )
  @Property(type: PropertyType.floatVector)
  List<double>? vector;

  /// 元数据（JSON字符串）
  String? metadata;

  /// 创建时间
  DateTime createdAt;

  /// 更新时间
  DateTime updatedAt;

  VectorDocumentEntity({
    required this.documentId,
    required this.collectionName,
    this.vector,
    this.metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentId,
      'collectionName': collectionName,
      'vector': vector,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 从Map创建实例
  factory VectorDocumentEntity.fromMap(Map<String, dynamic> map) {
    return VectorDocumentEntity(
      documentId: map['documentId'] as String,
      collectionName: map['collectionName'] as String,
      vector: (map['vector'] as List?)?.cast<double>(),
      metadata: map['metadata'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    )..id = map['id'] as int? ?? 0;
  }

  @override
  String toString() {
    return 'VectorDocumentEntity(id: $id, documentId: $documentId, '
        'collection: $collectionName, vectorDim: ${vector?.length ?? 0})';
  }
}

/// ObjectBox 向量搜索结果包装类
class VectorSearchResultWrapper {
  final VectorDocumentEntity document;
  final double score;

  const VectorSearchResultWrapper({
    required this.document,
    required this.score,
  });

  @override
  String toString() {
    return 'VectorSearchResultWrapper(documentId: ${document.documentId}, score: $score)';
  }
}
