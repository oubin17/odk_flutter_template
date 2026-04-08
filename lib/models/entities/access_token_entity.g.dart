// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenEntity _$AccessTokenEntityFromJson(Map<String, dynamic> json) =>
    AccessTokenEntity(
      tokenValue: json['tokenValue'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$AccessTokenEntityToJson(AccessTokenEntity instance) =>
    <String, dynamic>{
      'tokenValue': instance.tokenValue,
      'tokenType': instance.tokenType,
    };
