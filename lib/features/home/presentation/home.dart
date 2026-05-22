import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/content/presentation/content_page.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/first_index.dart';
import 'package:odk_flutter_template/features/mine/presentation/profile_page.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bottom_nav_bar.dart';
import 'package:odk_flutter_template/widgets/app_page/app_floating_nav_bar.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FirstIndexPage(),
    const ContentPage(),
    const ContentPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      padding: EdgeInsets.zero,

      /// 使用 Scaffold 自带的底部导航栏
      // body: IndexedStack(index: _currentIndex, children: _pages),
      // bottomNavigationBar: AppBottomNavBar(
      //   currentIndex: _currentIndex,
      //   items: [
      //     AppBottomNavItem(icon: Icons.home, label: L10nUtils.home),
      //     AppBottomNavItem(icon: Icons.explore, label: L10nUtils.discover),
      //     AppBottomNavItem(icon: Icons.explore, label: L10nUtils.discover),
      //     AppBottomNavItem(icon: Icons.person, label: L10nUtils.mine),
      //   ],
      //   onTap: (index) => setState(() => _currentIndex = index),
      // ),

      /// 使用自定义的浮动底部导航栏（需要将 body 包裹在 AppFloatingNavBar.wrap 中）
      body: AppFloatingNavBar.wrap(
        context: context,
        currentIndex: _currentIndex,
        items: [
          AppFloatingNavItem(
            icon: Icons.home,
            label: L10nUtils.of(context).home,
          ),
          AppFloatingNavItem(
            icon: Icons.explore,
            label: L10nUtils.of(context).discover,
          ),
          AppFloatingNavItem(
            icon: Icons.explore,
            label: L10nUtils.of(context).discover,
          ),
          AppFloatingNavItem(
            icon: Icons.person,
            label: L10nUtils.of(context).mine,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
    );
  }
}
