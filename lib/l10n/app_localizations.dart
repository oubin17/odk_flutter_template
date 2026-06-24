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

  /// 操作失败
  ///
  /// In en, this message translates to:
  /// **'Operation Failed'**
  String get operationFailed;

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

  /// 保存中
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// 应用标题
  ///
  /// In en, this message translates to:
  /// **'ODK Flutter Template'**
  String get appTitle;

  /// 应用名称
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

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

  /// 消息
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get message;

  /// 我的
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get mine;

  /// 详情
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

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

  /// 密码
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

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

  /// 登录失败，请检查账号密码
  ///
  /// In en, this message translates to:
  /// **'Login failed, please check your account and password'**
  String get loginFailed;

  /// 注册失败
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

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

  /// 请勾选用户协议和隐私政策
  ///
  /// In en, this message translates to:
  /// **'Please agree to the User Agreement and Privacy Policy'**
  String get agreeTermsFirst;

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

  /// 参数校验失败提示
  ///
  /// In en, this message translates to:
  /// **'Parameter validation failed, please check your input'**
  String get paramValidationError;

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

  /// 账户
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

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

  /// 帮助&关于
  ///
  /// In en, this message translates to:
  /// **'Help & About'**
  String get helpAbout;

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

  /// 关于
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

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

  /// 退出登录确认提示
  ///
  /// In en, this message translates to:
  /// **'You will need to log in again after signing out. Are you sure?'**
  String get logoutConfirmMsg;

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

  /// 模拟器不支持相机，请使用真机测试
  ///
  /// In en, this message translates to:
  /// **'Camera is not available on simulator, please test on a real device'**
  String get cameraNotAvailableOnSimulator;

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

  /// 成功
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get errorCode000;

  /// 请求参数非法
  ///
  /// In en, this message translates to:
  /// **'Invalid request parameters'**
  String get errorCode001;

  /// 请求过于频繁
  ///
  /// In en, this message translates to:
  /// **'Too many requests, please try again later'**
  String get errorCode002;

  /// 租户非法
  ///
  /// In en, this message translates to:
  /// **'Invalid tenant'**
  String get errorCode003;

  /// 租户为空
  ///
  /// In en, this message translates to:
  /// **'Tenant is empty'**
  String get errorCode004;

  /// 租户不匹配
  ///
  /// In en, this message translates to:
  /// **'Tenant mismatch'**
  String get errorCode005;

  /// 用户已经存在
  ///
  /// In en, this message translates to:
  /// **'User already exists'**
  String get errorCode010;

  /// 登录ID重复
  ///
  /// In en, this message translates to:
  /// **'Login ID already exists'**
  String get errorCode011;

  /// 用户不存在
  ///
  /// In en, this message translates to:
  /// **'User does not exist'**
  String get errorCode012;

  /// 密码不匹配
  ///
  /// In en, this message translates to:
  /// **'Password mismatch'**
  String get errorCode013;

  /// 用户状态异常
  ///
  /// In en, this message translates to:
  /// **'Abnormal user status'**
  String get errorCode014;

  /// 用户未登录
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get errorCode015;

  /// 新旧密码一致
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as old password'**
  String get errorCode016;

  /// 密码已经存在
  ///
  /// In en, this message translates to:
  /// **'Password already exists'**
  String get errorCode017;

  /// Token过期
  ///
  /// In en, this message translates to:
  /// **'Token expired, please log in again'**
  String get errorCode020;

  /// Token缺失
  ///
  /// In en, this message translates to:
  /// **'Token missing, please log in again'**
  String get errorCode021;

  /// Token不匹配
  ///
  /// In en, this message translates to:
  /// **'Token mismatch, please log in again'**
  String get errorCode022;

  /// 暂无权限
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorCode030;

  /// 验证码不匹配
  ///
  /// In en, this message translates to:
  /// **'Verification code mismatch'**
  String get errorCode040;

  /// 验证码已过期
  ///
  /// In en, this message translates to:
  /// **'Verification code expired'**
  String get errorCode041;

  /// 验证码已存在
  ///
  /// In en, this message translates to:
  /// **'Verification code already exists'**
  String get errorCode042;

  /// 验证码已超过最大验证次数
  ///
  /// In en, this message translates to:
  /// **'Maximum verification attempts exceeded'**
  String get errorCode043;

  /// 验证码已超过最大发送次数
  ///
  /// In en, this message translates to:
  /// **'Maximum verification code sends exceeded'**
  String get errorCode044;

  /// 验证码唯一键错误
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code unique key'**
  String get errorCode045;

  /// 验证码不存在
  ///
  /// In en, this message translates to:
  /// **'Verification code does not exist'**
  String get errorCode046;

  /// 未知系统异常
  ///
  /// In en, this message translates to:
  /// **'Unknown system error'**
  String get errorCodeN100;

  /// 签名错误
  ///
  /// In en, this message translates to:
  /// **'Signing error'**
  String get errorCodeN110;

  /// 选择模型
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get aiChatSelectModel;

  /// 历史会话
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get aiChatHistory;

  /// 暂无会话记录
  ///
  /// In en, this message translates to:
  /// **'No chat history'**
  String get aiChatNoHistory;

  /// 新对话
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get aiChatNewConversation;

  /// 删除会话确认标题
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get aiChatDeleteConfirmTitle;

  /// 删除会话确认消息
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat and all its messages?'**
  String get aiChatDeleteConfirmMsg;

  /// AI对话欢迎语
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation'**
  String get aiChatWelcome;

  /// AI对话输入提示
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get aiChatInputHint;

  /// 消息通知标题
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// 暂无消息
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationEmpty;

  /// 昨天
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationYesterday;

  /// 天前
  ///
  /// In en, this message translates to:
  /// **' days ago'**
  String get notificationDaysAgo;

  /// 合规信息分区标题
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get complianceInfo;

  /// 第三方SDK列表
  ///
  /// In en, this message translates to:
  /// **'Third-party SDK List'**
  String get sdkList;

  /// 个人信息收集清单
  ///
  /// In en, this message translates to:
  /// **'Personal Information Collection'**
  String get privacyCollection;

  /// 权限使用说明
  ///
  /// In en, this message translates to:
  /// **'Permission Usage'**
  String get permissionInfo;

  /// 必要标签
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get complianceRequired;

  /// 用途标签
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get compliancePurpose;

  /// 使用场景标签
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get complianceScenario;

  /// 提供方标签
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get complianceProvider;

  /// 收集数据标签
  ///
  /// In en, this message translates to:
  /// **'Data Collected'**
  String get complianceDataCollected;

  /// 收集目的标签
  ///
  /// In en, this message translates to:
  /// **'Collection Purpose'**
  String get complianceCollectionPurpose;

  /// 处理方式标签
  ///
  /// In en, this message translates to:
  /// **'Processing Method'**
  String get complianceProcessingMethod;

  /// 权限使用说明页面描述
  ///
  /// In en, this message translates to:
  /// **'This app may request the following permissions during operation, solely for providing corresponding features. Non-essential permissions are only requested when using the relevant features. You can manage permissions anytime in system settings.'**
  String get permissionInfoDesc;

  /// 相机权限名称
  ///
  /// In en, this message translates to:
  /// **'Camera (CAMERA)'**
  String get permCameraName;

  /// 相机权限用途
  ///
  /// In en, this message translates to:
  /// **'Take profile photos'**
  String get permCameraPurpose;

  /// 相机权限使用场景
  ///
  /// In en, this message translates to:
  /// **'When user selects \"Take Photo\" on profile page'**
  String get permCameraScenario;

  /// 相册权限名称
  ///
  /// In en, this message translates to:
  /// **'Photo Library (READ_MEDIA_IMAGES)'**
  String get permAlbumName;

  /// 相册权限用途
  ///
  /// In en, this message translates to:
  /// **'Select profile image from album'**
  String get permAlbumPurpose;

  /// 相册权限使用场景
  ///
  /// In en, this message translates to:
  /// **'When user selects \"Choose from Album\" on profile page'**
  String get permAlbumScenario;

  /// 通知权限名称
  ///
  /// In en, this message translates to:
  /// **'Notifications (POST_NOTIFICATIONS)'**
  String get permNotificationName;

  /// 通知权限用途
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get permNotificationPurpose;

  /// 通知权限使用场景
  ///
  /// In en, this message translates to:
  /// **'During app runtime (user can toggle)'**
  String get permNotificationScenario;

  /// 网络权限名称
  ///
  /// In en, this message translates to:
  /// **'Network (INTERNET)'**
  String get permNetworkName;

  /// 网络权限用途
  ///
  /// In en, this message translates to:
  /// **'Server communication, web content loading'**
  String get permNetworkPurpose;

  /// 网络权限使用场景
  ///
  /// In en, this message translates to:
  /// **'During app runtime (required)'**
  String get permNetworkScenario;

  /// 设备状态权限名称
  ///
  /// In en, this message translates to:
  /// **'Device State (READ_PHONE_STATE)'**
  String get permPhoneStateName;

  /// 设备状态权限用途
  ///
  /// In en, this message translates to:
  /// **'Crash monitoring auxiliary info (device model, etc.)'**
  String get permPhoneStatePurpose;

  /// 设备状态权限使用场景
  ///
  /// In en, this message translates to:
  /// **'Auto-collected by Bugly SDK on crash'**
  String get permPhoneStateScenario;

  /// SDK列表页面描述
  ///
  /// In en, this message translates to:
  /// **'This app integrates the following third-party SDKs to provide various features. All SDKs\' data collection and processing comply with relevant laws and privacy policies.'**
  String get sdkListDesc;

  /// Dart开源社区
  ///
  /// In en, this message translates to:
  /// **'Dart Open Source Community'**
  String get sdkProviderDartCommunity;

  /// Flutter官方
  ///
  /// In en, this message translates to:
  /// **'Flutter Official'**
  String get sdkProviderFlutterOfficial;

  /// 腾讯公司
  ///
  /// In en, this message translates to:
  /// **'Tencent Computer System Co., Ltd.'**
  String get sdkProviderTencent;

  /// 无数据收集
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get sdkDataNone;

  /// Dio用途
  ///
  /// In en, this message translates to:
  /// **'Network requests'**
  String get sdkDioPurpose;

  /// Dio收集数据
  ///
  /// In en, this message translates to:
  /// **'Network request parameters (including device ID)'**
  String get sdkDioData;

  /// Provider用途
  ///
  /// In en, this message translates to:
  /// **'State management'**
  String get sdkProviderLibPurpose;

  /// GoRouter用途
  ///
  /// In en, this message translates to:
  /// **'Route navigation'**
  String get sdkGoRouterPurpose;

  /// 安全存储用途
  ///
  /// In en, this message translates to:
  /// **'Secure storage (tokens and sensitive data)'**
  String get sdkSecureStoragePurpose;

  /// 安全存储收集数据
  ///
  /// In en, this message translates to:
  /// **'Locally stored tokens'**
  String get sdkSecureStorageData;

  /// 偏好设置用途
  ///
  /// In en, this message translates to:
  /// **'Preference storage'**
  String get sdkSharedPrefsPurpose;

  /// 偏好设置收集数据
  ///
  /// In en, this message translates to:
  /// **'Theme mode, language preference'**
  String get sdkSharedPrefsData;

  /// 图片缓存用途
  ///
  /// In en, this message translates to:
  /// **'Image cache loading'**
  String get sdkCachedImagePurpose;

  /// 图片缓存收集数据
  ///
  /// In en, this message translates to:
  /// **'Image cache files'**
  String get sdkCachedImageData;

  /// Webview用途
  ///
  /// In en, this message translates to:
  /// **'Embedded web pages (agreement pages, etc.)'**
  String get sdkWebviewPurpose;

  /// Webview收集数据
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get sdkWebviewData;

  /// 图片选择器用途
  ///
  /// In en, this message translates to:
  /// **'Avatar photo/album selection'**
  String get sdkImagePickerPurpose;

  /// 图片选择器收集数据
  ///
  /// In en, this message translates to:
  /// **'Selected images'**
  String get sdkImagePickerData;

  /// 权限管理用途
  ///
  /// In en, this message translates to:
  /// **'Permission request management'**
  String get sdkPermissionHandlerPurpose;

  /// 设备信息用途
  ///
  /// In en, this message translates to:
  /// **'Device info retrieval'**
  String get sdkDeviceInfoPurpose;

  /// 设备信息收集数据
  ///
  /// In en, this message translates to:
  /// **'Device model, OS version'**
  String get sdkDeviceInfoData;

  /// 包信息用途
  ///
  /// In en, this message translates to:
  /// **'App package info retrieval'**
  String get sdkPackageInfoPurpose;

  /// 包信息收集数据
  ///
  /// In en, this message translates to:
  /// **'App version, package name'**
  String get sdkPackageInfoData;

  /// 网络连接用途
  ///
  /// In en, this message translates to:
  /// **'Network status monitoring'**
  String get sdkConnectivityPurpose;

  /// 网络连接收集数据
  ///
  /// In en, this message translates to:
  /// **'Network connection type'**
  String get sdkConnectivityData;

  /// 本地通知用途
  ///
  /// In en, this message translates to:
  /// **'Local push notifications'**
  String get sdkLocalNotificationsPurpose;

  /// 本地通知收集数据
  ///
  /// In en, this message translates to:
  /// **'Notification content'**
  String get sdkLocalNotificationsData;

  /// Bugly用途
  ///
  /// In en, this message translates to:
  /// **'Crash exception monitoring'**
  String get sdkBuglyPurpose;

  /// Bugly收集数据
  ///
  /// In en, this message translates to:
  /// **'Device model, OS version, crash logs'**
  String get sdkBuglyData;

  /// 个人信息收集清单页面描述
  ///
  /// In en, this message translates to:
  /// **'This app collects the following personal information during operation, solely for providing and improving our services. We strictly protect your personal information in accordance with our Privacy Policy.'**
  String get privacyCollectionDesc;

  /// 手机号信息类型
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get privacyPhoneInfoType;

  /// 手机号收集目的
  ///
  /// In en, this message translates to:
  /// **'User login, registration, identity verification'**
  String get privacyPhonePurpose;

  /// 手机号处理方式
  ///
  /// In en, this message translates to:
  /// **'Encrypted and stored on server, not shared with third parties'**
  String get privacyPhoneMethod;

  /// 密码信息类型
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get privacyPasswordInfoType;

  /// 密码收集目的
  ///
  /// In en, this message translates to:
  /// **'User login authentication'**
  String get privacyPasswordPurpose;

  /// 密码处理方式
  ///
  /// In en, this message translates to:
  /// **'Encrypted transmission to server, no plaintext stored locally'**
  String get privacyPasswordMethod;

  /// 昵称信息类型
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get privacyNicknameInfoType;

  /// 昵称收集目的
  ///
  /// In en, this message translates to:
  /// **'User profile display'**
  String get privacyNicknamePurpose;

  /// 昵称处理方式
  ///
  /// In en, this message translates to:
  /// **'Transmitted to server for storage'**
  String get privacyNicknameMethod;

  /// 头像信息类型
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get privacyAvatarInfoType;

  /// 头像收集目的
  ///
  /// In en, this message translates to:
  /// **'User profile display'**
  String get privacyAvatarPurpose;

  /// 头像处理方式
  ///
  /// In en, this message translates to:
  /// **'Uploaded to server, local image cache'**
  String get privacyAvatarMethod;

  /// 性别信息类型
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get privacyGenderInfoType;

  /// 性别收集目的
  ///
  /// In en, this message translates to:
  /// **'Profile completion'**
  String get privacyGenderPurpose;

  /// 性别处理方式
  ///
  /// In en, this message translates to:
  /// **'Transmitted to server for storage'**
  String get privacyGenderMethod;

  /// 生日信息类型
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get privacyBirthdayInfoType;

  /// 生日收集目的
  ///
  /// In en, this message translates to:
  /// **'Profile completion'**
  String get privacyBirthdayPurpose;

  /// 生日处理方式
  ///
  /// In en, this message translates to:
  /// **'Transmitted to server for storage'**
  String get privacyBirthdayMethod;

  /// 设备标识信息类型
  ///
  /// In en, this message translates to:
  /// **'Device ID (IDFA/Android ID)'**
  String get privacyDeviceIdInfoType;

  /// 设备标识收集目的
  ///
  /// In en, this message translates to:
  /// **'Device identification, crash monitoring'**
  String get privacyDeviceIdPurpose;

  /// 设备标识处理方式
  ///
  /// In en, this message translates to:
  /// **'Locally generated and stored, not uploaded (except Bugly SDK)'**
  String get privacyDeviceIdMethod;

  /// 设备信息类型
  ///
  /// In en, this message translates to:
  /// **'Device model, OS version'**
  String get privacyDeviceInfoInfoType;

  /// 设备信息收集目的
  ///
  /// In en, this message translates to:
  /// **'Crash diagnosis, version adaptation'**
  String get privacyDeviceInfoPurpose;

  /// 设备信息处理方式
  ///
  /// In en, this message translates to:
  /// **'Uploaded to Tencent server via Bugly SDK'**
  String get privacyDeviceInfoMethod;

  /// 应用版本号信息类型
  ///
  /// In en, this message translates to:
  /// **'App version number'**
  String get privacyAppVersionInfoType;

  /// 应用版本号收集目的
  ///
  /// In en, this message translates to:
  /// **'Version update detection'**
  String get privacyAppVersionPurpose;

  /// 应用版本号处理方式
  ///
  /// In en, this message translates to:
  /// **'Read locally, compared with server version'**
  String get privacyAppVersionMethod;

  /// 网络状态信息类型
  ///
  /// In en, this message translates to:
  /// **'Network connection status'**
  String get privacyNetworkStatusInfoType;

  /// 网络状态收集目的
  ///
  /// In en, this message translates to:
  /// **'Network status monitoring and alerts'**
  String get privacyNetworkStatusPurpose;

  /// 网络状态处理方式
  ///
  /// In en, this message translates to:
  /// **'Local monitoring only, not stored or uploaded'**
  String get privacyNetworkStatusMethod;

  /// 崩溃日志信息类型
  ///
  /// In en, this message translates to:
  /// **'Crash logs'**
  String get privacyCrashLogInfoType;

  /// 崩溃日志收集目的
  ///
  /// In en, this message translates to:
  /// **'App crash monitoring and repair'**
  String get privacyCrashLogPurpose;

  /// 崩溃日志处理方式
  ///
  /// In en, this message translates to:
  /// **'Uploaded to Tencent server via Bugly SDK'**
  String get privacyCrashLogMethod;
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
