import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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
  final List<_Chunk> _streamChunks = <_Chunk>[];
  bool _finalized = false;
  String _lastContent = '';

  // 分离的思考链和正文内容（用于流式处理）
  String _streamingThinking = '';
  String _streamingContent = '';
  bool _isInThinkingMode = false;
  String _partialTag = '';

  // 新增：严格顺序控制状态
  bool _thinkingCompleted = false;
  bool _contentStarted = false;
  bool _hasThinkingContent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.isStreaming) {
        _processStreamingContent();
      } else {
        _finalize();
      }
      _lastContent = widget.message.content;
    });
  }

  @override
  void didUpdateWidget(covariant OptimizedStreamingMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.content != _lastContent) {
      if (widget.isStreaming) {
        _processStreamingContent();
      } else if (!_finalized) {
        _finalize();
      }
      _lastContent = widget.message.content;
    }
    if (!widget.isStreaming && oldWidget.isStreaming && !_finalized) {
      _finalize();
    }
  }

  /// 处理流式内容，实时分离思考链和正文
  void _processStreamingContent() {
    if (_finalized) return;

    final fullContent = widget.message.content;
    final newContent = fullContent.substring(_lastContent.length);

    if (newContent.isEmpty) return;

    // 处理新增的内容片段
    String processedContent = _partialTag + newContent;
    _partialTag = '';

    // 实时检测和处理思考链标签
    _processThinkingTags(processedContent);

    // 更新渲染块（只处理正文内容）- 严格控制更新时机
    if (_streamingContent.isNotEmpty && _shouldUpdateContentChunks()) {
      final renderer = _IncrementalRenderer();
      renderer.reset();
      final chunks = renderer.process(_streamingContent);

      setState(() {
        _streamChunks.clear();
        _streamChunks.addAll(chunks);
      });
    }
  }

  /// 处理思考链标签，实时分离思考链和正文
  void _processThinkingTags(String text) {
    int i = 0;
    while (i < text.length) {
      if (_isInThinkingMode) {
        // 在思考模式中，寻找结束标签
        final endIndex = text.indexOf('</think>', i);
        if (endIndex != -1) {
          // 找到结束标签，添加剩余的思考内容
          _streamingThinking += text.substring(i, endIndex);
          _isInThinkingMode = false;
          _thinkingCompleted = true; // 标记思考链完成
          _hasThinkingContent = _streamingThinking.isNotEmpty;
          i = endIndex + 8; // 跳过 </think> 标签
        } else {
          // 没有找到结束标签，将剩余内容都作为思考内容
          _streamingThinking += text.substring(i);
          _hasThinkingContent = _streamingThinking.isNotEmpty;
          break;
        }
      } else {
        // 不在思考模式中，寻找开始标签
        final startIndex = text.indexOf('<think>', i);
        if (startIndex != -1) {
          // 找到开始标签，处理之前的正文内容
          if (startIndex > i) {
            final contentBeforeThink = text.substring(i, startIndex);
            // 只有在没有思考链或思考链已完成时才处理正文
            if (!_hasThinkingContent || _thinkingCompleted) {
              _streamingContent += contentBeforeThink;
              if (!_contentStarted && contentBeforeThink.trim().isNotEmpty) {
                _contentStarted = true;
              }
            }
          }
          _isInThinkingMode = true;
          _hasThinkingContent = true;
          i = startIndex + 7; // 跳过 <think> 标签
        } else {
          // 没有找到开始标签，剩余内容都是正文
          final remainingContent = text.substring(i);
          // 只有在没有思考链或思考链已完成时才处理正文
          if (!_hasThinkingContent || _thinkingCompleted) {
            _streamingContent += remainingContent;
            if (!_contentStarted && remainingContent.trim().isNotEmpty) {
              _contentStarted = true;
            }
          }
          break;
        }
      }
    }

    // 处理可能的部分标签（跨块）
    if (_isInThinkingMode && text.endsWith('<')) {
      _partialTag = '<';
      _streamingContent = _streamingContent.substring(
        0,
        _streamingContent.length - 1,
      );
    } else if (text.endsWith('</') ||
        text.endsWith('</t') ||
        text.endsWith('</th') ||
        text.endsWith('</thi') ||
        text.endsWith('</thin') ||
        text.endsWith('</think')) {
      final lastTagStart = text.lastIndexOf('<');
      if (lastTagStart != -1) {
        _partialTag = text.substring(lastTagStart);
        if (_isInThinkingMode) {
          _streamingThinking = _streamingThinking.substring(
            0,
            _streamingThinking.length - _partialTag.length,
          );
        } else {
          _streamingContent = _streamingContent.substring(
            0,
            _streamingContent.length - _partialTag.length,
          );
        }
      }
    }
  }

  void _finalize() {
    setState(() {
      _finalized = true;
      // 移除清空操作，避免重渲染动画
      // 保持流式状态的连续性，让 MessageContentWidget 接管渲染
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
        // 实时显示思考链（流式）
        if (_streamingThinking.isNotEmpty && !widget.message.isFromUser)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ThinkingChainWidget(
              content: _streamingThinking,
              modelName: widget.message.modelName ?? '',
              isCompleted: _thinkingCompleted,
            ),
          ),

        // 附件显示
        if (widget.message.attachments.isNotEmpty ||
            widget.message.imageUrls.isNotEmpty)
          _buildAttachments(),

        // 正文内容显示 - 严格控制显示时机
        if (_shouldShowContent()) _buildStreaming(),
      ],
    );
  }

  /// 判断是否应该显示正文内容
  bool _shouldShowContent() {
    // 如果没有思考链内容，直接显示正文
    if (!_hasThinkingContent) {
      return _streamChunks.isNotEmpty || widget.isStreaming;
    }

    // 如果有思考链内容，必须等思考链完成且正文开始后才显示
    return _thinkingCompleted &&
        _contentStarted &&
        (_streamChunks.isNotEmpty || widget.isStreaming);
  }

  /// 判断是否应该更新正文内容的渲染块
  bool _shouldUpdateContentChunks() {
    // 如果没有思考链内容，直接更新
    if (!_hasThinkingContent) {
      return true;
    }

    // 如果有思考链内容，必须等思考链完成后才更新正文渲染块
    return _thinkingCompleted;
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
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  highlightColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  child: Text(
                    '生成中...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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
              '\$\$$content\$\$',
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
