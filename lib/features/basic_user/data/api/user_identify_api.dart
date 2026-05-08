class UserIdentifyApi {
  // 单例实例
  static final UserIdentifyApi _instance = UserIdentifyApi._internal();

  UserIdentifyApi._internal();
  factory UserIdentifyApi() => _instance;
}
