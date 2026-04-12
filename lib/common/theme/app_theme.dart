import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // ===================== 【核心：成组主题色板】 =====================
  /// 一、主色系列（梯度分组：超浅 → 浅 → 主色 → 深 → 超深）
  /// 亮色主题 主色组
  static const Color _lightPrimary50 = Color(0xFFE8F0FF); // 超浅（背景/标签）
  static const Color _lightPrimary100 = Color(0xFFC6D8FF); // 浅（边框/线条）
  static const Color _lightPrimary = Color(0xFF407BFF); // 主色（按钮/强调）
  static const Color _lightPrimary700 = Color(0xFF3366CC); // 深（按压态）
  static const Color _lightPrimary900 = Color(0xFF254D99); // 超深（文字强调）

  /// 暗色主题 主色组
  static const Color _darkPrimary50 = Color(0xFF1E2A47); // 超浅（背景）
  static const Color _darkPrimary100 = Color(0xFF354975); // 浅（边框）
  static const Color _darkPrimary = Color(0xFF6495ED); // 主色
  static const Color _darkPrimary700 = Color(0xFF8CB5FF); // 深
  static const Color _darkPrimary900 = Color(0xFFADC8FF); // 超浅

  /// 二、背景色组（页面/卡片/悬浮）
  static const Color _lightBgPage = Color(0xFFF7F8FA);
  static const Color _lightBgCard = Colors.white;
  static const Color _darkBgPage = Color(0xFF121212);
  static const Color _darkBgCard = Color(0xFF1E1E1E);

  /// 三、分割线组
  static const Color _lightDivider = Color(0xFFF2F3F5);
  static const Color _darkDivider = Color(0xFF2C2C2C);

  /// 四、文字色组（主/次/提示/禁用）
  static const Color _lightTextMain = Color(0xFF1D2129);
  static const Color _lightTextSecond = Color(0xFF4E5969);
  // static const Color _lightTextGray = Color(0xFF86909C);
  static const Color _darkTextMain = Color(0xFFFFFFFF);
  static const Color _darkTextSecond = Color(0xFFE0E0E0);
  // static const Color _darkTextGray = Color(0xFF909090);

  // ===================== 全局通用配置 =====================
  // 统一圆角
  static final double radius = 16.w;

  // ===================== 对外暴露：根据主题模式获取对应色组 =====================
  // 主色
  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? _lightPrimary
      : _darkPrimary;

  // 主色-浅（用于：标签背景、头像背景、弱强调）
  static Color primaryLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? _lightPrimary100
      : _darkPrimary100;

  // 主色-超浅（用于：最淡背景、悬浮背景）
  static Color primary50(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? _lightPrimary50
      : _darkPrimary50;

  // 主色-深（用于：按钮按压、文字强调）
  static Color primaryDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? _lightPrimary700
      : _darkPrimary700;

  // 主色-超深（用于：文字强调、图标强调）
  static Color primaryDeepDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? _lightPrimary900
      : _darkPrimary900;
  // ===================== 亮色主题 =====================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    scaffoldBackgroundColor: _lightBgPage,
    cardColor: _lightBgCard,
    dividerColor: _lightDivider,
    // 按钮样式
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
      ),
    ),
    // 文字样式
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 28.sp, color: _lightTextMain),
      bodyMedium: TextStyle(fontSize: 26.sp, color: _lightTextSecond),
    ),
    fontFamily: 'AlibabaPuHuiTi',
  );

  // ===================== 暗色主题 =====================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    scaffoldBackgroundColor: _darkBgPage,
    cardColor: _darkBgCard,
    dividerColor: _darkDivider,
    // 按钮样式
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
      ),
    ),
    // 文字样式
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 28.sp, color: _darkTextMain),
      bodyMedium: TextStyle(fontSize: 26.sp, color: _darkTextSecond),
    ),
    fontFamily: 'AlibabaPuHuiTi',
  );
}
