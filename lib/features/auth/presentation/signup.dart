import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/auth/data/models/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

//注册页面
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController accountController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Widget registerText() {
      return AppText.customerTitle("注册", 40.sp, FontWeight.bold);
    }

    Widget userNameField() {
      return AppInput(
        controller: userNameController,
        label: '用户名',
        hint: '请输入用户名',
        prefix: const Icon(Icons.account_circle),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "用户名不能为空";
          }
          return null;
        },
      );
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

    void register(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        final String? userId = await AuthService().register(
          UserRegistRequest(
            userName: userNameController.text,
            loginId: accountController.text,
            identifyValue: passwordController.text,
          ),
        );
        if (userId == null) {
          AppToast.showToast("注册失败");
        } else {
          NavigatorUtils.goNamed(RouteNames.signin);
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
      // appBar: BasicAppbar(title: Text(widget.title)),
      // 👇 【核心】禁止页面随键盘上移，背景永久固定
      resizeToAvoidBottomInset: false,
      // 👇 核心2：让body延伸【覆盖底部导航栏】+ 全屏显示
      extendBody: true,
      // 可选：让body延伸覆盖状态栏（顶部也全屏）
      // extendBodyBehindAppBar: true,
      body: Stack(
        // 👇 【优化】Stack铺满全屏
        fit: StackFit.expand,
        children: [
          // 👇 背景图：固定不动，不受键盘影响
          Image.asset(
            Assets.login.loginRegist.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 👇 【优化】滚动视图：防止键盘挡住输入框
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _appLogoField(),
                  registerText(),
                  SizedBox(height: 40.h),
                  userNameField(),
                  SizedBox(height: 40.h),
                  accountField(),
                  SizedBox(height: 40.h),
                  passwordField(),
                  Spacer(),
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
