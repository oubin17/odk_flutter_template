---
name: "rename-bundle-id"
description: "重命名项目包名/Bundle ID。Invoke when user says '重命名包名', '修改包名', 'rename bundle id', '更换包名', '新项目包名', or mentions changing the bundle id/package name."
---

# Rename Bundle ID Skill

## 功能

基于模板创建新项目时，一键替换：
1. **项目名称**（pubspec.yaml name、Dart 导入路径、Web 显示名称）
2. **Bundle ID/包名**（iOS/Android/macOS/Linux/Windows）

## 触发词

- 重命名包名
- 修改包名
- rename bundle id
- 更换包名
- 新项目包名
- 改包名
- 新项目

## 执行流程

### 1. 询问用户信息

向用户询问以下信息：

| 信息 | 格式 | 示例 |
|------|------|------|
| **新项目名称** | snake_case（下划线分隔） | `my_flutter_app` |
| **新 Bundle ID** | 反向域名格式 | `com.mycompany.myapp` |
| **新显示名称**（可选） | 人类可读名称 | `My Flutter App` |

**询问模板：**
```
请提供以下信息：
1. 新项目名称（snake_case，如 my_flutter_app）
2. 新 Bundle ID（如 com.mycompany.myapp）
3. 新显示名称（可选，如 My Flutter App，不提供则从项目名自动转换）
```

### 2. 检测当前信息

从项目中提取当前信息：

**当前项目名称：**
- `pubspec.yaml` 中的 `name` 字段

**当前 Bundle ID：**
- Android: `android/app/build.gradle.kts` 中的 `namespace`
- iOS: `ios/Runner.xcodeproj/project.pbxproj` 中的 `PRODUCT_BUNDLE_IDENTIFIER`

**当前显示名称：**
- `lib/l10n/app_en.arb` 中的 `appTitle`

### 3. 执行替换

按顺序执行以下脚本：

```bash
# 1. 替换项目名称
chmod +x scripts/rename_project_name.sh
./scripts/rename_project_name.sh <新项目名称> "<新显示名称>"

# 2. 替换 Bundle ID
chmod +x scripts/rename_bundle_id.sh
./scripts/rename_bundle_id.sh <旧Bundle ID> <新Bundle ID>
```

### 4. 执行后续步骤

替换完成后，自动执行：

```bash
flutter clean
flutter pub get
flutter gen-l10n
cd ios && pod install && cd ..
```

### 5. 提示用户手动操作

告知用户需要在 Xcode 中重新配置签名（Team + Bundle ID）。

## 示例对话

**用户：** 基于模板创建新项目，项目名 my_app，Bundle ID com.mycompany.myapp

**AI：**
检测到当前信息：
- 项目名称: `odk_flutter_template`
- Bundle ID: `com.example.lushiApp`
- 显示名称: `ODK Flutter Template`

确认替换为：
- 项目名称: `my_app`
- Bundle ID: `com.mycompany.myapp`
- 显示名称: `My App`（自动转换）

正在执行替换...

✅ 项目名称替换完成
✅ Bundle ID 替换完成
✅ flutter clean
✅ flutter pub get
✅ flutter gen-l10n
✅ iOS pod install

**全部替换完成！请在 Xcode 中重新配置签名（选择你的 Team 并确认 Bundle ID）。**

## 注意事项

- 项目名称只能包含小写字母、数字和下划线（snake_case）
- Bundle ID 格式必须为反向域名格式：`com.company.appname`
- Bundle ID 只能包含小写字母、数字和下划线
- 执行前确保没有未提交的重要更改（脚本会修改大量文件）
- iOS 签名需要在 Xcode 中手动配置