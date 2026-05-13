// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_check_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionCheckResult _$VersionCheckResultFromJson(Map<String, dynamic> json) =>
    VersionCheckResult(
      hasUpdate: json['hasUpdate'] as bool,
      latestVersion: json['latestVersion'] == null
          ? null
          : AppVersionInfo.fromJson(
              json['latestVersion'] as Map<String, dynamic>,
            ),
      currentVersion: json['currentVersion'] as String,
    );

Map<String, dynamic> _$VersionCheckResultToJson(VersionCheckResult instance) =>
    <String, dynamic>{
      'hasUpdate': instance.hasUpdate,
      'latestVersion': instance.latestVersion?.toJson(),
      'currentVersion': instance.currentVersion,
    };
