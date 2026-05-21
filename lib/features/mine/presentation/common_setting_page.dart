import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/providers/locale/locale_provider.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class CommonSettingPage extends StatelessWidget {
  const CommonSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.commonSetting),
      body: ListView(
        children: [
          // 主题切换 + 图标
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final currentMode = themeProvider.isDarkMode
                  ? L10nUtils.darkMode
                  : L10nUtils.lightMode;
              return AppListItem(
                left: themeProvider.isDarkMode
                    ? Icon(
                        Icons.dark_mode_outlined,
                        color: AppColors.textSecond(context),
                      )
                    : Icon(
                        Icons.light_mode_outlined,
                        color: AppColors.textSecond(context),
                      ),
                title: L10nUtils.themeMode,
                desc: currentMode,
                showArrow: false,
                onTap: () {
                  themeProvider.changeTheme(
                    themeProvider.isDarkMode
                        ? ThemeModeType.light
                        : ThemeModeType.dark,
                  );
                },
              );
            },
          ),
          const AppDivider(padding: 30),

          Consumer<LocaleProvider>(
            builder: (context, localProvider, child) {
              return AppListItem(
                left: localProvider.isEnglish
                    ? Icon(
                        Icons.language_outlined,
                        color: AppColors.textSecond(context),
                      )
                    : Icon(
                        Icons.language_outlined,
                        color: AppColors.textSecond(context),
                      ),
                title: L10nUtils.switchLanguage,
                desc: L10nUtils.language,
                showArrow: false,
                onTap: () {
                  localProvider.changeLanguage(
                    Locale(
                      localProvider.isEnglish
                          ? LocaleType.zh.name
                          : LocaleType.en.name,
                    ),
                  );
                },
              );
            },
          ),
          const AppDivider(padding: 30),
        ],
      ),
    );
  }
}
