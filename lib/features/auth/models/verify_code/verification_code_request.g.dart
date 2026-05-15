// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCodeRequest _$VerificationCodeRequestFromJson(
  Map<String, dynamic> json,
) => VerificationCodeRequest(
  verifyType: json['verifyType'] as String,
  verifyKey: json['verifyKey'] as String,
  verifyScene: json['verifyScene'] as String,
);

Map<String, dynamic> _$VerificationCodeRequestToJson(
  VerificationCodeRequest instance,
) => <String, dynamic>{
  'verifyType': instance.verifyType,
  'verifyKey': instance.verifyKey,
  'verifyScene': instance.verifyScene,
};
