// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileEntity _$UserProfileEntityFromJson(Map<String, dynamic> json) =>
    UserProfileEntity(
      userName: json['userName'] as String?,
      gender: json['gender'] as String?,
      birthDay: json['birthDay'] as String?,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$UserProfileEntityToJson(UserProfileEntity instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'gender': instance.gender,
      'birthDay': instance.birthDay,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
    };
