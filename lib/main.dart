import 'package:flutter/material.dart';
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
    return MaterialApp.router(
      // 绑定路由配置
      routerConfig: AppRouter.router,
      // 关闭调试标识
      debugShowCheckedModeBanner: false,

      // 其他主题配置保留不变
      // theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
