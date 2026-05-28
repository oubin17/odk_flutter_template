import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 毛玻璃底部导航栏数据模型
class AppGlassBottomBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badge;

  const AppGlassBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });
}

/// 毛玻璃风格底部导航栏
///
/// iOS 26 Liquid Glass 风格：滑动药丸 + 毛玻璃背景，适配项目主题色和明暗模式。
class AppGlassBottomBar extends StatelessWidget {
  final List<AppGlassBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 导航栏高度（不含底部安全距离）
  final double height;

  /// 外边距
  final EdgeInsetsGeometry margin;

  /// 是否显示标签文字
  final bool showLabels;

  /// 选中时颜色（默认项目主色）
  final Color? activeColor;

  /// 未选中时颜色
  final Color? inactiveColor;

  /// 导航栏背景模糊强度
  final double barBlurSigma;

  /// 激活药丸模糊强度
  final double pillBlurSigma;

  const AppGlassBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 80,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 8),
    this.showLabels = true,
    this.activeColor,
    this.inactiveColor,
    this.barBlurSigma = 20,
    this.pillBlurSigma = 28,
  }) : assert(items.length >= 2, 'At least 2 items are required.');

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomSafe = media.padding.bottom * 0.35;

    final effectiveActiveColor = activeColor ?? AppColors.primary(context);
    final effectiveInactiveColor =
        inactiveColor ??
        (isDark ? Colors.white.withAlpha(140) : Colors.black.withAlpha(140));

    // 背景色
    final barBgColor = isDark
        ? const Color(0xFF2C2C2E).withAlpha(220)
        : Colors.white.withAlpha(240);

    // 药丸背景色
    final pillBgColor = isDark
        ? Colors.white.withAlpha(15)
        : effectiveActiveColor.withAlpha(18);

    // 药丸高亮渐变
    final pillHighlightTop = isDark
        ? Colors.white.withAlpha(30)
        : Colors.white.withAlpha(80);

    final barH = height.h;

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin.add(EdgeInsets.only(bottom: bottomSafe)),
        child: SizedBox(
          height: barH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(barH / 2),
            child: Stack(
              children: [
                // 毛玻璃背景
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: barBlurSigma,
                        sigmaY: barBlurSigma,
                      ),
                      child: Container(color: barBgColor),
                    ),
                  ),
                ),

                // 阴影
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 60 : 30),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 滑动药丸
                _SlidingPill(
                  items: items,
                  currentIndex: currentIndex,
                  barHeight: barH,
                  blurSigma: pillBlurSigma,
                  showLabels: showLabels,
                  pillBgColor: pillBgColor,
                  highlightTop: pillHighlightTop,
                ),

                // 导航项
                Row(
                  children: List.generate(items.length, (i) {
                    final it = items[i];
                    final selected = i == currentIndex;
                    final iconColor = selected
                        ? effectiveActiveColor
                        : effectiveInactiveColor;
                    final textColor = selected
                        ? effectiveActiveColor
                        : (isDark
                              ? Colors.white.withAlpha(180)
                              : Colors.black.withAlpha(160));

                    return Expanded(
                      child: InkWell(
                        onTap: () => onTap(i),
                        customBorder: const StadiumBorder(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AppIcon(
                                    selected
                                        ? (it.activeIcon ?? it.icon)
                                        : it.icon,
                                    size: 36.w,
                                    color: iconColor,
                                  ),
                                  if ((it.badge ?? 0) > 0)
                                    Positioned(
                                      right: -8.w,
                                      top: -6.h,
                                      child: _Badge(count: it.badge!),
                                    ),
                                ],
                              ),
                              if (showLabels) ...[
                                AppGap.h(2),
                                AppText(
                                  it.label,
                                  size: selected ? 18.sp : 17.sp,
                                  weight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: textColor,
                                  maxLines: 1,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 滑动药丸指示器
class _SlidingPill extends StatelessWidget {
  final List<AppGlassBottomBarItem> items;
  final int currentIndex;
  final double barHeight;
  final double blurSigma;
  final bool showLabels;
  final Color pillBgColor;
  final Color highlightTop;

  const _SlidingPill({
    required this.items,
    required this.currentIndex,
    required this.barHeight,
    required this.blurSigma,
    required this.showLabels,
    required this.pillBgColor,
    required this.highlightTop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final slots = items.length;
        final slotW = c.maxWidth / slots;
        final vPad = showLabels ? 1.0 : 0.5;
        final pillH = barHeight - vPad * 2;

        // 药丸宽度：尽量填满 slot，只留极小边距
        final pillMargin = 2.0;
        final pillW = slotW - pillMargin * 2;

        final left = slotW * currentIndex + pillMargin;

        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              left: left,
              top: vPad,
              width: pillW,
              height: pillH,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(pillH / 2),
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blurSigma,
                          sigmaY: blurSigma,
                        ),
                        child: const SizedBox.expand(),
                      ),
                      Container(color: pillBgColor),
                      IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [highlightTop, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 角标组件
class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(235),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.white.withAlpha(200), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 6.w,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
