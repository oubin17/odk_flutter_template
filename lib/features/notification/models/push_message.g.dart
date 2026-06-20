// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushMessage _$PushMessageFromJson(Map<String, dynamic> json) => PushMessage(
  messageId: json['messageId'] as String?,
  title: json['title'] as String?,
  body: json['body'] as String?,
  type: $enumDecodeNullable(_$PushMessageTypeEnumMap, json['type']),
  data: json['data'] as Map<String, dynamic>?,
  sendTime: json['sendTime'] as String?,
  isRead: json['isRead'] as bool? ?? false,
  routePath: json['routePath'] as String?,
);

Map<String, dynamic> _$PushMessageToJson(PushMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'title': instance.title,
      'body': instance.body,
      'type': _$PushMessageTypeEnumMap[instance.type],
      'data': instance.data,
      'sendTime': instance.sendTime,
      'isRead': instance.isRead,
      'routePath': instance.routePath,
    };

const _$PushMessageTypeEnumMap = {
  PushMessageType.system: 'system',
  PushMessageType.business: 'business',
  PushMessageType.marketing: 'marketing',
};
