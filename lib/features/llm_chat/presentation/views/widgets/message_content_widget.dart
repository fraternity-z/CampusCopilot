import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:highlight/highlight.dart' as highlight;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown/markdown.dart' show InlineSyntax;
import '../../../../../app/app_router.dart' show codeBlockSettingsProvider, generalSettingsProvider, CodeBlockSettings;
import 'thinking_chain_widget.dart';
import '../../../domain/entities/chat_message.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'enhanced_mermaid_renderer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'file_attachment_card.dart';
import 'image_preview_widget.dart';
import 'dart:ui' as ui;
import 'package:shimmer/shimmer.dart';

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
  MarkdownStyleSheet? _cachedStyleSheet;
  ThemeData? _lastTheme;

  @override
  Widget build(BuildContext context) {
    // 处理图像生成占位符
    if (widget.message.type == MessageType.generating) {
      return _buildImageGenerationPlaceholder(context);
    }
    
    // 获取设置
    final codeBlockSettings = ref.watch(codeBlockSettingsProvider);

    // 仅在内容变化时重新分离思考链与正文
    if (_lastProcessedContent != widget.message.content) {
      _cachedSeparatedContent = _separateThinkingAndContent(
        widget.message.content,
      );
      _lastProcessedContent = widget.message.content;
    }

    final separated = _cachedSeparatedContent!;
    final thinkingContent = separated['thinking'];
    final actualContent = separated['content'] ?? widget.message.content;


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
          _buildContentWithMath(
            context: context,
            content: actualContent,
            styleSheet: _getMarkdownStyleSheet(context),
            codeBlockSettings: codeBlockSettings,
          ),

        // 引用展示（来自模型内置联网/Responses/Claude）
        if (!widget.message.isFromUser &&
            widget.message.metadata != null &&
            widget.message.metadata!['citations'] != null)
          _buildCitations(context, widget.message.metadata!['citations']),
      ],
    );
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
              
              // 生成中文字
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

  /// 获取缓存的Markdown样式表
  MarkdownStyleSheet _getMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);

    // 如果主题改变了，重新构建样式表
    if (_cachedStyleSheet == null || _lastTheme != theme) {
      _lastTheme = theme;
      _cachedStyleSheet = _buildMarkdownStyleSheet(context);
    }

    return _cachedStyleSheet!;
  }

  /// 构建Markdown样式表
  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = widget.message.isFromUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    final bodyFont = GoogleFonts.inter(textStyle: theme.textTheme.bodyMedium);
    final headingFont = GoogleFonts.poppins(
      textStyle: theme.textTheme.headlineMedium,
    );

    return MarkdownStyleSheet(
      p: bodyFont.copyWith(color: textColor, height: 1.7, letterSpacing: 0.2),
      h1: headingFont.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        height: 1.4,
      ),
      h2: headingFont.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.4,
      ),
      h3: headingFont.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 1.4,
      ),
      h4: headingFont.copyWith(color: textColor, fontSize: 18),
      h5: headingFont.copyWith(color: textColor, fontSize: 16),
      h6: headingFont.copyWith(color: textColor, fontSize: 14),
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: textColor.withValues(alpha: 0.85),
      ),
      strong: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      em: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
      ),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: 'JetBrains Mono, Source Code Pro, monospace',
        fontSize: 13,
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.6,
        ),
      ),
      listBullet: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      // 间距优化
      blockSpacing: 16,
      // 透明化默认代码块装饰，去除可能的白色占位背景
      codeblockDecoration: const BoxDecoration(color: Colors.transparent),
      // flutter_markdown 0.7.x 不支持这些属性，保留兼容的 blockSpacing 即可
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
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

  /// 渲染带块级数学公式的内容。
  /// 规则：使用正则表达式按 $$$$ 分割，公式部分使用 [Math.tex] 渲染，其他部分使用 MarkdownBody。
  Widget _buildContentWithMath({
    required BuildContext context,
    required String content,
    required MarkdownStyleSheet styleSheet,
    required CodeBlockSettings codeBlockSettings,
  }) {
    // 先将 \\[..\\] 格式的公式统一转换为 $$..$$，便于后续统一处理
    final normalizedContent = content.replaceAllMapped(
      RegExp(r'\\\[(.*?)\\\]', dotAll: true),
      (match) => '\$\$${match.group(1)}\$\$',
    );

    final mathRegex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);
    final mermaidRegex = RegExp(r'```mermaid\s*\n(.*?)\n\s*```', dotAll: true);

    // Collect all matches
    final List<Match> allMatches = [];
    allMatches.addAll(mathRegex.allMatches(normalizedContent));

    // 添加 Mermaid 图表匹配
    final mermaidMatches = mermaidRegex.allMatches(normalizedContent);
    allMatches.addAll(mermaidMatches);

    // Sort by start index
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    int lastEnd = 0;
    final segments = <Widget>[];

    for (final match in allMatches) {
      if (match.start > lastEnd) {
        final text = normalizedContent.substring(lastEnd, match.start);
        if (text.trim().isNotEmpty) {
          segments.add(
            _buildMarkdownWithMathEngine(
              context: context,
              data: text,
              styleSheet: styleSheet,
              codeBlockSettings: codeBlockSettings,
            ),
          );
        }
      }
      final content = match.group(1)!;
      if (match.pattern == mathRegex.pattern) {
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
      } else {
        // Mermaid - 使用简化的容器，让布局管理器处理边距和约束
        segments.add(
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: codeBlockSettings.enableMermaidDiagrams
                ? EnhancedMermaidRenderer(mermaidCode: content)
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mermaid图表 (已禁用)',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      }
      lastEnd = match.end;
    }

    // Last segment
    if (lastEnd < normalizedContent.length) {
      final text = normalizedContent.substring(lastEnd);
      if (text.trim().isNotEmpty) {
        segments.add(
          _buildMarkdownWithMathEngine(
            context: context,
            data: text,
            styleSheet: styleSheet,
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

  /// 根据 GeneralSettings 的 mathEngine 选择 KaTeX 或 flutter_math 渲染行内公式
  Widget _buildMarkdownWithMathEngine({
    required BuildContext context,
    required String data,
    required MarkdownStyleSheet styleSheet,
    required CodeBlockSettings codeBlockSettings,
  }) {
    final general = ref.read(generalSettingsProvider);
    final ext = _gfmWithoutIndentedCode();
    if (general.mathEngine == 'mathjax') {
      // MathJax 路径：使用 flutter_math_fork 同步渲染，行内仍用 Math.tex
      return MarkdownBody(
        data: data,
        selectable: true,
        styleSheet: styleSheet,
        inlineSyntaxes: [InlineLatexSyntax()],
        builders: {
          'code': EnhancedInlineCodeBuilder(
            isFromUser: widget.message.isFromUser,
          ),
          'pre': CodeBlockBuilder(
            codeBlockSettings: codeBlockSettings,
            isFromUser: widget.message.isFromUser,
          ),
          'inline_math': InlineLatexBuilder(),
          // 这些增强构建器在本文件下方定义
          'blockquote': EnhancedBlockquoteBuilder(),
        },
        extensionSet: ext,
      );
    }
    // KaTeX 也复用 flutter_math_fork 渲染，方便跨平台；未来可替换为 HTML+KaTeX
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: styleSheet,
      inlineSyntaxes: [InlineLatexSyntax()],
      builders: {
        'code': EnhancedInlineCodeBuilder(
          isFromUser: widget.message.isFromUser,
        ),
        'pre': CodeBlockBuilder(
          codeBlockSettings: codeBlockSettings,
          isFromUser: widget.message.isFromUser,
        ),
        'inline_math': InlineLatexBuilder(),
        'blockquote': EnhancedBlockquoteBuilder(),
      },
      extensionSet: ext,
    );
  }

  /// 基于 GFM 的扩展集，但移除缩进代码块语法，避免普通缩进行被误判为代码块
  md.ExtensionSet _gfmWithoutIndentedCode() {
    final List<md.BlockSyntax> blocks =
        List<md.BlockSyntax>.from(md.ExtensionSet.gitHubFlavored.blockSyntaxes)
          ..removeWhere(
            (s) => s.runtimeType.toString() == 'IndentedCodeBlockSyntax',
          );
    final List<md.InlineSyntax> inline = List<md.InlineSyntax>.from(
      md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
    );
    // 注意：markdown.ExtensionSet 的构造参数顺序为 (blockSyntaxes, inlineSyntaxes)
    return md.ExtensionSet(blocks, inline);
  }
}

/// 代码块构建器
class CodeBlockBuilder extends MarkdownElementBuilder {
  final CodeBlockSettings codeBlockSettings;
  final bool isFromUser;

  CodeBlockBuilder({required this.codeBlockSettings, required this.isFromUser});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    // 强制使用智能检测，不再信任围栏声明或简单关键词
    var language = _detectLanguage(code);

    return CodeBlockWidget(
      code: code,
      language: language,
      settings: codeBlockSettings,
      isFromUser: isFromUser,
    );
  }

  /// 智能语言检测：完全基于 highlight 的相关性评分
  String _detectLanguage(String code) {
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
            tooltip: _isCopied ? '已复制' : '复制代码',
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
    // 使用原来的 Atom One 主题
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

/// 行内数学公式语法，例如 $a^2 + b^2=c^2$
class InlineLatexSyntax extends InlineSyntax {
  InlineLatexSyntax() : super(r'\$(?!\$)(.+?)(?<!\$)\$');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final mathContent = match.group(1)!;
    parser.addNode(md.Element.text('inline_math', mathContent));
    return true;
  }
}

/// 行内数学公式Builder，将 Element 渲染为 Math.tex
class InlineLatexBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Math.tex(
      element.textContent,
      mathStyle: MathStyle.text,
      textStyle: preferredStyle,
      onErrorFallback: (e) => Text(element.textContent),
    );
  }
}

/// 增强的行内代码构建器（紫色圆角标签）
class EnhancedInlineCodeBuilder extends MarkdownElementBuilder {
  final bool isFromUser;
  EnhancedInlineCodeBuilder({required this.isFromUser});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final borderRadius = BorderRadius.circular(8);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            element.textContent,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono, monospace',
              fontSize: 13,
              color: Color(0xFF6A1B9A),
            ),
          ),
        ),
      ),
    );
  }
}

// 轻量占位：目前仅用于让 builder 不报错；详细样式已在 MarkdownStyleSheet 中体现
class EnhancedBlockquoteBuilder extends MarkdownElementBuilder {}

class EnhancedHorizontalRuleBuilder extends MarkdownElementBuilder {}

class EnhancedHeadingBuilder extends MarkdownElementBuilder {
  final int level;
  EnhancedHeadingBuilder({required this.level});
}
