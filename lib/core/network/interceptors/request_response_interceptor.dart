import 'package:dio/dio.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/network/check/network_utils.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
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
    // ====================== 在 async gap 之前获取 Token ======================
    // 避免在 await 之后使用 BuildContext（lint: don't use BuildContext across async gaps）
    final globalContext = AppRouter.routerKey.currentContext;
    String? token;
    if (globalContext != null) {
      token = globalContext.read<UserProvider>().token;
    }

    // ====================== 网络检查：无网络时直接拦截，不发出请求 ======================
    final hasNetwork = await NetworkCheck.instance.checkNetwork();
    if (!hasNetwork) {
      AppToast.showToast(L10nUtils.noNetworkConnection);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 999,
          data: ServiceResponse.networkError().toJson(),
        ),
      );
      return;
    }

    // ====================== 注入请求头 ======================
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
          message: response.data['errorContext'] ?? L10nUtils.operationFailed,
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
    // 注意：无网络的情况已在 onRequest 中通过 NetworkCheck 拦截，这里不会收到 connectionError
    String errorMsg = L10nUtils.requestError;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMsg = L10nUtils.networkTimeout;
        break;
      default:
        errorMsg = L10nUtils.requestError;
    }

    // 统一吐司提示（必加，避免页面无感知）
    AppToast.showToast(errorMsg);

    // ====================== 原有逻辑：token 过期处理 ======================
    final responseData = err.response?.data;
    if (responseData is Map<String, dynamic>) {
      final dataMap = responseData;
      List<String> tokenExpiredCodes = ['020', '021', '022'];
      final errorCode = dataMap['errorCode'];
      if (tokenExpiredCodes.contains(errorCode)) {
        AuthService().afterLogout();
        NavigatorUtils.goNamed(RouteNames.signin);
      }
    }

    // ====================== 关键：不执行 handler.next(err)！异常到此为止 ======================
    // 直接把异常标记为处理完成，Dio 不会再把异常抛给 post 方法
    final safeData = responseData is Map<String, dynamic>
        ? responseData
        : <String, dynamic>{};

    handler.resolve(
      Response(
        requestOptions: err.requestOptions,
        statusCode: 999, // 自定义异常码
        data: ServiceResponse.bizError(
          safeData['errorType'],
          safeData['errorCode'],
          safeData['errorContext'],
        ).toJson(),
      ),
    );
  }
}
