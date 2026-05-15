import 'dart:convert';
import 'dart:io';

import 'package:odk_flutter_template/common/app_info/global_info.dart';
import 'package:odk_flutter_template/core/constants/sys_constants.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/core/utils/version_utils.dart';
import 'package:odk_flutter_template/features/mine/models/app_version_info.dart';
import 'package:odk_flutter_template/features/system/models/sys_global_config_dto.dart';
import 'package:odk_flutter_template/features/system/service/system_service.dart';

import '../models/version_check_result.dart';

/// 版本检查服务
class VersionCheckService {
  static final VersionCheckService _instance = VersionCheckService._();
  factory VersionCheckService() => _instance;
  VersionCheckService._();

  /// 检查版本更新
  ///
  /// 调用后端接口获取最新版本信息，与当前版本比较
  /// 返回 [VersionCheckResult] 包含是否有更新及最新版本信息
  Future<VersionCheckResult> checkUpdate() async {
    try {
      // 1. 获取当前版本信息（直接从 GlobalInfo 获取，避免重复异步调用）
      final currentVersion = GlobalInfo.instance.appVersion;

      // 2. 请求后端获取最新版本信息
      final SysGlobalConfigDto latestVersionConfig = await SystemService()
          .globalConfig(SysConstants.appLatestVersion);

      // 3. 将 configValue（JSON 字符串）反序列化为 AppVersionInfo
      final AppVersionInfo latestVersion = AppVersionInfo.fromJson(
        jsonDecode(latestVersionConfig.configValue) as Map<String, dynamic>,
      );

      // 4. 比较版本号：后端返回的 version 不为空且与当前版本不相等则有更新
      final hasUpdate =
          latestVersion.version.isNotEmpty &&
          latestVersion.version != currentVersion;

      return VersionCheckResult(
        hasUpdate: hasUpdate,
        latestVersion: hasUpdate ? latestVersion : null,
        currentVersion: currentVersion,
      );
    } catch (e) {
      // 网络异常等情况下，返回无更新
      Log.e('checkUpdate error: $e');
      return VersionCheckResult(
        hasUpdate: false,
        currentVersion: GlobalInfo.instance.appVersion,
      );
    }
  }

  /// 跳转到应用市场下载最新版本
  ///
  /// [versionInfo] 最新版本信息
  /// [packageName] Android 应用包名（用于跳转默认应用市场）
  Future<bool> goToUpdate(
    AppVersionInfo versionInfo, {
    String? packageName,
  }) async {
    if (Platform.isAndroid) {
      // 优先使用后端返回的 Android 地址
      if (versionInfo.androidUrl != null &&
          versionInfo.androidUrl!.isNotEmpty) {
        return VersionUtils.launchAppStore(androidUrl: versionInfo.androidUrl);
      }
      // 没有自定义地址，通过包名跳转应用市场
      if (packageName != null && packageName.isNotEmpty) {
        return VersionUtils.launchAndroidMarket(packageName);
      }
    } else if (Platform.isIOS) {
      // 优先使用后端返回的 iOS 地址
      if (versionInfo.iosUrl != null && versionInfo.iosUrl!.isNotEmpty) {
        return VersionUtils.launchAppStore(iosUrl: versionInfo.iosUrl);
      }
    }
    return false;
  }
}
