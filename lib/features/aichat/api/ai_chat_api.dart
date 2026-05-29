import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/core/network/interceptors/request_response_interceptor.dart';
import 'package:odk_flutter_template/core/network/interceptors/sign_interceptor.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_chat_request.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_conversation.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_message.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_model_dto.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class AiChatApi {
  static final AiChatApi _instance = AiChatApi._internal();
  AiChatApi._internal();
  factory AiChatApi() => _instance;

  /// AI对话（流式SSE）
  ///
  /// 返回 Stream<String>，每个事件为一段文本内容
  /// [onConversationId] 首次收到 conversationId 时回调
  Stream<String> chatStream(
    AiChatRequest request, {
    Function(String conversationId)? onConversationId,
  }) {
    final controller = StreamController<String>();

    _doChatStream(request, controller, onConversationId);

    return controller.stream;
  }

  Future<void> _doChatStream(
    AiChatRequest request,
    StreamController<String> controller,
    Function(String conversationId)? onConversationId,
  ) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: Env.serverUri,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 120),
          headers: {...ApiService.commonHeaders, 'Accept': 'text/event-stream'},
        ),
      );

      // 添加认证拦截器（与 ApiService 保持一致）
      dio.interceptors.add(RequestResponseInterceptor());
      dio.interceptors.add(SignInterceptor());

      final response = await dio.post(
        '/ai/chat',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );

      final responseStream = response.data as ResponseBody;
      String buffer = '';

      await for (final chunk in responseStream.stream) {
        buffer += utf8.decode(chunk, allowMalformed: true);
        final lines = buffer.split('\n');
        buffer = lines.removeLast(); // 保留未完成的行

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          if (trimmed.startsWith('data:')) {
            final dataStr = trimmed.substring(5).trim();
            if (dataStr.isEmpty || dataStr == '[DONE]') continue;

            try {
              final json = jsonDecode(dataStr);
              if (json is Map<String, dynamic>) {
                // 尝试提取 conversationId
                if (json.containsKey('conversationId') &&
                    json['conversationId'] != null) {
                  onConversationId?.call(json['conversationId'].toString());
                }
                // 提取文本内容
                final content = _extractContent(json);
                if (content != null && content.isNotEmpty) {
                  controller.add(content);
                }
              } else if (json is String) {
                controller.add(json);
              }
            } catch (_) {
              // 非 JSON 格式，直接作为文本内容
              controller.add(dataStr);
            }
          }
        }
      }

      // 处理 buffer 中剩余内容
      if (buffer.trim().isNotEmpty) {
        final trimmed = buffer.trim();
        if (trimmed.startsWith('data:')) {
          final dataStr = trimmed.substring(5).trim();
          if (dataStr.isNotEmpty && dataStr != '[DONE]') {
            try {
              final json = jsonDecode(dataStr);
              if (json is Map<String, dynamic>) {
                final content = _extractContent(json);
                if (content != null && content.isNotEmpty) {
                  controller.add(content);
                }
              }
            } catch (_) {
              controller.add(dataStr);
            }
          }
        }
      }

      controller.close();
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
        controller.close();
      }
    }
  }

  /// 从 SSE JSON 数据中提取文本内容
  /// 兼容 OpenAI 和 Alibaba 两种格式
  String? _extractContent(Map<String, dynamic> json) {
    // OpenAI 格式: choices[0].delta.content
    if (json.containsKey('choices')) {
      final choices = json['choices'];
      if (choices is List && choices.isNotEmpty) {
        final delta = choices[0]['delta'];
        if (delta is Map && delta.containsKey('content')) {
          return delta['content']?.toString();
        }
      }
    }
    // Alibaba 格式: output.text 或 choices[0].message.content
    if (json.containsKey('output')) {
      final output = json['output'];
      if (output is Map && output.containsKey('text')) {
        return output['text']?.toString();
      }
    }
    // 通用格式: content 字段
    if (json.containsKey('content')) {
      return json['content']?.toString();
    }
    return null;
  }

  /// 查询用户的会话列表
  Future<List<AiConversation>> getConversations() async {
    ServiceResponse response = await ApiService.instance.get(
      '/ai/conversations',
    );
    if (!response.success || response.data == null) return [];

    final list = response.data as List<dynamic>;
    return list
        .map((e) => AiConversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 查询会话的历史消息
  Future<List<AiMessage>> getConversationHistory(String conversationId) async {
    ServiceResponse response = await ApiService.instance.get(
      '/ai/conversations/history',
      queryParameters: {'conversationId': conversationId},
    );
    if (!response.success || response.data == null) return [];

    final list = response.data as List<dynamic>;
    return list
        .map((e) => AiMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 删除会话及其消息
  Future<ServiceResponse> deleteConversation(String conversationId) async {
    return await ApiService.instance.delete(
      '/ai/conversation?conversationId=$conversationId',
    );
  }

  /// 获取可用的模型列表
  Future<List<AiModelDTO>> getModels() async {
    ServiceResponse response = await ApiService.instance.get('/ai/models');
    if (!response.success || response.data == null) return [];

    final list = response.data as List<dynamic>;
    return list
        .map((e) => AiModelDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
