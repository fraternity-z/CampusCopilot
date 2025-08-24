import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/knowledge_base_config_provider.dart';

/// 知识库配置创建对话框
class KnowledgeBaseConfigCreateDialog extends ConsumerStatefulWidget {
  const KnowledgeBaseConfigCreateDialog({super.key});

  @override
  ConsumerState<KnowledgeBaseConfigCreateDialog> createState() =>
      _KnowledgeBaseConfigCreateDialogState();
}

class _KnowledgeBaseConfigCreateDialogState
    extends ConsumerState<KnowledgeBaseConfigCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedModelId;
  String? _selectedModelName;
  String? _selectedModelProvider;

  int _chunkSize = 1000;
  int _chunkOverlap = 200;
  int _maxRetrievedChunks = 5;
  double _similarityThreshold = 0.3; // 降低默认阈值，提高召回率

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(knowledgeBaseConfigProvider);
    final availableModels = configState.availableEmbeddingModels;

    // 确保选中的模型ID在可用模型列表中
    if (_selectedModelId == null && availableModels.isNotEmpty) {
      // 优先选择 text-embedding-3-small，如果不存在则选择第一个
      final preferredModel = availableModels.firstWhere(
        (model) => model.id == 'text-embedding-3-small',
        orElse: () => availableModels.first,
      );
      _selectedModelId = preferredModel.id;
      _selectedModelName = preferredModel.name;
      _selectedModelProvider = preferredModel.provider;
    } else if (_selectedModelId != null &&
        !availableModels.any((model) => model.id == _selectedModelId)) {
      // 如果当前选中的模型不在可用列表中，重置为第一个可用模型
      if (availableModels.isNotEmpty) {
        final firstModel = availableModels.first;
        _selectedModelId = firstModel.id;
        _selectedModelName = firstModel.name;
        _selectedModelProvider = firstModel.provider;
      }
    }

    return AlertDialog(
      title: const Text('创建知识库配置'),
      content: SizedBox(
        width: double.maxFinite,
        height: 500, // 设置固定高度，避免溢出
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 配置名称
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '配置名称',
                    hintText: '请输入配置名称',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入配置名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 嵌入模型选择
                if (availableModels.isEmpty) ...[
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '没有可用的嵌入模型',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '请先到设置页面配置LLM提供商和模型',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedModelId,
                    decoration: const InputDecoration(
                      labelText: '嵌入模型',
                      hintText: '选择嵌入模型',
                    ),
                    items: availableModels.map((model) {
                      return DropdownMenuItem(
                        value: model.id,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(model.name, overflow: TextOverflow.ellipsis),
                              Text(
                                '${model.provider} • ${model.id}',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final model = availableModels.firstWhere(
                          (m) => m.id == value,
                        );
                        setState(() {
                          _selectedModelId = value;
                          _selectedModelName = model.name;
                          _selectedModelProvider = model.provider;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return '请选择嵌入模型';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),

                // 高级设置
                ExpansionTile(
                  title: const Text('高级设置'),
                  children: [
                    // 分块大小
                    TextFormField(
                      initialValue: _chunkSize.toString(),
                      decoration: const InputDecoration(
                        labelText: '分块大小',
                        hintText: '每个文本块的字符数',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final size = int.tryParse(value);
                        if (size != null && size > 0) {
                          _chunkSize = size;
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // 重叠大小
                    TextFormField(
                      initialValue: _chunkOverlap.toString(),
                      decoration: const InputDecoration(
                        labelText: '重叠大小',
                        hintText: '相邻文本块的重叠字符数',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final overlap = int.tryParse(value);
                        if (overlap != null && overlap >= 0) {
                          _chunkOverlap = overlap;
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // 最大检索块数
                    TextFormField(
                      initialValue: _maxRetrievedChunks.toString(),
                      decoration: const InputDecoration(
                        labelText: '最大检索块数',
                        hintText: '搜索时返回的最大文本块数量',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final chunks = int.tryParse(value);
                        if (chunks != null && chunks > 0) {
                          _maxRetrievedChunks = chunks;
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // 相似度阈值
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '相似度阈值: ${_similarityThreshold.toStringAsFixed(2)}',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Slider(
                            value: _similarityThreshold,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            onChanged: (value) {
                              setState(() {
                                _similarityThreshold = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
        if (availableModels.isNotEmpty)
          ElevatedButton(onPressed: _createConfig, child: const Text('创建')),
      ],
    );
  }

  void _createConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedModelId == null ||
        _selectedModelName == null ||
        _selectedModelProvider == null) {
      return;
    }

    try {
      await ref
          .read(knowledgeBaseConfigProvider.notifier)
          .createConfig(
            name: _nameController.text.trim(),
            embeddingModelId: _selectedModelId!,
            embeddingModelName: _selectedModelName!,
            embeddingModelProvider: _selectedModelProvider!,
            chunkSize: _chunkSize,
            chunkOverlap: _chunkOverlap,
            maxRetrievedChunks: _maxRetrievedChunks,
            similarityThreshold: _similarityThreshold,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('知识库配置创建成功')));
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
