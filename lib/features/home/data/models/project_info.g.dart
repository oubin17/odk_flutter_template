// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectInfo _$ProjectInfoFromJson(Map<String, dynamic> json) => ProjectInfo(
  id: json['id'] as String,
  projectName: json['projectName'] as String,
  company: json['company'] as String,
  city: json['city'] as String,
  headCount: (json['headCount'] as num).toInt(),
  urgencyLevel: json['urgencyLevel'] as String,
  status: json['status'] as String,
  contents: json['contents'] as String,
  updateTime: json['updateTime'] as String,
);

Map<String, dynamic> _$ProjectInfoToJson(ProjectInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectName': instance.projectName,
      'company': instance.company,
      'city': instance.city,
      'headCount': instance.headCount,
      'urgencyLevel': instance.urgencyLevel,
      'status': instance.status,
      'contents': instance.contents,
      'updateTime': instance.updateTime,
    };
