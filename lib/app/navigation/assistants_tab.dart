import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/ui_constants.dart';
import '../../features/persona_management/presentation/providers/persona_group_provider.dart';
import '../../features/persona_management/presentation/providers/persona_provider.dart';
import '../../features/persona_management/domain/entities/persona.dart';
import '../../features/persona_management/presentation/widgets/persona_edit_dialog.dart';
import '../../features/persona_management/presentation/widgets/preset_persona_selector_dialog.dart';
import '../../data/local/app_database.dart';
import '../widgets/sidebar_button.dart';
import '../widgets/action_button.dart';

/// 助手标签页组件
class AssistantsTab extends ConsumerWidget {
  const AssistantsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(personaGroupProvider);
    final groups = groupState.groups;
    final selectedGroupId = groupState.selectedGroupId;
    final personas = ref.watch(personaListProvider);

    // 根据选中的分组过滤助手
    final filteredPersonas = _getFilteredPersonas(
      personas, 
      selectedGroupId, 
      groupState.selectedGroup,
    );

    return ListView(
      padding: const EdgeInsets.all(UIConstants.spacingL),
      children: [
        // 智能体管理按钮
        SidebarButton(
          icon: Icons.smart_toy,
          label: '智能体管理',
          onTap: () => _showCreatePersonaOptions(context, ref),
        ),

        const SizedBox(height: UIConstants.spacingM),

        // 顶部操作按钮
        _buildActionButtons(context, ref),

        const SizedBox(height: UIConstants.spacingXL),

        // 当前过滤状态提示
        if (selectedGroupId != null) ...[
          _buildFilterIndicator(context, ref, groupState),
          const SizedBox(height: UIConstants.spacingL),
        ],

        // 分组列表
        if (groups.isNotEmpty) ...[
          ...groups.map((group) => _PersonaGroupItem(group: group)),
          const SizedBox(height: UIConstants.spacingXL),
        ],

        // 助手列表标题
        _buildAssistantsTitle(context, selectedGroupId),
        const SizedBox(height: UIConstants.spacingS),

        // 助手列表
        if (filteredPersonas.isEmpty) ...[
          _buildEmptyState(context, selectedGroupId),
        ] else ...[
          ...filteredPersonas.map(
            (persona) => _PersonaItem(persona: persona),
          ),
        ],

        const SizedBox(height: UIConstants.spacingL),

        // 助手统计
        _buildAssistantsCount(context, filteredPersonas, selectedGroupId),
      ],
    );
  }

  /// 获取过滤后的助手列表
  List<Persona> _getFilteredPersonas(
    List<Persona> personas,
    String? selectedGroupId,
    PersonaGroupsTableData? selectedGroup,
  ) {
    if (selectedGroupId == null) return personas;
    
    if (selectedGroup == null) return [];
    
    // 暂时通过简单的名称匹配来模拟分组关系
    return personas.where((persona) {
      return _getPersonaGroupId(persona) == selectedGroupId;
    }).toList();
  }

  /// 获取助手的分组ID（暂时用助手类型来模拟）
  String? _getPersonaGroupId(Persona persona) {
    if (persona.name.contains('编程') || persona.name.contains('代码')) {
      return 'programming-group';
    } else if (persona.name.contains('写作') || persona.name.contains('文案')) {
      return 'writing-group';
    }
    return null;
  }

  /// 构建操作按钮行
  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            icon: Icons.folder_outlined,
            label: '分组',
            onTap: () => _showCreateGroupDialog(context, ref),
          ),
        ),
        const SizedBox(width: UIConstants.spacingS),
        Expanded(
          child: ActionButton(
            icon: Icons.add,
            label: '助手',
            onTap: () => _showCreatePersonaOptions(context, ref),
          ),
        ),
      ],
    );
  }

  /// 构建过滤指示器
  Widget _buildFilterIndicator(
    BuildContext context,
    WidgetRef ref,
    PersonaGroupState groupState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingM,
        vertical: UIConstants.spacingS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: UIConstants.iconSizeSmall,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: UIConstants.spacingS),
          Text(
            '正在显示分组: ${groupState.selectedGroup?.name ?? "未知"}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => ref.read(personaGroupProvider.notifier).clearSelection(),
            child: Icon(
              Icons.clear,
              size: UIConstants.iconSizeSmall,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建助手列表标题
  Widget _buildAssistantsTitle(BuildContext context, String? selectedGroupId) {
    return Text(
      selectedGroupId != null ? '分组助手' : '所有助手',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context, String? selectedGroupId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.spacingL),
        child: Text(
          selectedGroupId != null ? '该分组暂无助手' : '暂无助手',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// 构建助手统计
  Widget _buildAssistantsCount(
    BuildContext context,
    List<Persona> filteredPersonas,
    String? selectedGroupId,
  ) {
    return Text(
      selectedGroupId != null
          ? '分组中共 ${filteredPersonas.length} 个助手'
          : '共 ${filteredPersonas.length} 个助手',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
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
}

/// 助手分组项组件
class _PersonaGroupItem extends ConsumerWidget {
  final PersonaGroupsTableData group;

  const _PersonaGroupItem({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(personaGroupProvider);
    final isSelected = groupState.selectedGroupId == group.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: UIConstants.spacingXS),
      child: InkWell(
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        onTap: () => _handleGroupTap(ref, isSelected),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingM,
            vertical: UIConstants.spacingS + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
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
                size: UIConstants.iconSizeSmall + 2,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : null,
              ),
              const SizedBox(width: UIConstants.spacingS),
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
                  size: UIConstants.iconSizeSmall,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: UIConstants.spacingS),
              ],
              _buildGroupMenu(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGroupTap(WidgetRef ref, bool isSelected) {
    final notifier = ref.read(personaGroupProvider.notifier);
    if (isSelected) {
      notifier.clearSelection();
    } else {
      notifier.selectGroup(group.id);
    }
  }

  Widget _buildGroupMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleGroupAction(context, ref, value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'rename', child: Text('重命名')),
        PopupMenuItem(value: 'delete', child: Text('删除')),
      ],
    );
  }

  void _handleGroupAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, ref);
        break;
      case 'delete':
        _showDeleteDialog(context, ref);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
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
                ref.read(personaGroupProvider.notifier).renameGroup(group.id, name);
              }
              Navigator.of(context).pop();
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
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
}

/// 助手项组件
class _PersonaItem extends ConsumerWidget {
  final Persona persona;

  const _PersonaItem({required this.persona});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: UIConstants.spacingXS),
      child: InkWell(
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        onTap: () => _handlePersonaTap(context, ref),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.spacingM,
            vertical: UIConstants.spacingS + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          child: Row(
            children: [
              // 助手头像
              Container(
                width: UIConstants.avatarSizeMedium,
                height: UIConstants.avatarSizeMedium,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(UIConstants.avatarSizeMedium / 2),
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
              const SizedBox(width: UIConstants.spacingM),
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
                const SizedBox(width: UIConstants.spacingS),
              ],
              // 更多操作按钮
              _buildPersonaMenu(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePersonaTap(BuildContext context, WidgetRef ref) {
    ref.read(personaProvider.notifier).selectPersona(persona.id);
    context.go('/chat');
  }

  Widget _buildPersonaMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handlePersonaAction(context, ref, value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('编辑')),
        if (!persona.isDefault)
          const PopupMenuItem(value: 'delete', child: Text('删除')),
      ],
    );
  }

  void _handlePersonaAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => PersonaEditDialog(personaId: persona.id),
        );
        break;
      case 'delete':
        _showDeleteDialog(context, ref);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
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
}
