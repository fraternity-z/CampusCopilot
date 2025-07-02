import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/llm_chat/presentation/views/chat_screen.dart';
import '../features/persona_management/presentation/widgets/persona_edit_dialog.dart';
import '../features/persona_management/presentation/widgets/preset_persona_selector_dialog.dart';
import '../features/settings/presentation/views/settings_screen.dart';

import '../features/settings/presentation/views/appearance_settings_screen.dart';
import '../features/settings/presentation/views/data_management_screen.dart';
import '../features/settings/presentation/views/about_screen.dart';
import '../features/settings/presentation/views/model_management_screen.dart';
import '../features/settings/presentation/views/provider_config_screen.dart';

import '../features/knowledge_base/presentation/views/knowledge_base_screen.dart';
import '../features/llm_chat/presentation/providers/chat_provider.dart';
import '../features/llm_chat/domain/entities/chat_session.dart';
import '../../features/persona_management/presentation/providers/persona_group_provider.dart';
import '../features/persona_management/presentation/providers/persona_provider.dart';
import '../features/persona_management/domain/entities/persona.dart';
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

/// 代码块设置状态管理
class CodeBlockSettings {
  final bool enableCodeEditing; // 启用代码块编辑功能
  final bool enableLineNumbers; // 在代码块左侧显示行号
  final bool enableCodeFolding; // 长代码块可以折叠显示
  final bool enableCodeWrapping; // 长代码行可以自动换行
  final bool defaultCollapseCodeBlocks; // 新代码块默认以折叠状态显示
  final bool enableMermaidDiagrams; // 启用Mermaid图表渲染功能

  const CodeBlockSettings({
    this.enableCodeEditing = true,
    this.enableLineNumbers = true,
    this.enableCodeFolding = true,
    this.enableCodeWrapping = true,
    this.defaultCollapseCodeBlocks = false,
    this.enableMermaidDiagrams = true,
  });

  CodeBlockSettings copyWith({
    bool? enableCodeEditing,
    bool? enableLineNumbers,
    bool? enableCodeFolding,
    bool? enableCodeWrapping,
    bool? defaultCollapseCodeBlocks,
    bool? enableMermaidDiagrams,
  }) {
    return CodeBlockSettings(
      enableCodeEditing: enableCodeEditing ?? this.enableCodeEditing,
      enableLineNumbers: enableLineNumbers ?? this.enableLineNumbers,
      enableCodeFolding: enableCodeFolding ?? this.enableCodeFolding,
      enableCodeWrapping: enableCodeWrapping ?? this.enableCodeWrapping,
      defaultCollapseCodeBlocks:
          defaultCollapseCodeBlocks ?? this.defaultCollapseCodeBlocks,
      enableMermaidDiagrams:
          enableMermaidDiagrams ?? this.enableMermaidDiagrams,
    );
  }
}

final codeBlockSettingsProvider = StateProvider<CodeBlockSettings>((ref) {
  return const CodeBlockSettings();
});

/// 常规设置状态管理
class GeneralSettings {
  final bool enableMarkdownRendering;
  final bool enableAutoSave;
  final bool enableNotifications;
  final double fontSize;
  final String language;
  final String mathEngine; // 新增：数学引擎选择

  const GeneralSettings({
    this.enableMarkdownRendering = true,
    this.enableAutoSave = true,
    this.enableNotifications = true,
    this.fontSize = 14.0,
    this.language = 'zh-CN',
    this.mathEngine = 'katex', // 默认使用KaTeX
  });

  GeneralSettings copyWith({
    bool? enableMarkdownRendering,
    bool? enableAutoSave,
    bool? enableNotifications,
    double? fontSize,
    String? language,
    String? mathEngine,
  }) {
    return GeneralSettings(
      enableMarkdownRendering:
          enableMarkdownRendering ?? this.enableMarkdownRendering,
      enableAutoSave: enableAutoSave ?? this.enableAutoSave,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      fontSize: fontSize ?? this.fontSize,
      language: language ?? this.language,
      mathEngine: mathEngine ?? this.mathEngine,
    );
  }
}

final generalSettingsProvider = StateProvider<GeneralSettings>((ref) {
  return const GeneralSettings();
});

/// 侧边栏折叠状态管理
final sidebarModelParamsExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarCodeBlockExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarGeneralExpandedProvider = StateProvider<bool>((ref) => false);

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
    final isCollapsed = ref.watch(sidebarCollapsedProvider);

    return Scaffold(
      // 添加浮动ActionButton来展开侧边栏
      floatingActionButton: isCollapsed
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                ref.read(sidebarCollapsedProvider.notifier).state = false;
              },
              tooltip: '展开侧边栏',
              child: const Icon(Icons.menu),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

      body: Stack(
        children: [
          // 主内容区域 - 现在占满整个屏幕
          child,

          // 侧边栏浮层
          if (!isCollapsed) ...[
            // 半透明背景遮罩
            GestureDetector(
              onTap: () {
                ref.read(sidebarCollapsedProvider.notifier).state = true;
              },
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // 侧边栏内容
            const NavigationSidebar(),
          ],
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
    final selectedTab = ref.watch(sidebarTabProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth > 600 ? 320.0 : screenWidth * 0.85;

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        // 添加左滑手势关闭侧边栏
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -500) {
            ref.read(sidebarCollapsedProvider.notifier).state = true;
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: sidebarWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // 应用标题和关闭按钮
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
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
                  children: [
                    Icon(
                      Icons.smart_toy,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Anywherechat',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 关闭侧边栏按钮
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () {
                        ref.read(sidebarCollapsedProvider.notifier).state =
                            true;
                      },
                      tooltip: '关闭侧边栏',
                    ),
                  ],
                ),
              ),

              // 标签页标题栏
              _buildTabBar(context, ref, selectedTab),

              // 标签页内容区域
              Expanded(child: _buildTabContent(context, ref, selectedTab)),
            ],
          ),
        ),
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
    final selectedGroupId = groupState.selectedGroupId;
    final personas = ref.watch(personaListProvider);

    // 根据选中的分组过滤助手（暂时通过助手名称模拟分组关系）
    List<Persona> filteredPersonas;
    if (selectedGroupId != null) {
      final selectedGroup = groupState.selectedGroup;
      if (selectedGroup != null) {
        // 暂时通过简单的名称匹配来模拟分组关系
        // 后续可以添加真正的groupId字段
        filteredPersonas = personas.where((persona) {
          return _getPersonaGroupId(persona) == selectedGroupId;
        }).toList();
      } else {
        filteredPersonas = [];
      }
    } else {
      filteredPersonas = personas;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 智能体管理按钮
        _buildSidebarButton(
          context,
          icon: Icons.smart_toy,
          label: '智能体管理',
          badge: null,
          onTap: () => _showCreatePersonaOptions(context, ref),
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
                onTap: () => _showCreatePersonaOptions(context, ref),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 当前过滤状态提示
        if (selectedGroupId != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  '正在显示分组: ${groupState.selectedGroup?.name ?? "未知"}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () =>
                      ref.read(personaGroupProvider.notifier).clearSelection(),
                  child: Icon(
                    Icons.clear,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

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

        // 助手列表标题
        Text(
          selectedGroupId != null ? '分组助手' : '所有助手',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // 助手列表
        if (filteredPersonas.isEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                selectedGroupId != null ? '该分组暂无助手' : '暂无助手',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ] else ...[
          ...filteredPersonas.map(
            (persona) => _buildPersonaItem(context, ref, persona),
          ),
        ],

        const SizedBox(height: 16),

        // 助手统计
        Text(
          selectedGroupId != null
              ? '分组中共 ${filteredPersonas.length} 个助手'
              : '共 ${filteredPersonas.length} 个助手',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 获取助手的分组ID（暂时用助手类型来模拟）
  String? _getPersonaGroupId(Persona persona) {
    // 暂时通过助手名称来模拟分组关系
    // 后续可以添加真正的groupId字段到数据库
    if (persona.name.contains('编程') || persona.name.contains('代码')) {
      return 'programming-group'; // 假设有一个编程分组
    } else if (persona.name.contains('写作') || persona.name.contains('文案')) {
      return 'writing-group'; // 假设有一个写作分组
    }
    return null; // 未分组
  }

  /// 构建助手条目
  Widget _buildPersonaItem(
    BuildContext context,
    WidgetRef ref,
    Persona persona,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // 选择助手并跳转到聊天页面
          ref.read(personaProvider.notifier).selectPersona(persona.id);
          context.go('/chat');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          child: Row(
            children: [
              // 助手头像
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    persona.avatar ?? persona.name.substring(0, 1),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 助手信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      persona.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (persona.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        persona.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // 默认标记
              if (persona.isDefault) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '默认',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // 更多操作按钮
              PopupMenuButton<String>(
                onSelected: (value) =>
                    _handlePersonaAction(context, ref, value, persona),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('编辑')),
                  if (!persona.isDefault)
                    const PopupMenuItem(value: 'delete', child: Text('删除')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 处理助手菜单操作
  void _handlePersonaAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    Persona persona,
  ) {
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => PersonaEditDialog(personaId: persona.id),
        );
        break;
      case 'delete':
        _showDeletePersonaDialog(context, ref, persona);
        break;
    }
  }

  /// 显示删除助手确认对话框
  void _showDeletePersonaDialog(
    BuildContext context,
    WidgetRef ref,
    Persona persona,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除助手'),
        content: Text('确定要删除助手 "${persona.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(personaProvider.notifier).deletePersona(persona.id);
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 构建分组条目
  Widget _buildGroupItem(
    BuildContext context,
    WidgetRef ref,
    PersonaGroupsTableData group,
  ) {
    final groupState = ref.watch(personaGroupProvider);
    final isSelected = groupState.selectedGroupId == group.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // 点击分组进行过滤
          final notifier = ref.read(personaGroupProvider.notifier);
          if (isSelected) {
            // 如果当前分组已选中，则取消选择（显示所有助手）
            notifier.clearSelection();
          } else {
            // 选中当前分组
            notifier.selectGroup(group.id);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.folder_open : Icons.folder,
                size: 18,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
              ),
              if (isSelected) ...[
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ],
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

  /// 显示创建智能体选项
  Future<void> _showCreatePersonaOptions(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selectedPersona = await showDialog<Persona>(
      context: context,
      builder: (context) => const PresetPersonaSelectorDialog(),
    );
    if (!context.mounted) return;
    if (selectedPersona != null) {
      showDialog(
        context: context,
        builder: (context) => PersonaEditDialog(presetPersona: selectedPersona),
      );
    } else {
      // 自定义创建
      showDialog(
        context: context,
        builder: (context) => const PersonaEditDialog(),
      );
    }
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
                    subtitle: _formatSessionTime(session.updatedAt),
                    time: '',
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(chatProvider.notifier).selectSession(session.id);
                      // 关闭侧边栏
                      ref.read(sidebarCollapsedProvider.notifier).state = true;
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
        // 模型参数折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '模型参数',
          icon: Icons.tune,
          isExpanded: ref.watch(sidebarModelParamsExpandedProvider),
          onToggle: () {
            ref.read(sidebarModelParamsExpandedProvider.notifier).state = !ref
                .read(sidebarModelParamsExpandedProvider);
          },
          content: _buildModelParametersContent(context, ref),
        ),

        const SizedBox(height: 12),

        // 代码块设置折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '代码块设置',
          icon: Icons.code,
          isExpanded: ref.watch(sidebarCodeBlockExpandedProvider),
          onToggle: () {
            ref.read(sidebarCodeBlockExpandedProvider.notifier).state = !ref
                .read(sidebarCodeBlockExpandedProvider);
          },
          content: _buildCodeBlockSettingsContent(context, ref),
        ),

        const SizedBox(height: 12),

        // 常规设置折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '常规设置',
          icon: Icons.settings,
          isExpanded: ref.watch(sidebarGeneralExpandedProvider),
          onToggle: () {
            ref.read(sidebarGeneralExpandedProvider.notifier).state = !ref.read(
              sidebarGeneralExpandedProvider,
            );
          },
          content: _buildGeneralSettingsContent(context, ref),
        ),

        const SizedBox(height: 24),

        // 重置所有设置按钮
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showResetSettingsDialog(context, ref);
            },
            child: const Text('重置所有设置'),
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

  /// 构建折叠栏组件
  Widget _buildCollapsibleSection(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // 标题栏
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(8),
                ),
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
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // 内容区域
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: content,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// 构建模型参数内容
  Widget _buildModelParametersContent(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
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
        const SizedBox(height: 16),
        // 重置模型参数按钮
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              ref.read(modelParametersProvider.notifier).state =
                  const ModelParameters();
            },
            child: const Text('重置模型参数'),
          ),
        ),
      ],
    );
  }

  /// 构建代码块设置内容
  Widget _buildCodeBlockSettingsContent(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(codeBlockSettingsProvider);

    return Column(
      children: [
        // 代码编辑开关
        _buildSettingSwitch(
          context,
          title: '代码编辑',
          subtitle: '启用代码块编辑功能',
          value: settings.enableCodeEditing,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableCodeEditing: value);
          },
        ),
        const SizedBox(height: 12),

        // 行号显示开关
        _buildSettingSwitch(
          context,
          title: '代码显示行号',
          subtitle: '在代码块左侧显示行号',
          value: settings.enableLineNumbers,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableLineNumbers: value);
          },
        ),
        const SizedBox(height: 12),

        // 代码折叠开关
        _buildSettingSwitch(
          context,
          title: '代码可折叠',
          subtitle: '长代码块可以折叠显示',
          value: settings.enableCodeFolding,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableCodeFolding: value);
          },
        ),
        const SizedBox(height: 12),

        // 代码换行开关
        _buildSettingSwitch(
          context,
          title: '代码可换行',
          subtitle: '长代码行可以自动换行',
          value: settings.enableCodeWrapping,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableCodeWrapping: value);
          },
        ),
        const SizedBox(height: 12),

        // 默认收起代码块开关
        _buildSettingSwitch(
          context,
          title: '默认收起代码块',
          subtitle: '新代码块默认以折叠状态显示',
          value: settings.defaultCollapseCodeBlocks,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(defaultCollapseCodeBlocks: value);
          },
        ),
        const SizedBox(height: 12),

        // Mermaid图表开关
        _buildSettingSwitch(
          context,
          title: 'Mermaid图表',
          subtitle: '启用Mermaid图表渲染功能',
          value: settings.enableMermaidDiagrams,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableMermaidDiagrams: value);
          },
        ),
      ],
    );
  }

  /// 构建常规设置内容
  Widget _buildGeneralSettingsContent(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(generalSettingsProvider);

    return Column(
      children: [
        // Markdown渲染开关
        _buildSettingSwitch(
          context,
          title: 'Markdown 渲染',
          subtitle: '启用 Markdown 语法支持',
          value: settings.enableMarkdownRendering,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableMarkdownRendering: value);
          },
        ),
        const SizedBox(height: 12),
        // 自动保存开关
        _buildSettingSwitch(
          context,
          title: '自动保存',
          subtitle: '自动保存对话记录',
          value: settings.enableAutoSave,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableAutoSave: value);
          },
        ),
        const SizedBox(height: 12),
        // 通知开关
        _buildSettingSwitch(
          context,
          title: '系统通知',
          subtitle: '接收应用通知',
          value: settings.enableNotifications,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableNotifications: value);
          },
        ),
        const SizedBox(height: 16),
        // 字体大小设置
        _buildParameterSlider(
          context,
          label: '字体大小',
          value: settings.fontSize,
          min: 10.0,
          max: 20.0,
          divisions: 10,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(fontSize: value);
          },
        ),
        const SizedBox(height: 16),
        // 语言选择
        _buildDropdownField(
          context,
          title: '语言',
          value: settings.language,
          items: const ['zh-CN', 'en-US'],
          onChanged: (value) {
            if (value != null) {
              ref.read(generalSettingsProvider.notifier).state = settings
                  .copyWith(language: value);
            }
          },
        ),
        const SizedBox(height: 16),
        // 数学引擎选择
        _buildDropdownField(
          context,
          title: '数学引擎',
          value: settings.mathEngine,
          items: const ['katex', 'mathjax'],
          onChanged: (value) {
            if (value != null) {
              ref.read(generalSettingsProvider.notifier).state = settings
                  .copyWith(mathEngine: value);
            }
          },
        ),
      ],
    );
  }

  /// 构建设置开关
  Widget _buildSettingSwitch(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  /// 构建下拉菜单设置
  Widget _buildDropdownField(
    BuildContext context, {
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// 显示重置设置对话框
  void _showResetSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置所有设置'),
        content: const Text('确定要重置所有设置为默认值吗？此操作不可撤销。'),
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
              // 重置所有设置
              ref.read(modelParametersProvider.notifier).state =
                  const ModelParameters();
              ref.read(codeBlockSettingsProvider.notifier).state =
                  const CodeBlockSettings();
              ref.read(generalSettingsProvider.notifier).state =
                  const GeneralSettings();
            },
            child: const Text('重置'),
          ),
        ],
      ),
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
