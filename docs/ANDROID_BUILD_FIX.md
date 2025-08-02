# Android构建问题修复文档

## 🔍 问题描述

在GitHub Actions中构建Android APK时出现以下错误：
- `Unrecognized option: -q`
- `Could not create the Java Virtual Machine`
- `Unrecognized option: --full-stacktrace`

## 🎯 根本原因

1. **Gradle版本过旧**：Gradle 8.15版本不支持Flutter 3.32.5的新参数
2. **JVM参数冲突**：内存分配过大（4G）在CI环境中不稳定
3. **版本兼容性问题**：Gradle、Android Gradle Plugin和Flutter版本不匹配

## 🛠️ 修复方案

### 1. 升级Gradle版本
```properties
# android/gradle/wrapper/gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.25-all.zip
```

### 2. 升级Android Gradle Plugin
```kotlin
// android/settings.gradle.kts
id("com.android.application") version "8.8.0" apply false
```

### 3. 优化JVM参数配置
```properties
# android/gradle.properties
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:+UseStringDeduplication
org.gradle.daemon=false
```

### 4. 更新GitHub Actions工作流
- 减少内存分配：4G → 2G
- 禁用Gradle daemon
- 添加环境变量和超时保护
- 升级所有Gradle相关引用到8.25版本

## 📋 修复文件列表

1. `android/gradle/wrapper/gradle-wrapper.properties` - 升级Gradle版本
2. `android/settings.gradle.kts` - 升级AGP版本
3. `android/gradle.properties` - 优化JVM参数
4. `.github/workflows/build-and-release.yml` - 更新CI配置
5. `scripts/test-android-build.sh` - 添加测试脚本
6. `scripts/test-android-build.bat` - 添加Windows测试脚本

## ✅ 验证结果

运行 `flutter analyze --suggestions` 确认：
- ✅ Gradle版本兼容性检查通过
- ✅ Android Gradle Plugin版本兼容
- ✅ 无版本冲突警告

## 🚀 使用方法

### 本地测试
```bash
# Linux/macOS
./scripts/test-android-build.sh

# Windows
scripts\test-android-build.bat
```

### 云端构建
推送代码到GitHub，工作流会自动使用新的配置进行构建。

## 📊 性能优化

- **内存使用**：从4G减少到2G，提高CI环境稳定性
- **构建速度**：启用并行构建和缓存
- **错误处理**：添加详细的诊断信息和超时保护

## 🔧 故障排除

如果仍然遇到问题：

1. 检查Flutter版本兼容性：`flutter doctor -v`
2. 验证Gradle配置：`cd android && ./gradlew --version`
3. 查看详细构建日志：`flutter build apk --verbose`
4. 清理缓存：`flutter clean && flutter pub get`

## 📝 注意事项

- 确保本地开发环境也使用相同的Gradle版本
- 如果本地构建成功但云端失败，检查CI环境的内存限制
- 定期更新Flutter和相关工具链以保持兼容性 