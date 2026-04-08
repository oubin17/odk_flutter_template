// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
  userId: json['userId'] as String,
  userType: json['userType'] as String,
  userStatus: json['userStatus'] as String,
  accessToken: AccessTokenEntity.fromJson(
    json['accessToken'] as Map<String, dynamic>,
  ),
  roles: (json['roles'] as List<dynamic>?)
      ?.map((e) => RoleEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  userProfile: json['userProfile'] == null
      ? null
      : UserProfileEntity.fromJson(json['userProfile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userType': instance.userType,
      'userStatus': instance.userStatus,
      'accessToken': instance.accessToken,
      'roles': instance.roles,
      'userProfile': instance.userProfile,
    };
