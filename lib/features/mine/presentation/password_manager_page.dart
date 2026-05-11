import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_identify/password_reset_request.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_identify/password_update_request.dart';
import 'package:odk_flutter_template/features/basic_user/domain/user_identify_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_countdown/countdown_controller.dart';
import 'package:odk_flutter_template/widgets/app_countdown/verify_code_input.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

enum PasswordManagerType { set, change }

class PasswordManagerPage extends StatefulWidget {
  final String title;
  final PasswordManagerType type;

  const PasswordManagerPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<PasswordManagerPage> createState() => _PasswordManagerPageState();
}

class _PasswordManagerPageState extends State<PasswordManagerPage> {
  // ✅ 修复：独立控制器，Stateful 中正确声明
  late final TextEditingController _oldPwdController;
  late final TextEditingController _newPwdController;
  late final TextEditingController _confirmPwdController;
  late final TextEditingController _verifyCodeController;

  // 🔥 公共倒计时控制器（全项目复用）
  late final CountdownController _countdownController;

  // 验证码实体
  final VerificationCode _verificationCode = VerificationCode("", "");

  @override
  void initState() {
    super.initState();
    // 初始化控制器
    _oldPwdController = TextEditingController();
    _newPwdController = TextEditingController();
    _confirmPwdController = TextEditingController();
    _verifyCodeController = TextEditingController();
    // 初始化倒计时控制器
    _countdownController = CountdownController();
  }

  @override
  void dispose() {
    // 释放内存
    _oldPwdController.dispose();
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    _verifyCodeController.dispose();
    // 释放倒计时控制器
    _countdownController.dispose();
    super.dispose();
  }

  /// 检查密码是否符合要求
  bool _checkPassword(PasswordManagerType type) {
    final oldPwd = _oldPwdController.text.trim();
    final newPwd = _newPwdController.text.trim();
    final confirmPwd = _confirmPwdController.text.trim();

    if (type == PasswordManagerType.change) {
      if (oldPwd.isEmpty) {
        AppToast.showToast("请输入旧密码");
        return false;
      }
      if (newPwd != confirmPwd) {
        AppToast.showToast("两次输入密码不一致");
        return false;
      }
    }
    return true;
  }

  Future<void> _handleSave() async {
    if (!_checkPassword(widget.type)) return;
    final oldPwd = _oldPwdController.text.trim();
    final newPwd = _newPwdController.text.trim();
    ServiceResponse response;
    switch (widget.type) {
      case PasswordManagerType.set:
        _verificationCode.verifyCode = _verifyCodeController.text.trim();
        if (_verificationCode.verifyCode.isEmpty) {
          AppToast.showToast("请输入验证码");
          return;
        }
        response = await UserIdentifyService().resetPassword(
          PasswordResetRequest(
            identifyValue: newPwd,
            verificationCode: _verificationCode,
          ),
        );
        break;
      case PasswordManagerType.change:
        response = await UserIdentifyService().updatePassword(
          PasswordUpdateRequest(
            oldIdentifyValue: oldPwd,
            newIdentifyValue: newPwd,
          ),
        );
        break;
    }
    if (!response.success) {
      AppToast.showToast("操作失败");
      return;
    }
    AppToast.showToast(L10nUtils.success);
    NavigatorUtils.pop();
  }

  // ✅ 修复：移除无用 Row，简化布局
  Widget _buildPasswordItem(
    TextEditingController controller,
    String title,
    String hint,
  ) {
    return AppInput(
      controller: controller,
      hint: hint,
      prefixIcon: AppText(
        title,
        size: 28.sp,
        color: AppColors.textMain(context),
      ),
      obscure: true, // 密码框必开隐藏
      validator: (value) => value?.trim().isEmpty ?? true ? "请输入密码" : null,
      suffixIcon: ClearButton(controller: controller),
    );
  }

  /// 验证码输入框（响应式倒计时）
  Widget _verifyCodeInput() {
    // 使用 read 只读取一次，不监听变化
    final userProvider = context.read<UserProvider>();
    final phone = userProvider.userEntity?.accessToken.tokenValue ?? "";
    return VerifyCodeInput(
      account: phone,
      verifyScene: VerifyScene.resetPassword,
      verifyCodeController: _verifyCodeController,
      onUniqueIdChanged: (uniqueId) {
        _verificationCode.uniqueId = uniqueId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: AppText(widget.title), onSave: _handleSave),
      body: SingleChildScrollView(
        // ✅ 修复：防止键盘弹出溢出
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            // 根据类型显示：设置密码=只显示新密码+确认；修改密码=显示旧/新/确认
            if (widget.type == PasswordManagerType.set)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 0.h),
                child: Column(
                  children: [
                    _buildPasswordItem(_newPwdController, "新密码    ", "请输入新密码"),
                    _verifyCodeInput(),
                  ],
                ),
              ),
            if (widget.type == PasswordManagerType.change)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 0.h),
                child: Column(
                  children: [
                    _buildPasswordItem(_oldPwdController, "旧密码    ", "请输入旧密码"),
                    _buildPasswordItem(_newPwdController, "新密码    ", "请输入新密码"),
                    _buildPasswordItem(
                      _confirmPwdController,
                      "确认密码",
                      "请输入确认密码",
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
