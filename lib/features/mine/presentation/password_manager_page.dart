import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/mine/models/user_identify/password_reset_request.dart';
import 'package:odk_flutter_template/features/mine/models/user_identify/password_update_request.dart';
import 'package:odk_flutter_template/features/mine/service/user_identify_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/countdown_controller.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

enum PasswordManagerType { set, change }

class PasswordManagerPage extends StatefulWidget {
  final String title;
  final PasswordManagerType type;

  const PasswordManagerPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<PasswordManagerPage> createState() => _PasswordManagerPageState();
}

class _PasswordManagerPageState extends State<PasswordManagerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _oldPwdController;
  late final TextEditingController _newPwdController;
  late final TextEditingController _confirmPwdController;
  late final TextEditingController _verifyCodeController;
  late final CountdownController _countdownController;
  final VerificationCode _verificationCode = VerificationCode("", "");

  @override
  void initState() {
    super.initState();
    _oldPwdController = TextEditingController();
    _newPwdController = TextEditingController();
    _confirmPwdController = TextEditingController();
    _verifyCodeController = TextEditingController();
    _countdownController = CountdownController();
  }

  @override
  void dispose() {
    _oldPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    _verifyCodeController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  // ===================== 保存逻辑 =====================

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final newPwd = _newPwdController.text.trim();
    ServiceResponse response;

    switch (widget.type) {
      case PasswordManagerType.set:
        _verificationCode.verifyCode = _verifyCodeController.text.trim();
        response = await UserIdentifyService().resetPassword(
          PasswordResetRequest(
            identifyValue: newPwd,
            verificationCode: _verificationCode,
          ),
        );
        break;
      case PasswordManagerType.change:
        response = await UserIdentifyService().updatePassword(
          PasswordUpdateRequest(
            oldIdentifyValue: _oldPwdController.text.trim(),
            newIdentifyValue: newPwd,
          ),
        );
        break;
    }

    if (!response.success) {
      AppToast.showToast(L10nUtils.operationFailed);
      return;
    }
    AppToast.showToast(L10nUtils.success);
    NavigatorUtils.pop();
  }

  // ===================== UI 构建 =====================

  /// 密码输入项
  Widget _buildPasswordItem(
    TextEditingController controller,
    String title,
    String hint, {
    FormFieldValidator<String>? validator,
  }) {
    return AppInput(
      controller: controller,
      hint: hint,
      prefixIcon: AppInputPrefix(title, width: 240.w),
      obscure: true,
      hideUnderline: true,
      validator:
          validator ??
          (value) => value?.trim().isEmpty ?? true
              ? L10nUtils.pleaseEnterPassword
              : null,
      suffixIcon: ClearButton(controller: controller),
    );
  }

  /// 验证码输入
  Widget _buildVerifyCodeInput() {
    final userProvider = context.read<UserProvider>();
    final phone = userProvider.userEntity?.accessToken.tokenValue ?? "";
    return VerifyCodeInput(
      account: phone,
      verifyScene: VerifyScene.resetPassword,
      verifyCodeController: _verifyCodeController,
      hideUnderline: true,
      onUniqueIdChanged: (uniqueId) {
        _verificationCode.uniqueId = uniqueId;
      },
    );
  }

  /// 设置密码表单
  Widget _buildSetPasswordForm() {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 30.w),
      child: Column(
        children: [
          _buildPasswordItem(
            _newPwdController,
            L10nUtils.newPassword,
            L10nUtils.pleaseEnterNewPassword,
          ),
          const AppDivider(),
          _buildVerifyCodeInput(),
          const AppDivider(),
        ],
      ),
    );
  }

  /// 修改密码表单
  Widget _buildChangePasswordForm() {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          _buildPasswordItem(
            _oldPwdController,
            L10nUtils.oldPassword,
            L10nUtils.pleaseEnterOldPassword,
          ),
          _buildPasswordItem(
            _newPwdController,
            L10nUtils.newPassword,
            L10nUtils.pleaseEnterNewPassword,
            validator: (value) {
              final newPwd = value?.trim();
              final oldPwd = _oldPwdController.text.trim();
              if (newPwd == null || newPwd.isEmpty) {
                return L10nUtils.pleaseEnterNewPassword;
              }
              if (newPwd == oldPwd) {
                return L10nUtils.newPasswordCannotBeSameAsOld;
              }
              return null;
            },
          ),
          _buildPasswordItem(
            _confirmPwdController,
            L10nUtils.confirmPassword,
            L10nUtils.pleaseEnterConfirmPassword,
            validator: (value) {
              final confirmPwd = value?.trim();
              final newPwd = _newPwdController.text.trim();
              if (confirmPwd == null || confirmPwd.isEmpty) {
                return L10nUtils.pleaseEnterConfirmPassword;
              }
              if (confirmPwd != newPwd) {
                return L10nUtils.passwordsNotMatch;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(widget.title),
      onSave: _handleSave,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: switch (widget.type) {
            PasswordManagerType.set => _buildSetPasswordForm(),
            PasswordManagerType.change => _buildChangePasswordForm(),
          },
        ),
      ),
    );
  }
}
