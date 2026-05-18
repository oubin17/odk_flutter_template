# iOS 真机调试完整指南

## 一、前提条件

| 条件 | 说明 |
|------|------|
| Mac 电脑 | iOS 开发必须使用 Mac |
| Xcode | App Store 下载安装（免费） |
| Apple ID | 免费账号即可，无需付费开发者账号 |
| iPhone + USB 数据线 | 用于连接电脑 |

---

## 二、首次配置（只需做一次）

### 2.1 在 Xcode 中配置签名

1. **打开 Xcode 项目**
   - 在 Finder 中进入项目目录的 `ios` 文件夹
   - 找到 `Runner.xcworkspace`（⚠️ 不是 Runner.xcodeproj）
   - 右键 → 打开方式 → Xcode（或拖拽到 Dock 栏的 Xcode 图标上）

2. **找到 Runner Target**
   - 点击 Xcode 左侧最顶部的**蓝色 Runner 图标**（项目入口）
   - 中间区域上方会出现 **TARGETS** 列表
   - 点击 **Runner**（不是 RunnerTests）

3. **配置签名**
   - 点击顶部的 **Signing & Capabilities** 标签
   - ✅ 勾选 **Automatically manage signing**
   - **Team** 下拉选择你的 Apple ID
     - 如果没有，点击 Add Account，登录你的 Apple ID，选择 Personal Team
   - **Bundle Identifier** 改成唯一值（如 `com.odk.myapp`）
     - ⚠️ 不能用 `com.example.xxx`，否则签名会失败
   - 确认下方没有红色错误提示

4. **关闭 Xcode**（配置完成后不再需要）

### 2.2 在 iPhone 上开启开发者模式

> iOS 16+ 必须开启，否则无法真机调试

1. iPhone 打开 **设置 → 隐私与安全性**
2. 滚动到最底部，找到 **开发者模式**
3. 打开开关，按提示重启 iPhone
4. 重启后弹出确认弹窗，点击 **打开**

> 💡 如果找不到"开发者模式"，先把 iPhone 连着 Mac 并打开 Xcode 等几秒，再去设置里看

### 2.3 授权 Xcode 自动化权限

1. Mac 上打开 **系统设置 → 隐私与安全性 → 自动化**
2. 确保终端（Terminal）或 VSCode 勾选了 Xcode 的控制权限

---

## 三、日常真机调试

### 3.1 连接设备

1. 用 USB 数据线连接 iPhone 和 Mac
2. iPhone 弹出"信任此电脑？"→ 点击 **信任** 并输入密码

### 3.2 检查设备是否识别

```bash
flutter devices
```

应看到类似输出：
```
欧达克的 iPhone (mobile) • 00008140-001A00321EBB001C • ios • iOS 26.4.2
```

### 3.3 运行

```bash
# 开发环境
flutter run -t lib/main_dev.dart

# 指定设备（多个设备时）
flutter run -t lib/main_dev.dart -d <设备ID>
```

### 3.4 调试操作

| 操作 | 快捷键 |
|------|--------|
| Hot Reload（热重载） | 按 `r` |
| Hot Restart（热重启） | 按 `R` |
| 退出调试 | 按 `q` |
| 查看日志 | 终端实时输出 |

### 3.5 首次安装后信任开发者

首次运行成功后，如果 App 无法打开：

1. iPhone 上 **设置 → 通用 → VPN与设备管理**
2. 找到你的开发者证书
3. 点击 **信任**

---

## 四、常见问题

### Q1：断开调试后 App 无法打开？

**原因**：免费 Apple 开发者账号的 Debug 模式 App 必须依赖调试进程才能运行。

**解决**：
- 日常开发：保持 `flutter run` 状态，不要按 `q` 退出
- 需要独立运行：使用 Release 模式构建

```bash
flutter build ios --release -t lib/main_dev.dart
```

### Q2：网络请求超时？

**原因**：iPhone 和服务器不在同一局域网。

**解决**：
- 确保 iPhone 连的 WiFi 和服务器在同一网络
- 检查 `lib/config/env.dart` 中的 `serverUri` IP 是否正确
- 在 iPhone Safari 中访问服务器 IP 测试连通性

### Q3：签名失败（红色错误）？

**原因**：Bundle Identifier 不唯一。

**解决**：在 Xcode 中将 Bundle Identifier 改成唯一值（如 `com.你的名字.app名`）。

### Q4：7天后 App 过期？

**原因**：免费开发者账号的签名有效期只有 7 天。

**解决**：重新 `flutter run` 即可重新安装。如需长期使用，升级为付费开发者账号（$99/年）。

### Q5：黑屏 + "Dart VM Service was not discovered"？

**解决**：
1. 检查自动化权限：**系统设置 → 隐私与安全性 → 自动化**
2. 执行 `flutter clean` 后重新运行
3. 关闭 Xcode 后只用命令行运行

---

## 五、免费账号 vs 付费账号

| 功能 | 免费账号 | 付费账号（$99/年） |
|------|----------|---------------------|
| 真机调试 | ✅ | ✅ |
| Hot Reload | ✅ | ✅ |
| App 独立运行（断开调试） | ❌ Debug 模式不行 | ✅ |
| App 有效期 | 7 天 | 1 年 |
| 上架 App Store | ❌ | ✅ |
| 推送通知 | ❌ | ✅ |
| TestFlight 分发 | ❌ | ✅ |

---

## 六、修改包名/Bundle ID

如果需要修改项目的包名，使用项目自带的脚本：

```bash
# 修改 iOS/macOS Bundle ID 和 Android 包名
./scripts/rename_bundle_id.sh com.example.lushiApp com.你的名字.你的app名

# 如果 iOS 和 Android 包名不同
./scripts/rename_bundle_id.sh com.example.lushiApp com.你的名字.你的app名 com.example.odk_flutter_template com.你的名字.你的app名
```

执行后：
```bash
flutter clean
flutter run -t lib/main_dev.dart
```

> ⚠️ 修改包名后需要重新在 Xcode 中配置签名
