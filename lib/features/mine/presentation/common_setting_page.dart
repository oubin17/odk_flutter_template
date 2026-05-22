import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/storage/storage_manager.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/providers/locale/locale_provider.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
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

          // 缓存清理
          AppListItem(
            left: Icon(
              Icons.cleaning_services_outlined,
              color: AppColors.textSecond(context),
            ),
            title: L10nUtils.clearCache,
            desc: _getCacheSize(),
            showArrow: false,
            onTap: () => _clearCache(context),
          ),
          const AppDivider(padding: 30),
        ],
      ),
    );
  }

  /// 获取缓存大小（简化版，实际项目中可计算临时目录大小）
  String _getCacheSize() {
    // TODO: 实际项目中可以通过遍历临时目录计算缓存大小
    // 这里提供一个简化实现
    try {
      // 简化：返回一个占位文本，实际应计算
      return '${L10nUtils.cacheSize}: --';
    } catch (e) {
      return '';
    }
  }

  /// 清理缓存
  void _clearCache(BuildContext context) {
    AppToast.showAppConfirmDialog(
      title: L10nUtils.clearCache,
      msg: L10nUtils.clearCacheConfirm,
      onConfirm: () async {
        try {
          // 清理 SharedPreferences 中的非关键数据
          // 注意：不清除 token、用户信息等关键数据
          await StorageManager().remove('cache_data');
          // TODO: 清理图片缓存（cached_network_image）
          // TODO: 清理 WebView 缓存
          // TODO: 清理临时目录文件
          AppToast.showNotify(L10nUtils.clearCacheSuccess, null);
        } catch (e) {
          AppToast.showToast(L10nUtils.operationFailed);
        }
      },
    );
  }
}
