import 'package:json_annotation/json_annotation.dart';

part 'verification_code_response.g.dart';

@JsonSerializable()
class VerificationCodeResponse {
  int expireTime;
  int verifyTimes;
  int maxVerifyTimes;
  String uniqueId;
  VerificationCodeResponse({
    required this.expireTime,
    required this.verifyTimes,
    required this.maxVerifyTimes,
    required this.uniqueId,
  });
  factory VerificationCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationCodeResponseToJson(this);
}
