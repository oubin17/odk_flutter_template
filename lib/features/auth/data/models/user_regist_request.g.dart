// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_regist_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistRequest _$UserRegistRequestFromJson(Map<String, dynamic> json) =>
    UserRegistRequest(
      userName: json['userName'] as String,
      loginId: json['loginId'] as String,
      identifyValue: json['identifyValue'] as String,
    );

Map<String, dynamic> _$UserRegistRequestToJson(UserRegistRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'loginId': instance.loginId,
      'identifyValue': instance.identifyValue,
    };
