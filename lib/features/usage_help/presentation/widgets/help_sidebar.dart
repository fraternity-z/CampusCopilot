import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/help_provider.dart';

/// 帮助侧边栏组件
class HelpSidebar extends ConsumerWidget {
  const HelpSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(helpSectionsProvider);
    final selectedSection = ref.watch(selectedSectionProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // 侧边栏头部
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '帮助目录',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // 栏目列表
          Expanded(
            child: sections.when(
              data: (sectionList) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sectionList.length,
                  itemBuilder: (context, index) {
                    final section = sectionList[index];
                    final isSelected = selectedSection == section.id;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Material(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            ref.read(selectedSectionProvider.notifier).state = section.id;
                            ref.read(selectedHelpItemProvider.notifier).state = null;
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _getIconForName(section.icon),
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        section.title,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        section.description,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.chevron_right,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '加载失败',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '请稍后重试',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 底部信息
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '需要更多帮助？',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '联系技术支持获取帮助',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
}
