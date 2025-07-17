#!/bin/bash

# 初始化 Gradle Wrapper 脚本
# 用于在 CI/CD 环境中确保 Gradle Wrapper 正确设置

echo "🔧 初始化 Gradle Wrapper..."

# 检查是否已有 gradle-wrapper.jar
if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
    echo "📦 下载 gradle-wrapper.jar..."
    
    # 创建目录
    mkdir -p gradle/wrapper
    
    # 下载 gradle-wrapper.jar
    curl -L -o gradle/wrapper/gradle-wrapper.jar \
        "https://github.com/gradle/gradle/raw/v8.12.0/gradle/wrapper/gradle-wrapper.jar"
    
    if [ $? -eq 0 ]; then
        echo "✅ gradle-wrapper.jar 下载成功"
    else
        echo "❌ gradle-wrapper.jar 下载失败，尝试备用方法..."
        
        # 备用方法：使用系统 gradle 创建 wrapper
        if command -v gradle &> /dev/null; then
            echo "🔄 使用系统 gradle 创建 wrapper..."
            gradle wrapper --gradle-version 8.12
        else
            echo "⚠️ 无法创建 gradle wrapper，请手动处理"
            exit 1
        fi
    fi
else
    echo "✅ gradle-wrapper.jar 已存在"
fi

# 确保 gradlew 文件存在且有执行权限
if [ ! -f "gradlew" ]; then
    echo "❌ gradlew 文件不存在"
    exit 1
fi

# 设置执行权限（在 Unix 系统上）
if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" ]]; then
    chmod +x gradlew
    echo "✅ gradlew 执行权限已设置"
fi

# 测试 gradlew
echo "🧪 测试 gradlew..."
./gradlew --version

if [ $? -eq 0 ]; then
    echo "✅ Gradle Wrapper 初始化成功"
else
    echo "❌ Gradle Wrapper 测试失败"
    exit 1
fi
