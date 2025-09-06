import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/highlight.dart' as highlight;
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:campus_copilot/shared/markdown/markdown_renderer.dart';
import 'package:campus_copilot/shared/charts/chart_from_json.dart';
import '../../../../../app/app_router.dart' show codeBlockSettingsProvider, generalSettingsProvider, CodeBlockSettings;
import 'thinking_chain_widget.dart';
import '../../../domain/entities/chat_message.dart';
import 'file_attachment_card.dart';
import 'image_preview_widget.dart';

/// 消息内容渲染组件
///
/// 支持功能：
/// - Markdown语法渲染
/// - 代码块显示
/// - 代码折叠/展开
/// - 行号显示
/// - 复制功能
/// - 多种主题
class MessageContentWidget extends ConsumerStatefulWidget {
  final ChatMessage message;

  const MessageContentWidget({super.key, required this.message});

  @override
  ConsumerState<MessageContentWidget> createState() =>
      _MessageContentWidgetState();
}

class _MessageContentWidgetState extends ConsumerState<MessageContentWidget> {
  // 缓存分离后的内容，减少重复计算
  Map<String, String?>? _cachedSeparatedContent;
  String? _lastProcessedContent;
  TextStyle? _cachedBaseTextStyle;
  ThemeData? _lastTheme;

  @override
  Widget build(BuildContext context) {
    // 处理图像生成占位符
    if (widget.message.type == MessageType.generating) {
      return _buildImageGenerationPlaceholder(context);
    }
    
    // 获取设置
    final codeBlockSettings = ref.watch(codeBlockSettingsProvider);
    final generalSettings = ref.watch(generalSettingsProvider);

    // 优先使用消息自带的思考链字段（兼容DeepSeek R1 / Reasoning 模型）
    final hasExplicitThinking =
        (widget.message.thinkingContent?.isNotEmpty ?? false);

    if (!hasExplicitThinking && _lastProcessedContent != widget.message.content) {
      _cachedSeparatedContent = _separateThinkingAndContent(
        widget.message.content,
      );
      _lastProcessedContent = widget.message.content;
    }

    final separated = hasExplicitThinking ? null : _cachedSeparatedContent;
    final thinkingContent = hasExplicitThinking
        ? widget.message.thinkingContent
        : separated?['thinking'];
    final actualContent = hasExplicitThinking
        ? widget.message.content
        : (separated?['content'] ?? widget.message.content);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 思考链显示
        if (thinkingContent != null && !widget.message.isFromUser)
          ThinkingChainWidget(
            content: thinkingContent,
            modelName: widget.message.modelName ?? '',
            isCompleted: widget.message.thinkingComplete, // 使用思考链完成状态
          ),
        // 文件附件显示
        if (widget.message.attachments.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.message.attachments.map((attachment) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: FileAttachmentCard(attachment: attachment),
                );
              }).toList(),
            ),
          ),

        // 图片显示 - 卡片式布局
        if (widget.message.imageUrls.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: _buildImageCards(),
          ),
        // 主要内容
        if (actualContent.trim().isNotEmpty)
          (generalSettings.enableMarkdownRendering
              ? _buildContentWithMath(
                  context: context,
                  content: actualContent,
                  baseTextStyle: _getBaseTextStyle(context),
                  codeBlockSettings: codeBlockSettings,
                )
              : _buildPlainTextContent(context, actualContent)),

        // 引用展示（来自模型内置联网Responses/Claude）
        if (!widget.message.isFromUser &&
            widget.message.metadata != null &&
            widget.message.metadata!['citations'] != null)
          _buildCitations(context, widget.message.metadata!['citations']),
      ],
    );
  }

  /// 构建纯文本内容（禁用 Markdown 渲染时）
  Widget _buildPlainTextContent(BuildContext context, String content) {
    final theme = Theme.of(context);
    final color = widget.message.isFromUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;
    final style = GoogleFonts.inter(
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: color,
        height: 1.7,
        letterSpacing: 0.2,
      ),
    );
    return SelectableText(content, style: style);
  }

  Widget _buildCitations(BuildContext context, dynamic citations) {
    try {
      final List<dynamic> list = citations as List<dynamic>;
      if (list.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '参考来源',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            ...list.take(5).map((e) {
              final m = e is Map<String, dynamic> ? e : <String, dynamic>{};
              final title = (m['title'] ?? m['url'] ?? '').toString();
              final url = (m['url'] ?? '').toString();
              if (title.isEmpty && url.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  /// 构建图像生成占位符
  Widget _buildImageGenerationPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final metadata = widget.message.metadata;
    final prompt = metadata?['prompt'] ?? '未知提示词';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              // 动画图标
              Shimmer.fromColors(
                baseColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                highlightColor: theme.colorScheme.primary.withValues(alpha: 0.8),
                child: Icon(
                  Icons.image,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              
              // 生成中文本
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      child: Text(
                        '正在生成图片...',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '请稍候，AI正在根据您的描述创作图片',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 提示词显示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '生成提示词：',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prompt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 进度指示器
          Row(
            children: [
              // 跳动的圆点动画
              ...List.generate(3, (index) {
                return Shimmer.fromColors(
                  baseColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  highlightColor: theme.colorScheme.primary.withValues(alpha: 0.8),
                  period: Duration(milliseconds: 800 + index * 200),
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              
              // 提示文字
              Text(
                '创作中，这可能需要几秒钟...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取缓存的基础文本样式
  TextStyle _getBaseTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    // 如果主题改变了，重新构建样式
    if (_cachedBaseTextStyle == null || _lastTheme != theme) {
      _lastTheme = theme;
      _cachedBaseTextStyle = _buildBaseTextStyle(context);
    }

    return _cachedBaseTextStyle!;
  }

  /// 构建基础文本样式
  TextStyle _buildBaseTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = widget.message.isFromUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    final bodyFont = GoogleFonts.inter(textStyle: theme.textTheme.bodyMedium);
    
    return bodyFont.copyWith(
      color: textColor, 
      height: 1.7, 
      letterSpacing: 0.2,
    );
  }

  /// 从内容中分离思考链和正文
  Map<String, String?> _separateThinkingAndContent(String content) {
    String? thinkingContent;
    String actualContent = content;

    // 检查是否包含think标签
    if (content.contains('<think>') && content.contains('</think>')) {
      final thinkStart = content.indexOf('<think>');
      final thinkEnd = content.indexOf('</think>');

      if (thinkStart != -1 && thinkEnd != -1 && thinkEnd > thinkStart) {
        // 提取思考链内容（去除标签）
        thinkingContent = content.substring(thinkStart + 7, thinkEnd).trim();

        // 提取正文内容（去除思考链部分）
        final beforeThink = content.substring(0, thinkStart).trim();
        final afterThink = content.substring(thinkEnd + 8).trim();
        actualContent = '$beforeThink $afterThink'.trim();
      }
    }

    return {'thinking': thinkingContent, 'content': actualContent};
  }

  /// 构建图片卡片网格
  Widget _buildImageCards() {
    // 从消息元数据中获取图片文件名和大小信息
    final imageFileNames =
        widget.message.metadata?['imageFileNames'] as List<dynamic>?;
    final imageFileSizes =
        widget.message.metadata?['imageFileSizes'] as List<dynamic>?;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.message.imageUrls.asMap().entries.map((entry) {
        final index = entry.key;
        final imageUrl = entry.value;

        // 获取对应索引的文件名和大小
        String? fileName;
        int? fileSize;

        if (imageFileNames != null && index < imageFileNames.length) {
          fileName = imageFileNames[index] as String?;
        }

        if (imageFileSizes != null && index < imageFileSizes.length) {
          fileSize = imageFileSizes[index] as int?;
        }

        return MessageImageCard(
          imageUrl: imageUrl,
          allImageUrls: widget.message.imageUrls,
          imageIndex: index,
          fileName: fileName,
          fileSize: fileSize,
        );
      }).toList(),
    );
  }

  /// 渲染带块级数学公式的内容
  /// 规则：使用正则表达式?$$$$ 分割，公式部分使用 [Math.tex] 渲染，其他部分使用 [MarkdownBody] 渲染
  Widget _buildContentWithMath({
    required BuildContext context,
    required String content,
    required TextStyle baseTextStyle,
    required CodeBlockSettings codeBlockSettings,
  }) {
    // 先将 \\[..\\] 格式的公式统一转换为$$..$$，便于后续统一处理
    final normalizedContent = content.replaceAllMapped(
      RegExp(r'\\\[(.*?)\\\]', dotAll: true),
      (match) => '\$\$${match.group(1)}\$\$',
    );

    final mathRegex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);

    // Collect all matches
    final List<Match> allMatches = [];
    allMatches.addAll(mathRegex.allMatches(normalizedContent));

    // Sort by start index
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    int lastEnd = 0;
    final segments = <Widget>[];

    for (final match in allMatches) {
      if (match.start > lastEnd) {
        final text = normalizedContent.substring(lastEnd, match.start);
        if (text.trim().isNotEmpty) {
          segments.add(
            _buildMarkdownWithAdapter(
              context: context,
              data: text,
              baseTextStyle: baseTextStyle,
              codeBlockSettings: codeBlockSettings,
            ),
          );
        }
      }
      final content = match.group(1)!;
      // Math
      segments.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Math.tex(
            content,
            mathStyle: MathStyle.display,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onErrorFallback: (FlutterMathException e) {
              // 出现解析错误时，降级为普通文本显示
              // ignore: unnecessary_brace_in_string_interps
              return Text('\$\$${content}\$\$');
            },
          ),
        ),
      );
      lastEnd = match.end;
    }

    // Last segment
    if (lastEnd < normalizedContent.length) {
      final text = normalizedContent.substring(lastEnd);
      if (text.trim().isNotEmpty) {
        segments.add(
          _buildMarkdownWithAdapter(
            context: context,
            data: text,
            baseTextStyle: baseTextStyle,
            codeBlockSettings: codeBlockSettings,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments,
    );
  }


  /// 适配层 + markdown_widget 渲染正文（保留代码块自定义与块级公式分段） 
  Widget _buildMarkdownWithAdapter({
    required BuildContext context,
    required String data,
    required TextStyle baseTextStyle,
    required CodeBlockSettings codeBlockSettings,
  }) {
    final renderer = MarkdownRenderer.defaultRenderer(
      engine: MarkdownEngine.markdownWidget,
    );
    return renderer.render(
      data,
      baseTextStyle: baseTextStyle,
      codeBlockBuilder: (code, language) {
        // 若markdown_widget 未提供语言，使用智能检测逻辑
        final lang = (language.isEmpty)
            ? CodeBlockLanguageDetector.detectLanguage(code)
            : language;
        return CodeBlockWidget(
          code: code,
          language: lang,
          settings: codeBlockSettings,
          isFromUser: widget.message.isFromUser,
        );
      },
    );
  }
}

/// 代码块语言检测工具类
class CodeBlockLanguageDetector {
  /// 智能语言检测：完全基于 highlight 的相关性评分
  static String detectLanguage(String code) {
    try {
      const languages = [
        'python',
        'javascript',
        'typescript',
        'dart',
        'java',
        'kotlin',
        'swift',
        'go',
        'rust',
        'cpp',
        'c',
        'csharp',
        'php',
        'ruby',
        'html',
        'css',
        'json',
        'yaml',
        'bash',
        'sql',
        'xml',
      ];
      String best = 'text';
      int bestScore = 0;
      for (final lang in languages) {
        try {
          final r = highlight.highlight.parse(code, language: lang);
          final score = r.relevance ?? 0;
          if (score > bestScore) {
            bestScore = score;
            best = lang;
          }
        } catch (_) {}
      }
      return bestScore >= 8 ? best : 'text';
    } catch (_) {
      return 'text';
    }
  }
}

/// 代码块组件
class CodeBlockWidget extends StatefulWidget {
  final String code;
  final String language;
  final CodeBlockSettings settings;
  final bool isFromUser;

  const CodeBlockWidget({
    super.key,
    required this.code,
    required this.language,
    required this.settings,
    required this.isFromUser,
  });

  @override
  State<CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

/// 语言信息类
class LanguageInfo {
  final IconData icon;
  final String displayName;
  final Color color;

  const LanguageInfo({
    required this.icon,
    required this.displayName,
    this.color = Colors.grey,
  });
}

/// 语言信息映射表
const Map<String, LanguageInfo> _languageInfoMap = {
  'dart': LanguageInfo(
    icon: Icons.flutter_dash,
    displayName: 'Dart',
    color: Color(0xFF0175C2),
  ),
  'python': LanguageInfo(
    icon: Icons.smart_toy,
    displayName: 'Python',
    color: Color(0xFF3776AB),
  ),
  'javascript': LanguageInfo(
    icon: Icons.javascript,
    displayName: 'JavaScript',
    color: Color(0xFFF7DF1E),
  ),
  'typescript': LanguageInfo(
    icon: Icons.code,
    displayName: 'TypeScript',
    color: Color(0xFF3178C6),
  ),
  'java': LanguageInfo(
    icon: Icons.coffee,
    displayName: 'Java',
    color: Color(0xFF007396),
  ),
  'html': LanguageInfo(
    icon: Icons.web,
    displayName: 'HTML',
    color: Color(0xFFE34C26),
  ),
  'css': LanguageInfo(
    icon: Icons.style,
    displayName: 'CSS',
    color: Color(0xFF1572B6),
  ),
  'json': LanguageInfo(
    icon: Icons.data_object,
    displayName: 'JSON',
    color: Color(0xFF000000),
  ),
  'yaml': LanguageInfo(
    icon: Icons.settings,
    displayName: 'YAML',
    color: Color(0xFFCB171E),
  ),
  'bash': LanguageInfo(
    icon: Icons.terminal,
    displayName: 'Shell',
    color: Color(0xFF4EAA25),
  ),
  'sql': LanguageInfo(
    icon: Icons.storage,
    displayName: 'SQL',
    color: Color(0xFF336791),
  ),
  'text': LanguageInfo(
    icon: Icons.description,
    displayName: 'Plain Text',
    color: Color(0xFF757575),
  ),
};

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  bool _isExpanded = true;
  bool _showLineNumbers = true;
  bool _isCopied = false;
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isExpanded = !widget.settings.defaultCollapseCodeBlocks;
    _showLineNumbers = widget.settings.enableLineNumbers;
    _controller = TextEditingController(text: widget.code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 0.6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: theme.colorScheme.outline.withValues(alpha: 0.10),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? _buildCodeContent(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建代码块头部
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final lang =
        _languageInfoMap[widget.language.toLowerCase()] ??
        _languageInfoMap['text']!;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 6, 5),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: lang.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: lang.color.withValues(alpha: 0.35),
                width: 0.6,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getLanguageIcon(widget.language),
                  size: 12,
                  color: lang.color,
                ),
                const SizedBox(width: 4),
                Text(
                  _getLanguageDisplayName(widget.language),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: lang.color,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 图表创建按钮（当代码块为 chart-json 或 json 且符合规范时显示）
          if ((widget.language.toLowerCase() == 'chart-json' || widget.language.toLowerCase() == 'json')
              && isChartSpecJson(widget.code))
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              iconSize: 14,
              visualDensity: VisualDensity.compact,
              tooltip: '创建图表',
              icon: const Icon(Icons.pie_chart_outline),
              onPressed: () {
                showChartPreviewDialog(context, widget.code);
              },
            ),
          if (widget.settings.enableLineNumbers)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              iconSize: 14,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                _showLineNumbers
                    ? Icons.format_list_numbered
                    : Icons.format_align_left,
              ),
              onPressed: () {
                setState(() {
                  _showLineNumbers = !_showLineNumbers;
                });
              },
              tooltip: _showLineNumbers ? '隐藏行号' : '显示行号',
            ),
          if (widget.settings.enableCodeFolding)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              iconSize: 14,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              tooltip: _isExpanded ? '折叠代码' : '展开代码',
            ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            iconSize: 14,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              _isCopied ? Icons.check : Icons.copy,
              color: _isCopied ? Colors.green : null,
            ),
            onPressed: () => _copyCode(context),
            tooltip: _isCopied ? '已复制代码' : '复制代码',
          ),
          if (widget.settings.enableCodeEditing)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              iconSize: 14,
              visualDensity: VisualDensity.compact,
              icon: Icon(_isEditing ? Icons.edit_off : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              tooltip: _isEditing ? '关闭编辑' : '编辑代码',
            ),
        ],
      ),
    );
  }

  /// 构建代码内容
  Widget _buildCodeContent(BuildContext context) {
    final lines = widget.code.split('\n');
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showLineNumbers) _buildLineNumbers(lines, theme),
          Expanded(
            child: widget.settings.enableCodeEditing && _isEditing
                ? _buildEditableCode(theme)
                : (widget.settings.enableCodeWrapping
                      ? _buildWrappableCode(theme)
                      : _buildScrollableCode(theme)),
          ),
        ],
      ),
    );
  }

  /// 构建行号
  Widget _buildLineNumbers(List<String> lines, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: lines.asMap().entries.map((entry) {
          return SizedBox(
            height: 20,
            child: Text(
              '${entry.key + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.end,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 构建可换行的代码
  Widget _buildWrappableCode(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = _getCodeTheme(isDark);

    return HighlightView(
      widget.code,
      language: widget.language,
      theme: codeTheme,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      textStyle: const TextStyle(
        fontFamily: 'Source Code Pro, monospace',
        fontSize: 14,
      ),
    );
  }

  /// 构建可滚动的代码
  Widget _buildScrollableCode(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final codeTheme = _getCodeTheme(isDark);

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HighlightView(
          widget.code,
          language: widget.language,
          theme: codeTheme,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: const TextStyle(
            fontFamily: 'Source Code Pro, monospace',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// 可编辑代码视图
  Widget _buildEditableCode(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          maxLines: null,
          style: const TextStyle(
            fontFamily: 'Source Code Pro, monospace',
            fontSize: 14,
          ),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.save, size: 16),
                label: const Text('保存到剪贴板'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _controller.text));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('已复制编辑后的代码')));
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: const Text('完成'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 获取代码高亮主题
  Map<String, TextStyle> _getCodeTheme(bool isDark) {
    // 使用原来的Atom One 主题
    final base = isDark ? atomOneDarkTheme : atomOneLightTheme;

    // 取消注释、文档标签、引用的斜体样式
    final fixed = Map<String, TextStyle>.from(base);
    const keys = ['comment', 'doctag', 'quote'];
    for (var k in keys) {
      if (fixed.containsKey(k)) {
        fixed[k] = fixed[k]!.copyWith(fontStyle: FontStyle.normal);
      }
    }
    return fixed;
  }

  /// 复制代码到剪贴板
  void _copyCode(BuildContext context) {
    if (_isCopied) return; // 防止重复点击

    Clipboard.setData(ClipboardData(text: widget.code));

    setState(() {
      _isCopied = true;
    });

    // 显示SnackBar反馈
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('代码已复制到剪贴板'),
        duration: Duration(seconds: 2),
      ),
    );

    // 2秒后恢复按钮状态
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  /// 获取语言对应的图标
  IconData _getLanguageIcon(String language) {
    return _languageInfoMap[language.toLowerCase()]?.icon ?? Icons.code;
  }

  /// 获取语言的显示名称
  String _getLanguageDisplayName(String language) {
    return _languageInfoMap[language.toLowerCase()]?.displayName ??
        language.toUpperCase();
  }
}

// 清理完成：已移除 flutter_markdown 相关构建器和语法类
// 所有 Markdown 渲染都交由 MarkdownRenderer 适配器处理
