// 单独的手机号校验逻辑（复用给输入框 + 发送验证码）
String? checkPhoneValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "账号不能为空";
  }
  final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
  if (!phoneRegex.hasMatch(value)) {
    return "请输入正确的11位手机号";
  }
  return null;
}
