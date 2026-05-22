import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/cache/app_cache_manager.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/providers/locale/locale_provider.dart';
import 'package:odk_flutter_template/providers/theme/theme_provider.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:provider/provider.dart';

class CommonSettingPage extends StatefulWidget {
  const CommonSettingPage({super.key});

  @override
  State<CommonSettingPage> createState() => _CommonSettingPageState();
}

class _CommonSettingPageState extends State<CommonSettingPage> {
  String _cacheSize = '';

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  /// 加载缓存大小
  Future<void> _loadCacheSize() async {
    final size = await AppCacheManager.getCacheSizeFormatted();
    if (mounted) {
      setState(() {
        _cacheSize = size;
      });
    }
  }

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
                left: AppIcon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
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
                left: const AppIcon(Icons.language_outlined),
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
            left: const AppIcon(Icons.cleaning_services_outlined),
            title: L10nUtils.clearCache,
            desc: _cacheSize.isNotEmpty
                ? '${L10nUtils.cacheSize}: $_cacheSize'
                : '${L10nUtils.cacheSize}: --',
            showArrow: false,
            onTap: () => _clearCache(context),
          ),
          const AppDivider(padding: 30),
        ],
      ),
    );
  }

  /// 清理缓存
  void _clearCache(BuildContext context) {
    AppToast.showAppConfirmDialog(
      title: L10nUtils.clearCache,
      msg: L10nUtils.clearCacheConfirm,
      onConfirm: () async {
        try {
          // 清理图片缓存（CachedNetworkImage）+ 临时目录
          await AppCacheManager.clearCache();
          // 刷新缓存大小显示
          await _loadCacheSize();
          AppToast.showNotify(L10nUtils.clearCacheSuccess, null);
        } catch (e) {
          AppToast.showToast(L10nUtils.operationFailed);
        }
      },
    );
  }
}
