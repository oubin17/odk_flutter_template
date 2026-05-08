class UserIdentifyService {
  // 单例实例
  static final UserIdentifyService _instance = UserIdentifyService._internal();

  UserIdentifyService._internal();
  factory UserIdentifyService() => _instance;
}
