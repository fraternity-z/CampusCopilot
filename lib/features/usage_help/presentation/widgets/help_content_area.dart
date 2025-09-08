import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/help_section.dart';
import '../providers/help_provider.dart';

/// 帮助内容区域组件
class HelpContentArea extends ConsumerWidget {
  final String? sectionId;
  final String? itemId;

  const HelpContentArea({
    super.key,
    this.sectionId,
    this.itemId,
  }) : assert(sectionId != null || itemId != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (itemId != null) {
      return _buildItemDetail(context, ref, itemId!);
    } else {
      return _buildSectionDetail(context, ref, sectionId!);
    }
  }

  /// 构建栏目详情
  Widget _buildSectionDetail(BuildContext context, WidgetRef ref, String sectionId) {
    final sectionDetail = ref.watch(selectedSectionDetailProvider);

    return sectionDetail.when(
      data: (section) {
        if (section == null) {
          return _buildNotFoundState(context);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 栏目头部
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForName(section.icon),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          section.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 条目列表
              Text(
                '相关内容',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              ...section.items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedHelpItemProvider.notifier).state = item.id;
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getIconForType(item.type),
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                            if (item.content.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                item.content.length > 200
                                    ? '${item.content.substring(0, 200)}...'
                                    : item.content,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            if (item.tags.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: item.tags.map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => _buildErrorState(context),
    );
  }

  /// 构建条目详情
  Widget _buildItemDetail(BuildContext context, WidgetRef ref, String itemId) {
    final itemDetail = ref.watch(selectedHelpItemDetailProvider);

    return itemDetail.when(
      data: (item) {
        if (item == null) {
          return _buildNotFoundState(context);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 返回按钮
              IconButton(
                onPressed: () {
                  ref.read(selectedHelpItemProvider.notifier).state = null;
                },
                icon: const Icon(Icons.arrow_back),
                tooltip: '返回',
              ),

              const SizedBox(height: 16),

              // 条目头部
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForType(item.type),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.type.displayName,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.viewCount} 次查看',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 内容区域
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 主要内容
                    Text(
                      item.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    // 步骤内容
                    if (item.steps.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        '操作步骤',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...item.steps.map((step) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    step.step.toString(),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      step.description,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        height: 1.5,
                                      ),
                                    ),
                                    if (step.tips.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      ...step.tips.map((tip) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.lightbulb_outline,
                                                size: 16,
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  tip,
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // 标签
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Text(
                        '相关标签',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 底部导航
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToPreviousItem(context, ref, item),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('上一条'),
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToNextItem(context, ref, item),
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('下一条'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => _buildErrorState(context),
    );
  }

  /// 构建未找到状态
  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '内容未找到',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '您查找的内容可能已被删除或移动',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '请检查网络连接后重试',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 导航到上一条目
  void _navigateToPreviousItem(BuildContext context, WidgetRef ref, HelpItem currentItem) {
    // 获取当前栏目
    final currentSectionId = ref.read(selectedSectionProvider);
    if (currentSectionId == null) return;

    // 获取当前栏目的详细信息
    final sectionAsync = ref.read(selectedSectionDetailProvider);
    sectionAsync.when(
      data: (section) {
        if (section == null || section.items.isEmpty) return;

        // 找到当前条目的位置
        final currentIndex = section.items.indexWhere((item) => item.id == currentItem.id);
        if (currentIndex <= 0) return; // 已经是第一个条目

        // 导航到上一条目
        final previousItem = section.items[currentIndex - 1];
        ref.read(selectedHelpItemProvider.notifier).state = previousItem.id;
      },
      loading: () {}, // 不处理加载状态
      error: (error, stack) {}, // 不处理错误状态
    );
  }

  /// 导航到下一条目
  void _navigateToNextItem(BuildContext context, WidgetRef ref, HelpItem currentItem) {
    // 获取当前栏目
    final currentSectionId = ref.read(selectedSectionProvider);
    if (currentSectionId == null) return;

    // 获取当前栏目的详细信息
    final sectionAsync = ref.read(selectedSectionDetailProvider);
    sectionAsync.when(
      data: (section) {
        if (section == null || section.items.isEmpty) return;

        // 找到当前条目的位置
        final currentIndex = section.items.indexWhere((item) => item.id == currentItem.id);
        if (currentIndex < 0 || currentIndex >= section.items.length - 1) return; // 已经是最后一个条目或未找到

        // 导航到下一条目
        final nextItem = section.items[currentIndex + 1];
        ref.read(selectedHelpItemProvider.notifier).state = nextItem.id;
      },
      loading: () {}, // 不处理加载状态
      error: (error, stack) {}, // 不处理错误状态
    );
  }

  /// 根据图标名称获取IconData
  IconData _getIconForName(String iconName) {
    switch (iconName) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'chat':
        return Icons.chat;
      case 'folder':
        return Icons.folder;
      case 'help_outline':
        return Icons.help_outline;
      case 'school':
        return Icons.school;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'settings_applications':
        return Icons.settings_applications;
      case 'cloud':
        return Icons.cloud;
      case 'build':
        return Icons.build;
      default:
        return Icons.article;
    }
  }

  /// 根据类型获取图标
  IconData _getIconForType(dynamic type) {
    switch (type.toString()) {
      case 'HelpItemType.faq':
        return Icons.help_outline;
      case 'HelpItemType.guide':
        return Icons.library_books;
      case 'HelpItemType.quickStart':
        return Icons.rocket_launch;
      case 'HelpItemType.feature':
        return Icons.star;
      case 'HelpItemType.troubleshooting':
        return Icons.build;
      default:
        return Icons.article;
    }
  }
}
