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
  String get todo => '待实现...';

  @override
  String get common => '通用';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get operationFailed => '操作失败';

  @override
  String get appTitle => 'ODK Flutter 模板';

  @override
  String get home => '首页';

  @override
  String get mine => '我的';

  @override
  String get systemSetting => '设置';

  @override
  String get commonSetting => '通用设置';

  @override
  String get account => '账户';

  @override
  String get general => '通用';

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
  String get accountSecurity => '账号安全';

  @override
  String get setPassword => '设置密码';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetPasswordShort => '重置密码';

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
  String get pleaseEnterVerifyCode => '请输入验证码';

  @override
  String resendAfterSeconds(int seconds) {
    return '${seconds}s后重发';
  }

  @override
  String get getVerifyCode => '获取验证码';

  @override
  String fieldNotEmptyTip(String field) {
    return '$field不能为空';
  }

  @override
  String fieldFormatErrorTip(String field) {
    return '$field格式不正确';
  }

  @override
  String get password => '密码';

  @override
  String get userAgreement => '用户协议';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get agreeTermsFirst => '请勾选用户协议和隐私政策';

  @override
  String get loginFailed => '登录失败，请检查账号密码';

  @override
  String get switchLoginType => '切换登录方式';

  @override
  String get noAccount => '没有账号？';

  @override
  String get hasAccount => '已经有账号？';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get registerFailed => '注册失败';

  @override
  String get paramValidationError => '参数校验失败，请检查输入';

  @override
  String get networkError => '网络异常，请检查网络连接';

  @override
  String get networkTimeout => '网络请求超时，请重试';

  @override
  String get networkConnectionFailed => '无法连接服务器，请稍后重试';

  @override
  String get sslError => '安全连接失败，请检查网络设置';

  @override
  String get requestError => '请求异常，请重试';

  @override
  String get requestCancelled => '请求已取消';

  @override
  String get responseError => '响应异常，请稍后重试';

  @override
  String get tooManyRequests => '请求过于频繁，请稍后重试';

  @override
  String get serverError => '服务器错误，请稍后重试';

  @override
  String get serverMaintenance => '服务器维护中，请稍后重试';

  @override
  String get unauthorized => '认证已过期，请重新登录';

  @override
  String get forbidden => '访问被拒绝，权限不足';

  @override
  String get notFound => '请求的资源不存在';

  @override
  String get dataParseError => '数据解析异常';

  @override
  String get downloadFailed => '下载失败，请重试';

  @override
  String get uploadFailed => '上传失败，请重试';

  @override
  String get unknownError => '未知错误，请重试';

  @override
  String get networkRestored => '网络连接恢复';

  @override
  String get noNetworkConnection => '当前无网络连接，请检查网络设置';
}
