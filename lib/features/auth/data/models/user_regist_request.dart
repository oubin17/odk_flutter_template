class UserRegistRequest {
  String username;
  String loginId;
  final String loginType = "1";
  final String identifyType = "1";
  String identifyValue;

  UserRegistRequest({
    required this.username,
    required this.loginId,
    required this.identifyValue,
  });
}
