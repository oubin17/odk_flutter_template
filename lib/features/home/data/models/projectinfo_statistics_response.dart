import 'package:json_annotation/json_annotation.dart';

part 'projectinfo_statistics_response.g.dart';

@JsonSerializable()
class ProjectInfoStatisticsResponse {
  int validReportCount = 0;
  int addReportCount = 0;
  int reviewCount = 0;
  int todayReviewCount = 0;

  ProjectInfoStatisticsResponse({
    required this.validReportCount,
    required this.addReportCount,
    required this.reviewCount,
    required this.todayReviewCount,
  });
  factory ProjectInfoStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectInfoStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectInfoStatisticsResponseToJson(this);
}
