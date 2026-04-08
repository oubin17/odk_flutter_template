import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BasicToast {
  static Future<bool?> show(String msg) async {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT, // 短提示
      gravity: ToastGravity.CENTER, // 居中显示
      timeInSecForIosWeb: 1, // iOS/Web 显示时长
      backgroundColor: Colors.black54, // 背景色
      textColor: Colors.white, // 文字颜色
      fontSize: 16.0, // 字体大小
    );
  }
}
