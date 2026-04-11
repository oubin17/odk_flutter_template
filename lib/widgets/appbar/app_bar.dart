import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 通用导航栏（适配主题+明暗模式）
class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  const BasicAppbar({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 透明背景保留（通用样式）
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? AppText(''),
      leading: context.canPop()
          ? IconButton(
              onPressed: () => NavigatorUtils.pop(),
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
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
