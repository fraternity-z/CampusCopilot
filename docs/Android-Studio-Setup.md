# 📱 在Android Studio虚拟机上运行AI Assistant

本指南将教您如何在Android Studio的Android虚拟机（AVD）上运行AI Assistant Flutter应用。

## 🛠️ 环境准备

### 1. 安装必要软件

确保您已经安装：
- ✅ **Android Studio** (最新版本)
- ✅ **Flutter SDK** 
- ✅ **Dart SDK** (通常包含在Flutter中)

### 2. 配置Flutter环境

检查Flutter环境是否正确配置：

```bash
# 检查Flutter环境
flutter doctor

# 如果有问题，按照提示修复
flutter doctor --android-licenses  # 接受Android许可证
```

### 3. 创建Android虚拟设备 (AVD)

#### 方法一：通过Android Studio界面

1. **打开Android Studio**
2. **点击 "More Actions" → "Virtual Device Manager"**
3. **点击 "Create Device"**
4. **选择设备型号**（推荐：Pixel 7 或 Pixel 6）
5. **选择系统镜像**：
   - 推荐：**API 34 (Android 14)** 或 **API 33 (Android 13)**
   - 如果首次使用，点击 "Download" 下载系统镜像
6. **配置AVD设置**：
   - RAM: 建议4GB或更多
   - VM heap: 512MB
   - Internal Storage: 8GB
   - SD Card: 1GB (可选)
7. **点击 "Finish" 创建**

#### 方法二：通过命令行

```bash
# 列出可用的系统镜像
flutter emulators

# 创建AVD (如果没有)
flutter emulators --create --name flutter_emulator

# 启动模拟器
flutter emulators --launch flutter_emulator
```

## 🚀 运行AI Assistant应用

### 步骤1：启动虚拟机

```bash
# 启动模拟器
flutter emulators --launch <模拟器名称>

# 或者在Android Studio中点击AVD旁边的播放按钮
```

### 步骤2：准备项目

```bash
# 进入项目目录
cd /e:/code/Anywherechat

# 获取依赖
flutter pub get

# 生成必要的代码（如果有）
flutter packages pub run build_runner build
```

### 步骤3：运行应用

```bash
# 检查连接的设备
flutter devices

# 运行应用（调试模式）
flutter run

# 或者指定设备运行
flutter run -d <设备ID>
```

### 步骤4：或者通过Android Studio运行

1. **在Android Studio中打开项目**
2. **等待Gradle同步完成**
3. **确保模拟器正在运行**
4. **点击绿色播放按钮或按F5**

## 🔧 常见问题解决

### 问题1：模拟器启动失败

```bash
# 检查HAXM是否安装（Intel CPU）
# 或检查Hyper-V设置（Windows）

# 在Android Studio中：
# Settings → Appearance & Behavior → System Settings → Android SDK → SDK Tools
# 确保 "Intel x86 Emulator Accelerator (HAXM installer)" 已勾选
```

### 问题2：Flutter无法识别设备

```bash
# 重启ADB服务
flutter doctor
adb kill-server
adb start-server

# 重新检查设备
flutter devices
```

### 问题3：构建错误

```bash
# 清理构建缓存
flutter clean
flutter pub get

# 重新构建
flutter run
```

### 问题4：Gradle同步失败

在 `android/gradle/wrapper/gradle-wrapper.properties` 中检查Gradle版本：
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
```

## ⚡ 性能优化建议

### 1. 模拟器性能设置

在AVD Manager中编辑虚拟设备：
- **Graphics**: Hardware - GLES 2.0
- **Boot Option**: Cold boot
- **Memory**: 增加RAM到4GB或更多

### 2. Flutter调试选项

```bash
# 热重载（开发时很有用）
# 在应用运行时按 'r' 键进行热重载
# 按 'R' 键进行完全重启

# 性能模式运行
flutter run --release

# 调试信息
flutter run --verbose
```

### 3. Android Studio设置

1. **File → Settings → Build → Compiler**
   - 增加 "Build process heap size" 到 2048 MB

2. **File → Settings → Languages & Frameworks → Flutter**
   - 启用 "Perform hot reload on save"

## 📱 应用功能测试

启动应用后，您可以测试以下功能：

### 基本功能：
- ✅ 启动画面显示
- ✅ 主界面加载
- ✅ 导航功能
- ✅ 设置页面

### AI功能（需要配置API密钥）：
- ✅ AI对话功能
- ✅ 不同AI供应商切换
- ✅ 知识库功能

### 平台特性：
- ✅ 文件选择器
- ✅ 图片选择
- ✅ 本地存储
- ✅ 网络请求

## 🐛 调试技巧

### 1. 查看日志

```bash
# 实时查看应用日志
flutter logs

# 或在Android Studio的Run窗口查看日志
```

### 2. 调试工具

```bash
# 打开Flutter DevTools
flutter run --web-browser-flag "--disable-web-security"
# 然后打开显示的DevTools URL
```

### 3. 性能分析

- 在DevTools中使用Performance标签页
- 检查内存使用情况
- 分析渲染性能

## 🎉 成功运行标志

当应用成功运行时，您应该看到：

1. **启动画面**：显示AI Assistant图标
2. **主界面**：包含导航和主要功能区域
3. **流畅的动画**：无卡顿的界面切换
4. **响应式布局**：适配不同屏幕尺寸

## 📞 获取帮助

如果遇到问题：

1. **查看Flutter日志**：`flutter logs`
2. **检查环境**：`flutter doctor`
3. **重置环境**：`flutter clean && flutter pub get`
4. **查看文档**：[Flutter官方文档](https://flutter.dev/docs)

现在您可以开始在Android虚拟机上体验AI Assistant应用了！🚀 