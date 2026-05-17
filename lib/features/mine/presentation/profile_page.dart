import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      showAppBar: false,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 64.h,
        bottom: 16.h,
      ),
      body: SingleChildScrollView(
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
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            children: [
              // 顶部操作栏：设置按钮右对齐
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIconButton(
                    icon: Icons.settings_outlined,
                    iconColor: AppColors.iconColor,
                    size: 40.w,
                    btnSize: 72.w,
                    onTap: () => context.pushNamed(RouteNames.systemSetting),
                  ),
                ],
              ),
              AppGap.hSmall,

              // 头像 + 编辑按钮（叠加布局）
              GestureDetector(
                onTap: () => context.pushNamed(RouteNames.userInfo),
                child: Stack(
                  children: [
                    AppAvatar(
                      imgUrl: user?.userProfile.avatarUrl,
                      assetPath: Assets.images.profile.admin.path,
                      size: 300.w,
                    ),
                  ],
                ),
              ),
              AppGap.hNormal,

              // 用户名居中显示
              AppText(
                user?.userProfile.userName ?? "",
                size: 36.sp,
                weight: FontWeight.w600,
                align: TextAlign.center,
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
