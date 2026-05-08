import 'dart:convert';

import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/features/basic_user/data/api/user_query_api.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';

class UserQueryService {
  // 单例实例
  static final UserQueryService _instance = UserQueryService._internal();

  UserQueryService._internal();
  factory UserQueryService() => _instance;

  /// 获取用户信息
  Future<UserEntity> getUserInfo() async {
    // 拦截器已经统一处理了所有异常
    UserEntity user = await UserQueryApi().getUserInfo();
    return user;
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
