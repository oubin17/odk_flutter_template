import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:odk_flutter_template/config/env.dart';

/// ======================== 整合版 全局日志工具类 ========================
/// 融合：自定义Log风格 + logger核心能力
/// 功能：无乱码、无冗余栈、分级打印、环境控制、错误堆栈、Sentry上报预留
/// 调用方式：Log.d() / Log.i() / Log.w() / Log.e()
/// ====================================================================
class Log {
  // 全局默认TAG
  static final String _defaultTag = Env.serverName;

  // ====================== 核心 Logger 配置（无乱码、无冗余） ======================
  static final Logger _logger = Logger(
    // 环境过滤：开发打印所有，生产只打印重要日志
    filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    // 极简打印机：彻底解决 乱码、方框、调用栈、多余格式问题
    printer: SimplePrinter(
      printTime: false,
      colors: false, // 关闭颜色转义符 ✅ 解决奇怪字符
    ),
  );

  // ====================== 对外调用日志方法 ======================

  /// 调试日志（替代print）
  static void d(String message, {String? tag}) {
    if (!kDebugMode) return;
    _logger.d(_formatMessage('🐛', tag, 'DEBUG', message));
  }

  /// 信息日志
  static void i(String message, {String? tag}) {
    if (!kDebugMode) return;
    _logger.i(_formatMessage('ℹ️', tag, 'INFO', message));
  }

  /// 警告日志
  static void w(String message, {String? tag}) {
    if (!kDebugMode) return;
    _logger.w(_formatMessage('⚠️', tag, 'WARN', message));
  }

  /// 错误日志（支持错误对象 + 堆栈）
  static void e(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // 开发环境：打印完整错误+堆栈
    if (kDebugMode) {
      _logger.e(_formatMessage('❌', tag, 'ERROR', message));
      if (error != null) _logger.e('   错误信息 → $error');
      if (stackTrace != null) _logger.e('   堆栈信息 → \n$stackTrace');
    }

    // 生产环境：上报崩溃（Sentry/Firebase）
    if (!kDebugMode && error != null) {
      // 这里后续集成 Sentry 上报
      // Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  // ====================== 内部工具 ======================

  /// 统一格式化日志：emoji + [TAG] + [级别] + 信息
  static String _formatMessage(
    String emoji,
    String? tag,
    String level,
    String msg,
  ) {
    final currentTag = tag ?? _defaultTag;
    return '$emoji [$currentTag] [$level] $msg';
  }
}
