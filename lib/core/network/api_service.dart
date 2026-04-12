import 'package:dio/dio.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/exceptions/app_exception.dart';
import 'package:odk_flutter_template/core/network/interceptors/request_response_interceptor.dart';
import 'package:odk_flutter_template/core/network/check/network_utils.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class ApiService {
  // 单例实例
  static ApiService? _instance;

  final Dio _dio;

  // 公共请求头
  static Map<String, dynamic> commonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-TENANT-ID': Env.tenantId,
    // 可以在这里添加其他公共请求头，例如：
    // 'Platform': 'mobile',
    // 'Version': '1.0.0',
  };

  // 获取单例实例的方法
  static ApiService get instance {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  // 私有构造函数
  ApiService._internal({String? baseUrl, Map<String, dynamic>? customHeaders})
    : _dio = Dio(
        BaseOptions(
          // 默认使用 BaseConstants.baseUrl，也可以自定义
          baseUrl: baseUrl ?? Env.serverUri,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          // 自动合并公共请求头和自定义请求头
          headers: {
            ...commonHeaders,
            if (customHeaders != null) ...customHeaders,
          },
        ),
      ) {
    // 注意：Dio 的 onResponse/onError 是逆序执行的。
    _dio.interceptors.add(RequestResponseInterceptor());
  }

  // 保留公开构造函数用于测试或特殊场景
  factory ApiService({String? baseUrl, Map<String, dynamic>? customHeaders}) {
    return ApiService._internal(baseUrl: baseUrl, customHeaders: customHeaders);
  }

  /// GET 请求
  /// 支持添加查询参数
  Future<ServiceResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final hasNetwork = await NetworkCheck.instance.checkNetwork();
    if (!hasNetwork) {
      // AppToast.showNotify('无网络连接', NotifyType.warning);
      return ServiceResponse.networkError();
    }
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ServiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _unwrapException(e);
    }
  }

  /// POST 请求
  /// 支持添加请求体数据
  Future<ServiceResponse> post(String path, dynamic data) async {
    try {
      final hasNetwork = await NetworkCheck.instance.checkNetwork();
      if (!hasNetwork) {
        // AppToast.showNotify('无网络连接', NotifyType.warning);
        return ServiceResponse.networkError();
      }
      final response = await _dio.post(path, data: data);
      return ServiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _unwrapException(e);
    }
  }

  /// PUT 请求
  /// 支持添加请求体数据
  Future<ServiceResponse> put(String path, dynamic data) async {
    try {
      final hasNetwork = await NetworkCheck.instance.checkNetwork();
      if (!hasNetwork) {
        // AppToast.showNotify('无网络连接', NotifyType.warning);
        return ServiceResponse.networkError();
      }
      final response = await _dio.put(path, data: data);
      return ServiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _unwrapException(e);
    }
  }

  /// DELETE 请求
  /// 支持添加路径
  Future<ServiceResponse> delete(String path) async {
    try {
      final hasNetwork = await NetworkCheck.instance.checkNetwork();
      if (!hasNetwork) {
        // AppToast.showNotify('无网络连接', NotifyType.warning);
        return ServiceResponse.networkError();
      }
      final response = await _dio.delete(path);
      return ServiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _unwrapException(e);
    }
  }

  Future<ServiceResponse> postWithQueryParameters(
    String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  ) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return ServiceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _unwrapException(e);
    }
  }

  /// 统一解包异常
  /// 如果 DioException 的 error 是 AppException，则直接抛出 AppException
  Exception _unwrapException(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return e;
  }
}
