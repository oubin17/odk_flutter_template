// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projectinfo_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectInfoStatisticsResponse _$ProjectInfoStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => ProjectInfoStatisticsResponse(
  validReportCount: (json['validReportCount'] as num).toInt(),
  addReportCount: (json['addReportCount'] as num).toInt(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  todayReviewCount: (json['todayReviewCount'] as num).toInt(),
);

Map<String, dynamic> _$ProjectInfoStatisticsResponseToJson(
  ProjectInfoStatisticsResponse instance,
) => <String, dynamic>{
  'validReportCount': instance.validReportCount,
  'addReportCount': instance.addReportCount,
  'reviewCount': instance.reviewCount,
  'todayReviewCount': instance.todayReviewCount,
};
