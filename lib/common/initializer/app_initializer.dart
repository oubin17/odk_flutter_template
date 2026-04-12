import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:odk_flutter_template/common/app_info/global_info.dart';
import 'package:odk_flutter_template/core/network/check/network_utils.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';

class AppInitializer {
  AppInitializer._internal();
  static final AppInitializer instance = AppInitializer._internal();

  // 🔥 核心：全局持有 UserProvider 实例
  late UserProvider userProvider;

  Future<void> init() async {
    // 1. 确保 Flutter 引擎绑定初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 2. ========== 新增：初始化网络监听 ==========
    await NetworkCheck.instance.initNetworkListen();

    // 3. 🔥 新增：保留原生启动屏，不自动关闭
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // 4. 启动时缓存全局信息
    await GlobalInfo.instance.init();
    // 5. 启动时恢复用户登录状态

    // 6. 1. 初始化普通存储
    await StorageManager.init();
    // 7.  启动时恢复用户登录状态
    userProvider = UserProvider();
    await userProvider.refresh();

    // 捕获 UI 崩溃
    FlutterError.onError = (FlutterErrorDetails details) {
      Log.e("🔥 UI 全局崩溃", error: details.exception, stackTrace: details.stack);
      FlutterError.presentError(details);
    };

    // 捕获 异步/原生 崩溃
    PlatformDispatcher.instance.onError = (error, stack) {
      Log.e("🔥 异步全局崩溃", error: error, stackTrace: stack);
      return true;
    };
  }
}
