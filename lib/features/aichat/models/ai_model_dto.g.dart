// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiModelDTO _$AiModelDTOFromJson(Map<String, dynamic> json) => AiModelDTO(
  modelCode: json['modelCode'] as String?,
  modelName: json['modelName'] as String?,
  providerType: json['providerType'] as String?,
  description: json['description'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
);

Map<String, dynamic> _$AiModelDTOToJson(AiModelDTO instance) =>
    <String, dynamic>{
      'modelCode': instance.modelCode,
      'modelName': instance.modelName,
      'providerType': instance.providerType,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
    };
