// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiConversation _$AiConversationFromJson(Map<String, dynamic> json) =>
    AiConversation(
      conversationId: json['conversationId'] as String?,
      title: json['title'] as String?,
      modelName: json['modelName'] as String?,
      providerType: json['providerType'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$AiConversationToJson(AiConversation instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'title': instance.title,
      'modelName': instance.modelName,
      'providerType': instance.providerType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
