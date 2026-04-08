// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleEntity _$RoleEntityFromJson(Map<String, dynamic> json) => RoleEntity(
  id: json['id'] as String,
  roleCode: json['roleCode'] as String,
  roleName: json['roleName'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$RoleEntityToJson(RoleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roleCode': instance.roleCode,
      'roleName': instance.roleName,
      'status': instance.status,
    };
