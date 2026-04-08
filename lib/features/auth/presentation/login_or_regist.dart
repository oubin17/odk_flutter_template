import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/button/basic_app_button.dart';
import 'package:provider/provider.dart';

class LoginOrRegistPage extends StatelessWidget {
  const LoginOrRegistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InnerLoginPage(title: '用户登录');
  }
}

class InnerLoginPage extends StatefulWidget {
  const InnerLoginPage({super.key, required this.title});

  final String title;

  @override
  State<InnerLoginPage> createState() => _InnerLoginPageState();
}

class _InnerLoginPageState extends State<InnerLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: BasicAppbar(title: Text(widget.title)),
      // 👇 【核心】禁止页面随键盘上移，背景永久固定
      resizeToAvoidBottomInset: false,
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
                  const SizedBox(height: 20),
                  _emailField(context),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Widget _appLogoField() {
    return SvgPicture.asset(
      AppImages.logoBg,
      width: 80,
      height: 80,
      // 👇 填充模式，保证全屏覆盖
      fit: BoxFit.cover,
    );
  }

  Widget _emailField(BuildContext context) {
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

  Widget _registerButton(BuildContext context) {
    return BasicAppButton(onPressed: () => _login(context), title: '登录');
  }
}
