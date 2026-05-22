import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:odk_flutter_template/common/initializer/app_initializer.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/crash/bugly_service.dart';
import 'package:odk_flutter_template/providers/locale/locale_provider.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_root/app_root.dart';
import 'package:provider/provider.dart';

void main() async {
  // 1. 先配置环境变量，确保 Env 能正确读取配置（如 Bugly appId）
  FlavorConfig(name: Environment.prod.name, variables: prodVariables);

  // 2. 执行应用初始化（内部包含 Bugly 初始化）
  await AppInitializer.instance.init();

  // 3. 设置 Bugly 异常捕获处理器（替代 postCatchedException，避免 Zone mismatch）
  BuglyService.instance.setupExceptionHandler();

  // 4. 启动应用（在 root zone 中执行，避免 Zone mismatch）
  runApp(
    MultiProvider(
      providers: [
        // 注入用户Provider
        ChangeNotifierProvider(
          create: (context) => AppInitializer.instance.userProvider,
        ),
        // 注入主题Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // 注入语言Provider
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const AppRoot(),
    ),
  );

  // 5. 所有初始化/校验完成 → 关闭原生启动屏
  FlutterNativeSplash.remove();
}
