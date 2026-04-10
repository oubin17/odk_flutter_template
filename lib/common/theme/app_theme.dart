import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // ------------------- 通用配置 -------------------
  // 主主题色（你可以随意修改！）
  static const Color primaryColor = Color(0xFF407BFF);
  static const Color primaryDarkColor = Color(0xFF6495ED);

  // 圆角统一
  static final double radius = 16.w;

  // ------------------- 亮色主题 -------------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFF2F3F5),
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
      ),
    ),
    // 文字主题
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 28.sp, color: const Color(0xFF1D2129)),
      bodyMedium: TextStyle(fontSize: 26.sp, color: const Color(0xFF4E5969)),
    ),
  );

  // ------------------- 暗色主题 -------------------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDarkColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: const Color(0xFF2C2C2C),
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDarkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
      ),
    ),
  );
}
