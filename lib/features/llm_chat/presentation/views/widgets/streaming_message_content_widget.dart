import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/chat_message.dart';
import 'message_content_widget.dart';
import 'thinking_chain_widget.dart';

/// 流式增量渲染的消息组件
class OptimizedStreamingMessageWidget extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool isStreaming;

  const OptimizedStreamingMessageWidget({
    super.key,
    required this.message,
    required this.isStreaming,
  });

  @override
  ConsumerState<OptimizedStreamingMessageWidget> createState() =>
      _OptimizedStreamingMessageWidgetState();
}

class _OptimizedStreamingMessageWidgetState
    extends ConsumerState<OptimizedStreamingMessageWidget> {
  final _renderer = _IncrementalRenderer();
  final List<_Chunk> _streamChunks = <_Chunk>[];
  bool _finalized = false;
  String _last = '';

  String? _thinking;
  String? _content;

  @override
  void initState() {
    super.initState();
    _splitThinking();
    // 避免在 initState 中依赖 InheritedWidget（Theme.of 等），延后到首帧后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.isStreaming) {
        _appendNew();
      } else {
        _finalize();
      }
      _last = widget.message.content;
    });
  }

  @override
  void didUpdateWidget(covariant OptimizedStreamingMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.content != _last) {
      _splitThinking();
      if (widget.isStreaming) {
        _appendNew();
      } else if (!_finalized) {
        _finalize();
      }
      _last = widget.message.content;
    }
    if (!widget.isStreaming && oldWidget.isStreaming && !_finalized) {
      _finalize();
    }
  }

  void _splitThinking() {
    final raw = widget.message.content;
    if (raw.contains('<think>') && raw.contains('</think>')) {
      final s = raw.indexOf('<think>');
      final e = raw.indexOf('</think>');
      if (s != -1 && e != -1 && e > s) {
        _thinking = raw.substring(s + 7, e).trim();
        final before = raw.substring(0, s).trim();
        final after = raw.substring(e + 8).trim();
        _content = ('$before $after').trim();
        return;
      }
    }
    _content = raw;
  }

  void _appendNew() {
    if (_finalized) return;
    final full = _content ?? widget.message.content;
    final chunks = _renderer.process(full);
    if (chunks.isEmpty) return;
    setState(() {
      for (final c in chunks) {
        if (_streamChunks.isNotEmpty &&
            _streamChunks.last.kind == _Kind.text &&
            c.kind == _Kind.text) {
          _streamChunks.last.text += c.text;
        } else {
          _streamChunks.add(_Chunk(c.kind, c.text));
        }
      }
    });
  }

  void _finalize() {
    setState(() {
      _finalized = true;
      _renderer.reset();
      _streamChunks.clear();
    });
  }

  TextStyle? _textStyle() {
    final theme = Theme.of(context);
    return GoogleFonts.inter(
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: widget.message.isFromUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        height: 1.7,
        letterSpacing: 0.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 非流式或已完成：直接使用完整渲染
    if (_finalized || !widget.isStreaming) {
      return MessageContentWidget(message: widget.message);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_thinking != null && !widget.message.isFromUser)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ThinkingChainWidget(
              content: _thinking!,
              modelName: widget.message.modelName ?? '',
              isCompleted: false,
            ),
          ),
        if (widget.message.attachments.isNotEmpty ||
            widget.message.imageUrls.isNotEmpty)
          _buildAttachments(),
        if (_streamChunks.isNotEmpty || widget.isStreaming) _buildStreaming(),
      ],
    );
  }

  Widget _buildAttachments() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.message.attachments.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.message.attachments
                  .map((a) => _attachmentChip(a))
                  .toList(),
            ),
          if (widget.message.imageUrls.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.message.imageUrls.length,
                itemBuilder: (context, i) => _imageThumb(i),
              ),
            ),
        ],
      ),
    );
  }

  Widget _attachmentChip(FileAttachment a) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _fileIcon(a.fileType),
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            a.fileName,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _fileIcon(String t) {
    switch (t.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.attach_file;
    }
  }

  Widget _imageThumb(int i) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            Center(
              child: Icon(
                Icons.image,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreaming() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._streamChunks.map((c) {
          switch (c.kind) {
            case _Kind.text:
              return SelectableText(c.text, style: _textStyle());
            case _Kind.code:
              return _ChunkBuilder._code(context, c.text);
            case _Kind.mermaid:
              return _ChunkBuilder._mermaid(context, c.text);
            case _Kind.math:
              return _ChunkBuilder._math(context, c.text);
          }
        }),
        if (widget.isStreaming)
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '生成中...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ========== 增量渲染支持 ==========

enum _Kind { text, code, mermaid, math }

class _Chunk {
  final _Kind kind;
  String text;
  _Chunk(this.kind, this.text);
}

class _IncrementalRenderer {
  int _last = 0;

  List<_Chunk> process(String full) {
    if (_last > full.length) _last = 0;
    final start = _last;
    if (start >= full.length) return const [];
    final delta = full.substring(start);
    _last = full.length;

    final List<_Chunk> out = [];

    // 快速路径：无特殊标记
    final hasFence = delta.contains('```');
    final hasMermaid = delta.contains('```mermaid');
    final hasMath = delta.contains(r'$$');
    if (!hasFence && !hasMermaid && !hasMath) {
      if (delta.trim().isNotEmpty) {
        out.add(_Chunk(_Kind.text, delta));
      }
      return out;
    }

    final buf = StringBuffer();
    int i = 0;
    while (i < delta.length) {
      // 代码围栏：在吐出围栏块前先吐出累积的文本
      if (delta.startsWith('```', i)) {
        final end = delta.indexOf('```', i + 3);
        if (end != -1) {
          final pending = buf.toString();
          if (pending.trim().isNotEmpty) out.add(_Chunk(_Kind.text, pending));
          buf.clear();
          final block = delta.substring(i, end + 3);
          final isMermaid = block.startsWith('```mermaid');
          out.add(_Chunk(isMermaid ? _Kind.mermaid : _Kind.code, block));
          i = end + 3;
          continue;
        }
      }

      // 数学块 $$...$$：在吐出数学块前先吐出累积的文本
      if (delta.startsWith(r'$$', i)) {
        final end = delta.indexOf(r'$$', i + 2);
        if (end != -1) {
          final pending = buf.toString();
          if (pending.trim().isNotEmpty) out.add(_Chunk(_Kind.text, pending));
          buf.clear();
          out.add(_Chunk(_Kind.math, delta.substring(i, end + 2)));
          i = end + 2;
          continue;
        }
      }

      // 改为按单换行合并，避免每个句子强制换段
      final brk = delta.indexOf('\n', i);
      if (brk != -1) {
        buf.write(delta.substring(i, brk + 1));
        // 不立即吐出，继续合并，只有遇到特殊块或结束才吐出
        i = brk + 1;
      } else {
        buf.write(delta.substring(i));
        i = delta.length;
      }
    }

    final rest = buf.toString();
    if (rest.isNotEmpty) out.add(_Chunk(_Kind.text, rest));
    return out;
  }

  void reset() {
    _last = 0;
  }
}

class _ChunkBuilder {
  static Widget _code(BuildContext context, String fenced) {
    final content = _stripFences(fenced);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: SelectableText(
        content,
        style: const TextStyle(
          fontFamily: 'JetBrains Mono, Source Code Pro, monospace',
          fontSize: 13,
        ),
      ),
    );
  }

  static Widget _mermaid(BuildContext context, String fenced) {
    final content = _stripFences(fenced);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mermaid图表渲染中…',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _math(BuildContext context, String fenced) {
    final content = fenced.replaceAll('\$\$', '').trim();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.functions,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SelectableText(
              '44$content44',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static String _stripFences(String fenced) {
    String s = fenced.trim();
    if (s.startsWith('```')) {
      s = s.substring(3);
      final nl = s.indexOf('\n');
      if (nl != -1) s = s.substring(nl + 1);
    }
    if (s.endsWith('```')) s = s.substring(0, s.length - 3);
    return s.trim();
  }
}
