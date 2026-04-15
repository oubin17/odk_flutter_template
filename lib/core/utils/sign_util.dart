import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:odk_flutter_template/common/app_info/global_info.dart';

import 'package:odk_flutter_template/config/env.dart';

class SignUtils {
  // 🔥 直接从环境配置获取密钥，无需存储！
  static String get _signSecret => Env.signSecret;

  // ====================== 生成签名（核心，无修改） ======================
  static Future<String> generateSign({
    required String signToken,
    required int timestamp,
    required String nonce,
  }) async {
    // 拼接字符串
    String signStr =
        'timestamp=$timestamp&nonce=$nonce&token=$signToken&secret=$_signSecret';

    // MD5 大写
    return md5.convert(utf8.encode(signStr)).toString().toUpperCase();
  }

  // 生成随机字符串
  // ====================== 🔥 替换这里：绝对唯一 nonce ======================
  static String generateNonce([int length = 8]) {
    // 1. 时间戳（精确到毫秒）
    String timePart = DateTime.now().millisecondsSinceEpoch.toString();
    // 2. 设备唯一ID（截取后8位）
    String devicePart = GlobalInfo.instance.deviceId.substring(
      GlobalInfo.instance.deviceId.length - 8,
    );
    // 3. 短随机数（8位）
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String randomPart = List.generate(
      length,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();

    // 组合 = 时间戳 + 设备ID + 随机数 → 绝对唯一
    return '${timePart}_${devicePart}_$randomPart';
  }
}
