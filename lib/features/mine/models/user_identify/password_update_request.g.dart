// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordUpdateRequest _$PasswordUpdateRequestFromJson(
  Map<String, dynamic> json,
) => PasswordUpdateRequest(
  oldIdentifyValue: json['oldIdentifyValue'] as String,
  newIdentifyValue: json['newIdentifyValue'] as String,
)..identifyType = json['identifyType'] as String;

Map<String, dynamic> _$PasswordUpdateRequestToJson(
  PasswordUpdateRequest instance,
) => <String, dynamic>{
  'identifyType': instance.identifyType,
  'oldIdentifyValue': instance.oldIdentifyValue,
  'newIdentifyValue': instance.newIdentifyValue,
};
