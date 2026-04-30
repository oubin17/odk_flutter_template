import 'package:json_annotation/json_annotation.dart';

part 'verification_code.g.dart';

@JsonSerializable()
class VerificationCode {
  String verifyCode;
  String uniqueId;
  VerificationCode(this.verifyCode, this.uniqueId);
  factory VerificationCode.fromJson(Map<String, dynamic> json) =>
      _$VerificationCodeFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationCodeToJson(this);
}
