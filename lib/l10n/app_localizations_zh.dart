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
  String get appTitle => 'ODK Flutter 模板';

  @override
  String get account => '账户';

  @override
  String get general => '通用';

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
  String get commonSetting => '通用设置';

  @override
  String get accountSecurity => '账号安全';

  @override
  String get setPassword => '设置密码';

  @override
  String get resetPassword => '重置密码';

  @override
  String get operationFailed => '操作失败';

  @override
  String get pleaseEnterPassword => '请输入密码';

  @override
  String get newPassword => '新密码';

  @override
  String get pleaseEnterNewPassword => '请输入新密码';

  @override
  String get oldPassword => '旧密码';

  @override
  String get pleaseEnterOldPassword => '请输入旧密码';

  @override
  String get newPasswordCannotBeSameAsOld => '新密码不能与旧密码相同';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get pleaseEnterConfirmPassword => '请输入确认密码';

  @override
  String get passwordsNotMatch => '两次输入密码不一致';

  @override
  String fieldNotEmptyTip(String field) {
    return '$field不能为空';
  }

  @override
  String fieldFormatErrorTip(String field) {
    return '$field格式不正确';
  }
}
