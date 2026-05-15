import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/presentation/auth_mixin.dart';
import 'package:odk_flutter_template/features/auth/presentation/signup_view_model.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with AuthMixin {
  // ====================== 业务逻辑 ======================

  /// 注册提交
  Future<void> _register(BuildContext context) async {
    final vm = context.read<SignUpViewModel>();

    // 协议校验
    final agreementError = vm.checkAgreement();
    if (agreementError != null) {
      AppToast.showToast(agreementError);
      return;
    }

    // 表单校验
    if (!validateForm()) return;

    // 同步表单数据到 ViewModel
    vm
      ..account = accountController.text
      ..verifyCode = verifyCodeController.text;

    // Loading 由 ViewModel 内部管理（AppToast.showLoading/dismiss）
    final response = await vm.register();

    if (!mounted) return;

    if (response.success) {
      NavigatorUtils.goNamed(RouteNames.home);
    } else {
      AppToast.showToast(response.errorContext ?? L10nUtils.registerFailed);
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
    return AppText.customerTitle(L10nUtils.register, 50.sp, FontWeight.bold);
  }

  /// 注册按钮 — AppDebounceButton 内置防重复点击
  Widget _registerButton(BuildContext context) {
    return AppDebounceButton(
      text: L10nUtils.register,
      onTap: () => _register(context),
    );
  }

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      builder: (context, child) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
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
            Column(
              children: [
                // 可滚动内容区域
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 88.h,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // AppGap.hLarge,
                          // AppGap.hLarge,
                          // _appLogo(),
                          AppGap.hLarge,
                          _registerTitle(),
                          AppGap.hLarge,
                          accountInput(
                            suffixIcon: ClearButton(
                              controller: accountController,
                            ),
                          ),
                          AppGap.hSmall,
                          VerifyCodeInput(
                            accountController: accountController,
                            verifyScene: VerifyScene.register,
                            verifyType: VerifyType.mobile,
                            verifyCodeController: verifyCodeController,
                            onUniqueIdChanged: (uniqueId) {
                              context
                                      .read<SignUpViewModel>()
                                      .verifyCodeUniqueId =
                                  uniqueId;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 底部固定区域
                _bottomFixedArea(context),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavWidget(),
    );
  }

  Widget _bottomFixedArea(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _registerButton(context),
            _agreementWidget(context),
            // _bottomNavWidget(),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.second(L10nUtils.hasAccount),
        AppTextButton(
          onTap: () => NavigatorUtils.goNamed(RouteNames.signin),
          text: L10nUtils.login,
        ),
      ],
    );
  }

  /// 协议勾选组件 — 绑定 ViewModel 状态
  Widget _agreementWidget(BuildContext context) {
    return Selector<SignUpViewModel, bool>(
      selector: (_, vm) => vm.isAgree,
      builder: (_, isAgree, _) {
        return AppAgreementCheckbox(
          isAgree: isAgree,
          onChanged: (value) => context.read<SignUpViewModel>().isAgree = value,
          onUserAgreement: () =>
              toAgreementPage(L10nUtils.userAgreement, Env.userAgreementUrl),
          onPrivacyPolicy: () =>
              toAgreementPage(L10nUtils.privacyPolicy, Env.privacyPolicyUrl),
        );
      },
    );
  }
}
