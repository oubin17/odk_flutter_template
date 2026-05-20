import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 通用导航栏（适配主题+明暗模式）+ 右上角统一保存按钮
class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  // 保存按钮回调
  final VoidCallback? onSave;
  // 保存按钮文案
  final String? saveText;
  // 右侧自定义操作按钮列表（与 onSave 互斥，优先使用 actions）
  final List<Widget>? actions;

  const BasicAppBar({
    super.key,
    this.title,
    this.onSave,
    this.saveText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 透明背景保留（通用样式）
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const AppText(''),
      leading: Builder(
        builder: (context) {
          final router = GoRouter.of(context);
          // 使用 canPop() + ModalRoute.isFirst 双重判断
          // canPop() 在 GoRouter 重定向场景下可能误判（如 / → /home 重定向残留），
          // 导致首页仍显示返回按钮但点击无效。
          // ModalRoute.of(context)?.isFirst 为 true 表示当前页面是导航栈根页面，不应显示返回按钮。
          final isRootRoute = ModalRoute.of(context)?.isFirst ?? true;
          if (!router.canPop() || isRootRoute) return const SizedBox.shrink();
          return IconButton(
            onPressed: () {
              // 点击时再次检查，避免 build 时和点击时路由状态不一致导致报错
              if (router.canPop()) {
                router.pop();
              }
            },
            icon: Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                // 主题适配：半透明背景色
                color: AppColors.textGray(context).withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20.w,
                // 主题适配：图标颜色自动切换黑白
                color: AppColors.textMain(context),
              ),
            ),
          );
        },
      ),
      // 右上角：优先使用自定义 actions，否则使用保存按钮
      actions:
          actions ??
          [
            if (onSave != null)
              Padding(
                // 右侧内边距，避免按钮贴边
                padding: EdgeInsets.only(right: 16.w),
                child: AppTextButton(
                  text: saveText ?? L10nUtils.save,
                  onTap: onSave!,
                  // 适配主题主色，和项目所有按钮保持一致
                  color: AppColors.primary(context),
                  size: 26.sp, // 统一字体大小
                ),
              ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
