import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

import 'widgets/message_content_widget.dart';
import 'widgets/model_selector_dialog.dart';
import 'widgets/message_options_button.dart';

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
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  /// 自动滚动到底部
  void _scrollToBottom({bool animate = true, bool gentle = false}) {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animate) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: gentle
                ? const Duration(milliseconds: 150)
                : const Duration(milliseconds: 300),
            curve: gentle ? Curves.easeInOut : Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  /// 实时平滑滚动到底部（用于AI流式响应）
  void _scrollToBottomSmoothly() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // 使用很短的动画时间，实现平滑的实时滚动
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  /// 检查是否需要自动滚动
  bool _shouldAutoScroll() {
    if (!_scrollController.hasClients) return true;

    // 如果用户已经滚动到接近底部（距离底部不超过100像素），则自动滚动
    final position = _scrollController.position;
    return position.maxScrollExtent - position.pixels < 100;
  }

  @override
  Widget build(BuildContext context) {
    // 监听消息变化并自动滚动
    ref.listen<List<ChatMessage>>(chatMessagesProvider, (previous, current) {
      if (previous == null) return;

      // 如果消息数量增加了，则立即自动滚动（新消息）
      if (current.length > previous.length) {
        _scrollToBottom();
      }
      // 如果最后一条消息的内容发生了变化（AI流式响应）
      else if (current.isNotEmpty && previous.isNotEmpty) {
        final currentLast = current.last;
        final previousLast = previous.last;
        if (currentLast.id == previousLast.id &&
            currentLast.content != previousLast.content &&
            _shouldAutoScroll()) {
          // 实时平滑滚动：每次内容更新都进行平滑滚动
          _scrollToBottomSmoothly();
        }
      }
    });

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
            data: (currentModel) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModelSelectorDialog(
                        allModels: allModels,
                        currentModel: currentModel,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (currentModel != null) ...[
                          Text(
                            currentModel.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else ...[
                          Text(
                            '选择模型',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            loading: () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '加载中...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            error: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '加载失败',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '加载中...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  '加载失败',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
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

        // 当消息列表首次加载或切换会话时，滚动到底部
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && messages.isNotEmpty) {
            _scrollToBottom(animate: false);
          }
        });

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
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 40, // 预留按钮空间
                    top: 20, // 顶部留白避免重叠
                    bottom: 10,
                  ),
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
                      MessageContentWidget(message: message),
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
                Positioned(
                  right: 8,
                  top: 4,
                  child: MessageOptionsButton(message: message),
                ),
              ],
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

            // 新的双层输入容器
            Container(
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: _isInputFocused
                    ? Border.all(color: const Color(0xFF2684FF), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 上层：输入区域 (56px)
                  Container(
                    height: 56,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Row(
                      children: [
                        // 左侧留白区 (16px)
                        const SizedBox(width: 16),
                        // 中间文本输入区域
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final speechText = ref.watch(
                                  chatProvider.select((s) => s.speechText),
                                );
                                final isListening = ref.watch(
                                  chatProvider.select((s) => s.isListening),
                                );

                                // 当有语音文本时，更新输入框
                                if (speechText.isNotEmpty &&
                                    _messageController.text != speechText) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _messageController.text = speechText;
                                    _messageController
                                        .selection = TextSelection.fromPosition(
                                      TextPosition(offset: speechText.length),
                                    );
                                  });
                                }

                                return TextField(
                                  controller: _messageController,
                                  focusNode: _inputFocusNode,
                                  decoration: InputDecoration(
                                    hintText: isListening
                                        ? '正在听您说话...'
                                        : '输入消息...',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: isListening
                                          ? const Color(0xFFFF6B6B)
                                          : const Color(0xFF999999),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isListening
                                        ? const Color(0xFFFF6B6B)
                                        : const Color(0xFF333333),
                                    height: 1.5,
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => _sendMessage(ref),
                                  enabled: !isListening, // 录音时禁用手动输入
                                );
                              },
                            ),
                          ),
                        ),
                        // 右侧留白区 (16px)
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  // 间隙 (4px)
                  const SizedBox(height: 4),

                  // 下层：工具区域 (40px)
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // 左侧工具图标
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () =>
                                _showAttachmentOptionsMenu(context, ref),
                            child: Tooltip(
                              message: '添加附件',
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFF999999),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _showSettings(),
                            child: Tooltip(
                              message: '设置',
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.tune,
                                  color: Color(0xFF999999),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // 右侧语音和发送按钮组合
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 语音按钮
                            Consumer(
                              builder: (context, ref, child) {
                                final isListening = ref.watch(
                                  chatProvider.select((s) => s.isListening),
                                );
                                final speechText = ref.watch(
                                  chatProvider.select((s) => s.speechText),
                                );

                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _handleVoiceButton(ref),
                                    child: Tooltip(
                                      message: isListening
                                          ? '停止录音'
                                          : (speechText.isNotEmpty
                                                ? '确认发送语音'
                                                : '语音输入'),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isListening
                                              ? const Color(0xFFFF6B6B)
                                              : (speechText.isNotEmpty
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFFF5F5F5)),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: isListening
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFFFF6B6B,
                                                    ).withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Icon(
                                          isListening
                                              ? Icons.stop_rounded
                                              : (speechText.isNotEmpty
                                                    ? Icons.check_rounded
                                                    : Icons.mic_outlined),
                                          color:
                                              isListening ||
                                                  speechText.isNotEmpty
                                              ? Colors.white
                                              : const Color(0xFF666666),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            // 发送按钮 - 改进样式
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _sendMessage(ref),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF2684FF),
                                        Color(0xFF0052CC),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF2684FF,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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

  /// 处理语音按钮点击
  void _handleVoiceButton(WidgetRef ref) {
    final chatNotifier = ref.read(chatProvider.notifier);
    final isListening = ref.read(chatProvider.select((s) => s.isListening));
    final speechText = ref.read(chatProvider.select((s) => s.speechText));

    if (isListening) {
      // 如果正在录音，则停止录音
      chatNotifier.stopSpeechRecognition();
    } else if (speechText.isNotEmpty) {
      // 如果有语音文本，则确认并发送
      chatNotifier.confirmSpeechText();
    } else {
      // 开始录音
      chatNotifier.startSpeechRecognition();
    }
  }

  /// 发送消息
  void _sendMessage(WidgetRef ref) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _messageController.clear();

    // 发送消息后立即滚动到底部
    _scrollToBottom();
  }

  /// 显示设置
  void _showSettings() {
    context.go('/settings');
  }

  /// 显示附件选择菜单
  void _showAttachmentOptionsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部指示条
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 选项列表
              _buildAttachmentOption(
                context,
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF2684FF),
                title: '从相册选择图片',
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(ref);
                },
              ),

              _buildAttachmentOption(
                context,
                icon: Icons.camera_alt_outlined,
                iconColor: const Color(0xFFE91E63),
                title: '拍摄照片',
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera(ref);
                },
              ),

              _buildAttachmentOption(
                context,
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF4CAF50),
                title: '上传文件',
                onTap: () {
                  Navigator.pop(context);
                  _pickFiles(ref);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建附件选择选项
  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 从相册选择图片
  Future<void> _pickImageFromGallery(WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        ref.read(chatProvider.notifier).attachFiles(result.files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('选择图片失败: $e')));
      }
    }
  }

  /// 拍摄照片
  Future<void> _pickImageFromCamera(WidgetRef ref) async {
    try {
      // 这里先用FilePicker模拟，后续可以集成image_picker包
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        ref.read(chatProvider.notifier).attachFiles(result.files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('拍摄照片失败: $e')));
      }
    }
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
