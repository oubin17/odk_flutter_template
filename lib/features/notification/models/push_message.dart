import 'package:json_annotation/json_annotation.dart';

part 'push_message.g.dart';

/// 推送消息类型
enum PushMessageType {
  /// 系统通知
  system,
  /// 业务消息
  business,
  /// 营销消息
  marketing,
}

/// 推送消息 Model
@JsonSerializable()
class PushMessage {
  /// 消息 ID
  final String? messageId;

  /// 消息标题
  final String? title;

  /// 消息内容
  final String? body;

  /// 消息类型
  final PushMessageType? type;

  /// 消息数据（自定义字段）
  final Map<String, dynamic>? data;

  /// 发送时间
  final String? sendTime;

  /// 是否已读
  final bool isRead;

  /// 点击跳转路径
  final String? routePath;

  PushMessage({
    this.messageId,
    this.title,
    this.body,
    this.type,
    this.data,
    this.sendTime,
    this.isRead = false,
    this.routePath,
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) =>
      _$PushMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PushMessageToJson(this);

  /// 从 Firebase RemoteMessage 转换
  factory PushMessage.fromFirebaseMessage(Map<String, dynamic> messageData) {
    return PushMessage(
      messageId: messageData['messageId']?.toString(),
      title: messageData['notification']?['title'] ?? messageData['title'],
      body: messageData['notification']?['body'] ?? messageData['body'],
      type: _parseMessageType(messageData['data']?['type']),
      data: messageData['data'] as Map<String, dynamic>?,
      sendTime: messageData['sentTime']?.toString(),
      routePath: messageData['data']?['routePath'],
    );
  }

  static PushMessageType? _parseMessageType(dynamic type) {
    if (type == null) return null;
    final typeStr = type.toString();
    switch (typeStr) {
      case 'system':
        return PushMessageType.system;
      case 'business':
        return PushMessageType.business;
      case 'marketing':
        return PushMessageType.marketing;
      default:
        return PushMessageType.system;
    }
  }

  /// 复制并更新已读状态
  PushMessage copyWith({bool? isRead}) {
    return PushMessage(
      messageId: messageId,
      title: title,
      body: body,
      type: type,
      data: data,
      sendTime: sendTime,
      isRead: isRead ?? this.isRead,
      routePath: routePath,
    );
  }
}