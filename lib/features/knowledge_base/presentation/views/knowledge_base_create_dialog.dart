import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/multi_knowledge_base_provider.dart';
import '../providers/knowledge_base_config_provider.dart';
import '../../domain/entities/knowledge_base.dart';

/// 知识库创建对话框
class KnowledgeBaseCreateDialog extends ConsumerStatefulWidget {
  const KnowledgeBaseCreateDialog({super.key});

  @override
  ConsumerState<KnowledgeBaseCreateDialog> createState() =>
      _KnowledgeBaseCreateDialogState();
}

class _KnowledgeBaseCreateDialogState
    extends ConsumerState<KnowledgeBaseCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedConfigId;
  String _selectedIcon = 'library_books';
  Color _selectedColor = Colors.blue;

  final List<String> _availableIcons = [
    'library_books',
    'book',
    'folder',
    'description',
    'storage',
    'archive',
  ];

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(knowledgeBaseConfigProvider);
    final multiKbState = ref.watch(multiKnowledgeBaseProvider);

    return AlertDialog(
      title: const Text('创建知识库'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 名称输入
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '知识库名称',
                  hintText: '请输入知识库名称',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入知识库名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 描述输入
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '描述（可选）',
                  hintText: '请输入知识库描述',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // 配置选择
              DropdownButtonFormField<String>(
                value: _selectedConfigId,
                decoration: const InputDecoration(labelText: '知识库配置'),
                items: configState.configs.map((config) {
                  return DropdownMenuItem(
                    value: config.id,
                    child: Text(config.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedConfigId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '请选择知识库配置';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 图标选择
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('图标', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _availableIcons.map((iconName) {
                      final isSelected = _selectedIcon == iconName;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIcon = iconName;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconData(iconName),
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 颜色选择
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('颜色', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _availableColors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: multiKbState.isLoading ? null : _createKnowledgeBase,
          child: multiKbState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('创建'),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'book':
        return Icons.book;
      case 'folder':
        return Icons.folder;
      case 'library_books':
        return Icons.library_books;
      case 'description':
        return Icons.description;
      case 'storage':
        return Icons.storage;
      case 'archive':
        return Icons.archive;
      default:
        return Icons.library_books;
    }
  }

  void _createKnowledgeBase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = CreateKnowledgeBaseRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIcon,
      color: '#${_selectedColor.toARGB32().toRadixString(16).substring(2)}',
      configId: _selectedConfigId!,
    );

    try {
      await ref
          .read(multiKnowledgeBaseProvider.notifier)
          .createKnowledgeBase(request);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('知识库创建成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建失败: $e')));
      }
    }
  }
}
