import 'package:dio/dio.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/network/interceptors/request_response_interceptor.dart';
import 'package:odk_flutter_template/core/network/interceptors/sign_interceptor.dart';
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
          connectTimeout: Duration(seconds: Env.httpTimeout),
          receiveTimeout: Duration(seconds: Env.httpTimeout),
          // 自动合并公共请求头和自定义请求头
          headers: {
            ...commonHeaders,
            if (customHeaders != null) ...customHeaders,
          },
        ),
      ) {
    // 注意：Dio 的 onResponse/onError 是逆序执行的。
    _dio.interceptors.add(RequestResponseInterceptor());
    _dio.interceptors.add(SignInterceptor());
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
    final response = await _dio.get(path, queryParameters: queryParameters);
    return ServiceResponse.fromJson(response.data);
  }

  /// POST 请求
  /// 支持添加请求体数据
  Future<ServiceResponse> post(String path, dynamic data) async {
    final response = await _dio.post(path, data: data);
    return ServiceResponse.fromJson(response.data);
  }

  /// PUT 请求
  /// 支持添加请求体数据
  Future<ServiceResponse> put(String path, dynamic data) async {
    final response = await _dio.put(path, data: data);
    return ServiceResponse.fromJson(response.data);
  }

  /// DELETE 请求
  /// 支持添加路径
  Future<ServiceResponse> delete(String path) async {
    final response = await _dio.delete(path);
    return ServiceResponse.fromJson(response.data);
  }

  Future<ServiceResponse> postWithQueryParameters(
    String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  ) async {
    final response = await _dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
    );
    return ServiceResponse.fromJson(response.data);
  }
}
