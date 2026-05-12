import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/tool_utils.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/domain/verify_code.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 验证码工具类（提供全项目复用的发送验证码能力）
class VerifyCodeUtils {
  /// 发送验证码
  ///
  /// [controller] 输入账号的 TextEditingController
  /// [verifyScene] 验证码使用场景（如：LOGIN, REGISTER, RESET_PASSWORD 等）
  ///
  /// 返回 uniqueId（验证码唯一标识），用于后续业务请求
  static Future<String?> sendVerifyCode({
    required TextEditingController controller,
    required String verifyScene,
  }) async {
    // 1. 校验账号
    final errorMsg = ToolUtils.checkPhoneValidator(controller.text);
    if (errorMsg != null) {
      AppToast.showToast(errorMsg);
      return null;
    }

    try {
      // 2. 请求接口
      final response = await VerifyCodeService().sendVerifyCode(
        VerificationCodeRequest(
          verifyType: "1",
          verifyKey: controller.text,
          verifyScene: verifyScene,
        ),
      );
      // 3. 返回唯一标识
      AppToast.showToast("验证码发送成功");
      return response.uniqueId;
    } catch (e) {
      AppToast.showToast("验证码发送失败：$e");
      return null;
    }
  }
}
