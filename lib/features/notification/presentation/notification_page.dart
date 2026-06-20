import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/notification/models/push_message.dart';
import 'package:odk_flutter_template/features/notification/service/notification_service.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 消息通知页面
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // 监听新消息
    _notificationService.messageStream.listen((message) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _notificationService.messages;

    return AppPage(
      title: AppText.title(L10nUtils.notificationTitle),
      body: messages.isEmpty
          ? _buildEmptyState(context)
          : _buildMessageList(messages, context),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 120.w,
            color: AppColors.textGray(context),
          ),
          AppGap.hNormal,
          AppText.tip(L10nUtils.notificationEmpty),
        ],
      ),
    );
  }

  /// 消息列表
  Widget _buildMessageList(List<PushMessage> messages, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildMessageItem(message, context),
        );
      },
    );
  }

  /// 消息项
  Widget _buildMessageItem(PushMessage message, BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: () => _handleMessageTap(message),
        borderRadius: BorderRadius.circular(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 未读标记
            if (!message.isRead)
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  shape: BoxShape.circle,
                ),
              ),
            if (!message.isRead) AppGap.w(16),
            // 消息内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  if (message.title != null)
                    AppText.title(message.title!),
                  if (message.title != null) AppGap.hSmall,
                  // 内容
                  if (message.body != null)
                    AppText.body(message.body!),
                  if (message.body != null) AppGap.hSmall,
                  // 时间
                  if (message.sendTime != null)
                    AppText.tip(_formatTime(message.sendTime!)),
                ],
              ),
            ),
            // 类型图标
            _buildTypeIcon(message.type, context),
          ],
        ),
      ),
    );
  }

  /// 类型图标
  Widget _buildTypeIcon(PushMessageType? type, BuildContext context) {
    IconData iconData;
    Color color;

    switch (type) {
      case PushMessageType.system:
        iconData = Icons.info_outline;
        color = AppColors.primary(context);
        break;
      case PushMessageType.business:
        iconData = Icons.business_center_outlined;
        color = AppColors.textSecond(context);
        break;
      case PushMessageType.marketing:
        iconData = Icons.local_offer_outlined;
        color = AppColors.success;
        break;
      default:
        iconData = Icons.notifications_outlined;
        color = AppColors.textGray(context);
    }

    return Icon(
      iconData,
      size: 48.w,
      color: color,
    );
  }

  /// 处理消息点击
  void _handleMessageTap(PushMessage message) {
    // 标记为已读
    if (!message.isRead) {
      _notificationService.markAsRead(message.messageId ?? '');
      setState(() {});
    }

    // TODO: 根据消息类型或 routePath 跳转到对应页面
  }

  /// 格式化时间
  String _formatTime(String sendTime) {
    try {
      final timestamp = int.parse(sendTime);
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        // 今天，显示时间
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (diff.inDays == 1) {
        // 昨天
        return L10nUtils.notificationYesterday;
      } else if (diff.inDays < 7) {
        // 一周内
        return '${diff.inDays}${L10nUtils.notificationDaysAgo}';
      } else {
        // 超过一周，显示日期
        return '${date.month}/${date.day}';
      }
    } catch (e) {
      return sendTime;
    }
  }
}