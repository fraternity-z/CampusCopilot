import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/domain/services/model_management_service.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';

/// AI提供商配置页面
class ProviderConfigScreen extends ConsumerStatefulWidget {
  final String providerId;

  const ProviderConfigScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderConfigScreen> createState() =>
      _ProviderConfigScreenState();
}

class _ProviderConfigScreenState extends ConsumerState<ProviderConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _organizationIdController = TextEditingController();

  bool _isLoading = false;
  bool _isEnabled = true;
  LlmConfigsTableData? _existingConfig;
  List<ModelInfo> _availableModels = [];

  @override
  void initState() {
    super.initState();
    _loadProviderConfig();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _organizationIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerInfo = ref.watch(providerInfoProvider(widget.providerId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${providerInfo.displayName} 配置'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveConfig,
            child: const Text('保存'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildBasicConfigCard(providerInfo),
                  const SizedBox(height: 16),
                  _buildAdvancedConfigCard(providerInfo),
                  const SizedBox(height: 16),
                  _buildModelManagementCard(),
                  const SizedBox(height: 16),
                  _buildTestConnectionCard(),
                ],
              ),
            ),
    );
  }

  /// 构建基础配置卡片
  Widget _buildBasicConfigCard(ProviderInfo providerInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getProviderIcon(widget.providerId),
                const SizedBox(width: 8),
                Text(
                  '基础配置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 配置名称
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '配置名称',
                border: OutlineInputBorder(),
                helperText: '为此配置设置一个易识别的名称',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入配置名称';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // API密钥
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API密钥',
                border: OutlineInputBorder(),
                helperText: '从提供商官网获取的API密钥',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入API密钥';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // 启用状态
            SwitchListTile(
              title: const Text('启用此配置'),
              subtitle: const Text('关闭后此配置将不会出现在选择列表中'),
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建高级配置卡片
  Widget _buildAdvancedConfigCard(ProviderInfo providerInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '高级配置',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 基础URL
            TextFormField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: '基础URL（可选）',
                border: OutlineInputBorder(),
                helperText: '自定义API端点，留空使用默认地址',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasScheme) {
                    return '请输入有效的URL';
                  }
                }
                return null;
              },
            ),

            // OpenAI专用配置
            if (widget.providerId == 'openai') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizationIdController,
                decoration: const InputDecoration(
                  labelText: '组织ID（可选）',
                  border: OutlineInputBorder(),
                  helperText: 'OpenAI组织ID，仅团队账户需要',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建模型管理卡片
  Widget _buildModelManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '可用模型',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _refreshModels,
                      icon: const Icon(Icons.refresh),
                      tooltip: '从API获取最新模型',
                    ),
                    IconButton(
                      onPressed: _addCustomModel,
                      icon: const Icon(Icons.add),
                      tooltip: '添加自定义模型',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_availableModels.isEmpty)
              const Center(child: Text('暂无可用模型，请先配置API密钥并点击刷新'))
            else
              Column(
                children: _availableModels.map((model) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: _getModelTypeIcon(model.type),
                      title: Text(model.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (model.description != null)
                            Text(model.description!),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (model.contextWindow != null)
                                Chip(
                                  label: Text('${model.contextWindow}K上下文'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              if (model.supportsVision)
                                const Chip(
                                  label: Text('视觉'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              if (model.supportsFunctionCalling)
                                const Chip(
                                  label: Text('函数调用'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => _handleModelAction(model, value),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('编辑')),
                          const PopupMenuItem(
                            value: 'duplicate',
                            child: Text('复制'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建测试连接卡片
  Widget _buildTestConnectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '连接测试',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testConnection,
                icon: const Icon(Icons.wifi_protected_setup),
                label: const Text('测试连接'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取提供商图标
  Widget _getProviderIcon(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'openai':
        return const Icon(Icons.psychology, color: Colors.green);
      case 'google':
        return const Icon(Icons.auto_awesome, color: Colors.blue);
      case 'anthropic':
        return const Icon(Icons.smart_toy, color: Colors.orange);
      default:
        return const Icon(Icons.api);
    }
  }

  /// 获取模型类型图标
  Widget _getModelTypeIcon(ModelType type) {
    switch (type) {
      case ModelType.chat:
        return const Icon(Icons.chat, color: Colors.blue);
      case ModelType.embedding:
        return const Icon(Icons.text_fields, color: Colors.green);
      case ModelType.multimodal:
        return const Icon(Icons.image, color: Colors.purple);
      case ModelType.imageGeneration:
        return const Icon(Icons.image, color: Colors.orange);
      case ModelType.speech:
        return const Icon(Icons.mic, color: Colors.red);
    }
  }

  /// 加载提供商配置
  Future<void> _loadProviderConfig() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(appDatabaseProvider);
      final configs = await database.getAllLlmConfigs();

      _existingConfig = configs.cast<LlmConfigsTableData?>().firstWhere(
        (config) => config?.provider == widget.providerId,
        orElse: () => null,
      );

      if (_existingConfig != null) {
        _nameController.text = _existingConfig!.name;
        _apiKeyController.text = _existingConfig!.apiKey;
        _baseUrlController.text = _existingConfig!.baseUrl ?? '';
        _organizationIdController.text = _existingConfig!.organizationId ?? '';
        _isEnabled = _existingConfig!.isEnabled;
      } else {
        final providerInfo = ref.read(providerInfoProvider(widget.providerId));
        _nameController.text = '${providerInfo.displayName} 配置';
      }

      await _loadModels();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载配置失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 加载模型列表
  Future<void> _loadModels() async {
    try {
      final service = ref.read(modelManagementServiceProvider);
      final models = await service.getModelsByProvider(widget.providerId);

      setState(() {
        _availableModels = models;
      });
    } catch (e) {
      // 忽略错误，使用空列表
    }
  }

  /// 保存配置
  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final database = ref.read(appDatabaseProvider);
      final now = DateTime.now();
      final configId =
          _existingConfig?.id ??
          '${widget.providerId}-${now.millisecondsSinceEpoch}';

      final config = LlmConfigsTableCompanion.insert(
        id: configId,
        name: _nameController.text,
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: drift.Value(
          _baseUrlController.text.isEmpty ? null : _baseUrlController.text,
        ),
        organizationId: drift.Value(
          _organizationIdController.text.isEmpty
              ? null
              : _organizationIdController.text,
        ),
        createdAt: _existingConfig?.createdAt ?? now,
        updatedAt: now,
        isEnabled: drift.Value(_isEnabled),
      );

      await database.upsertLlmConfig(config);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('配置保存成功')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 刷新模型列表
  Future<void> _refreshModels() async {
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入API密钥')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(modelManagementServiceProvider);
      final config = LlmConfig(
        id: 'temp',
        name: 'temp',
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text,
        organizationId: _organizationIdController.text.isEmpty
            ? null
            : _organizationIdController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final models = await service.fetchModelsFromAPI(config);

      // 同步到数据库
      for (final model in models) {
        try {
          await service.addCustomModel(
            name: model.name,
            modelId: model.id,
            provider: widget.providerId,
            description: model.description,
            type: model.type,
            contextWindow: model.contextWindow,
            maxOutputTokens: model.maxOutputTokens,
            supportsStreaming: model.supportsStreaming,
            supportsFunctionCalling: model.supportsFunctionCalling,
            supportsVision: model.supportsVision,
            inputPrice: model.pricing?.inputPrice,
            outputPrice: model.pricing?.outputPrice,
            currency: model.pricing?.currency ?? 'USD',
            capabilities: model.capabilities,
          );
        } catch (e) {
          // 忽略重复模型错误
        }
      }

      await _loadModels();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('成功获取 ${models.length} 个模型')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('获取模型失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 添加自定义模型
  void _addCustomModel() {
    _showModelEditDialog();
  }

  /// 处理模型操作
  void _handleModelAction(ModelInfo model, String action) {
    switch (action) {
      case 'edit':
        _showModelEditDialog(model: model);
        break;
      case 'duplicate':
        _duplicateModel(model);
        break;
      case 'delete':
        _deleteModel(model);
        break;
    }
  }

  /// 显示模型编辑对话框
  void _showModelEditDialog({ModelInfo? model}) {
    showDialog(
      context: context,
      builder: (context) => ModelEditDialog(
        providerId: widget.providerId,
        model: model,
        onSaved: _loadModels,
      ),
    );
  }

  /// 复制模型
  Future<void> _duplicateModel(ModelInfo model) async {
    try {
      final service = ref.read(modelManagementServiceProvider);
      await service.addCustomModel(
        name: '${model.name} (副本)',
        modelId: '${model.id}-copy',
        provider: widget.providerId,
        description: model.description,
        type: model.type,
        contextWindow: model.contextWindow,
        maxOutputTokens: model.maxOutputTokens,
        supportsStreaming: model.supportsStreaming,
        supportsFunctionCalling: model.supportsFunctionCalling,
        supportsVision: model.supportsVision,
        inputPrice: model.pricing?.inputPrice,
        outputPrice: model.pricing?.outputPrice,
        currency: model.pricing?.currency ?? 'USD',
        capabilities: model.capabilities,
      );
      await _loadModels();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('复制模型失败: $e')));
      }
    }
  }

  /// 删除模型
  Future<void> _deleteModel(ModelInfo model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除模型 "${model.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(modelManagementServiceProvider);
        await service.deleteCustomModel(model.id);
        await _loadModels();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('删除模型失败: $e')));
        }
      }
    }
  }

  /// 测试连接
  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final config = LlmConfig(
        id: 'test',
        name: 'test',
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text,
        organizationId: _organizationIdController.text.isEmpty
            ? null
            : _organizationIdController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final provider = LlmProviderFactory.createProvider(config);
      final isValid = await provider.validateConfig();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isValid ? '连接测试成功' : '连接测试失败'),
            backgroundColor: isValid ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('连接测试失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

/// 模型编辑对话框
class ModelEditDialog extends ConsumerStatefulWidget {
  final String providerId;
  final ModelInfo? model;
  final VoidCallback onSaved;

  const ModelEditDialog({
    super.key,
    required this.providerId,
    this.model,
    required this.onSaved,
  });

  @override
  ConsumerState<ModelEditDialog> createState() => _ModelEditDialogState();
}

class _ModelEditDialogState extends ConsumerState<ModelEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contextWindowController = TextEditingController();
  final _maxOutputTokensController = TextEditingController();
  final _inputPriceController = TextEditingController();
  final _outputPriceController = TextEditingController();

  ModelType _selectedType = ModelType.chat;
  bool _supportsStreaming = true;
  bool _supportsFunctionCalling = false;
  bool _supportsVision = false;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _modelIdController.text = widget.model!.id;
      _descriptionController.text = widget.model!.description ?? '';
      _contextWindowController.text =
          widget.model!.contextWindow?.toString() ?? '';
      _maxOutputTokensController.text =
          widget.model!.maxOutputTokens?.toString() ?? '';
      _inputPriceController.text =
          widget.model!.pricing?.inputPrice?.toString() ?? '';
      _outputPriceController.text =
          widget.model!.pricing?.outputPrice?.toString() ?? '';
      _selectedType = widget.model!.type;
      _supportsStreaming = widget.model!.supportsStreaming;
      _supportsFunctionCalling = widget.model!.supportsFunctionCalling;
      _supportsVision = widget.model!.supportsVision;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.model == null ? '添加模型' : '编辑模型'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '模型名称'),
                  validator: (value) =>
                      value?.isEmpty == true ? '请输入模型名称' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelIdController,
                  decoration: const InputDecoration(labelText: '模型ID'),
                  validator: (value) =>
                      value?.isEmpty == true ? '请输入模型ID' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: '描述'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ModelType>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: '模型类型'),
                  items: ModelType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getModelTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contextWindowController,
                        decoration: const InputDecoration(labelText: '上下文窗口'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxOutputTokensController,
                        decoration: const InputDecoration(
                          labelText: '最大输出Token',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _inputPriceController,
                        decoration: const InputDecoration(labelText: '输入价格'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _outputPriceController,
                        decoration: const InputDecoration(labelText: '输出价格'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('支持流式响应'),
                  value: _supportsStreaming,
                  onChanged: (value) =>
                      setState(() => _supportsStreaming = value!),
                ),
                CheckboxListTile(
                  title: const Text('支持函数调用'),
                  value: _supportsFunctionCalling,
                  onChanged: (value) =>
                      setState(() => _supportsFunctionCalling = value!),
                ),
                CheckboxListTile(
                  title: const Text('支持视觉输入'),
                  value: _supportsVision,
                  onChanged: (value) =>
                      setState(() => _supportsVision = value!),
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
        FilledButton(onPressed: _saveModel, child: const Text('保存')),
      ],
    );
  }

  String _getModelTypeName(ModelType type) {
    switch (type) {
      case ModelType.chat:
        return '聊天模型';
      case ModelType.embedding:
        return '嵌入模型';
      case ModelType.multimodal:
        return '多模态模型';
      case ModelType.imageGeneration:
        return '图像生成';
      case ModelType.speech:
        return '语音模型';
    }
  }

  Future<void> _saveModel() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final service = ref.read(modelManagementServiceProvider);

      if (widget.model == null) {
        await service.addCustomModel(
          name: _nameController.text,
          modelId: _modelIdController.text,
          provider: widget.providerId,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          type: _selectedType,
          contextWindow: _contextWindowController.text.isEmpty
              ? null
              : int.tryParse(_contextWindowController.text),
          maxOutputTokens: _maxOutputTokensController.text.isEmpty
              ? null
              : int.tryParse(_maxOutputTokensController.text),
          supportsStreaming: _supportsStreaming,
          supportsFunctionCalling: _supportsFunctionCalling,
          supportsVision: _supportsVision,
          inputPrice: _inputPriceController.text.isEmpty
              ? null
              : double.tryParse(_inputPriceController.text),
          outputPrice: _outputPriceController.text.isEmpty
              ? null
              : double.tryParse(_outputPriceController.text),
        );
      } else {
        await service.updateCustomModel(
          id: widget.model!.id,
          name: _nameController.text,
          modelId: _modelIdController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          type: _selectedType,
          contextWindow: _contextWindowController.text.isEmpty
              ? null
              : int.tryParse(_contextWindowController.text),
          maxOutputTokens: _maxOutputTokensController.text.isEmpty
              ? null
              : int.tryParse(_maxOutputTokensController.text),
          supportsStreaming: _supportsStreaming,
          supportsFunctionCalling: _supportsFunctionCalling,
          supportsVision: _supportsVision,
          inputPrice: _inputPriceController.text.isEmpty
              ? null
              : double.tryParse(_inputPriceController.text),
          outputPrice: _outputPriceController.text.isEmpty
              ? null
              : double.tryParse(_outputPriceController.text),
        );
      }

      widget.onSaved();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    }
  }
}
