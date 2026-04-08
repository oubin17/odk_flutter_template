import 'package:dio/dio.dart';

/// 应用层统一异常类型
enum AppExceptionType {
  network, // 网络错误
  server, // 服务器业务错误
  parse, // 数据解析错误
  timeout, // 超时
  cancel, // 取消请求
  unknown, // 未知错误
}

/// 应用统一异常类
class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
  });

  /// 从 DioException 创建 AppException
  factory AppException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.timeout,
          message: '请求超时',
          originalError: exception,
        );
      case DioExceptionType.badResponse:
        // HTTP 状态码错误
        final statusCode = exception.response?.statusCode;
        return AppException(
          type: AppExceptionType.network,
          message: '网络错误：$statusCode',
          code: statusCode?.toString(),
          originalError: exception,
        );
      case DioExceptionType.cancel:
        return AppException(
          type: AppExceptionType.cancel,
          message: '请求已取消',
          originalError: exception,
        );
      default:
        return AppException(
          type: AppExceptionType.network,
          message: exception.message ?? '网络错误',
          originalError: exception,
        );
    }
  }

  @override
  String toString() => 'AppException(${type.name}): $message (code: $code)';
}
