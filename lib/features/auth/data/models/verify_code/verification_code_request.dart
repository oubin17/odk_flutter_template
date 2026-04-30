import 'package:json_annotation/json_annotation.dart';

part 'verification_code_request.g.dart';

@JsonSerializable()
class VerificationCodeRequest {
  String verifyType;

  String verifyKey;

  String verifyScene;

  VerificationCodeRequest({
    required this.verifyType,
    required this.verifyKey,
    required this.verifyScene,
  });
  factory VerificationCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerificationCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationCodeRequestToJson(this);
}
