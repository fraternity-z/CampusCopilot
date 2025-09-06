# Markdown 渲染迁移方案（flutter_markdown → markdown_widget）

## 背景与现状

项目当前主要在消息内容与思考链组件中使用 `flutter_markdown` 完成 Markdown 渲染，并在此基础上实现了较多自定义能力，包括 GitHub Flavored Markdown 的取舍、行内与块级 LaTeX 公式渲染（借助 `flutter_math_fork` 与自定义语法）、代码块高亮与折叠/行号/复制、以及流式增量渲染路径。`pubspec.yaml` 中已引入 `markdown_widget: ^2.3.2+6` 但尚未使用。

本方案目标是在保证功能与体验不回退的前提下，逐步用 `markdown_widget` 替换现有渲染内核，收敛渲染差异，获得目录（TOC）、更灵活的节点扩展与样式配置等能力，并保留随时回滚的安全阀。

## 可行性评估

`markdown_widget` 提供跨平台、TOC、代码高亮、暗色模式与较强的可扩展能力，适合承载后续的自定义需求。对当前关键能力的覆盖评估如下：普通 Markdown 标题、列表、引用、链接、图片等基础语法覆盖度高且成熟；代码高亮可以继续使用 `highlight` 生态并通过配置覆盖主题，不阻塞现有代码卡片；行号、折叠、复制功能是我们自定义的代码块容器，与具体 Markdown 引擎解耦，迁移时无需重写；LaTeX 公式不是 `markdown_widget` 的内置职责，可以延用现有“以 $$…$$ 分段 + `Math.tex` 渲染”的策略，在渐进阶段保持稳定，再评估是否用其自定义节点机制接管。

综合判断：替换渲染内核具备可行性，建议先低风险试点，再迁移主消息渲染，逐项对齐样式与交互。

## API 差异与映射

现用 `flutter_markdown` 以 `MarkdownBody(data, styleSheet, builders, inlineSyntaxes, extensionSet, onTapLink, imageBuilder…)` 方式配置，强调通过 element builder 与语法扩展接管节点渲染。`markdown_widget` 以 `MarkdownWidget(data)` 为主入口，风格通过 `MarkdownConfig/StyleConfig` 配置，目录通过 `TocController` 驱动，且可使用 `MarkdownGenerator` 将 Markdown 生成 Widget 列表；若需扩展语法/节点，可通过“生成器 + 自定义节点/规则”的方式覆盖。两者都能完成基础渲染与链接处理，差异在于扩展点与样式覆盖路径不同。迁移初期以“最小接入 + 渐进补齐”的方式避免一次性重写大量构建器。

## 渐进式迁移计划

阶段一：引入渲染适配层并在低风险入口试点。新增 `lib/shared/markdown/markdown_renderer.dart`，提供统一接口与两套实现（`flutter_markdown` 与 `markdown_widget`）。首先在思考链组件接入适配层并默认使用 `markdown_widget`，不改变主消息体实现。完成小规模比对与回归验证。

阶段二：在主消息内容组件中接入适配层，仅替换 Markdown 内核，保留既有“公式分段 + Math.tex 渲染”的逻辑与自定义代码卡片组件，确保代码高亮/行号/折叠/复制等交互不变。随后逐项对齐段落、标题、引用、列表等样式。

阶段三：如有需要，将公式解析迁移为 `markdown_widget` 的自定义节点机制，或继续使用分段策略。对齐链接点击与图片加载策略，统一浅/深色主题下的字体、行距与颜色，按需启用 TOC。

阶段四：在功能与样式完全一致后，评估移除 `flutter_markdown` 依赖或保留为后备。输出迁移报告与回滚指南。

## 验收与验证

以典型用例集进行端到端比对，包括：长段落、标题层级、嵌套列表、引用、行内代码与代码围栏（多语言）、图片/链接点击、行内与块级公式、以及流式内容的增量更新表现。观察首次构建耗时、滚动流畅度与内存曲线，确认无明显回退。对关键界面截屏对比，确认视觉差异在可接受范围。

## 风险与规避

LaTeX 公式解析差异是主要风险。迁移初期保留现有“分段 + Math.tex”实现，避免一次性切换解析链路。样式与行距可能存在偏差，先最小接入，分阶段统一 `StyleConfig`。链接与图片行为差异通过适配层参数逐项补齐。任何阶段可通过适配层快速切换回 `flutter_markdown`，作为回滚策略。

## 推荐方案与当前落地

推荐采用“适配层 + 试点迁移”的策略。该策略对现有复杂自定义侵入最小，具备随时回滚能力，同时为后续的节点级扩展保留空间。当前已完成阶段一：新增适配层并在 `thinking_chain_widget.dart` 试点接入 `markdown_widget`。后续将把同一适配层接入主消息组件，再分阶段对齐样式与行为。

