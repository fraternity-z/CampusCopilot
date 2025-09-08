plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ai_assistant"
    compileSdk = flutter.compileSdkVersion
    // 不强制指定 NDK 版本，避免 CI 无匹配 NDK 时失败
    // ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }


    // 构建性能优化
    buildFeatures {
        buildConfig = true
    }

    // 打包优化（AGP 8 使用 packaging）
    packaging {
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
        // 仅构建主流 ARM 架构，避免拉取不必要的系统镜像（如 MIPS/x86）
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a")
        }
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

// 指定 Kotlin 工具链为 JDK 21（Gradle/AGP 运行时），产物目标字节码 17 由 kotlinOptions 控制
kotlin {
    jvmToolchain(21)
}
