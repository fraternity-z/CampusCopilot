import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/help_provider.dart';
import '../widgets/help_search_bar.dart';
import '../widgets/help_sidebar.dart';
import '../widgets/help_content_area.dart';
import '../widgets/help_quick_access.dart';

/// 使用帮助主界面
/// 参考B站和腾讯云的帮助界面设计，采用左侧导航 + 右侧内容的布局
class UsageHelpScreen extends ConsumerStatefulWidget {
  const UsageHelpScreen({super.key});

  @override
  ConsumerState<UsageHelpScreen> createState() => _UsageHelpScreenState();
}

class _UsageHelpScreenState extends ConsumerState<UsageHelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 安全返回操作
  /// 基于用户最常见的导航模式实现返回
  void _safePop() {
    try {
      // 检查是否可以弹出（正常的路由栈弹出）
      if (GoRouter.of(context).canPop()) {
        // 可以弹出，正常返回上一级页面
        context.pop();
      } else {
        // 无法弹出，基于最常见的用户行为模式处理
        // 从应用使用情况分析，用户通常从设置页面的关于页面进入帮助页面
        debugPrint('Cannot pop, navigating to about page based on common user behavior');
        GoRouter.of(context).go('/settings/about');
      }
    } catch (e) {
      // 记录错误并提供降级方案
      debugPrint('Navigation error: $e');
      try {
        // 降级到主页面
        GoRouter.of(context).go('/chat');
      } catch (fallbackError) {
        debugPrint('Fallback navigation also failed: $fallbackError');
        // 如果都失败了，停留在当前页面
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return _buildContent(context);
    } catch (e, stackTrace) {
      debugPrint('Help page build error: $e\n$stackTrace');
      return _buildErrorFallback(context, e, stackTrace);
    }
  }

  Widget _buildContent(BuildContext context) {
    final uiState = ref.watch(helpUIStateProvider);
    final isSearching = uiState.isSearching;
    final showSidebar = uiState.showSidebar;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context, ref, isSearching),
      body: SafeArea(
        child: Row(
          children: [
            // 左侧导航栏
            if (showSidebar) ...[
              SizedBox(
                width: 280,
                child: _buildSidebarSafely(),
              ),
              Container(
                width: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],

            // 右侧内容区域
            Expanded(
              child: isSearching
                  ? _buildSearchView(context, ref)
                  : _buildMainContent(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarSafely() {
    try {
      return HelpSidebar();
    } catch (e) {
      debugPrint('Sidebar build error: $e');
      return Container(
        color: Colors.grey[100],
        child: const Center(
          child: Text('侧边栏加载失败'),
        ),
      );
    }
  }

  Widget _buildErrorFallback(BuildContext context, Object error, StackTrace stackTrace) {
    debugPrint('Help page error: $error\n$stackTrace');
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用帮助'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _safePop,
          tooltip: '返回',
        ),
      ),
      body: Center(
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
              '页面加载失败',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '请稍后重试或联系技术支持',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // 刷新页面
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, bool isSearching) {
    if (isSearching) {
      return AppBar(
        title: HelpSearchBar(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(helpUIStateProvider.notifier).endSearch();
            ref.read(searchQueryProvider.notifier).state = '';
          },
          tooltip: '返回',
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    }

    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.help_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('使用帮助'),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _safePop,
        tooltip: '返回',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            ref.read(helpUIStateProvider.notifier).startSearch();
          },
          tooltip: '搜索帮助',
        ),
        IconButton(
          icon: Icon(
            ref.watch(helpUIStateProvider).showSidebar
                ? Icons.menu_open
                : Icons.menu,
          ),
          onPressed: () {
            ref.read(helpUIStateProvider.notifier).toggleSidebar();
          },
          tooltip: '切换侧边栏',
        ),
      ],
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  /// 构建搜索视图
  Widget _buildSearchView(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Column(
      children: [
        // 搜索状态提示
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Text(
            query.isEmpty ? '请输入搜索关键词' : '搜索结果',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // 搜索结果
        Expanded(
          child: searchResults.when(
            data: (results) {
              if (query.isEmpty) {
                return _buildEmptySearchState(context);
              }

              if (results.isEmpty) {
                return _buildNoResultsState(context, query);
              }

              return _buildSearchResults(context, ref, results);
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
                    '搜索出错了',
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
      ],
    );
  }

  /// 构建主内容区域
  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final selectedItem = ref.watch(selectedHelpItemProvider);

    debugPrint('Building main content - selectedSection: $selectedSection, selectedItem: $selectedItem');

    try {
      if (selectedItem != null) {
        // 显示帮助条目详情
        debugPrint('Showing help item: $selectedItem');
        return HelpContentArea(itemId: selectedItem);
      } else if (selectedSection != null) {
        // 显示栏目内容
        debugPrint('Showing help section: $selectedSection');
        return HelpContentArea(sectionId: selectedSection);
      } else {
        // 显示首页
        debugPrint('Showing help home page');
        return _buildHomePage(context, ref);
      }
    } catch (e) {
      // 如果出现异常，显示错误状态
      debugPrint('Error building main content: $e');
      return _buildErrorState(context);
    }
  }

  /// 构建首页
  Widget _buildHomePage(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 欢迎区域
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '欢迎使用Campus Copilot',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '您的智能校园助手，让学习更高效',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '在这里您可以找到关于Campus Copilot各项功能的详细说明、使用技巧和常见问题解答。如果您是新用户，建议从"快速入门"开始。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 快速访问区域
          Text(
            '快速访问',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          HelpQuickAccess(),

          const SizedBox(height: 32),

          // 热门帮助
          Text(
            '热门帮助',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildPopularHelp(context, ref),
        ],
      ),
    );
  }

  /// 构建热门帮助
  Widget _buildPopularHelp(BuildContext context, WidgetRef ref) {
    final frequentlyUsed = ref.watch(frequentlyUsedItemsProvider);

    return frequentlyUsed.when(
      data: (items) {
        return Column(
          children: items.take(5).map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
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
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  '${item.viewCount} 次查看',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedHelpItemProvider.notifier).state = item.id;
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox(),
    );
  }


  /// 构建空搜索状态
  Widget _buildEmptySearchState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '搜索帮助内容',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '输入关键词搜索相关帮助内容',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建无结果状态
  Widget _buildNoResultsState(BuildContext context, String query) {
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
            '未找到相关内容',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '没有找到与"$query"相关的帮助内容',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建搜索结果
  Widget _buildSearchResults(BuildContext context, WidgetRef ref, List<dynamic> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(item.type),
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 20,
              ),
            ),
            title: Text(
              item.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              item.content.length > 100
                  ? '${item.content.substring(0, 100)}...'
                  : item.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(selectedHelpItemProvider.notifier).state = item.id;
              ref.read(helpUIStateProvider.notifier).endSearch();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
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
            '页面加载失败',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '请稍后重试或联系技术支持',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // 刷新页面
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重试'),
          ),
        ],
      ),
    );
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
