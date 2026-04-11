// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
// import 'package:odk_flutter_template/gen/assets.gen.dart';
// import 'package:odk_flutter_template/routes/app_router.dart';
// import 'package:odk_flutter_template/routes/navigator_utils.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({super.key});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   bool fromOtherPage = false;
//   bool _isRedirected = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final params = GoRouterState.of(context).uri.queryParameters;
//     fromOtherPage = params['fromOtherPage'] == 'true';

//     if (!_isRedirected) {
//       _isRedirected = true;
//       _redirect(fromOtherPage);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // 🔥 1. 背景色和原生完全一致
//       // backgroundColor: const Color(0xFFFFFFFF),
//       body: Image.asset(
//         Assets.logo.path,
//         width: 1.sw,
//         height: 1.sh,
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   Future<void> _redirect(bool fromOtherPage) async {
//     await Future.delayed(const Duration(seconds: 1));
//     if (fromOtherPage) {
//       NavigatorUtils.goNamed(RouteNames.signin);
//       return;
//     }
//     final isLogged = await AuthService().checkLoggedIn();
//     if (isLogged) {
//       NavigatorUtils.goNamed(RouteNames.home);
//     } else {
//       NavigatorUtils.goNamed(RouteNames.signin);
//     }
//   }
// }
