import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

// 登录页面 → 改为 StatefulWidget
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController verifyCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final VerificationCode verificationCode = VerificationCode("", "");
  bool passwordLogin = true; // 状态变量，放在State里

  @override
  void dispose() {
    // 释放控制器，防止内存泄漏
    accountController.dispose();
    verifyCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget signInText() {
    return AppText.customerTitle("登录", 40.sp, FontWeight.bold);
  }

  Widget accountField() {
    return AppInput(
      controller: accountController,
      label: '账号',
      hint: '请输入账号',
      prefix: const Icon(Icons.app_registration),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "账号不能为空";
        }
        return null;
      },
    );
  }

  Widget verifyCodeField() {
    return AppCodeInput(
      controller: verifyCodeController,
      onSendCode: () async {
        VerificationCodeResponse response = await AuthService().sendVerifyCode(
          VerificationCodeRequest(
            verifyType: "1",
            verifyKey: accountController.text,
            verifyScene: "LOGIN",
          ),
        );
        verificationCode.uniqueId = response.uniqueId;
      },
      isCounting: false,
    );
  }

  Widget switchLoginTypeField() {
    return AppTextButton(
      text: '切换登录方式',
      onTap: () {
        // ✅ 必须用 setState 更新状态，刷新UI
        setState(() {
          passwordLogin = !passwordLogin;
        });
      },
    );
  }

  Widget passwordField() {
    return AppInput(
      controller: passwordController,
      label: '密码',
      hint: '请输入密码',
      prefix: const Icon(Icons.password),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "密码不能为空";
        }
        return null;
      },
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      verificationCode.verifyCode = verifyCodeController.text;
      AppToast.showLoading();
      final userProvider = context.read<UserProvider>();
      final UserEntity? userEntity = await AuthService().login(
        UserLoginRequest(
          loginId: accountController.text,
          identifyType: passwordLogin ? "1" : "2",
          // 密码登录 → 传密码；验证码登录 → 传null
          identifyValue: passwordLogin ? passwordController.text : null,
          // 验证码登录 → 传验证码对象；密码登录 → 传null
          verificationCode: passwordLogin ? null : verificationCode,
        ),
      );
      AppToast.dismiss();
      if (userEntity == null) {
        AppToast.showToast("登录失败，请检查账号密码");
      } else {
        await userProvider.refresh();
        NavigatorUtils.goNamed(RouteNames.home);
      }
    }
  }

  Widget loginButton() {
    return AppButton(onTap: login, text: '登录');
  }

  Widget bottomText() {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second("没有账号？"),
          AppTextButton(
            onTap: () {
              NavigatorUtils.goNamed(RouteNames.signup);
            },
            text: '注册',
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
          Image.asset(
            Assets.images.login.loginRegist.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  signInText(),
                  AppGap.hNormal,
                  accountField(),
                  AppGap.hNormal,
                  if (passwordLogin) passwordField() else verifyCodeField(),
                  AppGap.hSuperSmall,
                  switchLoginTypeField(),
                  const Spacer(),
                  loginButton(),
                  AppGap.hXL,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomText(),
    );
  }
}
