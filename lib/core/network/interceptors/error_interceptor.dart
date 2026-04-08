import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:odk_flutter_template/core/exceptions/app_exception.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';

/// 统一错误处理拦截器
class ErrorInterceptor extends InterceptorsWrapper {
  ErrorInterceptor() {
    Log.i('实例已成功创建并挂载', tag: 'ErrorInterceptor');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('成功捕获到上层抛出的异常！', tag: 'ErrorInterceptor', error: err.message);

    // 1. 转换为统一异常
    final appException = _handleException(err);

    // 2. 打印错误日志 (开发环境)
    if (kDebugMode) {
      _printError(appException, err);
    }

    // 3. 抛出转换后的异常，这样外部可以直接 catch (AppException e)
    Log.w(
      '正在抛出 AppException: ${appException.message}',
      tag: 'ErrorInterceptor',
    );
    throw appException;
  }

  /// 处理异常转换
  AppException _handleException(DioException err) {
    // 检查是否是业务逻辑错误 (从响应体中解析)
    if (err.response != null && err.response?.data != null) {
      final data = err.response!.data;

      // 如果是 Map 类型，检查是否有业务错误信息
      if (data is Map<String, dynamic>) {
        final errorContext = data['errorContext'] as String?;
        if (errorContext != null && errorContext.isNotEmpty) {
          return AppException(
            type: AppExceptionType.server,
            message: errorContext,
            code: data['errorCode'] as String?,
          );
        }
      }
    }

    // 否则使用默认的 Dio 异常转换
    return AppException.fromDioException(err);
  }

  /// 打印错误日志
  void _printError(AppException appException, DioException original) {
    final buffer = StringBuffer();
    buffer.writeln('\n❌ [网络错误] ${appException.type.name}');
    buffer.writeln('   消息：${appException.message}');
    if (appException.code != null) {
      buffer.writeln('   代码：${appException.code}');
    }
    buffer.writeln('   URL: ${original.requestOptions.uri}');
    buffer.writeln('   方法：${original.requestOptions.method}');
    buffer.writeln('   原始错误：${original.message}');

    Log.e(buffer.toString(), tag: 'Network-ERR');
  }
}
