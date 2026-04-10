import 'package:flutter/foundation.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';

enum ThemeModeType { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.system;

  bool get isDarkMode => _themeMode == ThemeModeType.dark;

  ThemeModeType get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  Future<void> _loadThemeFromStorage() async {
    final themeMode = StorageManager().getString(StorageKey.themeMode);
    if (themeMode != null) {
      _themeMode = ThemeModeType.values.firstWhere(
        (element) => element.toString() == themeMode,
        orElse: () => ThemeModeType.light,
      );
    } else {
      _themeMode = ThemeModeType.light;
    }
    notifyListeners();
  }

  void changeTheme(ThemeModeType themeMode) {
    _themeMode = themeMode;
    //持久化存储
    StorageManager().setString(StorageKey.themeMode, themeMode.name);
    notifyListeners();
  }
}
