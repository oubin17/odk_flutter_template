import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/mine/presentation/password_manager_page.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 账号与安全设置页
class SecuritySettingPage extends StatelessWidget {
  const SecuritySettingPage({super.key});

  /// 分组内分割线
  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Divider(height: 1.h, color: AppColors.divider(context)),
    );
  }

  /// 密码管理分组
  Widget _buildPasswordContext(BuildContext context) {
    return Column(
      children: [
        AppListItem(
          title: L10nUtils.setPassword,
          onTap: () {
            NavigatorUtils.pushNamed(
              RouteNames.passwordManager,
              queryParameters: {
                "type": PasswordManagerType.set.index.toString(),
                "title": L10nUtils.setPassword,
              },
            );
          },
        ),
        _buildDivider(context),
        AppListItem(
          title: L10nUtils.resetPassword,
          onTap: () {
            NavigatorUtils.pushNamed(
              RouteNames.passwordManager,
              queryParameters: {
                "type": PasswordManagerType.change.index.toString(),
                "title": L10nUtils.resetPassword,
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.accountSecurity),
      body: ListView(
        children: [
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildPasswordContext(context),
          ),
        ],
      ),
    );
  }
}
