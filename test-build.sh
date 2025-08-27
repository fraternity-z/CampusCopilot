#!/bin/bash

echo "🔍 测试构建修复效果..."

# 检查Flutter环境
echo "=== Flutter环境检查 ==="
flutter --version
flutter doctor -v

# 清理并重新获取依赖
echo "=== 清理环境 ==="
flutter clean
flutter pub get

# 生成代码
echo "=== 生成代码 ==="
dart run build_runner build --delete-conflicting-outputs

# 检查Android构建
echo "=== Android构建测试 ==="
cd android
./gradlew --version || echo "Gradle版本检查失败"
cd ..

echo "=== 尝试Android APK构建 ==="
flutter build apk --release --dart-define=flutter.inspector.structuredErrors=false --target-platform android-arm64,android-arm || echo "Android构建失败"

# 如果是macOS，测试iOS构建  
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "=== 尝试iOS构建 ==="
    flutter build ios --release --no-codesign --dart-define=flutter.inspector.structuredErrors=false --target-platform ios-arm64 || echo "iOS构建失败"
fi

echo "✅ 构建测试完成"