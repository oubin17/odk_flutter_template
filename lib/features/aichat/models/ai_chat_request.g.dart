// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiChatRequest _$AiChatRequestFromJson(Map<String, dynamic> json) =>
    AiChatRequest(
      inputMsg: json['inputMsg'] as String,
      modelName: json['modelName'] as String?,
      providerType: json['providerType'] as String?,
      conversationId: json['conversationId'] as String?,
    );

Map<String, dynamic> _$AiChatRequestToJson(AiChatRequest instance) =>
    <String, dynamic>{
      'inputMsg': instance.inputMsg,
      'modelName': instance.modelName,
      'providerType': instance.providerType,
      'conversationId': instance.conversationId,
    };
