import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/extend_infodto.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';

part 'user_regist_request.g.dart';

@JsonSerializable()
class UserRegistRequest {
  String? userName;
  String loginId;
  final String loginType = "1";
  String? identifyType = "1";
  String? identifyValue;

  VerificationCode verificationCode;

  ExtendInfoDto extendInfoDto;

  UserRegistRequest({
    this.userName,
    required this.loginId,
    required this.verificationCode,
    required this.extendInfoDto,
    this.identifyValue,
  });
  factory UserRegistRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegistRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserRegistRequestToJson(this);
}
