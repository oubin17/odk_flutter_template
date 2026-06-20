# ODK Flutter Template - AI 全局开发指引

> 本文件为项目唯一的 AI 开发规范源文件，所有 AI 辅助编程工具（Cursor、Cline、WindSurf、Windsurf、Windi3 等）应自动加载并严格遵守。
>
> **重要**：这是一个 Flutter 模板项目，后续新项目会基于此模板完善功能。因此，本指引力求详细全面，确保 AI 生成代码时能够遵循统一规范，避免出错。
>
> **维护说明**：修改本文件后，其他编辑器的 .cursorrules、.windsurfrules 等配置文件通过符号链接指向本文件，实现一处修改全局同步。

---

## 目录

1. [项目能力概览](#1-项目能力概览)
2. [技术栈与依赖](#2-技术栈与依赖)
3. [架构分级详解](#3-架构分级详解)
4. [目录结构规范](#4-目录结构规范)
5. [分层职责与依赖方向](#5-分层职责与依赖方向)
6. [公共组件使用规范](#6-公共组件使用规范)
7. [状态管理规范](#7-状态管理规范)
8. [路由与导航规范](#8-路由与导航规范)
9. [网络请求规范](#9-网络请求规范)
10. [编码风格与细节](#10-编码风格与细节)
11. [国际化规范](#11-国际化规范)
12. [屏幕适配规范](#12-屏幕适配规范)
13. [Model 生成规范](#13-model-生成规范)
14. [新页面开发流程](#14-新页面开发流程)
15. [禁止事项清单](#15-禁止事项清单)
16. [常见模式参考](#16-常见模式参考)
17. [编辑器配置说明](#17-编辑器配置说明)

---

## 1. 项目能力概览

### 1.1 模板定位

本项目是一个 **Flutter 企业级应用模板**，包含以下开箱即用的能力：

| 能力模块 | 说明 |
|---------|------|
| **用户认证** | 手机号+验证码登录、手机号+密码登录、用户注册、Token 自动续期 |
| **AI 对话** | AI 聊天功能，支持多轮对话、上下文记忆 |
| **内容管理** | 内容列表、内容详情 |
| **用户中心** | 个人信息查看/编辑、头像上传、密码管理 |
| **系统设置** | 通用设置、安全设置、版本信息、关于我们、反馈建议、账号注销 |
| **路由系统** | GoRouter + 登录拦截 + 白名单机制 |
| **网络封装** | Dio 统一拦截、签名验证、错误处理 |
| **主题适配** | 明暗主题自动切换 |
| **国际化** | 中文/英文双语支持 |
| **屏幕适配** | flutter_screenutil 统一适配 |

### 1.2 模板特性

- **Feature-First 分层架构**：按功能模块组织代码，每模块包含 API/Model/Service/Presentation 四层
- **Provider 状态管理**：使用 ChangeNotifierProvider + Selector 实现精准状态监听
- **防抖机制**：统一的防重复点击组件（AppDebounceButton/AppDebounceWrapper）
- **表单校验**：统一的表单校验流程（GlobalKey<FormState> + AppInput.validator）
- **生命周期安全**：异步回调 mounted 检查 + 控制器 dispose 释放

---

## 2. 技术栈与依赖

### 2.1 核心技术版本

| 技术 | 版本要求 | 说明 |
|------|---------|------|
| Flutter | 3.10+ | 必须使用最新稳定版 |
| Dart | 3.10+ | 与 Flutter 版本匹配 |
| GoRouter | ^14.0.0 | 路由管理 |
| Provider | ^6.1.0 | 状态管理 |
| Dio | ^5.4.0 | 网络请求 |
| flutter_screenutil | ^5.9.0 | 屏幕适配 |
| json_annotation | ^4.9.0 | JSON 序列化注解 |
| json_serializable | ^6.8.0 | JSON 代码生成 |
| build_runner | ^2.4.0 | 代码生成工具 |

### 2.2 主要依赖（pubspec.yaml 核心依赖）

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 路由
  go_router: ^14.0.0

  # 状态管理
  provider: ^6.1.0

  # 网络
  dio: ^5.4.0

  # 屏幕适配
  flutter_screenutil: ^5.9.0

  # JSON 序列化
  json_annotation: ^4.9.0

  # UI 组件
  cached_network_image: ^3.3.0
  flutter_smart_dialog: ^4.9.0

  # 安全存储
  flutter_secure_storage: ^9.0.0

  # 其他
  intl: ^0.19.0
  visibility_detector: ^0.4.0+2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  json_serializable: ^6.8.0
  build_runner: ^2.4.0
```

---

## 3. 架构分级详解

### 3.1 架构原则

本项目采用 **Feature-First 分层架构**，核心原则：

1. **单一职责**：每层只做一件事
2. **依赖单向**：上层依赖下层，下层不依赖上层
3. **接口隔离**：通过接口/单例模式解耦
4. **可测试性**：业务逻辑与 UI 分离，可独立测试

### 3.2 分层级别

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│                      (表现层)                              │
│  ┌─────────────────┐  ┌─────────────────────────────┐  │
│  │   Page (UI)     │  │   ViewModel (Logic)          │  │
│  │   页面组件       │  │   视图模型/业务逻辑           │  │
│  └─────────────────┘  └─────────────────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                    Service Layer                         │
│                      (服务层)                              │
│  ┌─────────────────────────────────────────────────────┐│
│  │   Service (单例) - 业务编排 + 数据处理               ││
│  └─────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────┤
│                     API Layer                            │
│                      (接口层)                              │
│  ┌─────────────────────────────────────────────────────┐│
│  │   API (单例) - 网络请求封装                          ││
│  └─────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────┤
│                     Model Layer                          │
│                      (模型层)                              │
│  ┌─────────────────────────────────────────────────────┐│
│  │   Model - 数据模型 (json_serializable)              ││
│  └─────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────┘
```

### 3.3 分层职责

| 层级 | 职责 | 禁止事项 |
|------|------|---------|
| **Presentation/Page** | UI 渲染 + 事件绑定 | 禁止写业务逻辑 |
| **Presentation/ViewModel** | 业务逻辑 + 表单状态 | 禁止直接操作 Widget |
| **Service** | API 编排 + 数据处理 + 缓存 | 禁止直接返回 Widget |
| **API** | HTTP 请求封装 | 禁止处理业务逻辑 |
| **Model** | 数据结构定义 | 禁止包含业务逻辑 |

---

## 4. 目录结构规范

### 4.1 项目根目录结构

```
lib/
├── common/                    # 公共能力
│   ├── app_info/             # 应用信息
│   ├── initializer/           # 初始化器
│   └── theme/                 # 主题配置
├── config/                    # 全局配置
│   └── env.dart               # 环境配置
├── core/                      # 核心能力
│   ├── cache/                 # 缓存管理
│   ├── constants/             # 常量定义
│   ├── crash/                 # 崩溃捕获
│   ├── network/               # 网络核心（ApiService + 拦截器）
│   ├── session/               # 会话管理
│   ├── storage/               # 存储管理
│   └── utils/                 # 工具类
├── features/                  # 功能模块（按 feature 组织）
│   └── {feature_name}/
│       ├── api/               # API 接口
│       ├── models/            # 数据模型
│       ├── presentation/      # 表现层（Page + ViewModel）
│       └── service/            # 业务服务
├── l10n/                      # 国际化资源
├── models/                    # 全局通用模型
│   ├── request/               # 请求模型
│   └── response/              # 响应模型
├── providers/                 # 全局 Provider
├── routes/                    # 路由配置
├── widgets/                   # 公共组件
├── main.dart                  # 应用入口
└── main_*.dart                # 环境变体入口
```

### 4.2 Feature 模块结构

每个 Feature（功能模块）必须包含以下四层：

```
lib/features/{feature_name}/
├── api/                                    # API 接口层（单例）
│   └── {feature_name}_api.dart             # 使用 ApiService 封装请求
│
├── models/                                 # 数据模型层
│   └── {feature_name}/
│       ├── {model}.dart                    # json_annotation 模型定义
│       └── {model}.g.dart                  # 自动生成的代码
│
├── presentation/                           # 表现层
│   ├── {page_name}.dart                    # 页面（纯 UI + 事件绑定）
│   ├── {page_name}_view_model.dart         # ViewModel（业务逻辑）
│   └── {feature_name}_mixin.dart           # 共享 UI 逻辑 Mixin（可选）
│
└── service/                                 # 业务服务层（单例）
    └── {feature_name}_service.dart          # 编排 API + 数据处理
```

### 4.3 命名规范

| 类型 | 命名规则 | 示例 |
|------|---------|------|
| Feature 目录 | snake_case | `user_profile`、`ai_chat` |
| Page 类 | PascalCase + Page | `SignInPage`、`UserInfoPage` |
| ViewModel 类 | PascalCase + ViewModel | `SignInViewModel`、`UserInfoViewModel` |
| Service 类 | PascalCase + Service | `AuthService`、`UserProfileService` |
| API 类 | PascalCase + Api | `AuthApi`、`UserProfileApi` |
| Model 类 | PascalCase（名词） | `UserEntity`、`LoginResponse` |
| Mixin 类 | PascalCase + Mixin | `AuthMixin` |

---

## 5. 分层职责与依赖方向

### 5.1 数据流向

```
用户操作 → Page (UI渲染) → ViewModel (逻辑) → Service (编排) → API (网络)
              ↓               ↓                  ↓
          ChangeNotifier   Model (数据)      Model (数据)
```

### 5.2 Page（页面层）职责

**职责**：
- UI 渲染：使用公共组件构建界面
- 事件绑定：将用户操作转发给 ViewModel
- 状态监听：使用 Selector 精准监听 ViewModel 状态变化
- 路由跳转：调用 NavigatorUtils 进行页面导航

**禁止**：
- 禁止写业务逻辑（API 调用、数据处理等）
- 禁止直接创建 Service/Api 实例
- 禁止使用 context.watch() 全量监听

### 5.3 ViewModel（视图模型层）职责

**职责**：
- 表单状态管理：管理输入框内容、校验状态
- 业务逻辑处理：数据校验、格式转换、流程编排
- API 调用调度：调用 Service 层方法
- 结果处理：返回结果或错误信息给 Page

**禁止**：
- 禁止直接操作 Widget
- 禁止管理 isLoading 状态（由 AppDebounceButton 处理）
- 禁止直接发送网络请求（必须通过 Service）

### 5.4 Service（服务层）职责

**职责**：
- API 编排：组合多个 API 调用
- 数据处理：数据转换、缓存、格式化
- 业务规则：与具体 UI 无关的业务规则

**模式**：单例模式
```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;
}
```

### 5.5 API（接口层）职责

**职责**：
- HTTP 请求封装：使用 ApiService 发起请求
- 请求参数转换：将 Model 转为 JSON
- 响应转换：将 JSON 转为 Model

**模式**：单例模式
```dart
class AuthApi {
  static final AuthApi _instance = AuthApi._internal();
  AuthApi._internal();
  factory AuthApi() => _instance;
}
```

---

## 6. 公共组件使用规范

> **重要**：所有公共组件从 `lib/widgets/app_widgets/app_widgets.dart` 导入，**禁止直接使用原生 Flutter 组件**。

### 6.1 组件速查表

#### 文本组件

| 组件 | 用途 | 替代 | 导入 |
|------|------|------|------|
| `AppText` | 统一文本 | ❌ `Text` | app_widgets.dart |
| `AppText.title` | 标题文本 32sp | - | app_widgets.dart |
| `AppText.body` | 正文文本 28sp | - | app_widgets.dart |
| `AppText.second` | 次要文本 26sp | - | app_widgets.dart |
| `AppText.tip` | 提示文本 24sp | - | app_widgets.dart |
| `AppTip` | 带背景提示 | - | app_widgets.dart |

#### 按钮组件

| 组件 | 用途 | 替代 | 导入 |
|------|------|------|------|
| `AppButton` | 主按钮（填充） | ❌ `ElevatedButton` | app_widgets.dart |
| `AppDebounceButton` | **防抖提交按钮** | ❌ 手动管理 isLoading | app_debounce_button.dart |
| `AppOutlinedButton` | 次按钮（线框） | ❌ `OutlinedButton` | app_widgets.dart |
| `AppTextButton` | 文字按钮 | ❌ `TextButton` | app_widgets.dart |
| `AppIconButton` | 图标按钮 | ❌ `IconButton` | app_widgets.dart |

#### 输入组件

| 组件 | 用途 | 替代 | 导入 |
|------|------|------|------|
| `AppInput` | 通用输入框 | ❌ `TextFormField` | app_widgets.dart |
| `AppInputPrefix` | 输入框前缀 | ❌ 空格对齐 | app_widgets.dart |
| `ClearButton` | 清除按钮 | - | app_widgets.dart |
| `AppTextArea` | 多行文本域 | ❌ `TextField` | app_widgets.dart |

#### 布局组件

| 组件 | 用途 | 替代 | 导入 |
|------|------|------|------|
| `AppCard` | 统一卡片 | ❌ `Container` 卡片 | app_widgets.dart |
| `AppListItem` | 列表项 | - | app_widgets.dart |
| `AppGap` | 统一间距 | ❌ `SizedBox(height:)` | app_widgets.dart |
| `AppDivider` | 分割线 | ❌ `Divider` | app_widgets.dart |

#### 其他组件

| 组件 | 用途 | 替代 | 导入 |
|------|------|------|------|
| `AppAvatar` | 头像 | ❌ `CircleAvatar` | app_widgets.dart |
| `AppCheckbox` | 勾选框 | ❌ `Checkbox` | app_widgets.dart |
| `AppAgreementCheckbox` | 协议勾选框 | - | app_widgets.dart |
| `AppDot` | 红点标记 | - | app_widgets.dart |
| `AppColors` | 统一颜色 | ❌ 硬编码颜色 | app_widgets.dart |
| `AppIcon` | 统一图标 | - | app_widgets.dart |

#### 页面骨架

| 组件 | 用途 | 导入 |
|------|------|------|
| `AppPage` | 标准页面骨架 | app_page/app_page.dart |
| `BasicAppBar` | 标准 AppBar | app_page/app_bar.dart |

#### 其他功能组件

| 组件 | 用途 | 导入 |
|------|------|------|
| `VerifyCodeInput` | 验证码输入 | app_countdown/verify_code_input.dart |
| `AppToast` | Toast/Loading | smart_dialog/app_toast.dart |
| `AppBottomDatePicker` | 底部日期选择 | app_widgets.dart |
| `AppRefreshList` | 下拉刷新列表 | app_refresh/app_refresh_list.dart |

### 6.2 AppGap 间距常量

```dart
// 垂直间距
AppGap.hSuperSmall  // 10.h
AppGap.hSmall        // 20.h
AppGap.hNormal       // 30.h
AppGap.hLarge        // 40.h
AppGap.hXL           // 60.h

// 水平间距
AppGap.wSuperSmall   // 10.w
AppGap.wSmall        // 20.w
AppGap.wNormal       // 30.w
AppGap.wLarge        // 40.w
AppGap.wXL           // 60.w

// 自定义间距
AppGap.h(24)         // SizedBox(height: 24.h)
AppGap.w(24)         // SizedBox(width: 24.w)
```

### 6.3 AppColors 颜色常量

```dart
// 主色系（自动适配明暗主题）
AppColors.primary50(context)      // 超浅
AppColors.primaryLight(context)    // 浅
AppColors.primary(context)         // 主色
AppColors.primaryDark(context)      // 深

// 背景色
AppColors.bgPage(context)          // 页面背景
AppColors.bgSecond(context)        // 次要背景
AppColors.card(context)            // 卡片背景
AppColors.divider(context)         // 分割线

// 文字色
AppColors.textMain(context)        // 主文字
AppColors.textSecond(context)      // 次要文字
AppColors.textGray(context)        // 灰文字
AppColors.textWhite                // 白色文字

// 状态色
AppColors.success                   // 绿色
AppColors.error                     // 红色
AppColors.warning                   // 橙色
```

---

## 7. 状态管理规范

### 7.1 核心原则

| 原则 | 说明 |
|------|------|
| `ChangeNotifierProvider` | 创建并注入 ViewModel |
| `Selector<VM, Type>` | 精准监听某个属性，只重建 builder 内 Widget |
| `context.read<VM>()` | 调用 ViewModel 方法，不触发重建 |
| `context.watch<VM>()` | ❌ **禁止使用**，全量重建性能差 |

### 7.2 Provider 使用模式

```dart
// Page 中：ChangeNotifierProvider 提供 ViewModel
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => SignInViewModel(),
    builder: (context, child) => _buildScaffold(context),
  );
}

// Page 中：Selector 精准监听状态
Selector<SignInViewModel, bool>(
  selector: (_, vm) => vm.isPasswordLogin,
  builder: (_, isPasswordLogin, _) {
    return isPasswordLogin ? _passwordInput() : _verifyCodeInput();
  },
)

// Page 中：context.read 调用方法（不监听）
context.read<SignInViewModel>().toggleLoginType();

// ViewModel 中：notifyListeners() 通知更新
void setPassword(String password) {
  _password = password;
  notifyListeners();
}
```

### 7.3 防抖规范

**必须使用防抖组件，禁止手动管理 isLoading**

| 组件 | 适用场景 | 特点 |
|------|---------|------|
| `AppDebounceButton` | 页面级提交按钮（登录、注册、保存） | 自带按钮 UI + Loading 动画 |
| `AppDebounceWrapper` | 任意可点击组件（弹窗确认、图标按钮、卡片点击） | 不改变外观，仅防抖逻辑 |

```dart
// ✅ 正确：使用 AppDebounceButton
AppDebounceButton(
  text: L10nUtils.login,
  onTap: () => _login(context),
)

// ✅ 正确：使用 AppDebounceWrapper
AppDebounceWrapper(
  onTap: () => _showConfirm(),
  child: AppTextButton(
    text: L10nUtils.confirm,
    onTap: null,
  ),
)

// ❌ 错误：手动管理 isLoading
// bool isLoading = false;
// if (isLoading) return;
// setState(() => isLoading = true);
```

### 7.4 ViewModel 生命周期

```dart
class SignInViewModel extends ChangeNotifier {
  // 构造函数：初始化服务
  SignInViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  // dispose：清理资源
  @override
  void dispose() {
    // 取消订阅、释放控制器等
    super.dispose();
  }
}
```

---

## 8. 路由与导航规范

### 8.1 路由注册三步骤

```dart
// 步骤 1: RouteNames 添加路由名称
class RouteNames {
  static const String {pageName} = '{PageName}';  // PascalCase
}

// 步骤 2: RoutePaths 添加路由路径
class RoutePaths {
  static const String {pageName} = '/{pageName}';  // camelCase
}

// 步骤 3: AppRouter.routes 注册路由
GoRoute(
  path: RoutePaths.{pageName},
  name: RouteNames.{pageName},
  builder: (context, state) => const {PageName}Page(),
),
```

### 8.2 导航方法

| 方法 | 导航栈行为 | 能否返回 | 典型场景 |
|------|-----------|---------|---------|
| `NavigatorUtils.goNamed()` | 替换整个栈 | ❌ 不能 | 登录→首页、退出→登录 |
| `NavigatorUtils.pushNamed()` | 压入栈顶 | ✅ 能 | 进入详情页、协议页 |
| `NavigatorUtils.pushReplacementNamed()` | 替换栈顶 | ❌ 被替换页不能 | 登录→首页 |
| `NavigatorUtils.pop()` | 弹出栈顶 | — | 返回上一页 |

### 8.3 路由传参

```dart
// 跳转时传递参数（queryParameters）
NavigatorUtils.pushNamed(
  RouteNames.userInfoUpdate,
  queryParameters: {
    'title': '修改昵称',
    'value': currentNickname,
    'type': typeIndex.toString(),
  },
);

// 接收时获取参数
final title = state.uri.queryParameters['title'] ?? '';
final value = state.uri.queryParameters['value'] ?? '';
final typeIndex = state.uri.queryParameters['type'];
```

### 8.4 白名单页面

无需登录即可访问的页面，添加到 `AppRouter.whiteList`：

```dart
static const List<String> whiteList = [
  RoutePaths.signup,
  RoutePaths.signin,
  RoutePaths.agreement,
  // 新页面如需匿名访问，在此添加...
];
```

### 8.5 登录拦截机制

路由 redirect 中自动判断登录状态：

```dart
redirect: (context, state) {
  final userProvider = context.read<UserProvider>();
  final isLoggedIn = userProvider.userEntity != null;
  final currentPath = state.uri.path;

  // 白名单页面不拦截
  if (whiteList.contains(currentPath)) return null;

  // 根路径根据登录状态跳转
  if (currentPath == '/') {
    return isLoggedIn ? RoutePaths.home : RoutePaths.signin;
  }

  // 未登录强制跳转登录页
  if (!isLoggedIn) {
    return RoutePaths.signin;
  }

  return null;
}
```

---

## 9. 网络请求规范

### 9.1 ApiService 使用

```dart
import 'package:odk_flutter_template/core/network/api_service.dart';

// GET 请求
ServiceResponse response = await ApiService().get('/api/path', queryParameters: {});

// POST 请求
ServiceResponse response = await ApiService().post('/api/path', data: {});

// 文件上传
ServiceResponse response = await ApiService().upload('/api/upload', filePath);
```

### 9.2 API 层封装

```dart
class AuthApi {
  static final AuthApi _instance = AuthApi._internal();
  AuthApi._internal();
  factory AuthApi() => _instance;

  /// 登录
  Future<ServiceResponse> login(LoginRequest request) async {
    return await ApiService().post('/api/auth/login', data: request.toJson());
  }

  /// 获取用户信息（返回具体 Model）
  Future<UserEntity?> getUserInfo() async {
    ServiceResponse response = await ApiService().get('/api/user/info');
    if (response.data == null) return null;
    return UserEntity.fromJson(response.data as Map<String, dynamic>);
  }
}
```

### 9.3 Service 层编排

```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  /// 登录并缓存 Token
  Future<ServiceResponse> login(LoginRequest request) async {
    final response = await AuthApi().login(request);
    if (response.success && response.data != null) {
      // 缓存 Token 等操作
      await UserSessionService().saveToken(response.data['token']);
    }
    return response;
  }
}
```

### 9.4 响应结构

```dart
// ServiceResponse 结构
class ServiceResponse {
  final bool success;           // 请求是否成功
  final dynamic data;          // 响应数据
  final String? message;        // 错误信息
  final int? code;              // 状态码
}

// PageResponse 结构（分页列表）
class PageResponse<T> {
  final List<T> items;          // 数据列表
  final int total;              // 总数
  final int page;               // 当前页
  final int pageSize;           // 每页大小
}
```

---

## 10. 编码风格与细节

### 10.1 Loading 与 Toast

```dart
// 显示 Loading
AppToast.showLoading();

// 关闭 Loading
AppToast.dismiss();

// 显示提示
AppToast.showToast('操作成功');

// 显示错误
AppToast.showToast('网络错误');

// 显示确认对话框
AppToast.showAppConfirmDialog(
  title: '确认退出',
  onConfirm: () => _logout(),
);
```

**重要**：Loading 由 ViewModel 内部管理，在 try/finally 中控制：

```dart
Future<void> submit() async {
  AppToast.showLoading();
  try {
    final result = await _service.submit();
    if (result.success) {
      AppToast.showToast('提交成功');
    } else {
      AppToast.showToast(result.message ?? '提交失败');
    }
  } catch (e) {
    AppToast.showToast('网络错误');
  } finally {
    AppToast.dismiss();
  }
}
```

### 10.2 表单校验

```dart
// 1. Page 中定义 FormKey
final _formKey = GlobalKey<FormState>();

// 2. Form 包裹输入框
Form(
  key: _formKey,
  child: Column(
    children: [
      AppInput(
        controller: _phoneController,
        hint: '请输入手机号',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入手机号';
          }
          if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
            return '手机号格式不正确';
          }
          return null;
        },
      ),
    ],
  ),
)

// 3. 提交时校验
Future<void> _submit() async {
  if (_formKey.currentState?.validate() ?? false) {
    // 校验通过，调用 ViewModel
  }
}
```

### 10.3 生命周期安全

```dart
class _MyPageState extends State<MyPage> {
  @override
  void dispose() {
    // 释放控制器
    _controller.dispose();
    super.dispose();
  }
}

// 异步回调中检查 mounted
Future<void> _loadData() async {
  try {
    final result = await _service.getData();
    if (!mounted) return;
    // 安全访问 setState
    setState(() => _data = result);
  } catch (e) {
    if (!mounted) return;
    AppToast.showToast('加载失败');
  }
}
```

### 10.4 屏幕适配

**所有尺寸必须使用适配后缀，禁止裸数字**

| 后缀 | 用途 | 示例 |
|------|------|------|
| `.w` | 宽度适配 | `20.w` = 屏幕宽度 * 20 / 750` |
| `.h` | 高度适配 | `20.h` = 屏幕高度 * 20 / 750` |
| `.sp` | 字号适配 | `28.sp` = 逻辑字号 |

```dart
// ✅ 正确
Container(
  width: 200.w,
  height: 100.h,
  padding: EdgeInsets.all(20.w),
  child: Text('文字', style: TextStyle(fontSize: 28.sp)),
)

// ❌ 错误
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(20),
  child: Text('文字', style: TextStyle(fontSize: 28)),
)
```

### 10.5 国际化

所有用户可见文字必须使用 `L10nUtils`：

```dart
// 获取国际化文案
AppText(L10nUtils.login)           // 登录
AppText(L10nUtils.register)        // 注册
AppText(L10nUtils.confirm)        // 确认
AppText(L10nUtils.cancel)          // 取消

// AppInput 中使用
AppInput(
  hint: L10nUtils.phoneHint,      // 请输入手机号
)

// Button 中使用
AppButton(
  text: L10nUtils.submit,          // 提交
)
```

---

## 11. 国际化规范

### 11.1 国际化文件

| 文件 | 语言 | 路径 |
|------|------|------|
| app_zh.arb | 中文 | lib/l10n/app_zh.arb |
| app_en.arb | 英文 | lib/l10n/app_en.arb |

### 11.2 国际化定义格式

```json
// app_zh.arb
{
  "login": "登录",
  "register": "注册",
  "phoneHint": "请输入手机号",
  "@phoneHint": {
    "description": "手机号输入框占位提示"
  }
}
```

### 11.3 新增国际化文案的步骤

1. 在 `app_zh.arb` 中添加中文文案
2. 在 `app_en.arb` 中添加英文文案
3. 使用 `L10nUtils.{key}` 获取文案

---

## 12. 屏幕适配规范

### 12.1 屏幕适配初始化

```dart
// main.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(750, 1334), // 设计稿尺寸
      minSdkAdapt: true,
      sdSdkAdapt: true,
      builder: (context, child) {
        return MaterialApp(...);
      },
    ),
  );
}
```

### 12.2 适配规则

| 场景 | 适配方式 | 示例 |
|------|---------|------|
| 固定尺寸 | `.w` 或 `.h` | `100.w` = 宽度的 13.3% |
| 字号 | `.sp` | `28.sp` = 逻辑字号的 3.7% |
| 间距 | `.w` 或 `.h` | `EdgeInsets.symmetric(horizontal: 20.w)` |
| 圆角 | `.w` | `BorderRadius.circular(16.w)` |

---

## 13. Model 生成规范

### 13.1 创建 Model

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  final String? id;
  final String? nickname;
  final String? phone;
  final String? avatar;
  final int? gender;  // 0-未知 1-男 2-女

  UserEntity({
    this.id,
    this.nickname,
    this.phone,
    this.avatar,
    this.gender,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
```

### 13.2 枚举类型

```dart
@JsonEnum()
enum Gender {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  male,
  @JsonValue(2)
  female,
}
```

### 13.3 嵌套对象

```dart
@JsonSerializable()
class OrderEntity {
  final String? id;
  final UserEntity? user;           // 嵌套对象
  final List<OrderItem>? items;     // 嵌套列表

  OrderEntity({this.id, this.user, this.items});

  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);
  Map<String, dynamic> toJson() => _$OrderEntityToJson(this);
}
```

### 13.4 运行代码生成

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 13.5 分页请求/响应

```dart
// PageRequest - 分页请求
class PageRequest {
  final int page;
  final int pageSize;

  PageRequest({this.page = 1, this.pageSize = 10});

  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
  };
}

// PageResponse - 分页响应
@JsonSerializable()
class PageResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  PageResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PageResponseFromJson(json, fromJsonT);
}
```

---

## 14. 新页面开发流程

### 14.1 流程概览

```
1. 创建目录结构
   └── lib/features/{feature_name}/
       ├── api/
       ├── models/
       ├── presentation/
       └── service/

2. 创建 Model (models/)

3. 创建 API (api/)

4. 创建 Service (service/)

5. 创建 ViewModel (presentation/)

6. 创建 Page (presentation/)

7. 注册路由 (routes/app_router.dart)

8. 添加国际化文案 (l10n/app_zh.arb, app_en.arb)

9. 运行 build_runner (如有 Model 更新)

10. 代码检查与测试
```

### 14.2 完整示例

以创建"反馈页面"(Feedback)为例：

#### Step 1: 创建目录结构

```
lib/features/feedback/
├── api/
│   └── feedback_api.dart
├── models/
│   └── feedback/
│       ├── feedback_request.dart
│       └── feedback_request.g.dart
├── presentation/
│   ├── feedback_page.dart
│   └── feedback_view_model.dart
└── service/
    └── feedback_service.dart
```

#### Step 2: 创建 Model

```dart
// lib/features/feedback/models/feedback/feedback_request.dart
import 'package:json_annotation/json_annotation.dart';

part 'feedback_request.g.dart';

@JsonSerializable()
class FeedbackRequest {
  final String content;
  final String? contact;

  FeedbackRequest({required this.content, this.contact});

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackRequestToJson(this);
}
```

#### Step 3: 创建 API

```dart
// lib/features/feedback/api/feedback_api.dart
import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/features/feedback/models/feedback/feedback_request.dart';

class FeedbackApi {
  static final FeedbackApi _instance = FeedbackApi._internal();
  FeedbackApi._internal();
  factory FeedbackApi() => _instance;

  Future<ServiceResponse> submit(FeedbackRequest request) async {
    return await ApiService().post('/api/feedback/submit', data: request.toJson());
  }
}
```

#### Step 4: 创建 Service

```dart
// lib/features/feedback/service/feedback_service.dart
import 'package:odk_flutter_template/features/feedback/api/feedback_api.dart';
import 'package:odk_flutter_template/features/feedback/models/feedback/feedback_request.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  FeedbackService._internal();
  factory FeedbackService() => _instance;

  Future<ServiceResponse> submit(FeedbackRequest request) async {
    return await FeedbackApi().submit(request);
  }
}
```

#### Step 5: 创建 ViewModel

```dart
// lib/features/feedback/presentation/feedback_view_model.dart
import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/feedback/models/feedback/feedback_request.dart';
import 'package:odk_flutter_template/features/feedback/service/feedback_service.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

class FeedbackViewModel extends ChangeNotifier {
  final FeedbackService _service;

  String _content = '';
  String? _contact;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get canSubmit => _content.trim().isNotEmpty;

  FeedbackViewModel({FeedbackService? service})
      : _service = service ?? FeedbackService();

  void setContent(String value) {
    _content = value;
    notifyListeners();
  }

  void setContact(String? value) {
    _contact = value;
  }

  /// 提交反馈（由 AppDebounceButton 调用，不需手动管理 Loading）
  Future<bool> submit() async {
    // 业务校验
    if (_content.trim().isEmpty) {
      _errorMessage = L10nUtils.feedbackContentEmpty;
      notifyListeners();
      return false;
    }

    AppToast.showLoading();
    try {
      final request = FeedbackRequest(content: _content, contact: _contact);
      final response = await _service.submit(request);

      if (response.success) {
        AppToast.showToast(L10nUtils.submitSuccess);
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = L10nUtils.networkError;
      notifyListeners();
      return false;
    } finally {
      AppToast.dismiss();
    }
  }
}
```

#### Step 6: 创建 Page

```dart
// lib/features/feedback/presentation/feedback_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedbackViewModel(),
      child: AppPage(
        title: AppText(L10nUtils.feedback),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<FeedbackViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 反馈内容
              AppText.second(L10nUtils.feedbackContent),
              AppGap.hSmall,
              AppCard(
                showShadow: false,
                padding: EdgeInsets.zero,
                child: AppTextArea(
                  controller: _contentController,
                  hint: L10nUtils.feedbackHint,
                  maxLength: 500,
                  onChanged: vm.setContent,
                ),
              ),

              AppGap.hLarge,

              // 联系方式
              AppText.second(L10nUtils.contactWay),
              AppGap.hSmall,
              AppInput(
                controller: _contactController,
                hint: L10nUtils.contactOptional,
                keyboardType: TextInputType.phone,
                onChanged: vm.setContact,
              ),

              AppGap.hLarge,

              // 错误提示
              if (vm.errorMessage != null) ...[
                AppTip(tip: vm.errorMessage!),
                AppGap.hLarge,
              ],

              // 提交按钮
              AppDebounceButton(
                text: L10nUtils.submit,
                onTap: () => _submit(context, vm),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context, FeedbackViewModel vm) async {
    final success = await vm.submit();
    if (success && mounted) {
      NavigatorUtils.pop();
    }
  }
}
```

#### Step 7: 注册路由

```dart
// lib/routes/app_router.dart

// 1. RouteNames 添加
class RouteNames {
  // ...
  static const String feedback = 'Feedback';
}

// 2. RoutePaths 添加
class RoutePaths {
  // ...
  static const String feedback = '/feedback';
}

// 3. routes 添加
GoRoute(
  path: RoutePaths.feedback,
  name: RouteNames.feedback,
  builder: (context, state) => const FeedbackPage(),
),

// 4. 白名单（如需匿名访问）
static const List<String> whiteList = [
  // ...
  RoutePaths.feedback,
];
```

#### Step 8: 添加国际化

```json
// lib/l10n/app_zh.arb
{
  "feedback": "反馈建议",
  "feedbackContent": "反馈内容",
  "feedbackHint": "请输入您的问题或建议...",
  "contactWay": "联系方式",
  "contactOptional": "手机号/邮箱（选填）",
  "feedbackContentEmpty": "请输入反馈内容",
  "submitSuccess": "提交成功"
}
```

```json
// lib/l10n/app_en.arb
{
  "feedback": "Feedback",
  "feedbackContent": "Content",
  "feedbackHint": "Please enter your questions or suggestions...",
  "contactWay": "Contact",
  "contactOptional": "Phone/Email (Optional)",
  "feedbackContentEmpty": "Please enter feedback content",
  "submitSuccess": "Submitted successfully"
}
```

---

## 15. 禁止事项清单

### 15.1 架构层面

| 禁止 | 正确做法 |
|------|---------|
| Page 中写业务逻辑 | 业务逻辑写在 ViewModel |
| ViewModel 中管理 isLoading | 使用 AppDebounceButton |
| 跨层调用（Page → API） | Page → ViewModel → Service → API |
| 手动管理防抖标志位 | 使用 AppDebounceButton/AppDebounceWrapper |

### 15.2 组件层面

| 禁止 | 正确做法 |
|------|---------|
| 直接使用 `Text` | 使用 `AppText` |
| 直接使用 `ElevatedButton` | 使用 `AppButton` |
| 直接使用 `TextFormField` | 使用 `AppInput` |
| 直接使用 `OutlinedButton` | 使用 `AppOutlinedButton` |
| 直接使用 `TextButton` | 使用 `AppTextButton` |
| 直接使用 `IconButton` | 使用 `AppIconButton` |
| 直接使用 `CircleAvatar` | 使用 `AppAvatar` |
| 直接使用 `Checkbox` | 使用 `AppCheckbox` |
| 直接使用 `Divider` | 使用 `AppDivider` |
| 使用 `SizedBox(height:)` | 使用 `AppGap` |
| 硬编码颜色值 | 使用 `AppColors` |

### 15.3 状态管理层面

| 禁止 | 正确做法 |
|------|---------|
| 使用 `context.watch<VM>()` | 使用 `Selector<VM, Type>` |
| 在 Page 中创建 Service 实例 | 注入 Service 或使用单例 |

### 15.4 编码层面

| 禁止 | 正确做法 |
|------|---------|
| 使用裸数字尺寸 | 使用 `.w/.h/.sp` |
| 异步回调不检查 mounted | 使用 `if (!mounted) return;` |
| 控制器不释放 | 在 `dispose()` 中释放 |
| 用户可见文字硬编码 | 使用 `L10nUtils.{key}` |
| 魔法数字/字符串 | 定义常量 |

---

## 16. 常见模式参考

### 16.1 列表页模式

```dart
class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final _listKey = GlobalKey<AppRefreshListState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContentViewModel(),
      child: AppPage(
        title: AppText(L10nUtils.content),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ContentViewModel>(
      builder: (context, vm, child) {
        return AppRefreshList(
          key: _listKey,
          itemCount: vm.items.length,
          onRefresh: vm.refresh,
          onLoadMore: vm.loadMore,
          itemBuilder: (context, index) {
            final item = vm.items[index];
            return _buildItem(item);
          },
        );
      },
    );
  }

  Widget _buildItem(ContentItem item) {
    return AppCard(
      onTap: () => _goDetail(item.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(item.title),
          AppGap.hSmall,
          AppText.body(item.summary),
        ],
      ),
    );
  }

  void _goDetail(String id) {
    NavigatorUtils.pushNamed(
      RouteNames.contentDetail,
      queryParameters: {'id': id},
    );
  }
}
```

### 16.2 表单编辑页模式

```dart
class UserInfoUpdatePage extends StatefulWidget {
  final String title;
  final String value;
  final UserInfoUpdateType type;

  const UserInfoUpdatePage({
    super.key,
    required this.title,
    required this.value,
    required this.type,
  });

  @override
  State<UserInfoUpdatePage> createState() => _UserInfoUpdatePageState();
}

class _UserInfoUpdatePageState extends State<UserInfoUpdatePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserInfoUpdateViewModel(type: widget.type),
      child: AppPage(
        title: AppText(widget.title),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<UserInfoUpdateViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.w),
              child: AppInput(
                controller: _controller,
                hint: L10nUtils.inputHint,
                onChanged: vm.setValue,
              ),
            ),
            if (vm.errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: AppTip(tip: vm.errorMessage!),
              ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(30.w),
              child: AppDebounceButton(
                text: L10nUtils.save,
                onTap: () => _save(context, vm),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save(BuildContext context, UserInfoUpdateViewModel vm) async {
    final success = await vm.save();
    if (success && mounted) {
      NavigatorUtils.pop(result: vm.value);
    }
  }
}
```

### 16.3 设置页模式

```dart
class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.systemSetting),
      body: ListView(
        children: [
          AppGap.hLarge,
          // 通用设置
          _buildSectionHeader(L10nUtils.generalSetting),
          AppListItem(
            title: L10nUtils.language,
            right: AppText.second('中文'),
            onTap: () => _changeLanguage(context),
          ),
          AppListItem(
            title: L10nUtils.theme,
            right: AppText.second(L10nUtils.auto),
            onTap: () => _changeTheme(context),
          ),
          AppDivider(),
          // 安全设置
          _buildSectionHeader(L10nUtils.securitySetting),
          AppListItem(
            title: L10nUtils.changePassword,
            onTap: () => NavigatorUtils.pushNamed(RouteNames.passwordManager),
          ),
          AppListItem(
            title: L10nUtils.bindPhone,
            onTap: () => _bindPhone(context),
          ),
          AppDivider(),
          // 其他
          _buildSectionHeader(L10nUtils.other),
          AppListItem(
            title: L10nUtils.about,
            onTap: () => NavigatorUtils.pushNamed(RouteNames.about),
          ),
          AppListItem(
            title: L10nUtils.feedback,
            onTap: () => NavigatorUtils.pushNamed(RouteNames.feedback),
          ),
          AppGap.hLarge,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
      child: AppText.tip(title),
    );
  }
}
```

---

## 17. 编辑器配置说明

### 17.1 配置符号链接

为使其他编辑器自动加载本指引文件，请创建符号链接：

```bash
# Cursor
ln -sf /path/to/AGENTS.md ~/.cursor/rules/odk_flutter_template.md

# WindSurf
ln -sf /path/to/AGENTS.md ~/.windsurf/rules/odk_flutter_template.md

# Cline
ln -sf /path/to/AGENTS.md ~/.cline/rules/odk_flutter_template.md
```

### 17.2 .cursorrules 示例

```markdown
# Cursor Rules Configuration
# This file should symlink to the project's AGENTS.md

ODK_FLUTTER_TEMPLATE_RULES=/path/to/your/project/AGENTS.md
```

### 17.3 加载优先级

1. 项目根目录的 `AGENTS.md`（最高优先级）
2. 编辑器全局配置
3. 编辑器工作区配置

---

## 附录 A：快速检查清单

生成代码后，请逐项确认：

### 架构检查
- [ ] 目录结构符合 Feature-First 分层
- [ ] Page 只做 UI 渲染和事件绑定
- [ ] ViewModel 继承 ChangeNotifier
- [ ] Service/API 使用单例模式
- [ ] 无跨层调用

### 组件检查
- [ ] 所有 `Text` 使用 `AppText` 替代
- [ ] 所有 `ElevatedButton` 使用 `AppButton` 替代
- [ ] 所有 `TextFormField` 使用 `AppInput` 替代
- [ ] 所有 `SizedBox(height:)` 使用 `AppGap` 替代
- [ ] 所有颜色使用 `AppColors` 替代

### 状态管理检查
- [ ] 使用 `Selector` 监听状态变化
- [ ] 使用 `context.read` 调用方法
- [ ] 禁止使用 `context.watch`
- [ ] 提交按钮使用 `AppDebounceButton`

### 编码规范检查
- [ ] 所有尺寸使用 `.w/.h/.sp`
- [ ] 所有用户可见文字使用 `L10nUtils`
- [ ] 异步回调检查 `mounted`
- [ ] 控制器在 `dispose` 中释放
- [ ] 路由已注册
- [ ] Model 使用 `json_serializable`

---

## 附录 B：常用命令

```bash
# 代码生成
dart run build_runner build --delete-conflicting-outputs

# 清理并重新生成
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# Flutter 分析
flutter analyze

# Flutter 格式化
flutter format .

# 获取依赖
flutter pub get

# 更新依赖
flutter pub upgrade
```

---

## 附录 C：相关文档索引

| 文档 | 说明 |
|------|------|
| `AGENTS.md` | AI 编码规范（本文档） |
| `docs/prompt_new_page.md` | 新页面开发完整提示词模板 |
| `docs/network_config.md` | 网络请求配置说明 |
| `docs/exception_handling.md` | 全局异常处理机制 |
| `docs/android_signing_guide.md` | Android 签名配置 |
| `README.md` | 项目功能特性、快速开始 |

---

**维护说明**：
- 本文件为项目唯一 AI 编码规范源文件
- 各编辑器配置文件（.cursorrules、.windsurfrules 等）通过符号链接指向本文件
- 修改规范时只需编辑本文件，其他文件自动同步
