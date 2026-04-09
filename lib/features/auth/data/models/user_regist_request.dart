import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserRegistRequest {
  String userName;
  String loginId;
  final String loginType = "1";
  final String identifyType = "1";
  String identifyValue;

  UserRegistRequest({
    required this.userName,
    required this.loginId,
    required this.identifyValue,
  });
}
