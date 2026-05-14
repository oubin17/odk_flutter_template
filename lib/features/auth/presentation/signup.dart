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
  Future<void> _register() async {
    final vm = context.read<SignUpViewModel>();

    // 协议校验
    final agreementError = vm.checkAgreement();
    if (agreementError != null) {
      AppToast.showToast(agreementError);
      return;
    }

    // 表单校验
    if (!validateForm()) return;

    // 防重复提交（ViewModel 的 isLoading 已由 Selector 监听控制按钮禁用，
    // 这里额外检查防止 Selector 重建间隙的重复点击）
    if (vm.isLoading) return;

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

  /// 注册按钮 — 监听 isLoading 控制禁用状态
  Widget _registerButton() {
    return Selector<SignUpViewModel, bool>(
      selector: (_, vm) => vm.isLoading,
      builder: (_, isLoading, _) {
        return AppButton(
          onTap: isLoading ? null : _register,
          text: L10nUtils.register,
        );
      },
    );
  }

  // ====================== 主布局 ======================
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 88.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppGap.hLarge,
                    AppGap.hLarge,
                    _appLogo(),
                    AppGap.hLarge,
                    _registerTitle(),
                    AppGap.hLarge,
                    accountInput(
                      suffixIcon: ClearButton(controller: accountController),
                    ),
                    AppGap.hSmall,
                    VerifyCodeInput(
                      accountController: accountController,
                      verifyScene: VerifyScene.register,
                      verifyType: VerifyType.mobile,
                      verifyCodeController: verifyCodeController,
                      onUniqueIdChanged: (uniqueId) {
                        context.read<SignUpViewModel>().verifyCodeUniqueId =
                            uniqueId;
                      },
                    ),
                    SizedBox(height: 200.h),
                    _registerButton(),
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
        hint: L10nUtils.hasAccount,
        actionText: L10nUtils.login,
        onTap: () => NavigatorUtils.goNamed(RouteNames.signin),
      ),
    );
  }

  /// 协议勾选组件 — 绑定 ViewModel 状态
  Widget _agreementWidget() {
    final vm = context.read<SignUpViewModel>();
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
