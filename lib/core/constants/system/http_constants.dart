import 'package:odk_flutter_template/core/constants/system/system_constants.dart';

class HttpConstants {
  // 根据平台自动选择正确的 baseUrl
  static String get baseUrl {
    return 'http://${SystemConstants.serverIp}:${SystemConstants.serverPort}/${SystemConstants.serverName}/api';

    // return 'http://${SystemConstants.serverIp}:8080/odk-base-template/api';

    // iOS 模拟器或真机
    // if (Platform.isIOS) {
    //   return 'http://$SystemConstants.serverIp:8080/odk-base-template/api';
    // }

    // // Android 模拟器
    // if (Platform.isAndroid) {
    //   return 'http://10.0.2.2:8080/odk-base-template/api';
    // }

    // // Web、macOS、Windows、Linux
    // return 'http://localhost:8080/odk-base-template/api';
  }

  // 公共请求头
  static const Map<String, dynamic> commonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-TENANT-ID': SystemConstants.tenantId,
    // 可以在这里添加其他公共请求头，例如：
    // 'Platform': 'mobile',
    // 'Version': '1.0.0',
  };
}
