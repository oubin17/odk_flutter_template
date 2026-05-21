import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ====================== 签名配置 ======================
// 从 key.properties 文件读取签名信息（该文件已在 .gitignore 中排除，不会提交到仓库）
// 发布前请创建 android/key.properties 文件，内容格式如下：
// storePassword=你的密钥库密码
// keyPassword=你的密钥密码
// keyAlias=你的密钥别名
// storeFile=你的密钥库文件路径（相对于 android/app 目录，如 ../../keystore/release.jks）
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.odk_flutter_template"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ====================== 签名配置 ======================
    signingConfigs {
        // Release 签名配置（从 key.properties 读取）
        // 如果 key.properties 不存在，则使用 debug 签名（开发阶段）
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.odk_flutter_template"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // 🔥 使用 release 签名配置（如果 key.properties 存在）
            // 如果 key.properties 不存在，回退到 debug 签名（仅限开发调试）
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // 开发阶段没有 key.properties 时使用 debug 签名
                // ⚠️ 发布到应用市场前必须创建 key.properties 并配置正式签名！
                signingConfigs.getByName("debug")
            }

            // 开启代码混淆和压缩（发布时建议开启）
            isMinifyEnabled = false
            // 开启资源压缩
            isShrinkResources = false
            // ProGuard 规则文件
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
