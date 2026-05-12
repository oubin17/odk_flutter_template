import 'package:odk_flutter_template/core/utils/l10n_utils.dart';

class ToolUtils {
  /// 统一的手机号校验逻辑
  static String? checkPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return L10nUtils.fieldNotEmptyTip(L10nUtils.account);
    }
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return L10nUtils.fieldFormatErrorTip(L10nUtils.phoneNumber);
    }
    return null;
  }
}
