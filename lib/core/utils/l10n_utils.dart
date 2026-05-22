import 'package:flutter/widgets.dart';
import 'package:odk_flutter_template/l10n/app_localizations.dart';

/// 国际化静态工具类（🔥 全局静态调用，无需context）
class L10nUtils {
  static AppLocalizations? _localizations;

  /// 初始化（在 MaterialApp builder 中调用一次）
  static void init(BuildContext context) {
    _localizations = AppLocalizations.of(context);
  }

  /// 强制更新缓存（在语言切换时调用）
  // static void update() {
  //   final rootContext = AppRouter.routerKey.currentContext;
  //   if (rootContext != null) {
  //     _localizations = AppLocalizations.of(rootContext);
  //   }
  // }

  /// 内部统一获取本地化实例
  // static AppLocalizations get _loc {
  //   // 优先从根 context 获取（动态）
  //   final rootContext = AppRouter.routerKey.currentContext;
  //   if (rootContext != null) {
  //     final loc = AppLocalizations.of(rootContext);
  //     if (loc != null) return loc;
  //   }

  //   // 降级到静态缓存（兼容无 context 场景）
  //   assert(
  //     _localizations != null,
  //     "L10nUtils 未初始化，请在 MaterialApp builder 中调用 L10nUtils.init()",
  //   );
  //   return _localizations!;
  // }

  /// 内部统一获取根上下文本地化实例
  // static AppLocalizations get _loc {
  //   final rootContext = AppRouter.routerKey.currentContext;
  //   assert(rootContext != null, "应用根上下文未就绪");
  //   return AppLocalizations.of(rootContext!)!;
  // }

  // 统一入口，实时获取当前上下文语种
  ///为什么 of(context) 能自动更新？ 因为 Localizations.of(context) 建立了依赖关系，语言变化时 Flutter 会自动重建依赖它的 widget 为什么静态调用不能自动更新？ 因为静态调用不依赖 context，Flutter 不知道需要重建这个 widget 最佳方案？ 混合模式：Widget 中用 of(context) ，无 context 场景用静态属性 + 主动更新缓存
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
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
  static String get discover => _localizations!.discover;
  static String get mine => _localizations!.mine;
  static String get helpAbout => _localizations!.helpAbout;
  static String get iHaveReadAndAgree => _localizations!.iHaveReadAndAgree;
  static String get andText => _localizations!.andText;

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
  static String get logoutConfirmMsg => _localizations!.logoutConfirmMsg;

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

  // ======================== 网络状态 ========================
  static String get networkRestored => _localizations!.networkRestored;
  static String get noNetworkConnection => _localizations!.noNetworkConnection;

  // ======================== 版本信息页 ========================
  static String get appName => _localizations!.appName;
  static String get packageName => _localizations!.packageName;
  static String get versionNumber => _localizations!.versionNumber;
  static String get buildNumber => _localizations!.buildNumber;
  static String get checkingUpdate => _localizations!.checkingUpdate;
  static String newVersionFound(String version) =>
      _localizations!.newVersionFound(version);
  static String get updateNow => _localizations!.updateNow;
  static String get alreadyLatestVersion =>
      _localizations!.alreadyLatestVersion;
  static String get cannotOpenAppStore => _localizations!.cannotOpenAppStore;

  // ======================== 头像更新 ========================
  static String get takePhoto => _localizations!.takePhoto;
  static String get chooseFromAlbum => _localizations!.chooseFromAlbum;
  static String get cameraPermissionDenied =>
      _localizations!.cameraPermissionDenied;
  static String get photoPermissionDenied =>
      _localizations!.photoPermissionDenied;
  static String get permissionDeniedTip => _localizations!.permissionDeniedTip;
  static String get avatarUpdateSuccess => _localizations!.avatarUpdateSuccess;
  static String get selectAvatar => _localizations!.selectAvatar;
  static String get saving => _localizations!.saving;
  static String get cameraNotAvailableOnSimulator =>
      _localizations!.cameraNotAvailableOnSimulator;

  // ======================== 状态页面 ========================
  static String get loading => _localizations!.loading;
  static String get emptyData => _localizations!.emptyData;
  static String get retry => _localizations!.retry;
  static String get pageNotFound => _localizations!.pageNotFound;
  static String get pageNotFoundDesc => _localizations!.pageNotFoundDesc;
  static String get networkErrorDesc => _localizations!.networkErrorDesc;
  static String get serverErrorDesc => _localizations!.serverErrorDesc;
  static String get unknownErrorDesc => _localizations!.unknownErrorDesc;

  // ======================== 下拉刷新/上拉加载 ========================
  static String get pullToRefresh => _localizations!.pullToRefresh;
  static String get releaseToRefresh => _localizations!.releaseToRefresh;
  static String get refreshComplete => _localizations!.refreshComplete;
  static String get pullToLoadMore => _localizations!.pullToLoadMore;
  static String get releaseToLoadMore => _localizations!.releaseToLoadMore;
  static String get loadingMore => _localizations!.loadingMore;
  static String get noMoreData => _localizations!.noMoreData;
  static String get loadFailed => _localizations!.loadFailed;
  static String get follow => _localizations!.follow;
  static String get unfollow => _localizations!.unfollow;
  static String get detail => _localizations!.detail;

  // ======================== 隐私政策弹窗 ========================
  static String get privacyPolicyDialogTitle =>
      _localizations!.privacyPolicyDialogTitle;
  static String privacyPolicyDialogContent(
    String userAgreement,
    String privacyPolicy,
  ) => _localizations!.privacyPolicyDialogContent(userAgreement, privacyPolicy);
  static String get privacyPolicyAgree => _localizations!.privacyPolicyAgree;
  static String get privacyPolicyDisagree =>
      _localizations!.privacyPolicyDisagree;
  static String get privacyPolicyDisagreeMessage =>
      _localizations!.privacyPolicyDisagreeMessage;
  static String get privacyPolicyExitConfirm =>
      _localizations!.privacyPolicyExitConfirm;
  static String get privacyPolicyExitMessage =>
      _localizations!.privacyPolicyExitMessage;

  // ======================== 账号注销 ========================
  static String get deleteAccount => _localizations!.deleteAccount;
  static String get deleteAccountWarning =>
      _localizations!.deleteAccountWarning;
  static String get deleteAccountConfirmTitle =>
      _localizations!.deleteAccountConfirmTitle;
  static String get deleteAccountConfirmMessage =>
      _localizations!.deleteAccountConfirmMessage;
  static String get deleteAccountInputHint =>
      _localizations!.deleteAccountInputHint;
  static String get deleteAccountInputMatch =>
      _localizations!.deleteAccountInputMatch;
  static String get deleteAccountButton => _localizations!.deleteAccountButton;
  static String get deleteAccountSuccess =>
      _localizations!.deleteAccountSuccess;
  static String get deleteAccountFailed => _localizations!.deleteAccountFailed;

  // ======================== 缓存清理 ========================
  static String get clearCache => _localizations!.clearCache;
  static String get cacheSize => _localizations!.cacheSize;
  static String get clearCacheSuccess => _localizations!.clearCacheSuccess;
  static String get clearCacheConfirm => _localizations!.clearCacheConfirm;

  // ======================== 关于/反馈 ========================
  static String get about => _localizations!.about;
  static String get feedback => _localizations!.feedback;
  static String get feedbackEmail => _localizations!.feedbackEmail;
  static String get feedbackHint => _localizations!.feedbackHint;
  static String get feedbackSubmit => _localizations!.feedbackSubmit;
  static String get feedbackSuccess => _localizations!.feedbackSuccess;
  static String get feedbackFailed => _localizations!.feedbackFailed;
  static String get feedbackContentRequired =>
      _localizations!.feedbackContentRequired;
}
