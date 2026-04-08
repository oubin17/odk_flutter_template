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

  // 通用无 Context 跳转
  static void go(String path) {
    AppRouter.router.go(path);
  }

  // 2. 新增：name 跳转 ✅
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    AppRouter.router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  // 3. 新增：替换跳转（登录→首页专用）
  static void pushReplacementNamed(String name) {
    AppRouter.router.pushReplacementNamed(name);
  }

  // 4. 新增：普通跳转
  static void push(String path) {
    AppRouter.router.push(path);
  }

  // 5. 新增：返回
  static void pop() {
    AppRouter.router.pop();
  }
}
