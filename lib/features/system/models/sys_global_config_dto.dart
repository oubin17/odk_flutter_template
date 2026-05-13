import 'package:json_annotation/json_annotation.dart';

part 'sys_global_config_dto.g.dart';

@JsonSerializable()
class SysGlobalConfigDto {
  String configKey;
  String configValue;
  String configDesc;
  SysGlobalConfigDto({
    required this.configKey,
    required this.configValue,
    required this.configDesc,
  });

  factory SysGlobalConfigDto.fromJson(Map<String, dynamic> json) =>
      _$SysGlobalConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SysGlobalConfigDtoToJson(this);
}
