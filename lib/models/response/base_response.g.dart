// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
  success: json['success'] as bool,
  errorType: json['errorType'] as String?,
  errorCode: json['errorCode'] as String?,
  errorContext: json['errorContext'] as String?,
);

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errorType': instance.errorType,
      'errorCode': instance.errorCode,
      'errorContext': instance.errorContext,
    };
