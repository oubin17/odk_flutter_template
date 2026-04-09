import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/data/models/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/button/basic_app_button.dart';
import 'package:odk_flutter_template/widgets/toast/basic_toast.dart';

//
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController accountController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Widget registerText() {
      return Text(
        "注册",
        style: TextStyle(
          // color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }

    Widget userNameField() {
      return TextFormField(
        controller: userNameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.app_registration),
          labelText: '用户名',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入用户名';
          }
          return null;
        },
      );
    }

    Widget accountField() {
      return TextFormField(
        controller: accountController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.app_registration),
          labelText: '账号',
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

    void register(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        final String? userId = await AuthService().register(
          UserRegistRequest(
            username: userNameController.text,
            loginId: accountController.text,
            identifyValue: passwordController.text,
          ),
        );
        if (userId == null) {
          BasicToast.show("注册失败");
        } else {
          NavigatorUtils.goNamed(RouteNames.signin);
        }
      }
    }

    Widget registerButton(BuildContext context) {
      return BasicAppButton(onPressed: () => register(context), title: '注册');
    }

    Widget signupText(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "已经有账号？",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                {
                  NavigatorUtils.goNamed(RouteNames.signin);
                }
              },
              child: Text('登录'),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 50.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _appLogoField(),
                  registerText(),
                  const SizedBox(height: 20),
                  userNameField(),
                  const SizedBox(height: 20),
                  accountField(),
                  const SizedBox(height: 20),
                  passwordField(),
                  const SizedBox(height: 40),
                  registerButton(context),
                  const SizedBox(height: 20),
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
