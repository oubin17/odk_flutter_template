import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

class AppToast {
  static void dismiss() => SmartDialog.dismiss();

  /// Show loading toast
  static void showLoading({String? loading, Duration? displayTime}) {
    SmartDialog.showLoading(
      msg: loading ?? "Loading...",
      alignment: Alignment.center,
      displayTime: displayTime,
    );
  }

  /// Show toast
  static void showToast(String message, {alignment = Alignment.center}) {
    SmartDialog.showToast(message, alignment: alignment);
  }

  static void showToast2(String message, {gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
    );
  }

  /// Show notify
  static void showNotify(String message, warning, {NotifyType? notifyType}) {
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

  /// 通用确认弹窗（确认按钮使用 AppDebounceWrapper 防抖）
  ///
  /// [title] 标题文字
  /// [msg] 描述文字（可选）
  /// [confirmText] 确认按钮文字，默认"确认"
  /// [cancelText] 取消按钮文字，默认"取消"
  /// [onConfirm] 确认回调
  /// [isDanger] 是否为危险操作（如退出登录），确认按钮变红
  /// [icon] 标题上方图标（可选，如 Icons.logout）
  static void showAppConfirmDialog({
    required String title,
    String? msg,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    bool isDanger = false,
    IconData? icon,
  }) {
    SmartDialog.show(
      clickMaskDismiss: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.card(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 内容区域 ──
            Padding(
              padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 图标（可选）
                  if (icon != null) ...[
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: isDanger
                            ? AppColors.errorLight
                            : AppColors.primary50(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 40.w,
                        color: isDanger
                            ? AppColors.error
                            : AppColors.primary(context),
                      ),
                    ),
                    AppGap.hNormal,
                  ],
                  // 标题
                  AppText.title(title, color: AppColors.textMain(context)),
                  // 描述文字
                  if (msg != null && msg.isNotEmpty) ...[
                    AppGap.hSmall,
                    AppText(
                      msg,
                      color: AppColors.textSecond(context),
                      size: 26.sp,
                      align: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // ── 分割线 ──
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: AppColors.divider(context),
            ),

            // ── 按钮区域 ──
            Row(
              children: [
                // 取消按钮
                Expanded(
                  child: AppDialogButton(
                    text: cancelText ?? L10nUtils.cancel,
                    textColor: AppColors.textSecond(context),
                    onTap: () => SmartDialog.dismiss(),
                  ),
                ),
                // 竖向分割线
                SizedBox(
                  width: 1.w,
                  height: 80.h,
                  child: ColoredBox(color: AppColors.divider(context)),
                ),
                // 确认按钮（防抖）
                Expanded(
                  child: AppDebounceWrapper(
                    onTap: () async {
                      SmartDialog.dismiss();
                      onConfirm?.call();
                    },
                    child: AppDialogButton(
                      text: confirmText ?? L10nUtils.confirm,
                      textColor: isDanger
                          ? AppColors.error
                          : AppColors.primary(context),
                      isBold: true,
                      onTap: null, // 由 AppDebounceWrapper 接管
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
