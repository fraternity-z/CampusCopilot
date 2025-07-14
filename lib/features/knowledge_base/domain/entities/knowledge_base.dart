import 'package:flutter/material.dart';

/// 知识库实体
class KnowledgeBase {
  /// 知识库唯一标识符
  final String id;

  /// 知识库名称
  final String name;

  /// 知识库描述
  final String? description;

  /// 知识库图标
  final String? icon;

  /// 知识库颜色
  final String? color;

  /// 关联的配置ID
  final String configId;

  /// 文档数量
  final int documentCount;

  /// 文本块数量
  final int chunkCount;

  /// 是否为默认知识库
  final bool isDefault;

  /// 是否启用
  final bool isEnabled;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 最后使用时间
  final DateTime? lastUsedAt;

  const KnowledgeBase({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.configId,
    required this.documentCount,
    required this.chunkCount,
    required this.isDefault,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.lastUsedAt,
  });

  /// 从数据库数据创建实体
  factory KnowledgeBase.fromTableData(dynamic tableData) {
    return KnowledgeBase(
      id: tableData.id ?? '',
      name: tableData.name ?? '未命名知识库',
      description: tableData.description,
      icon: tableData.icon,
      color: tableData.color,
      configId: tableData.configId ?? 'default_config',
      documentCount: tableData.documentCount ?? 0,
      chunkCount: tableData.chunkCount ?? 0,
      isDefault: tableData.isDefault ?? false,
      isEnabled: tableData.isEnabled ?? true,
      createdAt: tableData.createdAt ?? DateTime.now(),
      updatedAt: tableData.updatedAt ?? DateTime.now(),
      lastUsedAt: tableData.lastUsedAt,
    );
  }

  /// 复制并修改
  KnowledgeBase copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? configId,
    int? documentCount,
    int? chunkCount,
    bool? isDefault,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUsedAt,
  }) {
    return KnowledgeBase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      configId: configId ?? this.configId,
      documentCount: documentCount ?? this.documentCount,
      chunkCount: chunkCount ?? this.chunkCount,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// 获取知识库颜色
  Color getColor() {
    if (color != null) {
      try {
        return Color(int.parse(color!.replaceFirst('#', '0xFF')));
      } catch (e) {
        // 如果颜色解析失败，返回默认颜色
      }
    }
    return Colors.blue;
  }

  /// 获取知识库图标
  IconData getIcon() {
    switch (icon) {
      case 'book':
        return Icons.book;
      case 'folder':
        return Icons.folder;
      case 'library_books':
        return Icons.library_books;
      case 'description':
        return Icons.description;
      case 'storage':
        return Icons.storage;
      case 'archive':
        return Icons.archive;
      default:
        return Icons.library_books;
    }
  }

  /// 获取知识库状态描述
  String getStatusDescription() {
    if (!isEnabled) {
      return '已禁用';
    }
    if (documentCount == 0) {
      return '空知识库';
    }
    return '$documentCount 个文档，$chunkCount 个文本块';
  }

  @override
  String toString() {
    return 'KnowledgeBase(id: $id, name: $name, documentCount: $documentCount, chunkCount: $chunkCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KnowledgeBase && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 知识库创建请求
class CreateKnowledgeBaseRequest {
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final String configId;

  const CreateKnowledgeBaseRequest({
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.configId,
  });
}

/// 知识库更新请求
class UpdateKnowledgeBaseRequest {
  final String? name;
  final String? description;
  final String? icon;
  final String? color;
  final String? configId;
  final bool? isEnabled;

  const UpdateKnowledgeBaseRequest({
    this.name,
    this.description,
    this.icon,
    this.color,
    this.configId,
    this.isEnabled,
  });
}
