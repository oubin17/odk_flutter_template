import 'package:flutter_flavor/flutter_flavor.dart';

// 1. 环境枚举（你原有的，保留）
enum Environment { dev, test, prod }

// 2. 【核心】抽离所有配置 Key → 统一常量管理
// 以后改 Key 只改这里，全局自动生效！
class ConfigKey {
  static const String serverName = 'serverName';
  static const String tokenHeader = 'ODK-TOKEN';
  static const String tenantId = 'tenantId';
  static const String serverUri = 'serverUri';
  static const String httpTimeout = 'httpTimeout';

  // 👇 新增：签名密钥 Key（统一管理，杜绝硬编码）
  static const String signSecret = 'signSecret';
}

// 3. 公共配置（使用常量 Key，无硬编码）
const Map<String, String> commonVariables = {
  ConfigKey.serverName: 'odk-base-template',
  ConfigKey.tokenHeader: 'ODK-TOKEN',
  ConfigKey.tenantId: 'DEFAULT',
  ConfigKey.httpTimeout: '3',
};

// 4. 各环境独立配置（继承公共配置，常量 Key）
const Map<String, String> devVariables = {
  ...commonVariables,
  // ConfigKey.serverUri: 'http://172.27.16.154:8080/odk-base-template/api',
  ConfigKey.serverUri: 'http://192.168.31.228:8080/odk-base-template/api',

  // 开发环境专属密钥
  ConfigKey.signSecret: 'flutter_app_dev_sign_secret_2025',
};

const Map<String, String> testVariables = {
  ...commonVariables,
  ConfigKey.serverUri: 'http://xxx:8080/odk-base-template/api',

  // 测试环境专属密钥
  ConfigKey.signSecret: 'flutter_app_test_sign_secret_2025',
};

const Map<String, String> prodVariables = {
  ...commonVariables,
  ConfigKey.serverUri: 'http://xxx:8080/odk-base-template/api',

  // 生产环境专属密钥
  ConfigKey.signSecret: 'flutter_app_prod_sign_secret_2025',
};

// 5. 【可选推荐】封装快捷获取方法 → 彻底告别字符串！
class Env {
  // 获取配置
  static String get(String key) {
    return FlavorConfig.instance.variables[key] ?? '';
  }

  // 快捷访问（最推荐！直接调用 Env.tenantId）
  static String get serverName => get(ConfigKey.serverName);
  static String get tokenHeader => get(ConfigKey.tokenHeader);
  static String get tenantId => get(ConfigKey.tenantId);
  static String get serverUri => get(ConfigKey.serverUri);
  static int get httpTimeout => int.parse(get(ConfigKey.httpTimeout));
  // 👇 新增：快捷获取签名密钥
  static String get signSecret => get(ConfigKey.signSecret);
}
