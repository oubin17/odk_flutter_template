import 'package:json_annotation/json_annotation.dart';

part 'ai_chat_request.g.dart';

/// AI对话请求
@JsonSerializable()
class AiChatRequest {
  /// 用户输入消息
  final String inputMsg;

  /// 模型名称（如 qwen-plus、deepseek-chat 等）
  final String? modelName;

  /// 协议/提供商类型（OPENAI, ALIBABA）
  final String? providerType;

  /// 会话ID，为空表示新会话
  final String? conversationId;

  AiChatRequest({
    required this.inputMsg,
    this.modelName,
    this.providerType,
    this.conversationId,
  });

  factory AiChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AiChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AiChatRequestToJson(this);
}
