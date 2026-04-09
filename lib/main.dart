import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  // 确保 Flutter 引擎绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 初始化普通存储
  await StorageManager.init();
  // 启动时恢复用户登录状态

  final userProvider = UserProvider();
  await userProvider.refresh();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => userProvider)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 核心：ScreenUtilInit 包裹整个应用
    // 宽度、圆角、水平间距 → 用 .w
    // 字体大小 → 用 .sp
    // 高度 → 用 .h
    return ScreenUtilInit(
      // 设计稿尺寸（UI给你的标准尺寸，二选一）
      designSize: const Size(750, 1334), // 手机常用（推荐）
      minTextAdapt: true, // 最小文字适配
      splitScreenMode: true, // 支持分屏模式适配
      // 你的应用主体
      child: MaterialApp.router(
        // 绑定路由配置
        routerConfig: AppRouter.router,
        // 关闭调试标识
        debugShowCheckedModeBanner: false,

        // 其他主题配置保留不变
        // theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
