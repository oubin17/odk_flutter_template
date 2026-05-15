import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/auth/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class VerifyCodeApi {
  // 单例实例
  static final VerifyCodeApi _instance = VerifyCodeApi._internal();

  VerifyCodeApi._internal();
  factory VerifyCodeApi() => _instance;

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
