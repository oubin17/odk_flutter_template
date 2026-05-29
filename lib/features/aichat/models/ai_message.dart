import 'package:json_annotation/json_annotation.dart';

part 'ai_message.g.dart';

/// AI对话消息展示对象
@JsonSerializable()
class AiMessage {
  /// 消息ID
  final String? id;

  /// 会话ID
  final String? conversationId;

  /// 角色: user / assistant / system
  final String? role;

  /// 消息内容
  final String? content;

  /// 使用的模型名称
  final String? modelName;

  /// 创建时间
  final String? createTime;

  AiMessage({
    this.id,
    this.conversationId,
    this.role,
    this.content,
    this.modelName,
    this.createTime,
  });

  factory AiMessage.fromJson(Map<String, dynamic> json) =>
      _$AiMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AiMessageToJson(this);
}
