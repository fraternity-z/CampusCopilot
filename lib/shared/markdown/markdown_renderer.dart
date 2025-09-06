import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart' as mdw;
import 'package:markdown/markdown.dart' as md;

/// 渲染引擎类型
enum MarkdownEngine { markdownWidget }

/// Markdown 渲染适配器（最小公共接口）
abstract class MarkdownRenderer {
  const MarkdownRenderer();

  /// 渲染入口
  Widget render(
    String data, {
    TextStyle? baseTextStyle,
    /// 自定义代码块构建器（用于接入现有 CodeBlockWidget 等）
    Widget Function(String code, String language)? codeBlockBuilder,
    /// 可选：Markdown 扩展集配置（如 GFM 样式）
    md.ExtensionSet? extensionSet,
  });

  /// 工厂：返回默认的 markdown_widget 渲染器
  factory MarkdownRenderer.defaultRenderer({MarkdownEngine? engine}) {
    return const _MarkdownWidgetRenderer();
  }
}

/// markdown_widget 渲染实现（已完全替换 flutter_markdown）
class _MarkdownWidgetRenderer implements MarkdownRenderer {
  const _MarkdownWidgetRenderer();

  @override
  Widget render(
    String data, {
    TextStyle? baseTextStyle,
    Widget Function(String code, String language)? codeBlockBuilder,
    md.ExtensionSet? extensionSet,
  }) {
    // markdown_widget 的样式/行为主要通过 MarkdownConfig 配置：
    // - 段落样式：PConfig(textStyle)
    // - 代码块：PreConfig(builder) 交由现有 CodeBlockWidget 渲染，保持原交互
    // - 行内 code：用 CodeConfig 的 TextStyle 做轻量近似（后续可升级）
    final List<mdw.WidgetConfig> cfg = [];
    if (baseTextStyle != null) {
      cfg.add(mdw.PConfig(textStyle: baseTextStyle));
    }
    cfg.add(const mdw.CodeConfig(
      style: TextStyle(backgroundColor: Color(0x16000000)),
    ));
    if (codeBlockBuilder != null) {
      cfg.add(mdw.PreConfig(builder: (code, lang) => codeBlockBuilder(code, lang)));
    } else {
      cfg.add(const mdw.PreConfig());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 0.0;
        final double? boundedWidth = (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
            ? constraints.maxWidth
            : (screenWidth > 0 ? screenWidth : null);
        // 用 SizedBox 明确提供横向约束，避免 Vertical viewport was given unbounded width
        return SizedBox(
          width: (boundedWidth == null || boundedWidth == 0) ? null : boundedWidth,
          child: mdw.MarkdownWidget(
            data: data,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            selectable: true,
            config: mdw.MarkdownConfig(configs: cfg),
          ),
        );
      },
    );
  }
}
