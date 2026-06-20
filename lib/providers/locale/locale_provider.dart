import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';

enum LocaleType { en, zh }

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == LocaleType.en.name;
  bool get isChinese => _locale.languageCode == LocaleType.zh.name;

  LocaleProvider() {
    _initLocale();
  }

  /// 初始化语言设置
  /// 优先级：用户已设置的语言 > 系统语言（中/英）
  Future<void> _initLocale() async {
    final savedLanguageCode = StorageManager().getString(
      StorageKey.languageCode,
    );

    if (savedLanguageCode != null) {
      // 用户已设置过语言，直接使用保存的值
      _locale = Locale(savedLanguageCode);
    } else {
      // 用户未设置过，检测系统语言
      _locale = _getSystemLocale();
    }
    notifyListeners();
  }

  /// 获取系统语言
  /// 如果系统语言是中文（zh），使用中文；否则默认英文
  Locale _getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // 检查系统语言是否包含中文
    if (systemLocale.languageCode == LocaleType.zh.name) {
      return const Locale('zh');
    }

    // 其他情况默认英文
    return const Locale('en');
  }

  /// 切换语言时保存
  void changeLanguage(Locale newLocale) async {
    StorageManager().setString(StorageKey.languageCode, newLocale.languageCode);
    _locale = newLocale;
    notifyListeners();
  }
}
