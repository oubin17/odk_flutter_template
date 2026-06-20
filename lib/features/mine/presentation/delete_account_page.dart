import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/mixins/mounted_safe_mixin.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 账号注销页面
///
/// 满足 Apple App Store 和 GDPR 的合规要求：
/// - 提供账号删除功能
/// - 明确告知用户注销后果
/// - 需要二次确认（输入确认文本）
/// - 注销后清除所有用户数据
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage>
    with MountedSafeMixin {
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  /// 检查输入是否匹配确认文本
  bool get _isConfirmMatch =>
      _confirmController.text == L10nUtils.deleteAccountInputMatch;

  /// 执行注销操作
  Future<void> _deleteAccount() async {
    if (!_isConfirmMatch) {
      AppToast.showToast(L10nUtils.deleteAccountInputHint);
      return;
    }

    // 二次确认弹窗
    final confirmed = await _showConfirmDialog();
    if (!confirmed) return;

    try {
      // 调用后端注销接口（如果有的话）
      await AuthService().deletion();

      mountedSafeCallback(() {
        AppToast.showNotify(L10nUtils.deleteAccountSuccess, null);
        // 跳转到登录页
        NavigatorUtils.goNamed(RouteNames.signin);
      });
    } catch (e) {
      mountedSafeCallback(() {
        AppToast.showToast(L10nUtils.deleteAccountFailed);
      });
    }
  }

  /// 二次确认弹窗
  Future<bool> _showConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(L10nUtils.deleteAccountConfirmTitle),
        content: AppText.second(L10nUtils.deleteAccountConfirmMessage),
        actions: [
          AppTextButton(
            text: L10nUtils.cancel,
            onTap: () => Navigator.of(context).pop(false),
          ),
          AppTextButton(
            text: L10nUtils.confirm,
            color: AppColors.error,
            onTap: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.deleteAccount),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⚠️ 警告提示卡片
            _buildWarningCard(context),
            AppGap.hLarge,

            // 注销说明
            _buildDescription(context),
            AppGap.hLarge,

            // 确认输入框
            _buildConfirmInput(context),
            AppGap.hLarge,

            // 注销按钮
            _buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  /// 警告提示卡片
  Widget _buildWarningCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 40.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AppText(
              L10nUtils.deleteAccountWarning,
              size: 26.sp,
              color: AppColors.errorDark,
            ),
          ),
        ],
      ),
    );
  }

  /// 注销说明
  Widget _buildDescription(BuildContext context) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            L10nUtils.deleteAccountConfirmTitle,
            size: 30.sp,
            weight: FontWeight.w600,
          ),
          AppGap.hSmall,
          AppText.second(L10nUtils.deleteAccountConfirmMessage),
        ],
      ),
    );
  }

  /// 确认输入框
  Widget _buildConfirmInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.second(L10nUtils.deleteAccountInputHint),
        AppGap.hSmall,
        AppInput(
          controller: _confirmController,
          hint: L10nUtils.deleteAccountInputMatch,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  /// 注销按钮
  Widget _buildDeleteButton(BuildContext context) {
    return AppDebounceButton(
      text: L10nUtils.deleteAccountButton,
      disabled: !_isConfirmMatch,
      bgColor: AppColors.error,
      onTap: _deleteAccount,
    );
  }
}
