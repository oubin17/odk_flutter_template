import 'package:json_annotation/json_annotation.dart';

part 'user_profile_entity.g.dart';

@JsonSerializable()
class UserProfileEntity {
  String? userName;
  String? gender;
  String? birthDay;

  UserProfileEntity({this.userName, this.gender, this.birthDay});

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);

  // 2. 👇 添加这个 toJson 方法
  Map<String, dynamic> toJson() => _$UserProfileEntityToJson(this);
}
