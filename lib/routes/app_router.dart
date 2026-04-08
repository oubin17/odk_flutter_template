import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/features/auth/presentation/login_or_regist.dart';
import 'package:odk_flutter_template/features/home/presentation/home.dart';
import 'package:odk_flutter_template/features/splash/presentation/splash.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/pages/todo_detail.dart';
import 'package:odk_flutter_template/routes/pages/not_found.dart';
import 'package:provider/provider.dart';

// go 尝试在现有栈中找到与 location 匹配的路由，如果已存在，则 pop 回到该路由（丢弃之间的所有路由）；如果不存在，则 push 一个新路由。

//特点：避免重复添加相同页面，常用于底部导航栏切换（每个 tab 只保留一个实例）。
// push 始终在栈顶添加一个新路由，无论栈中是否已有相同页面。

//特点：不检查重复，每次调用都会新建页面实例。适合需要多层跳转的场景（例如从商品列表进入详情，再从详情进入更多详情）。
//pushReplacement replace 始终替换栈顶路由，无论栈中是否已有相同页面。
//pop() 返回上一个页面
class AppRouter {
  // 🔥 【新增】GoRouter 全局路由 Key（替代原生 navigatorKey）
  static final GlobalKey<NavigatorState> routerKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: routerKey,

    // 1. 初始页面（替代原生 initialRoute）
    initialLocation: '/',

    // 2. 🌍 全局路由守卫（核心：登录校验）
    redirect: (context, state) {
      final userProvider = context.read<UserProvider>();
      final isLoggedIn = userProvider.userEntity != null;

      final currentPath = state.uri.path;
      // 白名单页面：直接放行
      if (whiteList.contains(currentPath)) return null;

      // 非白名单 + 未登录 → 强制跳转到登录页，并携带目标页面
      if (!isLoggedIn) {
        // return '/login?target=$currentPath';
        return '/login';
      }
      // 已登录 → 正常跳转
      return null;
    },

    // 3. 404 页面（访问不存在路由时显示）
    errorBuilder: (context, state) => Scaffold(body: const NotFoundPage()),

    // 4. 路由表（替代原生 MaterialApp.routes）
    routes: [
      GoRoute(
        path: '/',
        name: 'Splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => const LoginOrRegistPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'Home',
        builder: (context, state) => const HomePage(),
      ),

      // 👉 带参数路由示例（后面讲传参）
      GoRoute(
        path: '/detail/:id', // 路径参数
        name: 'detail',
        builder: (context, state) =>
            TodoDetail(id: state.pathParameters['id']!),
      ),
    ],
  );

  /// 路由白名单
  static const List<String> whiteList = ['/', '/login', '/register'];
}
