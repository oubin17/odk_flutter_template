import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odk_flutter_template/common/app_info/app_info.dart';
import 'package:odk_flutter_template/common/app_info/device_info.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';

class FirstIndexPage extends StatelessWidget {
  const FirstIndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    // return const AppInfoPage();
    // return const DeviceInfoPage();
    var num1 = 123456;
    String f1 = NumberFormat('#,###').format(num1);
    DateTime now = DateTime.now();
    String f2 = DateFormat('yyyy年MM月dd日 HH时mm分').format(now);
    String enDate = DateFormat('EEEE, MMMM dd, yyyy', 'en_US').format(now);

    return Scaffold(
      appBar: const BasicAppbar(title: Text('First Index Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText("你好世界 Flutter 阿里巴巴普惠体", size: 30),
            const AppText("正文文字：横竖撇捺 123 abc", size: 28),
            const AppText("按钮文字也会统一", size: 24),
            AppText('Hello World $f1'),
            AppText('Hello World $f2'),
            AppText('Hello World $enDate'),
          ],
        ),
      ),
    );
  }
}
