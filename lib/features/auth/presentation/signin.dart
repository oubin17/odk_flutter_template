import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/service/auth_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

// 登录页面（优化版，对齐注册页规范）
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // 表单核心（私有规范）
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 验证码实体
  final VerificationCode _verificationCode = VerificationCode("", "");

  // 登录状态
  bool _isPasswordLogin = true;
  // 🔥 协议勾选状态（合规必选）
  bool _isAgree = false;

  @override
  void dispose() {
    // 统一释放资源，防止内存泄漏
    _accountController.dispose();
    _verifyCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 跳转到协议页面
  void _toAgreementPage(String title, String url) {
    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': url},
    );
  }

  /// 登录提交
  Future<void> _login() async {
    // 🔥 协议必选校验
    if (!_isAgree) {
      AppToast.showToast(L10nUtils.agreeTermsFirst);
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _verificationCode.verifyCode = _verifyCodeController.text;
    AppToast.showLoading();

    final UserLoginResponse? userEntity = await AuthService().login(
      UserLoginRequest(
        loginId: _accountController.text,
        identifyType: _isPasswordLogin ? "1" : "2",
        identifyValue: _isPasswordLogin ? _passwordController.text : null,
        verificationCode: _isPasswordLogin ? null : _verificationCode,
      ),
    );

    AppToast.dismiss();
    if (userEntity == null) {
      AppToast.showToast(L10nUtils.loginFailed);
    } else {
      if (!mounted) return;
      NavigatorUtils.goNamed(RouteNames.home);
    }
  }

  // ====================== UI 组件拆分（对齐注册页） ======================
  Widget _signInTitle() {
    return AppText.customerTitle(L10nUtils.login, 50.sp, FontWeight.bold);
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
      validator: ToolUtils.checkPhoneValidator,
    );
  }

  Widget _passwordInput() {
    return AppInput(
      controller: _passwordController,
      label: L10nUtils.password,
      prefixIcon: Icon(
        Icons.password,
        size: 32.w,
        color: AppColors.textGray(context),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return L10nUtils.fieldNotEmptyTip(L10nUtils.password);
        }
        return null;
      },
    );
  }

  /// 验证码输入框（响应式倒计时）
  Widget _verifyCodeInput() {
    return VerifyCodeInput(
      accountController: _accountController,
      verifyScene: VerifyScene.login,
      verifyType: VerifyType.mobile,
      verifyCodeController: _verifyCodeController,
      onUniqueIdChanged: (uniqueId) {
        _verificationCode.uniqueId = uniqueId;
      },
    );
  }

  /// 切换登录方式
  Widget _switchLoginType() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppTextButton(
        text: L10nUtils.switchLoginType,
        onTap: () => setState(() => _isPasswordLogin = !_isPasswordLogin),
      ),
    );
  }

  /// 协议勾选框（复用注册页组件，右对齐）
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

  Widget _loginButton() {
    return AppButton(onTap: _login, text: L10nUtils.login);
  }

  Widget _bottomRegisterText() {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second(L10nUtils.noAccount),
          AppTextButton(
            onTap: () => NavigatorUtils.goNamed(RouteNames.signup),
            text: L10nUtils.register,
          ),
        ],
      ),
    );
  }

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图
          Image.asset(
            Assets.images.login.loginRegist.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // 内容区域
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppGap.hLarge,
                  AppGap.hLarge,
                  _signInTitle(),
                  AppGap.hNormal,
                  _accountInput(),
                  AppGap.hNormal,
                  // 动态切换登录方式
                  if (_isPasswordLogin)
                    _passwordInput()
                  else
                    _verifyCodeInput(),
                  AppGap.hSuperSmall,
                  _switchLoginType(),
                  const Spacer(),
                  _loginButton(),
                  // 🔥 协议组件（和注册页统一）
                  _agreementWidget(),
                  AppGap.hNormal,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomRegisterText(),
    );
  }
}
