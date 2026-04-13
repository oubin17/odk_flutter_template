import 'package:json_annotation/json_annotation.dart';

part 'user_login_request.g.dart';

@JsonSerializable()
class UserLoginRequest {
  final String loginId;
  final String loginType = "1";
  final String identifyType = "1";
  String identifyValue;

  UserLoginRequest({required this.loginId, required this.identifyValue});
  factory UserLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$UserLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}
