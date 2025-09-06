# 图表 JSON 规范与集成方案（graphic）

## 目标

- 在消息内，AI 输出规范的图表 JSON 片段；当代码块语言为 `chart-json`（推荐）或 `json` 且结构符合规范时，显示“创建图表”按钮。
- 点击按钮弹出预览对话框，使用 `graphic` 渲染；支持导出 PNG。

## JSON 规范

- 必填字段：
  - `chart`: 图表类型，`line | bar | scatter | pie`
  - `data`: 数组，元素为对象（记录）。
  - `encode`: 字段映射对象，常用键：
    - `x`: x 轴字段名
    - `y`: y 轴字段名
    - `color`: 分类/系列字段名（可选）
- 可选字段：
  - `title`: 图表标题
  - `axis`: 轴配置对象（目前用于是否绘制坐标轴、标题文本）
  - `options`: 绘图选项，如 `{"smooth": true, "stack": false, "transpose": false}`

### 示例

```chart-json
{
  "chart": "line",
  "title": "月度趋势",
  "data": [
    {"x": "Jan", "y": 120, "s": "系列A"},
    {"x": "Feb", "y": 132, "s": "系列A"},
    {"x": "Jan", "y": 98,  "s": "系列B"}
  ],
  "encode": {"x": "x", "y": "y", "color": "s"},
  "axis": {"x": {"title": "月份"}, "y": {"title": "数值"}},
  "options": {"smooth": true}
}
```

## AI 生成约束（提示模板片段）

```
请在回答末尾单独附上一个图表 JSON 代码块：
```chart-json
{
  "chart": "line|bar|scatter|pie",
  "title": "...",
  "data": [{"x": "...", "y": 0, "s": "可选系列名"}],
  "encode": {"x": "x", "y": "y", "color": "s"},
  "axis": {"x": {"title": "..."}, "y": {"title": "..."}},
  "options": {"smooth": false, "stack": false, "transpose": false}
}
```
仅输出一个 JSON 对象，不要在代码块内包含注释或其他文本。
```

## 集成点与职责

- `lib/shared/charts/chart_from_json.dart`
  - `isChartSpecJson(code)`: 校验 JSON 是否符合规范。
  - `showChartPreviewDialog(context, code)`: 解析 JSON → 生成 `graphic.Chart` → 弹窗预览与导出 PNG。
- `CodeBlockWidget._buildHeader(...)`
  - 若 `language` 为 `chart-json` 或 `json` 且 `isChartSpecJson(code)` 为真，则显示“创建图表”按钮，点击触发预览。

## 导出 PNG

- 对话框中的图表包裹 `RepaintBoundary`，通过 `toImage` 获取 PNG 字节。
- 使用 `file_selector` 的 `getSaveLocation` 与 `XFile.saveTo` 保存。
- Web 或无文件系统平台将自动回退为提示（后续可扩展）。

## 兼容与扩展

- 初期支持 `line/bar/scatter/pie` 四类图表；后续可扩展 area、stacked area、box、heatmap 等。
- `axis` 当前用于决定是否绘制坐标轴与标题，精细化样式可按需拓展。
- `options.transpose` 仅影响条形图坐标系转置（后续扩展到其他图形）。

