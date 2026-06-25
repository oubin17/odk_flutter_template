import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 权限使用说明页面
///
/// 满足国内应用市场合规要求：
/// App 内必须说明各权限的用途和使用场景，配合权限声明使用。
///
/// **维护说明**：新增/移除权限后，请同步更新 [_getPermissionList] 及
/// AndroidManifest.xml / Info.plist 中的权限声明。
class PermissionInfoPage extends StatelessWidget {
  const PermissionInfoPage({super.key});

  /// 权限使用清单（⚠️ 新增权限后请同步更新）
  static List<_PermissionInfo> _getPermissionList() {
    return [
      _PermissionInfo(
        name: L10nUtils.permCameraName,
        purpose: L10nUtils.permCameraPurpose,
        scenario: L10nUtils.permCameraScenario,
        isRequired: false,
      ),
      _PermissionInfo(
        name: L10nUtils.permAlbumName,
        purpose: L10nUtils.permAlbumPurpose,
        scenario: L10nUtils.permAlbumScenario,
        isRequired: false,
      ),
      _PermissionInfo(
        name: L10nUtils.permNotificationName,
        purpose: L10nUtils.permNotificationPurpose,
        scenario: L10nUtils.permNotificationScenario,
        isRequired: false,
      ),
      _PermissionInfo(
        name: L10nUtils.permNetworkName,
        purpose: L10nUtils.permNetworkPurpose,
        scenario: L10nUtils.permNetworkScenario,
        isRequired: true,
      ),
      _PermissionInfo(
        name: L10nUtils.permPhoneStateName,
        purpose: L10nUtils.permPhoneStatePurpose,
        scenario: L10nUtils.permPhoneStateScenario,
        isRequired: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.permissionInfo),
      body: ListView(
        padding: AppGap.formPadding,
        children: [
          // 页面说明
          AppText.second(L10nUtils.permissionInfoDesc),
          AppGap.hLarge,

          // 权限列表
          ..._getPermissionList().map(
            (perm) => _buildPermissionCard(context, perm),
          ),
        ],
      ),
    );
  }

  /// 构建单个权限信息卡片
  Widget _buildPermissionCard(BuildContext context, _PermissionInfo perm) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 权限名称 + 必要标签
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppText(
                  perm.name,
                  size: 28.sp,
                  weight: FontWeight.w600,
                  color: AppColors.textMain(context),
                ),
              ),
              if (perm.isRequired) ...[
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight(context),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AppText(
                    L10nUtils.complianceRequired,
                    size: 20.sp,
                    color: AppColors.primary(context),
                  ),
                ),
              ],
            ],
          ),
          AppGap.h(8),
          // 用途
          _buildInfoRow(context, L10nUtils.compliancePurpose, perm.purpose),
          AppGap.h(4),
          // 使用场景
          _buildInfoRow(context, L10nUtils.complianceScenario, perm.scenario),
        ],
      ),
    );
  }

  /// 构建信息行
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

/// 权限信息数据模型
class _PermissionInfo {
  final String name;
  final String purpose;
  final String scenario;
  final bool isRequired;

  const _PermissionInfo({
    required this.name,
    required this.purpose,
    required this.scenario,
    required this.isRequired,
  });
}
