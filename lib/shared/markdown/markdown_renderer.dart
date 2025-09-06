import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fm;
import 'package:markdown_widget/markdown_widget.dart' as mdw;
import 'package:markdown/markdown.dart' as md;

/// 渲染引擎类型
enum MarkdownEngine { flutterMarkdown, markdownWidget }

/// Markdown 渲染适配器（最小公共接口）
abstract class MarkdownRenderer {
  const MarkdownRenderer();

  /// 渲染入口
  Widget render(
    String data, {
    TextStyle? baseTextStyle,
    /// 自定义代码块构建器（用于接入现有 CodeBlockWidget 等）
    Widget Function(String code, String language)? codeBlockBuilder,
    /// 可选：flutter_markdown 使用的扩展集（如 GFM 去除缩进代码块）
    md.ExtensionSet? extensionSet,
  });

  /// 工厂：按需选择引擎（默认采用 markdown_widget 以便试点）
  factory MarkdownRenderer.defaultRenderer({MarkdownEngine? engine}) {
    switch (engine) {
      case MarkdownEngine.flutterMarkdown:
        return const _FlutterMarkdownRenderer();
      case MarkdownEngine.markdownWidget:
      default:
        return const _MarkdownWidgetRenderer();
    }
  }
}

/// Flutter Markdown 渲染实现（保持现有样式的最小一致性）
class _FlutterMarkdownRenderer implements MarkdownRenderer {
  const _FlutterMarkdownRenderer();

  @override
  Widget render(
    String data, {
    TextStyle? baseTextStyle,
    Widget Function(String code, String language)? codeBlockBuilder,
    md.ExtensionSet? extensionSet,
  }) {
    // 说明：适配层保持最小职责，这里仅设置段落基础样式与扩展集。
    // 具体的 builders / inlineSyntaxes 仍由调用方控制（保留向后兼容）。
    return fm.MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: fm.MarkdownStyleSheet(
        p: baseTextStyle,
      ),
      extensionSet: extensionSet,
    );
  }
}

/// markdown_widget 渲染实现（先以默认配置接入，后续逐步覆盖样式/规则）
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
