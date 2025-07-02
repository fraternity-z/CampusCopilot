import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/persona_provider.dart';
import '../providers/persona_group_provider.dart';
import '../../domain/entities/persona.dart';
import 'persona_edit_dialog.dart';
import 'preset_persona_selector_dialog.dart';

/// 智能体管理弹窗
class PersonaManagementDialog extends ConsumerStatefulWidget {
  const PersonaManagementDialog({super.key});

  @override
  ConsumerState<PersonaManagementDialog> createState() =>
      _PersonaManagementDialogState();
}

class _PersonaManagementDialogState
    extends ConsumerState<PersonaManagementDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // 标题栏
            _buildHeader(context),

            // 搜索框
            _buildSearchBar(context),

            // 标签页
            _buildTabBar(context),

            // 内容区域
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonaList(context),
                  _buildGroupList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
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
              '智能体管理',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: '关闭',
          ),
        ],
      ),
    );
  }

  /// 构建搜索框
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索智能体...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
        },
      ),
    );
  }

  /// 构建标签页栏
  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(icon: Icon(Icons.person, size: 20), text: '智能体'),
          Tab(icon: Icon(Icons.folder, size: 20), text: '分组'),
        ],
      ),
    );
  }

  /// 构建智能体列表
  Widget _buildPersonaList(BuildContext context) {
    final personas = ref.watch(personaListProvider);
    final filteredPersonas = _searchText.isEmpty
        ? personas
        : personas
              .where(
                (persona) =>
                    persona.name.toLowerCase().contains(
                      _searchText.toLowerCase(),
                    ) ||
                    (persona.description?.toLowerCase().contains(
                          _searchText.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();

    return Column(
      children: [
        // 添加按钮
        Container(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCreatePersonaOptions(context),
              icon: const Icon(Icons.add),
              label: const Text('创建新智能体'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),

        // 智能体列表
        Expanded(
          child: filteredPersonas.isEmpty
              ? _buildEmptyState(context, '暂无智能体', '点击上方按钮创建第一个智能体')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredPersonas.length,
                  itemBuilder: (context, index) {
                    final persona = filteredPersonas[index];
                    return _buildPersonaCard(context, persona);
                  },
                ),
        ),
      ],
    );
  }

  /// 构建分组列表
  Widget _buildGroupList(BuildContext context) {
    final groupState = ref.watch(personaGroupProvider);
    final groups = groupState.groups;

    return Column(
      children: [
        // 添加分组按钮
        Container(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCreateGroupDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('创建新分组'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),

        // 分组列表
        Expanded(
          child: groups.isEmpty
              ? _buildEmptyState(context, '暂无分组', '点击上方按钮创建第一个分组')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _buildGroupCard(context, group);
                  },
                ),
        ),
      ],
    );
  }

  /// 构建智能体卡片
  Widget _buildPersonaCard(BuildContext context, Persona persona) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => PersonaEditDialog(personaId: persona.id),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  persona.name.isNotEmpty ? persona.name[0].toUpperCase() : '助',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            persona.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (persona.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '默认',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (persona.description?.isNotEmpty ?? false)
                          ? persona.description!
                          : '暂无描述',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 操作按钮
              PopupMenuButton<String>(
                onSelected: (value) =>
                    _handlePersonaAction(context, value, persona),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('编辑')),
                  if (!persona.isDefault)
                    const PopupMenuItem(value: 'delete', child: Text('删除')),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建分组卡片
  Widget _buildGroupCard(BuildContext context, dynamic group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          group.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${group.personaCount ?? 0} 个智能体'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleGroupAction(context, value, group),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rename', child: Text('重命名')),
            const PopupMenuItem(value: 'delete', child: Text('删除')),
          ],
        ),
        onTap: () {
          // 选择分组并关闭弹窗
          ref.read(personaGroupProvider.notifier).selectGroup(group.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 处理智能体操作
  void _handlePersonaAction(
    BuildContext context,
    String action,
    Persona persona,
  ) {
    switch (action) {
      case 'edit':
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => PersonaEditDialog(personaId: persona.id),
        );
        break;
      case 'delete':
        _showDeletePersonaDialog(context, persona);
        break;
    }
  }

  /// 处理分组操作
  void _handleGroupAction(BuildContext context, String action, dynamic group) {
    switch (action) {
      case 'rename':
        _showRenameGroupDialog(context, group);
        break;
      case 'delete':
        _showDeleteGroupDialog(context, group);
        break;
    }
  }

  /// 显示创建分组对话框
  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建分组'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '分组名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(personaGroupProvider.notifier)
                    .createGroup(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  /// 显示重命名分组对话框
  void _showRenameGroupDialog(BuildContext context, dynamic group) {
    final TextEditingController controller = TextEditingController(
      text: group.name,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名分组'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '分组名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(personaGroupProvider.notifier)
                    .renameGroup(group.id, controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 显示删除智能体对话框
  void _showDeletePersonaDialog(BuildContext context, Persona persona) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除智能体'),
        content: Text('确定要删除智能体 "${persona.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(personaProvider.notifier).deletePersona(persona.id);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 显示删除分组对话框
  void _showDeleteGroupDialog(BuildContext context, dynamic group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分组'),
        content: Text('确定要删除分组 "${group.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(personaGroupProvider.notifier).deleteGroup(group.id);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 显示创建智能体选项
  void _showCreatePersonaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '创建新智能体',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 选择预设智能体
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.auto_awesome, color: Colors.white),
              ),
              title: const Text('选择预设智能体'),
              subtitle: const Text('从多种专业助手中选择'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                Navigator.of(context).pop();
                final selectedPersona = await showDialog<Persona>(
                  context: context,
                  builder: (context) => const PresetPersonaSelectorDialog(),
                );
                if (selectedPersona != null) {
                  if (!context.mounted) return;
                  Navigator.of(context).pop(); // 关闭管理弹窗
                  showDialog(
                    context: context,
                    builder: (context) =>
                        PersonaEditDialog(presetPersona: selectedPersona),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            // 自定义创建
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('自定义创建'),
              subtitle: const Text('从零开始创建个性化助手'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 关闭管理弹窗
                showDialog(
                  context: context,
                  builder: (context) => const PersonaEditDialog(),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
