import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/system/models/sys_global_config_dto.dart';

class SystemApi {
  // 单例实例
  static final SystemApi _instance = SystemApi._internal();

  SystemApi._internal();
  factory SystemApi() => _instance;

  /// 验证 token 是否有效
  Future<void> validateToken() async {
    await ApiService().get('/system/validateToken');
  }

  /// 获取全局配置
  Future<SysGlobalConfigDto> globalConfig(String configKey) async {
    final response = await ApiService().postWithQueryParameters(
      '/sys/global/config/get',
      {'configKey': configKey},
      {},
    );
    if (response.data == null) {
      return SysGlobalConfigDto(
        configKey: configKey,
        configValue: '',
        configDesc: '',
      );
    }
    return SysGlobalConfigDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// 获取全局配置
  Future<void> addFeedback(String content) async {
    await ApiService().post('/sys/feedback/add', {'content': content});
  }
}
