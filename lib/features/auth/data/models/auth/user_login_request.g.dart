// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginRequest _$UserLoginRequestFromJson(Map<String, dynamic> json) =>
    UserLoginRequest(
      loginId: json['loginId'] as String,
      identifyType: json['identifyType'] as String,
      identifyValue: json['identifyValue'] as String?,
      verificationCode: json['verificationCode'] == null
          ? null
          : VerificationCode.fromJson(
              json['verificationCode'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UserLoginRequestToJson(UserLoginRequest instance) =>
    <String, dynamic>{
      'loginId': instance.loginId,
      'identifyType': instance.identifyType,
      'identifyValue': instance.identifyValue,
      'verificationCode': instance.verificationCode,
    };
