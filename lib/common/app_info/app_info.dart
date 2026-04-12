import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  // 获取App信息
  Future<void> _getAppInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // 主题适配：弹窗背景色
      backgroundColor: AppColors.bgPage(context),
      // 圆角
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: _packageInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("应用名称：${_packageInfo!.appName}"),
                  AppText("包名：${_packageInfo!.packageName}"),
                  AppText("版本号：${_packageInfo!.version}"),
                  AppText("构建号：${_packageInfo!.buildNumber}"),
                ],
              ),
            ),
    );
  }
}
