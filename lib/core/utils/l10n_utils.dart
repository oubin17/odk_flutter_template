import 'package:flutter/widgets.dart';
import 'package:odk_flutter_template/l10n/app_localizations.dart';

/// 国际化静态工具类（🔥 全局静态调用，无需context）
class L10nUtils {
  static AppLocalizations? _localizations;

  /// 初始化（在 MaterialApp builder 中调用一次）
  static void init(BuildContext context) {
    _localizations = AppLocalizations.of(context);
  }

  // ======================== 通用 ========================
  static String get confirm => _localizations!.confirm;
  static String get cancel => _localizations!.cancel;
  static String get save => _localizations!.save;
  static String get success => _localizations!.success;
  static String get failed => _localizations!.fail;
  static String get error => _localizations!.error;
  static String get todo => _localizations!.todo;
  static String get common => _localizations!.common;
  static String get login => _localizations!.login;
  static String get register => _localizations!.register;
  static String get operationFailed => _localizations!.operationFailed;

  // ======================== 应用全局 ========================
  static String get appTitle => _localizations!.appTitle;
  static String get home => _localizations!.home;
  static String get mine => _localizations!.mine;

  // ======================== 设置页 ========================
  static String get systemSetting => _localizations!.systemSetting;
  static String get commonSetting => _localizations!.commonSetting;
  static String get account => _localizations!.account;
  static String get general => _localizations!.general;
  static String get themeMode => _localizations!.themeMode;
  static String get lightMode => _localizations!.lightMode;
  static String get darkMode => _localizations!.darkMode;
  static String get switchLanguage => _localizations!.switchLanguage;
  static String get language => _localizations!.language;
  static String get aboutUs => _localizations!.aboutUs;
  static String get deviceInfo => _localizations!.deviceInfo;
  static String get versionInfo => _localizations!.versionInfo;
  static String get logout => _localizations!.logout;

  // ======================== 个人页 ========================
  static String get profile => _localizations!.profile;
  static String get avatar => _localizations!.avatar;
  static String get nickname => _localizations!.nickname;
  static String get gender => _localizations!.gender;
  static String get male => _localizations!.male;
  static String get female => _localizations!.female;
  static String get birthday => _localizations!.birthday;
  static String get phoneNumber => _localizations!.phoneNumber;

  // ======================== 账号安全 ========================
  static String get accountSecurity => _localizations!.accountSecurity;
  static String get setPassword => _localizations!.setPassword;
  static String get resetPassword => _localizations!.resetPassword;
  static String get resetPasswordShort => _localizations!.resetPasswordShort;
  static String get pleaseEnterPassword => _localizations!.pleaseEnterPassword;
  static String get newPassword => _localizations!.newPassword;
  static String get pleaseEnterNewPassword =>
      _localizations!.pleaseEnterNewPassword;
  static String get oldPassword => _localizations!.oldPassword;
  static String get pleaseEnterOldPassword =>
      _localizations!.pleaseEnterOldPassword;
  static String get newPasswordCannotBeSameAsOld =>
      _localizations!.newPasswordCannotBeSameAsOld;
  static String get confirmPassword => _localizations!.confirmPassword;
  static String get pleaseEnterConfirmPassword =>
      _localizations!.pleaseEnterConfirmPassword;
  static String get passwordsNotMatch => _localizations!.passwordsNotMatch;

  // ======================== 验证码 ========================
  static String get pleaseEnterVerifyCode =>
      _localizations!.pleaseEnterVerifyCode;
  static String resendAfterSeconds(int seconds) =>
      _localizations!.resendAfterSeconds(seconds);
  static String get getVerifyCode => _localizations!.getVerifyCode;

  // ======================== 表单校验 ========================
  static String fieldNotEmptyTip(String field) =>
      _localizations!.fieldNotEmptyTip(field);
  static String fieldFormatErrorTip(String field) =>
      _localizations!.fieldFormatErrorTip(field);
  static String get paramValidationError =>
      _localizations!.paramValidationError;

  // ======================== 登录/注册 ========================
  static String get password => _localizations!.password;
  static String get userAgreement => _localizations!.userAgreement;
  static String get privacyPolicy => _localizations!.privacyPolicy;
  static String get agreeTermsFirst => _localizations!.agreeTermsFirst;
  static String get loginFailed => _localizations!.loginFailed;
  static String get switchLoginType => _localizations!.switchLoginType;
  static String get noAccount => _localizations!.noAccount;
  static String get hasAccount => _localizations!.hasAccount;
  static String get welcomeBack => _localizations!.welcomeBack;
  static String get registerFailed => _localizations!.registerFailed;

  // ======================== 网络异常 ========================
  static String get networkError => _localizations!.networkError;
  static String get networkTimeout => _localizations!.networkTimeout;
  static String get networkConnectionFailed =>
      _localizations!.networkConnectionFailed;
  static String get sslError => _localizations!.sslError;

  // ======================== 请求/响应异常 ========================
  static String get requestError => _localizations!.requestError;
  static String get requestCancelled => _localizations!.requestCancelled;
  static String get responseError => _localizations!.responseError;
  static String get tooManyRequests => _localizations!.tooManyRequests;

  // ======================== 服务器异常 ========================
  static String get serverError => _localizations!.serverError;
  static String get serverMaintenance => _localizations!.serverMaintenance;

  // ======================== 权限/认证异常 ========================
  static String get unauthorized => _localizations!.unauthorized;
  static String get forbidden => _localizations!.forbidden;

  // ======================== 资源/数据异常 ========================
  static String get notFound => _localizations!.notFound;
  static String get dataParseError => _localizations!.dataParseError;

  // ======================== 上传/下载异常 ========================
  static String get downloadFailed => _localizations!.downloadFailed;
  static String get uploadFailed => _localizations!.uploadFailed;

  // ======================== 其他异常 ========================
  static String get unknownError => _localizations!.unknownError;
}
