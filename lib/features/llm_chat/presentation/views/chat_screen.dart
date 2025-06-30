import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/domain/entities/app_settings.dart';

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
    return Scaffold(appBar: _buildAppBar(), body: _buildMainChatArea());
  }

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer(
        builder: (context, ref, child) {
          final session = ref.watch(currentChatSessionProvider);
          return Text(session?.title ?? 'AI 助手');
        },
      ),
      actions: [
        _buildModelSelector(),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: _showSettings,
          tooltip: '设置',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// 构建主聊天区域
  Widget _buildMainChatArea() {
    return Column(
      children: [
        _buildPersonaInfoBar(),
        Expanded(child: _buildMessageList()),
        _buildInputArea(),
      ],
    );
  }

  /// 构建模型选择器
  Widget _buildModelSelector() {
    return Consumer(
      builder: (context, ref, child) {
        final allModelsAsync = ref.watch(databaseAvailableModelsProvider);
        final currentModelAsync = ref.watch(databaseCurrentModelProvider);

        return allModelsAsync.when(
          data: (allModels) => currentModelAsync.when(
            data: (currentModel) => PopupMenuButton<String>(
              tooltip: '选择模型',
              icon: const Icon(Icons.tune),
              onSelected: (value) async {
                if (value == 'configure') {
                  context.go('/settings/models');
                } else {
                  await ref.read(settingsProvider.notifier).switchModel(value);
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuEntry<String>>[];

                if (allModels.isEmpty) {
                  // 如果没有可用模型，显示配置选项
                  items.add(
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        '未配置AI模型',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem<String>(
                      value: 'configure',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(child: Text('前往配置AI')),
                        ],
                      ),
                    ),
                  );
                } else {
                  final groupedModels =
                      <AIProvider, List<ModelInfoWithProvider>>{};

                  // 按提供商分组模型
                  for (final model in allModels) {
                    groupedModels
                        .putIfAbsent(model.provider, () => [])
                        .add(model);
                  }

                  groupedModels.forEach((provider, models) {
                    if (items.isNotEmpty) {
                      items.add(const PopupMenuDivider());
                    }

                    // 添加提供商标题
                    items.add(
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text(
                          models.first.providerName,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    );

                    // 添加该提供商的模型
                    for (final model in models) {
                      items.add(
                        PopupMenuItem<String>(
                          value: model.id,
                          child: Row(
                            children: [
                              if (currentModel?.id == model.id) ...[
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                              ] else
                                const SizedBox(width: 24),
                              Expanded(child: Text(model.name)),
                            ],
                          ),
                        ),
                      );
                    }
                  });

                  // 在模型列表后添加配置选项
                  if (items.isNotEmpty) {
                    items.add(const PopupMenuDivider());
                  }
                  items.add(
                    PopupMenuItem<String>(
                      value: 'configure',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(child: Text('管理AI配置')),
                        ],
                      ),
                    ),
                  );
                }

                return items;
              },
            ),
            loading: () =>
                const IconButton(icon: Icon(Icons.tune), onPressed: null),
            error: (_, __) =>
                const IconButton(icon: Icon(Icons.tune), onPressed: null),
          ),
          loading: () =>
              const IconButton(icon: Icon(Icons.tune), onPressed: null),
          error: (_, __) =>
              const IconButton(icon: Icon(Icons.tune), onPressed: null),
        );
      },
    );
  }

  /// 构建模型信息栏
  Widget _buildPersonaInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final currentModelAsync = ref.watch(databaseCurrentModelProvider);
          return Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: currentModelAsync.when(
                  data: (currentModel) => Text(
                    currentModel?.name ?? 'AI 助手',
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  loading: () => const Text('加载中...'),
                  error: (_, __) => const Text('AI 助手'),
                ),
              ),
              const SizedBox(width: 12),
              currentModelAsync.when(
                data: (currentModel) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentModel != null
                        ? Colors.green.shade400
                        : Colors.red.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (currentModel != null
                                    ? Colors.green.shade400
                                    : Colors.red.shade400)
                                .withAlpha(128),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建消息列表
  Widget _buildMessageList() {
    return Consumer(
      builder: (context, ref, child) {
        final messages = ref.watch(chatMessagesProvider);
        final error = ref.watch(chatErrorProvider);

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(102),
                ),
                const SizedBox(height: 20),
                Text(
                  '开始新的对话',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(204),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '向您的 AI 助手发送消息以开始',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(153),
                  ),
                ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            onPressed: () => ref.read(chatProvider.notifier).clearError(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isFromUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary.withAlpha(26),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
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
                    style: textTheme.bodyLarge?.copyWith(
                      color: isUser
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: textTheme.bodySmall?.copyWith(
                      color:
                          (isUser
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface)
                              .withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondary.withAlpha(26),
              child: Icon(
                Icons.person_outline,
                size: 18,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    final attachedFiles = ref.watch(
      chatProvider.select((s) => s.attachedFiles),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 显示已附加的文件
            if (attachedFiles.isNotEmpty)
              _buildAttachedFiles(context, ref, attachedFiles),

            // 输入框和按钮
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _pickFiles(ref),
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: '附件',
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: '输入消息...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(ref),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _sendMessage(ref),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.send),
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

  /// 构建已附加文件列表
  Widget _buildAttachedFiles(
    BuildContext context,
    WidgetRef ref,
    List<PlatformFile> files,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      height: 80, // 固定高度以便滚动
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  file.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () {
                    ref.read(chatProvider.notifier).removeFile(file);
                  },
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 选择文件
  Future<void> _pickFiles(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      ref.read(chatProvider.notifier).attachFiles(result.files);
    }
  }

  /// 发送消息
  void _sendMessage(WidgetRef ref) {
    final text = _messageController.text.trim();
    ref.read(chatProvider.notifier).sendMessage(text);
    _messageController.clear();
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
