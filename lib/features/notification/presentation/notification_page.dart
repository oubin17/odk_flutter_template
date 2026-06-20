import 'dart:async';

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
  StreamSubscription<PushMessage>? _messageSub;

  @override
  void initState() {
    super.initState();
    _messageSub = _notificationService.messageStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _messageSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _notificationService.messages;

    return AppPage(
      title: AppText.title(L10nUtils.notificationTitle),
      padding: EdgeInsets.zero,
      body: messages.isEmpty
          ? _buildEmptyState(context)
          : _buildMessageList(messages, context),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(child: AppText.tip(L10nUtils.notificationEmpty));
  }

  /// 消息列表
  Widget _buildMessageList(List<PushMessage> messages, BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 32.w).copyWith(top: 8.h),
      itemCount: messages.length,
      separatorBuilder: (_, __) => AppGap.hSmall,
      itemBuilder: (context, index) {
        return _buildMessageItem(messages[index], context);
      },
    );
  }

  /// 消息项
  Widget _buildMessageItem(PushMessage message, BuildContext context) {
    final isUnread = !message.isRead;

    return Material(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(16.w),
      child: InkWell(
        onTap: () => _handleMessageTap(message),
        borderRadius: BorderRadius.circular(16.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题行
                  Row(
                    children: [
                      Expanded(
                        child: AppText(
                          message.title ?? '',
                          size: 30.sp,
                          weight: isUnread ? FontWeight.w600 : FontWeight.w500,
                          color: AppColors.textMain(context),
                          maxLines: 1,
                        ),
                      ),
                      AppGap.wSmall,
                      AppText.tip(_formatTime(message.sendTime ?? '')),
                    ],
                  ),
                  AppGap.hSuperSmall,
                  // 正文
                  AppText(
                    message.body ?? '',
                    size: 26.sp,
                    color: AppColors.textSecond(context),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            // 未读圆点（右上角）
            if (isUnread)
              Positioned(
                top: 12.w,
                right: 12.w,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 处理消息点击
  void _handleMessageTap(PushMessage message) {
    // 标记为已读
    if (!message.isRead) {
      _notificationService.markAsRead(message.messageId ?? '');
      setState(() {});
    }

    // TODO: 根据消息 routePath 跳转到对应页面
  }

  /// 格式化时间
  String _formatTime(String sendTime) {
    try {
      final timestamp = int.parse(sendTime);
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } else if (diff.inDays == 1) {
        return L10nUtils.notificationYesterday;
      } else if (diff.inDays < 7) {
        return '${diff.inDays}${L10nUtils.notificationDaysAgo}';
      } else {
        return '${date.month}/${date.day}';
      }
    } catch (e) {
      return sendTime;
    }
  }
}
