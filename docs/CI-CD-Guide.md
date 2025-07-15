# 🚀 AnywhereChat CI/CD 工作流指南

本指南详细说明如何使用为AnywhereChat项目设置的GitHub Actions工作流，包括自动构建APK、IPA、EXE文件并发布release。

## 📋 工作流概览

我们为项目配置了一个主要的工作流：

### 🎯 构建并发布全平台应用 (build-and-release.yml)
- **触发条件**: 仅手动触发或推送版本标签 (v*.* 格式)
- **功能**: 构建所有平台的release版本并自动发布GitHub Release
- **支持平台**: Windows、Android、iOS
- **用途**: 正式版本发布

## 🛠️ 初始设置

### GitHub Secrets 配置

在GitHub仓库设置中添加以下Secrets（Settings → Secrets and variables → Actions）：

#### Android签名所需Secrets：
```
ANDROID_KEYSTORE_BASE64       # keystore文件的Base64编码
KEYSTORE_PASSWORD            # keystore密码
KEY_ALIAS                   # 密钥别名
KEY_PASSWORD                # 密钥密码
```

#### iOS签名所需Secrets（可选）：
```
IOS_CERTIFICATE_BASE64           # iOS开发证书的Base64编码
IOS_CERTIFICATE_PASSWORD         # 证书密码
IOS_PROVISIONING_PROFILE_BASE64  # Provisioning Profile的Base64编码
KEYCHAIN_PASSWORD               # Keychain密码
```

#### Google Play上传所需Secrets（可选）：
```
GOOGLE_PLAY_SERVICE_ACCOUNT     # Google Play Console服务账户JSON
```

### 如何生成Android签名密钥

1. **生成keystore文件**：
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **转换为Base64编码**：
```bash
# Linux/macOS
base64 -i upload-keystore.jks -o keystore-base64.txt

# Windows
certutil -encode upload-keystore.jks keystore-base64.txt
```

3. **将Base64内容添加到GitHub Secrets**

### 如何获取iOS签名证书

1. 在Apple Developer中心下载开发证书(.p12文件)
2. 下载对应的Provisioning Profile
3. 转换为Base64编码并添加到Secrets

## 🚀 使用方法

### 方式一：自动发布Release（推荐）

1. **创建版本标签**：
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. **自动触发**: 推送标签后会自动触发构建流程

3. **下载结果**: 在Repository的Releases页面查看和下载构建产物

### 方式二：手动触发发布

1. 进入GitHub仓库的Actions页面
2. 选择"构建并发布跨平台应用"工作流
3. 点击"Run workflow"
4. 输入版本号（如v1.0.1）
5. 点击运行

### 方式三：签名构建（生产环境）

1. 进入Actions页面
2. 选择"签名构建工作流"
3. 选择要构建的平台：
   - ✅ Android签名APK/AAB
   - ✅ iOS (需要签名配置)
   - ✅ Windows
   - ✅ 上传到应用商店
4. 点击运行

## 📁 构建产物说明

### Android平台
- **APK文件**: 
  - `ai-assistant-android-arm64.apk` (ARM64架构)
  - `ai-assistant-android-arm.apk` (ARM架构)
  - `ai-assistant-android-x64.apk` (x86_64架构)
- **AAB文件**: `ai-assistant-android.aab` (Google Play上传用)

### iOS平台
- **IPA文件**: `ai-assistant-ios.ipa`
- ⚠️ **注意**: 无签名版本仅供测试，正式发布需要开发者证书

### Windows平台
- **ZIP包**: `ai-assistant-windows.zip` (完整程序包)
- **MSIX包**: `ai-assistant-windows.msix` (Microsoft Store用)

## ⚡ 工作流特性

### 🔄 持续集成特性
- ✅ 代码格式检查
- ✅ 静态代码分析
- ✅ 单元测试执行
- ✅ 测试覆盖率报告
- ✅ 多平台兼容性测试

### 🎯 发布流程特性
- ✅ 自动版本标记
- ✅ 多平台并行构建
- ✅ 自动GitHub Release创建
- ✅ 构建产物自动上传
- ✅ 详细的Release说明

### ✍️ 签名构建特性
- ✅ 生产级签名配置
- ✅ 应用商店就绪文件
- ✅ 选择性平台构建
- ✅ 安全的密钥管理

## 🔧 自定义配置

### 修改Flutter版本
在工作流文件中修改`FLUTTER_VERSION`环境变量：
```yaml
env:
  FLUTTER_VERSION: '3.24.0'  # 修改为所需版本
```

### 修改构建选项
在相应的构建步骤中添加或修改Flutter构建参数：
```yaml
- name: 构建Android APK
  run: flutter build apk --release --split-per-abi --dart-define=FLAVOR=production
```

### 添加自定义步骤
可以在现有工作流中添加自定义构建步骤，例如：
```yaml
- name: 运行自定义脚本
  run: ./scripts/pre-build.sh
```

## 🐛 故障排除

### 常见问题

1. **Android构建失败**
   - 检查JDK版本（需要JDK 17）
   - 验证签名配置是否正确
   - 确认依赖是否完整

2. **iOS构建失败**
   - 确认运行在macOS runner上
   - 检查Xcode版本兼容性
   - 验证签名证书配置

3. **Windows构建失败**
   - 确认msix配置正确
   - 检查Windows特定依赖

4. **签名相关错误**
   - 验证Base64编码是否正确
   - 确认Secrets名称匹配
   - 检查密钥密码是否正确

### 调试方法

1. **查看构建日志**: 在Actions页面点击具体的工作流运行查看详细日志
2. **本地复现**: 使用相同的Flutter和JDK版本在本地尝试构建
3. **分步调试**: 注释掉部分构建步骤，逐步定位问题

## 📚 相关资源

- [Flutter官方CI/CD文档](https://docs.flutter.dev/deployment/ci)
- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Android应用签名指南](https://developer.android.com/studio/publish/app-signing)
- [iOS代码签名指南](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)

## 🎉 快速开始

1. **首次使用**:
   ```bash
   # 1. 配置必要的GitHub Secrets
   # 2. 提交代码到main分支测试CI
   git add .
   git commit -m "feat: 添加CI/CD工作流"
   git push origin main
   
   # 3. 创建首个版本发布
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **日常开发**:
   - 创建PR → 自动触发CI检查
   - 合并到main → 自动构建测试版本
   - 需要发布时 → 创建版本标签或手动触发

现在您已经拥有了一个完整的自动化构建和发布流程！🎊 