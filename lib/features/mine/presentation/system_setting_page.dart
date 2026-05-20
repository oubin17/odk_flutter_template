import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

class SystemSettingPage extends StatelessWidget {
  const SystemSettingPage({super.key});

  /// 分组标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, bottom: 8.h, top: 4.h),
      child: AppText.tip(title),
    );
  }

  Widget _buildAccountContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: L10nUtils.profile,
          onTap: () {
            NavigatorUtils.pushNamed(RouteNames.userInfo);
          },
        ),
        const AppDivider(),
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
    return AppPage(
      title: AppText(L10nUtils.systemSetting),
      body: ListView(
        children: [
          // 账号分组
          _buildSectionTitle(L10nUtils.account),
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildAccountContext(context),
          ),

          AppGap.h(24),

          // 通用分组
          _buildSectionTitle(L10nUtils.general),
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildSystemContext(context),
          ),

          AppGap.h(24),
          // 帮助关于分组
          _buildSectionTitle(L10nUtils.helpAbout),
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildVersionInfoContext(context),
          ),
          AppGap.hLarge,

          // 退出登录
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildLogoutContext(context),
          ),
        ],
      ),
    );
  }
}
