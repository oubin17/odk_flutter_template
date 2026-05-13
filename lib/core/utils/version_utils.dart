import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// 版本号工具类（比较版本号大小）
class VersionUtils {
  /// 跳转到应用市场
  /// [androidUrl] Android 应用市场地址（可选，为空则跳转默认应用市场）
  /// [iosUrl] iOS App Store 地址（可选，为空则跳转默认 App Store）
  static Future<bool> launchAppStore({
    String? androidUrl,
    String? iosUrl,
  }) async {
    if (Platform.isAndroid) {
      // 优先使用自定义地址，否则跳转默认应用市场
      final url = androidUrl;
      if (url != null && url.isNotEmpty) {
        return _launchUrl(url);
      }
      // 没有自定义地址时，尝试打开默认应用市场
      // 注意：这里需要传入应用的包名
      return false;
    } else if (Platform.isIOS) {
      // 优先使用自定义地址，否则跳转默认 App Store
      final url = iosUrl;
      if (url != null && url.isNotEmpty) {
        return _launchUrl(url);
      }
      return false;
    }
    return false;
  }

  /// 跳转到 Android 应用市场（通过包名）
  static Future<bool> launchAndroidMarket(String packageName) async {
    // 尝试多个应用市场的 URI scheme
    final marketUrls = [
      // 华为应用市场
      'appmarket://details?id=$packageName',
      // 小米应用商店
      'mimarket://details?id=$packageName',
      // OPPO 应用商店
      'oppomarket://details?packagename=$packageName',
      // vivo 应用商店
      'vivomarket://details?id=$packageName',
      // 应用宝
      'tmast://appdetails?pname=$packageName',
      // Google Play
      'market://details?id=$packageName',
      // Google Play Web 备用
      'https://play.google.com/store/apps/details?id=$packageName',
    ];

    for (final url in marketUrls) {
      final launched = await _launchUrl(url);
      if (launched) return true;
    }
    return false;
  }

  /// 跳转到 iOS App Store（通过 appId）
  static Future<bool> launchIOSAppStore(String appId) async {
    final url = 'https://apps.apple.com/app/id$appId';
    return _launchUrl(url);
  }

  /// 通用 URL 跳转
  static Future<bool> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
