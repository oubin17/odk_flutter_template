import 'package:flutter/material.dart';
import 'package:odk_flutter_template/common/app_info/app_info.dart';
import 'package:odk_flutter_template/common/app_info/device_info.dart';

class FirstIndexPage extends StatelessWidget {
  const FirstIndexPage({super.key});
  @override
  Widget build(BuildContext context) {
    // return const AppInfoPage();
    return const DeviceInfoPage();
  }
}
