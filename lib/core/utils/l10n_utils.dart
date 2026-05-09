import 'package:flutter/widgets.dart';
import 'package:odk_flutter_template/l10n/app_localizations.dart';

/// 国际化静态工具类（🔥 全局静态调用，无需context）
class L10nUtils {
  static AppLocalizations? _localizations;

  /// 初始化（在 MaterialApp builder 中调用一次）
  static void init(BuildContext context) {
    _localizations = AppLocalizations.of(context);
  }

  /// ====================== 静态调用所有文本 ======================
  ///
  static String get confirm => _localizations!.confirm;
  static String get cancel => _localizations!.cancel;
  static String get save => _localizations!.save;
  static String get success => _localizations!.success;
  static String get failed => _localizations!.fail;
  static String get error => _localizations!.error;

  /// 自动生成，直接复制你的ARB键名即可
  static String get appTitle => _localizations!.appTitle;
  // static String get welcomeMessage => _localizations!.welcomeMessage;
  static String get switchLanguage => _localizations!.switchLanguage;
  static String get language => _localizations!.language;

  // static String get unreadMessages => _localizations!.unreadMessages;

  // 👇 把你所有翻译文本都按这个格式加进来（你之前的主题/个人中心文本）
  static String get systemSetting => _localizations!.systemSetting;

  static String get themeMode => _localizations!.themeMode;
  static String get lightMode => _localizations!.lightMode;
  static String get darkMode => _localizations!.darkMode;
  static String get aboutUs => _localizations!.aboutUs;
  static String get deviceInfo => _localizations!.deviceInfo;
  static String get versionInfo => _localizations!.versionInfo;
  static String get logout => _localizations!.logout;

  static String get home => _localizations!.home;
  static String get mine => _localizations!.mine;
  static String get profile => _localizations!.profile;
  static String get avatar => _localizations!.avatar;
  static String get nickname => _localizations!.nickname;
  static String get gender => _localizations!.gender;
  static String get male => _localizations!.male;
  static String get female => _localizations!.female;
  static String get birthday => _localizations!.birthday;
  static String get phoneNumber => _localizations!.phoneNumber;
  static String get todo => _localizations!.todo;

  // 错误提示
  /// 新增：表单校验（不能为空，带字段名参数）
  static String fieldNotEmptyTip(String field) =>
      _localizations!.fieldNotEmptyTip(field);

  /// 新增：表单校验（格式错误，带字段名参数）
  static String fieldFormatErrorTip(String field) =>
      _localizations!.fieldFormatErrorTip(field);
}
