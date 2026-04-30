import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';

part 'user_login_request.g.dart';

@JsonSerializable()
class UserLoginRequest {
  final String loginId;
  final String loginType = "1";
  //1-密码登录 2-验证码登录
  String identifyType; //1-密码登录 2-验证码登录
  String? identifyValue;
  VerificationCode? verificationCode;

  UserLoginRequest({
    required this.loginId,
    required this.identifyType,
    this.identifyValue,
    this.verificationCode,
  });
  factory UserLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$UserLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}
