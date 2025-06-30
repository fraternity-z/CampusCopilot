import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:uuid/uuid.dart';

import '../../domain/entities/persona.dart';
import '../providers/persona_provider.dart';

/// 智能体编辑界面
///
/// 用于创建和编辑智能体，包含：
/// - 头像设置（上传图片或选择emoji）
/// - 名称编辑
/// - 提示词编辑（角色设定）
class PersonaEditScreen extends ConsumerStatefulWidget {
  final String? personaId;

  const PersonaEditScreen({super.key, this.personaId});

  @override
  ConsumerState<PersonaEditScreen> createState() => _PersonaEditScreenState();
}

class _PersonaEditScreenState extends ConsumerState<PersonaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _systemPromptController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _avatarImagePath;
  String _avatarEmoji = '🤖';
  bool _useImageAvatar = false;

  bool get _isEditing => widget.personaId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadPersonaData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            // 头像设置卡片
            _buildAvatarCard(),

            const SizedBox(height: 16),

            // 名称设置卡片
            _buildNameCard(),

            const SizedBox(height: 16),

            // 提示词设置卡片
            _buildSystemPromptCard(),

            const SizedBox(height: 32),

            // 操作按钮
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// 构建头像设置卡片
  Widget _buildAvatarCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '头像',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 头像预览
            Center(
              child: GestureDetector(
                onTap: _showAvatarOptions,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: _buildAvatarContent(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 头像选项按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('上传图片'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showEmojiPicker,
                    icon: const Icon(Icons.emoji_emotions),
                    label: const Text('选择表情'),
                  ),
                ),
              ],
            ),

            if (_useImageAvatar && _avatarImagePath != null) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _removeImage,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('移除图片'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建头像内容
  Widget _buildAvatarContent() {
    if (_useImageAvatar && _avatarImagePath != null) {
      return ClipOval(
        child: Image.file(
          File(_avatarImagePath!),
          width: 76,
          height: 76,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  /// 构建默认头像（emoji或名称首字母）
  Widget _buildDefaultAvatar() {
    String displayText = _avatarEmoji;
    if (_avatarEmoji.isEmpty && _nameController.text.isNotEmpty) {
      displayText = _nameController.text[0].toUpperCase();
    }

    return Center(
      child: Text(displayText, style: const TextStyle(fontSize: 32)),
    );
  }

  /// 构建名称设置卡片
  Widget _buildNameCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '名称',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '智能体名称',
                hintText: '为你的智能体起个名字',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // 当名称改变时，如果使用的是默认头像，需要更新显示
                if (!_useImageAvatar) {
                  setState(() {});
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入智能体名称';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建提示词设置卡片
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
                  '提示词',
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
              '定义智能体的角色、性格和行为方式。这是给AI的指令，用来告诉AI如何扮演这个角色。',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                hintText: '例如：你是一个专业的编程助手，擅长解答技术问题...',
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入提示词';
                }
                return null;
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
              icon: const Icon(Icons.chat),
              label: const Text('开始对话'),
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
        _systemPromptController.text = persona.systemPrompt;
        _avatarEmoji = persona.avatarEmoji;
        _avatarImagePath = persona.avatarImagePath;
        setState(() {
          _useImageAvatar = persona.hasImageAvatar;
        });
      }
    }
  }

  /// 显示头像选项
  void _showAvatarOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择头像'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('选择表情'),
                onTap: _showEmojiPicker,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('上传图片'),
                onTap: _pickImage,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 选择表情
  void _showEmojiPicker() {
    final commonEmojis = [
      '🤖',
      '👨‍💻',
      '👩‍💻',
      '🎯',
      '💡',
      '🚀',
      '⭐',
      '🔥',
      '💯',
      '🎨',
      '📚',
      '🔧',
      '⚡',
      '🌟',
      '🎪',
      '🎭',
      '🎮',
      '🎵',
      '🍕',
      '☕',
      '🌙',
      '🌈',
      '🦄',
      '🐱',
      '🐶',
      '🦉',
      '🐧',
      '🦊',
      '🐼',
      '🦋',
      '🌸',
      '🌺',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择表情'),
        content: SizedBox(
          width: double.maxFinite,
          height: 200,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: commonEmojis.length,
            itemBuilder: (context, index) {
              final emoji = commonEmojis[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _avatarEmoji = emoji;
                    _useImageAvatar = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _avatarEmoji == emoji
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 上传图片
  void _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${Uuid().v4()}.jpg';
      final newFile = await file.copy('${appDir.path}/$fileName');
      _avatarImagePath = newFile.path;
      setState(() {
        _useImageAvatar = true;
      });
    }
  }

  /// 移除图片
  void _removeImage() {
    _avatarImagePath = null;
    setState(() {
      _useImageAvatar = false;
    });
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
        systemPrompt: _systemPromptController.text.trim(),
        avatarImagePath: _useImageAvatar ? _avatarImagePath : null,
        avatarEmoji: _useImageAvatar ? '🤖' : _avatarEmoji,
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
