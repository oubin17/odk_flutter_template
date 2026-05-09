// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get success => '成功';

  @override
  String get fail => '失败';

  @override
  String get error => '错误';

  @override
  String get systemSetting => '设置';

  @override
  String get themeMode => '主题模式';

  @override
  String get lightMode => '日间模式';

  @override
  String get darkMode => '夜间模式';

  @override
  String get switchLanguage => '语言';

  @override
  String get language => '中文';

  @override
  String get aboutUs => '关于我们';

  @override
  String get deviceInfo => '设备信息';

  @override
  String get versionInfo => '版本信息';

  @override
  String get logout => '登出';

  @override
  String get home => '首页';

  @override
  String get mine => '我的';

  @override
  String get profile => '用户画像';

  @override
  String get avatar => '头像';

  @override
  String get nickname => '昵称';

  @override
  String get gender => '性别';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get birthday => '生日';

  @override
  String get phoneNumber => '手机号';

  @override
  String get todo => '待实现...';

  @override
  String get appTitle => 'Flutter Internationalization Demo';

  @override
  String welcomeMessage(String userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get english => 'English';

  @override
  String unreadMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread messages',
      one: '1 unread message',
      zero: 'No unread messages',
    );
    return '$_temp0';
  }

  @override
  String fieldNotEmptyTip(String field) {
    return '$field不能为空';
  }

  @override
  String fieldFormatErrorTip(String field) {
    return '$field格式不正确';
  }
}
