import 'package:device_info_plus/device_info_plus.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

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

  final _uuid = const Uuid();
  final StorageManager prefs = StorageManager();

  /// 初始化：APP启动时调用一次
  Future<void> init() async {
    try {
      await _initAppInfo();
      await _initSafeDeviceId();
      await _fillSysInfo();
    } catch (e) {
      // 终极兜底，绝不崩溃
      deviceId = _uuid.v4();
      osType = Platform.operatingSystem;
      osVersion = 'unknown';
      appVersion = '1.0.0';
      appBuild = '1';
    }
  }

  // 初始化App信息
  Future<void> _initAppInfo() async {
    final package = await PackageInfo.fromPlatform();
    appVersion = package.version;
    appBuild = package.buildNumber;
  }

  // 初始化安全设备ID（全平台兜底）
  Future<void> _initSafeDeviceId() async {
    // 1. 读取本地已存储的ID
    final localId = StorageManager().getString(StorageKey.deviceId);
    if (localId != null && localId.isNotEmpty) {
      deviceId = localId;
      return;
    }

    // 2. 安卓/iOS 尝试获取硬件ID
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final info = await deviceInfo.androidInfo;
          deviceId = info.id;
        } else {
          final info = await deviceInfo.iosInfo;
          deviceId = info.identifierForVendor ?? _uuid.v4();
        }
      } catch (e) {
        deviceId = _uuid.v4();
      }
    } else {
      // 3. 其他平台直接生成UUID
      deviceId = _uuid.v4();
    }
    // 4. 持久化存储
    StorageManager().setString(StorageKey.deviceId, deviceId);
  }

  // 填充系统信息
  Future<void> _fillSysInfo() async {
    osType = Platform.operatingSystem;
    osVersion = Platform.operatingSystemVersion;
  }
}
