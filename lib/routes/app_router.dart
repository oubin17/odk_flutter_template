import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/features/auth/presentation/login_or_regist.dart';
import 'package:odk_flutter_template/features/auth/presentation/signin.dart';
import 'package:odk_flutter_template/features/auth/presentation/signup.dart';
import 'package:odk_flutter_template/features/home/presentation/home.dart';
import 'package:odk_flutter_template/features/splash/presentation/splash.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/pages/todo_detail.dart';
import 'package:odk_flutter_template/routes/pages/not_found.dart';
import 'package:provider/provider.dart';

// ====================== 【核心新增】路由名称常量类 ======================
// 全局统一管理所有路由 name，杜绝硬编码
class RouteNames {
  static const String splash = 'Splash';
  static const String signup = 'Signup';
  static const String signin = 'Signin';

  static const String login = 'Login';
  static const String home = 'Home';
  static const String detail = 'detail';
}

// ====================== 路由路径常量（可选，推荐一起抽离） ======================
class RoutePaths {
  static const String splash = '/';
  static const String signup = '/signup';
  static const String signin = '/signin';

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail/:id';
}

class AppRouter {
  static final GlobalKey<NavigatorState> routerKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: routerKey,
    initialLocation: RoutePaths.splash, // 使用常量
    redirect: (context, state) {
      final userProvider = context.read<UserProvider>();
      final isLoggedIn = userProvider.userEntity != null;

      final currentPath = state.uri.path;
      if (whiteList.contains(currentPath)) return null;

      if (!isLoggedIn) {
        return RoutePaths.login; // 使用常量
      }
      return null;
    },

    errorBuilder: (context, state) => const Scaffold(body: NotFoundPage()),

    routes: [
      GoRoute(
        path: RoutePaths.splash, // 常量路径
        name: RouteNames.splash, // 常量名称 ✅
        builder: (context, state) => const SplashPage(),
      ),
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
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginOrRegistPage(),
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
    ],
  );

  /// 路由白名单（使用常量）
  static const List<String> whiteList = [
    RoutePaths.splash,
    RoutePaths.signup,
    RoutePaths.signin,
  ];
}
