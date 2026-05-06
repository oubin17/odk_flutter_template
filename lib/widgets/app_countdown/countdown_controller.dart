import 'dart:async';
import 'package:flutter/material.dart';

/// 通用验证码倒计时控制器（全项目复用）
class CountdownController extends ChangeNotifier {
  // 倒计时总时长（默认60秒）
  final int totalSeconds;

  CountdownController({this.totalSeconds = 60});

  bool _isCounting = false;
  int _countDown = 60;
  Timer? _timer;

  bool get isCounting => _isCounting;
  int get countDown => _countDown;

  /// 开始倒计时
  void start() {
    if (_isCounting) return;

    _isCounting = true;
    _countDown = totalSeconds;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDown > 1) {
        _countDown--;
        notifyListeners();
      } else {
        reset();
      }
    });
  }

  /// 重置倒计时
  void reset() {
    _isCounting = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  /// 销毁资源
  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
