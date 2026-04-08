// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResumeLibraryInfo _$ResumeLibraryInfoFromJson(Map<String, dynamic> json) =>
    ResumeLibraryInfo(
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      age: json['age'] as String?,
      gender: json['gender'] as String?,
      domicile: json['domicile'] as String?,
      extendInfo: json['extendInfo'] as String?,
      workAddr: json['workAddr'] as String?,
      idNo: json['idNo'] as String?,
    );

Map<String, dynamic> _$ResumeLibraryInfoToJson(ResumeLibraryInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mobile': instance.mobile,
      'age': instance.age,
      'workAddr': instance.workAddr,
      'idNo': instance.idNo,
      'domicile': instance.domicile,
      'extendInfo': instance.extendInfo,
      'gender': instance.gender,
    };
