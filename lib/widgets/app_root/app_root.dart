import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:odk_flutter_template/common/theme/app_theme.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:provider/provider.dart';

/// 应用根组件（抽离所有UI初始化逻辑）
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // 屏幕适配核心组件
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
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            // 绑定路由配置
            routerConfig: AppRouter.router,
            // 关闭调试标识
            debugShowCheckedModeBanner: false,
            // 🔥 5.x 保留这个初始化即可
            builder: FlutterSmartDialog.init(),
            // 绑定主题
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(themeProvider.themeMode),
          );
        },
      ),
    );
  }

  // 主题模式转换（私有方法，跟随根组件）
  ThemeMode _getThemeMode(ThemeModeType type) {
    switch (type) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }
}
