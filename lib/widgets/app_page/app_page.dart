import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';

/// 通用页面骨架组件
///
/// 封装项目中最常见的 Scaffold 布局模式，统一页面背景色、AppBar 和 body 内边距。
/// body 的滚动方式由调用方自行决定，AppPage 不做限制。
///
/// **padding 规则：**
/// - 不传 [padding] 时：
///   - body 为 ScrollView / SingleChildScrollView → 不加外层 Padding（由 ScrollView 自管理，避免滚动时与 AppBar 产生固定间隙）
///   - body 为其他 Widget → 使用默认 [AppGap.pagePadding]
/// - 传 `EdgeInsets.zero` 可显式取消 padding
/// - 传自定义 [padding] 则始终生效
///
/// **使用示例：**
///
/// ```dart
/// // ScrollView 页面（自动跳过外层 padding，由 ScrollView 自管理）
/// AppPage(
///   title: AppText('设置'),
///   body: ListView(
///     padding: AppGap.pagePadding,
///     children: [...],
///   ),
/// )
///
/// // 非 ScrollView body（自动添加默认 padding）
/// AppPage(
///   title: AppText('设置'),
///   body: _buildForm(),
/// )
///
/// // 带保存按钮
/// AppPage(
///   title: AppText('修改密码'),
///   onSave: _handleSave,
///   body: SingleChildScrollView(child: _buildForm()),
/// )
///
/// // 无 appBar 页面
/// AppPage(
///   showAppBar: false,
///   body: SingleChildScrollView(child: _buildContent()),
/// )
/// ```
class AppPage extends StatelessWidget {
  /// 页面标题（优先级低于 [appBar]，设置后自动创建 BasicAppBar）
  final Widget? title;

  /// 保存按钮回调（设置后自动在 AppBar 右侧显示保存按钮）
  final VoidCallback? onSave;

  /// 保存按钮文案
  final String? saveText;

  /// 自定义 AppBar（设置后 [title] / [onSave] / [saveText] 将被忽略）
  final PreferredSizeWidget? appBar;

  /// 页面主体内容（调用方自行决定滚动方式）
  final Widget body;

  /// body 内边距
  /// - 不传时：ScrollView body 不加外层 padding，非 ScrollView body 使用默认 padding
  /// - 传 `EdgeInsets.zero` 可显式取消 padding
  /// - 传自定义值则始终作为外层 Padding 生效
  final EdgeInsetsGeometry? padding;

  /// 页面背景色（默认 AppColors.bgPage(context)）
  final Color? backgroundColor;

  /// 是否显示 AppBar（默认 true；设为 false 可隐藏 AppBar）
  final bool showAppBar;

  /// 底部导航栏（如 BottomNavigationBar、BottomAppBar 等）
  final Widget? bottomNavigationBar;

  const AppPage({
    super.key,
    this.title,
    this.onSave,
    this.saveText,
    this.appBar,
    required this.body,
    this.padding,
    this.backgroundColor,
    this.showAppBar = true,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.bgPage(context),
      extendBody: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  /// 构建 AppBar
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (!showAppBar) return null;

    // 自定义 appBar 优先
    if (appBar != null) return appBar;

    // 通过 title 构建 BasicAppBar
    if (title != null) {
      return BasicAppBar(title: title, onSave: onSave, saveText: saveText);
    }

    // 有保存按钮但无标题时，仍显示 AppBar
    if (onSave != null) {
      return BasicAppBar(onSave: onSave, saveText: saveText);
    }

    return null;
  }

  /// 构建 body
  ///
  /// ScrollView body 不加外层 Padding（避免滚动时与 AppBar 产生固定间隙），
  /// 由 ScrollView 自身的 padding 属性管理边距。
  Widget _buildBody(BuildContext context) {
    // 显式传了 padding，始终生效
    if (padding != null) {
      return Padding(padding: padding!, child: body);
    }

    // ScrollView 自管理 padding，不加外层 Padding
    if (body is ScrollView || body is SingleChildScrollView) {
      return body;
    }

    // 非 ScrollView body：使用默认 padding
    return Padding(padding: AppGap.pagePadding, child: body);
  }
}
