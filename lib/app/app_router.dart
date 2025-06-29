import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/llm_chat/presentation/views/chat_screen.dart';
import '../features/persona_management/presentation/views/persona_list_screen.dart';
import '../features/settings/presentation/views/settings_screen.dart';

import '../features/settings/presentation/views/appearance_settings_screen.dart';
import '../features/settings/presentation/views/data_management_screen.dart';
import '../features/settings/presentation/views/about_screen.dart';
import '../features/settings/presentation/views/model_management_screen.dart';
import '../features/settings/presentation/views/provider_config_screen.dart';
import '../features/persona_management/presentation/views/persona_edit_screen.dart';
import '../features/knowledge_base/presentation/views/knowledge_base_screen.dart';
import '../features/llm_chat/presentation/providers/chat_provider.dart';
import '../features/llm_chat/domain/entities/chat_session.dart';
import '../../features/persona_management/presentation/providers/persona_group_provider.dart';
import '../data/local/app_database.dart';

/// 侧边栏折叠状态管理
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// 侧边栏标签页状态管理
enum SidebarTab { assistants, topics, settings }

final sidebarTabProvider = StateProvider<SidebarTab>(
  (ref) => SidebarTab.assistants,
);

/// 模型参数设置状态管理
class ModelParameters {
  final double temperature;
  final double maxTokens;
  final double topP;
  final double contextLength;

  const ModelParameters({
    this.temperature = 0.7,
    this.maxTokens = 2048,
    this.topP = 0.9,
    this.contextLength = 10,
  });

  ModelParameters copyWith({
    double? temperature,
    double? maxTokens,
    double? topP,
    double? contextLength,
  }) {
    return ModelParameters(
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      topP: topP ?? this.topP,
      contextLength: contextLength ?? this.contextLength,
    );
  }
}

final modelParametersProvider = StateProvider<ModelParameters>((ref) {
  return const ModelParameters();
});

/// 应用路由配置
///
/// 使用GoRouter实现声明式路由，支持：
/// - 深度链接
/// - 路由守卫
/// - 嵌套路由
/// - 路由重定向
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/chat',
    debugLogDiagnostics: true,

    routes: [
      // Shell路由 - 提供统一的导航框架
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // LLM聊天功能
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),

          // 智能体管理
          GoRoute(
            path: '/personas',
            name: 'personas',
            builder: (context, state) => const PersonaListScreen(),
            routes: [
              GoRoute(
                path: '/create',
                name: 'persona-create',
                builder: (context, state) => const PersonaEditScreen(),
              ),
              GoRoute(
                path: '/edit/:id',
                name: 'persona-edit',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PersonaEditScreen(personaId: id);
                },
              ),
            ],
          ),

          // 知识库管理
          GoRoute(
            path: '/knowledge',
            name: 'knowledge',
            builder: (context, state) => const KnowledgeBaseScreen(),
          ),

          // 设置
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              // 模型管理
              GoRoute(
                path: 'models',
                name: 'model-management',
                builder: (context, state) => const ModelManagementScreen(),
                routes: [
                  GoRoute(
                    path: 'provider/:providerId',
                    name: 'provider-config',
                    builder: (context, state) {
                      final providerId = state.pathParameters['providerId']!;
                      return ProviderConfigScreen(providerId: providerId);
                    },
                  ),
                ],
              ),
              // 外观设置
              GoRoute(
                path: 'appearance',
                name: 'appearance-settings',
                builder: (context, state) => const AppearanceSettingsScreen(),
              ),
              // 数据管理
              GoRoute(
                path: 'data',
                name: 'data-management',
                builder: (context, state) => const DataManagementScreen(),
              ),
              // 关于
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    // 错误页面
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

/// 主要的Shell布局，包含侧边栏导航
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          const NavigationSidebar(),

          // 主内容区域
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 侧边导航栏
class NavigationSidebar extends ConsumerWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final selectedTab = ref.watch(sidebarTabProvider);
    final width = isCollapsed ? 60.0 : 280.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // 应用标题和折叠按钮
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.smart_toy,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI 助手',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () {
                      ref.read(sidebarCollapsedProvider.notifier).state = true;
                    },
                    tooltip: '折叠侧边栏',
                  ),
                ] else ...[
                  const SizedBox(width: 4),
                  Tooltip(
                    message: '展开侧边栏',
                    child: InkWell(
                      onTap: () {
                        ref.read(sidebarCollapsedProvider.notifier).state =
                            false;
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(Icons.chevron_right, size: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 标签页标题栏
          if (!isCollapsed) _buildTabBar(context, ref, selectedTab),

          // 标签页内容区域
          Expanded(
            child: isCollapsed
                ? _buildCollapsedSidebar(context, ref)
                : _buildTabContent(context, ref, selectedTab),
          ),
        ],
      ),
    );
  }

  /// 构建标签栏
  Widget _buildTabBar(
    BuildContext context,
    WidgetRef ref,
    SidebarTab selectedTab,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(context, ref, SidebarTab.assistants, selectedTab),
          ),
          Expanded(
            child: _buildTab(context, ref, SidebarTab.topics, selectedTab),
          ),
          Expanded(
            child: _buildTab(context, ref, SidebarTab.settings, selectedTab),
          ),
        ],
      ),
    );
  }

  /// 构建单个标签
  Widget _buildTab(
    BuildContext context,
    WidgetRef ref,
    SidebarTab tab,
    SidebarTab selectedTab,
  ) {
    final isSelected = tab == selectedTab;
    final tabInfo = _getTabInfo(tab);

    return InkWell(
      onTap: () {
        ref.read(sidebarTabProvider.notifier).state = tab;
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tabInfo['icon'],
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              tabInfo['label'],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 获取标签信息
  Map<String, dynamic> _getTabInfo(SidebarTab tab) {
    switch (tab) {
      case SidebarTab.assistants:
        return {'icon': Icons.person, 'label': '助手'};
      case SidebarTab.topics:
        return {'icon': Icons.topic, 'label': '聊天记录'};
      case SidebarTab.settings:
        return {'icon': Icons.settings, 'label': '参数设置'};
    }
  }

  /// 构建折叠状态的侧边栏
  Widget _buildCollapsedSidebar(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // 助手 图标
        _buildCollapsedSectionIcon(
          context,
          icon: Icons.person,
          tooltip: '助手',
          onTap: () {
            ref.read(sidebarCollapsedProvider.notifier).state = false;
            ref.read(sidebarTabProvider.notifier).state = SidebarTab.assistants;
          },
        ),

        const SizedBox(height: 16),

        // 聊天记录 图标
        _buildCollapsedSectionIcon(
          context,
          icon: Icons.topic,
          tooltip: '聊天记录',
          onTap: () {
            ref.read(sidebarCollapsedProvider.notifier).state = false;
            ref.read(sidebarTabProvider.notifier).state = SidebarTab.topics;
          },
        ),

        const Spacer(),

        // 参数设置 图标
        _buildCollapsedSectionIcon(
          context,
          icon: Icons.settings,
          tooltip: '参数设置',
          onTap: () {
            ref.read(sidebarCollapsedProvider.notifier).state = false;
            ref.read(sidebarTabProvider.notifier).state = SidebarTab.settings;
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  /// 构建折叠状态的分区图标
  Widget _buildCollapsedSectionIcon(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// 构建标签页内容
  Widget _buildTabContent(
    BuildContext context,
    WidgetRef ref,
    SidebarTab selectedTab,
  ) {
    switch (selectedTab) {
      case SidebarTab.assistants:
        return _buildAssistantsContent(context, ref);
      case SidebarTab.topics:
        return _buildTopicsContent(context, ref);
      case SidebarTab.settings:
        return _buildSettingsContent(context, ref);
    }
  }

  /// 构建助手内容
  Widget _buildAssistantsContent(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(personaGroupProvider);
    final groups = groupState.groups;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 智能体管理按钮
        _buildSidebarButton(
          context,
          icon: Icons.smart_toy,
          label: '智能体管理',
          badge: null,
          onTap: () => context.go('/personas'),
        ),

        const SizedBox(height: 12),

        // 顶部操作按钮：添加分组 / 添加助手
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.folder_outlined,
                label: '分组',
                onTap: () => _showCreateGroupDialog(context, ref),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.add,
                label: '助手',
                onTap: () => context.go('/personas/create'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 分组列表
        if (groups.isEmpty) ...[
          Center(
            child: Text(
              '暂无助手分组',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ] else ...[
          ...groups.map((group) => _buildGroupItem(context, ref, group)),
        ],

        const SizedBox(height: 24),

        // 未分组助手标题
        Text(
          '未分组助手',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // 默认助手
        _buildAssistantItem(
          context,
          icon: '默',
          iconBg: Theme.of(context).colorScheme.primary,
          title: '默认助手',
          subtitle: '2个对话',
          onTap: () => context.go('/chat'),
        ),

        const SizedBox(height: 16),

        // 助手统计
        Text(
          '共 1 个助手',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建分组条目
  Widget _buildGroupItem(
    BuildContext context,
    WidgetRef ref,
    PersonaGroupsTableData group,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // TODO: 未来可实现点击分组过滤助手
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Row(
            children: [
              const Icon(Icons.folder, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) =>
                    _handleGroupAction(context, ref, value, group),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'rename', child: Text('重命名')),
                  const PopupMenuItem(value: 'delete', child: Text('删除')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 处理分组菜单操作
  void _handleGroupAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    PersonaGroupsTableData group,
  ) {
    switch (action) {
      case 'rename':
        _showRenameGroupDialog(context, ref, group);
        break;
      case 'delete':
        _deleteGroup(context, ref, group);
        break;
    }
  }

  void _deleteGroup(
    BuildContext context,
    WidgetRef ref,
    PersonaGroupsTableData group,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分组'),
        content: Text('确定删除分组 "${group.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(personaGroupProvider.notifier).deleteGroup(group.id);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showRenameGroupDialog(
    BuildContext context,
    WidgetRef ref,
    PersonaGroupsTableData group,
  ) {
    final controller = TextEditingController(text: group.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名分组'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '分组名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref
                    .read(personaGroupProvider.notifier)
                    .renameGroup(group.id, name);
              }
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 创建分组对话框
  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建助手分组'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '分组名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(personaGroupProvider.notifier).createGroup(name);
              }
              Navigator.of(context).pop();
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 构建聊天记录内容
  Widget _buildTopicsContent(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 标题栏
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '聊天记录',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {
                  ref.read(chatProvider.notifier).createNewSession();
                },
                tooltip: '新建对话',
              ),
            ],
          ),
        ),

        // 聊天记录列表
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              // 安全地获取数据，确保不为null
              final chatState = ref.watch(chatProvider);
              final sessions = chatState.sessions;
              final currentSession = chatState.currentSession;
              final error = chatState.error;

              // 如果有错误，显示错误信息
              if (error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '加载失败',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(chatProvider.notifier).clearError();
                          ref.invalidate(chatProvider);
                        },
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                );
              }

              // 如果会话列表为空
              if (sessions.isEmpty) {
                return const Center(
                  child: Text('暂无聊天记录', style: TextStyle(color: Colors.grey)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  final isSelected = currentSession?.id == session.id;

                  return _buildChatSessionTile(
                    context,
                    title: session.title,
                    subtitle: '${session.messageCount}条消息',
                    time: _formatSessionTime(session.updatedAt),
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(chatProvider.notifier).selectSession(session.id);
                      // 跳转到聊天页面
                      context.go('/chat');
                    },
                    onDelete: () {
                      _showDeleteSessionDialog(context, ref, session);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// 构建参数设置内容
  Widget _buildSettingsContent(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '模型参数',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 16),

        // 温度设置
        _buildParameterSlider(
          context,
          label: '温度 (Temperature)',
          value: ref.watch(modelParametersProvider).temperature,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (value) {
            ref.read(modelParametersProvider.notifier).state = ref
                .read(modelParametersProvider)
                .copyWith(temperature: value);
          },
        ),

        const SizedBox(height: 16),

        // 最大 Token 设置
        _buildParameterSlider(
          context,
          label: '最大 Token 数',
          value: ref.watch(modelParametersProvider).maxTokens,
          min: 256,
          max: 4096,
          divisions: 15,
          onChanged: (value) {
            ref.read(modelParametersProvider.notifier).state = ref
                .read(modelParametersProvider)
                .copyWith(maxTokens: value);
          },
        ),

        const SizedBox(height: 16),

        // Top P 设置
        _buildParameterSlider(
          context,
          label: 'Top P',
          value: ref.watch(modelParametersProvider).topP,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: (value) {
            ref.read(modelParametersProvider.notifier).state = ref
                .read(modelParametersProvider)
                .copyWith(topP: value);
          },
        ),

        const SizedBox(height: 24),

        Text(
          '对话设置',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 16),

        // 上下文长度设置
        _buildParameterSlider(
          context,
          label: '上下文长度',
          value: ref.watch(modelParametersProvider).contextLength,
          min: 1,
          max: 20,
          divisions: 19,
          onChanged: (value) {
            ref.read(modelParametersProvider.notifier).state = ref
                .read(modelParametersProvider)
                .copyWith(contextLength: value);
          },
        ),

        const SizedBox(height: 24),

        // 重置按钮
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              ref.read(modelParametersProvider.notifier).state =
                  const ModelParameters();
            },
            child: const Text('重置为默认值'),
          ),
        ),
      ],
    );
  }

  /// 构建侧边栏按钮
  Widget _buildSidebarButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建助手条目
  Widget _buildAssistantItem(
    BuildContext context, {
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: iconBg,
                child: Text(
                  icon,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  _handleAssistantMenuAction(context, value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('编辑')),
                  const PopupMenuItem(value: 'delete', child: Text('删除')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建聊天会话条目
  Widget _buildChatSessionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.chat_bubble_outline,
            size: 16,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected
                ? Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 16,
                color: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 8),
                      Text('删除'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        dense: true,
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建参数滑块
  Widget _buildParameterSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              value.toStringAsFixed(label.contains('Token') ? 0 : 1),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  /// 格式化会话时间
  String _formatSessionTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚才';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  /// 显示删除会话确认对话框
  void _showDeleteSessionDialog(
    BuildContext context,
    WidgetRef ref,
    ChatSession session,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除会话'),
        content: Text('确定要删除「${session.title}」吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatProvider.notifier).deleteSession(session.id);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 处理助手菜单操作
  void _handleAssistantMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('编辑助手'),
            content: const Text('编辑助手功能将在后续版本中实现！'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除助手'),
            content: const Text('确定要删除该助手吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // 删除助手功能暂未实现，显示提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('删除助手功能将在后续版本中实现'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('删除'),
              ),
            ],
          ),
        );
        break;
    }
  }
}

/// 错误页面
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错误')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('页面加载出错', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? '未知错误',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/chat'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
