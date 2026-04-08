class UserLoginRequest {
  final String loginId;
  final String loginType = "1";
  final String identifyType = "1";
  String identifyValue;

  UserLoginRequest({required this.loginId, required this.identifyValue});
}
