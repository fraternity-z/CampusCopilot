import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/utils/keyboard_utils.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/animated_title_widget.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/widgets/elegant_notification.dart';

import '../../domain/entities/chat_message.dart';
import '../providers/chat_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

import 'widgets/message_content_widget.dart';
import 'widgets/streaming_message_content_widget.dart';
import 'widgets/model_selector_dialog.dart';
import 'widgets/message_options_button.dart';
import 'widgets/chat_action_menu.dart';
import '../../../knowledge_base/presentation/providers/multi_knowledge_base_provider.dart';
import '../providers/search_providers.dart';

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

class _ChatScreenState extends ConsumerState<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _isInputFocused = false;
  bool _ragEnabled = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      setState(() {
        _isInputFocused = _inputFocusNode.hasFocus;
      });
    });

    // 初始化RAG状态，从设置中读取
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      setState(() {
        _ragEnabled = settings.chatSettings.enableRag;
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
            // 自适应动画时长：长列表使用较短动画
            duration: Duration(milliseconds: gentle ? 120 : 220),
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
        // 使用更短动画，降低频繁rebuild卡顿
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
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
    super.build(context);
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

    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(appBar: _buildAppBar(), body: _buildMainChatArea()),
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// 构建应用栏
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer(
        builder: (context, ref, child) {
          final session = ref.watch(currentChatSessionProvider);
          return AnimatedTitleWidget(
            title: session?.title ?? 'AI 助手',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          );
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
        final allModelsAsync = ref.watch(databaseChatModelsProvider);
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
          key: const PageStorageKey('chat_message_list'),
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          cacheExtent: 800,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    left: 18,
                    right: 46, // 预留按钮空间
                    top: 18,
                    bottom: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary.withAlpha(235),
                              colorScheme.primary,
                            ],
                          )
                        : null,
                    color: isUser ? null : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomLeft: isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(6),
                      bottomRight: isUser
                          ? const Radius.circular(6)
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (message.isFromUser ||
                              message.status != MessageStatus.sending)
                          ? MessageContentWidget(message: message)
                          : OptimizedStreamingMessageWidget(
                              message: message,
                              isStreaming: true,
                            ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(message.timestamp),
                        style: textTheme.bodySmall?.copyWith(
                          color:
                              (isUser
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface)
                                  .withAlpha(140),
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
    final attachedImages = ref.watch(
      chatProvider.select((s) => s.attachedImages),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 显示已附加的图片
            if (attachedImages.isNotEmpty)
              _buildAttachedImages(context, ref, attachedImages),

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
                            child: TextField(
                              controller: _messageController,
                              focusNode: _inputFocusNode,
                              decoration: const InputDecoration(
                                hintText: '输入消息...',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF999999),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                height: 1.5,
                              ),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(ref),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Color(0xFF999999),
                                    size: 20, // 统一图标大小
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // RAG + AI搜索并列控制
                        _buildRagAndSearchControls(),
                        const SizedBox(width: 12),
                        const ChatActionMenu(),
                        const Spacer(),
                        // 右侧语音和发送按钮组合
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 发送/停止按钮 - 改进样式和状态管理
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _messageController,
                              builder: (context, textValue, child) {
                                return Consumer(
                                  builder: (context, ref, child) {
                                    final isLoading = ref.watch(
                                      chatLoadingProvider,
                                    );
                                    final attachedFiles = ref.watch(
                                      chatProvider.select(
                                        (s) => s.attachedFiles,
                                      ),
                                    );

                                    // 计算按钮是否可用
                                    final hasText = textValue.text
                                        .trim()
                                        .isNotEmpty;
                                    final canSend =
                                        !isLoading &&
                                        (hasText || attachedFiles.isNotEmpty);
                                    final isStopButton = isLoading;

                                    return MouseRegion(
                                      cursor: canSend || isStopButton
                                          ? SystemMouseCursors.click
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onTap: canSend || isStopButton
                                            ? () => isStopButton
                                                  ? _stopResponse(ref)
                                                  : _sendMessage(ref)
                                            : null,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            gradient: canSend || isStopButton
                                                ? LinearGradient(
                                                    colors: isStopButton
                                                        ? [
                                                            const Color(
                                                              0xFFFF6B6B,
                                                            ),
                                                            const Color(
                                                              0xFFE53E3E,
                                                            ),
                                                          ]
                                                        : [
                                                            const Color(
                                                              0xFF2684FF,
                                                            ),
                                                            const Color(
                                                              0xFF0052CC,
                                                            ),
                                                          ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  )
                                                : null,
                                            color: canSend || isStopButton
                                                ? null
                                                : const Color(0xFFE2E8F0),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            boxShadow: canSend || isStopButton
                                                ? [
                                                    BoxShadow(
                                                      color:
                                                          (isStopButton
                                                                  ? const Color(
                                                                      0xFFFF6B6B,
                                                                    )
                                                                  : const Color(
                                                                      0xFF2684FF,
                                                                    ))
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Icon(
                                            isStopButton
                                                ? Icons.stop_rounded
                                                : Icons.send_rounded,
                                            color: canSend || isStopButton
                                                ? Colors.white
                                                : const Color(0xFF94A3B8),
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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

  /// 构建已附加图片列表
  Widget _buildAttachedImages(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> images, // 使用 dynamic 以支持 ImageResult
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      height: 100, // 稍微高一点以显示图片缩略图
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            width: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // 图片缩略图
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120, // 增大预览图宽度
                    height: 120, // 增大预览图高度
                    child: Image.memory(
                      image.thumbnailBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Icon(
                            Icons.broken_image,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 删除按钮
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(chatProvider.notifier).removeImage(image);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                // 文件大小标签
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      image.sizeDescription,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
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
      // 分离图片文件和文档文件
      final imageFiles = <PlatformFile>[];
      final documentFiles = <PlatformFile>[];

      for (final file in result.files) {
        final extension = file.extension?.toLowerCase();
        if (_isImageFile(extension)) {
          imageFiles.add(file);
        } else {
          documentFiles.add(file);
        }
      }

      // 处理图片文件 - 转换为ImageResult
      if (imageFiles.isNotEmpty) {
        try {
          await _processImageFiles(ref, imageFiles);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('处理图片文件失败: $e')));
          }
        }
      }

      // 处理文档文件
      if (documentFiles.isNotEmpty) {
        ref.read(chatProvider.notifier).attachFiles(documentFiles);
      }
    }
  }

  /// 判断是否为图片文件
  bool _isImageFile(String? extension) {
    if (extension == null) return false;
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  /// 处理图片文件
  Future<void> _processImageFiles(
    WidgetRef ref,
    List<PlatformFile> imageFiles,
  ) async {
    final imageService = ImageService();
    final chatNotifier = ref.read(chatProvider.notifier);

    for (final file in imageFiles) {
      if (file.path != null) {
        try {
          // 使用ImageService处理图片文件
          final xFile = XFile(file.path!);
          final imageResult = await imageService.processImageFromXFile(xFile);

          // 添加到聊天状态
          chatNotifier.addProcessedImage(imageResult);
        } catch (e) {
          debugPrint('处理图片文件失败: ${file.name}, 错误: $e');
          // 继续处理其他图片
        }
      }
    }
  }

  /// 发送消息
  void _sendMessage(WidgetRef ref) {
    final text = _messageController.text.trim();
    final attachedFiles = ref.read(chatProvider).attachedFiles;

    // 检查是否有内容可发送
    if (text.isEmpty && attachedFiles.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _messageController.clear();

    // 发送消息后立即滚动到底部
    _scrollToBottom();
  }

  /// 停止AI响应
  void _stopResponse(WidgetRef ref) {
    ref.read(chatProvider.notifier).stopResponse();
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
      await ref.read(chatProvider.notifier).pickImagesFromGallery();
    } catch (e) {
      if (mounted) {
        ElegantNotification.error(
          context,
          '选择图片失败: $e',
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  /// 拍摄照片
  Future<void> _pickImageFromCamera(WidgetRef ref) async {
    try {
      await ref.read(chatProvider.notifier).capturePhoto();
    } catch (e) {
      if (mounted) {
        ElegantNotification.error(
          context,
          '拍摄照片失败: $e',
          duration: const Duration(seconds: 3),
        );
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

  /// 构建并列的 RAG 与 AI 搜索控制（紧凑样式）
  Widget _buildRagAndSearchControls() {
    return Consumer(
      builder: (context, ref, child) {
        // 监听设置变化，同步RAG状态
        final settings = ref.watch(settingsProvider);
        final settingsRagEnabled = settings.chatSettings.enableRag;
        if (_ragEnabled != settingsRagEnabled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _ragEnabled = settingsRagEnabled;
            });
          });
        }

        // 监听搜索开关
        final searchConfig = ref.watch(searchConfigProvider);
        final bool searchEnabled = searchConfig.searchEnabled;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // RAG控制图标
            GestureDetector(
              onTap: () => _showRagControlMenu(context, ref),
              child: Tooltip(
                message: 'RAG知识库控制',
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _ragEnabled
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_awesome,
                      size: 20, // 统一图标大小
                      color: _ragEnabled
                          ? Theme.of(context).colorScheme.primary
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // AI 搜索开关按钮（颜色区分）
            GestureDetector(
              onTap: () async {
                final notifier = ref.read(searchConfigProvider.notifier);
                final newEnabled = !searchEnabled;
                await notifier.updateSearchEnabled(newEnabled);
                if (!context.mounted) return; // 防止在组件卸载后使用当前BuildContext
                ElegantNotification.info(
                  context,
                  newEnabled ? '已启用AI搜索' : '已关闭AI搜索',
                  duration: const Duration(seconds: 2),
                );
              },
              child: Tooltip(
                message: 'AI搜索（联网）',
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: searchEnabled
                        ? Colors.teal.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.travel_explore,
                      size: 20,
                      color: searchEnabled
                          ? Colors.teal
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 显示RAG控制菜单
  void _showRagControlMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          // 使用watch来监听知识库状态变化
          final multiKbState = ref.watch(multiKnowledgeBaseProvider);

          return Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'RAG知识库控制',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // RAG总开关
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _ragEnabled ? Icons.toggle_on : Icons.toggle_off,
                          color: _ragEnabled
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RAG增强功能',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _ragEnabled ? '已启用知识库检索' : '已禁用知识库检索',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _ragEnabled,
                          onChanged: (value) async {
                            setState(() {
                              _ragEnabled = value;
                            });
                            await ref
                                .read(settingsProvider.notifier)
                                .updateRagEnabled(value);

                            // 当RAG开关状态变化时，重新加载知识库列表
                            if (value) {
                              ref
                                  .read(multiKnowledgeBaseProvider.notifier)
                                  .reload();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // 显示加载状态
                  if (_ragEnabled && multiKbState.isLoading) ...[
                    const SizedBox(height: 20),
                    const Center(child: CircularProgressIndicator()),
                  ],

                  // 显示错误信息
                  if (_ragEnabled && multiKbState.error != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '加载知识库失败: ${multiKbState.error}',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 知识库列表
                  if (_ragEnabled &&
                      !multiKbState.isLoading &&
                      multiKbState.error == null) ...[
                    if (multiKbState.knowledgeBases.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        '选择知识库',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),

                      // 知识库列表
                      ...multiKbState.knowledgeBases.map((kb) {
                        final isSelected =
                            multiKbState.currentKnowledgeBase?.id == kb.id;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(
                              kb.getIcon(),
                              color: kb.getColor(),
                              size: 24,
                            ),
                            title: Text(
                              kb.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(kb.getStatusDescription()),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                            onTap: () {
                              ref
                                  .read(multiKnowledgeBaseProvider.notifier)
                                  .selectKnowledgeBase(kb.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }),
                    ] else ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '暂无知识库',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '请先创建知识库并上传文档',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
