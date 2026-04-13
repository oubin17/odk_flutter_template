import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/first_index.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/private_resume_page.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/profile_page.dart';
import 'package:odk_flutter_template/features/home/presentation/pages/resume_library.dart';
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
    const PrivateResumePage(),
    const ResumeLibraryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.private_connectivity),
            label: '私有库',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: '简历库',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
