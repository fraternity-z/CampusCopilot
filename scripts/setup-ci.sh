#!/bin/bash

# AI Assistant CI/CD 快速设置脚本
# 运行此脚本可帮助您快速配置CI/CD环境

set -e

echo "🚀 AI Assistant CI/CD 快速设置向导"
echo "================================="

# 检查是否在项目根目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 错误: 请在Flutter项目根目录运行此脚本"
    exit 1
fi

echo "✅ 项目环境检查通过"

# 创建必要的目录
echo "📁 创建必要的目录结构..."
mkdir -p .github/workflows
mkdir -p docs
mkdir -p scripts
mkdir -p android/app

echo "✅ 目录结构创建完成"

# 检查keystore文件
if [ ! -f "android/app/upload-keystore.jks" ]; then
    echo ""
    echo "🔐 Android签名配置"
    echo "=================="
    echo "未找到签名密钥文件，是否需要生成新的keystore? (y/n)"
    read -r generate_keystore
    
    if [ "$generate_keystore" = "y" ]; then
        echo "请输入keystore信息:"
        read -p "别名 (alias): " keystore_alias
        read -s -p "keystore密码: " keystore_password
        echo
        read -s -p "密钥密码: " key_password
        echo
        
        # 生成keystore
        keytool -genkey -v -keystore android/app/upload-keystore.jks \
                -keyalg RSA -keysize 2048 -validity 10000 \
                -alias "$keystore_alias" \
                -storepass "$keystore_password" \
                -keypass "$key_password"
        
        echo "✅ Keystore文件已生成: android/app/upload-keystore.jks"
        
        # 生成Base64编码
        if command -v base64 >/dev/null 2>&1; then
            echo "📋 生成GitHub Secrets所需的Base64编码..."
            base64 -i android/app/upload-keystore.jks > keystore-base64.txt
            echo "✅ Base64编码已保存到: keystore-base64.txt"
            echo "请将此文件内容添加到GitHub Secrets: ANDROID_KEYSTORE_BASE64"
        fi
        
        # 创建key.properties模板
        cat > android/key.properties.example << EOF
storePassword=$keystore_password
keyPassword=$key_password
keyAlias=$keystore_alias
storeFile=upload-keystore.jks
EOF
        echo "✅ 已创建key.properties示例文件"
        
        echo ""
        echo "🔑 请在GitHub仓库中添加以下Secrets:"
        echo "ANDROID_KEYSTORE_BASE64 = (keystore-base64.txt的内容)"
        echo "KEYSTORE_PASSWORD = $keystore_password"
        echo "KEY_ALIAS = $keystore_alias" 
        echo "KEY_PASSWORD = $key_password"
    fi
fi

# Flutter版本检查
echo ""
echo "🔧 Flutter环境检查"
echo "=================="
if command -v flutter >/dev/null 2>&1; then
    flutter_version=$(flutter --version | head -n 1 | awk '{print $2}')
    echo "✅ 检测到Flutter版本: $flutter_version"
    
    echo "是否使用此版本更新工作流配置? (y/n)"
    read -r update_flutter_version
    
    if [ "$update_flutter_version" = "y" ]; then
        # 更新工作流文件中的Flutter版本
        if [ -f ".github/workflows/build-and-release.yml" ]; then
            sed -i.bak "s/FLUTTER_VERSION: '[^']*'/FLUTTER_VERSION: '$flutter_version'/" .github/workflows/build-and-release.yml
            echo "✅ 已更新发布工作流的Flutter版本"
        fi
        
        if [ -f ".github/workflows/pr-build.yml" ]; then
            sed -i.bak "s/FLUTTER_VERSION: '[^']*'/FLUTTER_VERSION: '$flutter_version'/" .github/workflows/pr-build.yml
            echo "✅ 已更新CI工作流的Flutter版本"
        fi
        
        if [ -f ".github/workflows/signed-build.yml" ]; then
            sed -i.bak "s/FLUTTER_VERSION: '[^']*'/FLUTTER_VERSION: '$flutter_version'/" .github/workflows/signed-build.yml
            echo "✅ 已更新签名构建工作流的Flutter版本"
        fi
    fi
else
    echo "⚠️  未检测到Flutter，请先安装Flutter SDK"
fi

# 权限设置
echo ""
echo "⚙️  设置文件权限..."
chmod +x scripts/*.sh 2>/dev/null || true

echo ""
echo "🎉 CI/CD环境设置完成!"
echo "==================="
echo ""
echo "下一步操作:"
echo "1. 提交工作流文件到GitHub仓库"
echo "2. 在GitHub仓库设置中配置Secrets"
echo "3. 创建版本标签测试自动发布:"
echo "   git tag v1.0.0"
echo "   git push origin v1.0.0"
echo ""
echo "详细说明请查看: docs/CI-CD-Guide.md"
echo ""
echo "如有问题，请查看工作流文档或提交Issue 🤝" 