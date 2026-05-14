import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/presentation/auth_mixin.dart';
import 'package:odk_flutter_template/features/auth/presentation/signin_view_model.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

/// 登录页面
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with AuthMixin {
  // 密码控制器（登录页独有）
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // ====================== 业务逻辑 ======================

  /// 登录提交
  Future<void> _login() async {
    final vm = context.read<SignInViewModel>();

    // 协议校验
    final agreementError = vm.checkAgreement();
    if (agreementError != null) {
      AppToast.showToast(agreementError);
      return;
    }

    // 表单校验
    if (!validateForm()) return;

    // 防重复提交
    if (vm.isLoading) return;

    // 同步表单数据到 ViewModel
    vm.account = accountController.text;
    if (vm.isPasswordLogin) {
      vm.password = _passwordController.text;
    } else {
      vm.verifyCode = verifyCodeController.text;
    }

    // Loading 由 ViewModel 内部管理（AppToast.showLoading/dismiss）
    final response = await vm.login();

    if (!mounted) return;

    if (response != null) {
      NavigatorUtils.goNamed(RouteNames.home);
    } else {
      AppToast.showToast(vm.errorMessage ?? L10nUtils.loginFailed);
    }
  }

  // ====================== UI 组件拆分 ======================
  Widget _signInTitle() {
    return AppText.customerTitle(L10nUtils.login, 50.sp, FontWeight.bold);
  }

  Widget _passwordInput() {
    return AppInput(
      controller: _passwordController,
      label: L10nUtils.password,
      prefixIcon: Icon(
        Icons.password,
        size: 32.w,
        color: AppColors.textGray(context),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return L10nUtils.fieldNotEmptyTip(L10nUtils.password);
        }
        return null;
      },
    );
  }

  /// 切换登录方式
  Widget _switchLoginType() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppTextButton(
        text: L10nUtils.switchLoginType,
        onTap: () => context.read<SignInViewModel>().toggleLoginType(),
      ),
    );
  }

  /// 登录按钮 — 监听 isLoading 控制禁用状态
  Widget _loginButton() {
    return Selector<SignInViewModel, bool>(
      selector: (_, vm) => vm.isLoading,
      builder: (_, isLoading, _) {
        return AppButton(
          onTap: isLoading ? null : _login,
          text: L10nUtils.login,
        );
      },
    );
  }

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppGap.hLarge,
                    AppGap.hLarge,
                    _signInTitle(),
                    AppGap.hNormal,
                    accountInput(),
                    AppGap.hNormal,
                    // 动态切换登录方式
                    Selector<SignInViewModel, bool>(
                      selector: (_, vm) => vm.isPasswordLogin,
                      builder: (_, isPasswordLogin, _) {
                        if (isPasswordLogin) {
                          return _passwordInput();
                        }
                        return VerifyCodeInput(
                          accountController: accountController,
                          verifyScene: VerifyScene.login,
                          verifyType: VerifyType.mobile,
                          verifyCodeController: verifyCodeController,
                          onUniqueIdChanged: (uniqueId) {
                            context.read<SignInViewModel>().verifyCodeUniqueId =
                                uniqueId;
                          },
                        );
                      },
                    ),
                    AppGap.hSuperSmall,
                    _switchLoginType(),
                    SizedBox(height: 200.h),
                    _loginButton(),
                    _agreementWidget(),
                    AppGap.hNormal,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: authBottomNav(
        hint: L10nUtils.noAccount,
        actionText: L10nUtils.register,
        onTap: () => NavigatorUtils.goNamed(RouteNames.signup),
      ),
    );
  }

  /// 协议勾选组件
  Widget _agreementWidget() {
    final vm = context.read<SignInViewModel>();
    return AppAgreementCheckbox(
      isAgree: vm.isAgree,
      onChanged: (value) => vm.isAgree = value,
      onUserAgreement: () =>
          toAgreementPage(L10nUtils.userAgreement, Env.userAgreementUrl),
      onPrivacyPolicy: () =>
          toAgreementPage(L10nUtils.privacyPolicy, Env.privacyPolicyUrl),
    );
  }
}
