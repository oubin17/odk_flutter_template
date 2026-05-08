class UserProfileService {
  // 单例实例
  static final UserProfileService _instance = UserProfileService._internal();

  UserProfileService._internal();
  factory UserProfileService() => _instance;
}
