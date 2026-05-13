import 'package:odk_flutter_template/features/auth/data/api/verify_code_api.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';

class VerifyCodeService {
  // 单例实例
  static final VerifyCodeService _instance = VerifyCodeService._internal();

  VerifyCodeService._internal();
  factory VerifyCodeService() => _instance;

  /// 发送验证码
  Future<VerificationCodeResponse> sendVerifyCode(
    VerificationCodeRequest request,
  ) async {
    // 拦截器已经统一处理了所有异常
    return await VerifyCodeApi().sendVerifyCode(request)
        as VerificationCodeResponse;
  }
}
