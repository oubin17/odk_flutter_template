import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
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

  Future<UserLoginResponse?> loginAfterRegister(
    UserRegistRequest request,
  ) async {
    ServiceResponse response = await ApiService().post(
      '/user/register/login',
      request.toJson(),
    );
    return UserLoginResponse.fromJson(response.data as Map<String, dynamic>)
        as UserLoginResponse?;
  }

  Future<UserLoginResponse?> login(UserLoginRequest request) async {
    ServiceResponse response = await ApiService().post(
      '/user/login',
      request.toJson(),
    );

    if (response.data == null) {
      return null;
    }

    return UserLoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await ApiService().post('/user/logout', {});
  }

  /// 获取用户信息
  Future<UserEntity> getUserInfo() async {
    ServiceResponse response = await ApiService().get('/user/query');

    return UserEntity.fromJson(response.data as Map<String, dynamic>);
  }

  /// 验证 token 是否有效
  Future<void> validateToken() async {
    await ApiService().get('/system/validateToken');
  }

  /// 生成验证码
  Future<VerificationCodeResponse?> sendVerifyCode(
    VerificationCodeRequest request,
  ) async {
    ServiceResponse response = await ApiService().post(
      '/verifycode/generate',
      request.toJson(),
    );

    if (response.data == null) {
      return null;
    }

    return VerificationCodeResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
