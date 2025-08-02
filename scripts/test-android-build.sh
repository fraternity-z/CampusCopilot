#!/bin/bash

# Android构建测试脚本
# 用于测试和诊断Android构建问题

set -e

echo "🔍 Android构建测试脚本"
echo "========================"

# 检查环境
echo "📋 检查环境..."
echo "Java版本:"
java -version
echo "JAVA_HOME: $JAVA_HOME"

echo "Flutter版本:"
flutter --version

echo "系统资源:"
free -h 2>/dev/null || echo "无法获取内存信息"
df -h 2>/dev/null || echo "无法获取磁盘信息"

# 设置环境变量
export JAVA_OPTS="-Xmx2G"
export GRADLE_OPTS="-Dorg.gradle.daemon=false"

echo "环境变量:"
echo "JAVA_OPTS=$JAVA_OPTS"
echo "GRADLE_OPTS=$GRADLE_OPTS"

# 进入Android目录
cd android

echo "🔧 检查Gradle配置..."
if [ -f "gradlew" ]; then
    echo "✅ gradlew文件存在"
    chmod +x gradlew
    
    echo "测试Gradle版本:"
    ./gradlew --version
    
    echo "测试Gradle任务:"
    ./gradlew help --quiet
else
    echo "❌ gradlew文件不存在"
    exit 1
fi

# 返回项目根目录
cd ..

echo "🧹 清理项目..."
flutter clean

echo "📦 获取依赖..."
flutter pub get

echo "🔨 开始构建测试..."
flutter build apk --release --verbose

echo "✅ 构建测试完成"
echo "📦 检查构建产物:"
ls -la build/app/outputs/flutter-apk/

echo "🎉 测试成功完成！" 