import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/auth/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class AuthApi {
  // 单例实例
  static final AuthApi _instance = AuthApi._internal();

  AuthApi._internal();
  factory AuthApi() => _instance;

  /// 注册
  // Future<String?> register(UserRegistRequest request) async {
  //   ServiceResponse response = await ApiService().post(
  //     '/user/register',
  //     request.toJson(),
  //   );
  //   return response.data as String?;
  // }

  /// 注册后登录
  Future<ServiceResponse> loginAfterRegister(UserRegistRequest request) async {
    return await ApiService().post('/user/register/login', request.toJson());
  }

  /// 登录：验证码登录，密码登录
  /// 返回 [ServiceResponse]，由 AuthService 解析结果
  Future<ServiceResponse> login(UserLoginRequest request) async {
    return await ApiService().post('/user/login', request.toJson());
  }

  /// 退出登录
  Future<void> logout() async {
    await ApiService().post('/user/logout', {});
  }

  /// 删除账户
  Future<void> deletion() async {
    await ApiService().post('/user/status/deletion', {});
  }
}
