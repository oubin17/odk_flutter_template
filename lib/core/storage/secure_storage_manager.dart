import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final SecureStorageManager _instance =
      SecureStorageManager._internal();
  factory SecureStorageManager() => _instance;
  SecureStorageManager._internal();

  // ======================
  // ✅ Android 最优配置：持久化 + 不丢数据 + 全机型兼容
  // ======================
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: false, // 关闭有BUG的加密
    resetOnError: false,
  );

  // ======================
  // ✅ iOS 最优配置：系统Keychain + 永久不丢失
  // ======================
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.unlocked, // 仅手机解锁时可访问（最安全）
  );

  // 双平台初始化
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  // 保存字符串
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // 读取字符串
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // 删除
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // 清空
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // 读取对象（你的逻辑完全不变）
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJsonFunc,
  ) async {
    final jsonString = await read(key);
    if (jsonString == null) return null;
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJsonFunc(map);
  }
}
