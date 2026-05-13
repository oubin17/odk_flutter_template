// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sys_global_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SysGlobalConfigDto _$SysGlobalConfigDtoFromJson(Map<String, dynamic> json) =>
    SysGlobalConfigDto(
      configKey: json['configKey'] as String,
      configValue: json['configValue'] as String,
      configDesc: json['configDesc'] as String,
    );

Map<String, dynamic> _$SysGlobalConfigDtoToJson(SysGlobalConfigDto instance) =>
    <String, dynamic>{
      'configKey': instance.configKey,
      'configValue': instance.configValue,
      'configDesc': instance.configDesc,
    };
