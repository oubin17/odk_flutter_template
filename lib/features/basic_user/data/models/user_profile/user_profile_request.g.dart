// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileRequest _$UserProfileRequestFromJson(Map<String, dynamic> json) =>
    UserProfileRequest(
      userName: json['userName'] as String?,
      gender: json['gender'] as String?,
      birthDay: json['birthDay'] as String?,
    );

Map<String, dynamic> _$UserProfileRequestToJson(UserProfileRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'gender': instance.gender,
      'birthDay': instance.birthDay,
    };
