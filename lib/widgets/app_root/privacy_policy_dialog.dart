import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 首次启动隐私政策弹窗
///
/// 满足国内应用市场（工信部）和 Apple App Store 的合规要求：
/// - 首次启动时弹出隐私政策
/// - 用户同意前不得收集任何个人信息
/// - 用户不同意则无法使用应用
/// - 提供用户协议和隐私政策的查看链接
///
/// 使用方式：
/// ```dart
/// // 在路由重定向中调用
/// final agreed = await PrivacyPolicyDialog.showIfNeeded(context);
/// if (!agreed) {
///   // 用户不同意，退出应用
///   exit(0);
/// }
/// ```
class PrivacyPolicyDialog {
  PrivacyPolicyDialog._();

  /// 检查是否已同意隐私政策
  static bool isAgreed() {
    return StorageManager().getBool(StorageKey.privacyPolicyAgreed) ?? false;
  }

  /// 标记已同意隐私政策
  static Future<void> _markAgreed() async {
    await StorageManager().setBool(StorageKey.privacyPolicyAgreed, true);
  }

  /// 如果未同意，则弹出隐私政策弹窗
  ///
  /// 返回 true 表示用户已同意，false 表示用户拒绝
  /// 如果已经同意过，直接返回 true
  static Future<bool> showIfNeeded(BuildContext context) async {
    // 已经同意过，直接返回
    if (isAgreed()) return true;

    // 弹出隐私政策弹窗
    final result = await _showDialog(context);
    return result ?? false;
  }

  /// 弹出隐私政策对话框
  ///
  /// 返回 true 表示同意，false 表示拒绝，null 表示关闭弹窗
  static Future<bool?> _showDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      // 禁止点击外部关闭弹窗（合规要求：必须明确选择）
      barrierDismissible: false,
      // 禁止返回键关闭弹窗
      builder: (context) =>
          PopScope(canPop: false, child: const _PrivacyPolicyDialogContent()),
    );
  }
}

/// 隐私政策弹窗内容组件
class _PrivacyPolicyDialogContent extends StatefulWidget {
  const _PrivacyPolicyDialogContent();

  @override
  State<_PrivacyPolicyDialogContent> createState() =>
      _PrivacyPolicyDialogContentState();
}

class _PrivacyPolicyDialogContentState
    extends State<_PrivacyPolicyDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 48.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            AppText(
              L10nUtils.privacyPolicyDialogTitle,
              size: 36.sp,
              weight: FontWeight.w600,
              align: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // 内容（含可点击的协议链接）
            _buildContentWithLinks(context),
            SizedBox(height: 48.h),

            // 同意按钮
            SizedBox(
              width: double.infinity,
              height: 88.h,
              child: ElevatedButton(
                onPressed: _onAgree,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: AppText(
                  L10nUtils.privacyPolicyAgree,
                  size: 32.sp,
                  color: Colors.white,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 不同意按钮
            SizedBox(
              width: double.infinity,
              height: 88.h,
              child: OutlinedButton(
                onPressed: _onDisagree,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.textGray(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: AppText(
                  L10nUtils.privacyPolicyDisagree,
                  size: 32.sp,
                  color: AppColors.textGray(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建带可点击链接的内容文本
  Widget _buildContentWithLinks(BuildContext context) {
    final userAgreementText = L10nUtils.userAgreement;
    final privacyPolicyText = L10nUtils.privacyPolicy;

    // 使用 RichText + TextSpan 实现可点击的协议链接
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontSize: 28.sp,
          color: AppColors.textSecond(context),
          height: 1.8,
        ),
        children: _buildTextSpans(
          context,
          userAgreementText,
          privacyPolicyText,
        ),
      ),
    );
  }

  /// 构建文本片段列表（普通文本 + 可点击链接交替）
  List<TextSpan> _buildTextSpans(
    BuildContext context,
    String userAgreementText,
    String privacyPolicyText,
  ) {
    // 获取完整内容模板，然后拆分
    final contentTemplate = L10nUtils.privacyPolicyDialogContent(
      '{{USER_AGREEMENT}}',
      '{{PRIVACY_POLICY}}',
    );

    // 按 placeholder 拆分
    final parts = contentTemplate.split('{{USER_AGREEMENT}}');
    final beforeUserAgreement = parts[0];
    final afterUserAgreement = parts.length > 1 ? parts[1] : '';

    final parts2 = afterUserAgreement.split('{{PRIVACY_POLICY}}');
    final beforePrivacyPolicy = parts2[0];
    final afterPrivacyPolicy = parts2.length > 1 ? parts2[1] : '';

    return [
      // 用户协议之前的文本
      TextSpan(text: beforeUserAgreement),
      // 用户协议链接
      TextSpan(
        text: userAgreementText,
        style: TextStyle(
          color: AppColors.primary(context),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () =>
              _toAgreementPage(L10nUtils.userAgreement, Env.userAgreementUrl),
      ),
      // 用户协议和隐私政策之间的文本
      TextSpan(text: beforePrivacyPolicy),
      // 隐私政策链接
      TextSpan(
        text: privacyPolicyText,
        style: TextStyle(
          color: AppColors.primary(context),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () =>
              _toAgreementPage(L10nUtils.privacyPolicy, Env.privacyPolicyUrl),
      ),
      // 隐私政策之后的文本
      TextSpan(text: afterPrivacyPolicy),
    ];
  }

  /// 跳转到协议页面
  void _toAgreementPage(String title, String url) {
    final currentLocale = Localizations.localeOf(context);
    final lang = currentLocale.languageCode;
    final separator = url.contains('?') ? '&' : '?';
    final localizedUrl = '$url${separator}lang=$lang';

    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': localizedUrl},
    );
  }

  /// 同意隐私政策
  Future<void> _onAgree() async {
    await PrivacyPolicyDialog._markAgreed();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  /// 不同意隐私政策
  void _onDisagree() {
    // 先提示用户
    AppToast.showAppConfirmDialog(
      title: L10nUtils.privacyPolicyExitConfirm,
      msg: L10nUtils.privacyPolicyExitMessage,
      confirmText: L10nUtils.privacyPolicyExitConfirm,
      cancelText: L10nUtils.cancel,
      onConfirm: () {
        // 用户确认退出应用
        exit(0);
      },
    );
  }
}
