import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 网络状态工具类
class NetworkCheck {
  // 单例模式
  NetworkCheck._internal();
  static final NetworkCheck instance = NetworkCheck._internal();

  final Connectivity _connectivity = Connectivity();

  // 网络状态枚举
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // 🔥 新增：初始化标记，避免启动时误触弹窗
  bool _isInitializing = true;

  /// 初始化网络监听（全局只调用一次）
  Future<void> initNetworkListen() async {
    // 首次获取网络状态
    await _checkNetworkStatus();

    // 初始化完成，允许后续弹窗
    _isInitializing = false;

    // 监听网络变化
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateNetworkStatus(results);
    });
  }

  /// 检查当前网络状态（供接口请求前调用，无弹窗）
  Future<bool> checkNetwork() async {
    final List<ConnectivityResult> result = await _connectivity
        .checkConnectivity();
    return result[0] != ConnectivityResult.none;
  }

  /// 内部更新网络状态
  Future<void> _checkNetworkStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateNetworkStatus([result.first]);
  }

  /// 处理网络变化
  void _updateNetworkStatus(List<ConnectivityResult> results) {
    final hasNetwork = !results.contains(ConnectivityResult.none);

    // 状态没变化，不处理
    if (_isConnected == hasNetwork) return;

    // 更新状态
    _isConnected = hasNetwork;

    // 🔥 核心：初始化期间，不弹出Toast（解决调试重启弹窗问题）
    if (_isInitializing) {
      Log.i('网络初始化状态：${_isConnected ? "已连接" : "未连接"}');
      return;
    }

    // 正常状态变化：弹出提示
    if (_isConnected) {
      AppToast.showToast('网络连接恢复', gravity: ToastGravity.TOP);
      Log.i('网络状态：已连接 (${results.first})');
    } else {
      AppToast.showToast('当前无网络连接，请检查网络设置', gravity: ToastGravity.TOP);
      Log.w('网络状态：断开连接');
    }
  }
}
