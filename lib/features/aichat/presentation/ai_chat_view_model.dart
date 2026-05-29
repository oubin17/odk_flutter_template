import 'dart:async';
import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_chat_request.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_conversation.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_message.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_model_dto.dart';
import 'package:odk_flutter_template/features/aichat/service/ai_chat_service.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:uuid/uuid.dart';

/// AI对话 ViewModel — 业务逻辑与 UI 分离
///
/// 职责：
/// - 管理对话消息列表、当前会话、模型选择
/// - 执行流式对话、加载历史消息、切换会话、删除会话
class AiChatViewModel extends ChangeNotifier {
  final AiChatService _aiChatService;

  // ====================== 可选模型列表 ======================

  /// 从服务端获取的模型列表
  final List<AiModelDTO> _availableModels = [];
  List<AiModelDTO> get availableModels => List.unmodifiable(_availableModels);

  /// 是否正在加载模型列表
  bool _isLoadingModels = false;
  bool get isLoadingModels => _isLoadingModels;

  // ====================== 表单状态 ======================

  /// 当前选中的模型代码
  String _modelName = '';
  String get modelName => _modelName;

  /// 当前选中的协议/提供商类型
  String _providerType = '';
  String get providerType => _providerType;

  /// 当前模型的显示名称（优先 modelName，降级 modelCode）
  String get modelDisplayName {
    final model = _availableModels.where((m) => m.modelCode == _modelName);
    if (model.isNotEmpty) {
      return model.first.modelName ?? model.first.modelCode ?? _modelName;
    }
    return _modelName;
  }

  // ====================== UI 状态 ======================

  /// 当前会话ID（前端生成，保证同一会话窗口中唯一）
  String? _conversationId;
  String? get conversationId => _conversationId;

  /// 对话消息列表
  final List<AiMessage> _messages = [];
  List<AiMessage> get messages => List.unmodifiable(_messages);

  /// 会话列表
  final List<AiConversation> _conversations = [];
  List<AiConversation> get conversations => List.unmodifiable(_conversations);

  /// 是否正在流式接收中
  bool _isStreaming = false;
  bool get isStreaming => _isStreaming;

  /// 当前正在流式接收的 assistant 消息内容（展示给用户的部分）
  String _streamingContent = '';
  String get streamingContent => _streamingContent;

  /// SSE 流已接收的全部内容（可能比展示内容多，用于逐字动画追赶）
  String _fullReceivedContent = '';

  /// 逐字输出定时器
  Timer? _typingTimer;

  /// 逐字输出间隔（毫秒）
  static const int _typingIntervalMs = 30;

  /// 错误信息
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 是否正在加载历史消息
  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;

  /// 是否正在加载会话列表
  bool _isLoadingConversations = false;
  bool get isLoadingConversations => _isLoadingConversations;

  /// 流式订阅
  StreamSubscription<String>? _streamSubscription;

  AiChatViewModel({AiChatService? aiChatService})
    : _aiChatService = aiChatService ?? AiChatService() {
    // 初始化时加载模型列表
    loadModels();
  }

  // ====================== 状态更新 ======================

  /// 切换模型
  void selectModel(String modelName, String providerType) {
    _modelName = modelName;
    _providerType = providerType;
    notifyListeners();
  }

  /// 加载可用模型列表
  Future<void> loadModels() async {
    _isLoadingModels = true;
    notifyListeners();

    try {
      final models = await _aiChatService.getModels();
      _availableModels.clear();
      _availableModels.addAll(models);

      // 按 sortOrder 排序
      _availableModels.sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0));

      // 如果当前没有选中模型，且列表不为空，则默认选中第一个
      if (_modelName.isEmpty && _availableModels.isNotEmpty) {
        _modelName = _availableModels.first.modelCode ?? '';
        _providerType = _availableModels.first.providerType ?? '';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingModels = false;
    notifyListeners();
  }

  // ====================== 业务逻辑 ======================

  /// 发送消息（流式SSE）
  Future<void> sendMessage(String inputMsg) async {
    if (inputMsg.trim().isEmpty) return;
    if (_isStreaming) return;

    _errorMessage = null;

    // 如果当前没有 conversationId，前端生成一个唯一的
    _conversationId ??= const Uuid().v4();

    // 添加用户消息到列表
    final userMessage = AiMessage(
      role: 'user',
      content: inputMsg,
      conversationId: _conversationId,
    );
    _messages.add(userMessage);

    // 添加空的 assistant 消息占位
    final assistantMessage = AiMessage(
      role: 'assistant',
      content: '',
      conversationId: _conversationId,
      modelName: _modelName,
    );
    _messages.add(assistantMessage);

    _isStreaming = true;
    _streamingContent = '';
    _fullReceivedContent = '';
    _startTypingTimer();
    notifyListeners();

    try {
      final request = AiChatRequest(
        inputMsg: inputMsg,
        modelName: _modelName,
        providerType: _providerType,
        conversationId: _conversationId,
      );

      final stream = _aiChatService.chatStream(request);

      _streamSubscription = stream.listen(
        (content) {
          // SSE 数据追加到完整内容缓冲区，由定时器逐字展示
          _fullReceivedContent += content;
        },
        onError: (error) {
          _stopTypingTimer();
          _isStreaming = false;
          _errorMessage = error.toString();
          // 移除空的 assistant 消息
          if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
            _messages.removeLast();
          }
          notifyListeners();
        },
        onDone: () {
          // 流结束时，立即展示所有剩余内容
          _stopTypingTimer();
          _streamingContent = _fullReceivedContent;
          // 将 streamingContent 写入最后一条 assistant 消息
          if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
            final lastIndex = _messages.length - 1;
            _messages[lastIndex] = AiMessage(
              id: _messages[lastIndex].id,
              conversationId: _conversationId,
              role: 'assistant',
              content: _streamingContent,
              modelName: _modelName,
              createTime: _messages[lastIndex].createTime,
            );
          }
          _isStreaming = false;
          _streamingContent = '';
          _fullReceivedContent = '';
          notifyListeners();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _isStreaming = false;
      _errorMessage = e.toString();
      // 移除空的 assistant 消息
      if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
        _messages.removeLast();
      }
      notifyListeners();
    }
  }

  /// 启动逐字输出定时器
  void _startTypingTimer() {
    _stopTypingTimer();
    _typingTimer = Timer.periodic(Duration(milliseconds: _typingIntervalMs), (
      _,
    ) {
      if (_streamingContent.length < _fullReceivedContent.length) {
        // 每次追加1个字符，实现逐字打字效果
        _streamingContent = _fullReceivedContent.substring(
          0,
          _streamingContent.length + 1,
        );
        notifyListeners();
      }
    });
  }

  /// 停止逐字输出定时器
  void _stopTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = null;
  }

  /// 停止流式接收
  void stopStreaming() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _stopTypingTimer();

    // 立即展示所有已接收内容
    _streamingContent = _fullReceivedContent;

    // 将 streamingContent 写入最后一条 assistant 消息
    if (_streamingContent.isNotEmpty &&
        _messages.isNotEmpty &&
        _messages.last.role == 'assistant') {
      final lastIndex = _messages.length - 1;
      _messages[lastIndex] = AiMessage(
        id: _messages[lastIndex].id,
        conversationId: _conversationId,
        role: 'assistant',
        content: _streamingContent,
        modelName: _modelName,
        createTime: _messages[lastIndex].createTime,
      );
    }

    _isStreaming = false;
    _streamingContent = '';
    _fullReceivedContent = '';
    notifyListeners();
  }

  /// 加载会话列表
  Future<void> loadConversations() async {
    _isLoadingConversations = true;
    notifyListeners();

    try {
      final list = await _aiChatService.getConversations();
      _conversations.clear();
      _conversations.addAll(list);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingConversations = false;
    notifyListeners();
  }

  /// 切换到指定会话
  Future<void> switchConversation(AiConversation conversation) async {
    _conversationId = conversation.conversationId;
    _messages.clear();
    notifyListeners();

    await loadHistoryMessages();
  }

  /// 新建会话
  /// 前端生成唯一的 conversationId，确保同一会话窗口中 ID 唯一
  void newConversation() {
    _conversationId = const Uuid().v4();
    _messages.clear();
    _streamingContent = '';
    _fullReceivedContent = '';
    _isStreaming = false;
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _stopTypingTimer();
    notifyListeners();
  }

  /// 加载历史消息
  Future<void> loadHistoryMessages() async {
    if (_conversationId == null) return;

    _isLoadingHistory = true;
    notifyListeners();

    try {
      final list = await _aiChatService.getConversationHistory(
        _conversationId!,
      );
      _messages.clear();
      _messages.addAll(list);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingHistory = false;
    notifyListeners();
  }

  /// 删除会话
  Future<void> deleteConversation(String conversationId) async {
    AppToast.showLoading();

    try {
      final response = await _aiChatService.deleteConversation(conversationId);
      AppToast.dismiss();

      if (response.success) {
        // 如果删除的是当前会话，清空消息并生成新的 conversationId
        if (_conversationId == conversationId) {
          _conversationId = const Uuid().v4();
          _messages.clear();
        }
        // 从列表中移除
        _conversations.removeWhere((c) => c.conversationId == conversationId);
        notifyListeners();
        AppToast.showToast(L10nUtils.success);
      } else {
        AppToast.showToast(response.localizedErrorMessage());
      }
    } catch (e) {
      AppToast.dismiss();
      AppToast.showToast(e.toString());
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _stopTypingTimer();
    super.dispose();
  }
}
