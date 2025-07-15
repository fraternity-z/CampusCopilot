# GitHub Actions 工作流指南

本文档详细介绍 AnywhereChat 项目的 GitHub Actions 工作流配置和使用方法。

## 🔄 工作流概览

### 1. 多平台构建和发布 (`multi-platform-build.yml`)

**用途**: 生产环境的多平台构建和自动发布

**触发方式**: 
- 仅手动触发 (workflow_dispatch)
- 不支持自动触发，确保发布的可控性

**构建平台**:
- ❌ **Windows**: 暂时移除（文件锁定问题）
- ✅ **Android**: Release APK + Debug APK
- ⚠️ **iOS**: 未签名构建 (开发阶段)

**输入参数**:
- `version_tag`: 版本标签 (可选，默认自动生成)
- `release_notes`: 发布说明 (可选)

**自动功能**:
- 生成基于时间的版本标签
- 创建 GitHub Release
- 上传所有构建产物
- 生成详细的发布说明

### 2. 快速构建测试 (`quick-build.yml`)

**用途**: 快速测试特定平台的构建状态

**触发方式**: 手动触发

**平台选择**:
- `android`: 仅构建 Android Debug APK
- `windows`: 仅构建 Windows Debug 版本
- `ios`: 仅构建 iOS Debug 版本 (无签名)
- `all`: 构建所有平台

**特点**:
- 快速反馈
- Debug 版本构建
- 适合开发阶段测试

### 3. 构建状态检查 (`build-check.yml`)

**用途**: 代码质量检查和构建验证

**触发条件**:
- Pull Request 到 main/develop 分支
- 手动触发

**检查内容**:
- 依赖冲突检查
- 代码分析 (`flutter analyze`)
- 代码格式检查 (`dart format`)
- 所有平台构建测试
- 构建状态汇总报告

### 4. 传统构建发布 (`build-and-release.yml`)

**用途**: 基于标签的传统发布流程

**触发条件**:
- 推送版本标签 (v*)
- 手动触发

**功能**: 兼容现有的标签发布流程

## 🚀 使用指南

### 生产环境发布

1. **进入 GitHub Actions 页面**
   - 导航到仓库的 Actions 标签页

2. **选择工作流**
   - 点击 "Multi-Platform Build and Release"

3. **配置构建参数**
   ```
   Version tag: v1.0.0 (可选，留空自动生成)
   Release notes: 本次更新的详细说明
   ```

4. **执行构建**
   - 点击 "Run workflow"
   - 等待构建完成 (约 15-30 分钟)

5. **检查结果**
   - 构建成功后自动创建 GitHub Release
   - 下载构建产物进行测试

### 开发阶段测试

1. **快速单平台测试**
   ```
   工作流: Quick Build Test
   平台选择: android/windows/ios/all
   ```

2. **PR 构建检查**
   ```
   自动触发: 提交 PR 时自动运行
   检查内容: 代码质量 + 构建测试
   ```

### 版本标签格式

**自动生成格式**:
```
v2024.01.15-build.1430
格式: v{YYYY.MM.DD}-build.{HHMM}
```

**手动指定格式**:
```
v1.0.0          # 正式版本
v1.0.0-beta.1   # 测试版本
v1.0.0-rc.1     # 候选版本
```

## 📦 构建产物

### Windows
- **状态**: ❌ 暂时移除
- **原因**: GitHub Actions中持续出现文件锁定问题
- **替代方案**: 本地构建 `flutter build windows --release`

### Android
- **Release APK**: `AnywhereChat-Android-Release-{version}.apk`
- **Debug APK**: `AnywhereChat-Android-Debug-{version}.apk`
- **要求**: Android 5.0 (API 21) 及以上

### iOS
- **状态**: 未签名构建
- **内容**: 构建状态信息和使用说明
- **限制**: 需要在 Xcode 中配置签名

## ⚙️ 技术规格

### 环境配置
```yaml
Flutter: 3.32.5 (stable)
Dart: 3.8.1 (随 Flutter 安装)
Java: 17 (Android 构建)
```

### 构建环境
- **Android**: Ubuntu Latest + Java 21
- **Windows**: ❌ 暂时移除
- **iOS**: macOS Latest

### 构建步骤
1. 检出代码
2. 设置 Flutter 环境
3. 安装依赖 (`flutter pub get`)
4. 生成代码 (`dart run build_runner build`)
5. 执行平台构建
6. 打包和上传

## 🔧 故障排除

### 常见问题

#### 1. Flutter 版本不匹配
```yaml
# 确保工作流使用正确版本
flutter-version: '3.32.5'
channel: 'stable'
```

#### 2. 代码生成失败
```bash
# 本地测试命令
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Android 构建失败
- 检查 Java 版本 (必须是 17)
- 验证 `android/` 目录配置
- 查看 Gradle 构建日志

#### 4. Windows 构建失败
- 检查 Windows SDK 安装
- 验证 Visual Studio 组件
- 查看 MSBuild 输出

#### 5. iOS 构建失败
- 正常现象 (无签名配置)
- 需要在 Xcode 中手动配置签名
- 检查 iOS 部署目标版本

### 调试步骤

1. **查看构建日志**
   - 点击失败的工作流
   - 展开具体步骤查看错误信息

2. **本地复现**
   ```bash
   # 使用相同的 Flutter 版本
   flutter version 3.32.5
   
   # 清理并重新构建
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   
   # 测试构建
   flutter build apk --debug
   flutter build windows --debug
   ```

3. **检查依赖**
   ```bash
   flutter doctor -v
   flutter pub deps
   flutter analyze
   ```

## 📊 性能优化

### 构建时间优化
- 使用 GitHub Actions 缓存
- 并行构建多个平台
- 优化依赖安装过程

### 资源使用优化
- 合理设置超时时间
- 清理临时文件
- 优化构建产物大小

## 🔒 安全考虑

### 权限管理
- 工作流仅使用必要权限
- 不存储敏感信息在代码中
- 使用 GitHub Secrets 管理密钥

### 构建安全
- 跳过代码签名 (开发阶段)
- 验证构建产物完整性
- 限制工作流触发条件

## 📈 监控和维护

### 定期检查
- 监控构建成功率
- 检查构建时间趋势
- 更新依赖版本

### 维护任务
- 定期更新 Flutter 版本
- 检查 GitHub Actions 版本
- 优化工作流配置

---

*最后更新: 2024年*
