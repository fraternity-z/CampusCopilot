@echo off
REM Android构建测试脚本 (Windows版本)
REM 用于测试和诊断Android构建问题

echo 🔍 Android构建测试脚本
echo ========================

REM 检查环境
echo 📋 检查环境...
echo Java版本:
java -version
echo JAVA_HOME: %JAVA_HOME%

echo Flutter版本:
flutter --version

REM 设置环境变量
set JAVA_OPTS=-Xmx2G
set GRADLE_OPTS=-Dorg.gradle.daemon=false

echo 环境变量:
echo JAVA_OPTS=%JAVA_OPTS%
echo GRADLE_OPTS=%GRADLE_OPTS%

REM 进入Android目录
cd android

echo 🔧 检查Gradle配置...
if exist gradlew.bat (
    echo ✅ gradlew.bat文件存在
    
    echo 测试Gradle版本:
    gradlew.bat --version
    
    echo 测试Gradle任务:
    gradlew.bat help --quiet
) else (
    echo ❌ gradlew.bat文件不存在
    exit /b 1
)

REM 返回项目根目录
cd ..

echo 🧹 清理项目...
flutter clean

echo 📦 获取依赖...
flutter pub get

echo 🔨 开始构建测试...
flutter build apk --release --verbose

echo ✅ 构建测试完成
echo 📦 检查构建产物:
dir build\app\outputs\flutter-apk\

echo 🎉 测试成功完成！ 