import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

class AppToast {
  /// Show loading toast
  static void showLoading({String? loading, Duration? displayTime}) {
    SmartDialog.showLoading(
      msg: loading ?? "Loading...",
      alignment: Alignment.center,
      displayTime: displayTime,
    );
  }

  /// Show toast
  static void showToast(String message) {
    SmartDialog.showToast(message, alignment: Alignment.center);
  }

  /// Show notify
  static void showNotify(String message, {NotifyType? notifyType}) {
    SmartDialog.showNotify(
      msg: message,
      alignment: Alignment.center,
      notifyType: notifyType ?? NotifyType.success,
    );
  }

  ///showAttach 方法的核心作用是实现弹窗与目标组件的关联定位，使弹窗能够智能地出现在目标组件的指定位置，而非简单的屏幕居中显示。
  static void showAttach(BuildContext context, WidgetBuilder builder) {
    SmartDialog.showAttach(targetContext: context, builder: builder);
  }

  /// 展示自定义弹窗内容
  static void show(Widget widget) {
    SmartDialog.show(builder: (context) => widget);
  }

  /// 通用确认弹窗
  static void showAppConfirmDialog({
    required String title,
    String? msg,
    String confirmText = "确认",
    String cancelText = "取消",
    VoidCallback? onConfirm,
  }) {
    SmartDialog.show(
      clickMaskDismiss: false,
      // 原生圆角弹窗容器
      builder: (context) => Dialog(
        // 主题适配：弹窗背景色
        backgroundColor: AppColors.bgPage(context),
        // 圆角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        // 阴影
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              AppText.title(title, color: AppColors.textMain(context)),
              AppGap.hNormal,
              if (msg != null && msg.isNotEmpty) ...[
                AppText.second(msg, color: AppColors.textSecond(context)),
                AppGap.hSmall,
              ],

              // 按钮行
              Row(
                children: [
                  // 取消按钮（原生）
                  Expanded(
                    child: AppTextButton(
                      text: cancelText,
                      onTap: () => SmartDialog.dismiss(),
                    ),
                  ),
                  AppGap.wXL,
                  Expanded(
                    child: AppTextButton(
                      text: confirmText,
                      onTap: () {
                        SmartDialog.dismiss();
                        onConfirm?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
