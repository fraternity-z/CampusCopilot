import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:markdown/markdown.dart' as md;
import '../../../../../app/app_router.dart';
import 'language_detector.dart';

/// 消息内容渲染组件
///
/// 支持功能：
/// - Markdown语法渲染
/// - 代码块语法高亮
/// - 代码折叠/展开
/// - 行号显示
/// - 复制功能
/// - 多种主题
class MessageContentWidget extends ConsumerWidget {
  final String content;
  final bool isFromUser;

  const MessageContentWidget({
    super.key,
    required this.content,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalSettings = ref.watch(generalSettingsProvider);
    final codeBlockSettings = ref.watch(codeBlockSettingsProvider);

    // 如果不启用Markdown渲染，直接返回纯文本
    if (!generalSettings.enableMarkdownRendering) {
      return SelectableText(
        content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isFromUser
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurface,
        ),
      );
    }

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: _buildMarkdownStyleSheet(context),
      builders: {
        'code': CodeBlockBuilder(
          codeBlockSettings: codeBlockSettings,
          isFromUser: isFromUser,
        ),
        'pre': CodeBlockBuilder(
          codeBlockSettings: codeBlockSettings,
          isFromUser: isFromUser,
        ),
      },
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
    );
  }

  /// 构建Markdown样式表
  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isFromUser
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return MarkdownStyleSheet(
      p: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      h1: theme.textTheme.headlineMedium?.copyWith(color: textColor),
      h2: theme.textTheme.headlineSmall?.copyWith(color: textColor),
      h3: theme.textTheme.titleLarge?.copyWith(color: textColor),
      h4: theme.textTheme.titleMedium?.copyWith(color: textColor),
      h5: theme.textTheme.titleSmall?.copyWith(color: textColor),
      h6: theme.textTheme.titleSmall?.copyWith(color: textColor),
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: textColor.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
      ),
      strong: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      em: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: 'monospace',
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      listBullet: theme.textTheme.bodyMedium?.copyWith(color: textColor),
    );
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
    var language =
        element.attributes['class']?.replaceFirst('language-', '') ?? '';

    // 如果没有指定语言或者是无效语言，使用自动检测
    if (language.isEmpty || !LanguageDetector.isLanguageSupported(language)) {
      language = LanguageDetector.detectLanguage(code);
    }

    return CodeBlockWidget(
      code: code,
      language: language,
      settings: codeBlockSettings,
      isFromUser: isFromUser,
    );
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

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  bool _isExpanded = true;
  bool _showLineNumbers = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = !widget.settings.defaultCollapseCodeBlocks;
    _showLineNumbers = widget.settings.enableLineNumbers;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 代码块头部
          _buildHeader(context, isDark),
          // 代码内容
          if (_isExpanded) _buildCodeContent(context, isDark),
        ],
      ),
    );
  }

  /// 构建代码块头部
  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          // 语言图标和标签
          Icon(
            _getLanguageIcon(widget.language),
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            _getLanguageDisplayName(widget.language),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // 行号切换按钮
          if (widget.settings.enableLineNumbers)
            IconButton(
              icon: Icon(
                _showLineNumbers
                    ? Icons.format_list_numbered
                    : Icons.format_list_numbered_rtl,
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  _showLineNumbers = !_showLineNumbers;
                });
              },
              tooltip: _showLineNumbers ? '隐藏行号' : '显示行号',
            ),
          // 折叠/展开按钮
          if (widget.settings.enableCodeFolding)
            IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              tooltip: _isExpanded ? '折叠代码' : '展开代码',
            ),
          // 复制按钮
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () => _copyCode(context),
            tooltip: '复制代码',
          ),
        ],
      ),
    );
  }

  /// 构建代码内容
  Widget _buildCodeContent(BuildContext context, bool isDark) {
    final codeStyle = _getCodeStyle(isDark);
    final lines = widget.code.split('\n');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 行号
          if (_showLineNumbers) _buildLineNumbers(lines),
          // 代码内容
          Expanded(
            child: widget.settings.enableCodeWrapping
                ? _buildWrappableCode(codeStyle)
                : _buildScrollableCode(codeStyle),
          ),
        ],
      ),
    );
  }

  /// 构建行号
  Widget _buildLineNumbers(List<String> lines) {
    final theme = Theme.of(context);

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
  Widget _buildWrappableCode(Map<String, TextStyle> codeStyle) {
    return HighlightView(
      widget.code,
      language: widget.language,
      theme: codeStyle,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      textStyle: const TextStyle(
        fontFamily: 'Source Code Pro, monospace',
        fontSize: 14,
      ),
    );
  }

  /// 构建可滚动的代码
  Widget _buildScrollableCode(Map<String, TextStyle> codeStyle) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: HighlightView(
        widget.code,
        language: widget.language,
        theme: codeStyle,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(
          fontFamily: 'Source Code Pro, monospace',
          fontSize: 14,
        ),
      ),
    );
  }

  /// 获取代码高亮主题
  Map<String, TextStyle> _getCodeStyle(bool isDark) {
    // 仅使用 Atom One 主题
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
    Clipboard.setData(ClipboardData(text: widget.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('代码已复制到剪贴板'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// 获取语言对应的图标
  IconData _getLanguageIcon(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Icons.flutter_dash;
      case 'python':
        return Icons.smart_toy;
      case 'javascript':
      case 'typescript':
        return Icons.javascript;
      case 'java':
        return Icons.coffee;
      case 'html':
        return Icons.web;
      case 'css':
        return Icons.style;
      case 'json':
        return Icons.data_object;
      case 'yaml':
        return Icons.settings;
      case 'bash':
        return Icons.terminal;
      case 'sql':
        return Icons.storage;
      default:
        return Icons.code;
    }
  }

  /// 获取语言的显示名称
  String _getLanguageDisplayName(String language) {
    switch (language.toLowerCase()) {
      case 'javascript':
        return 'JavaScript';
      case 'typescript':
        return 'TypeScript';
      case 'html':
        return 'HTML';
      case 'css':
        return 'CSS';
      case 'json':
        return 'JSON';
      case 'yaml':
        return 'YAML';
      case 'bash':
        return 'Shell';
      case 'sql':
        return 'SQL';
      case 'text':
        return 'Plain Text';
      default:
        return language.toUpperCase();
    }
  }
}
