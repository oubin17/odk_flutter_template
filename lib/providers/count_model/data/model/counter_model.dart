import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {
  // 1. 私有状态
  int _count = 0;

  // 2. 对外暴露只读的状态值
  int get count => _count;

  // 3. 封装修改状态的方法
  void increment() {
    _count++;
    // 状态变更后，通知所有监听者重建 UI
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
