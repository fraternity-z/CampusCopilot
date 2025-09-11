import 'dart:async';
import 'package:flutter/material.dart';
import 'settings_tab_web.dart';

/// Web 预览版：聊天页面
/// - 本地内存消息列表；
/// - 伪流式回复；
/// - 不依赖任何网络/数据库/provider。
class ChatScreenWeb extends StatefulWidget {
  final VoidCallback? onOpenDaily;
  final VoidCallback? onOpenSettings;
  const ChatScreenWeb({super.key, this.onOpenDaily, this.onOpenSettings});

  @override
  State<ChatScreenWeb> createState() => _ChatScreenWebState();
}

class _ChatScreenWebState extends State<ChatScreenWeb> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [
    const _Msg(role: _Role.assistant, text: '你好，我是你的学习助手。有什么要一起解决的吗？'),
  ];
  bool _ragEnabled = false; // 仅展示

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
      ),
      body: Column(
        children: [
          _personaBar(context),
          const Divider(height: 1),
          Expanded(child: _messageList(context)),
          const Divider(height: 1),
          _inputBar(context),
        ],
      ),
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

  Widget _personaBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(children: [
        CircleAvatar(radius: 14, backgroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.smart_toy, size: 16, color: Colors.white)),
        const SizedBox(width: 8),
        Expanded(child: Text('通用助手 · RAG ${_ragEnabled?"已启用":"未启用"}', maxLines: 1, overflow: TextOverflow.ellipsis)),
        TextButton.icon(onPressed: () => setState(()=> _ragEnabled = !_ragEnabled), icon: const Icon(Icons.extension), label: Text(_ragEnabled? '关闭RAG':'开启RAG')),
      ]),
    );
  }

  Widget _messageList(BuildContext context) {
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

  Widget _inputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: '给 AI 发一条消息...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(onPressed: _send, icon: const Icon(Icons.send), label: const Text('发送')),
        ]),
      ),
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
    _msgs.add(const _Msg(role: _Role.assistant, text: ''));
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
