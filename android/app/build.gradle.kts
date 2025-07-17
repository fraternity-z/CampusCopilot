plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ai_assistant"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // 修复NDK版本兼容性问题

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        // 启用增量编译
        incremental = true
    }

    kotlinOptions {
        jvmTarget = "21"  // 修复JVM目标兼容性问题
    }

    // 构建性能优化
    buildFeatures {
        buildConfig = true
    }

    // 打包优化
    packagingOptions {
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt"
            )
        }
    }

    defaultConfig {
        applicationId = "com.example.ai_assistant"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // 使用调试签名配置以便开发测试
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
