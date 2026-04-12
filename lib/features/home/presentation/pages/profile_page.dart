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
        child: Column(
          children: [
            AppGap.hSmall,
            _buildInfoCard(),
            AppGap.hSmall,
            _buildSystemSettingCard(
              context,
              icon: Icons.settings,
              title: "系统设置",
              onTap: () => context.pushNamed(RouteNames.systemSetting),
            ),
            AppGap.hSmall,

            AppGap.hSmall,
          ],
        ),
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
              // 本地图片
              AppAvatar(
                assetPath: user?.isAdmin == true
                    ? Assets.images.profile.admin.path
                    : Assets.images.profile.employee.path,
                size: 300.w,
              ),
              AppGap.hSuperSmall,
              AppText(
                user?.userProfile?.userName ?? "未设置姓名",
                size: 40.sp,
                weight: FontWeight.bold,
              ),
              AppGap.hSuperSmall,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: AppText(
                  user?.isAdmin == true ? "管理员" : "员工",
                  size: 28.sp,
                  weight: FontWeight.w200,
                  color: Colors.blue[700],
                ),
              ),
              const Divider(),
              _buildInfoRow(
                context,
                Icons.badge,
                "工号",
                user?.accessToken.tokenValue ?? "",
              ),
              AppGap.hSuperSmall,
              _buildInfoRow(
                context,
                Icons.check_circle_outline,
                "状态",
                user?.userStatus == "0" ? "正常" : "异常",
              ),
            ],
          ),
        );
      },
    );
  }

  /// 信息行组件
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 32.w, color: AppColors.textSecond(context)),
        AppGap.wSmall,
        AppText.second(label),
        const Spacer(),
        AppText.second(value),
      ],
    );
  }

  /// 占位卡片
  Widget _buildSystemSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecond(context)),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
