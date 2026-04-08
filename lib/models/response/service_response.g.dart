// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceResponse _$ServiceResponseFromJson(Map<String, dynamic> json) =>
    ServiceResponse(
      success: json['success'] as bool,
      data: json['data'],
      errorType: json['errorType'] as String?,
      errorCode: json['errorCode'] as String?,
      errorContext: json['errorContext'] as String?,
    );

Map<String, dynamic> _$ServiceResponseToJson(ServiceResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errorType': instance.errorType,
      'errorCode': instance.errorCode,
      'errorContext': instance.errorContext,
      'data': instance.data,
    };
