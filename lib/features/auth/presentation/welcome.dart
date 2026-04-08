// import 'package:flutter/material.dart';
// import 'package:odk_flutter_template/core/constants/images/app_images.dart';
// import 'package:odk_flutter_template/features/auth/presentation/login_or_regist.dart';

// class Welcome extends StatelessWidget {
//   const Welcome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 背景图片
//           Image.asset(
//             AppImages.splash,
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           // Container(color: Colors.black.withOpacity(0.3)),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
//             child: Column(
//               children: [
//                 const SizedBox(height: 200),
//                 // const Center(
//                 //   child: Text(
//                 //     '禄仕管理系统',
//                 //     style: TextStyle(
//                 //       fontSize: 30,
//                 //       color: Color.fromARGB(255, 12, 178, 189),
//                 //       fontWeight: FontWeight.bold,
//                 //     ),
//                 //   ),
//                 // ),
//                 const Spacer(),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       // 执行跳转
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LoginOrRegistPage(),
//                         ),
//                       );
//                     },
//                     child: const Icon(
//                       Icons.login,
//                       size: 40,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
