import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/common/app_info/app_info.dart';
import 'package:odk_flutter_template/common/app_info/device_info.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      appBar: const BasicAppbar(title: AppText("设置")),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

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
            onTap: () {
              // Fluttertoast.showToast(msg: "操作成功！");
              AppToast.showLoading(
                loading: "待实现...",
                displayTime: const Duration(seconds: 2),
              );
            },
          ),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

          // 版本信息 + 图标
          AppListItem(
            left: Icon(
              Icons.system_update_outlined,
              color: AppColors.textSecond(context),
            ),
            title: "版本信息",
            // desc: "1.0.0",
            onTap: () {
              // SmartDialog.show(builder: (context) => const AppInfoPage());
              AppToast.show(const AppInfoPage());
            },
          ),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
          // 设备信息 + 图标
          AppListItem(
            left: Icon(
              Icons.device_hub_outlined,
              color: AppColors.textSecond(context),
            ),
            title: "设备信息",
            // desc: "1.0.0",
            onTap: () {
              AppToast.show(const DeviceInfoPage());
            },
          ),

          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
          // Spacer(),
          AppListItem(
            left: Icon(Icons.logout, color: AppColors.textSecond(context)),
            title: "退出登录",
            showArrow: false,
            onTap: () {
              AppToast.showAppConfirmDialog(
                title: "退出登录",
                // msg: "是否退出登录？",
                onConfirm: () {
                  AuthService().logout();
                  // 直接清空，比refresh更快
                  context.read<UserProvider>().clearUser();
                  context.go('/?fromOtherPage=true');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
