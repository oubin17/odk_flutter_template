---
name: "flutter-ui-design"
description: "Flutter UI 设计技能，指导 AI 生成高质量、有设计感的页面，避免 AI 生成感。Invoke when user says '设计页面', '创建页面', '生成 UI', 'Flutter UI', '页面设计', or requests to create/design a Flutter page/screen."
---

# Flutter UI Design Skill

> 目标：指导 AI 在 Flutter 跨端项目中产出"看起来像真人设计师做的"界面——符合 Material Design 3 平台特性、有克制而恰当的动效、不落入"AI生成感"的视觉套路，同时兼顾性能与可维护性。

## 触发词

- 设计页面
- 创建页面
- 生成 UI
- Flutter UI
- 页面设计
- 新页面

---

## 一、核心设计哲学（先于一切技术规范）

在套用任何规范之前，先回答三个问题，并把答案写进设计说明里：

1. **这个产品/页面是什么？给谁用？这一屏唯一要完成的任务是什么？**
2. **品牌或内容本身有没有可以借用的视觉线索？**（行业属性、内容调性、目标用户的审美偏好）
3. **这一屏的"记忆点"是什么？** 只允许有一个——把克制留给其他地方。

凡是脱离具体产品语境、可以套用在"任何 App 任何页面"上的设计决策（默认紫色种子色、统一的渐变卡片、千篇一律的图标+标题+副标题结构），都是需要警惕的信号。AI 容易陷入"语法正确但毫无个性"的设计，这套方案的大部分内容就是为了对抗这种倾向。

---

## 二、Material Design 3 规范基线

### 2.1 颜色系统（ColorScheme）

- 用 `ColorScheme.fromSeed(seedColor: ..., brightness: ...)` 生成基础色板，但 **seed 颜色必须来自品牌或内容**，不要默认用 Flutter 文档示例里的紫色（`Colors.deepPurple`）——这是目前"一眼AI味"最强的信号之一。
- 善用 M3 的语义角色（roles）而不是直接写死颜色：`primary` / `onPrimary` / `primaryContainer` / `secondaryContainer` / `surface` / `surfaceContainerHighest` / `error` 等，保证浅色/深色模式自动适配。
- 如果产品需要多套强调色（如状态标签：成功/警告/危险），用 `ColorScheme` 之外的自定义 `ThemeExtension` 扩展语义色，而不是散落在各 Widget 里硬编码十六进制值。
- M3 的 Surface Tint（表面色调叠加）替代了 M2 大量使用阴影制造层级的方式，优先用 `surfaceContainer` 系列的色阶区分层级，减少阴影堆叠带来的"廉价感"。

```dart
final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF2D5B4E), // 取自品牌主色，而非默认紫色
  brightness: Brightness.light,
);

ThemeData(
  colorScheme: colorScheme,
  useMaterial3: true,
);

// 或使用项目已有的 AppColors
AppColors.primary        // 主色
AppColors.onPrimary      // 主色上的文字
AppColors.surface        // 背景色
AppColors.onSurface      // 背景上的文字
```

### 2.2 字体排版（Typography / TextTheme）

- 基于 M3 的 type scale（display / headline / title / body / label，每类大中小）定制 `TextTheme`，不要全局只用一个 `fontSize` 改改大小了事。
- 中文场景注意：M3 默认字阶（如 `displayLarge` 57px）是为英文字重设计的，中文字号建议整体下调 10%-15%，并适当增加行高（`height: 1.4~1.6`），避免中文显得过大过空。
- 用字重（`FontWeight`）和字间距（`letterSpacing`）制造层级，而不是仅靠改变字号——这是让排版显得"被设计过"而非"被缩放过"的关键。

```dart
textTheme: TextTheme(
  displayLarge: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w600, height: 1.1),
  bodyLarge: TextStyle(fontSize: 16.sp, height: 1.5),
  labelSmall: TextStyle(fontSize: 12.sp, height: 1.4, letterSpacing: 0.4),
)
```

**项目文字层级（使用 AppText）：**

| 层级 | 用途 | AppText 类型 | 字号 |
|------|------|-------------|------|
| **H1** | 页面标题 | `AppText.title()` | 24-28sp |
| **H2** | 区块标题 | `AppText.body()` (bold) | 18-20sp |
| **Body** | 正文内容 | `AppText.body()` | 14-16sp |
| **Secondary** | 次要信息 | `AppText.second()` | 12-14sp |
| **Tip** | 提示/说明 | `AppText.tip()` | 10-12sp |

### 2.3 形状（Shape）与组件语义

- M3 提供形状角色：`extraSmall`(4dp)/`small`(8dp)/`medium`(12dp)/`large`(16dp)/`extraLarge`(28dp)。统一通过 `ShapeBorder` 主题配置，不要每个组件随手写一个 `BorderRadius.circular()`。
- 全局圆角一旦定调（比如卡片用 16dp、按钮用 20dp/全圆），全 App 保持一致，避免"这个页面圆角 8，那个页面圆角 24"的随意感。

| 组件类型 | 圆角大小 | 示例 |
|---------|---------|------|
| **小组件** | 4-8dp | 按钮、输入框、标签 |
| **卡片** | 12-16dp | AppCard、列表项 |
| **大组件** | 16-28dp | 底部弹窗、模态框 |
| **全屏** | 0dp | 页面容器 |

- 优先使用 M3 新组件而非沿用 M2 旧组件：
  - 按钮：`FilledButton` / `FilledButton.tonal` / `OutlinedButton` / `TextButton`
  - 导航：`NavigationBar`（替代 `BottomNavigationBar`）、`NavigationDrawer`、`NavigationRail`（宽屏/平板自适应）
  - 输入：`SegmentedButton`、M3 风格 `TextField`（filled 风格）

### 2.4 自适应主题（明暗模式 & 动态取色）

- 同时提供 light/dark 两套 `ColorScheme`，深色模式不是简单"反色"，M3 深色模式建议降低饱和度、提高表面层级对比的细腻程度。
- 如果目标平台是 Android 12+，可考虑支持 Material You 动态取色（`DynamicColorBuilder`），让 App 跟随系统壁纸色。

---

## 三、色彩搭配原则（避免过度设计）

### 3.1 色彩层次

```
主色 (Primary)      → 主要按钮、重要图标、导航激活态
次色 (Secondary)    → 辅助按钮、次要信息、装饰元素
背景 (Surface)      → 页面背景、卡片背景
文字 (OnSurface)    → 正文、标题
弱化文字            → 提示文字、次要信息
```

### 3.2 4-6 色原则

- **4–6 个具名色**原则：一个主色、一个辅助色、一个点缀色（用于强调/CTA）、加上中性灰阶。
- 点缀色全局只用于最需要被注意的 1-2 个元素（主 CTA、未读红点），不要让每个卡片都带渐变。
- 中性色阶要足够细（至少 5-7 级灰），用于划分背景/卡片/分割线/禁用态。

### 3.3 渐变慎用

当下 AI 生成界面最容易被识别的特征之一就是"无意义的紫蓝/粉橙渐变背景"。只有当渐变本身承载语义（如温度、进度、深浅层级）时才使用。

| 陷阱 | 正确做法 |
|------|---------|
| ❌ 使用过多颜色 | ✅ 限制在 4-6 种具名色 |
| ❌ 高饱和度大面积使用 | ✅ 主色用于强调，背景用中性色 |
| ❌ 渐变滥用 | ✅ 渐变仅用于承载语义（进度、状态） |
| ❌ 阴影堆叠 | ✅ 用 Surface Tint / surfaceContainer 区分层级 |

### 3.4 色彩心理学

| 场景 | 推荐色系 | Flutter 示例 |
|------|---------|-------------|
| **金融/安全** | 蓝色、绿色 | `Colors.blue`, `Colors.teal` |
| **社交/娱乐** | 橙色、粉色 | `Colors.orange`, `Colors.pink` |
| **医疗/健康** | 绿色、白色 | `Colors.green`, `Colors.white` |
| **教育/知识** | 蓝色、紫色 | `Colors.indigo`, `Colors.deepPurple` |

---

## 四、排版层次

### 4.1 文字层级

- 一屏内文字层级建议不超过 4 级（标题、副标题/摘要、正文、辅助说明），层级越少越克制，越显专业。
- 中文排版避免"标题加粗+正文加粗"的扁平对比，用字号差 + 字重差 + 颜色明度差三者组合制造层次。

### 4.2 行高与字重

| 类型 | 行高 | 字重 |
|------|------|------|
| 标题 | 1.2-1.4 | Bold (w700) |
| 正文 | 1.4-1.6 | Regular (w400) |
| 提示 | 1.4-1.5 | Light (w300) |

### 4.3 行宽控制

正文每行中文字符数建议 18-24 字（约等于西文 60-75 字符），过宽的整段文字在移动端会显得像未经设计的网页直接塞进 App。

### 4.4 排版间距（8dp 网格）

采用 **8dp 网格**作为间距基准（4 / 8 / 12 / 16 / 24 / 32 / 48...），所有 `padding`/`margin`/`SizedBox` 间距从这个数列里取值，杜绝随手写 `13` `17` 这种数字。

```dart
// 使用 AppGap 统一间距
AppGap.hSmall()    // 8.h  - 紧凑间距（同级元素）
AppGap.hNormal()   // 16.h - 标准间距（段落间）
AppGap.hLarge()    // 24.h - 大间距（区块间）
AppGap.wSmall()    // 8.w  - 水平紧凑
AppGap.wNormal()   // 16.w - 水平标准
```

---

## 五、空间布局

### 5.1 留白即设计

避免把屏幕"填满"。常见 AI 生成感陷阱是每屏都密密麻麻铺满卡片网格——适当增加呼吸空间（页面四周留白、卡片间距加大）会立刻显得更精致。

### 5.2 避免过度卡片化

不是所有内容都需要塞进带阴影圆角的卡片。列表项可以用纯分割线呈现，信息分组可以用色块/留白替代卡片边框，过度卡片化是 M2 时代遗留的"安全选择"，也是当下识别度很高的模板感来源。

### 5.3 页面结构

```dart
// 标准页面骨架（使用 AppPage）
AppPage(
  title: '页面标题',
  body: Column(
    children: [
      // 1. 主要内容区（占 60-70%）
      Expanded(child: _buildContent()),
      
      // 2. 底部操作区（固定高度）
      _buildBottomActions(),
    ],
  ),
)
```

### 5.4 卡片布局

```dart
// 卡片内部结构（使用 AppCard）
AppCard(
  child: Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(children: [标题, 操作按钮]),
        AppGap.hSmall(),
        
        // 内容区
        内容Widget,
        AppGap.hSmall(),
        
        // 底部信息（可选）
        次要信息,
      ],
    ),
  ),
)
```

### 5.5 列表布局

```dart
// 使用 AppListItem 统一列表项
AppListItem(
  title: '标题',
  subtitle: '描述',  // 可选
  trailing: Icon(...),  // 可选
  onTap: () => ...,  // 可选
)
```

### 5.6 响应式布局

```dart
// 使用 flutter_screenutil 适配
Container(
  width: 100.w,   // 屏幕宽度百分比
  height: 50.h,   // 屏幕高度百分比
  padding: EdgeInsets.all(16.w),
)

// 字号适配
TextStyle(fontSize: 14.sp)
```

### 5.7 跨端意识

Flutter 的"跨端"卖点要求同一套设计在手机、平板、桌面/Web 上都合理：
- 用 `NavigationRail`/`NavigationDrawer` 在宽屏下替换 `NavigationBar`
- 用 `LayoutBuilder`/断点系统切换单列/多列布局
- 不要简单地把手机布局拉伸铺满大屏

---

## 六、动态交互模式库

> 原则：**一屏一个"重点动效"**，其余保持安静克制。所有动效优先复用 Flutter 内置过渡。

### 6.1 页面过渡动画

- 全局过渡：通过 `PageTransitionsTheme` 按平台区分（iOS 用 `CupertinoPageTransitionsBuilder`，Android 用 `FadeForwardsPageTransitionsBuilder`/`ZoomPageTransitionsBuilder`）。
- 共享元素过渡：列表点进详情页时，用 `Hero` Widget 让图片/标题位置连续过渡，这是提升"原生高级感"性价比最高的动效之一。

```dart
theme: ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
)

// Hero 过渡
Hero(
  tag: 'item-${item.id}',
  child: Image(...),
)
```

### 6.2 微交互反馈

- 按压反馈：M3 组件自带 ripple/state layer，不要用 `GestureDetector` 包一个静态 `Container` 而丢失反馈层。
- 状态切换动效：`AnimatedContainer` / `AnimatedSwitcher` / `AnimatedCrossFade` 用于颜色、尺寸、内容切换的轻量过渡（200-300ms，曲线用 `Curves.easeOutCubic`）。
- 点赞/收藏一类的"小确认"动效：可用 `TweenAnimationBuilder` 做缩放回弹（scale 1 → 1.2 → 1），时长建议 150-250ms。

```dart
// 点击涟漪效果（Material 3 内置）
InkWell(
  onTap: () => ...,
  borderRadius: BorderRadius.circular(12.w),
  child: Container(...),
)

// 按钮点击（使用 AppDebounceButton）
AppDebounceButton(
  onPressed: () => ...,
  text: '提交',
)

// 加载状态动画
AppToast.showLoading()  // 显示 loading
AppToast.dismiss()      // 关闭 loading
```

### 6.3 滚动效果

- 列表进场：用错位渐入（staggered fade + slide），首屏列表项依次延迟 30-50ms 出现，比所有项同时弹出更有质感——但**只用一次**，不要每次滚动都重复触发。
- 视差/吸顶：`CustomScrollView` + `SliverAppBar`（`flexibleSpace` + `pinned: true`）做封面图随滚动收缩、标题渐显的效果。
- 下拉刷新：`RefreshIndicator`（Android 风格）或自定义 Cupertino 风格刷新控件。
- 滚动物理效果：`BouncingScrollPhysics`（iOS 风格）vs `ClampingScrollPhysics`（Android 风格），用 `ScrollConfiguration` 按平台适配。

```dart
// 下拉刷新 + 上拉加载（使用 AppRefreshList）
AppRefreshList(
  onRefresh: () async => ...,
  onLoadMore: () async => ...,
  child: ListView(...),
)

// 视差吸顶
CustomScrollView(
  slivers: [
    SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: 200.h,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('标题'),
        background: Image(...),
      ),
    ),
    SliverList(delegate: SliverChildBuilderDelegate(...)),
  ],
)
```

### 6.4 状态切换动画

```dart
// 展开/收起动画
AnimatedSize(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: isExpanded ? FullContent() : SummaryContent(),
)

// 切换动画
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: isLoading ? LoadingWidget() : ContentWidget(),
)
```

### 6.5 加载与空状态

- 骨架屏（Shimmer）：内容加载中用灰色块 + 流光扫过动效占位，优于纯 `CircularProgressIndicator` 转圈。
- 空状态/错误状态：给一个简洁的插画/图标 + 一句具体、口语化、可执行的文案，并配一个轻量的 fade-in。

```dart
// 空状态处理
if (items.isEmpty)
  EmptyStateWidget(
    image: Assets.images.emptyState,
    title: '暂无数据',
    action: AppButton(text: '刷新', onPressed: ...),
  )
else
  ListView(children: items)

// 加载状态
if (isLoading)
  LoadingWidget()
else if (hasError)
  ErrorWidget(error: error)
else
  ContentWidget(data: data)
```

### 6.6 动效使用的"刹车点"

以下情况应该主动减少/去掉动效：

- 同一屏内已有 2 个以上动效在同时播放（视觉噪音）。
- 动效与内容无关，纯粹"为了显得有科技感"（如毫无意义的粒子背景、持续呼吸的光晕）。
- 用户需要频繁重复的操作路径上加了长动效（如每次返回都放 600ms 转场）。
- 必须支持 `MediaQuery.disableAnimations` / 系统"减少动态效果"开关。

---

## 七、性能优化与视觉平衡

### 7.1 性能原则

| 原则 | 说明 |
|------|------|
| **60fps** | 动画帧率不低于 60fps |
| **const 构造** | 所有静态 Widget 标注 `const`，减少 rebuild |
| **缩小 rebuild** | 用 `Selector`/`ValueListenableBuilder` 精确订阅状态 |
| **RepaintBoundary** | 隔离动画区域，避免全局重绘 |

### 7.2 图片优化

```dart
// 使用缓存图片
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 200,  // 限制内存缓存尺寸
)

// 本地图片预加载
precacheImage(AssetImage('assets/image.png'), context)
```

### 7.3 列表优化

```dart
// 长列表使用 ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  itemExtent: 80.h,  // 估算项高度（提升滚动性能）
)

// 使用 AutomaticKeepAlive 保持状态
class ItemWidget extends StatefulWidget {
  @override
  bool get wantKeepAlive => true;
}
```

### 7.4 性价比排序

视觉精致度与成本的取舍排序（性价比从高到低）：

**Hero 过渡 > 列表错位进场 > 微交互反馈 > 骨架屏 > 视差吸顶 > 毛玻璃/粒子特效**

预算有限时优先做前面几项。

---

## 八、组件复用与主题一致性

### 8.1 使用项目公共组件

**必须使用**（禁止原生组件）：

| 原生组件 | 替换为 | 说明 |
|---------|-------|------|
| `Text` | `AppText` | 统一文字样式 |
| `ElevatedButton` | `AppButton` / `AppDebounceButton` | 统一按钮 |
| `TextFormField` | `AppInput` | 统一输入框 |
| `SizedBox(height:)` | `AppGap.h()` | 统一间距 |
| `Divider` | `AppDivider` | 统一分割线 |
| `Container` (卡片) | `AppCard` | 统一卡片 |
| `CircleAvatar` | `AppAvatar` | 统一头像 |
| `Checkbox` | `AppCheckbox` | 统一勾选框 |

### 8.2 设计令牌（Design Tokens）

用 `ThemeExtension` 把设计令牌纳入主题系统：

```dart
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.success,
    required this.warning,
    required this.spacingUnit,
    required this.motionShort,
    required this.motionCurve,
  });

  final Color success;
  final Color warning;
  final double spacingUnit; // 8.0
  final Duration motionShort; // 200ms
  final Curve motionCurve; // Curves.easeOutCubic

  @override
  AppTokens copyWith({...}) => AppTokens(...);

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {...}
}

// 使用
final tokens = Theme.of(context).extension<AppTokens>()!;
```

### 8.3 禁止硬编码

颜色/间距/字号/圆角凡是出现"裸数字"或 `Colors.xxx` 字面量散落在业务代码里，都应改为引用 `Theme.of(context)` 或 `AppTokens`。

### 8.4 组件复用模式

```dart
// 创建可复用的业务组件
class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  
  const UserAvatar({this.avatarUrl, this.size = 48});
  
  @override
  Widget build(BuildContext context) {
    return AppAvatar(
      imageUrl: avatarUrl,
      size: size.w,
    );
  }
}
```

---

## 九、避免"AI生成感"的策略

### 9.1 最容易被识别为"AI生成"的视觉模式

| 陷阱 | 表现 | 替代策略 |
|------|------|---------|
| **默认种子紫色** | 全 App 主色是 Material 默认的紫/蓝紫色 | 从品牌色或内容主题取色，做 `fromSeed` |
| **无意义渐变** | 卡片/背景大量使用紫蓝、粉橙渐变 | 渐变仅用于承载语义（进度、状态），其余用纯色+留白 |
| **过度卡片化** | 每个信息单元都套一层圆角卡片+阴影 | 部分内容用分割线/留白分组，减少视觉噪音 |
| **千篇一律的"图标+大标题+一行说明"** | Feature 介绍、空状态、引导页全部套用此结构 | 根据内容特性选不同的呈现（数据可视化、对比表格、真实截图） |
| **滥用毫无意义的动效** | 持续呼吸光晕、漂浮粒子、everything fade-in | 一屏一个重点动效，其余保持静止 |
| **泛用 Emoji/Clipart 风插画** | 大量通用风格插画拼贴，与产品内容无关 | 优先用产品真实截图/数据/图标系统 |
| **文案套话** | "开启你的精彩旅程"、"探索无限可能"等空洞文案 | 用具体、可执行、第一人称视角的文案 |
| **全局统一无差别圆角/阴影强度** | 不论按钮/卡片/弹窗一律用同一组随手设置的值 | 建立清晰的形状/高度角色体系并保持克制差异 |

### 9.2 给 AI 的执行性约束

1. **先确定产品语境再设计**：在生成 UI 前先用一两句话明确"这是什么产品、给谁用、这一屏的核心任务"，并据此选择 seed color 与字体基调。
2. **强制做"一个记忆点"声明**：每个页面生成前，先说明这一屏的"signature 元素"是什么，其余部分必须保持克制。
3. **强制色彩令牌数量上限**：设计输出中明确列出 4-6 个具名颜色及其用途，超出范围的颜色不允许出现。
4. **动效数量预算**：单屏新增动效不超过 2 类（如"列表错位进场 + 按钮按压反馈"），其余交互复用 Material 默认状态层。
5. **文案自查**：生成的任何 UI 文案，重新读一遍是否"换成任何其他 App 都成立"——如果成立，重写为更具体、贴合本产品上下文的表达。
6. **强制对照检查环节**：在最终产出前，与 9.1 表格逐项核对，如果命中任意一条陷阱且没有特殊理由，要求修改。

### 9.3 真实感设计技巧

```dart
// 1. 使用真实数据结构（而非占位符）
Text(user.name ?? '未设置')  // 而非 Text('用户名')

// 2. 添加空状态处理
if (items.isEmpty)
  EmptyStateWidget(message: '暂无数据')
else
  ListView(children: items)

// 3. 添加加载状态
if (isLoading)
  LoadingWidget()
else if (hasError)
  ErrorWidget(error: error)
else
  ContentWidget(data: data)

// 4. 添加边界情况处理
// 输入框：最大长度、格式校验
// 图片：加载失败显示占位图
// 列表：下拉刷新、上拉加载
```

### 9.4 情感化设计

```dart
// 添加情感化元素
// 1. 空状态插图
EmptyStateWidget(
  image: Assets.images.emptyState,
  title: '暂无数据',
  action: AppButton(text: '刷新', onPressed: ...),
)

// 2. 成功反馈
AppToast.showToast('操作成功', icon: Icons.check_circle)

// 3. 引导提示
AppTip(text: '点击右上角可以分享给朋友')
```

---

## 十、推荐工作流程

类似设计工作室的"提案-评审-执行"流程：

### 10.1 定调（Brief）

明确产品/页面定位、目标用户、核心任务、是否已有品牌色/字体资产。

### 10.2 令牌规划（Token Plan）

在动手写 Widget 代码前，先以文字形式给出：
- 颜色：4-6 个具名色 + 用途
- 字体：展示字体 + 正文字体 + 字阶（5-7 级）
- 形状/间距：圆角等级、8dp 间距基准
- 动效基调：本页面唯一的"重点动效"是什么

### 10.3 自我评审（Critique）

对照第 9 章陷阱清单逐项检查规划，凡是"换个产品也能直接套用"的部分，重新设计。

### 10.4 编码实现（Build）

按确认后的令牌实现 `ThemeData`/`ThemeExtension`，再实现具体页面，组件优先复用已有原子组件层。

### 10.5 二次评审（Re-critique）

完成后再次自检：
- 动效是否过多
- 卡片是否过度使用
- 文案是否空泛
- 深色模式是否测试过
- 宽屏/平板布局是否适配
- 性能关键路径是否验证过帧率

---

## 十一、页面设计检查清单

### 视觉层面
- [ ] Seed Color 来自品牌/内容，而非默认值
- [ ] 颜色令牌数量 ≤ 6，全部具名且语义清晰
- [ ] 文字层级清晰（不超过 4 级）
- [ ] 间距有层次（8dp 网格）
- [ ] 圆角统一协调
- [ ] 无过度装饰元素
- [ ] 无过度卡片化

### 交互层面
- [ ] 每屏动效不超过 2 类，且与内容相关
- [ ] 点击有涟漪/缩放反馈
- [ ] 加载有 loading 状态
- [ ] 状态切换有过渡动画
- [ ] 滚动流畅（使用 builder）
- [ ] 页面过渡按平台区分

### 功能层面
- [ ] 空状态有处理
- [ ] 错误状态有处理
- [ ] 输入有校验
- [ ] 提交有防抖

### 规范层面
- [ ] 使用 AppText/AppButton/AppInput/AppGap/AppCard
- [ ] 使用 .w/.h/.sp 适配
- [ ] 文字使用 L10nUtils 国际化
- [ ] 异步回调检查 mounted
- [ ] 控制器在 dispose 释放
- [ ] 颜色/间距/字号无业务代码硬编码

### 跨端层面
- [ ] 明暗模式均已设计并测试
- [ ] 宽屏/平板布局已做自适应
- [ ] 支持"减少动态效果"开关

### 文案层面
- [ ] 文案具体、口语化、可执行
- [ ] 无空洞套话

---

## 十二、示例：生成高质量页面

### 用户输入模板

```
请使用 flutter-ui-design skill，帮我设计一个用户列表页面：
- 展示用户头像、姓名、简介
- 支持下拉刷新、上拉加载
- 点击进入用户详情
- 空状态显示插图
- 需要登录才能访问
```

### AI 生成流程

1. **定调**：用户列表页，展示用户信息，核心任务是"浏览并选择用户"
2. **令牌规划**：
   - 颜色：主色（品牌蓝）、辅助色（灰色）、点缀色（未读红点）
   - 动效：列表错位进场 + Hero 过渡
3. **实现要点**：
   - 结构：AppPage + AppRefreshList + AppListItem
   - 动画：列表淡入、点击涟漪、Hero 过渡
   - 状态：加载、空状态、错误状态
   - 交互：防抖点击、下拉刷新、上拉加载
   - 规范：AppText/AppAvatar/AppGap、.w/.h/.sp

---

## 十三、参考资料

| 文档 | 说明 |
|------|------|
| [AGENTS.md](file:///AGENTS.md) | 项目架构规范、公共组件 |
| [Material Design 3](https://m3.material.io/) | Google 官方设计规范 |
| [Flutter Animation](https://docs.flutter.dev/ui/animations) | Flutter 动画官方文档 |
| [prompt_new_page.md](file:///docs/prompt_new_page.md) | 新页面开发完整规范 |