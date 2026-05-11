import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/mine/presentation/password_manager_page.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

class SecuritySettingPage extends StatelessWidget {
  const SecuritySettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: AppText("账号安全")),

      body: ListView(
        children: [
          AppListItem(
            title: "设置密码",
            onTap: () {
              NavigatorUtils.pushNamed(
                RouteNames.passwordManager,
                queryParameters: {
                  "type": PasswordManagerType.set.index.toString(),
                  "title": "设置密码",
                },
              );
            },
          ),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 60.w),

          AppListItem(
            title: "重置密码",
            onTap: () {
              NavigatorUtils.pushNamed(
                RouteNames.passwordManager,
                queryParameters: {
                  "type": PasswordManagerType.change.index.toString(),
                  "title": "重置密码",
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
