import 'package:flutter/material.dart';

/// 知识库配置实体
class KnowledgeBaseConfig {
  /// 配置ID
  final String id;

  /// 配置名称
  final String name;

  /// 嵌入模型ID
  final String embeddingModelId;

  /// 嵌入模型名称
  final String embeddingModelName;

  /// 嵌入模型提供商
  final String embeddingModelProvider;

  /// 分块大小
  final int chunkSize;

  /// 分块重叠
  final int chunkOverlap;

  /// 最大检索结果数
  final int maxRetrievedChunks;

  /// 相似度阈值
  final double similarityThreshold;

  /// 是否为默认配置
  final bool isDefault;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  const KnowledgeBaseConfig({
    required this.id,
    required this.name,
    required this.embeddingModelId,
    required this.embeddingModelName,
    required this.embeddingModelProvider,
    this.chunkSize = 1000,
    this.chunkOverlap = 200,
    this.maxRetrievedChunks = 5,
    this.similarityThreshold = 0.3, // 降低默认阈值，提高召回率
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 复制并修改
  KnowledgeBaseConfig copyWith({
    String? id,
    String? name,
    String? embeddingModelId,
    String? embeddingModelName,
    String? embeddingModelProvider,
    int? chunkSize,
    int? chunkOverlap,
    int? maxRetrievedChunks,
    double? similarityThreshold,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KnowledgeBaseConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      embeddingModelId: embeddingModelId ?? this.embeddingModelId,
      embeddingModelName: embeddingModelName ?? this.embeddingModelName,
      embeddingModelProvider:
          embeddingModelProvider ?? this.embeddingModelProvider,
      chunkSize: chunkSize ?? this.chunkSize,
      chunkOverlap: chunkOverlap ?? this.chunkOverlap,
      maxRetrievedChunks: maxRetrievedChunks ?? this.maxRetrievedChunks,
      similarityThreshold: similarityThreshold ?? this.similarityThreshold,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'embeddingModelId': embeddingModelId,
      'embeddingModelName': embeddingModelName,
      'embeddingModelProvider': embeddingModelProvider,
      'chunkSize': chunkSize,
      'chunkOverlap': chunkOverlap,
      'maxRetrievedChunks': maxRetrievedChunks,
      'similarityThreshold': similarityThreshold,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 从JSON创建
  factory KnowledgeBaseConfig.fromJson(Map<String, dynamic> json) {
    return KnowledgeBaseConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      embeddingModelId: json['embeddingModelId'] as String,
      embeddingModelName: json['embeddingModelName'] as String,
      embeddingModelProvider: json['embeddingModelProvider'] as String,
      chunkSize: json['chunkSize'] as int? ?? 1000,
      chunkOverlap: json['chunkOverlap'] as int? ?? 200,
      maxRetrievedChunks: json['maxRetrievedChunks'] as int? ?? 5,
      similarityThreshold:
          (json['similarityThreshold'] as num?)?.toDouble() ?? 0.7,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 知识库文档实体
class KnowledgeDocument {
  /// 文档唯一标识符
  final String id;

  /// 文档标题
  final String title;

  /// 文档内容
  final String content;

  /// 文件路径
  final String filePath;

  /// 文件类型
  final String fileType;

  /// 文件大小（字节）
  final int fileSize;

  /// 上传时间
  final DateTime uploadedAt;

  /// 最后修改时间
  final DateTime lastModified;

  /// 处理状态
  final String status;

  /// 标签列表
  final List<String> tags;

  /// 元数据
  final Map<String, dynamic> metadata;

  const KnowledgeDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    required this.lastModified,
    required this.status,
    required this.tags,
    required this.metadata,
  });

  /// 复制并修改
  KnowledgeDocument copyWith({
    String? id,
    String? title,
    String? content,
    String? filePath,
    String? fileType,
    int? fileSize,
    DateTime? uploadedAt,
    DateTime? lastModified,
    String? status,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return KnowledgeDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      lastModified: lastModified ?? this.lastModified,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  /// 获取文件大小的可读格式
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// 获取状态的可读格式
  String get formattedStatus {
    switch (status) {
      case 'processing':
        return '处理中';
      case 'saving_chunks':
        return '保存文本块';
      case 'generating_embeddings':
        return '生成向量';
      case 'completed':
        return '已完成';
      case 'embedding_failed':
        return '向量生成失败';
      case 'failed':
        return '失败';
      case 'pending':
        return '等待中';
      default:
        return status;
    }
  }

  /// 获取文件类型图标
  IconData get fileTypeIcon {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'md':
        return Icons.article;
      case 'html':
        return Icons.web;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KnowledgeDocument && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'KnowledgeDocument(id: $id, title: $title, fileType: $fileType, status: $status)';
  }
}
