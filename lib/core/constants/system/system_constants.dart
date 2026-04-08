class SystemConstants {
  static const String serverName = 'odk-base-template';
  //环境配置
  static const String environment = 'dev';

  // 公共请求头
  static const String tokenHeader = 'ODK-TOKEN';

  // 租户ID
  static const String tenantId = 'DEFAULT';

  // static const String tenantId = 'ODK-LUSHI';

  static String get serverIp {
    // iOS 模拟器或真机
    switch (environment) {
      case 'dev':
        return '192.168.31.228';
      // return '172.27.16.154';
      case 'test':
        return 'xxx';
      case 'prod':
        return 'xxx';
      default:
        return 'xxx';
    }
  }

  static String get serverPort {
    switch (environment) {
      case 'dev':
        return '8080';
      case 'test':
        return '8080';
      case 'prod':
        return '8080';
      default:
        return '8080';
    }
  }
}
