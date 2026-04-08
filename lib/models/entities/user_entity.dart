import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/models/entities/access_token_entity.dart';
import 'package:odk_flutter_template/models/entities/role_entity.dart';
import 'package:odk_flutter_template/models/entities/user_profile_entity.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  String userId;
  String userType;
  String userStatus;
  AccessTokenEntity accessToken;
  List<RoleEntity>? roles;
  UserProfileEntity? userProfile;

  bool get isAdmin => roles?.any((role) => role.roleCode == 'ADMIN') ?? false;
  // bool get isAdmin => accessToken.tokenValue == 'admin';

  UserEntity({
    required this.userId,
    required this.userType,
    required this.userStatus,
    required this.accessToken,
    this.roles,
    this.userProfile,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
