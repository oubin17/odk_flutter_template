import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:odk_flutter_template/common/app_info/global_info.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
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

    // ======================
    // 🔥 新增：最优设备+App请求头（直接用全局缓存）
    // ======================
    options.headers['X-App-Version'] = GlobalInfo.instance.appVersion;
    options.headers['X-App-Build'] = GlobalInfo.instance.appBuild;
    options.headers['X-Device-ID'] = GlobalInfo.instance.deviceId;
    options.headers['X-OS-Type'] = GlobalInfo.instance.osType;
    options.headers['X-OS-Version'] = GlobalInfo.instance.osVersion;
    Log.i(
      '${options.method} ${options.uri} ${options.data} ${options.headers}',
      tag: 'Network-REQ',
    );
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
    Log.e('成功捕获到上层抛出的异常！', tag: 'ErrorInterceptor', error: err.message);

    // 🔥 修复1：空安全判断 + 安全强转（防止崩溃）
    final dynamic responseData = err.response?.data;
    if (responseData == null || responseData is! Map<String, dynamic>) {
      handler.next(err);
      return;
    }
    final Map<String, dynamic> dataMap = responseData;

    // 支持：status=404 / statusCode=404 两种格式
    final int? status = dataMap['status'] ?? err.response?.statusCode;
    if (status == 404) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppToast.showToast('请求异常');
      });
    }

    if (dataMap['success'] == false) {
      Log.w('业务逻辑失败: $dataMap', tag: 'Network-ERR');
      List<String> tokenExpiredCodes = ['020', '021', '022'];
      final errorCode = dataMap['errorCode'];

      if (tokenExpiredCodes.contains(errorCode)) {
        // 1. 清除本地存储
        AuthService().afterLogout();
        // ====================== 优化：联动清空Provider ======================
        // 清空用户状态，保证所有UI页面自动刷新（如个人卡片、导航栏等）
        final globalContext = AppRouter.routerKey.currentContext;
        if (globalContext != null) {
          globalContext.read<UserProvider>().clearUser();
        }
        // ======================================================

        // 2. 跳转欢迎页
        NavigatorUtils.goNamed(RouteNames.signin);
      }
    }
  }
}
