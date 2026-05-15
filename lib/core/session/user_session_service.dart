import 'dart:convert';

import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/features/basic_user/models/user_query/user_entity.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';

class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();

  UserSessionService._internal();

  factory UserSessionService() => _instance;

  UserProvider? _userProvider;

  void bindUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<void> syncUserSession(
    UserEntity userEntity, {
    String? token,
    bool updateToken = false,
  }) async {
    // final effectiveToken = token ?? userEntity.accessToken.tokenValue;

    if (updateToken) {
      await SecureStorageManager().write(StorageKey.token, token!);
    }

    await SecureStorageManager().write(
      StorageKey.userInfo,
      jsonEncode(userEntity.toJson()),
    );

    _userProvider?.setUser(userEntity, token: token, updateToken: updateToken);
  }

  Future<void> clearSession({bool clearAllStorage = false}) async {
    await SecureStorageManager().deleteAll();
    if (clearAllStorage) {
      await StorageManager().clear();
    }
    await _userProvider?.clearUser();
  }
}
