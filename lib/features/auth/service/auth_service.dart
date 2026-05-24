import 'package:odk_flutter_template/core/crash/bugly_service.dart';
import 'package:odk_flutter_template/core/session/user_session_service.dart';
import 'package:odk_flutter_template/core/utils/encrypt_utils.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/api/auth_api.dart';
import 'package:odk_flutter_template/features/auth/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/models/auth/userlogin_response.dart';
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
  ///
  /// 返回 `({UserLoginResponse? user, String? errorMessage})`：
  /// - 登录成功：user 不为 null，errorMessage 为 null
  /// - 失败（业务/网络）：user 为 null，errorMessage 为错误信息
  ///   - 业务失败：errorMessage 为服务端返回的 errorContext
  ///   - 网络异常：errorMessage 为通用网络错误提示（拦截器已弹 Toast）
  Future<({UserLoginResponse? user, String? errorMessage})> login(
    UserLoginRequest request,
  ) async {
    if (request.identifyValue != null) {
      request.identifyValue = await EncryptUtils.encrypt(
        request.identifyValue!,
      );
    }

    final response = await AuthApi().login(request);

    if (!response.success) {
      return (
        user: null,
        // ✅ 优先根据 errorCode 映射国际化文本，降级到 errorContext，最终降级到 loginFailed
        errorMessage: response.localizedErrorMessage(L10nUtils.loginFailed),
      );
    }

    if (response.data == null) {
      return (user: null, errorMessage: L10nUtils.loginFailed);
    }

    final userLoginResponse = UserLoginResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    await _doAfterLogin(userLoginResponse);
    return (user: userLoginResponse, errorMessage: null);
  }

  Future<void> _doAfterLogin(UserLoginResponse response) async {
    await UserSessionService().syncUserSession(
      response,
      token: response.token,
      updateToken: true,
    );
    // 🔥 设置 Bugly 用户标识，便于在 Bugly 后台按用户筛选崩溃
    if (response.userId.isNotEmpty) {
      await BuglyService.instance.setUserId(response.userId);
    }
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
    // 🔥 清除 Bugly 用户标识
    await BuglyService.instance.setUserId('');
  }

  /// 删除账户
  Future<void> deletion() async {
    await AuthApi().deletion();
    await afterLogout();
  }
}
