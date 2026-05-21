# Flutter 新页面生成提示词

> 本提示词基于 `odk_flutter_template` 项目架构，用于指导 AI 生成符合项目规范的新页面。
> 使用时将 `{页面描述}` 替换为实际需求即可。

---

## 提示词模板

```
请帮我生成一个 {页面描述} 页面，严格遵循以下项目架构和编码规范：

---

### 一、项目架构规范（必须遵守）

#### 1. 目录结构（Feature-First 分层架构）

按功能模块组织，每个 feature 下分为四层：

```
lib/features/{feature_name}/
├── api/                          # API 接口层
│   └── {feature_name}_api.dart   # 网络请求定义（单例，使用 ApiService）
├── models/                       # 数据模型层
│   └── {feature_name}/
│       ├── {model}.dart          # JSON 序列化模型（json_annotation + json_serializable）
│       └── {model}.g.dart        # 自动生成文件
├── presentation/                 # 表现层（页面 + ViewModel + Mixin）
│   ├── {page_name}.dart          # 页面（纯 UI + 事件绑定）
│   ├── {page_name}_view_model.dart  # ViewModel（业务逻辑 + 状态管理）
│   └── {feature_name}_mixin.dart # 共享 UI 逻辑 Mixin（可选，跨页面复用时提取）
└── service/                      # 业务服务层
    └── {feature_name}_service.dart  # 业务编排（调用 API + 数据处理 + 缓存等）
```

#### 2. 分层职责与依赖方向

```
Page (UI) → ViewModel (逻辑) → Service (编排) → API (网络)
                ↓                    ↓
            ChangeNotifier      Model (数据)
```

- **Page**：纯 UI 渲染 + 事件绑定，禁止在 Page 中写业务逻辑
- **ViewModel**：继承 `ChangeNotifier`，管理表单状态和业务逻辑，可独立单元测试
- **Service**：单例模式（`factory Constructor() => _instance`），编排 API 调用和数据处理
- **API**：单例模式，使用 `ApiService` 封装 HTTP 请求，返回 `ServiceResponse` 或具体 Model
- **Model**：使用 `json_annotation` + `json_serializable`，运行 `build_runner` 生成 `.g.dart`

---

### 二、页面编码规范

#### 1. 页面（Page）结构模板

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

/// {页面中文描述}
class {PageName}Page extends StatefulWidget {
  const {PageName}Page({super.key});

  @override
  State<{PageName}Page> createState() => _{PageName}PageState();
}

class _{PageName}PageState extends State<{PageName}Page> {
  // ====================== 控制器 ======================
  // TextEditingController 等在此声明，在 dispose 中释放

  @override
  void dispose() {
    // 释放控制器
    super.dispose();
  }

  // ====================== 业务逻辑 ======================
  // 调用 ViewModel 方法，处理结果（Toast、导航等）
  // 禁止在此编写业务逻辑，仅做：校验 → 同步数据到 VM → 调用 VM 方法 → 处理结果

  // ====================== UI 组件拆分 ======================
  // 将复杂 UI 拆分为私有方法，方法名以 _ 开头
  // 每个方法返回一个 Widget，方法名语义化描述组件用途

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => {PageName}ViewModel(),
      builder: (context, child) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    // 使用 AppPage 通用页面骨架（标准页面）
    return AppPage(
      title: AppText(L10nUtils.{titleKey}),
      body: _buildBody(context),
    );

    // 或使用 Scaffold 自定义布局（登录/注册等特殊页面）
    // return Scaffold(
    //   resizeToAvoidBottomInset: true,
    //   body: GestureDetector(
    //     onTap: () => FocusScope.of(context).unfocus(),
    //     child: ...,
    //   ),
    // );
  }
}
```

#### 2. ViewModel 结构模板

```dart
import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// {页面中文描述} ViewModel — 业务逻辑与 UI 分离
///
/// 职责：
/// - 管理表单状态（{列举表单字段}）
/// - 执行业务流程（校验 → 组装请求 → 调用 API → 返回结果）
///
/// 防重复点击由 AppDebounceButton 在 UI 层处理，ViewModel 不再管理 isLoading
/// 可独立单元测试，不依赖 Flutter Widget 生命周期
class {PageName}ViewModel extends ChangeNotifier {
  final {FeatureName}Service _{featureName}Service;

  // ====================== 表单状态 ======================
  // 表单字段，由 Page 同步过来

  // ====================== UI 状态 ======================
  // 错误信息、结果等 UI 展示用状态
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  {PageName}ViewModel({FeatureName}Service? {featureName}Service})
      : _{featureName}Service = {featureName}Service ?? {FeatureName}Service();

  // ====================== 状态更新 ======================
  // setter 方法，修改状态后调用 notifyListeners()

  // ====================== 业务逻辑 ======================
  // 校验方法：返回错误信息，null 表示通过
  // 提交方法：AppToast.showLoading() → try/catch/finally → AppToast.dismiss()
  // 返回结果对象，由 Page 层决定后续操作（Toast、导航等）
}
```

#### 3. API 层模板

```dart
import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
// import models...

class {FeatureName}Api {
  static final {FeatureName}Api _instance = {FeatureName}Api._internal();
  {FeatureName}Api._internal();
  factory {FeatureName}Api() => _instance;

  /// {接口描述}
  Future<ServiceResponse> {methodName}({...} request) async {
    return await ApiService().post('/api/path', request.toJson());
  }

  /// {接口描述}（返回具体 Model）
  Future<{ResponseModel}?> {methodName}({...} request) async {
    ServiceResponse response = await ApiService().post('/api/path', request.toJson());
    if (response.data == null) return null;
    return {ResponseModel}.fromJson(response.data as Map<String, dynamic>);
  }
}
```

#### 4. Service 层模板

```dart
import 'package:odk_flutter_template/features/{feature_name}/api/{feature_name}_api.dart';
// import models...

class {FeatureName}Service {
  static final {FeatureName}Service _instance = {FeatureName}Service._internal();
  {FeatureName}Service._internal();
  factory {FeatureName}Service() => _instance;

  /// {方法描述}
  Future<ServiceResponse> {methodName}({...} request) async {
    return await {FeatureName}Api().{methodName}(request);
  }
}
```

---

### 三、公共组件使用规范

#### 1. 必须使用的公共组件（从 `app_widgets.dart` 导入）

| 组件 | 用途 | 替代 |
|------|------|------|
| `AppText` | 统一文本（title/body/second/tip） | 禁止直接使用 `Text` |
| `AppButton` | 主按钮（填充） | 禁止直接使用 `ElevatedButton` |
| `AppDebounceButton` | 防重复点击按钮（提交场景必用） | 禁止手动管理 isLoading |
| `AppOutlinedButton` | 次按钮（线框） | 禁止直接使用 `OutlinedButton` |
| `AppTextButton` | 文字按钮 | 禁止直接使用 `TextButton` |
| `AppIconButton` | 图标按钮 | 禁止直接使用 `IconButton` |
| `AppInput` | 通用输入框（支持表单校验） | 禁止直接使用 `TextFormField` |
| `AppInputPrefix` | 国际化输入框前缀（固定宽度对齐） | 禁止用空格对齐 |
| `ClearButton` | 输入框清除按钮 | 配合 AppInput suffixIcon 使用 |
| `AppCard` | 统一卡片容器 | 禁止直接写 Container 卡片 |
| `AppListItem` | 通用列表项 | 设置页/列表页必用 |
| `AppAvatar` | 通用头像（网络/本地/形状） | 禁止直接写 CircleAvatar |
| `AppGap` | 统一间距（hSmall/hNormal/hLarge 等） | 禁止直接写 SizedBox(height:) |
| `AppTip` | 小字提醒（整行背景） | 提示信息场景 |
| `AppCheckbox` | 勾选框 | 禁止直接使用 Checkbox |
| `AppAgreementCheckbox` | 协议勾选框 | 登录/注册协议场景 |
| `AppDivider` | 分割线 | 禁止直接使用 Divider |
| `AppDot` | 红点标记 | 未读/新功能提示 |
| `AppColors` | 统一颜色（适配明暗主题） | 禁止硬编码颜色值 |

#### 2. 通用页面骨架

| 组件 | 用途 |
|------|------|
| `AppPage` | 标准页面骨架（Scaffold + AppBar + body padding） |
| `BasicAppBar` | 标准 AppBar（通过 AppPage.title 配置） |

#### 3. 其他公共组件

| 组件 | 路径 | 用途 |
|------|------|------|
| `VerifyCodeInput` | `app_countdown/` | 验证码输入（带倒计时） |
| `AppToast` | `smart_dialog/` | Toast 提示 / Loading |
| `AppBottomDatePicker` | `app_widgets.dart` | 底部日期选择器 |

---

### 四、路由注册规范

#### 1. 在 `RouteNames` 中添加路由名称常量

```dart
class RouteNames {
  // ... 已有路由
  static const String {pageName} = '{PageName}';  // PascalCase
}
```

#### 2. 在 `RoutePaths` 中添加路由路径常量

```dart
class RoutePaths {
  // ... 已有路由
  static const String {pageName} = '/{pageName}';  // camelCase
}
```

#### 3. 在 `AppRouter.routes` 中注册路由

```dart
GoRoute(
  path: RoutePaths.{pageName},
  name: RouteNames.{pageName},
  builder: (context, state) => const {PageName}Page(),
),
```

#### 4. 如需传参，使用 `queryParameters`

```dart
// 跳转时
NavigatorUtils.pushNamed(
  RouteNames.{pageName},
  queryParameters: {'key': 'value'},
);

// 接收时
final value = state.uri.queryParameters['key'] ?? '';
```

#### 5. 白名单页面（无需登录即可访问）

在 `AppRouter.whiteList` 中添加路径：

```dart
static const List<String> whiteList = [
  // ... 已有白名单
  RoutePaths.{pageName},
];
```

---

### 五、导航工具使用规范

| 方法 | 导航栈行为 | 能否返回 | 典型场景 |
|------|-----------|---------|---------|
| `NavigatorUtils.goNamed()` | 替换整个栈 | ❌ 不能 | 登录→首页、退出→登录 |
| `NavigatorUtils.pushNamed()` | 压入栈顶 | ✅ 能 | 进入详情页、协议页 |
| `NavigatorUtils.pushReplacementNamed()` | 替换栈顶 | ❌ 被替换页不能 | 登录→首页（保留更深层历史） |
| `NavigatorUtils.pop()` | 弹出栈顶 | — | 返回上一页 |

---

### 六、编码细节规范

#### 1. 状态管理

- 使用 `Provider` + `ChangeNotifier`
- Page 中通过 `ChangeNotifierProvider` 创建 ViewModel
- 使用 `context.read<VM>()` 调用方法（不监听重建）
- 使用 `Selector<VM, Type>` 精准监听状态变化（避免不必要的重建）
- 禁止在 ViewModel 中管理 `isLoading`，防重复点击由 `AppDebounceButton` 处理

**`ChangeNotifierProvider` 与 `Selector` 的区别：**

| | `ChangeNotifierProvider` | `Selector` |
|---|---|---|
| **作用** | 创建并注入 ViewModel 到 Widget 树 | 精准监听 ViewModel 的某个属性 |
| **重建范围** | 不控制（取决于子组件用 watch 还是 Selector） | 只重建 builder 内的 Widget |
| **使用位置** | 页面顶层 `build()` 方法中 | 需要响应特定状态的子组件 |
| **类比** | "数据提供者" | "精准订阅者" |

```dart
// ChangeNotifierProvider：创建 ViewModel，让子树可以访问
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => SignInViewModel(),  // 创建并注入
    builder: (context, child) => _buildScaffold(context),
  );
}

// Selector：只监听 isPasswordLogin，该属性变化时才重建
Selector<SignInViewModel, bool>(
  selector: (_, vm) => vm.isPasswordLogin,
  builder: (_, isPasswordLogin, _) {
    return isPasswordLogin ? _passwordInput() : _verifyCodeInput();
  },
)

// context.read：调用方法，不监听任何变化，不会触发重建
context.read<SignInViewModel>().toggleLoginType();

// ❌ 禁止使用 context.watch：监听所有变化，任何 notifyListeners() 都会重建整个 Widget
// final vm = context.watch<SignInViewModel>();  // 不推荐
```

**核心原则：**
- `ChangeNotifierProvider` 是"提供数据"，`Selector` 是"精准消费数据"
- 两者配合使用：Provider 提供数据源，Selector 控制重建粒度
- 调用方法用 `context.read<VM>()`（不触发重建）
- 监听状态用 `Selector<VM, Type>`（精准重建）
- 禁止使用 `context.watch<VM>()`（全量重建，性能差）

#### 2. Loading 与 Toast

- 显示 Loading：`AppToast.showLoading()`
- 关闭 Loading：`AppToast.dismiss()`
- 显示提示：`AppToast.showToast('message')`
- Loading 由 ViewModel 内部管理（showLoading/dismiss 在 try/finally 中）

#### 2.1 防抖规范

项目中提供两种防抖组件，根据场景选择：

| 组件 | 适用场景 | 特点 |
|------|---------|------|
| `AppDebounceButton` | 页面级提交按钮 | 自带按钮 UI（填充样式 + Loading 动画） |
| `AppDebounceWrapper` | 任意可点击组件 | 不改变子组件外观，仅添加防抖逻辑 |

**使用原则：**
- 页面提交按钮（登录、注册、保存等）→ 使用 `AppDebounceButton`
- 弹窗内确认按钮、图标按钮、卡片点击等 → 使用 `AppDebounceWrapper` 包裹
- `AppToast.showAppConfirmDialog()` 内部已使用 `AppDebounceWrapper` 防抖，调用方无需额外处理
- 禁止手动编写 `isConfirming` 标志位等防抖逻辑，统一使用上述组件

```dart
// ✅ 页面提交按钮：AppDebounceButton
AppDebounceButton(
  text: L10nUtils.login,
  onTap: () => _login(context),
)

// ✅ 弹窗确认按钮：AppDebounceWrapper 包裹
AppDebounceWrapper(
  onTap: () async {
    SmartDialog.dismiss();
    onConfirm?.call();
  },
  child: AppTextButton(
    text: L10nUtils.confirm,
    onTap: null, // 点击由 AppDebounceWrapper 接管
  ),
)

// ✅ 图标按钮防抖：AppDebounceWrapper 包裹
AppDebounceWrapper(
  onTap: () => context.pushNamed(RouteNames.userInfo),
  child: AppIconButton(icon: Icons.edit, onTap: null),
)

// ❌ 禁止：手动管理防抖标志位
// bool isConfirming = false;
// if (isConfirming) return;
// isConfirming = true;
```

#### 3. 表单校验

- 使用 `GlobalKey<FormState>` + `Form` + `TextFormField`
- 校验方法：`formKey.currentState?.validate() ?? false`
- 输入框校验通过 `AppInput.validator` 传入
- 业务校验（如协议勾选）在 ViewModel 中处理，返回错误信息

#### 4. 国际化

- 所有用户可见文字必须使用 `L10nUtils.{key}` 获取
- 新增国际化文案需在 `lib/l10n/app_zh.arb` 和 `app_en.arb` 中添加

#### 5. 屏幕适配

- 使用 `flutter_screenutil`：`.w`（宽度）、`.h`（高度）、`.sp`（字号）
- 所有尺寸值必须带适配后缀，禁止使用裸数字

#### 6. 生命周期安全

- 异步回调中必须检查 `if (!mounted) return;`
- 控制器必须在 `dispose()` 中释放

#### 7. Mixin 复用

- 多个页面共享的 UI 逻辑（表单控制器、通用输入框、底部导航等）提取为 Mixin
- Mixin 定义格式：`mixin {Name}Mixin<T extends StatefulWidget> on State<T>`
- 参考示例：`AuthMixin`（登录/注册共享逻辑）

---

### 七、Model 生成规范

1. 创建 Model 文件，使用 `json_annotation` 注解：

```dart
import 'package:json_annotation/json_annotation.dart';

part '{model_name}.g.dart';

@JsonSerializable()
class {ModelName} {
  final String? field;

  {ModelName}({this.field});

  factory {ModelName}.fromJson(Map<String, dynamic> json) =>
      _${ModelName}FromJson(json);
  Map<String, dynamic> toJson() => _${ModelName}ToJson(this);
}
```

2. 运行代码生成：

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### 八、生成检查清单

生成完成后，请确认以下事项：

- [ ] 目录结构符合 Feature-First 分层架构
- [ ] Page 中无业务逻辑，仅做 UI 渲染 + 事件绑定
- [ ] ViewModel 继承 ChangeNotifier，业务逻辑可独立测试
- [ ] Service 为单例模式，编排 API 调用
- [ ] API 为单例模式，使用 ApiService 封装请求
- [ ] 所有用户可见文字使用 L10nUtils 国际化
- [ ] 所有尺寸使用 .w/.h/.sp 适配
- [ ] 使用公共组件（AppText/AppButton/AppInput/AppGap 等），未直接使用原生组件
- [ ] 提交按钮使用 AppDebounceButton，未手动管理 isLoading
- [ ] 异步回调中检查 mounted
- [ ] 控制器在 dispose 中释放
- [ ] 路由已在 RouteNames/RoutePaths/AppRouter 中注册
- [ ] 如需白名单，已添加到 whiteList
- [ ] Model 使用 json_annotation + json_serializable
```

---

## 使用示例

### 示例 1：生成注册登录页

```
请帮我生成一个注册登录页，严格遵循以下项目架构和编码规范：

[粘贴上方完整提示词模板，将 {页面描述} 替换为：包含手机号+验证码登录、手机号+密码登录、
验证码注册、协议勾选等功能的注册登录页面]
```

### 示例 2：生成用户信息编辑页

```
请帮我生成一个用户信息编辑页，严格遵循以下项目架构和编码规范：

[粘贴上方完整提示词模板，将 {页面描述} 替换为：支持修改昵称、头像、手机号等用户信息的编辑页面，
包含表单校验、图片选择上传、保存提交等功能]
```

### 示例 3：生成设置页

```
请帮我生成一个系统设置页，严格遵循以下项目架构和编码规范：

[粘贴上方完整提示词模板，将 {页面描述} 替换为：包含账号安全、通用设置、关于我们、
退出登录等列表项的设置页面，使用 AppPage + AppListItem 布局]
