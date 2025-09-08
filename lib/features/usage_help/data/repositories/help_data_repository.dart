import '../../domain/entities/help_section.dart';
import '../models/help_data.dart';

/// 帮助数据仓库
class HelpDataRepository {
  /// 获取所有帮助栏目
  Future<List<HelpSection>> getAllSections() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 100));
    return HelpData.sections;
  }

  /// 根据ID获取帮助栏目
  Future<HelpSection?> getSectionById(String sectionId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return HelpData.sections.firstWhere((section) => section.id == sectionId);
    } catch (e) {
      return null;
    }
  }

  /// 根据ID获取帮助条目
  Future<HelpItem?> getHelpItemById(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 50));

    for (final section in HelpData.sections) {
      try {
        return section.items.firstWhere((item) => item.id == itemId);
      } catch (e) {
        // 继续查找下一个section
      }
    }

    return null;
  }

  /// 获取常用帮助条目
  Future<List<HelpItem>> getFrequentlyUsedItems() async {
    await Future.delayed(const Duration(milliseconds: 100));

    final allItems = <HelpItem>[];
    for (final section in HelpData.sections) {
      allItems.addAll(section.items);
    }

    // 按查看次数排序，返回前几个
    allItems.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return allItems.where((item) => item.isFrequentlyUsed).toList();
  }

  /// 搜索帮助条目
  Future<List<HelpItem>> searchHelpItems(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    await Future.delayed(const Duration(milliseconds: 200));

    final allItems = <HelpItem>[];
    for (final section in HelpData.sections) {
      allItems.addAll(section.items);
    }

    final lowerQuery = query.toLowerCase();

    return allItems.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
             item.content.toLowerCase().contains(lowerQuery) ||
             item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// 获取相关帮助条目
  Future<List<HelpItem>> getRelatedItems(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final currentItem = await getHelpItemById(itemId);
    if (currentItem == null) {
      return [];
    }

    final allItems = <HelpItem>[];
    for (final section in HelpData.sections) {
      allItems.addAll(section.items);
    }

    // 查找相同标签的条目
    return allItems.where((item) {
      if (item.id == itemId) return false;

      return item.tags.any((tag) => currentItem.tags.contains(tag));
    }).take(5).toList();
  }
}
