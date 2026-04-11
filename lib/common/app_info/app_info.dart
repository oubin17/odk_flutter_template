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
    return Scaffold(
      appBar: AppBar(title: const Text("App信息")),
      body: _packageInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("应用名称：${_packageInfo!.appName}"),
                  Text("包名：${_packageInfo!.packageName}"),
                  Text("版本号：${_packageInfo!.version}"),
                  Text("构建号：${_packageInfo!.buildNumber}"),
                ],
              ),
            ),
    );
  }
}
