// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiMessage _$AiMessageFromJson(Map<String, dynamic> json) => AiMessage(
  id: json['id'] as String?,
  conversationId: json['conversationId'] as String?,
  role: json['role'] as String?,
  content: json['content'] as String?,
  modelName: json['modelName'] as String?,
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$AiMessageToJson(AiMessage instance) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'role': instance.role,
  'content': instance.content,
  'modelName': instance.modelName,
  'createTime': instance.createTime,
};
