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
  String get appTitle => 'ODK Flutter Template';

  @override
  String get account => 'Account';

  @override
  String get general => 'General';

  @override
  String get systemSetting => 'Setting';

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
  String get home => 'Home';

  @override
  String get mine => 'Mine';

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
  String get todo => 'To do...';

  @override
  String get commonSetting => 'General Settings';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get setPassword => 'Set Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get operationFailed => 'Operation Failed';

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
  String fieldNotEmptyTip(String field) {
    return '$field cannot be empty';
  }

  @override
  String fieldFormatErrorTip(String field) {
    return '$field format is incorrect';
  }
}
