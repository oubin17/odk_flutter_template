class UserProfileApi {
  // 单例实例
  static final UserProfileApi _instance = UserProfileApi._internal();

  UserProfileApi._internal();
  factory UserProfileApi() => _instance;
}
