import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart' as ToolUtils;
import 'package:odk_flutter_template/features/auth/data/models/auth/extend_infodto.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/countdown_controller.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

// 注册页面（优化版）
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

  // 🔥 公共倒计时控制器（自动管理定时器）
  late final CountdownController _countdownController;

  // 协议勾选状态
  bool _isAgree = false;

  @override
  void initState() {
    super.initState();
    // 初始化倒计时（60秒）
    _countdownController = CountdownController();
  }

  @override
  void dispose() {
    // 统一释放资源
    _accountController.dispose();
    _verifyCodeController.dispose();
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

  /// 发送验证码
  Future<void> _sendVerifyCode() async {
    final errorMsg = ToolUtils.checkPhoneValidator(_accountController.text);
    if (errorMsg != null) {
      AppToast.showToast(errorMsg);
      return;
    }

    try {
      final response = await AuthService().sendVerifyCode(
        VerificationCodeRequest(
          verifyType: "1",
          verifyKey: _accountController.text,
          verifyScene: "REGISTER",
        ),
      );
      _verifyCode.uniqueId = response.uniqueId;
      _countdownController.start(); // 启动公共倒计时
      AppToast.showToast("验证码发送成功");
    } catch (e) {
      AppToast.showToast("验证码发送失败：$e");
    }
  }

  /// 注册提交
  Future<void> _register() async {
    if (!_isAgree) {
      AppToast.showToast("请勾选用户协议和隐私政策");
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
      context,
    );

    AppToast.dismiss();
    if (!response.success) {
      AppToast.showToast(response.errorContext ?? "注册失败");
    } else {
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
    return AppText.customerTitle("欢迎回来", 50.sp, FontWeight.bold);
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

  /// 协议组件（修复：右对齐 + 无溢出）
  Widget _agreementWidget() {
    return AppAgreementCheckbox(
      isAgree: _isAgree,
      onChanged: (value) => setState(() => _isAgree = value),
      onUserAgreement: () => _toAgreementPage("用户协议", Env.userAgreementUrl),
      onPrivacyPolicy: () => _toAgreementPage("隐私政策", Env.privacyPolicyUrl),
    );
  }

  Widget _registerButton() {
    return AppButton(onTap: _register, text: '注册');
  }

  Widget _bottomLoginText() {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second("已经有账号？"),
          AppTextButton(
            onTap: () => NavigatorUtils.goNamed(RouteNames.signin),
            text: '登录',
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
