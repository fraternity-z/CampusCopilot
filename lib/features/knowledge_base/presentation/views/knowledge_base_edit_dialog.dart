import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/multi_knowledge_base_provider.dart';
import '../providers/knowledge_base_config_provider.dart';
import '../../domain/entities/knowledge_base.dart';

/// 知识库编辑对话框
class KnowledgeBaseEditDialog extends ConsumerStatefulWidget {
  final KnowledgeBase knowledgeBase;

  const KnowledgeBaseEditDialog({super.key, required this.knowledgeBase});

  @override
  ConsumerState<KnowledgeBaseEditDialog> createState() =>
      _KnowledgeBaseEditDialogState();
}

class _KnowledgeBaseEditDialogState
    extends ConsumerState<KnowledgeBaseEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  late String? _selectedConfigId;
  late String _selectedIcon;
  late Color _selectedColor;
  late bool _isEnabled;

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.knowledgeBase.name);
    _descriptionController = TextEditingController(
      text: widget.knowledgeBase.description ?? '',
    );
    _selectedConfigId = widget.knowledgeBase.configId;
    _selectedIcon = widget.knowledgeBase.icon ?? 'library_books';
    _selectedColor = widget.knowledgeBase.getColor();
    _isEnabled = widget.knowledgeBase.isEnabled;
  }

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
      title: const Text('编辑知识库'),
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
                initialValue: _selectedConfigId,
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

              // 启用状态
              SwitchListTile(
                title: const Text('启用知识库'),
                subtitle: Text(_isEnabled ? '知识库已启用' : '知识库已禁用'),
                value: _isEnabled,
                onChanged: widget.knowledgeBase.isDefault
                    ? null // 默认知识库不能禁用
                    : (value) {
                        setState(() {
                          _isEnabled = value;
                        });
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
          onPressed: multiKbState.isLoading ? null : _updateKnowledgeBase,
          child: multiKbState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('保存'),
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

  void _updateKnowledgeBase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = UpdateKnowledgeBaseRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIcon,
      color: '#${_selectedColor.toARGB32().toRadixString(16).substring(2)}',
      configId: _selectedConfigId,
      isEnabled: _isEnabled,
    );

    try {
      await ref
          .read(multiKnowledgeBaseProvider.notifier)
          .updateKnowledgeBase(widget.knowledgeBase.id, request);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('知识库更新成功')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('更新失败: $e')));
      }
    }
  }
}
