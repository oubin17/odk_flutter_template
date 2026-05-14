import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 登录/注册页共享 UI 逻辑 Mixin
///
/// 统一管理：表单控制器、账号输入框、底部导航、协议跳转、mounted 安全回调
///
/// 注意：协议勾选状态（isAgree）和业务逻辑（checkAgreement、register、login）
/// 已迁移到 ViewModel 层，由 SignUpViewModel / SignInViewModel 管理
///
/// 使用方式：
/// ```dart
/// class _MyPageState extends State<MyPage> with AuthMixin {
///   // 直接使用 formKey, accountController 等属性
///   // 直接使用 validateForm(), accountInput() 等方法
///   // 协议相关通过 ViewModel 管理
/// }
/// ```
mixin AuthMixin<T extends StatefulWidget> on State<T> {
  // ====================== 表单控制器 ======================
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController verifyCodeController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    verifyCodeController.dispose();
    super.dispose();
  }

  // ====================== mounted 安全回调 ======================

  /// 仅在 mounted 时执行回调（导航跳转、Toast 等）
  void mountedSafeCallback(VoidCallback fn) {
    if (mounted) {
      fn();
    }
  }

  // ====================== 协议跳转 ======================

  /// 跳转到协议页面
  void toAgreementPage(String title, String url) {
    NavigatorUtils.pushNamed(
      RouteNames.agreement,
      queryParameters: {'title': title, 'url': url},
    );
  }

  // ====================== 表单校验 ======================

  /// 表单校验
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // ====================== 输入组件 ======================

  /// 账号输入框
  Widget accountInput({Widget? suffixIcon}) {
    return AppInput(
      controller: accountController,
      label: L10nUtils.account,
      prefixIcon: Icon(
        Icons.phone_outlined,
        size: 32.w,
        color: AppColors.textGray(context),
      ),
      suffixIcon: suffixIcon,
      validator: ToolUtils.checkPhoneValidator,
    );
  }

  // ====================== 底部导航 ======================

  /// 底部导航文字（登录/注册互跳）
  Widget authBottomNav({
    required String hint,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.second(hint),
          AppTextButton(onTap: onTap, text: actionText),
        ],
      ),
    );
  }
}
