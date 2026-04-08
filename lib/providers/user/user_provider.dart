import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';

class UserProvider extends ChangeNotifier {
  UserEntity? _userEntity;

  String? _token;
  UserEntity? get userEntity => _userEntity;
  String? get token => _token;

  // 刷新：从存储读取数据（启动、登录、登出后调用）
  Future<void> refresh() async {
    _token = await SecureStorageManager().read(StorageKey.token);
    try {
      final String? userInfo = await SecureStorageManager().read(
        StorageKey.userInfo,
      );
      _userEntity = userInfo != null && userInfo.isNotEmpty
          ? UserEntity.fromJson(jsonDecode(userInfo))
          : null;
    } catch (e) {
      Log.e('读取用户信息失败: $e');
      _userEntity = null;
    }
    notifyListeners();
  }

  // 👇 新增：登出专用（快速清空状态，无需读存储）
  Future<void> clearUser() async {
    _userEntity = null;
    _token = null;
    notifyListeners();
  }
}
