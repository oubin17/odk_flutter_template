import 'package:dio/dio.dart';
import 'package:odk_flutter_template/common/app_info/global_info.dart';
import 'package:odk_flutter_template/config/env.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/core/utils/sign_util.dart';

class SignInterceptor extends InterceptorsWrapper {
  SignInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. 生成全局唯一参数（仅生成一次，保证签名和请求头一致）
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final String nonce = SignUtils.generateNonce();
    final String signToken;
    if (options.headers[Env.tokenHeader] != null) {
      signToken = options.headers[Env.tokenHeader];
    } else {
      options.headers[Env.tokenHeader] = GlobalInfo.instance.deviceId;
      signToken = GlobalInfo.instance.deviceId;
    }

    // 5. 生成签名（核心逻辑）
    final String sign = await SignUtils.generateSign(
      signToken: signToken,
      timestamp: timestamp,
      nonce: nonce,
    );

    // ====================== 组装请求头（全部非空，符合HTTP规范） ======================
    // 签名校验头
    options.headers['sign'] = sign;
    options.headers['timestamp'] = timestamp;
    options.headers['nonce'] = nonce;

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

    // 继续执行请求
    handler.next(options);
  }
}
