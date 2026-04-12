import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/features/auth/presentation/signin.dart';
import 'package:odk_flutter_template/features/auth/presentation/signup.dart';
import 'package:odk_flutter_template/features/home/presentation/home.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/system_setting_page.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/pages/todo_detail.dart';
import 'package:odk_flutter_template/routes/pages/not_found.dart';
import 'package:provider/provider.dart';

// ====================== 路由名称常量类（已删除Splash） ======================
class RouteNames {
  // 已删除：splash

  static const String signup = 'Signup';
  static const String signin = 'Signin';
  static const String systemSetting = 'SystemSetting';
  static const String home = 'Home';
  static const String detail = 'detail';
  static const String notFound = 'NotFound';
}

// ====================== 路由路径常量（已删除Splash） ======================
class RoutePaths {
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String systemSetting = '/systemSetting';
  static const String themeSetting = '/themeSetting';
  static const String home = '/home';
  static const String detail = '/detail/:id';
  static const String notFound = '/notFound';
}

class AppRouter {
  static final GlobalKey<NavigatorState> routerKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: routerKey,
    // 🔥 核心1：初始路由设为根路径 /，由重定向自动决定跳首页/登录页
    initialLocation: '/',
    // 🔥 核心2：路由重定向（登录校验，完全替代Splash功能）
    redirect: (context, state) {
      final userProvider = context.read<UserProvider>();
      // 判断是否已登录（Token有效/用户信息存在）
      final isLoggedIn = userProvider.userEntity != null;
      final currentPath = state.uri.path;

      // 白名单页面（登录/注册）不拦截
      if (whiteList.contains(currentPath)) return null;

      // 根路径 / → 自动根据登录状态跳转
      if (currentPath == '/') {
        return isLoggedIn ? RoutePaths.home : RoutePaths.signin;
      }

      // 未登录 → 强制跳登录页
      if (!isLoggedIn) {
        return RoutePaths.signin;
      }

      // 已登录 → 正常访问
      return null;
    },

    errorBuilder: (context, state) => const Scaffold(body: NotFoundPage()),

    // 🔥 核心3：已删除 Splash 路由
    routes: [
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: RoutePaths.signin,
        name: RouteNames.signin,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.detail,
        name: RouteNames.detail,
        builder: (context, state) =>
            TodoDetail(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RoutePaths.systemSetting,
        name: RouteNames.systemSetting,
        builder: (context, state) => const SystemSettingPage(),
      ),
      GoRoute(
        path: RoutePaths.notFound,
        name: RouteNames.notFound,
        builder: (context, state) => const NotFoundPage(),
      ),
    ],
  );

  /// 路由白名单（已删除Splash，仅保留登录/注册）
  static const List<String> whiteList = [RoutePaths.signup, RoutePaths.signin];
}
