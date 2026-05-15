import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/features/auth/models/verify_code/verification_code.dart';

part 'password_reset_request.g.dart';

@JsonSerializable()
class PasswordResetRequest {
  String identifyType = "1";
  String identifyValue;
  VerificationCode verificationCode;

  PasswordResetRequest({
    required this.identifyValue,
    required this.verificationCode,
  });
  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}
