import 'package:flutter/foundation.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Bugly 崩溃监控服务
///
/// 功能：
/// - 初始化 Bugly SDK（Android/iOS）
/// - 自动捕获 Dart 层异常并上报
/// - 自动捕获 Flutter UI 异常并上报
/// - 支持设置用户标识、自定义数据
/// - 支持手动上报异常
///
/// 使用方式：
/// - 在 AppInitializer.init() 中调用 BuglyService.instance.init()（需在 FlavorConfig 之后）
/// - 登录后调用 BuglyService.instance.setUserId() 设置用户标识
/// - 手动上报异常调用 BuglyService.instance.reportException()
class BuglyService {
  BuglyService._internal();
  static final BuglyService instance = BuglyService._internal();

  bool _initialized = false;

  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 初始化 Bugly
  ///
  /// 必须在 WidgetsFlutterBinding.ensureInitialized() 之后调用
  /// 必须在 FlavorConfig 配置完成之后调用（依赖 Env 读取 appId）
  Future<void> init() async {
    if (_initialized) return;

    try {
      // 检查 appId 是否已配置
      final androidAppId = Env.buglyAndroidAppId;
      final iosAppId = Env.buglyIOSAppId;

      if (androidAppId.isEmpty && iosAppId.isEmpty) {
        Log.w(
          '⚠️ Bugly 初始化跳过: Android 和 iOS appId 均为空，请先在 env.dart 中配置 appId',
          tag: 'BuglyService',
        );
        return;
      }

      if (androidAppId.startsWith('YOUR_') || iosAppId.startsWith('YOUR_')) {
        Log.w(
          '⚠️ Bugly 初始化跳过: appId 仍为占位符，请替换为在 Bugly 注册的真实 appId',
          tag: 'BuglyService',
        );
        return;
      }

      // 获取应用版本信息
      final packageInfo = await PackageInfo.fromPlatform();

      final result = await FlutterBugly.init(
        androidAppId: androidAppId.isNotEmpty ? androidAppId : null,
        iOSAppId: iosAppId.isNotEmpty ? iosAppId : null,
        channel: Env.buglyChannel.isNotEmpty ? Env.buglyChannel : null,
        appVersion: packageInfo.version,
        // 开发模式开启SDK日志，生产模式关闭
        debugMode: kDebugMode,
        // Android 专属配置
        enableCatchAnrTrace: true, // ANR 时获取系统 trace 文件
        enableRecordAnrMainStack: true, // 获取 ANR 主线程堆栈
        isBuglyLogUpload: true, // 上传自定义日志
        // iOS 专属配置
        blockMonitorTimeout: 3, // 卡顿阈值（秒）
        unexpectedTerminatingDetectionEnable: true, // 非正常退出检测
        enableBlockMonitor: true, // 卡顿监控
      );

      _initialized = true;

      if (result.isSuccess) {
        Log.i('🐛 Bugly 初始化成功, appId: ${result.appId}', tag: 'BuglyService');
      } else {
        Log.w('⚠️ Bugly 初始化失败: ${result.message}', tag: 'BuglyService');
      }
    } catch (e, stack) {
      Log.e('❌ Bugly 初始化异常', error: e, stackTrace: stack, tag: 'BuglyService');
    }
  }

  /// 设置用户标识
  ///
  /// 建议在用户登录成功后调用，便于在 Bugly 后台按用户筛选崩溃
  Future<void> setUserId(String userId) async {
    if (!_initialized) return;
    try {
      await FlutterBugly.setUserId(userId);
      Log.d('🐛 Bugly 设置用户标识: $userId', tag: 'BuglyService');
    } catch (e) {
      Log.e('❌ Bugly 设置用户标识失败', error: e, tag: 'BuglyService');
    }
  }

  /// 设置标签
  ///
  /// [userSceneTag] 标签 ID，可在 Bugly 网站生成
  Future<void> setUserTag(int userSceneTag) async {
    if (!_initialized) return;
    try {
      await FlutterBugly.setUserTag(userSceneTag);
    } catch (e) {
      Log.e('❌ Bugly 设置标签失败', error: e, tag: 'BuglyService');
    }
  }

  /// 设置关键数据，随崩溃信息上报
  ///
  /// 最多支持 9 组自定义 Key-Value
  Future<void> putUserData({required String key, required String value}) async {
    if (!_initialized) return;
    try {
      await FlutterBugly.putUserData(key: key, value: value);
    } catch (e) {
      Log.e('❌ Bugly 设置自定义数据失败', error: e, tag: 'BuglyService');
    }
  }

  /// 手动上报异常
  ///
  /// 适用于 try-catch 捕获的业务异常，需要手动上报的场景
  Future<void> reportException({
    required String message,
    required String detail,
    String? type,
    Map? data,
  }) async {
    if (!_initialized) return;
    try {
      await FlutterBugly.uploadException(
        message: message,
        detail: detail,
        type: type,
        data: data,
      );
      Log.d('🐛 Bugly 手动上报异常: $message', tag: 'BuglyService');
    } catch (e) {
      Log.e('❌ Bugly 手动上报异常失败', error: e, tag: 'BuglyService');
    }
  }

  /// 记录自定义日志到 Bugly
  ///
  /// 崩溃时会随崩溃信息一起上报
  Future<void> log({required String tag, required String message}) async {
    if (!_initialized) return;
    try {
      await FlutterBugly.log(tag: tag, message: message);
    } catch (e) {
      // 日志记录失败不影响业务
    }
  }

  /// 设置异常捕获处理器
  ///
  /// 替代 FlutterBugly.postCatchedException，避免 Zone mismatch 问题。
  /// 通过手动设置 FlutterError.onError 和 PlatformDispatcher.instance.onError
  /// 来捕获 Flutter UI 异常和 Dart 异常并上报到 Bugly。
  ///
  /// 必须在 BuglyService.init() 之后、runApp 之前调用
  void setupExceptionHandler() {
    // 捕获 Flutter UI 异常（如渲染异常、布局溢出等）
    FlutterError.onError = (FlutterErrorDetails details) {
      // 保留默认行为：在控制台打印异常
      FlutterError.presentError(details);

      // 本地日志打印
      Log.e(
        '🔥 Bugly 捕获 Flutter 异常',
        error: details.exception,
        stackTrace: details.stack,
        tag: 'BuglyService',
      );

      // 上报到 Bugly
      if (_initialized) {
        FlutterBugly.uploadException(
          message: details.exceptionAsString(),
          detail: details.stack.toString(),
        );
      }
    };

    // 捕获 Dart 异常（如异步异常、未处理的 Future 异常等）
    PlatformDispatcher.instance.onError = (error, stack) {
      // 本地日志打印
      Log.e(
        '🔥 Bugly 捕获 Dart 异常',
        error: error,
        stackTrace: stack,
        tag: 'BuglyService',
      );

      // 上报到 Bugly
      if (_initialized) {
        FlutterBugly.uploadException(
          message: error.toString(),
          detail: stack.toString(),
        );
      }

      // 返回 true 表示已处理该异常
      return true;
    };
  }
}
