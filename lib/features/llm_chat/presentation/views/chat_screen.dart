import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../persona_management/presentation/providers/persona_provider.dart';

/// 聊天界面
///
/// 主要的AI对话界面，包含：
/// - 消息列表显示
/// - 消息输入框
/// - 智能体选择
/// - 聊天历史管理
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildMainChatArea());
  }

  /// 构建主聊天区域
  Widget _buildMainChatArea() {
    return Column(
      children: [
        // 应用栏
        AppBar(
          automaticallyImplyLeading: false,
          title: const Text('AI 助手'),
          actions: [
            // 智能体选择按钮
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: _showPersonaSelector,
              tooltip: '选择智能体',
            ),
            // 聊天历史按钮
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: _showChatHistory,
              tooltip: '聊天历史',
            ),
            // 设置按钮
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettings,
              tooltip: '设置',
            ),
          ],
        ),

        // 当前智能体信息栏
        _buildPersonaInfoBar(),

        // 消息列表
        Expanded(child: _buildMessageList()),

        // 输入区域
        _buildInputArea(),
      ],
    );
  }

  /// 构建智能体信息栏
  Widget _buildPersonaInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final selectedPersona = ref.watch(selectedPersonaProvider);
                    return Text(
                      selectedPersona?.name ?? '通用助手',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final currentProvider = ref.watch(
                      currentAIProviderProvider,
                    );
                    final settings = ref.watch(settingsProvider);

                    String modelName = 'No AI configured';
                    if (currentProvider != null) {
                      switch (currentProvider) {
                        case AIProvider.openai:
                          modelName =
                              settings.openaiConfig?.defaultModel ??
                              'GPT-3.5 Turbo';
                          break;
                        case AIProvider.gemini:
                          modelName =
                              settings.geminiConfig?.defaultModel ??
                              'Gemini Pro';
                          break;
                        case AIProvider.claude:
                          modelName =
                              settings.claudeConfig?.defaultModel ??
                              'Claude 3 Sonnet';
                          break;
                      }
                    }

                    return Text(
                      modelName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // 连接状态指示器
          Consumer(
            builder: (context, ref, child) {
              final currentProvider = ref.watch(currentAIProviderProvider);
              final isConnected = currentProvider != null;

              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList() {
    return Consumer(
      builder: (context, ref, child) {
        final messages = ref.watch(chatMessagesProvider);
        // 序列化流加载状态供未来使用，但暂未使用
        // final isLoading = ref.watch(chatLoadingProvider);
        final error = ref.watch(chatErrorProvider);

        if (messages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '开始新的对话',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text('输入消息开始与AI助手聊天', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length + (error != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (error != null && index == messages.length) {
              return _buildErrorMessage(error);
            }
            return _buildMessageBubble(messages[index]);
          },
        );
      },
    );
  }

  /// 构建错误消息
  Widget _buildErrorMessage(String error) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                Text(error),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearError();
            },
            child: Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isFromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Theme.of(
                              context,
                            ).colorScheme.onPrimary.withValues(alpha: 0.7)
                          : Theme.of(context).colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: '输入消息...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            tooltip: '发送',
          ),
        ],
      ),
    );
  }

  /// 发送消息
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // 清空输入框
    _messageController.clear();

    // 发送消息到状态管理
    await ref.read(chatProvider.notifier).sendMessage(message);

    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 显示智能体选择器
  void _showPersonaSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final personas = ref.watch(personaListProvider);
          final selectedPersona = ref.watch(selectedPersonaProvider);

          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择智能体',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...personas.map(
                  (persona) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        persona.avatar ?? '🤖',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(persona.name),
                    subtitle: Text(persona.description),
                    trailing: selectedPersona?.id == persona.id
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      ref
                          .read(personaProvider.notifier)
                          .selectPersona(persona.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('已切换到 ${persona.name}')),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 显示聊天历史
  void _showChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('聊天历史'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Consumer(
            builder: (context, ref, child) {
              final chatState = ref.watch(chatProvider);
              final messages = chatState.messages;

              if (messages.isEmpty) {
                return const Center(child: Text('暂无聊天记录'));
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: message.isFromUser
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        message.isFromUser ? Icons.person : Icons.smart_toy,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      message.isFromUser ? '用户' : 'AI助手',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      message.content.length > 50
                          ? '${message.content.substring(0, 50)}...'
                          : message.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatProvider.notifier).clearChat();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('聊天记录已清空')));
            },
            child: const Text('清空记录'),
          ),
        ],
      ),
    );
  }

  /// 显示设置
  void _showSettings() {
    context.go('/settings');
  }

  /// 格式化时间戳
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else {
      return '${timestamp.month}/${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
