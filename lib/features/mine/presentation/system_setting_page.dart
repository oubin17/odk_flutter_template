import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  Widget _buildAccountContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: L10nUtils.profile,
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.userInfo);
          },
        ),
        Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

        AppListItem(
          title: L10nUtils.accountSecurity,
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
          title: L10nUtils.commonSetting,
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.commonSetting);
          },
        ),
        Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
      ],
    );
  }

  Widget _buildVersionInfoContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: L10nUtils.versionInfo,
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.versionInfo);
          },
        ),
        Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),
      ],
    );
  }

  Widget _buildLogoutContext(BuildContext context) {
    return AppListItem(
      title: L10nUtils.logout,
      isTitleCenter: true,
      showArrow: false,
      onTap: () {
        AppToast.showAppConfirmDialog(
          title: L10nUtils.logout,
          onConfirm: () async {
            await AuthService().logout();
            NavigatorUtils.goNamed(RouteNames.signin);
          },
        );
      },
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
          AppTip(tip: L10nUtils.account),
          _buildAccountContext(context),
          AppTip(tip: L10nUtils.general),
          _buildSystemContext(context),
          AppTip(tip: L10nUtils.helpAbout),
          _buildVersionInfoContext(context),
          AppTip(height: 20.h),
          _buildLogoutContext(context),
          Divider(height: 1.h, color: AppColors.divider(context)),
        ],
      ),
    );
  }
}
