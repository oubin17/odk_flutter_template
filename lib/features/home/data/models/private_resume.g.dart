// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_resume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateResumeInfo _$PrivateResumeInfoFromJson(Map<String, dynamic> json) =>
    PrivateResumeInfo(
      remark: json['remark'] as String?,
      status: json['status'] as String?,
      company: json['company'] as String?,
      userName: json['userName'] as String?,
      resumeLibraryDTO: json['resumeLibraryDTO'] == null
          ? null
          : ResumeLibraryInfo.fromJson(
              json['resumeLibraryDTO'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PrivateResumeInfoToJson(PrivateResumeInfo instance) =>
    <String, dynamic>{
      'remark': instance.remark,
      'status': instance.status,
      'company': instance.company,
      'userName': instance.userName,
      'resumeLibraryDTO': instance.resumeLibraryDTO,
    };
