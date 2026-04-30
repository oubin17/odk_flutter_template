// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_regist_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistRequest _$UserRegistRequestFromJson(Map<String, dynamic> json) =>
    UserRegistRequest(
      userName: json['userName'] as String?,
      loginId: json['loginId'] as String,
      verificationCode: VerificationCode.fromJson(
        json['verificationCode'] as Map<String, dynamic>,
      ),
      extendInfoDto: ExtendInfoDto.fromJson(
        json['extendInfoDto'] as Map<String, dynamic>,
      ),
      identifyValue: json['identifyValue'] as String?,
    )..identifyType = json['identifyType'] as String?;

Map<String, dynamic> _$UserRegistRequestToJson(UserRegistRequest instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'loginId': instance.loginId,
      'identifyType': instance.identifyType,
      'identifyValue': instance.identifyValue,
      'verificationCode': instance.verificationCode,
      'extendInfoDto': instance.extendInfoDto,
    };
