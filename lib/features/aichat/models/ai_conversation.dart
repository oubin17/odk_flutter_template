import 'package:json_annotation/json_annotation.dart';

part 'ai_conversation.g.dart';

/// AI对话会话展示对象
@JsonSerializable()
class AiConversation {
  /// 会话唯一ID
  final String? conversationId;

  /// 会话标题
  final String? title;

  /// 使用的模型名称
  final String? modelName;

  /// 协议类型
  final String? providerType;

  /// 创建时间
  final String? createTime;

  /// 更新时间
  final String? updateTime;

  AiConversation({
    this.conversationId,
    this.title,
    this.modelName,
    this.providerType,
    this.createTime,
    this.updateTime,
  });

  factory AiConversation.fromJson(Map<String, dynamic> json) =>
      _$AiConversationFromJson(json);

  Map<String, dynamic> toJson() => _$AiConversationToJson(this);
}
