import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/extend_infodto.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 注册页 ViewModel — 业务逻辑与 UI 分离
///
/// 职责：
/// - 管理表单状态（账号、验证码、协议勾选）
/// - 执行注册流程（校验 → 组装请求 → 调用 API → 返回结果）
/// - 管理 Loading 状态（UI 通过 Selector 监听 isLoading）
///
/// 可独立单元测试，不依赖 Flutter Widget 生命周期
class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService;

  // 隐私协议版本号
  static const String _privacyVersion = 'v1.0';

  // ====================== 表单状态 ======================

  /// 账号
  String account = '';

  /// 验证码
  String verifyCode = '';

  /// 验证码唯一标识
  String verifyCodeUniqueId = '';

  /// 协议勾选状态
  bool _isAgree = false;
  bool get isAgree => _isAgree;
  set isAgree(bool value) {
    _isAgree = value;
    notifyListeners();
  }

  // ====================== UI 状态 ======================

  /// 是否正在提交
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 错误信息（UI 展示用）
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 是否注册成功
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  SignUpViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  // ====================== 业务逻辑 ======================

  /// 协议必选校验
  ///
  /// 返回错误信息，null 表示校验通过
  String? checkAgreement() {
    if (!isAgree) return L10nUtils.agreeTermsFirst;
    return null;
  }

  /// 执行注册
  ///
  /// 返回 [ServiceResponse]，UI 层根据结果决定后续操作（Toast、导航等）
  Future<ServiceResponse> register() async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    AppToast.showLoading();

    try {
      // 提交时构建 VerificationCode
      final verificationCode = VerificationCode(verifyCode, verifyCodeUniqueId);

      final response = await _authService.register(
        UserRegistRequest(
          loginId: account,
          verificationCode: verificationCode,
          extendInfoDTO: ExtendInfoDto(privacyVersion: _privacyVersion),
        ),
      );

      _isSuccess = response.success;
      if (!response.success) {
        _errorMessage = response.errorContext ?? L10nUtils.registerFailed;
      }

      return response;
    } catch (e) {
      _errorMessage = L10nUtils.registerFailed;
      _isSuccess = false;
      // 返回一个失败响应，保持返回类型一致
      return ServiceResponse(success: false, errorContext: _errorMessage);
    } finally {
      _isLoading = false;
      AppToast.dismiss();
      notifyListeners();
    }
  }
}
