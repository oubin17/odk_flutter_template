import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/common/app_info/global_info.dart';
import 'package:odk_flutter_template/core/utils/version_utils.dart';
import 'package:odk_flutter_template/features/mine/service/version_check_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/features/mine/models/app_version/app_version_info.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/mixins/mounted_safe_mixin.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

class VersionInfoPage extends StatefulWidget {
  const VersionInfoPage({super.key});

  @override
  State<VersionInfoPage> createState() => _VersionInfoPageState();
}

class _VersionInfoPageState extends State<VersionInfoPage>
    with MountedSafeMixin {
  final _globalInfo = GlobalInfo.instance;

  // 版本更新相关状态
  bool _isChecking = true; // 是否正在检查更新
  bool _hasUpdate = false; // 是否有新版本
  AppVersionInfo? _latestVersion; // 最新版本信息

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  /// 检查版本更新
  Future<void> _checkUpdate() async {
    // 同步操作，此时 Widget 一定还是 mounted 的，直接 setState 即可
    setState(() {
      _isChecking = true;
    });

    try {
      final result = await VersionCheckService().checkUpdate();
      // await 之后 Widget 可能已销毁，需要安全检查
      mountedSafeSetState(() {
        _isChecking = false;
        _hasUpdate = result.hasUpdate;
        _latestVersion = result.latestVersion;
      });
    } catch (e) {
      mountedSafeSetState(() {
        _isChecking = false;
        _hasUpdate = false;
      });
    }
  }

  /// 点击更新按钮，跳转到应用市场
  Future<void> _onUpdateTap() async {
    if (_latestVersion == null) return;

    final success = await VersionCheckService().goToUpdate(
      _latestVersion!,
      packageName: _globalInfo.packageName,
    );

    if (!success) {
      // 如果跳转失败，尝试使用工具类直接跳转
      final fallbackSuccess = await VersionUtils.launchAppStore(
        androidUrl: _latestVersion!.androidUrl,
        iosUrl: _latestVersion!.iosUrl,
      );
      if (!fallbackSuccess) {
        mountedSafeCallback(() {
          AppToast.showNotify(
            L10nUtils.cannotOpenAppStore,
            null,
            notifyType: NotifyType.warning,
          );
        });
      }
    }
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.second(label),
          Flexible(child: AppText.second(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.versionInfo),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              AppGap.hXL,
              // 应用图标
              AppAvatar(
                assetPath: Assets.images.launcherIcon.launcher.path,
                size: 160,
                shape: AppAvatarShape.rounded,
                borderRadius: 24,
              ),
              AppGap.hNormal,
              // 应用名称
              AppText(
                _globalInfo.appName,
                size: 36.sp,
                weight: FontWeight.w600,
              ),
              AppGap.hSuperSmall,
              // 版本号
              AppText.second(
                'v${_globalInfo.appVersion} (${_globalInfo.appBuild})',
              ),
              AppGap.hNormal,

              // 版本详情卡片
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: AppCard(
                  showShadow: false,
                  bg: AppColors.card(context),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        label: L10nUtils.appName,
                        value: _globalInfo.appName,
                      ),
                      const AppDivider(padding: 0),
                      _buildInfoRow(
                        context,
                        label: L10nUtils.packageName,
                        value: _globalInfo.packageName,
                      ),
                      const AppDivider(padding: 0),
                      _buildInfoRow(
                        context,
                        label: L10nUtils.versionNumber,
                        value: _globalInfo.appVersion,
                      ),
                      const AppDivider(padding: 0),
                      _buildInfoRow(
                        context,
                        label: L10nUtils.buildNumber,
                        value: _globalInfo.appBuild,
                      ),
                    ],
                  ),
                ),
              ),
              AppGap.hXL,
              // ====== 版本更新提示区域 ======
              _buildUpdateHint(context),
              AppGap.hXL,
              // 版权信息
              AppText.tip('© ${DateTime.now().year} ${_globalInfo.appName}'),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建版本更新提示区域
  Widget _buildUpdateHint(BuildContext context) {
    // 正在检查更新
    if (_isChecking) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
                strokeWidth: 2.w,
              ),
            ),
            AppGap.wSmall,
            AppText.tip(
              L10nUtils.checkingUpdate,
              color: AppColors.textGray(context),
            ),
          ],
        ),
      );
    }

    // 有新版本 - 显示更新提示
    if (_hasUpdate && _latestVersion != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: AppCard(
          showShadow: false,
          bg: AppColors.primary50(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行：新版本标记 + 版本号
              Row(
                children: [
                  // 红点标记
                  const AppDot(),
                  AppGap.wSmall,
                  AppText(
                    L10nUtils.newVersionFound(_latestVersion!.version),
                    size: 28.sp,
                    weight: FontWeight.w500,
                    color: AppColors.primaryDark(context),
                  ),
                ],
              ),
              // 更新内容
              if (_latestVersion!.updateContent != null &&
                  _latestVersion!.updateContent!.isNotEmpty) ...[
                AppGap.hSmall,
                AppText(
                  _latestVersion!.updateContent!,
                  size: 26.sp,
                  maxLines: 5,
                ),
              ],
              AppGap.hNormal,
              // 更新按钮
              AppButton(
                text: L10nUtils.updateNow,
                height: 72.h,
                onTap: _onUpdateTap,
              ),
            ],
          ),
        ),
      );
    }

    // 已是最新版本
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 28.w, color: AppColors.success),
          AppGap.wSmall,
          AppText.tip(L10nUtils.alreadyLatestVersion, color: AppColors.success),
        ],
      ),
    );
  }
}
