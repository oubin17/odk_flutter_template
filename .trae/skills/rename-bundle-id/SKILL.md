---
name: "rename-bundle-id"
description: "重命名项目包名/Bundle ID。Invoke when user says '重命名包名', '修改包名', 'rename bundle id', '更换包名', '新项目包名', or mentions changing the bundle id/package name."
---

# Rename Bundle ID Skill

## 功能

基于模板创建新项目时，一键替换所有平台的包名/Bundle ID。

## 触发词

- 重命名包名
- 修改包名
- rename bundle id
- 更换包名
- 新项目包名
- 改包名

## 执行流程

### 1. 确认当前包名

从以下文件中提取当前包名：

**Android:**
- `android/app/build.gradle.kts` 中的 `namespace` 或 `applicationId`

**iOS:**
- `ios/Runner.xcodeproj/project.pbxproj` 中的 `PRODUCT_BUNDLE_IDENTIFIER`

### 2. 询问新包名

向用户询问新的包名，格式如：`com.company.appname`

### 3. 执行替换

运行重命名脚本：

```bash
chmod +x scripts/rename_bundle_id.sh
./scripts/rename_bundle_id.sh <旧包名> <新包名>
```

### 4. 执行后续步骤

替换完成后，自动执行以下命令：

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### 5. 提示用户手动操作

告知用户需要在 Xcode 中重新配置签名（Team + Bundle ID）。

## 示例对话

**用户：** 基于模板创建新项目，包名改成 com.mycompany.myapp

**AI：**
1. 检测到当前包名：`com.example.lushiApp`
2. 确认新包名：`com.mycompany.myapp`
3. 执行替换脚本...
4. 执行 `flutter clean` 和 `flutter pub get`...
5. 执行 iOS pod install...
6. ✅ 包名替换完成！

**注意：** 请在 Xcode 中重新配置签名（选择你的 Team 并确认 Bundle ID）。

## 注意事项

- 包名格式必须为反向域名格式：`com.company.appname`
- 包名只能包含小写字母、数字和下划线
- 执行前确保没有未提交的重要更改（脚本会修改多个文件）
- iOS 签名需要在 Xcode 中手动配置