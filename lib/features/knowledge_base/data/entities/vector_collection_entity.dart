import 'package:objectbox/objectbox.dart';

/// ObjectBox 向量集合实体
///
/// 存储向量集合的元数据信息
@Entity()
class VectorCollectionEntity {
  /// ObjectBox 自动生成的ID
  @Id()
  int id = 0;

  /// 集合名称（唯一）
  @Unique()
  String collectionName;

  /// 向量维度
  int vectorDimension;

  /// 集合描述
  String? description;

  /// 文档数量
  int documentCount;

  /// 创建时间
  DateTime createdAt;

  /// 更新时间
  DateTime updatedAt;

  /// 元数据（JSON字符串）
  String? metadata;

  /// 是否启用
  bool isEnabled;

  VectorCollectionEntity({
    required this.collectionName,
    required this.vectorDimension,
    this.description,
    this.documentCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.metadata,
    this.isEnabled = true,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collectionName': collectionName,
      'vectorDimension': vectorDimension,
      'description': description,
      'documentCount': documentCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
      'isEnabled': isEnabled,
    };
  }

  /// 从Map创建实例
  factory VectorCollectionEntity.fromMap(Map<String, dynamic> map) {
    return VectorCollectionEntity(
      collectionName: map['collectionName'] as String,
      vectorDimension: map['vectorDimension'] as int,
      description: map['description'] as String?,
      documentCount: map['documentCount'] as int? ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      metadata: map['metadata'] as String?,
      isEnabled: map['isEnabled'] as bool? ?? true,
    )..id = map['id'] as int? ?? 0;
  }

  @override
  String toString() {
    return 'VectorCollectionEntity(id: $id, name: $collectionName, '
        'dimension: $vectorDimension, documents: $documentCount)';
  }
}
