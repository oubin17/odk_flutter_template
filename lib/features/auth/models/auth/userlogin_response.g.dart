// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userlogin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginResponse _$UserLoginResponseFromJson(Map<String, dynamic> json) =>
    UserLoginResponse(
      token: json['token'] as String?,
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
          : UserProfileEntity.fromJson(
              json['userProfile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UserLoginResponseToJson(UserLoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userType': instance.userType,
      'userStatus': instance.userStatus,
      'accessToken': instance.accessToken.toJson(),
      'roles': instance.roles?.map((e) => e.toJson()).toList(),
      'userProfile': instance.userProfile?.toJson(),
      'token': instance.token,
    };
