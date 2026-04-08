import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/button/basic_app_button.dart';
import 'package:provider/provider.dart';

//
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Widget _registerText() {
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

    Widget _accountField(BuildContext context) {
      return TextFormField(
        controller: _emailController,
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

    Widget _passwordField(BuildContext context) {
      return TextFormField(
        controller: _passwordController,
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

    // ✅ 修复后的登录方法（无警告、安全）
    void _login(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        // 👇 核心：【异步前】提前获取 UserProvider 实例（无context风险）
        final userProvider = context.read<UserProvider>();
        final UserEntity? userEntity = await AuthService().login(
          UserLoginRequest(
            loginId: _emailController.text,
            identifyValue: _passwordController.text,
          ),
        );
        if (userEntity != null) {
          await userProvider.refresh();
          NavigatorUtils.goNamed(RouteNames.home);
        }
      }
    }

    Widget _registerButton(BuildContext context) {
      return BasicAppButton(onPressed: () => _login(context), title: '注册');
    }

    Widget _signupText(BuildContext context) {
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _appLogoField(),
                  _registerText(),
                  const SizedBox(height: 20),
                  _accountField(context),
                  const SizedBox(height: 20),
                  _passwordField(context),
                  const SizedBox(height: 40),
                  _registerButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _signupText(context),
    );
  }
}
