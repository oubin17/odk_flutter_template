export 'package:odk_flutter_template/widgets/app_widgets/app_debounce_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/common/theme/app_theme.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';

/// 全局统一颜色（适配明暗主题）
class AppColors {
  // ===================== 主色系列（梯度成组：自动适配明暗主题） =====================

  /// 主色-超浅（最淡背景、悬浮层背景）
  static Color primary50(BuildContext context) => AppTheme.primary50(context);

  /// 主色-浅（标签背景、头像背景、弱强调）
  static Color primaryLight(BuildContext context) =>
      AppTheme.primaryLight(context);

  /// 主色（按钮、强调、图标）
  static Color primary(BuildContext context) => AppTheme.primary(context);

  /// 主色-深（按压态、文字高亮、深强调）
  static Color primaryDark(BuildContext context) =>
      AppTheme.primaryDark(context);

  /// 主色-深（按压态、文字高亮、深强调）
  static Color primaryDeepDark(BuildContext context) =>
      AppTheme.primaryDeepDark(context);

  // ===================== 背景/边框系列 =====================
  /// 页面背景
  static Color bgPage(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  /// 次要背景
  static Color bgSecond(BuildContext context) =>
      AppTheme.secondBgColor(context);

  /// 卡片/输入框背景
  static Color card(BuildContext context) => Theme.of(context).cardColor;

  /// 分割线
  static Color divider(BuildContext context) => Theme.of(context).dividerColor;

  // ===================== 文字色系列（无改动，保留你的原有配置） =====================
  static Color textMain(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withAlpha(225)
      : const Color(0xFF1D2129);
  static Color textSecond(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withAlpha(170)
      : const Color(0xFF4E5969);
  static Color textGray(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withAlpha(128)
      : const Color(0xFF86909C);
  static const Color textWhite = Colors.white;

  // 状态色
  static const Color success = Color(0xFF00B42A);
  static const Color error = Color(0xFFF53F3F);
  static const Color errorLight = Color(0xFFFDE8E8); // 错误色-浅背景（类似 red.shade50）
  static const Color errorBorder = Color(0xFFFBC2C2); // 错误色-边框（类似 red.shade200）
  static const Color errorDark = Color(0xFFCB2634); // 错误色-深文字（类似 red.shade700）
  static const Color warning = Color(0xFFFF7D00);

  //其他特殊颜色，不跟随系统
  static const Color iconColor = Color(0xFF4E5969);
}

/// 统一文本组件（适配主题+暗黑模式）
class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final int? maxLines;
  final TextAlign? align;

  // 基础构造
  const AppText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.weight,
    this.maxLines,
    this.align,
  });
  // 快速标题
  const AppText.customerTitle(
    this.text,
    this.size,
    this.weight, {
    super.key,
    this.color,
  }) : maxLines = null,
       align = null;

  // 快速标题
  AppText.title(this.text, {super.key, this.color})
    : size = 32.sp,
      weight = FontWeight.w500,
      maxLines = null,
      align = null;

  // 正文（最常用）
  AppText.body(this.text, {super.key, this.color})
    : size = 28.sp,
      weight = FontWeight.normal,
      maxLines = null,
      align = null;

  // 次要文字
  AppText.second(this.text, {super.key, this.color})
    : size = 26.sp,
      weight = FontWeight.normal,
      maxLines = null,
      align = null;

  // 小字提示
  AppText.tip(this.text, {super.key, this.color})
    : size = 24.sp,
      weight = FontWeight.normal,
      maxLines = null,
      align = null;

  @override
  Widget build(BuildContext context) {
    Color getDefaultColor() {
      if (color != null) return color!;
      if (size == 32.sp) return AppColors.textMain(context);
      if (size == 28.sp) return AppColors.textMain(context);
      if (size == 26.sp) return AppColors.textSecond(context);
      if (size == 24.sp) return AppColors.textGray(context);
      return AppColors.textMain(context);
    }

    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: size,
        color: getDefaultColor(),
        fontWeight: weight,
        height: 1.4,
      ),
    );
  }
}

/// 小字提醒（整行背景 + 自定义高度 + 保留适配内边距）
class AppTip extends StatelessWidget {
  final String tip;

  /// 自定义高度（传值则固定高度，不传自适应）
  final double? height;

  const AppTip({super.key, this.tip = '', this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 👇 关键1：默认占满父容器宽度 → 背景铺满整行
      width: double.infinity,
      // 👇 关键2：强制约束高度，传入的高度100%生效
      height: height,
      // ✅ 你的原有内边距 完全保留（适配单位，不修改）
      padding: EdgeInsets.only(left: 20.w, top: 16.h, bottom: 16.h),
      color: AppColors.bgSecond(context),
      // 空内容时渲染空组件，不影响布局
      child: tip.isEmpty ? const SizedBox() : AppText.second(tip),
    );
  }
}

/// 统一间距组件
class AppGap {
  // ===================== 预设垂直间距 =====================
  static Widget hSuperSmall = SizedBox(height: 10.h);
  static Widget hSmall = SizedBox(height: 20.h);
  static Widget hNormal = SizedBox(height: 30.h);
  static Widget hLarge = SizedBox(height: 40.h);
  static Widget hXL = SizedBox(height: 60.h);

  // ===================== 预设水平间距 =====================
  static Widget wSuperSmall = SizedBox(width: 10.w);
  static Widget wSmall = SizedBox(width: 20.w);
  static Widget wNormal = SizedBox(width: 30.w);
  static Widget wLarge = SizedBox(width: 40.w);
  static Widget wXL = SizedBox(width: 60.w);

  // ===================== 自定义间距 =====================

  /// 自定义垂直间距
  /// [height] 逻辑像素值，内部自动适配屏幕（.h）
  ///
  /// 示例：AppGap.h(24) → SizedBox(height: 24.h)
  static Widget h(double height) => SizedBox(height: height.h);

  /// 自定义水平间距
  /// [width] 逻辑像素值，内部自动适配屏幕（.w）
  ///
  /// 示例：AppGap.w(24) → SizedBox(width: 24.w)
  static Widget w(double width) => SizedBox(width: width.w);
}

/// 统一卡片
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? bg;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.bg,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: bg ?? AppColors.card(context),
        borderRadius: BorderRadius.circular(radius ?? 16.w),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.w,
                  offset: Offset(0, 4.w),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// 主按钮（填充）
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool disabled;
  final double? height;
  final Color? bgColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.disabled = false,
    this.height,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 88.h,
      child: ElevatedButton(
        onPressed: disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? AppColors.textGray(context)
              : (bgColor ?? AppColors.primary(context)),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: AppText(
          text,
          color: AppColors.textWhite,
          size: 32.sp,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 统一图标组件（纯展示，适配主题+暗黑模式）
/// 用于列表项左侧图标、状态图标等纯展示场景
/// 如需可点击的图标按钮，请使用 [AppIconButton]
class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const AppIcon(this.icon, {super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 28.w,
      color: color ?? AppColors.textSecond(context),
    );
  }
}

/// 图标按钮（通用：返回、刷新、更多、删除等）
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;
  final double? size; // 图标大小
  final double? btnSize; // 按钮整体尺寸
  final Color? iconColor;
  final Color? bgColor;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.disabled = false,
    this.size,
    this.btnSize,
    this.iconColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final double actualBtnSize = btnSize ?? 60.w;
    final bool hasBg = bgColor != null && bgColor != Colors.transparent;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(hasBg ? actualBtnSize / 2 : 16.w),
      child: Container(
        width: actualBtnSize,
        height: actualBtnSize,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(hasBg ? actualBtnSize / 2 : 16.w),
        ),
        child: Icon(
          icon,
          size: size ?? 28.w,
          color: disabled
              ? AppColors.textGray(context)
              : (iconColor ?? AppColors.primary(context)),
        ),
      ),
    );
  }
}

/// 次按钮（线框）
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? sideColor;
  final Color? textColor;
  final double? height;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.sideColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSideColor = sideColor ?? AppColors.primary(context);
    final effectiveTextColor = textColor ?? AppColors.primary(context);
    return SizedBox(
      width: double.infinity,
      height: height ?? 72.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveSideColor, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: AppText(text, color: effectiveTextColor, size: 28.sp),
      ),
    );
  }
}

/// 文字按钮
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final double? size;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
      child: AppText(
        text,
        color: color ?? AppColors.primary(context),
        size: size ?? 26.sp,
      ),
    );
  }
}

/// 加载状态按钮
class AppLoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool disabled;

  const AppLoadingButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 88.h,
      child: ElevatedButton(
        onPressed: isLoading || disabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading || disabled
              ? AppColors.textGray(context)
              : AppColors.primary(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2.w)
            : AppText(
                text,
                color: AppColors.textWhite,
                size: 32.sp,
                weight: FontWeight.w500,
              ),
      ),
    );
  }
}

/// /// 通用输入框（支持表单校验 + 主题适配）
class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscure;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // 统一保留，兼容图标/文字
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool hideUnderline;

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onTap;

  const AppInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.hideUnderline = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      onTap: onTap,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 26.sp,
          color: AppColors.textGray(context),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 26.sp,
          color: AppColors.textGray(context),
        ),
        // ====================== 安全版前缀（无遮挡+可输入） ======================
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1, // 🔥 防遮挡核心：不撑满宽度
                  child: prefixIcon,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        // ====================================================================
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: suffixIcon,
              )
            : null,
        border: hideUnderline
            ? InputBorder.none
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryLight(context),
                  width: 1.w,
                ),
              ),
        enabledBorder: hideUnderline
            ? InputBorder.none
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryLight(context),
                  width: 1.w,
                ),
              ),
        focusedBorder: hideUnderline
            ? InputBorder.none
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryLight(context),
                  width: 1.w,
                ),
              ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
        errorStyle: TextStyle(fontSize: 24.sp, color: AppColors.error),
      ),
    );
  }
}

/// 🔥 国际化输入框统一前缀组件（自动对齐，适配所有语言）
/// 固定宽度 + 左对齐，无论文字长短，输入框永远对齐
class AppInputPrefix extends StatelessWidget {
  final String text; // 国际化文字（中文/英文自动适配）
  final double width; // 前缀固定宽度（统一所有输入框）

  const AppInputPrefix(
    this.text, {
    super.key,
    this.width = 120, // 🔥 统一固定宽度，全局修改这个值即可
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 核心：固定宽度，所有语言前缀区域一样宽
      width: width.w,
      // 左对齐，文字超长自动换行（可选）
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: AppText(
          text,
          size: 28.sp,
          color: AppColors.textMain(context),
          maxLines: 1,
        ),
      ),
    );
  }
}

// 🔥 封装通用的清除按钮组件（复用性极强）
class ClearButton extends StatelessWidget {
  final TextEditingController controller;

  const ClearButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // 监听输入框内容变化，动态显示/隐藏按钮
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 输入框为空时，不显示按钮
        if (controller.text.isEmpty) return const SizedBox();

        // 有内容时，显示删除图标（紧凑圆圈包裹）
        return AppIconButton(
          icon: Icons.cancel,
          size: 32.w,
          iconColor: AppColors.textGray(context).withAlpha(80),
          onTap: () {
            // 一键清空文本
            controller.clear();
          },
        );
      },
    );
  }
}

/// 通用列表项
class AppListItem extends StatelessWidget {
  final Widget? left;
  final String title;
  final String? desc;
  final Widget? right;
  final VoidCallback? onTap;
  final bool showArrow;
  final double verticalPadding;
  final double horizontalPadding;
  // 👇 新增：控制标题是否居中（默认false，保持原有样式）
  final bool isTitleCenter;

  const AppListItem({
    super.key,
    this.left,
    required this.title,
    this.desc,
    this.right,
    this.onTap,
    this.showArrow = true,
    this.verticalPadding = 20,
    this.horizontalPadding = 20,
    this.isTitleCenter = false, // 新增默认值
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding.h,
          horizontal: horizontalPadding.w,
        ),
        // 👇 核心：根据参数控制整体对齐方式
        child: Row(
          mainAxisAlignment: isTitleCenter
              ? MainAxisAlignment
                    .center // 居中模式
              : MainAxisAlignment.start, // 原有默认模式
          children: [
            // 居中时不显示左侧图标
            if (left != null && !isTitleCenter) ...[left!, AppGap.wNormal],
            Expanded(
              child: Column(
                // 👇 核心：根据参数控制文字对齐方式
                crossAxisAlignment: isTitleCenter
                    ? CrossAxisAlignment
                          .center // 文字居中
                    : CrossAxisAlignment.start, // 文字左对齐（原有）
                children: [
                  AppText.body(title),
                  if (desc != null && desc!.isNotEmpty) ...[
                    AppGap.hSmall,
                    AppText.tip(desc!),
                  ],
                ],
              ),
            ),
            // 居中时不显示右侧图标/箭头
            if (right != null && !isTitleCenter) ...[right!],
            if (showArrow && !isTitleCenter)
              Icon(
                Icons.arrow_forward_ios,
                size: 24.w,
                color: AppColors.textGray(context),
              ),
          ],
        ),
      ),
    );
  }
}

// 头像形状枚举
enum AppAvatarShape {
  circle, // 圆形（默认）
  square, // 正方形
  rounded, // 圆角矩形
}

/// 通用头像组件（支持网络/本地图片 + 自定义形状 + 主题适配）
class AppAvatar extends StatelessWidget {
  final String? imgUrl; // 网络图片地址
  final String? assetPath; // 本地资源图片路径（新增）
  final double size; // 尺寸
  final Widget? child; // 自定义子组件
  final AppAvatarShape shape; // 头像形状（新增）
  final double borderRadius; // 圆角大小（仅shape=rounded生效）

  const AppAvatar({
    super.key,
    this.imgUrl,
    this.assetPath,
    this.size = 100,
    this.child,
    this.shape = AppAvatarShape.circle, // 默认圆形
    this.borderRadius = 16, // 默认圆角16.w
  });

  @override
  Widget build(BuildContext context) {
    // 根据形状获取圆角/裁剪样式
    BorderRadiusGeometry getBorderRadius() {
      switch (shape) {
        case AppAvatarShape.circle:
          return BorderRadius.circular(size.w);
        case AppAvatarShape.square:
          return BorderRadius.zero;
        case AppAvatarShape.rounded:
          return BorderRadius.circular(borderRadius.w);
      }
    }

    return ClipRRect(
      borderRadius: getBorderRadius(),
      child: Container(
        width: size.w,
        height: size.w,
        color: AppColors.primaryLight(context),
        child: _buildImageContent(context),
      ),
    );
  }

  // 构建图片内容：网络图片 → 本地资源 → 默认图标
  Widget _buildImageContent(BuildContext context) {
    // 1. 优先显示网络图片（带缓存+占位+错误）
    if (imgUrl != null && imgUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imgUrl!,
        fit: BoxFit.cover,
        width: size.w,
        height: size.w,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: AppColors.primary(context),
            strokeWidth: 2.w,
          ),
        ),
        errorWidget: (context, url, error) =>
            assetPath != null && assetPath!.isNotEmpty
            ? Image.asset(
                assetPath!,
                fit: BoxFit.cover,
                width: size.w,
                height: size.w,
              )
            : _defaultIcon(context),
      );
    }

    // 2. 其次显示本地资源图片
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        width: size.w,
        height: size.w,
      );
    }

    // 3. 无图片时显示默认图标/自定义组件
    return child ?? _defaultIcon(context);
  }

  // 默认头像图标
  Widget _defaultIcon(BuildContext context) {
    return Icon(Icons.person, size: 40.w, color: AppColors.primary(context));
  }
}

// ===================== 通用底部日期选择器 =====================
class AppBottomDatePicker {
  /// 弹出底部日期选择器
  /// [context] 上下文
  /// [initialDate] 初始日期
  /// [minimumDate] 最小可选日期
  /// [maximumDate] 最大可选日期
  /// [mode] 选择模式：date(年月日) / time(时间) / dateTime(日期+时间)
  /// [onConfirm] 确认选择回调
  static Future<void> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    required Function(DateTime date) onConfirm,
  }) async {
    // 关闭键盘
    FocusScope.of(context).unfocus();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        DateTime? selectedDate = initialDate;
        return StatefulBuilder(
          builder: (ctx, setBottomState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 顶部操作栏：取消 + 确定
                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.divider(context),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 取消
                      // 使用 Navigator.of(context).pop() 关闭 BottomSheet，
                      // 而非 NavigatorUtils.pop()（GoRouter.pop()）。
                      // 原因：showModalBottomSheet 由 Flutter 原生 Navigator 管理，
                      // GoRouter.pop() 虽然底层也调用 Navigator.pop()，但语义不明确，
                      // 且在 GoRouter 与 Navigator 路由栈不同步时可能 pop 错误的路由。
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: AppText.tip(
                          L10nUtils.cancel,
                          color: AppColors.textGray(context),
                        ),
                      ),
                      // 确定
                      TextButton(
                        onPressed: () {
                          if (selectedDate != null) {
                            onConfirm(selectedDate!);
                          }
                          // 同上，使用 Navigator.of(context).pop() 关闭 BottomSheet
                          Navigator.of(context).pop();
                        },
                        child: AppText.body(
                          L10nUtils.confirm,
                          color: AppColors.primary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // 日期滚轮
                SizedBox(
                  height: 300.h,
                  child: CupertinoDatePicker(
                    mode: mode,
                    initialDateTime: initialDate ?? DateTime.now(),
                    minimumDate: minimumDate ?? DateTime(1900),
                    maximumDate: maximumDate ?? DateTime.now(),
                    onDateTimeChanged: (date) {
                      setBottomState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ===================== 统一勾选框组件 =====================

/// 基础勾选框（纯Checkbox，可独立复用）
class AppCheckbox extends StatelessWidget {
  final bool value; // 选中状态
  final ValueChanged<bool>? onChanged; // 状态回调
  final bool disabled; // 是否禁用
  final double size; // 勾选框尺寸

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.size = 26, // 默认尺寸，适配项目
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled
          ? null
          : () {
              onChanged?.call(!value);
            },
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.textGray(context).withAlpha(77)
              : (value ? AppColors.primary(context) : Colors.transparent),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            width: 1.5.w,
            color: disabled
                ? AppColors.textGray(context)
                : (value
                      ? AppColors.primary(context)
                      : AppColors.primaryDark(context)),
          ),
        ),
        child: value
            ? Icon(Icons.check, size: 20.w, color: Colors.white)
            : const SizedBox(),
      ),
    );
  }
}

/// 协议专用勾选框（勾选框 + 可点击文字，适配注册/登录页）
class AppAgreementCheckbox extends StatelessWidget {
  final bool isAgree;
  final ValueChanged<bool> onChanged;
  final VoidCallback onUserAgreement;
  final VoidCallback onPrivacyPolicy;

  const AppAgreementCheckbox({
    super.key,
    required this.isAgree,
    required this.onChanged,
    required this.onUserAgreement,
    required this.onPrivacyPolicy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 勾选框
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCheckbox(value: isAgree, onChanged: onChanged),
              AppGap.wSmall,
              AppText.tip(L10nUtils.iHaveReadAndAgree),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextButton(
                text: "《${L10nUtils.userAgreement}》",
                size: 24.sp,
                onTap: onUserAgreement,
              ),
              AppGap.wSmall,
              AppText.tip(L10nUtils.andText),
              AppGap.wSmall,
              AppTextButton(
                text: "《${L10nUtils.privacyPolicy}》",
                size: 24.sp,
                onTap: onPrivacyPolicy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 固定宽度空白占位符（强制对齐神器，替代不稳定的空格）
/// [width] 占位宽度，默认 20.w，适配屏幕
class AppWidthPlaceholder extends StatelessWidget {
  final double width;

  const AppWidthPlaceholder({super.key, this.width = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}

/// 垂直占位符（备用）
class AppHeightPlaceholder extends StatelessWidget {
  final double height;

  const AppHeightPlaceholder({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

/// 红点标记组件（用于新版本提示、未读消息、新功能标记等场景）
///
/// 示例：
/// ```dart
/// Row(
///   children: [
///     AppDot(),         // 默认红色小圆点
///     AppGap.wSmall,
///     AppText('发现新版本'),
///   ],
/// )
/// ```
class AppDot extends StatelessWidget {
  /// 圆点大小（直径）
  final double size;

  /// 圆点颜色，默认为错误红 [AppColors.error]
  final Color? color;

  const AppDot({super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color ?? AppColors.error,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// 多行文本域组件（适配主题 + 暗黑模式）
///
/// 适用于意见反馈、备注填写等多行文本输入场景。
/// 默认无边框，配合 [AppCard] 使用效果更佳。
///
/// 示例：
/// ```dart
/// AppCard(
///   showShadow: false,
///   padding: EdgeInsets.zero,
///   child: AppTextArea(
///     controller: _controller,
///     hint: L10nUtils.feedbackHint,
///     maxLength: 1000,
///     onChanged: (_) => setState(() {}),
///   ),
/// )
/// ```
class AppTextArea extends StatelessWidget {
  /// 控制器
  final TextEditingController? controller;

  /// 占位提示文字
  final String? hint;

  /// 最大行数
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 最大字符数（null 则不限制）
  final int? maxLength;

  /// 内容变化回调
  final ValueChanged<String>? onChanged;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 是否显示边框（默认无边框，配合 AppCard 使用）
  final bool showBorder;

  /// 圆角（showBorder 为 true 时生效）
  final double? borderRadius;

  /// 是否只读
  final bool readOnly;

  /// 键盘类型
  final TextInputType? keyboardType;

  const AppTextArea({
    super.key,
    this.controller,
    this.hint,
    this.maxLines = 10,
    this.minLines = 8,
    this.maxLength,
    this.onChanged,
    this.padding,
    this.showBorder = false,
    this.borderRadius,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      readOnly: readOnly,
      keyboardType: keyboardType ?? TextInputType.multiline,
      style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 28.sp,
          color: AppColors.textGray(context),
        ),
        border: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular((borderRadius ?? 12).w),
                borderSide: BorderSide(color: AppColors.divider(context)),
              )
            : InputBorder.none,
        enabledBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular((borderRadius ?? 12).w),
                borderSide: BorderSide(color: AppColors.divider(context)),
              )
            : InputBorder.none,
        focusedBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular((borderRadius ?? 12).w),
                borderSide: BorderSide(color: AppColors.primary(context)),
              )
            : InputBorder.none,
        contentPadding: padding ?? EdgeInsets.all(24.w),
        counterStyle: TextStyle(
          fontSize: 24.sp,
          color: AppColors.textGray(context),
        ),
      ),
    );
  }
}

/// 通用分割线组件（支持自定义颜色和左右边距）
///
/// 示例：
/// ```dart
/// AppDivider(),                              // 默认：主题分割线色 + 30.w 左右边距
/// AppDivider(color: Colors.red, padding: 20), // 自定义颜色和边距
/// ```
class AppDivider extends StatelessWidget {
  /// 分割线颜色，默认使用主题分割线色 [AppColors.divider]
  final Color? color;

  /// 左右边距（逻辑像素），默认 30
  final double padding;

  /// 分割线高度，默认 1
  final double height;

  const AppDivider({super.key, this.color, this.padding = 30, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.w),
      child: Divider(
        height: height.h,
        color: color ?? AppColors.divider(context),
      ),
    );
  }
}
