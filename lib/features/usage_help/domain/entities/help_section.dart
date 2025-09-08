import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_section.freezed.dart';
part 'help_section.g.dart';

/// 帮助栏目实体
@freezed
class HelpSection with _$HelpSection {
  const factory HelpSection({
    required String id,
    required String title,
    required String icon,
    required String description,
    required List<HelpItem> items,
    @Default([]) List<String> tags,
    @Default(0) int order,
  }) = _HelpSection;

  factory HelpSection.fromJson(Map<String, dynamic> json) =>
      _$HelpSectionFromJson(json);
}

/// 帮助条目实体
@freezed
class HelpItem with _$HelpItem {
  const factory HelpItem({
    required String id,
    required String title,
    required String content,
    required HelpItemType type,
    @Default([]) List<String> tags,
    @Default([]) List<HelpStep> steps,
    @Default([]) List<String> relatedItems,
    @Default(false) bool isFrequentlyUsed,
    @Default(0) int viewCount,
  }) = _HelpItem;

  factory HelpItem.fromJson(Map<String, dynamic> json) =>
      _$HelpItemFromJson(json);
}

/// 帮助步骤实体
@freezed
class HelpStep with _$HelpStep {
  const factory HelpStep({
    required int step,
    required String title,
    required String description,
    String? imageUrl,
    @Default([]) List<String> tips,
  }) = _HelpStep;

  factory HelpStep.fromJson(Map<String, dynamic> json) =>
      _$HelpStepFromJson(json);
}

/// 帮助条目类型
enum HelpItemType {
  /// 常见问题
  faq,
  /// 使用指南
  guide,
  /// 快速入门
  quickStart,
  /// 功能介绍
  feature,
  /// 故障排除
  troubleshooting,
}

/// 帮助条目类型扩展
extension HelpItemTypeExtension on HelpItemType {
  String get displayName {
    switch (this) {
      case HelpItemType.faq:
        return '常见问题';
      case HelpItemType.guide:
        return '使用指南';
      case HelpItemType.quickStart:
        return '快速入门';
      case HelpItemType.feature:
        return '功能介绍';
      case HelpItemType.troubleshooting:
        return '故障排除';
    }
  }

  String get icon {
    switch (this) {
      case HelpItemType.faq:
        return 'help_outline';
      case HelpItemType.guide:
        return 'library_books';
      case HelpItemType.quickStart:
        return 'rocket_launch';
      case HelpItemType.feature:
        return 'star';
      case HelpItemType.troubleshooting:
        return 'build';
    }
  }
}
