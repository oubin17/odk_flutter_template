# ODK Flutter Template

一个功能完善的 Flutter 应用模板，内置登录注册、网络请求、主题切换、多语言、版本更新等常用功能，帮助快速搭建生产级应用。

## ✨ 功能特性

- 🔐 **登录注册** — 手机号+验证码/密码登录，注册流程
- 🌐 **网络请求** — Dio 封装，统一拦截器、签名、异常处理
- 🎨 **主题切换** — 日间/夜间/跟随系统
- 🌍 **多语言** — 中文/英文，支持扩展
- 📦 **状态管理** — Provider + ChangeNotifier
- 🗺️ **路由管理** — GoRouter + 登录拦截
- 🔄 **版本更新** — 自动检查更新，跳转应用市场
- 📱 **屏幕适配** — flutter_screenutil
- 🔒 **安全存储** — flutter_secure_storage + SharedPreferences
- 📋 **隐私政策** — 首次启动弹窗（合规要求）
- 🖼️ **WebView** — 通用 WebView 页面，支持 JS 交互
- 🚀 **多环境** — dev/test/prod 环境配置

## 🚀 快速开始

### 1. 环境要求

- Flutter SDK >= 3.10.4
- Dart SDK >= 3.10.4
- Android Studio / VS Code
- Xcode (iOS 开发)

### 2. 克隆项目

```bash
git clone https://github.com/oubin17/odk_flutter_template.git
cd odk_flutter_template
flutter pub get
```

### 3. 运行项目

```bash
# 开发环境
flutter run -t lib/main_dev.dart

# 生产环境
flutter run -t lib/main.prod.dart
```

---

## ⚠️ 发布前必须操作

> **以下步骤是应用上架前的硬性要求，不完成将无法通过应用市场审核！**

### 🔴 1. 替换包名 / Bundle ID

当前项目使用示例包名 `com.example.odk_flutter_template`，**必须替换为你的正式包名**：

- `com.example.*` 包名会被 Google Play 拒绝
- 国内应用市场也会拒绝示例包名

```bash
# 使用项目提供的重命名脚本（推荐）
./scripts/rename_bundle_id.sh com.example.odk_flutter_template com.yourcompany.yourapp

# 手动替换需要修改的文件：
# - android/app/build.gradle.kts (applicationId, namespace)
# - android/app/src/main/AndroidManifest.xml (package)
# - ios/Runner.xcodeproj/project.pbxproj (PRODUCT_BUNDLE_IDENTIFIER)
# - android/app/src/main/kotlin/.../MainActivity.kt (package 声明)
```

替换后执行：
```bash
flutter clean
flutter pub get
cd ios && pod install  # iOS 需要
```

### 🔴 2. 配置 Android 签名

Release 构建必须使用正式签名，详见 👉 [Android 签名配置指南](docs/android_signing_guide.md)

```bash
# 1. 生成签名密钥
mkdir -p keystore
keytool -genkey -v -keystore keystore/release.jks \
  -keyalg RSA -keysize 2048 -validity 9125 -alias release

# 2. 创建 android/key.properties
echo "storePassword=你的密码" > android/key.properties
echo "keyPassword=你的密码" >> android/key.properties
echo "keyAlias=release" >> android/key.properties
echo "storeFile=../../keystore/release.jks" >> android/key.properties
```

### 🔴 3. 配置隐私政策 URL

在 `lib/config/env.dart` 中替换为你的隐私政策和用户协议地址：

```dart
static const String userAgreementUrl = 'https://your-domain.com/agreements/user_agreement.html';
static const String privacyPolicyUrl = 'https://your-domain.com/agreements/privacy_policy.html';
```

### 🔴 4. 配置服务器地址

在 `lib/config/env.dart` 中替换各环境的服务器地址：

```dart
const Map<String, String> prodVariables = {
  ...commonVariables,
  ConfigKey.serverUri: 'https://your-api-domain.com/api',
  ConfigKey.signSecret: 'your_prod_sign_secret',
};
```

### 🟡 5. 替换应用图标和启动屏

- 应用图标：替换 `assets/images/launcher_icon/launcher.png`，然后运行 `dart run flutter_launcher_icons`
- 启动屏：替换 `assets/logo.jpg`，然后运行 `dart run flutter_native_splash:create`
- iOS 启动屏：在 Xcode 中配置 `ios/Runner/Assets.xcassets/`

### 🟡 6. iOS 签名配置

1. 在 Xcode 中打开 `ios/Runner.xcworkspace`
2. 选择 Runner target → Signing & Capabilities
3. 选择你的 Team 和 Bundle Identifier
4. 确保 Provisioning Profile 有效

---

## 📁 项目结构

```
lib/
├── common/              # 全局信息、初始化、主题
├── config/              # 环境配置
├── core/                # 核心模块
│   ├── cache/           # 缓存
│   ├── constants/       # 常量
│   ├── network/         # 网络请求（Dio封装、拦截器、网络检查）
│   ├── session/         # 会话管理
│   ├── storage/         # 存储管理
│   └── utils/           # 工具类
├── features/            # 功能模块
│   ├── auth/            # 登录注册
│   ├── basic_user/      # 基础用户信息
│   ├── content/         # 内容模块
│   ├── home/            # 首页
│   ├── mine/            # 个人中心
│   └── system/          # 系统配置
├── gen/                 # 自动生成的代码（资源、字体）
├── l10n/                # 国际化文件
├── models/              # 数据模型
├── providers/           # 状态管理
├── routes/              # 路由配置
└── widgets/             # 通用组件
    ├── app_page/        # 页面组件
    ├── app_root/        # 根组件、隐私政策弹窗
    ├── app_status/      # 状态页面（空数据、错误等）
    ├── app_webview/     # WebView 组件
    ├── app_widgets/     # 通用 UI 组件
    ├── smart_dialog/    # 弹窗配置
    └── mixins/          # 通用 Mixin
```

## 📖 文档

| 文档 | 说明 |
|------|------|
| [Android 签名配置](docs/android_signing_guide.md) | Release 签名配置指南 |
| [网络配置](docs/network_config.md) | 网络请求配置说明 |
| [iOS 网络配置](docs/ios_network_config.md) | iOS 网络权限配置 |
| [iOS 调试指南](docs/ios_debug_guide.md) | iOS 调试相关 |
| [异常处理](docs/exception_handling.md) | 全局异常处理机制 |
| [新页面开发](docs/prompt_new_page.md) | 新页面开发规范 |

## 🔧 常用命令

```bash
# 代码生成（JSON序列化、资源文件等）
dart run build_runner build --delete-conflicting-outputs

# 国际化代码生成
flutter gen-l10n

# 生成应用图标
dart run flutter_launcher_icons

# 生成启动屏
dart run flutter_native_splash:create

# 移除启动屏
dart run flutter_native_splash:remove

# 构建 Release APK
flutter build apk --release

# 构建 App Bundle (Google Play)
flutter build appbundle --release

# 构建 iOS
flutter build ios --release
```

## 📄 License

MIT License
