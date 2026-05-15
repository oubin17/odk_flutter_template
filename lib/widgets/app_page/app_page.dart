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
/// - 不传 [padding] 时默认使用 `EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h)`
/// - 传 `EdgeInsets.zero` 可显式取消 padding
/// - body 为 ScrollView 时，调用方无需设置 ScrollView 的 padding，由 AppPage 统一管理
///
/// **使用示例：**
///
/// ```dart
/// // 最简用法：标题 + 滚动 body（自动添加默认 padding）
/// AppPage(
///   title: AppText('设置'),
///   body: SingleChildScrollView(child: _buildForm()),
/// )
///
/// // 列表页（无需给 ListView 设置 padding）
/// AppPage(
///   title: AppText('账号安全'),
///   body: ListView(children: [...]),
/// )
///
/// // 带保存按钮
/// AppPage(
///   title: AppText('修改密码'),
///   onSave: _handleSave,
///   body: SingleChildScrollView(child: _buildForm()),
/// )
///
/// // 自定义 padding
/// AppPage(
///   title: AppText('版本信息'),
///   padding: EdgeInsets.zero,
///   body: SingleChildScrollView(child: _buildContent()),
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
  /// - 默认值：`EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h)`
  /// - 传 `EdgeInsets.zero` 可显式取消 padding
  final EdgeInsetsGeometry? padding;

  /// 页面背景色（默认 AppColors.bgPage(context)）
  final Color? backgroundColor;

  /// 是否显示 AppBar（默认 true；设为 false 可隐藏 AppBar）
  final bool showAppBar;

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.bgPage(context),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
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

  /// 构建 body（统一添加 padding）
  Widget _buildBody(BuildContext context) {
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);

    return Padding(padding: effectivePadding, child: body);
  }
}
