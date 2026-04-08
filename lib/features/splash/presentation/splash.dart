import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool fromOtherPage = false;
  // 防止重复执行跳转
  bool _isRedirected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 上下文已就绪，安全获取路由参数
    final params = GoRouterState.of(context).uri.queryParameters;
    fromOtherPage = params['fromOtherPage'] == 'true';

    // 只执行一次跳转
    if (!_isRedirected) {
      _isRedirected = true;
      _redirect(fromOtherPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppImages.splash,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Future<void> _redirect(bool fromOtherPage) async {
    await Future.delayed(const Duration(seconds: 2));
    if (fromOtherPage) {
      NavigatorUtils.go('/login');
      return;
    }
    final isLogged = await AuthService().checkLoggedIn();
    if (isLogged) {
      NavigatorUtils.go('/home');
    } else {
      NavigatorUtils.go('/login');
    }
  }
}
