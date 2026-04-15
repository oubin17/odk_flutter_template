import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/auth/data/models/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
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

    void login(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        AppToast.showLoading();
        // 👇 核心：【异步前】提前获取 UserProvider 实例（无context风险）
        final userProvider = context.read<UserProvider>();
        final UserEntity? userEntity = await AuthService().login(
          UserLoginRequest(
            loginId: accountController.text,
            identifyValue: passwordController.text,
          ),
        );
        AppToast.dismiss();
        if (userEntity == null) {
          // 全局修改默认配置
          // SmartDialog.config.toast = SmartConfigToast(isExist: true);
          // AppToast.showToast("登录失败，请检查账号密码");
          AppToast.showToast("登录失败，请检查账号密码");
        } else {
          await userProvider.refresh();
          NavigatorUtils.goNamed(RouteNames.home);
        }
      }
    }

    Widget loginButton(BuildContext context) {
      return AppButton(onTap: () => login(context), text: '登录');
    }

    Widget bottomText(BuildContext context) {
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
                  // _appLogoField(),
                  signInText(),
                  AppGap.hNormal,
                  accountField(),
                  AppGap.hNormal,
                  AppGap.hNormal,
                  passwordField(),
                  const Spacer(),
                  loginButton(context),
                  AppGap.hXL,
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
