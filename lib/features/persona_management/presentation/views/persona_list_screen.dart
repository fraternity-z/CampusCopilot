import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/persona.dart';
import '../providers/persona_provider.dart';

/// 智能体列表界面
///
/// 显示所有已创建的智能体，支持：
/// - 智能体列表展示
/// - 创建新智能体
/// - 编辑现有智能体
/// - 删除智能体
/// - 智能体搜索和筛选
class PersonaListScreen extends ConsumerStatefulWidget {
  const PersonaListScreen({super.key});

  @override
  ConsumerState<PersonaListScreen> createState() => _PersonaListScreenState();
}

class _PersonaListScreenState extends ConsumerState<PersonaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能体管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/personas/create'),
            tooltip: '创建智能体',
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          _buildSearchBar(),

          // 智能体列表
          Expanded(child: _buildPersonaList()),
        ],
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: '搜索智能体...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  /// 构建智能体列表
  Widget _buildPersonaList() {
    return Consumer(
      builder: (context, ref, child) {
        final personaState = ref.watch(personaProvider);
        final personas = personaState.personas
            .where(
              (persona) =>
                  _searchQuery.isEmpty ||
                  persona.name.toLowerCase().contains(_searchQuery) ||
                  persona.description.toLowerCase().contains(_searchQuery),
            )
            .toList();

        if (personaState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (personaState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载失败', style: TextStyle(fontSize: 18, color: Colors.red)),
                const SizedBox(height: 8),
                Text(personaState.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(personaProvider.notifier).clearError();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (personas.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: personas.length,
          itemBuilder: (context, index) {
            final persona = personas[index];
            return _buildPersonaCard(persona);
          },
        );
      },
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? '还没有智能体' : '没有找到匹配的智能体',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty ? '创建你的第一个AI智能体' : '尝试使用不同的搜索词',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/personas/create'),
              icon: const Icon(Icons.add),
              label: const Text('创建智能体'),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建智能体卡片
  Widget _buildPersonaCard(Persona persona) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectPersona(persona),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 智能体头像
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      persona.avatar ?? '🤖',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 智能体信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          persona.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          persona.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // 操作按钮
                  PopupMenuButton<String>(
                    onSelected: (value) => _handlePersonaAction(value, persona),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('编辑'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('复制'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            '删除',
                            style: TextStyle(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 智能体标签
              Row(
                children: [
                  if (persona.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '默认',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    '更新: ${_formatDate(persona.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 选择智能体
  void _selectPersona(Persona persona) {
    final ref = ProviderScope.containerOf(context);
    ref.read(personaProvider.notifier).selectPersona(persona.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已选择智能体: ${persona.name}')));
  }

  /// 处理智能体操作
  void _handlePersonaAction(String action, Persona persona) {
    switch (action) {
      case 'edit':
        context.push('/personas/edit/${persona.id}');
        break;
      case 'duplicate':
        _duplicatePersona(persona);
        break;
      case 'delete':
        _showDeleteDialog(persona);
        break;
    }
  }

  /// 复制智能体
  void _duplicatePersona(Persona persona) {
    final ref = ProviderScope.containerOf(context);
    ref.read(personaProvider.notifier).duplicatePersona(persona.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已复制智能体: ${persona.name}')));
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(Persona persona) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除智能体'),
        content: Text('确定要删除智能体 "${persona.name}" 吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePersona(persona);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 删除智能体
  void _deletePersona(Persona persona) {
    final ref = ProviderScope.containerOf(context);
    ref.read(personaProvider.notifier).deletePersona(persona.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已删除智能体: ${persona.name}')));
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
