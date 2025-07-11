import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';

/// 自定义提供商编辑对话框
class CustomProviderEditDialog extends ConsumerStatefulWidget {
  final LlmConfigsTableData? provider;
  final VoidCallback? onSaved;

  const CustomProviderEditDialog({super.key, this.provider, this.onSaved});

  @override
  ConsumerState<CustomProviderEditDialog> createState() =>
      _CustomProviderEditDialogState();
}

class _CustomProviderEditDialogState
    extends ConsumerState<CustomProviderEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String _selectedCompatibilityType = 'openai';
  bool _isEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 初始化字段
  void _initializeFields() {
    if (widget.provider != null) {
      final provider = widget.provider!;
      _nameController.text = provider.customProviderName ?? provider.name;
      _selectedCompatibilityType = provider.apiCompatibilityType;
      _isEnabled = provider.isEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.provider == null ? '添加自定义提供商' : '编辑自定义提供商'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 只显示基本必要信息
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '提供商名称',
                    hintText: '例如：我的自定义AI服务',
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return '请输入提供商名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCompatibilityType,
                  decoration: const InputDecoration(labelText: 'API兼容性类型'),
                  items: LlmProviderFactory.getSupportedCompatibilityTypes()
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            LlmProviderFactory.getCompatibilityTypeDisplayName(
                              type,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCompatibilityType = value!;
                    });
                  },
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return '请选择API兼容性类型';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveProvider,
          child: _isLoading
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

  /// 保存提供商
  Future<void> _saveProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final database = ref.read(appDatabaseProvider);
      final now = DateTime.now();
      final configId =
          widget.provider?.id ?? 'custom-${now.millisecondsSinceEpoch}';

      final config = LlmConfigsTableCompanion.insert(
        id: configId,
        name: _nameController.text,
        provider: 'custom-$configId',
        apiKey: '', // 创建时为空，稍后配置
        createdAt: widget.provider?.createdAt ?? now,
        updatedAt: now,
        isEnabled: drift.Value(_isEnabled),
        isCustomProvider: const drift.Value(true),
        apiCompatibilityType: drift.Value(_selectedCompatibilityType),
        customProviderName: drift.Value(_nameController.text),
      );

      await database.upsertLlmConfig(config);

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.provider == null ? '自定义提供商已添加' : '自定义提供商已更新'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
