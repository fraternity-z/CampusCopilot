# 应用图标更新指南

本指南说明如何更新AnywhereChat应用的图标。

## 📱 图标要求

### 图标规格
- **格式**: PNG
- **尺寸**: 1024x1024 像素（推荐）
- **背景**: 透明或纯色
- **内容**: 清晰、简洁的图标设计

### 文件位置
- **源文件**: `assets/images/logo.png`
- **配置文件**: `pubspec.yaml`

## 🔧 更新步骤

### 1. 替换图标文件
将新的图标文件保存为 `assets/images/logo.png`，替换现有文件。

### 2. 生成平台图标
运行以下命令生成各平台的图标：

```bash
# 安装依赖（如果还没有安装）
flutter pub get

# 生成图标
flutter pub run flutter_launcher_icons:main
```

### 3. 验证生成结果
检查以下目录中的图标是否已更新：

#### Android
```
android/app/src/main/res/mipmap-hdpi/ic_launcher.png
android/app/src/main/res/mipmap-mdpi/ic_launcher.png
android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
```

#### iOS
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

#### Windows
```
windows/runner/resources/app_icon.ico
```

### 4. 测试图标
在各平台上构建和运行应用，确认图标显示正确：

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows
```

## ⚙️ 配置说明

### pubspec.yaml 配置
```yaml
flutter_launcher_icons:
  image_path: "assets/images/logo.png"
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/images/logo.png"
  windows:
    generate: true
    image_path: "assets/images/logo.png"
```

### MSIX 配置（Windows）
```yaml
msix_config:
  display_name: AnywhereChat
  publisher_display_name: AnywhereChat Team
  logo_path: assets/images/logo.png
```

## 🚨 注意事项

### 图标设计建议
- 保持简洁明了的设计
- 确保在小尺寸下仍然清晰可见
- 避免使用过多细节
- 考虑不同平台的设计规范

### 常见问题
1. **图标模糊**: 确保源图标分辨率足够高（1024x1024）
2. **背景问题**: iOS需要透明背景，Android会自动添加背景
3. **生成失败**: 检查图标文件路径和格式是否正确

### 平台特殊要求
- **iOS**: 需要透明背景，系统会自动添加圆角
- **Android**: 支持自适应图标，建议使用前景+背景设计
- **Windows**: 会自动生成ICO格式

## 🔄 自动化流程

图标更新后，CI/CD流程会自动使用新图标构建应用：

1. 提交图标更改到代码库
2. 触发GitHub Actions构建
3. 新构建的应用将包含更新后的图标

---

*最后更新: 2024年*
