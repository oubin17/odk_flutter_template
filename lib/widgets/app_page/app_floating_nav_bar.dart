import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 浮动底部导航栏数据模型
class AppFloatingNavItem {
  /// 图标（未选中）
  final IconData icon;

  /// 图标（选中时，可选；不传则使用 [icon]）
  final IconData? activeIcon;

  /// 标签文字（可选，不传则只显示图标）
  final String? label;

  const AppFloatingNavItem({required this.icon, this.activeIcon, this.label});
}

/// 浮动底部导航栏
///
/// 悬浮在内容之上，不挤压 body 布局，支持毛玻璃/半透明效果。
/// **必须通过 [AppFloatingNavBar.wrap] 包裹页面内容**，不能用 Scaffold.bottomNavigationBar。
///
/// **使用示例：**
///
/// ```dart
/// // 在 build 方法中：
/// return AppFloatingNavBar.wrap(
///   context: context,
///   currentIndex: _currentIndex,
///   items: [
///     AppFloatingNavItem(icon: Icons.home, label: '首页'),
///     AppFloatingNavItem(icon: Icons.explore, label: '发现'),
///     AppFloatingNavItem(icon: Icons.person, label: '我的'),
///   ],
///   onTap: (index) => setState(() => _currentIndex = index),
///   child: IndexedStack(index: _currentIndex, children: _pages),
/// );
/// ```
class AppFloatingNavBar extends StatelessWidget {
  /// 当前选中索引
  final int currentIndex;

  /// 导航项列表
  final List<AppFloatingNavItem> items;

  /// 点击回调
  final ValueChanged<int> onTap;

  /// 选中时颜色（默认主色）
  final Color? selectedItemColor;

  /// 未选中时颜色（默认灰色）
  final Color? unselectedItemColor;

  /// 导航栏背景色（默认半透明白色，配合毛玻璃效果）
  final Color? backgroundColor;

  /// 圆角大小
  final double borderRadius;

  /// 水平边距
  final double horizontalMargin;

  /// 底部安全距离（默认自动适配底部安全区）
  final double? bottomPadding;

  /// 导航栏高度（不含底部安全距离）
  final double barHeight;

  /// 导航项内部垂直内边距
  final double itemVerticalPadding;

  /// 图标大小
  final double iconSize;

  /// 是否启用毛玻璃效果
  final bool enableBlur;

  /// 毛玻璃模糊程度（仅 [enableBlur] 为 true 时生效）
  final double blurSigma;

  /// 背景不透明度（0.0 完全透明 ~ 1.0 完全不透明）
  final double opacity;

  const AppFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.backgroundColor,
    this.borderRadius = 45,
    this.horizontalMargin = 24,
    this.bottomPadding,
    this.barHeight = 80,
    this.itemVerticalPadding = 10,
    this.iconSize = 65,
    this.enableBlur = true,
    this.blurSigma = 10,
    this.opacity = 0.85,
  });

  /// 便捷方法：用 Stack 将导航栏叠加在页面内容之上
  ///
  /// [child] 是页面的主体内容，导航栏会悬浮在底部，不挤压 child 的布局。
  static Widget wrap({
    required BuildContext context,
    required int currentIndex,
    required List<AppFloatingNavItem> items,
    required ValueChanged<int> onTap,
    required Widget child,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? backgroundColor,
    double borderRadius = 45,
    double horizontalMargin = 48,
    double? bottomPadding,
    double barHeight = 80,
    double itemVerticalPadding = 10,
    double iconSize = 68,
    bool enableBlur = true,
    double blurSigma = 10,
    double opacity = 0.85,
  }) {
    return Stack(
      children: [
        // 页面主体内容（占满全部空间）
        Positioned.fill(child: child),
        // 浮动导航栏（叠加在底部）
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AppFloatingNavBar(
            currentIndex: currentIndex,
            items: items,
            onTap: onTap,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            horizontalMargin: horizontalMargin,
            bottomPadding: bottomPadding,
            barHeight: barHeight,
            itemVerticalPadding: itemVerticalPadding,
            iconSize: iconSize,
            enableBlur: enableBlur,
            blurSigma: blurSigma,
            opacity: opacity,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = selectedItemColor ?? AppColors.primary(context);
    final unselectedColor = unselectedItemColor ?? AppColors.textGray(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 优化背景色：提高不透明度，让导航栏与页面内容有更明显的视觉分离
    final bgColor =
        backgroundColor ??
        (isDark
            ? const Color(0xFF1C1C1E).withAlpha(220)
            : Colors.white.withAlpha(220));

    // 边框颜色：亮色模式用浅灰边框，暗色模式用深灰边框
    final borderColor = isDark
        ? Colors.white.withAlpha(20)
        : Colors.black.withAlpha(8);

    // 底部安全距离
    final bottomSafe = bottomPadding ?? MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin.w),
      padding: EdgeInsets.only(bottom: bottomSafe + 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: enableBlur ? blurSigma : 0,
            sigmaY: enableBlur ? blurSigma : 0,
          ),
          child: Opacity(
            opacity: opacity,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: itemVerticalPadding.h),
              constraints: BoxConstraints(minHeight: barHeight.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius.w),
                // 优化1：增强阴影，让导航栏有更明显的悬浮感
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 24.w,
                    offset: Offset(0, 8.w),
                    spreadRadius: 2.w,
                  ),
                  // 添加一层更近的浅阴影，增加层次感
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 8.w,
                    offset: Offset(0, 2.w),
                  ),
                ],
                // 优化2：添加细边框，让导航栏轮廓更清晰
                border: Border.all(color: borderColor, width: 1.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;
                  final color = isSelected ? primaryColor : unselectedColor;

                  return _NavItemWidget(
                    item: item,
                    isSelected: isSelected,
                    color: color,
                    primaryColor: primaryColor,
                    iconSize: iconSize,
                    isDark: isDark,
                    onTap: () => onTap(index),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 单个导航项组件
class _NavItemWidget extends StatelessWidget {
  final AppFloatingNavItem item;
  final bool isSelected;
  final Color color;
  final Color primaryColor;
  final double iconSize;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.color,
    required this.primaryColor,
    required this.iconSize,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 优化3：选中项添加圆形高亮背景，增强视觉层次
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 8.w : 8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withAlpha(isDark ? 30 : 20)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                size: iconSize.w,
                color: color,
              ),
            ),
            if (item.label != null) ...[
              SizedBox(height: 2.h),
              // 优化4：选中项文字添加微动画 + 加粗
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isSelected ? 21.sp : 20.sp,
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  height: 1.2,
                ),
                child: Text(item.label!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
