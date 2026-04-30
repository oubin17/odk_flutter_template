import 'package:json_annotation/json_annotation.dart';

part 'extend_infodto.g.dart';

@JsonSerializable()
class ExtendInfoDto {
  String privacyVersion;
  ExtendInfoDto({required this.privacyVersion});

  factory ExtendInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ExtendInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendInfoDtoToJson(this);
}
