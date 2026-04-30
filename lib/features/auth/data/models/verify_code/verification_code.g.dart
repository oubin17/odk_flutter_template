// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCode _$VerificationCodeFromJson(Map<String, dynamic> json) =>
    VerificationCode(json['verifyCode'] as String, json['uniqueId'] as String);

Map<String, dynamic> _$VerificationCodeToJson(VerificationCode instance) =>
    <String, dynamic>{
      'verifyCode': instance.verifyCode,
      'uniqueId': instance.uniqueId,
    };
