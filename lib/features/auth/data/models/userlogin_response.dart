import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/models/entities/access_token_entity.dart';
import 'package:odk_flutter_template/models/entities/role_entity.dart';
import 'package:odk_flutter_template/models/entities/user_profile_entity.dart';

part 'userlogin_response.g.dart';

@JsonSerializable()
class UserLoginResponse extends UserEntity {
  String? token;

  UserLoginResponse({
    this.token,
    required super.userId,
    required super.userType,
    required super.userStatus,
    required super.accessToken,
    super.roles,
    super.userProfile,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$UserLoginResponseFromJson(json);

  // 2. 👇 添加这个 toJson 方法
  Map<String, dynamic> toJson() => _$UserLoginResponseToJson(this);
}
