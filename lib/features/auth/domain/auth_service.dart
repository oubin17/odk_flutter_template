import 'package:odk_flutter_template/core/session/user_session_service.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/utils/encrypt_utils.dart';
import 'package:odk_flutter_template/features/auth/data/api/auth_api.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  // 登录状态（默认未登录）
  // bool isLoggedIn = false;

  /// 注册
  Future<ServiceResponse> register(UserRegistRequest request) async {
    if (request.identifyValue != null) {
      request.identifyValue = await EncryptUtils.encrypt(
        request.identifyValue!,
      );
    }

    ServiceResponse response = await AuthApi().loginAfterRegister(request);
    if (response.success) {
      UserLoginResponse userLoginResponse = UserLoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      await _doAfterLogin(userLoginResponse);
    }
    return response;
  }

  /// 登录
  Future<UserLoginResponse?> login(UserLoginRequest request) async {
    //
    if (request.identifyValue != null) {
      request.identifyValue = await EncryptUtils.encrypt(
        request.identifyValue!,
      );
    }
    // 拦截器已经统一处理了所有异常
    UserLoginResponse? response = await AuthApi().login(request);

    if (response != null) {
      await _doAfterLogin(response);
    }
    return response;
  }

  Future<void> _doAfterLogin(UserLoginResponse response) async {
    await UserSessionService().syncUserSession(
      response,
      token: response.token,
      updateToken: true,
    );
  }

  /// 登录方法，返回用户 ID
  Future<void> logout() async {
    // 拦截器已经统一处理了所有异常
    await AuthApi().logout();
    await afterLogout();
  }

  /// 登出后需要执行的操作，清除 storage 中的所有数据
  Future<void> afterLogout() async {
    await UserSessionService().clearSession(clearAllStorage: true);
  }

  /// 检查用户是否已登录
  Future<bool> checkLoggedIn() async {
    // 读取加密存储中的 token
    final token = await SecureStorageManager().read(StorageKey.token);
    // 不为空且不为空字符串，说明已登录
    if (token == null || token.isEmpty) return false;
    await AuthApi().validateToken();
    return true;
  }
}
