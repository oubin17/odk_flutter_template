import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/features/system/api/system_api.dart';
import 'package:odk_flutter_template/features/system/models/sys_global_config_dto.dart';

class SystemService {
  // 单例实例
  static final SystemService _instance = SystemService._internal();

  SystemService._internal();
  factory SystemService() => _instance;

  /// 检查用户是否已登录
  Future<bool> checkLoggedIn() async {
    // 读取加密存储中的 token
    final token = await SecureStorageManager().read(StorageKey.token);
    // 不为空且不为空字符串，说明已登录
    if (token == null || token.isEmpty) return false;
    await SystemApi().validateToken();
    return true;
  }

  /// 获取全局配置
  Future<SysGlobalConfigDto> globalConfig(String configKey) async {
    return await SystemApi().globalConfig(configKey);
  }

  /// 提交用户反馈
  Future<void> submitFeedback(String content) async {
    await SystemApi().addFeedback(content);
  }
}
