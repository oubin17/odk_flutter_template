import 'package:json_annotation/json_annotation.dart';

part 'user_profile_request.g.dart';

@JsonSerializable()
class UserProfileRequest {
  final String? userName;
  final String? gender;
  final String? birthDay;

  UserProfileRequest({this.userName, this.gender, this.birthDay});

  factory UserProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UserProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileRequestToJson(this);
}
