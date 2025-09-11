# Flutter Web 预览方案（仅展示页面）

## 背景与目标
目标：在不实现业务功能的前提下，通过浏览器打开并“看到页面”（UI 预览即可）。

现状：项目已包含 `web/` 目录与 `index.html`，具备 Flutter Web 基础。代码中大量模块直接依赖 `dart:io`、本地数据库（Drift/SQLite、ObjectBox）、文件/路径 API、代理控制等，在 Web 环境不可用；若直接以 `lib/main.dart` 作为入口运行 Web，会因不兼容依赖而编译失败。

## 现状阻塞点
- 平台相关导入：`dart:io`（如 `lib/main.dart`、`lib/core/network/dio_client.dart`、`lib/data/local/app_database.dart` 等）。
- 本地数据库：`sqlite3_flutter_libs`、`drift/native`、ObjectBox 等默认实现依赖原生或文件系统，不适配 Web。
- 路由/全局初始化：现有 `main.dart` 启动流程中含路径/代理/缓存初始化，部分在 Web 上不可用或需替代实现。

## 方案一：独立 Web 预览入口（推荐，最小改动、最快见效）
### 技术原理
新建一个专用于 Web 预览的入口文件（例如 `lib/main_web_preview.dart`），只引入纯 Flutter UI（不引用任何 `dart:io`、数据库、网络代理适配等），通过 `--target` 指定为 Web 入口即可编译运行。这样能绕开现有不兼容依赖，快速在浏览器展示页面。

### 实施步骤
1. 启用 Web 支持并检查环境：
   - `flutter config --enable-web`
   - `flutter doctor -v`
2. 新建 `lib/main_web_preview.dart`（示例代码见“附录”），仅包含最小可运行的 `MaterialApp` 与若干无依赖的示例 Widget（可逐步加入需要预览的 UI）。
3. 本地运行（Chrome）：
   - `flutter run -d chrome -t lib/main_web_preview.dart`
4. 构建发布（可选）：
   - `flutter build web -t lib/main_web_preview.dart --release`
   - 若部署至子路径，追加 `--base-href /yourpath/`，`web/index.html` 的 `<base href="$FLUTTER_BASE_HREF">` 会自动替换。

### 优点
- 改动面最小，见效最快；
- 完全满足“只展示页面，不要功能实现”的目标；
- 不影响现有原生端/桌面端逻辑。

### 风险与限制
- 仅能预览不依赖平台能力的 UI；
- 若导入任意含 `dart:io`/数据库/代理等模块，会再次触发 Web 编译错误。

### 验收标准
- `flutter run -d chrome -t lib/main_web_preview.dart` 启动后页面可正常渲染，无平台相关报错；
- 可按需添加更多无依赖的 UI 页面进行预览。

## 方案二：条件化适配与抽象（中等工作量，可保留更多真实页面）
### 技术原理
对存储、网络、代理、路径、数据库等做接口抽象，使用条件导入为 Web/非 Web 分别提供实现：
- 数据库：将 `drift/native` 改为 `drift/web` 或 wasm 方案；ObjectBox 在 Web 不可用，需禁用或替代；
- 网络：`dio` 在 Web 使用 `BrowserHttpClientAdapter`；代理功能在 Web 端禁用为 no-op；
- 路径/文件：`path_provider` 与本地文件改为 Web 侧兜底（如内存/IndexedDB）；
- 启动：`main.dart` 通过 `kIsWeb` 或条件导入规避不可用流程。

### 实施步骤（概述）
1. 数据库拆分：`app_database_io.dart` 与 `app_database_web.dart`，条件导入选择实现；Web 侧启用 `drift/web.dart` 或 wasm；移除 `dart:io`。
2. 网络适配：为 Dio 设置浏览器适配器，移除 `HttpClient`、自定义代理配置的依赖；`proxy_service` 在 Web 侧降级为 no-op 实现。
3. 路径/文件：去除 `Directory`/`File` 调用，替换为 Web 可用存储；
4. 启动流程：`main.dart` 分支化，针对 Web 不做路径/代理初始化。

### 优点
- 可在 Web 端运行较完整的页面与路由，接近真实应用；

### 风险与限制
- 改造面广、依赖多，测试成本高；
- 第三方库兼容性需一一验证，可能需要部分功能在 Web 端禁用。

## 方案三：静态路由预览站点（介于一与二之间）
### 技术原理
在独立 Web 入口的基础上，挂一个简化版路由（`MaterialApp.router` 或 `Navigator`），把若干“无依赖的预览页面”纳入路由，形成可浏览的“UI 画廊”。

### 特点
- 仍不依赖平台能力；
- 可一次性预览多个页面与导航；
- 可渐进地把更多页面纳入预览（前提：移除平台依赖）。

## 推荐方案与理由
推荐采用“方案一：独立 Web 预览入口”。
- 理由：最小改动、最快上线 Web 预览、风险最低；完全满足“只显示页面”的需求；后续可平滑演进到方案三（加入静态路由画廊），若有需要再评估方案二的全量适配。

## 执行计划（最小路径）
1. 新建 `lib/main_web_preview.dart` 并写入最小示例；
2. 本地运行 `flutter run -d chrome -t lib/main_web_preview.dart` 验证；
3. （可选）添加 1～2 个无依赖页面做预览路由；
4. （可选）`flutter build web -t lib/main_web_preview.dart --release` 输出静态站点用于部署。

## 附录：独立 Web 预览入口最小示例
```dart
// lib/main_web_preview.dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: WebPreviewHome(),
));

class WebPreviewHome extends StatelessWidget {
  const WebPreviewHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Web 预览')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('这里只展示 UI，不接入存储/网络/代理'),
            SizedBox(height: 12),
            Text('可按需把无依赖的页面搬到这里预览'),
          ],
        ),
      ),
    );
  }
}
```

## 运行与构建命令
- 运行：`flutter run -d chrome -t lib/main_web_preview.dart`
- 构建：`flutter build web -t lib/main_web_preview.dart --release`
- 子路径部署：`flutter build web -t lib/main_web_preview.dart --release --base-href /yourpath/`

## 风险与兜底
- 如误引入平台相关依赖导致 Web 编译失败：删除该依赖或将其移动回原入口；
- 如需更复杂页面：采用方案三的静态路由预览，将页面逐步无依赖化后纳入；
- 两次以上执行失败：回退到仅保留最小示例入口，确保可运行，然后循序添加页面定位问题源头。

