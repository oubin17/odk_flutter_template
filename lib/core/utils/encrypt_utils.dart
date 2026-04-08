import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

/// 加密工具类
class EncryptUtils {
  static String? _publicKey;

  /// 初始化，加载公钥
  static Future<void> init() async {
    if (_publicKey != null) return;
    _publicKey = await rootBundle.loadString(
      'lib/core/config/keys/public_key.pem',
    );
  }

  /// 使用 RSA 公钥对文本进行加密
  /// [plainText] 待加密的明文
  /// 返回加密后的 Base64 密文
  static Future<String> encrypt(String plainText) async {
    await init();

    if (_publicKey == null) {
      throw Exception('公钥加载失败');
    }

    final parser = RSAKeyParser();
    final publicKey = parser.parse(_publicKey!) as RSAPublicKey;

    final encrypter = Encrypter(RSA(publicKey: publicKey));
    return encrypter.encrypt(plainText).base64;
  }
}
