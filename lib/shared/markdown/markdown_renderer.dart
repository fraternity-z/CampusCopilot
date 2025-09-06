import 'package:flutter/material.dart';

// 两套渲染引擎的最小适配：
// - Flutter Markdown: 现有实现，稳定可靠
// - markdown_widget: 新实现，便于后续扩展（TOC、自定义节点等）

import 'package:flutter_markdown/flutter_markdown.dart' as fm;
import 'package:markdown_widget/markdown_widget.dart' as mdw;

/// 渲染引擎类型
enum MarkdownEngine { flutterMarkdown, markdownWidget }

/// Markdown 渲染适配器（最小公共接口）
abstract class MarkdownRenderer {
  const MarkdownRenderer();

  /// 渲染入口
  Widget render(
    String data, {
    TextStyle? baseTextStyle,
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
  }) {
    return fm.MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: fm.MarkdownStyleSheet(
        p: baseTextStyle,
      ),
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
  }) {
    // 说明：markdown_widget 的样式/行为主要通过 config/styleConfig 扩展；
    // 这里先以最小接入为目标，后续在渐进迁移阶段再逐项对齐样式与自定义规则。
    return mdw.MarkdownWidget(
      data: data,
      // 后续迭代：在此传入 mdw.MarkdownConfig / mdw.StyleConfig 以覆盖字体/颜色/间距
    );
  }
}

