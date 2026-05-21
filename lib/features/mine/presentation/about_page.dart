import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 关于页面
///
/// 包含：版本信息、关于我们、用户协议、隐私政策
/// 从设置页的"关于"入口进入
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.about),
      body: ListView(
        children: [
          // 顶部应用信息区域
          _buildAppHeader(context),

          AppGap.h(24),

          // 信息列表分组
          AppCard(
            showShadow: false,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListItem(
                  title: L10nUtils.versionInfo,
                  onTap: () {
                    NavigatorUtils.pushNamed(RouteNames.versionInfo);
                  },
                ),
                const AppDivider(),
                AppListItem(
                  title: L10nUtils.aboutUs,
                  onTap: () {
                    // 跳转到关于我们页面（使用 WebView 加载）
                    NavigatorUtils.pushNamed(
                      RouteNames.agreement,
                      queryParameters: {
                        'title': L10nUtils.aboutUs,
                        'url': Env.aboutUsUrl,
                      },
                    );
                  },
                ),
                const AppDivider(),
                AppListItem(
                  title: L10nUtils.userAgreement,
                  onTap: () {
                    NavigatorUtils.pushNamed(
                      RouteNames.agreement,
                      queryParameters: {
                        'title': L10nUtils.userAgreement,
                        'url': Env.userAgreementUrl,
                      },
                    );
                  },
                ),
                const AppDivider(),
                AppListItem(
                  title: L10nUtils.privacyPolicy,
                  onTap: () {
                    NavigatorUtils.pushNamed(
                      RouteNames.agreement,
                      queryParameters: {
                        'title': L10nUtils.privacyPolicy,
                        'url': Env.privacyPolicyUrl,
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 顶部应用信息区域（Logo + 应用名称 + 版本号）
  Widget _buildAppHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          // 应用图标
          AppAvatar(
            assetPath: Assets.images.launcherIcon.launcher.path,
            size: 120,
            shape: AppAvatarShape.rounded,
            borderRadius: 24,
          ),
          AppGap.hNormal,
          // 应用名称
          AppText(L10nUtils.appTitle, size: 36.sp, weight: FontWeight.w600),
        ],
      ),
    );
  }
}
