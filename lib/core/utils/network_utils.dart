import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 网络状态工具类
class NetworkUtil {
  // 单例模式
  NetworkUtil._internal();
  static final NetworkUtil instance = NetworkUtil._internal();

  final Connectivity _connectivity = Connectivity();

  // 网络状态枚举
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  /// 初始化网络监听（全局只调用一次）
  Future<void> initNetworkListen() async {
    // 首次获取网络状态
    await _checkNetworkStatus();

    // 监听网络变化
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateNetworkStatus(results);
    });
  }

  /// 检查当前网络状态
  Future<bool> checkNetwork() async {
    final result = await _connectivity.checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return result != ConnectivityResult.none;
  }

  /// 内部更新网络状态
  Future<void> _checkNetworkStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateNetworkStatus([result.first]);
  }

  /// 处理网络变化
  void _updateNetworkStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      _isConnected = false;
      // 无网络：弹出提示（用你项目已有的SmartDialog）
      AppToast.showToast('当前无网络连接，请检查网络设置');
      Log.w('网络状态：断开连接');
    } else {
      _isConnected = true;
      AppToast.showToast('网络连接恢复');
      Log.i('网络状态：已连接 (${results.first})');
    }
  }
}
