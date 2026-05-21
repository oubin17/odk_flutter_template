# Android 签名配置指南

## 📌 为什么需要签名配置？

Android 应用发布到应用市场（Google Play、华为、小米等）时，**必须使用正式的 release 签名**，不能使用 debug 签名。否则：
- Google Play 会拒绝上传
- 国内应用市场会拒绝审核
- 用户无法覆盖安装

## 🔧 配置步骤

### 1. 生成签名密钥

```bash
# 在项目根目录下创建 keystore 目录
mkdir -p keystore

# 生成签名密钥（有效期建议 25 年以上）
keytool -genkey -v -keystore keystore/release.jks \
  -keyalg RSA -keysize 2048 -validity 9125 \
  -alias release
```

按提示输入：
- 密钥库密码（storePassword）
- 密钥密码（keyPassword）
- 姓名、组织等信息

### 2. 创建 key.properties 文件

在 `android/` 目录下创建 `key.properties` 文件：

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=release
storeFile=../../keystore/release.jks
```

> ⚠️ **重要**：`key.properties` 已在 `.gitignore` 中排除，**不会被提交到 Git 仓库**，请妥善保管密码信息。

### 3. 验证签名配置

```bash
# 构建 release APK
flutter build apk --release

# 构建 App Bundle（Google Play 推荐）
flutter build appbundle --release

# 验证 APK 签名信息
keytool -printcert -jarin build/app/outputs/flutter-apk/app-release.apk
```

### 4. CI/CD 环境配置

在 CI/CD 环境中，建议通过环境变量传递签名信息：

```bash
# 在 CI/CD 中创建 key.properties
echo "storePassword=$STORE_PASSWORD" > android/key.properties
echo "keyPassword=$KEY_PASSWORD" >> android/key.properties
echo "keyAlias=release" >> android/key.properties
echo "storeFile=../../keystore/release.jks" >> android/key.properties
```

## 🔒 安全注意事项

1. **绝对不要**将 `key.properties` 和 `.jks` 文件提交到 Git 仓库
2. **备份密钥文件**：丢失密钥将无法更新应用！
3. **记录密码**：建议使用密码管理器保存密钥密码
4. **密钥有效期**：建议设置 25 年以上（9125 天），避免过期后无法更新应用

## 📁 文件结构

```
odk_flutter_template/
├── android/
│   ├── key.properties          ← 签名配置（已 gitignore）
│   ├── app/
│   │   └── build.gradle.kts    ← 自动读取 key.properties
│   └── ...
├── keystore/
│   └── release.jks             ← 签名密钥文件（已 gitignore）
└── ...
```

## ❓ 常见问题

### Q: 开发时没有 key.properties 会怎样？
A: 开发阶段如果没有 `key.properties` 文件，构建会自动回退到 debug 签名，不影响日常开发调试。

### Q: 如何查看已有密钥的信息？
```bash
keytool -list -v -keystore keystore/release.jks -alias release
```

### Q: 密钥忘记了怎么办？
A: 无法找回。只能重新生成密钥，但需要更换包名才能发布新应用。所以**务必备份密钥和密码**！
