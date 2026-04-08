# 统一异常处理机制

## 📋 架构设计

### 分层职责

```
┌─────────────────────────────────────┐
│         UI/页面层                    │  ← 在这里统一处理异常并显示提示
│  - try-catch AppException           │
│  - 根据异常类型显示不同提示          │
└─────────────────────────────────────┘
              ↑
┌─────────────────────────────────────┐
│      Domain 层 (AuthService)        │  ← 不处理异常，直接透传
│  - 纯业务逻辑                        │
│  - 不捕获网络异常                    │
└─────────────────────────────────────┘
              ↑
┌─────────────────────────────────────┐
│       Data 层 (AuthApi)             │  ← 不处理异常，直接透传
│  - API 调用封装                      │
│  - 数据转换                          │
└─────────────────────────────────────┘
              ↑
┌─────────────────────────────────────┐
│    Network 层 (ApiService)          │  ← 拦截器统一处理
│  - ErrorInterceptor 捕获所有异常     │
│  - 转换为 AppException               │
│  - 日志记录、错误上报                │
└─────────────────────────────────────┘
```

## 🎯 核心组件

### 1. AppException - 统一异常类

文件：`lib/core/exceptions/app_exception.dart`

```dart
enum AppExceptionType {
  network,   // 网络错误
  server,    // 服务器业务错误
  parse,     // 数据解析错误
  timeout,   // 超时
  cancel,    // 取消请求
  unknown,   // 未知错误
}

class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final int? code;
}
```

### 2. ErrorInterceptor - 统一错误拦截器

文件：`lib/core/network/error_interceptor.dart`

**职责:**
- ✅ 捕获所有 DioException
- ✅ 转换为统一的 AppException
- ✅ 记录错误日志 (开发环境)
- ✅ 可扩展：全局错误上报、埋点监控

**处理逻辑:**
1. 检查响应体中的业务错误信息 (`errorContext`)
2. 如果有业务错误，返回 `AppExceptionType.server`
3. 否则根据 DioException 类型返回对应的网络错误

## 💡 使用方式

### 在页面/UI 层处理异常

```dart
// 方式 1: try-catch
Future<void> _handleLogin() async {
  try {
    final userId = await AuthService().login('user', 'pass');
    // 登录成功逻辑
    Navigator.push(...);
  } on AppException catch (e) {
    // 根据异常类型显示不同提示
    switch (e.type) {
      case AppExceptionType.timeout:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('请求超时，请检查网络连接')),
        );
        break;
      case AppExceptionType.server:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),  // 显示服务器错误消息
        );
        break;
      case AppExceptionType.network:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('网络错误，请稍后重试')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发生错误：${e.message}')),
        );
    }
  }
}

// 方式 2: 使用 Future 的 catchError
AuthService().login('user', 'pass')
  .then((userId) => Navigator.push(...))
  .catchError((e) {
    if (e is AppException) {
      _showErrorDialog(e.message);
    }
  });
```

### 在 Domain 层保持简洁

```dart
// ✅ 推荐：不处理异常，让其自然传递
class AuthService {
  Future<String> login(String loginId, String password) async {
    UserLoginResponse response = await authApi.login(loginId, password);
    return response.userId;
  }
}

// ❌ 不推荐：重复捕获和抛出
class AuthService {
  Future<String> login(String loginId, String password) async {
    try {
      UserLoginResponse response = await authApi.login(loginId, password);
      return response.userId;
    } catch (e) {
      rethrow;  // 多余的代码
    }
  }
}
```

## 🔄 执行流程示例

### 场景 1: 服务器返回业务错误

```
用户点击登录
  ↓
AuthService.login() 
  ↓ (无 try-catch，异常透传)
AuthApi.login()
  ↓ (无 try-catch，异常透传)
ApiService.post()
  ↓ (无 try-catch，异常透传)
Dio 发送请求
  ↓
服务器响应：{ "success": false, "errorContext": "用户名或密码错误" }
  ↓
ErrorInterceptor.onError()
  - 检测到 errorContext
  - 创建 AppException(type: server, message: "用户名或密码错误")
  - 打印日志：❌ [网络错误] server
  ↓
handler.next(err) 继续传递
  ↓
页面层 try-catch 捕获 AppException
  ↓
显示 SnackBar: "用户名或密码错误"
```

### 场景 2: 网络超时

```
用户点击登录
  ↓
... (同上)
  ↓
Dio 发送请求
  ↓
等待超过 30 秒，无响应
  ↓
ErrorInterceptor.onError()
  - DioExceptionType.receiveTimeout
  - 创建 AppException(type: timeout, message: "请求超时")
  - 打印日志：❌ [网络错误] timeout
  ↓
页面层捕获并显示："请求超时，请检查网络连接"
```

## 📊 优势对比

### 之前的方案 (分散处理)

```dart
// ApiService 层
try { ... } catch (e) { print(...); rethrow; }

// AuthApi 层  
try { ... } catch (e) { print(...); rethrow; }

// AuthService 层
try { ... } catch (e) { rethrow; }

// 页面层
try { ... } catch (e) { 显示提示 }
```

**问题:**
- ❌ 每层都有重复的 try-catch
- ❌ 职责不清，不知道哪层应该处理
- ❌ 难以维护，修改逻辑要改多处
- ❌ 代码冗长

### 现在的方案 (统一处理)

```dart
// ApiService 层 - ErrorInterceptor
void onError(err) {
  AppException appEx = _convert(err);
  print('❌ [错误] ${appEx.message}');
  handler.next(err);  // 统一出口
}

// AuthApi 层 - 简洁
Future<UserLoginResponse> login(...) async {
  ServiceResponse response = await _apiService.post(...);
  return UserLoginResponse.fromJson(response.data);
}

// AuthService 层 - 简洁
Future<String> login(...) async {
  UserLoginResponse response = await authApi.login(...);
  return response.userId;
}

// 页面层 - 统一处理
try {
  await AuthService().login(...);
} on AppException catch (e) {
  _showError(e);  // 只在这里处理
}
```

**优势:**
- ✅ 职责清晰：拦截器负责转换，UI 层负责显示
- ✅ 代码简洁：中间层无需重复 try-catch
- ✅ 易于扩展：添加全局错误上报只需改拦截器
- ✅ 统一规范：所有请求走同一套异常处理

## 🛠️ 扩展功能

### 添加全局错误上报

在 `ErrorInterceptor` 中添加:

```dart
@override
void onError(DioException err, ErrorInterceptorHandler handler) {
  final appException = _handleException(err);
  
  if (kDebugMode) {
    _printError(appException, err);
  }
  
  // 👇 添加这里
  // 上报到监控系统 (如：Firebase Crashlytics, Sentry)
  ErrorReporter.report(appException);
  
  handler.next(err);
}
```

### 自定义错误提示映射

```dart
String getErrorMessage(AppException exception) {
  switch (exception.type) {
    case AppExceptionType.timeout:
      return '请求超时，请检查网络连接';
    case AppExceptionType.server:
      return exception.message;  // 使用服务器返回的消息
    case AppExceptionType.network:
      return '网络错误，请稍后重试';
    case AppExceptionType.cancel:
      return '请求已取消';
    default:
      return '发生错误：${exception.message}';
  }
}
```

## 📝 总结

**核心原则:**
1. **单一职责**: 每层只做一件事
2. **统一出口**: 所有异常从拦截器统一转换
3. **透明传递**: 中间层不重复捕获和抛出
4. **集中处理**: UI 层统一处理并显示

这样设计后，你的代码会变得更清晰、更易维护！🎉
