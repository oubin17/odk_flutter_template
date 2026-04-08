import 'package:flutter/foundation.dart';

/// 日志打印工具类
class Log {
  // 日志前缀
  static const String _tag = 'LushiApp';

  /// 调试日志 (Debug)
  static void d(String message, {String? tag}) {
    _printLog(message, level: 'DEBUG', tag: tag);
  }

  /// 信息日志 (Info)
  static void i(String message, {String? tag}) {
    _printLog(message, level: 'INFO', tag: tag);
  }

  /// 警告日志 (Warning)
  static void w(String message, {String? tag}) {
    _printLog(message, level: 'WARN', tag: tag);
  }

  /// 错误日志 (Error)
  static void e(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final fullTag = tag != null ? '[$tag]' : '[$_tag]';
      print('❌ $fullTag [ERROR] $message');
      if (error != null) print('   Error: $error');
      if (stackTrace != null) print('   StackTrace: \n$stackTrace');
    }

    // 正式环境下可以上报到 Sentry 或 Firebase Crashlytics
    if (!kDebugMode && error != null) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  /// 内部统一打印逻辑
  static void _printLog(String message, {required String level, String? tag}) {
    if (kDebugMode) {
      final fullTag = tag != null ? '[$tag]' : '[$_tag]';
      final emoji = _getEmoji(level);
      // 使用 print 保证控制台可见，或使用 developer.log 以支持 DevTools
      print('$emoji $fullTag [$level] $message');
    }
  }

  static String _getEmoji(String level) {
    switch (level) {
      case 'DEBUG':
        return '🐛';
      case 'INFO':
        return 'ℹ️';
      case 'WARN':
        return '⚠️';
      case 'ERROR':
        return '❌';
      default:
        return '📝';
    }
  }
}
