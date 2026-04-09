import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/button/basic_app_button.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/basic_toast.dart';
import 'package:provider/provider.dart';

//登录页面
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController accountController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Widget signInText() {
      return Text(
        "登录",
        style: TextStyle(
          // color: Colors.white,
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget accountField() {
      return TextFormField(
        controller: accountController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.app_registration),
          labelText: '账号',
          hintText: '请输入账号',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入账号';
          }
          return null;
        },
      );
    }

    Widget passwordField() {
      return TextFormField(
        controller: passwordController,
        decoration: const InputDecoration(
          hintText: '请输入密码',
          labelText: '密码',
          prefixIcon: Icon(Icons.password),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入密码';
          }
          return null;
        },
      );
    }

    void login(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        // 👇 核心：【异步前】提前获取 UserProvider 实例（无context风险）
        final userProvider = context.read<UserProvider>();
        final UserEntity? userEntity = await AuthService().login(
          UserLoginRequest(
            loginId: accountController.text,
            identifyValue: passwordController.text,
          ),
        );
        if (userEntity == null) {
          BasicToast.showToast("登录失败，请检查账号密码");
        } else {
          await userProvider.refresh();
          NavigatorUtils.goNamed(RouteNames.home);
        }
      }
    }

    Widget loginButton(BuildContext context) {
      return BasicAppButton(onPressed: () => login(context), title: '登录');
    }

    Widget bottomText(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(60.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "没有账号？",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                {
                  NavigatorUtils.goNamed(RouteNames.signup);
                }
              },
              child: Text('注册'),
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
            AppImages.login,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 👇 【优化】滚动视图：防止键盘挡住输入框
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _appLogoField(),
                  signInText(),
                  SizedBox(height: 40.h),
                  accountField(),
                  SizedBox(height: 40.h),
                  passwordField(),
                  SizedBox(height: 40.h),
                  loginButton(context),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomText(context),
    );
  }
}
