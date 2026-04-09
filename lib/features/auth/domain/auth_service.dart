import 'dart:convert';

import 'package:odk_flutter_template/core/exceptions/app_exception.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/encrypt_utils.dart';
import 'package:odk_flutter_template/features/auth/data/api/auth_api.dart';
import 'package:odk_flutter_template/features/auth/data/models/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/userlogin_response.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  // 登录状态（默认未登录）
  // bool isLoggedIn = false;

  /// 注册
  Future<String?> register(UserRegistRequest request) async {
    request.identifyValue = await EncryptUtils.encrypt(request.identifyValue);

    return await AuthApi().register(request);
  }

  /// 登录
  Future<UserEntity?> login(UserLoginRequest request) async {
    // 直接调用 API，让异常自然向上传递
    request.identifyValue = await EncryptUtils.encrypt(request.identifyValue);

    // 拦截器已经统一处理了所有异常
    UserLoginResponse? response = await AuthApi().login(request);

    //1.存储 token
    await SecureStorageManager().write(StorageKey.token, response?.token ?? '');
    UserEntity userEntity = UserEntity.fromJson(
      jsonDecode(jsonEncode(response?.toJson() ?? {})),
    );
    //2.存储用户信息
    await SecureStorageManager().write(
      StorageKey.userInfo,
      jsonEncode(userEntity.toJson()),
    );
    // isLoggedIn = true;
    return userEntity;
  }

  /// 登录方法，返回用户 ID
  ///
  /// 异常处理说明:
  /// - [AppException] - 网络错误或服务器业务错误，包含明确的错误类型和消息
  Future<void> logout() async {
    // 拦截器已经统一处理了所有异常
    await AuthApi().logout();
    await afterLogout();
  }

  /// 登出后需要执行的操作，清除 storage 中的所有数据
  Future<void> afterLogout() async {
    // isLoggedIn = false;
    await SecureStorageManager().deleteAll();
    await StorageManager().clear();
  }

  /// 检查用户是否已登录
  Future<bool> checkLoggedIn() async {
    // 读取加密存储中的 token
    final token = await SecureStorageManager().read(StorageKey.token);
    // 不为空且不为空字符串，说明已登录
    if (token == null || token.isEmpty) return false;
    await AuthApi().validateToken();
    return true;
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

  /// 获取用户信息
  Future<UserEntity> getUserInfo() async {
    // 拦截器已经统一处理了所有异常
    UserEntity user = await AuthApi().getUserInfo();
    return user;
  }
}
