import 'package:flutter/material.dart';

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
      case 'completed':
        return '已完成';
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
