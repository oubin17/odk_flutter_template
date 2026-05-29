import 'dart:async';
import 'package:odk_flutter_template/features/aichat/api/ai_chat_api.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_chat_request.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_conversation.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_message.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_model_dto.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class AiChatService {
  static final AiChatService _instance = AiChatService._internal();
  AiChatService._internal();
  factory AiChatService() => _instance;

  /// AI对话（流式SSE）
  Stream<String> chatStream(
    AiChatRequest request, {
    Function(String conversationId)? onConversationId,
  }) {
    return AiChatApi().chatStream(request, onConversationId: onConversationId);
  }

  /// 查询用户的会话列表
  Future<List<AiConversation>> getConversations() async {
    return await AiChatApi().getConversations();
  }

  /// 查询会话的历史消息
  Future<List<AiMessage>> getConversationHistory(String conversationId) async {
    return await AiChatApi().getConversationHistory(conversationId);
  }

  /// 删除会话及其消息
  Future<ServiceResponse> deleteConversation(String conversationId) async {
    return await AiChatApi().deleteConversation(conversationId);
  }

  /// 获取可用的模型列表
  Future<List<AiModelDTO>> getModels() async {
    return await AiChatApi().getModels();
  }
}
