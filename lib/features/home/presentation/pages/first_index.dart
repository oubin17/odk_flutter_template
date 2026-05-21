import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/basic_user/service/user_query_service.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 首页
class FirstIndexPage extends StatelessWidget {
  const FirstIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    var num1 = 123456;
    String f1 = NumberFormat('#,###').format(num1);
    DateTime now = DateTime.now();
    String f2 = DateFormat('yyyy年MM月dd日 HH时mm分').format(now);
    String enDate = DateFormat('EEEE, MMMM dd, yyyy', 'en_US').format(now);

    return AppPage(
      title: AppText(L10nUtils.home),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(L10nUtils.appTitle, size: 30.sp),
            AppText('正文文字：横竖撇捺 123 abc', size: 28.sp),
            AppText('按钮文字也会统一', size: 24.sp),
            AppText('Hello World $f1'),
            AppText('Hello World $f2'),
            AppText('Hello World $enDate'),
            AppIconButton(
              icon: Icons.search,
              onTap: () {
                UserQueryService().getUserInfo();
              },
            ),
          ],
        ),
      ),
    );
  }
}
