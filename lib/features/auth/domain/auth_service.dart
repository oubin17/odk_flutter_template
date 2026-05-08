import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/exceptions/app_exception.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/encrypt_utils.dart';
import 'package:odk_flutter_template/features/auth/data/api/auth_api.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_regist_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/user_login_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/auth/userlogin_response.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_request.dart';
import 'package:odk_flutter_template/features/auth/data/models/verify_code/verification_code_response.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  factory AuthService() => _instance;

  // 登录状态（默认未登录）
  // bool isLoggedIn = false;

  /// 注册
  Future<ServiceResponse> register(
    UserRegistRequest request,
    BuildContext context,
  ) async {
    if (request.identifyValue != null) {
      request.identifyValue = await EncryptUtils.encrypt(
        request.identifyValue!,
      );
    }

    ServiceResponse response = await AuthApi().loginAfterRegister(request);
    if (response.success) {
      UserLoginResponse userLoginResponse = UserLoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      //1.存储 token
      await _doAfterLogin(userLoginResponse, context);
    }
    return response;
  }

  /// 登录
  Future<UserEntity?> login(
    UserLoginRequest request,
    BuildContext context,
  ) async {
    //
    if (request.identifyValue != null) {
      request.identifyValue = await EncryptUtils.encrypt(
        request.identifyValue!,
      );
    }

    // 拦截器已经统一处理了所有异常
    UserLoginResponse? response = await AuthApi().login(request);

    //1.存储 token
    if (response != null) {
      await _doAfterLogin(response, context);
    }
    return null;
  }

  Future<UserEntity> _doAfterLogin(
    UserLoginResponse response,
    BuildContext context,
  ) async {
    final userProvider = context.read<UserProvider>();
    await SecureStorageManager().write(StorageKey.token, response.token ?? '');
    UserEntity userEntity = UserEntity.fromJson(
      jsonDecode(jsonEncode(response.toJson())),
    );
    //2.存储用户信息
    await SecureStorageManager().write(
      StorageKey.userInfo,
      jsonEncode(userEntity.toJson()),
    );
    await userProvider.refresh();
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
    afterLogout();
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
}
