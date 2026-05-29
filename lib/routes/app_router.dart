import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/features/aichat/presentation/ai_chat_page.dart'
    show AiChatPage, AiChatPageTransition;
import 'package:odk_flutter_template/features/auth/presentation/signin.dart';
import 'package:odk_flutter_template/features/auth/presentation/signup.dart';
import 'package:odk_flutter_template/features/content/presentation/content_detail_page.dart';
import 'package:odk_flutter_template/features/home/presentation/home.dart';
import 'package:odk_flutter_template/features/mine/presentation/about_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/common_setting_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/delete_account_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/feedback_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/password_manager_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/security_setting_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/system_setting_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/user_info_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/user_info_update_page.dart';
import 'package:odk_flutter_template/features/mine/presentation/version_info_page.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/widgets/app_webview/agreement_page.dart';
import 'package:odk_flutter_template/widgets/app_status/not_found.dart';
import 'package:provider/provider.dart';

// ====================== 路由名称常量类（已删除Splash） ======================
class RouteNames {
  // 已删除：splash

  static const String signup = 'Signup';
  static const String signin = 'Signin';
  static const String userInfo = 'UserInfo';
  static const String userInfoUpdate = 'UserInfoUpdate';
  static const String systemSetting = 'SystemSetting';
  static const String commonSetting = 'CommonSetting';
  static const String securitySetting = 'SecuritySetting';
  static const String passwordManager = 'PasswordManager';
  static const String versionInfo = 'VersionInfo';
  static const String home = 'Home';
  static const String aiChat = 'AiChat';
  static const String contentDetail = 'contentDetail';
  static const String notFound = 'NotFound';
  static const String agreement = 'Agreement';
  static const String deleteAccount = 'DeleteAccount';
  static const String about = 'About';
  static const String feedback = 'Feedback';
}

// ====================== 路由路径常量（已删除Splash） ======================
class RoutePaths {
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String userInfo = '/userInfo';
  static const String userInfoUpdate = '/userInfoUpdate';
  static const String systemSetting = '/systemSetting';
  static const String commonSetting = '/commonSetting';
  static const String securitySetting = '/securitySetting';
  static const String passwordManager = '/passwordManager';
  static const String versionInfo = '/version';
  static const String home = '/home';
  static const String aiChat = '/aiChat';
  static const String contentDetail = '/contentDetail';
  static const String notFound = '/notFound';
  static const String agreement = '/agreement';
  static const String deleteAccount = '/deleteAccount';
  static const String about = '/about';
  static const String feedback = '/feedback';
}

class AppRouter {
  static final GlobalKey<NavigatorState> routerKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: routerKey,
    // 注册 SmartDialog 观察者，除了在 builder 中初始化 FlutterSmartDialog.init() 外， 必须 在路由配置中注册 FlutterSmartDialog.observer 。如果没有这个观察者，插件无法正确感知页面层级和生命周期，导致 Overlay 弹窗无法正常渲染。
    observers: [FlutterSmartDialog.observer],
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
        path: RoutePaths.aiChat,
        name: RouteNames.aiChat,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AiChatPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AiChatPageTransition(animation: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
      GoRoute(
        path: RoutePaths.contentDetail,
        name: RouteNames.contentDetail,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return ContentDetailPage(id: id);
        },
      ),
      GoRoute(
        path: RoutePaths.userInfo,
        name: RouteNames.userInfo,
        builder: (context, state) => const UserInfoPage(),
      ),
      GoRoute(
        path: RoutePaths.versionInfo,
        name: RouteNames.versionInfo,
        builder: (context, state) => const VersionInfoPage(),
      ),
      GoRoute(
        path: RoutePaths.userInfoUpdate,
        name: RouteNames.userInfoUpdate,
        builder: (context, state) {
          // 从 queryParameters 取参数（不是 pathParameters）
          final title = state.uri.queryParameters['title'] ?? '用户信息更新';
          final value = state.uri.queryParameters['value'] ?? '';
          final typeIndex = state.uri.queryParameters['type'];

          // 安全解析枚举，防止报错
          late UserInfoUpdateType type;
          if (typeIndex != null && int.tryParse(typeIndex) != null) {
            type = UserInfoUpdateType.values[int.parse(typeIndex)];
          } else {
            type = UserInfoUpdateType.nickname; // 默认值
          }

          return UserInfoUpdatePage(title: title, value: value, type: type);
        },
      ),
      GoRoute(
        path: RoutePaths.systemSetting,
        name: RouteNames.systemSetting,
        builder: (context, state) => const SystemSettingPage(),
      ),
      GoRoute(
        path: RoutePaths.commonSetting,
        name: RouteNames.commonSetting,
        builder: (context, state) => const CommonSettingPage(),
      ),
      GoRoute(
        path: RoutePaths.securitySetting,
        name: RouteNames.securitySetting,
        builder: (context, state) => const SecuritySettingPage(),
      ),
      GoRoute(
        path: RoutePaths.passwordManager,
        name: RouteNames.passwordManager,
        builder: (context, state) {
          // 从 queryParameters 取参数（不是 pathParameters）
          final title = state.uri.queryParameters['title'] ?? '密码管理';
          final typeIndex = state.uri.queryParameters['type'];

          // 安全解析枚举，防止报错
          late PasswordManagerType type;
          if (typeIndex != null && int.tryParse(typeIndex) != null) {
            type = PasswordManagerType.values[int.parse(typeIndex)];
          } else {
            type = PasswordManagerType.set; // 默认值
          }
          return PasswordManagerPage(title: title, type: type);
        },
      ),
      GoRoute(
        path: RoutePaths.agreement,
        name: RouteNames.agreement,
        builder: (context, state) {
          // 接收路由传递的标题和链接
          // final title = state.uri.queryParameters['title'] ?? '协议';
          final url = state.uri.queryParameters['url'] ?? '';
          return AgreementPage(title: "", url: url);
        },
      ),
      GoRoute(
        path: RoutePaths.deleteAccount,
        name: RouteNames.deleteAccount,
        builder: (context, state) => const DeleteAccountPage(),
      ),
      GoRoute(
        path: RoutePaths.about,
        name: RouteNames.about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: RoutePaths.feedback,
        name: RouteNames.feedback,
        builder: (context, state) => const FeedbackPage(),
      ),
      GoRoute(
        path: RoutePaths.notFound,
        name: RouteNames.notFound,
        builder: (context, state) => const NotFoundPage(),
      ),
    ],
  );

  /// 路由白名单（已删除Splash，仅保留登录/注册）
  static const List<String> whiteList = [
    RoutePaths.signup,
    RoutePaths.signin,
    RoutePaths.agreement,
  ];
}
