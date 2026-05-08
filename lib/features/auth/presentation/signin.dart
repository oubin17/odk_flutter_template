import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart' as ToolUtils;
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/features/auth/domain/verify_code.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/countdown_controller.dart';
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

  // 🔥 公共倒计时控制器（全项目复用）
  late final CountdownController _countdownController;

  // 登录状态
  bool _isPasswordLogin = true;
  // 🔥 协议勾选状态（合规必选）
  bool _isAgree = false;

  @override
  void initState() {
    super.initState();
    // 初始化倒计时60秒
    _countdownController = CountdownController();
  }

  @override
  void dispose() {
    // 统一释放资源，防止内存泄漏
    _accountController.dispose();
    _verifyCodeController.dispose();
    _passwordController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  /// 跳转到协议页面
  void _toAgreementPage(String title, String url) {
    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': url},
    );
  }

  /// 发送登录验证码
  Future<void> _sendVerifyCode() async {
    // 1. 校验账号
    final errorMsg = ToolUtils.checkPhoneValidator(_accountController.text);
    if (errorMsg != null) {
      AppToast.showToast(errorMsg);
      return;
    }

    try {
      // 2. 请求接口
      final response = await VerifyCodeService().sendVerifyCode(
        VerificationCodeRequest(
          verifyType: "1",
          verifyKey: _accountController.text,
          verifyScene: "LOGIN",
        ),
      );
      // 3. 保存唯一标识 + 启动倒计时
      _verificationCode.uniqueId = response.uniqueId;
      _countdownController.start();
      AppToast.showToast("验证码发送成功");
    } catch (e) {
      AppToast.showToast("验证码发送失败：$e");
    }
  }

  /// 登录提交
  Future<void> _login() async {
    // 🔥 协议必选校验
    if (!_isAgree) {
      AppToast.showToast("请勾选用户协议和隐私政策");
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _verificationCode.verifyCode = _verifyCodeController.text;
    AppToast.showLoading();

    final UserEntity? userEntity = await AuthService().login(
      UserLoginRequest(
        loginId: _accountController.text,
        identifyType: _isPasswordLogin ? "1" : "2",
        identifyValue: _isPasswordLogin ? _passwordController.text : null,
        verificationCode: _isPasswordLogin ? null : _verificationCode,
      ),
      context,
    );

    AppToast.dismiss();
    if (userEntity == null) {
      AppToast.showToast("登录失败，请检查账号密码");
    } else {
      NavigatorUtils.goNamed(RouteNames.home);
    }
  }

  // ====================== UI 组件拆分（对齐注册页） ======================
  Widget _signInTitle() {
    return AppText.customerTitle("登录", 50.sp, FontWeight.bold);
  }

  Widget _accountInput() {
    return AppInput(
      controller: _accountController,
      label: '账号',
      prefix: Icon(
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
      label: '密码',
      prefix: Icon(
        Icons.password,
        size: 32.w,
        color: AppColors.textGray(context),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "密码不能为空";
        return null;
      },
    );
  }

  /// 验证码输入框（响应式倒计时）
  Widget _verifyCodeInput() {
    return ListenableBuilder(
      listenable: _countdownController,
      builder: (context, child) {
        return AppCodeInput(
          controller: _verifyCodeController,
          onSendCode: _sendVerifyCode,
          isCounting: _countdownController.isCounting,
          countTime: _countdownController.countDown,
        );
      },
    );
  }

  /// 切换登录方式
  Widget _switchLoginType() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppTextButton(
        text: '切换登录方式',
        onTap: () => setState(() => _isPasswordLogin = !_isPasswordLogin),
      ),
    );
  }

  /// 协议勾选框（复用注册页组件，右对齐）
  Widget _agreementWidget() {
    return AppAgreementCheckbox(
      isAgree: _isAgree,
      onChanged: (value) => setState(() => _isAgree = value),
      onUserAgreement: () => _toAgreementPage("用户协议", Env.userAgreementUrl),
      onPrivacyPolicy: () => _toAgreementPage("隐私政策", Env.privacyPolicyUrl),
    );
  }

  Widget _loginButton() {
    return AppButton(onTap: _login, text: '登录');
  }

  Widget _bottomRegisterText() {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second("没有账号？"),
          AppTextButton(
            onTap: () => NavigatorUtils.goNamed(RouteNames.signup),
            text: '注册',
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
