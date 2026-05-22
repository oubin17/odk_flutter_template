import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/routes/app_router.dart';

enum LocaleType { en, zh }

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == LocaleType.en.name;
  bool get isChinese => _locale.languageCode == LocaleType.zh.name;

  LocaleProvider() {
    _getSavedLocale();
    notifyListeners();
  }

  // 初始化时读取保存的语言
  Future<Locale> _getSavedLocale() async {
    final languageCode =
        StorageManager().getString(StorageKey.languageCode) ??
        LocaleType.en.name;
    _locale = Locale(languageCode);
    return _locale;
  }

  // 切换语言时保存
  void changeLanguage(Locale newLocale) async {
    StorageManager().setString(StorageKey.languageCode, newLocale.languageCode);
    _locale = newLocale;
    notifyListeners(); // 触发 MaterialApp 重建
    // ...其他切换逻辑

    // 强制更新缓存
    // L10nUtils.update();
  }
}
