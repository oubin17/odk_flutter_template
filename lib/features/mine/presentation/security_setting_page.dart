import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/mine/presentation/password_manager_page.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 账号与安全设置页
class SecuritySettingPage extends StatelessWidget {
  const SecuritySettingPage({super.key});

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
        const AppDivider(),
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

  /// 危险操作分组（注销账号）
  Widget _buildDangerContext(BuildContext context) {
    return AppListItem(
      title: L10nUtils.deleteAccount,
      isTitleCenter: true,
      showArrow: false,
      onTap: () {
        NavigatorUtils.pushNamed(RouteNames.deleteAccount);
      },
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
          AppGap.h(24),
          // 危险操作区域
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: _buildDangerContext(context),
          ),
        ],
      ),
    );
  }
}
