import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      appBar: AppBar(
        backgroundColor: AppColors.primary(context),
        leading: AppIconButton(
          icon: Icons.arrow_back,
          onTap: () => context.pop(),
          iconColor: Colors.white,
        ),
        title: const AppText("系统设置", color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          // 主题切换 + 图标
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final currentMode = themeProvider.isDarkMode ? "夜间模式" : "日间模式";
              return AppListItem(
                left: themeProvider.isDarkMode
                    ? Icon(
                        Icons.dark_mode_outlined,
                        color: AppColors.textSecond(context),
                      )
                    : Icon(
                        Icons.light_mode_outlined,
                        color: AppColors.textSecond(context),
                      ),
                title: "主题模式",
                desc: currentMode,
                showArrow: false,
                onTap: () {
                  themeProvider.changeTheme(
                    themeProvider.isDarkMode
                        ? ThemeModeType.light
                        : ThemeModeType.dark,
                  );
                },
              );
            },
          ),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

          // 关于我们 + 图标
          AppListItem(
            left: Icon(
              Icons.info_outline,
              color: AppColors.textSecond(context),
            ),
            title: "关于我们",
            onTap: () {},
          ),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

          // 版本信息 + 图标
          AppListItem(
            left: Icon(
              Icons.system_update_outlined,
              color: AppColors.textSecond(context),
            ),
            title: "版本信息",
            desc: "1.0.0",
            onTap: () {},
          ),
          // 退出登录 + 图标
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
          // Spacer(),
          AppListItem(
            left: Icon(Icons.logout, color: AppColors.textSecond(context)),
            title: "退出登录",
            showArrow: false,
            onTap: () {
              AuthService().logout();
              // 直接清空，比refresh更快
              context.read<UserProvider>().clearUser();
              context.go('/?fromOtherPage=true');
            },
          ),
        ],
      ),
    );
  }
}
