import 'dart:async';
import 'package:flutter/material.dart';
import 'settings_tab_web.dart';

/// Web 预览版：聊天页面
/// - 本地内存消息列表；
/// - 伪流式回复；
/// - 不依赖任何网络/数据库/provider。
class ChatScreenWeb extends StatefulWidget {
  final VoidCallback? onToggleSidebar;
  final VoidCallback? onOpenDaily;
  final VoidCallback? onOpenSettings;
  const ChatScreenWeb({super.key, this.onToggleSidebar, this.onOpenDaily, this.onOpenSettings});

  @override
  State<ChatScreenWeb> createState() => _ChatScreenWebState();
}

class _ChatScreenWebState extends State<ChatScreenWeb> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [
    const _Msg(role: _Role.assistant, text: '你好，我是你的学习助手。有什么要一起解决的吗？'),
  ];
  // 预览简化：不保留 RAG 状态开关，避免未使用警告

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onToggleSidebar,
          tooltip: '侧边栏',
        ),
        title: _modelSelector(context),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: '日常',
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: widget.onOpenDaily ?? () {},
          ),
          IconButton(
            tooltip: '设置',
            icon: const Icon(Icons.settings_outlined),
            onPressed: widget.onOpenSettings ?? () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsTabWeb()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 2,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _emptyOrList(context)),
              _composerBar(context),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _modelSelector(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showModelSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('选择模型', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ]),
      ),
    );
  }

  Widget _emptyOrList(BuildContext context) {
    if (_msgs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('开始新的对话', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('向您的 AI 助手发送消息以开始', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _msgs.length,
      itemBuilder: (_, i) {
        final m = _msgs[i];
        final isUser = m.role == _Role.user;
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85, minWidth: 120),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isUser
                    ? [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.85)]
                    : [Theme.of(context).colorScheme.surfaceContainer, Theme.of(context).colorScheme.surfaceContainerHigh],
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 20),
              ),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1), width: 1),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: isUser ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
              ),
              child: Text(m.text),
            ),
          ),
        );
      },
    );
  }

  Widget _composerBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6)),
            ],
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.20)),
          ),
          child: SizedBox(
            height: 120,
            child: Stack(
              children: [
                // 输入区域（靠上）
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 56, 56),
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: '输入消息...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                // 左下角：工具 + 模式分段
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Row(children: [
                    IconButton(icon: const Icon(Icons.add), tooltip: '添加', onPressed: () {}),
                    IconButton(icon: const Icon(Icons.auto_awesome), tooltip: '提示优化', onPressed: () {}),
                    IconButton(icon: const Icon(Icons.visibility_off_outlined), tooltip: '隐藏敏感', onPressed: () {}),
                    IconButton(icon: const Icon(Icons.more_vert), tooltip: '更多', onPressed: () {}),
                    const SizedBox(width: 8),
                    _segmentedMode(context),
                  ]),
                ),
                // 右下角：发送
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blueGrey.shade100,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.play_arrow_rounded),
                      color: Colors.blueGrey.shade700,
                      onPressed: _send,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _segmentedMode(BuildContext context) {
    // 外层白色胶囊
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        // 选中“聊天”
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Icon(Icons.chat_bubble_outline, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
            Text('聊天', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(width: 4),
        // 未选中“学习”
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(children: const [
            Icon(Icons.school_outlined, size: 16),
            SizedBox(width: 6),
            Text('学习'),
          ]),
        ),
      ]),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(role: _Role.user, text: text));
      _controller.clear();
    });
    _scrollToBottom();
    _simulateStreamReply();
  }

  void _simulateStreamReply() {
    const full = '这是一个模拟的流式回复。该页面仅用于 Web 预览，不连接任何模型。';
    int i = 0;
    if (_msgs.isEmpty) {
      _msgs.add(const _Msg(role: _Role.assistant, text: ''));
    } else {
      _msgs.add(const _Msg(role: _Role.assistant, text: ''));
    }
    final idx = _msgs.length - 1;
    Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i >= full.length) { t.cancel(); return; }
      setState(() { _msgs[idx] = _Msg(role: _Role.assistant, text: full.substring(0, i++)); });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    });
  }

  void _showModelSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return ListView(
          children: const [
            ListTile(leading: Icon(Icons.memory), title: Text('gpt-4o-mini（示例）')),
            ListTile(leading: Icon(Icons.memory), title: Text('deepseek-r1（示例）')),
            ListTile(leading: Icon(Icons.memory), title: Text('claude-3.5-sonnet（示例）')),
          ],
        );
      },
    );
  }
}

enum _Role { user, assistant }
class _Msg { final _Role role; final String text; const _Msg({required this.role, required this.text}); }
