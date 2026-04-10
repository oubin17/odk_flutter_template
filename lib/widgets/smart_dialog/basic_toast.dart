import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppToast {
  /// Show loading toast
  static void showLoading(String? loading) {
    SmartDialog.showToast(loading ?? "Loading...", alignment: Alignment.center);
  }

  /// Show toast
  static void showToast(String message) {
    SmartDialog.showToast(message, alignment: Alignment.center);
  }
}
