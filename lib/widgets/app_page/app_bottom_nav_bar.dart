import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// Scaffold 自带底部导航栏
///
/// 占满底部宽度，通过 [Scaffold.bottomNavigationBar] 传入使用。
/// 与 [AppFloatingNavBar] 风格一致，方便在两种导航栏之间切换。
///
/// **使用示例：**
///
/// ```dart
/// bottomNavigationBar: AppBottomNavBar(
///   currentIndex: _currentIndex,
///   items: [
///     AppBottomNavItem(icon: Icons.home, label: '首页'),
///     AppBottomNavItem(icon: Icons.explore, label: '发现'),
///     AppBottomNavItem(icon: Icons.person, label: '我的'),
///   ],
///   onTap: (index) => setState(() => _currentIndex = index),
/// ),
/// ```
class AppBottomNavBar extends StatelessWidget {
  /// 当前选中索引
  final int currentIndex;

  /// 导航项列表
  final List<AppBottomNavItem> items;

  /// 点击回调
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary(context);
    final unselectedColor = AppColors.textGray(context);
    final bgColor = AppColors.card(context).withValues(alpha: 0.85);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(20),
        //     blurRadius: 12.w,
        //     offset: Offset(0, -2.w),
        //   ),
        // ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: MediaQuery.of(context).padding.bottom + 5.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;
            final color = isSelected ? primaryColor : unselectedColor;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      size: 48.w,
                      color: color,
                    ),
                    if (item.label != null) ...[
                      AppGap.h(4),
                      AppText(
                        item.label!,
                        size: 20.sp,
                        color: color,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Scaffold 底部导航栏数据模型
class AppBottomNavItem {
  /// 图标（未选中）
  final IconData icon;

  /// 图标（选中时，可选；不传则使用 [icon]）
  final IconData? activeIcon;

  /// 标签文字（可选，不传则只显示图标）
  final String? label;

  const AppBottomNavItem({required this.icon, this.activeIcon, this.label});
}
