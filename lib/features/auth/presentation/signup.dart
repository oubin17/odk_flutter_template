import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/extend_infodto.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 表单控制器
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

  // 验证码实体
  final VerificationCode _verifyCode = VerificationCode("", "");

  // 协议勾选状态
  bool _isAgree = false;

  @override
  void dispose() {
    // 统一释放资源
    _accountController.dispose();
    _verifyCodeController.dispose();
    super.dispose();
  }

  /// 跳转到协议页面
  void _toAgreementPage(String title, String url) {
    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': url},
    );
  }

  /// 注册提交
  Future<void> _register() async {
    if (!_isAgree) {
      AppToast.showToast(L10nUtils.agreeTermsFirst);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    AppToast.showLoading();
    _verifyCode.verifyCode = _verifyCodeController.text;

    final ServiceResponse response = await AuthService().register(
      UserRegistRequest(
        // userName: _accountController.text,
        loginId: _accountController.text,
        identifyValue: "",
        verificationCode: _verifyCode,
        extendInfoDTO: ExtendInfoDto(privacyVersion: "v1.0"),
      ),
    );

    AppToast.dismiss();
    if (!response.success) {
      AppToast.showToast(response.errorContext ?? L10nUtils.registerFailed);
    } else {
      if (!mounted) return;
      NavigatorUtils.goNamed(RouteNames.home);
    }
  }

  // ====================== UI 组件拆分 ======================
  Widget _appLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: AppAvatar(
        assetPath: Assets.images.login.loginRegist.path,
        size: 200.w,
        shape: AppAvatarShape.square,
      ),
    );
  }

  Widget _registerTitle() {
    return AppText.customerTitle(L10nUtils.welcomeBack, 50.sp, FontWeight.bold);
  }

  Widget _accountInput() {
    return AppInput(
      controller: _accountController,
      label: L10nUtils.account,
      prefixIcon: Icon(
        Icons.phone_outlined,
        size: 32.w,
        color: AppColors.textGray(context),
      ),
      suffixIcon: ClearButton(controller: _accountController),
      validator: ToolUtils.checkPhoneValidator,
    );
  }

  Widget _verifyCodeInput() {
    return VerifyCodeInput(
      accountController: _accountController,
      verifyScene: VerifyScene.register,
      verifyType: VerifyType.mobile,
      verifyCodeController: _verifyCodeController,
      onUniqueIdChanged: (uniqueId) {
        _verifyCode.uniqueId = uniqueId;
      },
    );
  }

  /// 协议组件（修复：右对齐 + 无溢出）
  Widget _agreementWidget() {
    return AppAgreementCheckbox(
      isAgree: _isAgree,
      onChanged: (value) => setState(() => _isAgree = value),
      onUserAgreement: () =>
          _toAgreementPage(L10nUtils.userAgreement, Env.userAgreementUrl),
      onPrivacyPolicy: () =>
          _toAgreementPage(L10nUtils.privacyPolicy, Env.privacyPolicyUrl),
    );
  }

  Widget _registerButton() {
    return AppButton(onTap: _register, text: L10nUtils.register);
  }

  Widget _bottomLoginText() {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second(L10nUtils.hasAccount),
          AppTextButton(
            onTap: () => NavigatorUtils.goNamed(RouteNames.signin),
            text: L10nUtils.login,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppGap.hLarge,
                  AppGap.hLarge,
                  _appLogo(),
                  AppGap.hLarge,
                  _registerTitle(),
                  AppGap.hLarge,
                  _accountInput(),
                  AppGap.hSmall,
                  _verifyCodeInput(),
                  const Spacer(),
                  _registerButton(),
                  _agreementWidget(),
                  AppGap.hNormal,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomLoginText(),
    );
  }
}
