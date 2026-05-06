import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/extend_infodto.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

//注册页面
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController verifyCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final VerificationCode verifyCode = VerificationCode("", "");

  // 验证码倒计时状态
  bool isCounting = false;
  int countDown = 60;
  Timer? codeTimer; // 定时器

  // 仅保留这一个状态
  bool isAgree = false;

  // 跳转到协议页面（复用你的路由）
  void _toAgreementPage(String title, String url) {
    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': url},
    );
  }

  @override
  void dispose() {
    codeTimer?.cancel(); // 销毁定时器
    // 释放控制器
    userNameController.dispose();
    accountController.dispose();
    verifyCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 启动验证码倒计时
  void startCountDown() {
    setState(() {
      isCounting = true;
      countDown = 60;
    });

    // 开启定时器，每秒减1
    codeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countDown > 1) {
          countDown--;
        } else {
          // 倒计时结束，重置状态
          isCounting = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget appLogo() {
      return Align(
        alignment: Alignment.topLeft,
        child: AppAvatar(
          assetPath: Assets.images.login.loginRegist.path,
          size: 200.w,
          shape: AppAvatarShape.square,
        ),
      );
    }

    Widget registerText() {
      return AppText.customerTitle("欢迎回来", 50.sp, FontWeight.bold);
    }

    Widget accountField() {
      return AppInput(
        controller: accountController,
        label: '账号',
        prefix: Icon(
          Icons.phone_outlined,
          size: 32.w,
          color: AppColors.textGray(context),
        ),
        validator: checkPhoneValidator,
      );
    }

    Widget verifyCodeField() {
      return AppCodeInput(
        controller: verifyCodeController,
        onSendCode: () async {
          // 1. 校验手机号
          final errorMsg = checkPhoneValidator(accountController.text);
          if (errorMsg != null) {
            AppToast.showToast(errorMsg);
            return;
          }

          try {
            // 2. 发送验证码接口
            VerificationCodeResponse response = await AuthService()
                .sendVerifyCode(
                  VerificationCodeRequest(
                    verifyType: "1",
                    verifyKey: accountController.text,
                    verifyScene: "REGISTER",
                  ),
                );

            verifyCode.uniqueId = response.uniqueId;
            startCountDown();
            AppToast.showToast("验证码发送成功");
          } catch (e) {
            AppToast.showToast("验证码发送失败：$e");
          }
        },
        isCounting: isCounting,
        countTime: countDown,
      );
    }

    // 直接使用封装好的组件！
    Widget agreementWidget() {
      return AppAgreementCheckbox(
        isAgree: isAgree,
        onChanged: (value) {
          setState(() {
            isAgree = value;
          });
        },
        onUserAgreement: () =>
            _toAgreementPage("用户协议", "https://www.xxx.com/user_agreement.html"),
        onPrivacyPolicy: () =>
            _toAgreementPage("隐私政策", "https://www.xxx.com/privacy_policy.html"),
      );
    }

    void register(BuildContext context) async {
      // ====================== 新增：注册前必选校验协议 ======================
      if (!isAgree) {
        AppToast.showToast("请勾选用户协议和隐私政策");
        return;
      }

      if (formKey.currentState!.validate()) {
        AppToast.showLoading();
        verifyCode.verifyCode = verifyCodeController.text;
        final ServiceResponse serviceResponse = await AuthService().register(
          UserRegistRequest(
            userName: userNameController.text,
            loginId: accountController.text,
            identifyValue: passwordController.text,
            verificationCode: verifyCode,
            extendInfoDTO: ExtendInfoDto(privacyVersion: "v1.0"),
          ),
          context,
        );
        AppToast.dismiss();
        if (!serviceResponse.success) {
          AppToast.showToast(serviceResponse.errorContext ?? "注册失败");
        } else {
          NavigatorUtils.goNamed(RouteNames.home);
        }
      }
    }

    Widget registerButton(BuildContext context) {
      return AppButton(onTap: () => register(context), text: '注册');
    }

    Widget signupText(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(60.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.second("已经有账号？"),
            AppTextButton(
              onTap: () {
                NavigatorUtils.goNamed(RouteNames.signin);
              },
              text: '登录',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppGap.hLarge,
                  AppGap.hLarge,
                  appLogo(),
                  AppGap.hLarge,
                  registerText(),
                  AppGap.hLarge,
                  accountField(),
                  AppGap.hSmall,
                  verifyCodeField(),
                  AppGap.hSuperSmall,
                  agreementWidget(), // ✅ 一行调用
                  const Spacer(),
                  registerButton(context),
                  AppGap.hXL,
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: signupText(context),
    );
  }
}
