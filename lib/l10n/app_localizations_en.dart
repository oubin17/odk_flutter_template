// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get success => 'Success';

  @override
  String get fail => 'Failed';

  @override
  String get error => 'Error';

  @override
  String get todo => 'To do...';

  @override
  String get common => 'Common';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get operationFailed => 'Operation Failed';

  @override
  String get appTitle => 'ODK Flutter Template';

  @override
  String get home => 'Home';

  @override
  String get discover => 'Discover';

  @override
  String get mine => 'Mine';

  @override
  String get systemSetting => 'Setting';

  @override
  String get commonSetting => 'General Settings';

  @override
  String get account => 'Account';

  @override
  String get general => 'General';

  @override
  String get themeMode => 'ThemeMode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchLanguage => 'Language';

  @override
  String get language => 'English';

  @override
  String get aboutUs => 'About Us';

  @override
  String get helpAbout => 'Help & About';

  @override
  String get iHaveReadAndAgree => 'I have read and agree to the';

  @override
  String get andText => 'and';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmMsg =>
      'You will need to log in again after signing out. Are you sure?';

  @override
  String get profile => 'Profile';

  @override
  String get avatar => 'Avatar';

  @override
  String get nickname => 'Nickname';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get birthday => 'Birthday';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get setPassword => 'Set Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordShort => 'Reset Password';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get newPassword => 'New Password';

  @override
  String get pleaseEnterNewPassword => 'Please enter new password';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get pleaseEnterOldPassword => 'Please enter old password';

  @override
  String get newPasswordCannotBeSameAsOld =>
      'New password cannot be the same as old password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseEnterConfirmPassword => 'Please enter confirm password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get pleaseEnterVerifyCode => 'Please enter verification code';

  @override
  String resendAfterSeconds(int seconds) {
    return '${seconds}s to resend';
  }

  @override
  String get getVerifyCode => 'Get Code';

  @override
  String fieldNotEmptyTip(String field) {
    return '$field cannot be empty';
  }

  @override
  String fieldFormatErrorTip(String field) {
    return '$field format is incorrect';
  }

  @override
  String get password => 'Password';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get agreeTermsFirst =>
      'Please agree to the User Agreement and Privacy Policy';

  @override
  String get loginFailed =>
      'Login failed, please check your account and password';

  @override
  String get switchLoginType => 'Switch login method';

  @override
  String get noAccount => 'No account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get paramValidationError =>
      'Parameter validation failed, please check your input';

  @override
  String get networkError =>
      'Network error, please check your network connection';

  @override
  String get networkTimeout => 'Network request timed out, please try again';

  @override
  String get networkConnectionFailed =>
      'Unable to connect to server, please try again later';

  @override
  String get sslError =>
      'Secure connection failed, please check your network settings';

  @override
  String get requestError => 'Request error, please try again';

  @override
  String get requestCancelled => 'Request has been cancelled';

  @override
  String get responseError => 'Response error, please try again later';

  @override
  String get tooManyRequests => 'Too many requests, please try again later';

  @override
  String get serverError => 'Server error, please try again later';

  @override
  String get serverMaintenance =>
      'Server is under maintenance, please try again later';

  @override
  String get unauthorized => 'Authentication expired, please log in again';

  @override
  String get forbidden => 'Access denied, insufficient permissions';

  @override
  String get notFound => 'Requested resource not found';

  @override
  String get dataParseError => 'Data parsing error';

  @override
  String get downloadFailed => 'Download failed, please try again';

  @override
  String get uploadFailed => 'Upload failed, please try again';

  @override
  String get unknownError => 'Unknown error, please try again';

  @override
  String get networkRestored => 'Network connection restored';

  @override
  String get noNetworkConnection =>
      'No network connection, please check network settings';

  @override
  String get appName => 'App Name';

  @override
  String get packageName => 'Package Name';

  @override
  String get versionNumber => 'Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get checkingUpdate => 'Checking for updates...';

  @override
  String newVersionFound(String version) {
    return 'New version available v$version';
  }

  @override
  String get updateNow => 'Update Now';

  @override
  String get alreadyLatestVersion => 'Already up to date';

  @override
  String get cannotOpenAppStore =>
      'Unable to open app store, please search for updates manually';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromAlbum => 'Choose from Album';

  @override
  String get cameraPermissionDenied =>
      'Camera permission is required to take photos';

  @override
  String get photoPermissionDenied =>
      'Photo library permission is required to select photos';

  @override
  String get permissionDeniedTip =>
      'Permission denied, please find this app in Settings and enable Camera access';

  @override
  String get avatarUpdateSuccess => 'Avatar updated successfully';

  @override
  String get selectAvatar => 'Select Avatar';

  @override
  String get saving => 'Saving...';

  @override
  String get cameraNotAvailableOnSimulator =>
      'Camera is not available on simulator, please test on a real device';

  @override
  String get loading => 'Loading...';

  @override
  String get emptyData => 'No data';

  @override
  String get retry => 'Retry';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get pageNotFoundDesc => 'The page you are looking for does not exist';

  @override
  String get networkErrorDesc =>
      'Network connection error, please check your network and retry';

  @override
  String get serverErrorDesc =>
      'Server is temporarily unavailable, please try again later';

  @override
  String get unknownErrorDesc => 'Something went wrong, please try again later';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get releaseToRefresh => 'Release to refresh';

  @override
  String get refreshComplete => 'Refresh complete';

  @override
  String get pullToLoadMore => 'Pull up to load more';

  @override
  String get releaseToLoadMore => 'Release to load more';

  @override
  String get loadingMore => 'Loading...';

  @override
  String get noMoreData => 'No more data';

  @override
  String get loadFailed => 'Load failed, tap to retry';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get detail => 'Detail';

  @override
  String get privacyPolicyDialogTitle => 'Privacy Policy Notice';

  @override
  String privacyPolicyDialogContent(
    String userAgreement,
    String privacyPolicy,
  ) {
    return 'Thank you for using this app! Before using it, please carefully read and agree to the $userAgreement and $privacyPolicy. We will strictly protect your personal information in accordance with the policy.';
  }

  @override
  String get privacyPolicyAgree => 'Agree & Continue';

  @override
  String get privacyPolicyDisagree => 'Disagree';

  @override
  String get privacyPolicyDisagreeMessage =>
      'You need to agree to the Privacy Policy to use this app';

  @override
  String get privacyPolicyExitConfirm => 'Exit App';

  @override
  String get privacyPolicyExitMessage =>
      'You cannot use this app without agreeing to the Privacy Policy. Are you sure you want to exit?';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountWarning =>
      'After deleting your account, all your data will be permanently deleted and cannot be recovered. Please proceed with caution.';

  @override
  String get deleteAccountConfirmTitle => 'Confirm Account Deletion';

  @override
  String get deleteAccountConfirmMessage =>
      'This action is irreversible! After deletion, your account and all associated data will be permanently deleted and cannot be recovered. Are you sure you want to delete your account?';

  @override
  String get deleteAccountInputHint => 'Type \"CONFIRM DELETE\" to continue';

  @override
  String get deleteAccountInputMatch => 'CONFIRM DELETE';

  @override
  String get deleteAccountButton => 'Confirm Deletion';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String get deleteAccountFailed =>
      'Failed to delete account, please try again later';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get cacheSize => 'Cache Size';

  @override
  String get clearCacheSuccess => 'Cache cleared successfully';

  @override
  String get clearCacheConfirm =>
      'Are you sure you want to clear all cache data?';

  @override
  String get about => 'About';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackEmail => 'Feedback Email';

  @override
  String get feedbackHint => 'Please enter your suggestions';

  @override
  String get feedbackSubmit => 'Submit Feedback';

  @override
  String get feedbackSuccess => 'Feedback submitted successfully, thank you!';

  @override
  String get feedbackFailed =>
      'Failed to submit feedback, please try again later';

  @override
  String get feedbackContentRequired => 'Feedback content cannot be empty';
}
