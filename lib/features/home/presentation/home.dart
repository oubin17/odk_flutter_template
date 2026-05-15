import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/content/presentation/content_page.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/first_index.dart';
import 'package:odk_flutter_template/features/mine/presentation/profile_page.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

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
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        // 1. 核心：设置选中时的颜色
        selectedItemColor: AppColors.primary(context),

        // 2. 核心：设置未选中时的颜色
        unselectedItemColor: Colors.grey,

        // 3. 关键：固定模式，确保未选中时也显示文字
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: L10nUtils.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: L10nUtils.discover,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: L10nUtils.mine,
          ),
        ],
      ),
    );
  }
}
