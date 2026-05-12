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
  String get deviceInfo => 'Device Info';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get logout => 'Log Out';

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
}
