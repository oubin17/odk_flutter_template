import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:odk_flutter_template/common/initializer/app_initializer.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_root/app_root.dart';
import 'package:provider/provider.dart';

void main() async {
  // 🔥 只调用这一行，所有初始化全部完成
  await AppInitializer.instance.init();

  // 配置环境变量
  FlavorConfig(name: Environment.dev.name, variables: devVariables);

  runApp(
    MultiProvider(
      providers: [
        // 注入用户Provider
        ChangeNotifierProvider(
          create: (context) => AppInitializer.instance.userProvider,
        ),
        // 注入主题Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const AppRoot(),
    ),
  );

  // 🔥 4. 所有初始化/校验完成 → 关闭原生启动屏
  // 直接显示目标页面，无任何切换
  FlutterNativeSplash.remove();
}
