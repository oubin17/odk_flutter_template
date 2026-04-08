import 'package:odk_flutter_template/routes/app_router.dart';

/// 全局导航管理工具
class NavigatorUtils {
  // 私有化构造，禁止实例化
  NavigatorUtils._();

  // 🔥 获取 GoRouter 全局导航状态（无 context 核心）
  // static NavigatorState? get _routerState => AppRouter.routerKey.currentState;

  // /// 全局导航 Key，用于在没有 Context 的地方进行跳转
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();

  // /// 获取当前的 Context
  // static BuildContext? get currentContext => navigatorKey.currentContext;

  // /// 获取当前的 State
  // static NavigatorState? get currentState => navigatorKey.currentState;

  // /// 跳转到欢迎页并清空路由栈
  // static void pushReplacementPage(Widget page) {
  //   _routerState?.pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => page),
  //     (route) => false,
  //   );
  // }

  /// 🔥 清空路由栈，跳转到 Splash（完全等价你原来的 pushAndRemoveUntil）
  static void pushReplacementSplash() {
    // ✅ 最正确、最简单的写法：直接调用路由实例
    AppRouter.router.go('/');
  }

  // 通用无 Context 跳转
  static void go(String path) {
    AppRouter.router.go(path);
  }

  static void pop() {
    AppRouter.router.pop();
  }
}
