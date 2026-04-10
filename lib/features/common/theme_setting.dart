import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      appBar: AppBar(
        backgroundColor: AppColors.primary(context),
        title: AppText.title("主题设置", color: AppColors.textWhite),
        toolbarHeight: 88.h,
      ),
      body: ListView(
        padding: EdgeInsets.all(30.w),
        children: [
          AppCard(
            child: Column(
              children: [
                _themeItem(context, "日间模式", ThemeModeType.light, themeProvider),
                Divider(height: 1.h, color: AppColors.divider(context)),
                _themeItem(context, "夜间模式", ThemeModeType.dark, themeProvider),
                Divider(height: 1.h, color: AppColors.divider(context)),
                _themeItem(
                  context,
                  "跟随系统",
                  ThemeModeType.system,
                  themeProvider,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 主题选项
  Widget _themeItem(
    BuildContext context,
    String title,
    ThemeModeType mode,
    ThemeProvider provider,
  ) {
    return ListTile(
      title: AppText.body(title),
      trailing: provider.themeMode == mode
          ? Icon(Icons.check, color: AppColors.primary(context))
          : null,
      onTap: () => provider.changeTheme(mode),
    );
  }
}
