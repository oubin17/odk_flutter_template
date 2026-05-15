import 'package:json_annotation/json_annotation.dart';

part 'role_entity.g.dart';

@JsonSerializable()
class RoleEntity {
  String id;
  String roleCode;
  String roleName;
  String status;

  RoleEntity({
    required this.id,
    required this.roleCode,
    required this.roleName,
    required this.status,
  });

  factory RoleEntity.fromJson(Map<String, dynamic> json) =>
      _$RoleEntityFromJson(json);

  // 2. 👇 添加这个 toJson 方法
  Map<String, dynamic> toJson() => _$RoleEntityToJson(this);
}
