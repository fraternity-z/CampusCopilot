import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../data/local/app_database.dart';
import 'dart:convert';

part 'persona.freezed.dart';
part 'persona.g.dart';

/// 智能体实体
///
/// 表示一个AI智能体的身份设定，包含头像、名称和提示词
@freezed
class Persona with _$Persona {
  const factory Persona({
    /// 智能体唯一标识符
    required String id,

    /// 智能体名称
    required String name,

    /// 系统提示词（角色设定）
    required String systemPrompt,

    /// 创建时间
    required DateTime createdAt,

    /// 最后更新时间
    required DateTime updatedAt,

    /// 最后使用时间
    DateTime? lastUsedAt,

    /// 智能体头像图片路径（本地文件路径）
    String? avatarImagePath,

    /// 智能体头像emoji（当没有图片时使用）
    @Default('🤖') String avatarEmoji,

    /// 智能体头像 (兼容性字段)
    String? avatar,

    /// API配置ID
    String? apiConfigId,

    /// 是否为默认智能体
    @Default(false) bool isDefault,

    /// 是否启用
    @Default(true) bool isEnabled,

    /// 使用次数统计
    @Default(0) int usageCount,

    /// 智能体简短描述（可选）
    String? description,

    /// 智能体标签
    @Default([]) List<String> tags,

    /// 元数据
    Map<String, dynamic>? metadata,
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);

  factory Persona.defaultPersona() {
    final now = DateTime.now();
    return Persona(
      id: 'default_persona_id',
      name: '默认助手',
      systemPrompt: '你是一个乐于助人的AI助手。',
      createdAt: now,
      updatedAt: now,
      isDefault: true,
    );
  }
}

/// Persona扩展方法
extension PersonaExtensions on Persona {
  PersonasTableCompanion toCompanion() {
    return PersonasTableCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      systemPrompt: drift.Value(systemPrompt),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
      lastUsedAt: drift.Value(lastUsedAt),
      avatar: drift.Value(avatarDisplay),
      apiConfigId: drift.Value(apiConfigId ?? ''),
      isDefault: drift.Value(isDefault),
      isEnabled: drift.Value(isEnabled),
      usageCount: drift.Value(usageCount),
      description: drift.Value(description ?? ''),
      tags: drift.Value(jsonEncode(tags)),
      metadata: drift.Value(metadata != null ? jsonEncode(metadata) : null),
    );
  }

  /// 是否为新创建的智能体
  bool get isNew => usageCount == 0;

  /// 是否最近使用过
  bool get isRecentlyUsed {
    if (lastUsedAt == null) return false;
    final difference = DateTime.now().difference(lastUsedAt!);
    return difference.inDays < 7;
  }

  /// 获取显示名称
  String get displayName => name.isNotEmpty ? name : 'Unnamed Persona';

  /// 获取头像显示内容
  String get avatarDisplay {
    // 优先使用 avatar 字段
    if (avatar != null && avatar!.isNotEmpty) {
      return avatar!;
    }
    // 如果有图片路径，返回路径；否则返回emoji
    if (avatarImagePath != null && avatarImagePath!.isNotEmpty) {
      return avatarImagePath!;
    }
    return avatarEmoji.isNotEmpty
        ? avatarEmoji
        : name.isNotEmpty
        ? name[0].toUpperCase()
        : '🤖';
  }

  /// 是否使用图片头像
  bool get hasImageAvatar =>
      avatarImagePath != null && avatarImagePath!.isNotEmpty;

  /// 获取最后使用时间描述
  String get lastUsedDescription {
    if (lastUsedAt == null) return '从未使用';

    final now = DateTime.now();
    final difference = now.difference(lastUsedAt!);

    if (difference.inMinutes < 1) {
      return '刚刚使用';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '很久以前';
    }
  }

  /// 获取使用频率描述
  String get usageDescription {
    if (usageCount == 0) return '从未使用';
    if (usageCount == 1) return '使用1次';
    return '使用$usageCount次';
  }

  /// 复制并更新使用信息
  Persona copyWithUsage() {
    return copyWith(usageCount: usageCount + 1, lastUsedAt: DateTime.now());
  }

  /// 更新使用统计
  Persona updateUsage() {
    return copyWith(
      usageCount: usageCount + 1,
      lastUsedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// 添加标签
  Persona addTag(String tag) {
    if (tags.contains(tag)) return this;
    return copyWith(tags: [...tags, tag], updatedAt: DateTime.now());
  }

  /// 移除标签
  Persona removeTag(String tag) {
    return copyWith(
      tags: tags.where((t) => t != tag).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// 设为默认
  Persona setAsDefault() {
    return copyWith(isDefault: true, updatedAt: DateTime.now());
  }

  /// 取消默认
  Persona unsetAsDefault() {
    return copyWith(isDefault: false, updatedAt: DateTime.now());
  }
}

extension PersonasTableDataExtensions on PersonasTableData {
  Persona toPersona() {
    return Persona(
      id: id,
      name: name,
      systemPrompt: systemPrompt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastUsedAt: lastUsedAt,
      avatar: avatar,
      apiConfigId: apiConfigId,
      isDefault: isDefault,
      isEnabled: isEnabled,
      usageCount: usageCount,
      description: description,
      tags: (jsonDecode(tags) as List<dynamic>).cast<String>(),
      metadata: metadata != null
          ? jsonDecode(metadata!) as Map<String, dynamic>
          : null,
    );
  }
}
