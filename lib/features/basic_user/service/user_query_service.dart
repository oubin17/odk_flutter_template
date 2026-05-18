import 'dart:convert';

import 'package:odk_flutter_template/core/session/user_session_service.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/features/mine/api/user_profile_api.dart';
import 'package:odk_flutter_template/features/basic_user/api/user_query_api.dart';
import 'package:odk_flutter_template/features/basic_user/models/user_query/user_entity.dart';

class UserQueryService {
  // 单例实例
  static final UserQueryService _instance = UserQueryService._internal();

  UserQueryService._internal();
  factory UserQueryService() => _instance;

  /// 获取用户信息
  Future<UserEntity> getUserInfo() async {
    // 拦截器已经统一处理了所有异常
    UserEntity user = await UserQueryApi().getUserInfo();

    // 如果 avatar 不为空，调用服务端获取头像完整地址
    if (user.userProfile.avatar != null) {
      try {
        final response = await UserProfileApi().getAvatarUrl();
        if (response.success && response.data != null) {
          user.userProfile.avatarUrl = response.data.toString();
        }
      } catch (_) {
        // 获取头像地址失败不影响主流程
      }
    }

    return user;
  }

  /// 刷新用户信息（从服务器获取最新数据并更新本地存储和状态）
  Future<void> reloadUserInfo() async {
    UserEntity user = await getUserInfo();
    await UserSessionService().syncUserSession(
      user,
      token: null,
      updateToken: false,
    );
  }

  /// 获取本地用户信息
  Future<UserEntity?> getLocalUserInfo() async {
    final String? userInfo = await SecureStorageManager().read(
      StorageKey.userInfo,
    );
    if (userInfo == null) {
      return getUserInfo();
    } else {
      return UserEntity.fromJson(jsonDecode(userInfo));
    }
  }
}
