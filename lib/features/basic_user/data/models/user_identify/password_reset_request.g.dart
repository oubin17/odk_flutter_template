// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetRequest _$PasswordResetRequestFromJson(
  Map<String, dynamic> json,
) => PasswordResetRequest(
  identifyValue: json['identifyValue'] as String,
  verificationCode: VerificationCode.fromJson(
    json['verificationCode'] as Map<String, dynamic>,
  ),
)..identifyType = json['identifyType'] as String;

Map<String, dynamic> _$PasswordResetRequestToJson(
  PasswordResetRequest instance,
) => <String, dynamic>{
  'identifyType': instance.identifyType,
  'identifyValue': instance.identifyValue,
  'verificationCode': instance.verificationCode.toJson(),
};
