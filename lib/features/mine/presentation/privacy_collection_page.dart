import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 个人信息收集清单页面
///
/// 满足《个人信息保护法》及国内应用市场合规要求：
/// App 内必须明示收集了哪些个人信息、收集目的、处理方式。
///
/// **维护说明**：新增个人信息收集场景后，请同步更新 [_getCollectionList] 数据。
class PrivacyCollectionPage extends StatelessWidget {
  const PrivacyCollectionPage({super.key});

  /// 个人信息收集清单（⚠️ 新增收集场景后请同步更新）
  static List<_CollectionInfo> _getCollectionList() {
    return [
      _CollectionInfo(
        infoType: L10nUtils.privacyPhoneInfoType,
        purpose: L10nUtils.privacyPhonePurpose,
        processingMethod: L10nUtils.privacyPhoneMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyPasswordInfoType,
        purpose: L10nUtils.privacyPasswordPurpose,
        processingMethod: L10nUtils.privacyPasswordMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyNicknameInfoType,
        purpose: L10nUtils.privacyNicknamePurpose,
        processingMethod: L10nUtils.privacyNicknameMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyAvatarInfoType,
        purpose: L10nUtils.privacyAvatarPurpose,
        processingMethod: L10nUtils.privacyAvatarMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyGenderInfoType,
        purpose: L10nUtils.privacyGenderPurpose,
        processingMethod: L10nUtils.privacyGenderMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyBirthdayInfoType,
        purpose: L10nUtils.privacyBirthdayPurpose,
        processingMethod: L10nUtils.privacyBirthdayMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyDeviceIdInfoType,
        purpose: L10nUtils.privacyDeviceIdPurpose,
        processingMethod: L10nUtils.privacyDeviceIdMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyDeviceInfoInfoType,
        purpose: L10nUtils.privacyDeviceInfoPurpose,
        processingMethod: L10nUtils.privacyDeviceInfoMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyAppVersionInfoType,
        purpose: L10nUtils.privacyAppVersionPurpose,
        processingMethod: L10nUtils.privacyAppVersionMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyNetworkStatusInfoType,
        purpose: L10nUtils.privacyNetworkStatusPurpose,
        processingMethod: L10nUtils.privacyNetworkStatusMethod,
      ),
      _CollectionInfo(
        infoType: L10nUtils.privacyCrashLogInfoType,
        purpose: L10nUtils.privacyCrashLogPurpose,
        processingMethod: L10nUtils.privacyCrashLogMethod,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.privacyCollection),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        children: [
          // 页面说明
          AppText.second(L10nUtils.privacyCollectionDesc),
          AppGap.hLarge,

          // 收集清单
          ..._getCollectionList().map(
            (item) => _buildCollectionCard(context, item),
          ),
        ],
      ),
    );
  }

  /// 构建单个信息收集卡片
  Widget _buildCollectionCard(BuildContext context, _CollectionInfo item) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 信息类型
          AppText(
            item.infoType,
            size: 28.sp,
            weight: FontWeight.w600,
            color: AppColors.textMain(context),
          ),
          AppGap.h(8),
          // 收集目的
          _buildInfoRow(
            context,
            L10nUtils.complianceCollectionPurpose,
            item.purpose,
          ),
          AppGap.h(4),
          // 处理方式
          _buildInfoRow(
            context,
            L10nUtils.complianceProcessingMethod,
            item.processingMethod,
          ),
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

/// 个人信息收集项数据模型
class _CollectionInfo {
  final String infoType;
  final String purpose;
  final String processingMethod;

  const _CollectionInfo({
    required this.infoType,
    required this.purpose,
    required this.processingMethod,
  });
}
