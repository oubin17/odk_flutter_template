import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';

class RequestResponseInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ====================== 核心修改 ======================
    // 1. 通过全局路由Key获取上下文
    final globalContext = AppRouter.routerKey.currentContext;
    String? token;

    // 2. 从 UserProvider 中读取 Token（内存读取，无需异步await）
    if (globalContext != null) {
      token = globalContext.read<UserProvider>().token;
    }
    // ======================================================

    // 3. 注入请求头（逻辑不变）
    if (token != null && token.isNotEmpty) {
      options.headers[Env.tokenHeader] = token;
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.i(
      '${response.statusCode} ${response.requestOptions.uri} ${response.data}',
      tag: 'Network-RES',
    );

    if (response.statusCode != 200) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data,
          message: response.data['errorContext'] ?? '业务请求失败',
        ),
      );
    }

    final data = response.data;
    if (data is Map<String, dynamic> && data['success'] == false) {
      Log.w('业务逻辑失败: $data', tag: 'Network-ERR');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('捕获异常', tag: 'Network-ERR', error: err.message);

    // ====================== 核心修复：统一处理所有异常，不往外抛 ======================
    String errorMsg = '请求失败';
    // 1. 分类处理 Dio 异常类型（超时/无网/服务器错误）
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMsg = '网络请求超时，请重试';
        break;
      case DioExceptionType.connectionError:
        errorMsg = '网络连接异常，请检查网络';
        break;
      case DioExceptionType.badResponse:
        errorMsg = '服务器异常(${err.response?.statusCode})';
        break;
      default:
        errorMsg = '网络请求失败，请重试';
    }

    // 统一吐司提示（必加，避免页面无感知）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // AppToast.showToast(errorMsg, alignment: Alignment.topCenter);
      AppToast.showToast2(errorMsg);
    });

    // ====================== 原有逻辑：token 过期处理 ======================
    final responseData = err.response?.data;
    if (responseData is Map<String, dynamic>) {
      final dataMap = responseData;
      List<String> tokenExpiredCodes = ['020', '021', '022'];
      final errorCode = dataMap['errorCode'];
      if (tokenExpiredCodes.contains(errorCode)) {
        AuthService().afterLogout();
        // AppToast.showToast('登录已过期，请重新登录');
        final globalContext = AppRouter.routerKey.currentContext;
        if (globalContext != null) {
          globalContext.read<UserProvider>().clearUser();
        }
        NavigatorUtils.goNamed(RouteNames.signin);
      }
    }

    // ====================== 关键：不执行 handler.next(err)！异常到此为止 ======================
    // 直接把异常标记为处理完成，Dio 不会再把异常抛给 post 方法
    handler.resolve(
      Response(
        requestOptions: err.requestOptions,
        statusCode: 999, // 自定义异常码
        data: ServiceResponse.commonError().toJson(),
      ),
    );
  }
}
