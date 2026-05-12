import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/domain/verify_code.dart';
import 'package:odk_flutter_template/widgets/app_countdown/countdown_controller.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 完整的验证码输入组件（封装倒计时 + 发送逻辑 + 输入框）
///
/// 使用示例1 - 传入账号控制器（如登录/注册页）：
/// ```dart
/// VerifyCodeInput(
///   accountController: _accountController,
///   verifyScene: VerifyScene.login,
///   onUniqueIdChanged: (uniqueId) {
///     _verificationCode.uniqueId = uniqueId;
///   },
/// ),
/// ```
///
/// 使用示例2 - 直接传入账号（如修改密码页）：
/// ```dart
/// VerifyCodeInput(
///   account: UserService.currentUser.phone,
///   verifyScene: VerifyScene.resetPassword,
///   onUniqueIdChanged: (uniqueId) {
///     _verificationCode.uniqueId = uniqueId;
///   },
/// ),
/// ```
enum VerifyScene {
  login("LOGIN"),
  register("REGISTER"),
  resetPassword("RESET_PASSWORD"),
  common("COMMON");

  final String code;
  const VerifyScene(this.code);
}

enum VerifyType {
  userId("0", "USER_ID"),

  mobile("1", "MOBILE"),

  email("2", "EMAIL");

  final String code;

  final String name;
  const VerifyType(this.code, this.name);
}

class VerifyCodeInput extends StatefulWidget {
  /// 账号输入控制器（用于获取手机号）
  /// 与 [account] 二选一，优先使用 [accountController]
  final TextEditingController? accountController;

  /// 直接传入账号（用于不需要用户输入账号的场景，如修改密码）
  /// 与 [accountController] 二选一
  final String? account;

  /// 验证码使用场景
  final VerifyScene verifyScene;

  /// 验证码类型
  final VerifyType? verifyType;

  /// 验证码输入控制器（外部可获取输入的验证码）
  final TextEditingController? verifyCodeController;

  /// 验证码唯一标识变化回调（用于外部保存 uniqueId）
  final void Function(String)? onUniqueIdChanged;

  /// 验证码输入回调
  final void Function(String)? onChanged;

  /// 表单校验器
  final String? Function(String?)? validator;

  /// 表单保存回调
  final void Function(String?)? onSaved;

  /// 自动校验模式
  final AutovalidateMode? autovalidateMode;

  const VerifyCodeInput({
    super.key,
    this.accountController,
    this.account,
    this.verifyType,
    required this.verifyScene,
    this.verifyCodeController,
    this.onUniqueIdChanged,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
  }) : assert(
         accountController != null || account != null,
         "Either accountController or account must be provided.",
       );

  @override
  State<VerifyCodeInput> createState() => _VerifyCodeInputState();
}

class _VerifyCodeInputState extends State<VerifyCodeInput> {
  /// 内部倒计时控制器
  late final CountdownController _countdownController;

  /// 验证码输入控制器（内部默认创建，支持外部传入）
  late final TextEditingController _verifyCodeController;

  @override
  void initState() {
    super.initState();
    _countdownController = CountdownController();
    _verifyCodeController =
        widget.verifyCodeController ?? TextEditingController();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    // 只有内部创建的控制器才释放
    if (widget.verifyCodeController == null) {
      _verifyCodeController.dispose();
    }
    super.dispose();
  }

  /// 获取当前验证码控制器
  TextEditingController get verifyCodeController => _verifyCodeController;

  /// 获取账号
  String get _account {
    if (widget.accountController != null) {
      return widget.accountController!.text;
    }
    return widget.account!;
  }

  /// 发送验证码
  Future<String?> sendVerifyCode() async {
    final uniqueId = await _sendVerifyCode(
      account: _account,
      verifyType: widget.verifyType?.code ?? VerifyType.userId.code,
      verifyScene: widget.verifyScene,
    );
    if (uniqueId != null) {
      _countdownController.start();
      widget.onUniqueIdChanged?.call(uniqueId);
    }
    return uniqueId;
  }

  /// 发送验证码
  ///
  /// [account] 账号（手机号）
  /// [verifyScene] 验证码使用场景
  ///
  /// 返回 uniqueId（验证码唯一标识），用于后续业务请求
  static Future<String?> _sendVerifyCode({
    required String account,
    required String verifyType,
    required VerifyScene verifyScene,
  }) async {
    // 1. 校验账号
    final errorMsg = ToolUtils.checkPhoneValidator(account);
    if (errorMsg != null) {
      AppToast.showToast(errorMsg);
      return null;
    }

    try {
      // 2. 请求接口
      final response = await VerifyCodeService().sendVerifyCode(
        VerificationCodeRequest(
          verifyType: verifyType,
          verifyKey: account,
          verifyScene: verifyScene.code,
        ),
      );
      // 3. 返回唯一标识
      AppToast.showToast(L10nUtils.success);
      return response.uniqueId;
    } catch (e) {
      AppToast.showToast(L10nUtils.responseError);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _countdownController,
      builder: (context, child) {
        return AppCodeInput(
          controller: _verifyCodeController,
          onSendCode: sendVerifyCode,
          isCounting: _countdownController.isCounting,
          countTime: _countdownController.countDown,
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return L10nUtils.pleaseEnterVerifyCode;
                }
                return null;
              },
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          autovalidateMode: widget.autovalidateMode,
        );
      },
    );
  }
}

/// /// 验证码输入框（支持表单校验 + 主题适配 + 倒计时）
class AppCodeInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendCode;
  final bool isCounting;
  final int countTime;

  // 新增：表单校验核心参数（与AppInput完全一致）
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppCodeInput({
    super.key,
    required this.controller,
    required this.onSendCode,
    required this.isCounting,
    this.countTime = 60,
    // 新增校验参数
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput> {
  @override
  Widget build(BuildContext context) {
    // 核心：替换为 TextFormField，支持校验
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      // 绑定校验相关属性
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        hintText: L10nUtils.pleaseEnterVerifyCode,
        hintStyle: TextStyle(
          fontSize: 26.sp,
          color: AppColors.textGray(context),
        ),
        // filled: true,
        // fillColor: AppColors.card(context),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16.w),
        //   borderSide: BorderSide.none,
        // ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16.w),
        //   borderSide: BorderSide(color: AppColors.divider(context), width: 1.w),
        // ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight(context),
            width: 1.w,
          ),
        ),
        // 正常状态边框
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight(context),
            width: 1.w,
          ),
        ),
        // 聚焦状态边框（和正常状态完全一样，不变色）
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight(context),
            width: 1.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
        // 错误提示样式（统一主题）
        errorStyle: TextStyle(fontSize: 24.sp, color: AppColors.error),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: TextButton(
            onPressed: widget.isCounting ? null : widget.onSendCode,
            child: AppText(
              widget.isCounting
                  ? L10nUtils.resendAfterSeconds(widget.countTime)
                  : L10nUtils.getVerifyCode,
              color: widget.isCounting
                  ? AppColors.textGray(context)
                  : AppColors.primary(context),
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}
