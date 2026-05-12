import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.h,
          right: 16.h,
          top: 64.h,
          bottom: 16.h,
        ),
        child: Column(children: [AppGap.hSmall, _buildInfoCard()]),
      ),
    );
  }

  /// 个人信息卡片
  Widget _buildInfoCard() {
    // 监听 UserProvider 变化
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider provider, Widget? child) {
        // 👇 关键：从 Provider 中拿最新的用户数据
        final user = provider.userEntity;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                // 关键：让Row内所有子组件垂直居中对齐（头像、文本、按钮组对齐）
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppGap.wSmall,
                  AppAvatar(
                    assetPath: user?.isAdmin == true
                        ? Assets.images.profile.admin.path
                        : Assets.images.profile.employee.path,
                    size: 300.w,
                  ),
                  AppGap.wNormal,
                  AppText(
                    user?.userProfile?.userName ?? "",
                    size: 35.sp,
                    weight: FontWeight.w500,
                  ),
                  // ✅ 核心：添加Spacer，自动填充水平剩余空间，将后面的按钮组挤到最右侧
                  const Spacer(),
                  Column(
                    // 关键：让Column宽度自适应（不占满剩余空间）
                    mainAxisSize: MainAxisSize.min,
                    // 关键：按钮组自身右对齐
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppIconButton(
                        icon: Icons.settings_sharp,
                        iconColor: AppColors.iconColor,
                        size: 38.w,
                        onTap: () =>
                            context.pushNamed(RouteNames.systemSetting),
                      ),
                      AppIconButton(
                        icon: Icons.edit,
                        size: 30.w,
                        onTap: () => context.pushNamed(RouteNames.userInfo),
                      ),
                    ],
                  ),
                ],
              ),
              AppGap.hSuperSmall,

              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
