import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/common/app_info/app_info.dart';
import 'package:odk_flutter_template/common/app_info/device_info.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/l10n/app_localizations.dart';
import 'package:odk_flutter_template/providers/locale/locale_provider.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  Widget _buildTipContext(BuildContext context, String tip) {
    return Container(
      // 保持你原来的内边距
      padding: EdgeInsets.only(left: 20.w, top: 16.h, bottom: 16.h),
      color: AppColors.bgSecond(context),
      child: AppText.second(tip),
    );
  }

  Widget _buildAccountContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: "个人资料",
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.userInfo);
          },
        ),
        Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

        AppListItem(
          title: "账号安全",
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.securitySetting);
          },
        ),
      ],
    );
  }

  Widget _buildSystemContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: "通用设置",
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.commonSetting);
          },
        ),
        Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      appBar: BasicAppBar(title: AppText(L10nUtils.systemSetting)),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          AppTip(tip: "账号"),
          _buildAccountContext(context),
          AppTip(tip: "通用"),
          _buildSystemContext(context),
          AppListItem(
            left: Icon(Icons.logout, color: AppColors.textSecond(context)),
            title: L10nUtils.logout,
            showArrow: false,
            onTap: () {
              AppToast.showAppConfirmDialog(
                title: L10nUtils.logout,
                onConfirm: () async {
                  await AuthService().logout();
                  // ignore: use_build_context_synchronously
                  NavigatorUtils.goNamed(RouteNames.signin);
                },
              );
            },
          ),

          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
        ],
      ),
    );
  }
}
