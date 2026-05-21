import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// 确认
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// 取消
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// 保存
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// 成功
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// 失败
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get fail;

  /// 错误
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// 待实现占位文本
  ///
  /// In en, this message translates to:
  /// **'To do...'**
  String get todo;

  /// 通用
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get common;

  /// 登录
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// 注册
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// 操作失败
  ///
  /// In en, this message translates to:
  /// **'Operation Failed'**
  String get operationFailed;

  /// 应用标题
  ///
  /// In en, this message translates to:
  /// **'ODK Flutter Template'**
  String get appTitle;

  /// 首页
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// 发现
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// 我的
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get mine;

  /// 系统设置
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get systemSetting;

  /// 通用设置
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get commonSetting;

  /// 账户
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// 通用
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// 主题模式
  ///
  /// In en, this message translates to:
  /// **'ThemeMode'**
  String get themeMode;

  /// 日间模式
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// 夜间模式
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// 切换语言
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get switchLanguage;

  /// 当前语言名称
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// 关于我们
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// 帮助&关于
  ///
  /// In en, this message translates to:
  /// **'Help & About'**
  String get helpAbout;

  /// 我已阅读并同意
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the'**
  String get iHaveReadAndAgree;

  /// 和
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andText;

  /// 设备信息
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// 版本信息
  ///
  /// In en, this message translates to:
  /// **'Version Info'**
  String get versionInfo;

  /// 登出
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// 用户画像
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// 头像
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// 昵称
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// 性别
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// 男
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// 女
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// 生日
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// 手机号
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// 账号安全
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurity;

  /// 设置密码
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// 重置密码
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// 重置密码（场景名称）
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordShort;

  /// 请输入密码
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// 新密码
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// 请输入新密码
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get pleaseEnterNewPassword;

  /// 旧密码
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// 请输入旧密码
  ///
  /// In en, this message translates to:
  /// **'Please enter old password'**
  String get pleaseEnterOldPassword;

  /// 新密码不能与旧密码相同
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as old password'**
  String get newPasswordCannotBeSameAsOld;

  /// 确认密码
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// 请输入确认密码
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm password'**
  String get pleaseEnterConfirmPassword;

  /// 两次输入密码不一致
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// 请输入验证码
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get pleaseEnterVerifyCode;

  /// xx秒后重发
  ///
  /// In en, this message translates to:
  /// **'{seconds}s to resend'**
  String resendAfterSeconds(int seconds);

  /// 获取验证码
  ///
  /// In en, this message translates to:
  /// **'Get Code'**
  String get getVerifyCode;

  /// 字段不能为空，表单校验提示
  ///
  /// In en, this message translates to:
  /// **'{field} cannot be empty'**
  String fieldNotEmptyTip(String field);

  /// 字段格式不正确，表单校验提示
  ///
  /// In en, this message translates to:
  /// **'{field} format is incorrect'**
  String fieldFormatErrorTip(String field);

  /// 密码
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// 用户协议
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// 隐私政策
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// 请勾选用户协议和隐私政策
  ///
  /// In en, this message translates to:
  /// **'Please agree to the User Agreement and Privacy Policy'**
  String get agreeTermsFirst;

  /// 登录失败，请检查账号密码
  ///
  /// In en, this message translates to:
  /// **'Login failed, please check your account and password'**
  String get loginFailed;

  /// 切换登录方式
  ///
  /// In en, this message translates to:
  /// **'Switch login method'**
  String get switchLoginType;

  /// 没有账号？
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get noAccount;

  /// 已经有账号？
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// 欢迎回来
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// 注册失败
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// 参数校验失败提示
  ///
  /// In en, this message translates to:
  /// **'Parameter validation failed, please check your input'**
  String get paramValidationError;

  /// 网络异常提示
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your network connection'**
  String get networkError;

  /// 网络请求超时提示
  ///
  /// In en, this message translates to:
  /// **'Network request timed out, please try again'**
  String get networkTimeout;

  /// 网络连接失败提示
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to server, please try again later'**
  String get networkConnectionFailed;

  /// SSL证书错误提示
  ///
  /// In en, this message translates to:
  /// **'Secure connection failed, please check your network settings'**
  String get sslError;

  /// 请求异常提示
  ///
  /// In en, this message translates to:
  /// **'Request error, please try again'**
  String get requestError;

  /// 请求被取消提示
  ///
  /// In en, this message translates to:
  /// **'Request has been cancelled'**
  String get requestCancelled;

  /// 响应异常提示
  ///
  /// In en, this message translates to:
  /// **'Response error, please try again later'**
  String get responseError;

  /// 请求过于频繁提示
  ///
  /// In en, this message translates to:
  /// **'Too many requests, please try again later'**
  String get tooManyRequests;

  /// 服务器错误提示
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get serverError;

  /// 服务器维护提示
  ///
  /// In en, this message translates to:
  /// **'Server is under maintenance, please try again later'**
  String get serverMaintenance;

  /// 未授权/登录过期提示
  ///
  /// In en, this message translates to:
  /// **'Authentication expired, please log in again'**
  String get unauthorized;

  /// 无权限访问提示
  ///
  /// In en, this message translates to:
  /// **'Access denied, insufficient permissions'**
  String get forbidden;

  /// 资源未找到提示
  ///
  /// In en, this message translates to:
  /// **'Requested resource not found'**
  String get notFound;

  /// 数据解析异常提示
  ///
  /// In en, this message translates to:
  /// **'Data parsing error'**
  String get dataParseError;

  /// 下载失败提示
  ///
  /// In en, this message translates to:
  /// **'Download failed, please try again'**
  String get downloadFailed;

  /// 上传失败提示
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please try again'**
  String get uploadFailed;

  /// 未知错误提示
  ///
  /// In en, this message translates to:
  /// **'Unknown error, please try again'**
  String get unknownError;

  /// 网络连接恢复提示
  ///
  /// In en, this message translates to:
  /// **'Network connection restored'**
  String get networkRestored;

  /// 无网络连接提示
  ///
  /// In en, this message translates to:
  /// **'No network connection, please check network settings'**
  String get noNetworkConnection;

  /// 应用名称
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// 包名
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// 版本号
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionNumber;

  /// 构建号
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// 正在检查更新
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingUpdate;

  /// 发现新版本
  ///
  /// In en, this message translates to:
  /// **'New version available v{version}'**
  String newVersionFound(String version);

  /// 立即更新
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// 已是最新版本
  ///
  /// In en, this message translates to:
  /// **'Already up to date'**
  String get alreadyLatestVersion;

  /// 无法打开应用市场
  ///
  /// In en, this message translates to:
  /// **'Unable to open app store, please search for updates manually'**
  String get cannotOpenAppStore;

  /// 拍照
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// 从相册选择
  ///
  /// In en, this message translates to:
  /// **'Choose from Album'**
  String get chooseFromAlbum;

  /// 需要相机权限才能拍照
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos'**
  String get cameraPermissionDenied;

  /// 需要相册权限才能选择照片
  ///
  /// In en, this message translates to:
  /// **'Photo library permission is required to select photos'**
  String get photoPermissionDenied;

  /// 权限被拒绝，请在设置中开启
  ///
  /// In en, this message translates to:
  /// **'Permission denied, please find this app in Settings and enable Camera access'**
  String get permissionDeniedTip;

  /// 头像更新成功
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get avatarUpdateSuccess;

  /// 选择头像
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatar;

  /// 保存中
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// 模拟器不支持相机，请使用真机测试
  ///
  /// In en, this message translates to:
  /// **'Camera is not available on simulator, please test on a real device'**
  String get cameraNotAvailableOnSimulator;

  /// 加载中
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// 暂无数据
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get emptyData;

  /// 重试
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// 页面未找到
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// 页面未找到描述
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist'**
  String get pageNotFoundDesc;

  /// 网络错误描述
  ///
  /// In en, this message translates to:
  /// **'Network connection error, please check your network and retry'**
  String get networkErrorDesc;

  /// 服务器错误描述
  ///
  /// In en, this message translates to:
  /// **'Server is temporarily unavailable, please try again later'**
  String get serverErrorDesc;

  /// 未知错误描述
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later'**
  String get unknownErrorDesc;

  /// 下拉刷新
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// 释放刷新
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get releaseToRefresh;

  /// 刷新完成
  ///
  /// In en, this message translates to:
  /// **'Refresh complete'**
  String get refreshComplete;

  /// 上拉加载更多
  ///
  /// In en, this message translates to:
  /// **'Pull up to load more'**
  String get pullToLoadMore;

  /// 释放加载更多
  ///
  /// In en, this message translates to:
  /// **'Release to load more'**
  String get releaseToLoadMore;

  /// 正在加载
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingMore;

  /// 没有更多数据
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get noMoreData;

  /// 加载失败，点击重试
  ///
  /// In en, this message translates to:
  /// **'Load failed, tap to retry'**
  String get loadFailed;

  /// 关注
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// 取消关注
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// 详情
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// 隐私政策弹窗标题
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Notice'**
  String get privacyPolicyDialogTitle;

  /// 隐私政策弹窗内容
  ///
  /// In en, this message translates to:
  /// **'Thank you for using this app! Before using it, please carefully read and agree to the {userAgreement} and {privacyPolicy}. We will strictly protect your personal information in accordance with the policy.'**
  String privacyPolicyDialogContent(String userAgreement, String privacyPolicy);

  /// 同意隐私政策
  ///
  /// In en, this message translates to:
  /// **'Agree & Continue'**
  String get privacyPolicyAgree;

  /// 不同意隐私政策
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get privacyPolicyDisagree;

  /// 不同意隐私政策提示
  ///
  /// In en, this message translates to:
  /// **'You need to agree to the Privacy Policy to use this app'**
  String get privacyPolicyDisagreeMessage;

  /// 退出应用确认
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get privacyPolicyExitConfirm;

  /// 退出应用确认信息
  ///
  /// In en, this message translates to:
  /// **'You cannot use this app without agreeing to the Privacy Policy. Are you sure you want to exit?'**
  String get privacyPolicyExitMessage;

  /// 注销账号
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// 注销账号警告
  ///
  /// In en, this message translates to:
  /// **'After deleting your account, all your data will be permanently deleted and cannot be recovered. Please proceed with caution.'**
  String get deleteAccountWarning;

  /// 注销账号确认标题
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get deleteAccountConfirmTitle;

  /// 注销账号确认信息
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible! After deletion, your account and all associated data will be permanently deleted and cannot be recovered. Are you sure you want to delete your account?'**
  String get deleteAccountConfirmMessage;

  /// 注销账号输入提示
  ///
  /// In en, this message translates to:
  /// **'Type \"CONFIRM DELETE\" to continue'**
  String get deleteAccountInputHint;

  /// 注销账号输入匹配文本
  ///
  /// In en, this message translates to:
  /// **'CONFIRM DELETE'**
  String get deleteAccountInputMatch;

  /// 注销账号按钮
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get deleteAccountButton;

  /// 注销账号成功
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// 注销账号失败
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account, please try again later'**
  String get deleteAccountFailed;

  /// 清理缓存
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// 缓存大小
  ///
  /// In en, this message translates to:
  /// **'Cache Size'**
  String get cacheSize;

  /// 缓存清理完成
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get clearCacheSuccess;

  /// 确认清理缓存
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all cache data?'**
  String get clearCacheConfirm;

  /// 关于
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// 意见反馈
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// 反馈邮箱
  ///
  /// In en, this message translates to:
  /// **'Feedback Email'**
  String get feedbackEmail;

  /// 意见反馈输入提示
  ///
  /// In en, this message translates to:
  /// **'Please enter your suggestions'**
  String get feedbackHint;

  /// 提交反馈按钮
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmit;

  /// 反馈提交成功
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully, thank you!'**
  String get feedbackSuccess;

  /// 反馈提交失败
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback, please try again later'**
  String get feedbackFailed;

  /// 反馈内容不能为空
  ///
  /// In en, this message translates to:
  /// **'Feedback content cannot be empty'**
  String get feedbackContentRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
