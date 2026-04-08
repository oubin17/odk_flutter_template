import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//    await StorageManager().setJson(StorageKey.userInfo, response.toJson());

//    // UserLoginResponse? user = StorageManager().getObject(
//   StorageKey.userInfo,
//   (json) => UserLoginResponse.fromJson(json),
// );

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();

  factory StorageManager() => _instance;

  StorageManager._internal();

  static SharedPreferences? _prefs;

  /// 初始化 (必须在 main() 函数中调用)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 保存字符串
  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// 获取字符串
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// 保存整数
  Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  /// 获取整数
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// 保存布尔值
  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  /// 获取布尔值
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// 保存对象 (将 Map/List 转为 JSON 字符串存储)
  Future<bool> setJson(String key, dynamic value) async {
    final jsonString = jsonEncode(value);
    return await _prefs?.setString(key, jsonString) ?? false;
  }

  /// 获取对象 (将 JSON 字符串转为 Map)
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// 获取对象 (将 JSON 字符串转为自定义对象)
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJsonFunc) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;

    final Map<String, dynamic> map =
        jsonDecode(jsonString) as Map<String, dynamic>;

    // 调用传入的转换函数
    return fromJsonFunc(map);
  }

  /// 删除指定 key
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  /// 清空所有数据
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}
