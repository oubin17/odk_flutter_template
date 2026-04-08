import 'package:json_annotation/json_annotation.dart';

part 'project_info.g.dart';

@JsonSerializable()
class ProjectInfo {
  final String id;
  final String projectName;
  final String company;
  final String city;
  final int headCount;
  final String urgencyLevel;
  final String status;
  final String contents;
  final String updateTime;

  ProjectInfo({
    required this.id,
    required this.projectName,
    required this.company,
    required this.city,
    required this.headCount,
    required this.urgencyLevel,
    required this.status,
    required this.contents,
    required this.updateTime,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectInfoToJson(this);
}
