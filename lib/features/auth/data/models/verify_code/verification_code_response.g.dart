// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCodeResponse _$VerificationCodeResponseFromJson(
  Map<String, dynamic> json,
) => VerificationCodeResponse(
  expireTime: (json['expireTime'] as num).toInt(),
  verifyTimes: (json['verifyTimes'] as num).toInt(),
  maxVerifyTimes: (json['maxVerifyTimes'] as num).toInt(),
  uniqueId: json['uniqueId'] as String,
);

Map<String, dynamic> _$VerificationCodeResponseToJson(
  VerificationCodeResponse instance,
) => <String, dynamic>{
  'expireTime': instance.expireTime,
  'verifyTimes': instance.verifyTimes,
  'maxVerifyTimes': instance.maxVerifyTimes,
  'uniqueId': instance.uniqueId,
};
