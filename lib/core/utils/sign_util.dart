import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

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
  static String generateNonce([int length = 16]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();
  }
}
