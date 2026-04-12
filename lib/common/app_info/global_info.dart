import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

/// 全局设备&App信息缓存（启动时初始化一次）
class GlobalInfo {
  static final GlobalInfo instance = GlobalInfo._internal();
  GlobalInfo._internal();

  // App信息
  late String appVersion; // 版本号 X-App-Version
  late String appBuild; // 构建号 X-App-Build

  // 设备信息
  late String deviceId; // 设备唯一ID X-Device-ID
  late String osType; // 系统类型 android/ios
  late String osVersion; // 系统版本

  /// 初始化：APP启动时调用一次
  Future<void> init() async {
    // 1. 获取App信息
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appBuild = packageInfo.buildNumber;

    // 2. 获取设备信息
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      osType = 'android';
      osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      osType = 'ios';
      osVersion = iosInfo.systemVersion;
    }
  }
}
