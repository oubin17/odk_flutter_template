import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_conversation.dart';
import 'package:odk_flutter_template/features/aichat/presentation/ai_chat_view_model.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/features/aichat/models/ai_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

/// 消息列表的聚合状态，用于 Selector 同时监听多个字段
class _MessageListState {
  final List<AiMessage> messages;
  final String streamingContent;
  final bool isStreaming;

  const _MessageListState({
    required this.messages,
    required this.streamingContent,
    required this.isStreaming,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MessageListState &&
          runtimeType == other.runtimeType &&
          _listEquals(messages, other.messages) &&
          streamingContent == other.streamingContent &&
          isStreaming == other.isStreaming;

  @override
  int get hashCode =>
      Object.hash(messages.length, streamingContent, isStreaming);

  static bool _listEquals(List<AiMessage> a, List<AiMessage> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// AI对话页面过渡动画（进入：从下往上渐入，退出：从上往下渐出）
class AiChatPageTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const AiChatPageTransition({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // animation.value: 进入时 0→1，退出时 1→0
        final value = animation.value;
        if (value == 0) return const SizedBox.shrink();

        // 进入用 easeOut，退出用 easeIn（通过判断方向）
        final isEntering =
            animation.status == AnimationStatus.forward ||
            animation.status == AnimationStatus.completed;
        final curveValue = isEntering
            ? Curves.easeOut.transform(value)
            : Curves.easeIn.transform(value);

        // 进入：从下方 300 渐入；退出：向上方 -300 渐出
        final offsetY = isEntering
            ? (1 - curveValue) * 300
            : (1 - curveValue) * (-300);

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Opacity(opacity: curveValue, child: child),
        );
      },
    );
  }
}

/// AI对话页面
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  // ====================== 控制器 ======================
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  // ====================== 业务逻辑 ======================

  /// 发送消息
  void _sendMessage(BuildContext context) {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    final vm = context.read<AiChatViewModel>();
    vm.sendMessage(text);

    // 延迟滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  /// 滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// 新建会话（当前会话无内容时不重复创建）
  void _handleNewConversation(BuildContext context) {
    final vm = context.read<AiChatViewModel>();
    if (vm.messages.isEmpty) return;
    vm.newConversation();
  }

  /// 打开抽屉
  void _openDrawer(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
    // 加载会话列表
    context.read<AiChatViewModel>().loadConversations();
  }

  /// 选择模型
  void _showModelPicker(BuildContext context) {
    final vm = context.read<AiChatViewModel>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return ListenableBuilder(
          listenable: vm,
          builder: (_, _) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: AppText.title(
                      L10nUtils.aiChatSelectModel,
                      color: AppColors.textMain(context),
                    ),
                  ),
                  AppDivider(padding: 0),
                  if (vm.isLoadingModels)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.w,
                            color: AppColors.primary(context),
                          ),
                        ),
                      ),
                    )
                  else
                    ...vm.availableModels.map(
                      (model) => _buildModelItem(
                        context: context,
                        name: model.modelName ?? model.modelCode ?? '',
                        provider: model.providerType ?? '',
                        description: model.description ?? '',
                        isSelected: vm.modelName == model.modelCode,
                        onTap: () {
                          vm.selectModel(
                            model.modelCode ?? '',
                            model.providerType ?? '',
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  AppGap.hNormal,
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModelItem({
    required BuildContext context,
    required String name,
    required String provider,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(name, color: AppColors.textMain(context)),
                  if (description.isNotEmpty) ...[
                    AppGap.hSuperSmall,
                    AppText.tip(
                      description,
                      color: AppColors.textGray(context),
                    ),
                  ],
                  AppGap.hSuperSmall,
                  AppText.tip(provider, color: AppColors.textGray(context)),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary(context),
                size: 36.w,
              ),
          ],
        ),
      ),
    );
  }

  // ====================== UI 组件拆分 ======================

  /// 自定义 AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: AppIconButton(
        icon: Icons.sort_rounded,
        onTap: () => _openDrawer(context),
        iconColor: AppColors.textSecond(context),
        size: 40.w,
      ),
      title: Selector<AiChatViewModel, String>(
        selector: (_, vm) => vm.modelDisplayName,
        builder: (_, modelDisplayName, _) {
          return GestureDetector(
            onTap: () => _showModelPicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary50(context),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.second(
                    modelDisplayName,
                    color: AppColors.primary(context),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 32.w,
                    color: AppColors.primary(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      centerTitle: true,
      actions: [
        // 新建会话按钮（当前无内容时置灰）
        Selector<AiChatViewModel, bool>(
          selector: (_, vm) => vm.messages.isEmpty,
          builder: (_, isEmpty, _) {
            return AppIconButton(
              icon: Icons.add_rounded,
              onTap: isEmpty ? null : () => _handleNewConversation(context),
              iconColor: isEmpty
                  ? AppColors.textGray(context).withAlpha(77)
                  : AppColors.textSecond(context),
              size: 40.w,
            );
          },
        ),
        AppIconButton(
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: () => NavigatorUtils.pop(),
          iconColor: AppColors.textSecond(context),
          size: 48.w,
        ),
      ],
    );
  }

  /// 左侧抽屉（历史会话）
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 抽屉标题
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 20.w, 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: AppText.title(
                      L10nUtils.aiChatHistory,
                      color: AppColors.textMain(context),
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    iconColor: AppColors.textGray(context),
                    size: 28.w,
                  ),
                ],
              ),
            ),
            AppDivider(padding: 0),
            // 会话列表
            Expanded(
              child: Selector<AiChatViewModel, List<AiConversation>>(
                selector: (_, vm) => vm.conversations,
                builder: (_, conversations, _) {
                  if (conversations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary50(context),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 44.w,
                              color: AppColors.primary(context).withAlpha(102),
                            ),
                          ),
                          AppGap.hNormal,
                          AppText.second(
                            L10nUtils.aiChatNoHistory,
                            color: AppColors.textGray(context),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: conversations.length,
                    itemBuilder: (_, index) {
                      final conversation = conversations[index];
                      return _buildConversationItem(context, conversation);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 会话列表项
  Widget _buildConversationItem(
    BuildContext context,
    AiConversation conversation,
  ) {
    final vm = context.read<AiChatViewModel>();
    final isCurrent = vm.conversationId == conversation.conversationId;

    return Dismissible(
      key: ValueKey(conversation.conversationId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30.w),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 36.w,
        ),
      ),
      confirmDismiss: (_) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.card(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: AppText.body(L10nUtils.aiChatDeleteConfirmTitle),
            content: AppText.second(L10nUtils.aiChatDeleteConfirmMsg),
            actions: [
              AppTextButton(
                text: L10nUtils.cancel,
                onTap: () => Navigator.of(ctx).pop(false),
              ),
              AppTextButton(
                text: L10nUtils.confirm,
                color: AppColors.error,
                onTap: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      onDismissed: (_) {
        vm.deleteConversation(conversation.conversationId ?? '');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Material(
          color: isCurrent
              ? AppColors.primary50(context)
              : AppColors.bgSecond(context),
          borderRadius: BorderRadius.circular(20.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              vm.switchConversation(conversation);
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary(context).withAlpha(26)
                          : AppColors.bgPage(context),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: isCurrent
                          ? AppColors.primary(context)
                          : AppColors.textGray(context),
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          conversation.title ?? L10nUtils.aiChatNewConversation,
                          color: isCurrent
                              ? AppColors.primary(context)
                              : AppColors.textMain(context),
                          size: 28.sp,
                          maxLines: 1,
                        ),
                        SizedBox(height: 6.h),
                        AppText.tip(
                          conversation.createTime ?? '',
                          color: AppColors.textGray(context),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary(context).withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.primary(context),
                        size: 16.w,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 对话消息列表
  Widget _buildMessageList(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<AiChatViewModel>(
        builder: (_, vm, _) {
          final messages = vm.messages;
          if (messages.isEmpty) {
            return _buildEmptyState(context);
          }

          // 监听流式内容变化时自动滚动
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return ListView.builder(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final message = messages[index];
              final isUser = message.role == 'user';

              // 如果是最后一条 assistant 消息且正在流式接收
              if (!isUser && index == messages.length - 1 && vm.isStreaming) {
                return _buildMessageBubble(
                  key: ValueKey('streaming_${message.id}'),
                  context: context,
                  content: vm.streamingContent,
                  isUser: false,
                  isStreaming: true,
                );
              }

              return _buildMessageBubble(
                key: ValueKey(
                  'msg_${message.id}_${message.content?.length ?? 0}',
                ),
                context: context,
                content: message.content ?? '',
                isUser: isUser,
              );
            },
          );
        },
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.primary50(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 56.w,
              color: AppColors.primary(context).withAlpha(153),
            ),
          ),
          AppGap.hLarge,
          AppText.second(
            L10nUtils.aiChatWelcome,
            color: AppColors.textGray(context),
          ),
        ],
      ),
    );
  }

  /// 消息气泡
  Widget _buildMessageBubble({
    Key? key,
    required BuildContext context,
    required String content,
    required bool isUser,
    bool isStreaming = false,
  }) {
    return KeyedSubtree(
      key: key,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primary50(context),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 28.w,
                  color: AppColors.primary(context),
                ),
              ),
              SizedBox(width: 12.w),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppColors.primary(context)
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(20.r),
                  border: isUser
                      ? null
                      : Border.all(
                          color: AppColors.divider(context).withAlpha(26),
                          width: 0.5,
                        ),
                ),
                child: isUser
                    ? (content.isNotEmpty
                          ? AppText.body(content, color: AppColors.textWhite)
                          : const SizedBox.shrink())
                    : (content.isNotEmpty
                          ? MarkdownBody(
                              key: ValueKey(content),
                              data: content,
                              selectable: true,
                              styleSheet:
                                  MarkdownStyleSheet.fromTheme(
                                    Theme.of(context),
                                  ).copyWith(
                                    p: TextStyle(
                                      fontSize: 28.sp,
                                      color: AppColors.textMain(context),
                                      height: 1.5,
                                    ),
                                    h2: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMain(context),
                                    ),
                                    h3: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textMain(context),
                                    ),
                                    code: TextStyle(
                                      fontSize: 26.sp,
                                      backgroundColor: AppColors.bgSecond(
                                        context,
                                      ),
                                      color: AppColors.primary(context),
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: AppColors.bgSecond(context),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    blockquote: TextStyle(
                                      fontSize: 28.sp,
                                      color: AppColors.textSecond(context),
                                      height: 1.5,
                                    ),
                                    listBullet: TextStyle(
                                      fontSize: 28.sp,
                                      color: AppColors.textMain(context),
                                    ),
                                  ),
                            )
                          : (isStreaming
                                ? _buildStreamingIndicator(context)
                                : const SizedBox.shrink())),
              ),
            ),
            if (isUser) ...[
              SizedBox(width: 12.w),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: AppColors.primary50(context),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 28.w,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 流式接收指示器（打字效果）
  Widget _buildStreamingIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0),
        AppGap.wSuperSmall,
        _buildDot(1),
        AppGap.wSuperSmall,
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 200),
      builder: (_, value, _) {
        return Opacity(
          opacity: 0.4 + value * 0.6,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppColors.primary(context),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  /// 底部输入区域（发送按钮集成在输入框内）
  Widget _buildInputArea(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
        child: Container(
          constraints: BoxConstraints(minHeight: 64.h, maxHeight: 160.h),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(48.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 12.w,
                offset: Offset(0, -2.w),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 输入框
              Expanded(
                child: TextField(
                  controller: _inputController,
                  focusNode: _inputFocusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(context),
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: AppColors.textMain(context),
                  ),
                  decoration: InputDecoration(
                    hintText: L10nUtils.aiChatInputHint,
                    hintStyle: TextStyle(
                      fontSize: 28.sp,
                      color: AppColors.textGray(context),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 16.h,
                    ),
                  ),
                ),
              ),
              // 发送/停止按钮（集成在输入框右侧）
              Selector<AiChatViewModel, bool>(
                selector: (_, vm) => vm.isStreaming,
                builder: (_, isStreaming, _) {
                  if (isStreaming) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 8.h, 10.w, 8.h),
                      child: GestureDetector(
                        onTap: () =>
                            context.read<AiChatViewModel>().stopStreaming(),
                        child: Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: const BoxDecoration(
                            color: AppColors.errorLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.stop_rounded,
                            color: AppColors.error,
                            size: 26.w,
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 10.w, 8.h),
                    child: GestureDetector(
                      onTap: () => _sendMessage(context),
                      child: Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary(context),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: AppColors.textWhite,
                          size: 26.w,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiChatViewModel(),
      builder: (context, child) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          // 消息列表
          Expanded(child: _buildMessageList(context)),
          // 底部输入区域
          _buildInputArea(context),
        ],
      ),
    );
  }
}
