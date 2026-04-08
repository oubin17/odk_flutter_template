// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageRequest _$PageRequestFromJson(Map<String, dynamic> json) => PageRequest()
  ..page = (json['page'] as num).toInt()
  ..size = (json['size'] as num).toInt()
  ..sortField = json['sortField'] as String?
  ..sortDirection = json['sortDirection'] as String?;

Map<String, dynamic> _$PageRequestToJson(PageRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'sortField': instance.sortField,
      'sortDirection': instance.sortDirection,
    };
