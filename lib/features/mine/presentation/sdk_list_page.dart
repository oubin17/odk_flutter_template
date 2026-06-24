import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 第三方SDK列表页面
///
/// 满足国内应用市场（工信部）合规要求：
/// App 内必须展示集成的所有第三方SDK及其数据收集情况。
///
/// **维护说明**：新增/移除依赖后，请同步更新 [_getSdkList] 数据。
class SdkListPage extends StatelessWidget {
  const SdkListPage({super.key});

  /// 第三方SDK清单（⚠️ 新增依赖后请同步更新）
  ///
  /// 字段说明：
  /// - [name] SDK名称
  /// - [provider] 提供方/公司
  /// - [purpose] 用途
  /// - [dataCollected] 收集的数据
  static List<_SdkInfo> _getSdkList() {
    return [
      _SdkInfo(
        name: 'Dio',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkDioPurpose,
        dataCollected: L10nUtils.sdkDioData,
      ),
      _SdkInfo(
        name: 'Provider',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkProviderLibPurpose,
        dataCollected: L10nUtils.sdkDataNone,
      ),
      _SdkInfo(
        name: 'GoRouter',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkGoRouterPurpose,
        dataCollected: L10nUtils.sdkDataNone,
      ),
      _SdkInfo(
        name: 'flutter_secure_storage',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkSecureStoragePurpose,
        dataCollected: L10nUtils.sdkSecureStorageData,
      ),
      _SdkInfo(
        name: 'shared_preferences',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkSharedPrefsPurpose,
        dataCollected: L10nUtils.sdkSharedPrefsData,
      ),
      _SdkInfo(
        name: 'cached_network_image',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkCachedImagePurpose,
        dataCollected: L10nUtils.sdkCachedImageData,
      ),
      _SdkInfo(
        name: 'webview_flutter',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkWebviewPurpose,
        dataCollected: L10nUtils.sdkWebviewData,
      ),
      _SdkInfo(
        name: 'image_picker',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkImagePickerPurpose,
        dataCollected: L10nUtils.sdkImagePickerData,
      ),
      _SdkInfo(
        name: 'permission_handler',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkPermissionHandlerPurpose,
        dataCollected: L10nUtils.sdkDataNone,
      ),
      _SdkInfo(
        name: 'device_info_plus',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkDeviceInfoPurpose,
        dataCollected: L10nUtils.sdkDeviceInfoData,
      ),
      _SdkInfo(
        name: 'package_info_plus',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkPackageInfoPurpose,
        dataCollected: L10nUtils.sdkPackageInfoData,
      ),
      _SdkInfo(
        name: 'connectivity_plus',
        provider: L10nUtils.sdkProviderFlutterOfficial,
        purpose: L10nUtils.sdkConnectivityPurpose,
        dataCollected: L10nUtils.sdkConnectivityData,
      ),
      _SdkInfo(
        name: 'flutter_local_notifications',
        provider: L10nUtils.sdkProviderDartCommunity,
        purpose: L10nUtils.sdkLocalNotificationsPurpose,
        dataCollected: L10nUtils.sdkLocalNotificationsData,
      ),
      _SdkInfo(
        name: 'Bugly（flutter_bugly）',
        provider: L10nUtils.sdkProviderTencent,
        purpose: L10nUtils.sdkBuglyPurpose,
        dataCollected: L10nUtils.sdkBuglyData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.sdkList),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        children: [
          // 页面说明
          AppText.second(L10nUtils.sdkListDesc),
          AppGap.hLarge,

          // SDK列表
          ..._getSdkList().map((sdk) => _buildSdkCard(context, sdk)),
        ],
      ),
    );
  }

  /// 构建单个SDK信息卡片
  Widget _buildSdkCard(BuildContext context, _SdkInfo sdk) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SDK名称
          AppText(
            sdk.name,
            size: 28.sp,
            weight: FontWeight.w600,
            color: AppColors.textMain(context),
          ),
          AppGap.h(8),
          // 提供方
          _buildInfoRow(context, L10nUtils.complianceProvider, sdk.provider),
          AppGap.h(4),
          // 用途
          _buildInfoRow(context, L10nUtils.compliancePurpose, sdk.purpose),
          AppGap.h(4),
          // 收集数据
          _buildInfoRow(
            context,
            L10nUtils.complianceDataCollected,
            sdk.dataCollected,
          ),
        ],
      ),
    );
  }

  /// 构建信息行（标签: 值）
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140.w, child: AppText.tip(label)),
        Expanded(child: AppText.second(value)),
      ],
    );
  }
}

/// SDK信息数据模型
class _SdkInfo {
  final String name;
  final String provider;
  final String purpose;
  final String dataCollected;

  const _SdkInfo({
    required this.name,
    required this.provider,
    required this.purpose,
    required this.dataCollected,
  });
}
