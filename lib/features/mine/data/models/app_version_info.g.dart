// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionInfo _$AppVersionInfoFromJson(Map<String, dynamic> json) =>
    AppVersionInfo(
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as String?,
      updateContent: json['updateContent'] as String?,
      forceUpdate: json['forceUpdate'] as bool?,
      androidUrl: json['androidUrl'] as String?,
      iosUrl: json['iosUrl'] as String?,
    );

Map<String, dynamic> _$AppVersionInfoToJson(AppVersionInfo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'updateContent': instance.updateContent,
      'forceUpdate': instance.forceUpdate,
      'androidUrl': instance.androidUrl,
      'iosUrl': instance.iosUrl,
    };
