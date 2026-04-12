import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/common/theme/app_theme.dart';

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
  static const Color warning = Color(0xFFFF7D00);
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

/// 统一间距组件
class AppGap {
  // 垂直间距
  static Widget hSuperSmall = SizedBox(height: 10.h);
  static Widget hSmall = SizedBox(height: 20.h);
  static Widget hNormal = SizedBox(height: 30.h);
  static Widget hLarge = SizedBox(height: 40.h);
  static Widget hXL = SizedBox(height: 60.h);

  // 水平间距
  static Widget wSmall = SizedBox(width: 20.w);
  static Widget wNormal = SizedBox(width: 30.w);
  static Widget wLarge = SizedBox(width: 40.w);
  static Widget wXL = SizedBox(width: 60.w);
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
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        width: btnSize ?? 60.w,
        height: btnSize ?? 60.w,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(16.w),
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

  const AppOutlinedButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary(context), width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: AppText(text, color: AppColors.primary(context), size: 28.sp),
      ),
    );
  }
}

/// 文字按钮
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
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
        size: 26.sp,
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
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final bool readOnly;

  // 👇 新增：表单校验核心参数（和你之前用的 TextFormField 完全一致）
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppInput({
    super.key,
    this.controller,
    this.label,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.readOnly = false,
    // 👇 新增校验参数
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 核心：替换为 TextFormField，支持校验
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      // 👇 绑定校验相关属性
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      // 👇 原有装饰样式 100% 保留
      decoration: InputDecoration(
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
        prefixIcon: prefix != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: prefix,
              )
            : null,
        suffixIcon: suffix != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: suffix,
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: BorderSide(
            color: AppColors.primaryLight(context),
            width: 1.w,
          ),
        ),
        // filled: true,
        // fillColor: AppColors.card(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: BorderSide(color: AppColors.divider(context), width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
        // 错误提示样式（适配主题）
        errorStyle: TextStyle(fontSize: 24.sp, color: AppColors.error),
      ),
    );
  }
}

/// /// 验证码输入框（支持表单校验 + 主题适配 + 倒计时）
class AppCodeInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendCode;
  final bool isCounting;
  final int countTime;

  // 新增：表单校验核心参数（与AppInput完全一致）
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppCodeInput({
    super.key,
    required this.controller,
    required this.onSendCode,
    required this.isCounting,
    this.countTime = 60,
    // 新增校验参数
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput> {
  @override
  Widget build(BuildContext context) {
    // 核心：替换为 TextFormField，支持校验
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      // 绑定校验相关属性
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        hintText: "请输入验证码",
        hintStyle: TextStyle(
          fontSize: 26.sp,
          color: AppColors.textGray(context),
        ),
        // filled: true,
        // fillColor: AppColors.card(context),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16.w),
        //   borderSide: BorderSide.none,
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.w),
          borderSide: BorderSide(color: AppColors.divider(context), width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
        // 错误提示样式（统一主题）
        errorStyle: TextStyle(fontSize: 24.sp, color: AppColors.error),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: TextButton(
            onPressed: widget.isCounting ? null : widget.onSendCode,
            child: AppText(
              widget.isCounting ? "${widget.countTime}s后重发" : "获取验证码",
              color: widget.isCounting
                  ? AppColors.textGray(context)
                  : AppColors.primary(context),
              size: 24.sp,
            ),
          ),
        ),
      ),
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
        child: Row(
          children: [
            if (left != null) ...[left!, AppGap.wNormal],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(title),
                  if (desc != null && desc!.isNotEmpty) ...[
                    AppGap.hSmall,
                    AppText.tip(desc!),
                  ],
                ],
              ),
            ),
            if (right != null) ...[right!],
            if (showArrow)
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

  // 构建图片内容：本地图片 → 网络图片 → 默认图标
  Widget _buildImageContent(BuildContext context) {
    // 1. 优先显示本地资源图片
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        width: size.w,
        height: size.w,
      );
    }

    // 2. 其次显示网络图片（带缓存+占位+错误）
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
        errorWidget: (context, url, error) => _defaultIcon(context),
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
