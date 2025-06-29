import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/persona.dart';
import '../providers/persona_provider.dart';
import '../../../llm_chat/domain/services/model_management_service.dart';

/// 智能体编辑界面
///
/// 用于创建和编辑智能体，包含：
/// - 基本信息编辑
/// - 系统提示词编辑
/// - API配置选择
/// - 模型参数设置
class PersonaEditScreen extends ConsumerStatefulWidget {
  final String? personaId;

  const PersonaEditScreen({super.key, this.personaId});

  @override
  ConsumerState<PersonaEditScreen> createState() => _PersonaEditScreenState();
}

class _PersonaEditScreenState extends ConsumerState<PersonaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _systemPromptController = TextEditingController();

  String _selectedProvider = 'OpenAI';
  String _selectedModel = 'gpt-3.5-turbo';
  String _selectedAvatar = '🤖';
  double _temperature = 0.7;
  int _maxTokens = 2048;
  bool _isDefault = false;

  bool get _isEditing => widget.personaId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadPersonaData();
    } else {
      _setDefaultValues();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑智能体' : '创建智能体'),
        actions: [TextButton(onPressed: _savePersona, child: const Text('保存'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 基本信息卡片
            _buildBasicInfoCard(),

            const SizedBox(height: 16),

            // API配置卡片
            _buildApiConfigCard(),

            const SizedBox(height: 16),

            // 系统提示词卡片
            _buildSystemPromptCard(),

            const SizedBox(height: 16),

            // 高级设置卡片
            _buildAdvancedSettingsCard(),

            const SizedBox(height: 32),

            // 操作按钮
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// 构建基本信息卡片
  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '基本信息',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 名称输入框
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '智能体名称',
                hintText: '为你的智能体起个名字',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入智能体名称';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // 描述输入框
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述',
                hintText: '简单描述这个智能体的用途',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入智能体描述';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建API配置卡片
  Widget _buildApiConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI模型配置',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 供应商选择
            DropdownButtonFormField<String>(
              value: _selectedProvider,
              decoration: const InputDecoration(
                labelText: 'AI供应商',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'OpenAI', child: Text('OpenAI')),
                DropdownMenuItem(value: 'Google', child: Text('Google Gemini')),
                DropdownMenuItem(
                  value: 'Anthropic',
                  child: Text('Anthropic Claude'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProvider = value!;
                  _updateAvailableModels();
                });
              },
            ),

            const SizedBox(height: 16),

            // 模型选择（动态加载）
            Consumer(
              builder: (context, ref, _) {
                final providerKey = _selectedProvider.toLowerCase();
                final asyncModels = ref.watch(
                  modelsByProviderProvider(providerKey),
                );

                return asyncModels.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, st) => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '模型',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedModel,
                    items: [
                      DropdownMenuItem(
                        value: _selectedModel,
                        child: Text(_selectedModel),
                      ),
                    ],
                    onChanged: null,
                  ),
                  data: (models) {
                    final ids = models.map((m) => m.id).toList();
                    if (!ids.contains(_selectedModel)) {
                      _selectedModel = ids.isNotEmpty ? ids.first : '';
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedModel.isEmpty ? null : _selectedModel,
                      decoration: const InputDecoration(
                        labelText: '模型',
                        border: OutlineInputBorder(),
                      ),
                      items: ids
                          .map(
                            (id) =>
                                DropdownMenuItem(value: id, child: Text(id)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedModel = value ?? '';
                        });
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建系统提示词卡片
  Widget _buildSystemPromptCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '系统提示词',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showPromptTemplates,
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('模板'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '定义智能体的角色、行为和回答风格',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // 系统提示词输入框
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                hintText: '输入系统提示词...',
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入系统提示词';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建高级设置卡片
  Widget _buildAdvancedSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '高级设置',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 温度设置
            Text('创造性 (Temperature): ${_temperature.toStringAsFixed(1)}'),
            Slider(
              value: _temperature,
              min: 0.0,
              max: 2.0,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _temperature = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // 最大令牌数设置
            TextFormField(
              initialValue: _maxTokens.toString(),
              decoration: const InputDecoration(
                labelText: '最大令牌数',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _maxTokens = int.tryParse(value) ?? 2048;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_isEditing) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _testPersona,
              icon: const Icon(Icons.play_arrow),
              label: const Text('测试'),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _savePersona,
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? '保存更改' : '创建智能体'),
          ),
        ),
      ],
    );
  }

  /// 加载智能体数据
  void _loadPersonaData() {
    if (widget.personaId != null) {
      // 编辑模式：加载现有智能体数据
      final personas = ref.read(personaListProvider);
      final persona = personas
          .where((p) => p.id == widget.personaId)
          .firstOrNull;

      if (persona != null) {
        _nameController.text = persona.name;
        _descriptionController.text = persona.description;
        _systemPromptController.text = persona.systemPrompt;
        _selectedAvatar = persona.avatar ?? '🤖';
        setState(() {
          _isDefault = persona.isDefault;
        });
      }
    } else {
      // 创建模式：设置默认值
      _setDefaultValues();
    }
  }

  /// 设置默认值
  void _setDefaultValues() {
    _systemPromptController.text = '''你是一个有用的AI助手。请遵循以下原则：

1. 提供准确、有用的信息
2. 保持友好和专业的语调
3. 如果不确定答案，请诚实说明
4. 根据上下文调整回答的详细程度
5. 优先使用中文回答，除非用户明确要求其他语言

请根据用户的问题提供最佳回答。''';
  }

  /// 更新可用模型
  void _updateAvailableModels() {
    // 触发 Consumer 重建即可
    setState(() {});
  }

  /// 显示提示词模板
  void _showPromptTemplates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示词模板'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildTemplateItem('通用助手', '''你是一个有用的AI助手。请遵循以下原则：

1. 提供准确、有用的信息
2. 保持友好和专业的语调
3. 如果不确定答案，请诚实说明
4. 根据上下文调整回答的详细程度
5. 优先使用中文回答，除非用户明确要求其他语言

请根据用户的问题提供最佳回答。'''),

              _buildTemplateItem('创意写手', '''你是一位富有创造力的写作助手。你的特点：

1. 想象力丰富，善于创作故事和文案
2. 文笔优美，语言生动有趣
3. 能够根据不同风格和主题进行创作
4. 善于捕捉情感和氛围
5. 提供多样化的创意建议

请帮助用户进行各种创意写作任务。'''),

              _buildTemplateItem('代码专家', '''你是一位经验丰富的软件工程师。你的专长：

1. 精通多种编程语言和技术栈
2. 能够编写高质量、可维护的代码
3. 善于解释复杂的技术概念
4. 提供最佳实践和优化建议
5. 帮助调试和解决技术问题

请协助用户解决编程相关的问题。'''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 构建模板项
  Widget _buildTemplateItem(String title, String content) {
    return ListTile(
      title: Text(title),
      subtitle: Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
      onTap: () {
        _systemPromptController.text = content;
        Navigator.of(context).pop();
      },
    );
  }

  /// 测试智能体
  void _testPersona() {
    if (_nameController.text.trim().isEmpty ||
        _systemPromptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先填写智能体名称和系统提示词')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _TestPersonaDialog(
        personaName: _nameController.text.trim(),
        systemPrompt: _systemPromptController.text.trim(),
      ),
    );
  }

  /// 保存智能体
  void _savePersona() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final persona = Persona(
        id: widget.personaId ?? '', // 如果是新建，ID会在Provider中生成
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        systemPrompt: _systemPromptController.text.trim(),
        avatar: _selectedAvatar,
        isDefault: _isDefault,
        apiConfigId: 'default', // 暂时使用默认配置
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_isEditing) {
        // 更新现有智能体
        await ref.read(personaProvider.notifier).updatePersona(persona);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('智能体已更新')));
        }
      } else {
        // 创建新智能体
        await ref.read(personaProvider.notifier).createPersona(persona);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('智能体已创建')));
        }
      }

      if (mounted) {
        context.pop();
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

/// 智能体测试对话框
class _TestPersonaDialog extends StatefulWidget {
  final String personaName;
  final String systemPrompt;

  const _TestPersonaDialog({
    required this.personaName,
    required this.systemPrompt,
  });

  @override
  State<_TestPersonaDialog> createState() => _TestPersonaDialogState();
}

class _TestPersonaDialogState extends State<_TestPersonaDialog> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '测试 ${widget.personaName}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 系统提示词显示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '系统提示词:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.systemPrompt,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 聊天区域
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // 消息列表
                    Expanded(
                      child: _messages.isEmpty
                          ? Center(
                              child: Text(
                                '发送一条消息来测试智能体',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                final isUser = message['role'] == 'user';
                                return Align(
                                  alignment: isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    constraints: const BoxConstraints(
                                      maxWidth: 300,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      message['content'] ?? '',
                                      style: TextStyle(
                                        color: isUser
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    // 输入区域
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                hintText: '输入测试消息...',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onSubmitted: _isLoading
                                  ? null
                                  : (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _isLoading ? null : _sendMessage,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    _messageController.clear();

    // 模拟AI响应
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                '这是一个模拟响应。在实际应用中，这里会调用AI服务并使用系统提示词："${widget.systemPrompt.substring(0, 50)}..."来生成回复。',
          });
          _isLoading = false;
        });
      }
    });
  }
}
