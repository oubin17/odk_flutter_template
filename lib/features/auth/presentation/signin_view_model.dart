import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/features/auth/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';

/// 登录页 ViewModel — 业务逻辑与 UI 分离
///
/// 职责：
/// - 管理表单状态（账号、密码/验证码、登录方式、协议勾选）
/// - 执行登录流程（校验 → 组装请求 → 调用 API → 返回结果）
///
/// 防重复点击由 AppDebounceButton 在 UI 层处理，ViewModel 不再管理 isLoading
/// 可独立单元测试，不依赖 Flutter Widget 生命周期
class SignInViewModel extends ChangeNotifier {
  final AuthService _authService;

  // ====================== 表单状态 ======================

  /// 账号
  String account = '';

  /// 密码
  String password = '';

  /// 验证码
  String verifyCode = '';

  /// 验证码唯一标识
  String verifyCodeUniqueId = '';

  /// 登录方式：true=密码登录，false=验证码登录
  bool isPasswordLogin = true;

  /// 协议勾选状态
  bool _isAgree = false;
  bool get isAgree => _isAgree;
  set isAgree(bool value) {
    _isAgree = value;
    notifyListeners();
  }

  // ====================== UI 状态 ======================

  /// 错误信息（UI 展示用）
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SignInViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  // ====================== 状态更新 ======================

  /// 切换登录方式
  void toggleLoginType() {
    isPasswordLogin = !isPasswordLogin;
    notifyListeners();
  }

  // ====================== 业务逻辑 ======================

  /// 协议必选校验
  ///
  /// 返回错误信息，null 表示校验通过
  String? checkAgreement() {
    if (!isAgree) return L10nUtils.agreeTermsFirst;
    return null;
  }

  /// 执行登录
  ///
  /// 返回 [UserLoginResponse?]，UI 层负责错误提示
  /// 网络异常由拦截器统一处理（Toast + resolve），不会抛出异常
  Future<UserLoginResponse?> login() async {
    _errorMessage = null;

    ({UserLoginResponse? user, String? errorMessage}) result;

    if (isPasswordLogin) {
      // 密码登录
      result = await _authService.login(
        UserLoginRequest(
          loginId: account,
          identifyType: "1",
          identifyValue: password,
        ),
      );
    } else {
      // 验证码登录：提交时构建 VerificationCode
      final verificationCode = VerificationCode(verifyCode, verifyCodeUniqueId);
      result = await _authService.login(
        UserLoginRequest(
          loginId: account,
          identifyType: "2",
          verificationCode: verificationCode,
        ),
      );
    }

    _errorMessage = result.errorMessage;

    return result.user;
  }
}
