# 网络配置说明

## 开发环境配置指南

### 1. iOS 模拟器
```dart
// 使用 localhost（推荐）
static const String baseUrl = 'http://localhost:8080/odk-base-template/api';

// 或者使用 Mac 的实际 IP 地址
static const String baseUrl = 'http://192.168.x.x:8080/odk-base-template/api';
```

**注意：** iOS 模拟器中 `127.0.0.1` 指的是模拟器本身，不是你的 Mac！

### 2. Android 模拟器
```dart
// Android 模拟器必须使用 10.0.2.2
static const String baseUrl = 'http://10.0.2.2:8080/odk-base-template/api';
```

### 3. iOS/Android 真机
```dart
// 使用 Mac 的局域网 IP 地址（确保手机和电脑在同一 WiFi 网络）
static const String baseUrl = 'http://192.168.x.x:8080/odk-base-template/api';
```

**获取 Mac IP 地址的方法：**
```bash
# 在终端运行
ipconfig getifaddr en0
```

### 4. Web 浏览器
```dart
// 使用 localhost
static const String baseUrl = 'http://localhost:8080/odk-base-template/api';
```

### 5. macOS 桌面应用
```dart
// 使用 localhost
static const String baseUrl = 'http://localhost:8080/odk-base-template/api';
```

---

## 快速切换方案

### 方案 A：根据运行平台自动切换
在代码中使用条件判断：
```dart
import 'dart:io' show Platform;

class BaseConstants {
  static String get baseUrl {
    if (Platform.isIOS) {
      return 'http://localhost:8080/odk-base-template/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/odk-base-template/api';
    } else {
      return 'http://localhost:8080/odk-base-template/api';
    }
  }
}
```

### 方案 B：使用环境变量或配置文件
创建不同的配置文件：
- `base_constants_dev.dart` - 开发环境
- `base_constants_prod.dart` - 生产环境

---

## 常见问题排查

### 问题 1: Connection failed
**原因：** 使用了错误的地址
**解决：** 
- iOS 模拟器改用 `localhost`
- Android 模拟器改用 `10.0.2.2`

### 问题 2: 真机调试无法连接
**原因：** 
- 手机和电脑不在同一网络
- 防火墙阻止连接
**解决：**
1. 确保手机和 Mac 连接同一 WiFi
2. 关闭 Mac 的防火墙或添加例外
3. 使用 Mac 的局域网 IP 地址

### 问题 3: 后端服务未启动
**检查：**
```bash
# 测试后端是否可访问
curl http://localhost:8080/odk-base-template/api
```

---

## 当前配置
文件位置：`lib/core/constants/base_constants.dart`

```dart
static const String baseUrl = 'http://localhost:8080/odk-base-template/api';
```

适用于：iOS 模拟器、macOS 桌面应用、Web 浏览器
