import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/auth/data/models/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_response.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class AuthApi {
  // 单例实例
  static final AuthApi _instance = AuthApi._internal();

  AuthApi._internal();
  factory AuthApi() => _instance;

  /// 注册
  Future<String?> register(UserRegistRequest request) async {
    ServiceResponse response = await ApiService().post('/user/register', {
      'loginId': request.loginId,
      'identifyValue': request.identifyValue,
      "loginType": request.loginType,
      "identifyType": request.identifyType,
      "userName": request.userName,
    });
    return response.data as String?;
  }

  Future<UserLoginResponse?> login(UserLoginRequest request) async {
    ServiceResponse response = await ApiService().post('/user/login', {
      'loginId': request.loginId,
      'identifyValue': request.identifyValue,
      "loginType": request.loginType,
      "identifyType": request.identifyType,
    });

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
}
