import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

/// 全局设备 & App 信息缓存（启动时初始化一次）
///
/// 在 App 启动时调用 [init] 方法，将常用信息缓存到内存，
/// 后续通过 [GlobalInfo.instance.xxx] 同步获取，避免重复异步调用。
class GlobalInfo {
  static final GlobalInfo instance = GlobalInfo._internal();
  GlobalInfo._internal();

  final _uuid = const Uuid();

  // ======================== App 信息 ========================

  /// 应用版本号，如 "1.0.0"（对应 versionName / CFBundleShortVersionString）
  late String appVersion;

  /// 应用构建号，如 "1"（对应 versionCode / CFBundleVersion）
  late String appBuild;

  /// 应用包名 / Bundle Identifier，如 "com.example.app"
  late String packageName;

  /// 应用名称，如 "我的应用"
  late String appName;

  // ======================== 设备基础信息 ========================

  /// 设备唯一标识（优先使用硬件ID，兜底使用UUID并持久化）
  late String deviceId;

  /// 操作系统类型，如 "android"、"ios"、"macos"、"windows"、"linux"
  late String osType;

  /// 操作系统版本，如 "14.0"、"Android 13 (API 33)"
  late String osVersion;

  // ======================== Android 专属信息 ========================

  /// Android 设备品牌，如 "Xiaomi"、"HUAWEI"（非 Android 平台为空字符串）
  late String deviceBrand;

  /// Android 设备型号，如 "MI 10"、"Pixel 6"（非 Android 平台为空字符串）
  late String deviceModel;

  /// Android 设备制造商，如 "Xiaomi"、"Google"（非 Android 平台为空字符串）
  late String deviceManufacturer;

  /// Android SDK 版本号（API Level），如 33（非 Android 平台为 0）
  late int androidSdkInt;

  /// 设备是否为真机（非 Android/iOS 平台为 false）
  late bool isPhysicalDevice;

  // ======================== iOS 专属信息 ========================

  /// iOS 设备型号标识，如 "iPhone14,2"（非 iOS 平台为空字符串）
  late String iosModelName;

  /// iOS 系统名称，如 "iOS"（非 iOS 平台为空字符串）
  late String iosSystemName;

  // ======================== 屏幕信息 ========================

  /// 屏幕宽度（逻辑像素），如 375.0
  late double screenWidth;

  /// 屏幕高度（逻辑像素），如 812.0
  late double screenHeight;

  /// 设备像素比，如 3.0
  late double devicePixelRatio;

  // ======================== 平台快捷判断 ========================

  /// 是否为 Android 平台
  late bool isAndroid;

  /// 是否为 iOS 平台
  late bool isIOS;

  /// 是否为移动端（Android 或 iOS）
  late bool isMobile;

  /// 是否为桌面端（macOS / Windows / Linux）
  late bool isDesktop;

  /// 是否为 Web 平台
  late bool isWeb;

  /// 是否为模拟器（非真机）
  bool get isSimulator => isMobile && !isPhysicalDevice;

  // ======================== 网络信息 ========================

  /// 设备语言标签，如 "zh-CN"、"en-US"
  late String locale;

  /// 设备时区名称，如 "Asia/Shanghai"
  late String timeZoneName;

  /// 初始化：APP启动时调用一次
  Future<void> init() async {
    try {
      await _initAppInfo();
      await _initSafeDeviceId();
      await _fillSysInfo();
      _initPlatformInfo();
      _initScreenInfo();
      _initLocaleInfo();
    } catch (e) {
      // 终极兜底，绝不崩溃
      _fillDefaults();
    }
  }

  // 初始化App信息
  Future<void> _initAppInfo() async {
    final package = await PackageInfo.fromPlatform();
    appVersion = package.version;
    appBuild = package.buildNumber;
    packageName = package.packageName;
    appName = package.appName;
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

  // 填充系统信息（含平台专属设备详情）
  Future<void> _fillSysInfo() async {
    osType = Platform.operatingSystem;
    osVersion = Platform.operatingSystemVersion;

    // 初始化平台专属字段默认值
    deviceBrand = '';
    deviceModel = '';
    deviceManufacturer = '';
    androidSdkInt = 0;
    isPhysicalDevice = false;
    iosModelName = '';
    iosSystemName = '';

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceBrand = info.brand;
      deviceModel = info.model;
      deviceManufacturer = info.manufacturer;
      androidSdkInt = info.version.sdkInt;
      isPhysicalDevice = info.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      iosModelName = info.utsname.machine;
      iosSystemName = info.systemName;
      isPhysicalDevice = info.isPhysicalDevice;
    }
  }

  // 初始化平台快捷判断
  void _initPlatformInfo() {
    isAndroid = Platform.isAndroid;
    isIOS = Platform.isIOS;
    isMobile = Platform.isAndroid || Platform.isIOS;
    isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    isWeb = false; // dart:io 中 Platform 不支持 web，web 端需另行处理
  }

  // 初始化屏幕信息
  void _initScreenInfo() {
    // 使用 dart:ui 获取屏幕信息，无需额外依赖
    // 注意：需在 WidgetsFlutterBinding.ensureInitialized() 之后调用
    try {
      final view = PlatformDispatcher.instance.views.first;
      screenWidth = view.physicalSize.width / view.devicePixelRatio;
      screenHeight = view.physicalSize.height / view.devicePixelRatio;
      devicePixelRatio = view.devicePixelRatio;
    } catch (e) {
      screenWidth = 0;
      screenHeight = 0;
      devicePixelRatio = 1.0;
    }
  }

  // 初始化语言和时区信息
  void _initLocaleInfo() {
    try {
      final platformDispatcher = PlatformDispatcher.instance;
      locale = platformDispatcher.locale.toString();
      timeZoneName = DateTime.now().timeZoneName;
    } catch (e) {
      locale = 'zh-CN';
      timeZoneName = 'UTC';
    }
  }

  // 终极兜底：所有字段赋予安全默认值
  void _fillDefaults() {
    appVersion = '1.0.0';
    appBuild = '1';
    packageName = '';
    appName = '';
    deviceId = _uuid.v4();
    osType = Platform.operatingSystem;
    osVersion = 'unknown';
    deviceBrand = '';
    deviceModel = '';
    deviceManufacturer = '';
    androidSdkInt = 0;
    isPhysicalDevice = false;
    iosModelName = '';
    iosSystemName = '';
    screenWidth = 0;
    screenHeight = 0;
    devicePixelRatio = 1.0;
    isAndroid = Platform.isAndroid;
    isIOS = Platform.isIOS;
    isMobile = Platform.isAndroid || Platform.isIOS;
    isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    isWeb = false;
    locale = 'zh-CN';
    timeZoneName = 'UTC';
  }
}
