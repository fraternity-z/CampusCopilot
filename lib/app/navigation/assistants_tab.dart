import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/ui_constants.dart';
import '../../features/persona_management/presentation/providers/persona_provider.dart';
import '../../features/persona_management/domain/entities/persona.dart';
import '../../features/persona_management/presentation/widgets/persona_edit_dialog.dart';
import '../../features/persona_management/presentation/widgets/preset_persona_selector_dialog.dart';
import '../widgets/sidebar_button.dart';
import '../widgets/action_button.dart';

/// 助手标签页组件
class AssistantsTab extends ConsumerWidget {
  const AssistantsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personas = ref.watch(personaListProvider);

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

        // 创建助手按钮
        ActionButton(
          icon: Icons.add,
          label: '创建助手',
          onTap: () => _showCreatePersonaOptions(context, ref),
        ),

        const SizedBox(height: UIConstants.spacingXL),


        // 助手列表标题
        Text(
          '所有助手',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: UIConstants.spacingS),

        // 助手列表
        if (personas.isEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.spacingL),
              child: Text(
                '暂无助手',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ] else ...[
          ...personas.map(
            (persona) => _PersonaItem(persona: persona),
          ),
        ],

        const SizedBox(height: UIConstants.spacingL),

        // 助手统计
        Text(
          '共 ${personas.length} 个助手',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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
