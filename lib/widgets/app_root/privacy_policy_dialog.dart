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
          const PopScope(canPop: false, child: _PrivacyPolicyDialogContent()),
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
  /// 是否进入二次确认状态（点击"不同意"后切换）
  bool _showExitConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
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
                // 标题
                AppText(
                  _showExitConfirm
                      ? L10nUtils.privacyPolicyExitConfirm
                      : L10nUtils.privacyPolicyDialogTitle,
                  size: 32.sp,
                  weight: FontWeight.w600,
                  align: TextAlign.center,
                ),
                AppGap.h(20),

                // 内容
                if (_showExitConfirm)
                  _buildExitConfirmContent(context)
                else
                  _buildContentWithLinks(context),
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
          if (_showExitConfirm)
            _buildExitConfirmButtons(context)
          else
            _buildAgreeButtons(context),
        ],
      ),
    );
  }

  /// 构建隐私政策内容（含可点击的协议链接）
  Widget _buildContentWithLinks(BuildContext context) {
    final userAgreementText = L10nUtils.userAgreement;
    final privacyPolicyText = L10nUtils.privacyPolicy;

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontSize: 26.sp,
          color: AppColors.textSecond(context),
          height: 1.6,
        ),
        children: _buildTextSpans(
          context,
          userAgreementText,
          privacyPolicyText,
        ),
      ),
    );
  }

  /// 构建退出确认提示内容
  Widget _buildExitConfirmContent(BuildContext context) {
    return AppText(
      L10nUtils.privacyPolicyExitMessage,
      size: 26.sp,
      color: AppColors.textSecond(context),
      align: TextAlign.center,
    );
  }

  /// 构建同意/不同意按钮（一行展示，iOS 风格）
  Widget _buildAgreeButtons(BuildContext context) {
    return Row(
      children: [
        // 不同意按钮
        Expanded(
          child: AppDialogButton(
            text: L10nUtils.privacyPolicyDisagree,
            textColor: AppColors.textGray(context),
            onTap: _onDisagree,
          ),
        ),
        // 竖向分割线
        SizedBox(
          width: 1.w,
          height: 80.h,
          child: ColoredBox(color: AppColors.divider(context)),
        ),
        // 同意按钮
        Expanded(
          child: AppDialogButton(
            text: L10nUtils.privacyPolicyAgree,
            textColor: AppColors.primary(context),
            isBold: true,
            onTap: _onAgree,
          ),
        ),
      ],
    );
  }

  /// 构建退出确认按钮（确认退出 + 再想想，iOS 风格）
  Widget _buildExitConfirmButtons(BuildContext context) {
    return Row(
      children: [
        // 再想想（取消）
        Expanded(
          child: AppDialogButton(
            text: L10nUtils.cancel,
            textColor: AppColors.textSecond(context),
            onTap: _onCancelExit,
          ),
        ),
        // 竖向分割线
        SizedBox(
          width: 1.w,
          height: 80.h,
          child: ColoredBox(color: AppColors.divider(context)),
        ),
        // 确认退出（危险操作，红色）
        Expanded(
          child: AppDialogButton(
            text: L10nUtils.privacyPolicyExitConfirm,
            textColor: AppColors.error,
            isBold: true,
            onTap: _onConfirmExit,
          ),
        ),
      ],
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

  /// 不同意隐私政策 → 切换到二次确认状态
  void _onDisagree() {
    setState(() {
      _showExitConfirm = true;
    });
  }

  /// 取消退出 → 切换回隐私政策内容
  void _onCancelExit() {
    setState(() {
      _showExitConfirm = false;
    });
  }

  /// 确认退出应用
  void _onConfirmExit() {
    exit(0);
  }
}
